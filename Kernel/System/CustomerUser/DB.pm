# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CustomerUser::DB;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use Crypt::PasswdMD5 qw(unix_md5_crypt apache_md5_crypt);
use Digest::SHA;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::Cache',
    'Kernel::System::CheckItem',
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Valid',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::DynamicFieldValueObjectName',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed data
    for my $Needed (qw( PreferencesObject CustomerUserMap )) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # get database object
    $Self->{DBObject} = $Kernel::OM->Get('Kernel::System::DB');

    # max shown user per search list
    $Self->{UserSearchListLimit} = $Self->{CustomerUserMap}->{CustomerUserSearchListLimit} || 250;

    # config options
    $Self->{CustomerTable} = $Self->{CustomerUserMap}->{Params}->{Table}
        || die "Need CustomerUser->Params->Table in Kernel/Config.pm!";
    $Self->{CustomerKey} = $Self->{CustomerUserMap}->{CustomerKey}
        || $Self->{CustomerUserMap}->{Key}
        || die "Need CustomerUser->CustomerKey in Kernel/Config.pm!";
    $Self->{CustomerID} = $Self->{CustomerUserMap}->{CustomerID}
        || die "Need CustomerUser->CustomerID in Kernel/Config.pm!";
    $Self->{ReadOnly}                 = $Self->{CustomerUserMap}->{ReadOnly};
    $Self->{ExcludePrimaryCustomerID} = $Self->{CustomerUserMap}->{CustomerUserExcludePrimaryCustomerID} || 0;
    $Self->{SearchPrefix}             = $Self->{CustomerUserMap}->{CustomerUserSearchPrefix};

    if ( !defined $Self->{SearchPrefix} ) {
        $Self->{SearchPrefix} = '';
    }
    $Self->{SearchSuffix} = $Self->{CustomerUserMap}->{CustomerUserSearchSuffix};
    if ( !defined $Self->{SearchSuffix} ) {
        $Self->{SearchSuffix} = '*';
    }

    # check if CustomerKey is var or int
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[0] eq 'UserLogin' && $Entry->[5] =~ /^int$/i ) {
            $Self->{CustomerKeyInteger} = 1;
            last ENTRY;
        }
    }

    # set cache type
    $Self->{CacheType} = 'CustomerUser' . $Param{Count};

    # create cache object, but only if CacheTTL is set in customer config
    if ( $Self->{CustomerUserMap}->{CacheTTL} ) {
        $Self->{CacheObject} = $Kernel::OM->Get('Kernel::System::Cache');
    }

    # create new db connect if DSN is given
    if ( $Self->{CustomerUserMap}->{Params}->{DSN} ) {
        $Self->{DBObject} = Kernel::System::DB->new(
            DatabaseDSN  => $Self->{CustomerUserMap}->{Params}->{DSN},
            DatabaseUser => $Self->{CustomerUserMap}->{Params}->{User},
            DatabasePw   => $Self->{CustomerUserMap}->{Params}->{Password},
            %{ $Self->{CustomerUserMap}->{Params} },
        ) || die('Can\'t connect to database!');

        # remember that we have the DBObject not from parent call
        $Self->{NotParentDBObject} = 1;
    }

    # this setting specifies if the table has the create_time,
    # create_by, change_time and change_by fields of OTRS
    $Self->{ForeignDB} = $Self->{CustomerUserMap}->{Params}->{ForeignDB} ? 1 : 0;

    # defines if the database search will be performend case sensitive (1) or not (0)
    $Self->{CaseSensitive} = $Self->{CustomerUserMap}->{Params}->{SearchCaseSensitive}
        // $Self->{CustomerUserMap}->{Params}->{CaseSensitive} || 0;

    # fetch names of configured dynamic fields
    my @DynamicFieldMapEntries = grep { $_->[5] eq 'dynamic_field' } @{ $Self->{CustomerUserMap}->{Map} };
    $Self->{ConfiguredDynamicFieldNames} = { map { $_->[2] => 1 } @DynamicFieldMapEntries };

    return $Self;
}

sub CustomerName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserLogin!',
        );
        return;
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Name = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "CustomerName::$Param{UserLogin}",
        );
        return $Name if defined $Name;
    }

    my $CustomerUserNameFields = $Self->{CustomerUserMap}->{CustomerUserNameFields};
    if ( !IsArrayRefWithData($CustomerUserNameFields) ) {
        $CustomerUserNameFields = [ 'first_name', 'last_name', ];
    }

    # remove dynamic field names that are configured in CustomerUserNameFields
    # as they cannot be handled here
    my @CustomerUserNameFieldsWithoutDynamicFields
        = grep { !exists $Self->{ConfiguredDynamicFieldNames}->{$_} } @{$CustomerUserNameFields};

    # build SQL string 1/2
    my $SQL = "SELECT ";

    $SQL .= join( ", ", @CustomerUserNameFieldsWithoutDynamicFields );
    $SQL .= " FROM $Self->{CustomerTable} WHERE ";

    # check CustomerKey type
    my $UserLogin = $Param{UserLogin};
    if ( $Self->{CaseSensitive} ) {
        $SQL .= "$Self->{CustomerKey} = ?";
    }
    else {
        $SQL .= "LOWER($Self->{CustomerKey}) = LOWER(?)";
    }

    my %NameParts;

    # get data from customer user table
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => [ \$Param{UserLogin} ],
        Limit => 1,
    );

    my $FieldCounter = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        for my $Field (@Row) {
            $NameParts{ $CustomerUserNameFieldsWithoutDynamicFields[$FieldCounter] } = $Field;
            $FieldCounter++;
        }
    }

    # fetch dynamic field values, if configured
    my @DynamicFieldCustomerUserNameFields
        = grep { exists $Self->{ConfiguredDynamicFieldNames}->{$_} } @{$CustomerUserNameFields};
    if (@DynamicFieldCustomerUserNameFields) {
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        DYNAMICFIELDNAME:
        for my $DynamicFieldName (@DynamicFieldCustomerUserNameFields) {
            my $DynamicFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                Name => $DynamicFieldName,
            );
            next DYNAMICFIELDNAME if !IsHashRefWithData($DynamicFieldConfig);

            my $Value = $DynamicFieldBackendObject->ValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectName         => $Param{UserLogin},
            );

            next DYNAMICFIELDNAME if !defined $Value;

            if ( !IsArrayRefWithData($Value) ) {
                $Value = [$Value];
            }

            my @RenderedValues;

            VALUE:
            for my $CurrentValue ( @{$Value} ) {
                next VALUE if !defined $CurrentValue || !length $CurrentValue;

                my $RenderedValue = $DynamicFieldBackendObject->ReadableValueRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $CurrentValue,
                );

                next VALUE if !IsHashRefWithData($RenderedValue) || !defined $RenderedValue->{Value};

                push @RenderedValues, $RenderedValue->{Value};
            }

            $NameParts{$DynamicFieldName} = join ' ', @RenderedValues;
        }
    }

    # assemble name
    my @NameParts;
    CUSTOMERUSERNAMEFIELD:
    for my $CustomerUserNameField ( @{$CustomerUserNameFields} ) {
        next CUSTOMERUSERNAMEFIELD
            if !exists $NameParts{$CustomerUserNameField}
            || !defined $NameParts{$CustomerUserNameField}
            || !length $NameParts{$CustomerUserNameField};
        push @NameParts, $NameParts{$CustomerUserNameField};
    }

    my $JoinCharacter = $Self->{CustomerUserMap}->{CustomerUserNameFieldsJoin} // ' ';
    my $Name          = join $JoinCharacter, @NameParts;

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => "CustomerName::$Param{UserLogin}",
            Value => $Name,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }
    return $Name;
}

sub CustomerSearch {
    my ( $Self, %Param ) = @_;

    my %Users;
    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;

    # check needed stuff
    if (
        !$Param{Search}
        && !$Param{UserLogin}
        && !$Param{PostMasterSearch}
        && !$Param{CustomerID}
        && !$Param{CustomerIDRaw}
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Search, UserLogin, PostMasterSearch, CustomerIDRaw or CustomerID!',
        );
        return;
    }

    # check cache
    my $CacheKey = join '::', map { $_ . '=' . $Param{$_} } sort keys %Param;

    if ( $Self->{CacheObject} ) {
        my $Users = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType} . '_CustomerSearch',
            Key  => $CacheKey,
        );
        return %{$Users} if ref $Users eq 'HASH';
    }

    my $CustomerUserListFields = $Self->{CustomerUserMap}->{CustomerUserListFields};
    if ( !IsArrayRefWithData($CustomerUserListFields) ) {
        $CustomerUserListFields = [ 'first_name', 'last_name', 'email', ];
    }

    # remove dynamic field names that are configured in CustomerUserListFields
    # as they cannot be handled here
    my @CustomerUserListFieldsWithoutDynamicFields
        = grep { !exists $Self->{ConfiguredDynamicFieldNames}->{$_} } @{$CustomerUserListFields};

    # build SQL string 1/2
    my $SQL = "SELECT $Self->{CustomerKey} ";
    my @Bind;
    $SQL .= ', ' . ( join ', ', @CustomerUserListFieldsWithoutDynamicFields );

    # get like escape string needed for some databases (e.g. oracle)
    my $LikeEscapeString = $Self->{DBObject}->GetDatabaseFunction('LikeEscapeString');

    # build SQL string 2/2
    $SQL .= " FROM $Self->{CustomerTable} WHERE ";
    if ( $Param{Search} ) {
        if ( !$Self->{CustomerUserMap}->{CustomerUserSearchFields} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Need CustomerUserSearchFields in CustomerUser config, unable to search for '$Param{Search}'!",
            );
            return;
        }

        my $Search = $Self->{DBObject}->QueryStringEscape( QueryString => $Param{Search} );

        # remove dynamic field names that are configured in CustomerUserSearchFields
        # as they cannot be retrieved here
        my @CustomerUserSearchFields = grep { !exists $Self->{ConfiguredDynamicFieldNames}->{$_} }
            @{ $Self->{CustomerUserMap}->{CustomerUserSearchFields} };

        if ( $Param{CustomerUserOnly} ) {
            @CustomerUserSearchFields = grep { $_ ne 'customer_id' } @CustomerUserSearchFields;
        }

        my %QueryCondition = $Self->{DBObject}->QueryCondition(
            Key           => \@CustomerUserSearchFields,    #$Self->{CustomerUserMap}->{CustomerUserSearchFields},
            Value         => $Search,
            SearchPrefix  => $Self->{SearchPrefix},
            SearchSuffix  => $Self->{SearchSuffix},
            CaseSensitive => $Self->{CaseSensitive},
            BindMode      => 1,
        );

        $SQL .= $QueryCondition{SQL};
        push @Bind, @{ $QueryCondition{Values} };

        $SQL .= ' ';
    }
    elsif ( $Param{PostMasterSearch} ) {
        if ( $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} ) {

            # remove dynamic field names that are configured in CustomerUserPostMasterSearchFields
            # as they cannot be retrieved here
            my @CustomerUserPostMasterSearchFields = grep { !exists $Self->{ConfiguredDynamicFieldNames}->{$_} }
                @{ $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} };

            my $SQLExt = '';

            # for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} } ) {
            for my $Field (@CustomerUserPostMasterSearchFields) {
                if ($SQLExt) {
                    $SQLExt .= ' OR ';
                }
                my $PostMasterSearch = $Self->{DBObject}->Quote( $Param{PostMasterSearch} );
                push @Bind, \$PostMasterSearch;

                if ( $Self->{CaseSensitive} ) {
                    $SQLExt .= " $Field = ? ";
                }
                else {
                    $SQLExt .= " LOWER($Field) = LOWER(?) ";
                }
            }
            $SQL .= $SQLExt;
        }
    }
    elsif ( $Param{UserLogin} ) {

        my $UserLogin = $Param{UserLogin};

        # check CustomerKey type
        if ( $Self->{CustomerKeyInteger} ) {

            # return if login is no integer
            return if $Param{UserLogin} !~ /^(\+|\-|)\d{1,16}$/;

            $SQL .= "$Self->{CustomerKey} = ?";
            push @Bind, \$UserLogin;
        }
        else {
            $UserLogin = '%' . $Self->{DBObject}->Quote( $UserLogin, 'Like' ) . '%';
            $UserLogin =~ s/\*/%/g;
            push @Bind, \$UserLogin;
            if ( $Self->{CaseSensitive} ) {
                $SQL .= "$Self->{CustomerKey} LIKE ? $LikeEscapeString";
            }
            else {
                $SQL .= "LOWER($Self->{CustomerKey}) LIKE LOWER(?) $LikeEscapeString";
            }
        }
    }
    elsif ( $Param{CustomerID} ) {

        my $CustomerID = $Self->{DBObject}->Quote( $Param{CustomerID}, 'Like' );
        $CustomerID =~ s/\*/%/g;
        push @Bind, \$CustomerID;

        if ( $Self->{CaseSensitive} ) {
            $SQL .= "$Self->{CustomerID} LIKE ? $LikeEscapeString";
        }
        else {
            $SQL .= "LOWER($Self->{CustomerID}) LIKE LOWER(?) $LikeEscapeString";
        }
    }
    elsif ( $Param{CustomerIDRaw} ) {

        push @Bind, \$Param{CustomerIDRaw};

        if ( $Self->{CaseSensitive} ) {
            $SQL .= "$Self->{CustomerID} = ? ";
        }
        else {
            $SQL .= "LOWER($Self->{CustomerID}) = LOWER(?) ";
        }
    }

    # add valid option
    if ( $Self->{CustomerUserMap}->{CustomerValid} && $Valid ) {

        # get valid object
        my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

        $SQL .= ' AND '
            . $Self->{CustomerUserMap}->{CustomerValid}
            . ' IN (' . join( ', ', $ValidObject->ValidIDsGet() ) . ') ';
    }

    # dynamic field handling
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $DynamicFieldConfigs = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'CustomerUser',
        Valid      => 1,
    );
    my %DynamicFieldConfigsByName = map { $_->{Name} => $_ } @{$DynamicFieldConfigs};

    my @CustomerUserListFieldsDynamicFields
        = grep { exists $Self->{ConfiguredDynamicFieldNames}->{$_} } @{$CustomerUserListFields};

    # get data from customer user table
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => $Param{Limit} || $Self->{UserSearchListLimit},
    );

    my @CustomerUserData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @CustomerUserData, [@Row];
    }

    CUSTOMERUSERDATA:
    for my $CustomerUserData (@CustomerUserData) {
        my $CustomerKey = shift @{$CustomerUserData};
        next CUSTOMERUSERDATA if $Users{$CustomerKey};

        my %UserStringParts;

        my $FieldCounter = 0;
        for my $Field ( @{$CustomerUserData} ) {
            $UserStringParts{ $CustomerUserListFieldsWithoutDynamicFields[$FieldCounter] } = $Field;
            $FieldCounter++;
        }

        # fetch dynamic field values, if configured
        if (@CustomerUserListFieldsDynamicFields) {
            DYNAMICFIELDNAME:
            for my $DynamicFieldName (@CustomerUserListFieldsDynamicFields) {
                next DYNAMICFIELDNAME if !exists $DynamicFieldConfigsByName{$DynamicFieldName};

                my $Value = $DynamicFieldBackendObject->ValueGet(
                    DynamicFieldConfig => $DynamicFieldConfigsByName{$DynamicFieldName},
                    ObjectName         => $CustomerKey,
                );

                next DYNAMICFIELDNAME if !defined $Value;

                if ( !IsArrayRefWithData($Value) ) {
                    $Value = [$Value];
                }

                my @Values;

                VALUE:
                for my $CurrentValue ( @{$Value} ) {
                    next VALUE if !defined $CurrentValue || !length $CurrentValue;

                    my $ReadableValue = $DynamicFieldBackendObject->ReadableValueRender(
                        DynamicFieldConfig => $DynamicFieldConfigsByName{$DynamicFieldName},
                        Value              => $CurrentValue,
                    );

                    next VALUE if !IsHashRefWithData($ReadableValue) || !defined $ReadableValue->{Value};

                    my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
                        DynamicFieldConfig => $DynamicFieldConfigsByName{$DynamicFieldName},
                        Behavior           => 'IsACLReducible',
                    );
                    if ($IsACLReducible) {
                        my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                            DynamicFieldConfig => $DynamicFieldConfigsByName{$DynamicFieldName},
                        );

                        if (
                            IsHashRefWithData($PossibleValues)
                            && defined $PossibleValues->{ $ReadableValue->{Value} }
                            )
                        {
                            $ReadableValue->{Value} = $PossibleValues->{ $ReadableValue->{Value} };
                        }
                    }

                    push @Values, $ReadableValue->{Value};
                }

                $UserStringParts{$DynamicFieldName} = join ' ', @Values;
            }
        }

        # assemble user string
        my @UserStringParts;
        CUSTOMERUSERLISTFIELD:
        for my $CustomerUserListField ( @{$CustomerUserListFields} ) {
            next CUSTOMERUSERLISTFIELD
                if !exists $UserStringParts{$CustomerUserListField}
                || !defined $UserStringParts{$CustomerUserListField}
                || !length $UserStringParts{$CustomerUserListField};
            push @UserStringParts, $UserStringParts{$CustomerUserListField};
        }

        $Users{$CustomerKey} = join ' ', @UserStringParts;
        $Users{$CustomerKey} =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType} . '_CustomerSearch',
            Key   => $CacheKey,
            Value => \%Users,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }
    return %Users;
}

sub CustomerSearchDetail {
    my ( $Self, %Param ) = @_;

    if ( ref $Param{SearchFields} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "SearchFields must be an array reference!",
        );
        return;
    }

    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;

    $Param{Limit} //= '';

    # Split the search fields in scalar and array fields, before the diffrent handling.
    my @ScalarSearchFields = grep { 'Input' eq $_->{Type} } @{ $Param{SearchFields} };
    my @ArraySearchFields  = grep { 'Selection' eq $_->{Type} } @{ $Param{SearchFields} };

    # Verify that all passed array parameters contain an arrayref.
    ARGUMENT:
    for my $Argument (@ArraySearchFields) {
        if ( !defined $Param{ $Argument->{Name} } ) {
            $Param{ $Argument->{Name} } ||= [];

            next ARGUMENT;
        }

        if ( ref $Param{ $Argument->{Name} } ne 'ARRAY' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Argument->{Name} must be an array reference!",
            );
            return;
        }
    }

    # Set the default behaviour for the return type.
    my $Result = $Param{Result} || 'ARRAY';

    # Special handling if the result type is 'COUNT'.
    if ( $Result eq 'COUNT' ) {

        # Ignore the parameter 'Limit' when result type is 'COUNT'.
        $Param{Limit} = '';

        # Delete the OrderBy parameter when the result type is 'COUNT'.
        $Param{OrderBy} = [];
    }

    # Define order table from the search fields.
    my %OrderByTable = map { $_->{Name} => $_->{DatabaseField} } @{ $Param{SearchFields} };

    for my $Field (@ArraySearchFields) {

        my $SelectionsData = $Field->{SelectionsData};

        for my $SelectedValue ( @{ $Param{ $Field->{Name} } } ) {

            # Check if the selected value for the current field is valid.
            if ( !$SelectionsData->{$SelectedValue} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "The selected value $Field->{Name} is not valid!",
                );
                return;
            }
        }
    }

    my $DBObject = $Self->{DBObject};

    # Assemble the conditions used in the WHERE clause.
    my @SQLWhere;

    for my $Field (@ScalarSearchFields) {

        # Search for scalar fields (wildcards are allowed).
        if ( $Param{ $Field->{Name} } ) {

            # Get like escape string needed for some databases (e.g. oracle).
            my $LikeEscapeString = $DBObject->GetDatabaseFunction('LikeEscapeString');

            $Param{ $Field->{Name} } = $DBObject->Quote( $Param{ $Field->{Name} }, 'Like' );

            $Param{ $Field->{Name} } =~ s{ \*+ }{%}xmsg;

            # If the field contains more than only %.
            if ( $Param{ $Field->{Name} } !~ m{ \A %* \z }xms ) {
                push @SQLWhere,
                    "LOWER($Field->{DatabaseField}) LIKE LOWER('$Param{ $Field->{Name} }') $LikeEscapeString";
            }
        }
    }

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # Check all configured change dynamic fields, build lookup hash by name.
    my %CustomerUserDynamicFieldName2Config;
    my $CustomerUserDynamicFields = $DynamicFieldObject->DynamicFieldListGet(
        ObjectType => 'CustomerUser',
    );
    for my $DynamicField ( @{$CustomerUserDynamicFields} ) {
        $CustomerUserDynamicFieldName2Config{ $DynamicField->{Name} } = $DynamicField;
    }

    my $SQLDynamicFieldFrom     = '';
    my $SQLDynamicFieldWhere    = '';
    my $DynamicFieldJoinCounter = 1;

    DYNAMICFIELD:
    for my $DynamicField ( @{$CustomerUserDynamicFields} ) {

        my $SearchParam = $Param{ "DynamicField_" . $DynamicField->{Name} };

        next DYNAMICFIELD if ( !$SearchParam );
        next DYNAMICFIELD if ( ref $SearchParam ne 'HASH' );

        my $NeedJoin;

        for my $Operator ( sort keys %{$SearchParam} ) {

            my @SearchParams = ( ref $SearchParam->{$Operator} eq 'ARRAY' )
                ? @{ $SearchParam->{$Operator} }
                : ( $SearchParam->{$Operator} );

            my $SQLDynamicFieldWhereSub = '';
            if ($SQLDynamicFieldWhere) {
                $SQLDynamicFieldWhereSub = ' AND (';
            }
            else {
                $SQLDynamicFieldWhereSub = ' (';
            }

            my $Counter = 0;
            TEXT:
            for my $Text (@SearchParams) {
                next TEXT if ( !defined $Text || $Text eq '' );

                $Text =~ s/\*/%/gi;

                # Check search attribute, we do not need to search for '*'.
                next TEXT if $Text =~ /^\%{1,3}$/;

                my $ValidateSuccess = $DynamicFieldBackendObject->ValueValidate(
                    DynamicFieldConfig => $DynamicField,
                    Value              => $Text,
                    UserID             => $Param{UserID} || 1,
                );
                if ( !$ValidateSuccess ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Search not executed due to invalid value '"
                            . $Text
                            . "' on field '"
                            . $DynamicField->{Name} . "'!",
                    );
                    return;
                }

                if ($Counter) {
                    $SQLDynamicFieldWhereSub .= ' OR ';
                }
                $SQLDynamicFieldWhereSub .= $DynamicFieldBackendObject->SearchSQLGet(
                    DynamicFieldConfig => $DynamicField,
                    TableAlias         => "dfv$DynamicFieldJoinCounter",
                    Operator           => $Operator,
                    SearchTerm         => $Text,
                );

                $Counter++;
            }
            $SQLDynamicFieldWhereSub .= ') ';

            if ($Counter) {
                $SQLDynamicFieldWhere .= $SQLDynamicFieldWhereSub;
                $NeedJoin = 1;
            }
        }

        if ($NeedJoin) {
            $SQLDynamicFieldFrom .= "
                INNER JOIN dynamic_field_value dfv$DynamicFieldJoinCounter
                    ON (df_obj_id_name.object_id = dfv$DynamicFieldJoinCounter.object_id
                        AND dfv$DynamicFieldJoinCounter.field_id = "
                . $DBObject->Quote( $DynamicField->{ID}, 'Integer' ) . ")
            ";

            $DynamicFieldJoinCounter++;
        }
    }

    # Execute a dynamic field search, if a dynamic field where statement exists.
    if ($SQLDynamicFieldWhere) {

        my @DynamicFieldUserLogins;

        my $SQLDynamicField
            = "SELECT DISTINCT(df_obj_id_name.object_name) FROM dynamic_field_obj_id_name df_obj_id_name "
            . $SQLDynamicFieldFrom
            . " WHERE "
            . $SQLDynamicFieldWhere;

        my $UsedCache;

        if ( $Self->{CacheObject} ) {

            my $DynamicFieldSearchCacheData = $Self->{CacheObject}->Get(
                Type => $Self->{CacheType} . '_CustomerSearchDetailDynamicFields',
                Key  => $SQLDynamicField,
            );

            if ( defined $DynamicFieldSearchCacheData ) {
                if ( ref $DynamicFieldSearchCacheData eq 'ARRAY' ) {
                    @DynamicFieldUserLogins = @{$DynamicFieldSearchCacheData};

                    $UsedCache = 1;
                }
                else {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => 'Invalid ref ' . ref($DynamicFieldSearchCacheData) . '!'
                    );
                    return;
                }
            }
        }

        # Get the data only from database, if no cache entry exists.
        if ( !$UsedCache ) {

            return if !$DBObject->Prepare(
                SQL => $SQLDynamicField,
            );

            while ( my @Row = $DBObject->FetchrowArray() ) {
                push @DynamicFieldUserLogins, $Row[0];
            }

            if ( $Self->{CacheObject} ) {
                $Self->{CacheObject}->Set(
                    Type  => $Self->{CacheType} . '_CustomerSearchDetailDynamicFields',
                    Key   => $SQLDynamicField,
                    Value => \@DynamicFieldUserLogins,
                    TTL   => $Self->{CustomerUserMap}->{CacheTTL},
                );
            }
        }

        # Add the user logins from the dynamic fields, if a search result exists from the dynamic field search
        #   or skip the search and return a emptry array ref, if no user logins exists from the dynamic field search.
        if (@DynamicFieldUserLogins) {

            my $SQLQueryInCondition = $DBObject->QueryInCondition(
                Key      => $Self->{CustomerKey},
                Values   => \@DynamicFieldUserLogins,
                BindMode => 0,
            );

            push @SQLWhere, $SQLQueryInCondition;
        }
        else {
            return $Result eq 'COUNT' ? 0 : [];
        }
    }

    FIELD:
    for my $Field (@ArraySearchFields) {

        next FIELD if !@{ $Param{ $Field->{Name} } };

        my $SQLQueryInCondition = $DBObject->QueryInCondition(
            Key      => $Field->{DatabaseField},
            Values   => $Param{ $Field->{Name} },
            BindMode => 0,
        );

        push @SQLWhere, $SQLQueryInCondition;
    }

    # Special parameter for CustomerIDs from a customer company search result.
    if ( IsArrayRefWithData( $Param{CustomerCompanySearchCustomerIDs} ) ) {

        my $SQLQueryInCondition = $DBObject->QueryInCondition(
            Key      => $Self->{CustomerID},
            Values   => $Param{CustomerCompanySearchCustomerIDs},
            BindMode => 0,
        );

        push @SQLWhere, $SQLQueryInCondition;
    }

    # Special parameter to exclude some user logins from the search result.
    if ( IsArrayRefWithData( $Param{ExcludeUserLogins} ) ) {

        my $SQLQueryInCondition = $DBObject->QueryInCondition(
            Key      => $Self->{CustomerKey},
            Values   => $Param{ExcludeUserLogins},
            BindMode => 0,
            Negate   => 1,
        );

        push @SQLWhere, $SQLQueryInCondition;
    }

    # Add the valid option if needed.
    if ( $Self->{CustomerUserMap}->{CustomerValid} && $Valid ) {

        my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

        push @SQLWhere,
            "$Self->{CustomerUserMap}->{CustomerValid} IN (" . join( ', ', $ValidObject->ValidIDsGet() ) . ") ";
    }

    # Check if OrderBy contains only unique valid values.
    my %OrderBySeen;
    for my $OrderBy ( @{ $Param{OrderBy} } ) {

        if ( !$OrderBy || $OrderBySeen{$OrderBy} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "OrderBy contains invalid value '$OrderBy' or the value is used more than once!",
            );
            return;
        }

        # Remember the value to check if it appears more than once.
        $OrderBySeen{$OrderBy} = 1;
    }

    # Check if OrderByDirection array contains only 'Up' or 'Down'.
    DIRECTION:
    for my $Direction ( @{ $Param{OrderByDirection} } ) {

        # Only 'Up' or 'Down' allowed.
        next DIRECTION if $Direction eq 'Up';
        next DIRECTION if $Direction eq 'Down';

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "OrderByDirection can only contain 'Up' or 'Down'!",
        );
        return;
    }

    # Build the sql statement for the search.
    my $SQL = "SELECT DISTINCT($Self->{CustomerKey})";

    # Modify SQL when the result type is 'COUNT'.
    if ( $Result eq 'COUNT' ) {
        $SQL = "SELECT COUNT(DISTINCT($Self->{CustomerKey}))";
    }

    # Assemble the ORDER BY clause.
    my @SQLOrderBy;

    # The Order by clause is not needed for the result type 'COUNT'.
    if ( $Result ne 'COUNT' ) {

        my $Count = 0;

        ORDERBY:
        for my $OrderBy ( @{ $Param{OrderBy} } ) {

            my $Direction = 'DESC';

            if ( $Param{OrderByDirection}->[$Count] ) {
                if ( $Param{OrderByDirection}->[$Count] eq 'Up' ) {
                    $Direction = 'ASC';
                }
                elsif ( $Param{OrderByDirection}->[$Count] eq 'Down' ) {
                    $Direction = 'DESC';
                }
            }

            $Count++;

            next ORDERBY if !$OrderByTable{$OrderBy};

            push @SQLOrderBy, "$OrderByTable{$OrderBy} $Direction";

            next ORDERBY if $OrderBy eq 'UserLogin';

            $SQL .= ", $OrderByTable{$OrderBy}";
        }

        # If there is a possibility that the ordering is not determined
        #   we add an descending ordering by id.
        if ( !grep { $_ eq 'UserLogin' } ( @{ $Param{OrderBy} } ) ) {
            push @SQLOrderBy, "$Self->{CustomerKey} DESC";
        }
    }

    $SQL .= " FROM $Self->{CustomerTable} ";

    if (@SQLWhere) {
        my $SQLWhereString = join ' AND ', map {"( $_ )"} @SQLWhere;
        $SQL .= "WHERE $SQLWhereString ";
    }
    if (@SQLOrderBy) {
        my $OrderByString = join ', ', @SQLOrderBy;
        $SQL .= "ORDER BY $OrderByString";
    }

    # Check if a cache exists before we ask the database.
    if ( $Self->{CacheObject} ) {

        my $CacheData = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType} . '_CustomerSearchDetail',
            Key  => $SQL . $Param{Limit},
        );

        if ( defined $CacheData ) {
            if ( ref $CacheData eq 'ARRAY' ) {
                return $CacheData;
            }
            elsif ( ref $CacheData eq '' ) {
                return $CacheData;
            }
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Invalid ref ' . ref($CacheData) . '!'
            );
            return;
        }
    }

    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Limit => $Param{Limit},
    );

    my @IDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @IDs, $Row[0];
    }

    # Handle the diffrent result types.
    if ( $Result eq 'COUNT' ) {

        if ( $Self->{CacheObject} ) {
            $Self->{CacheObject}->Set(
                Type  => $Self->{CacheType} . '_CustomerSearchDetail',
                Key   => $SQL . $Param{Limit},
                Value => $IDs[0],
                TTL   => $Self->{CustomerUserMap}->{CacheTTL},
            );
        }

        return $IDs[0];
    }
    else {

        if ( $Self->{CacheObject} ) {
            $Self->{CacheObject}->Set(
                Type  => $Self->{CacheType} . '_CustomerSearchDetail',
                Key   => $SQL . $Param{Limit},
                Value => \@IDs,
                TTL   => $Self->{CustomerUserMap}->{CacheTTL},
            );
        }

        return \@IDs;
    }
}

sub CustomerIDList {
    my ( $Self, %Param ) = @_;

    my $Valid      = defined $Param{Valid} ? $Param{Valid} : 1;
    my $SearchTerm = $Param{SearchTerm} || '';

    my $CacheType = $Self->{CacheType} . '_CustomerIDList';
    my $CacheKey  = "CustomerIDList::${Valid}::$SearchTerm";

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Result = $Self->{CacheObject}->Get(
            Type => $CacheType,
            Key  => $CacheKey,
        );
        return @{$Result} if ref $Result eq 'ARRAY';
    }

    my $SQL = "
        SELECT DISTINCT($Self->{CustomerID})
        FROM $Self->{CustomerTable}
        WHERE 1 = 1 ";
    my @Bind;

    # add valid option
    if ( $Self->{CustomerUserMap}->{CustomerValid} && $Valid ) {

        # get valid object
        my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

        my $ValidIDs = join( ', ', $ValidObject->ValidIDsGet() );
        $SQL .= "
            AND $Self->{CustomerUserMap}->{CustomerValid} IN ($ValidIDs) ";
    }

    # add search term
    if ($SearchTerm) {
        my $SearchTermEscaped = $Self->{DBObject}->QueryStringEscape( QueryString => $SearchTerm );

        $SQL .= ' AND ';
        my %QueryCondition = $Self->{DBObject}->QueryCondition(
            Key           => $Self->{CustomerID},
            Value         => $SearchTermEscaped,
            SearchPrefix  => $Self->{SearchPrefix},
            SearchSuffix  => $Self->{SearchSuffix},
            CaseSensitive => $Self->{CaseSensitive},
            BindMode      => 1,
        );
        $SQL .= $QueryCondition{SQL};
        push @Bind, @{ $QueryCondition{Values} };

        $SQL .= ' ';
    }

    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my @Result;

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @Result, $Row[0];
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $CacheType,
            Key   => $CacheKey,
            Value => \@Result,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }
    return @Result;
}

sub CustomerIDs {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{User} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need User!'
        );
        return;
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $CustomerIDs = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "CustomerIDs::$Param{User}",
        );
        return @{$CustomerIDs} if ref $CustomerIDs eq 'ARRAY';
    }

    # get customer data
    my %Data = $Self->CustomerUserDataGet(
        User => $Param{User},
    );

    # there are multi customer ids
    my @CustomerIDs;
    if ( $Data{UserCustomerIDs} ) {

        # used separators
        SEPARATOR:
        for my $Separator ( ';', ',', '|' ) {

            next SEPARATOR if $Data{UserCustomerIDs} !~ /\Q$Separator\E/;

            # split it
            my @IDs = split /\Q$Separator\E/, $Data{UserCustomerIDs};

            for my $ID (@IDs) {
                $ID =~ s/^\s+//g;
                $ID =~ s/\s+$//g;
                push @CustomerIDs, $ID;
            }

            last SEPARATOR;
        }

        # fallback if no separator got found
        if ( !@CustomerIDs ) {
            $Data{UserCustomerIDs} =~ s/^\s+//g;
            $Data{UserCustomerIDs} =~ s/\s+$//g;
            push @CustomerIDs, $Data{UserCustomerIDs};
        }
    }

    # use also the primary customer id
    if ( $Data{UserCustomerID} && !$Self->{ExcludePrimaryCustomerID} ) {
        push @CustomerIDs, $Data{UserCustomerID};
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => 'CustomerIDs::' . $Param{User},
            Value => \@CustomerIDs,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }

    return @CustomerIDs;
}

sub CustomerUserDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{User} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need User!',
        );
        return;
    }

    # build select
    my $SQL = 'SELECT ';
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {

        next ENTRY if $Entry->[5] eq 'dynamic_field';

        $SQL .= " $Entry->[2], ";
    }

    if ( !$Self->{ForeignDB} ) {
        $SQL .= "create_time, create_by, change_time, change_by, ";
    }

    $SQL .= $Self->{CustomerKey} . " FROM $Self->{CustomerTable} WHERE ";

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Data = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "CustomerUserDataGet::$Param{User}",
        );
        return %{$Data} if ref $Data eq 'HASH';
    }

    # check customer key type
    my $User = $Param{User};

    if ( $Self->{CaseSensitive} ) {
        $SQL .= "$Self->{CustomerKey} = ?";
    }
    else {
        $SQL .= "LOWER($Self->{CustomerKey}) = LOWER(?)";
    }

    # ask the database
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => [ \$User ],
        Limit => 1,
    );

    # fetch the result
    my %Data;
    ROW:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my $MapCounter = 0;

        ENTRY:
        for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {

            next ENTRY if $Entry->[5] eq 'dynamic_field';

            $Data{ $Entry->[0] } = $Row[$MapCounter];
            $MapCounter++;
        }

        next ROW if $Self->{ForeignDB};

        for my $Key (qw(CreateTime CreateBy ChangeTime ChangeBy)) {
            $Data{$Key} = $Row[$MapCounter];
            $MapCounter++;
        }
    }

    # check data
    if ( !$Data{UserLogin} ) {

        # cache request
        if ( $Self->{CacheObject} ) {
            $Self->{CacheObject}->Set(
                Type  => $Self->{CacheType},
                Key   => "CustomerUserDataGet::$Param{User}",
                Value => {},
                TTL   => $Self->{CustomerUserMap}->{CacheTTL},
            );
        }
        return;
    }

    my $CustomerUserListFieldsMap = $Self->{CustomerUserMap}->{CustomerUserListFields};
    if ( !IsArrayRefWithData($CustomerUserListFieldsMap) ) {
        $CustomerUserListFieldsMap = [ 'first_name', 'last_name', 'email', ];
    }

    # Order fields by CustomerUserListFields (see bug#13821).
    my @CustomerUserListFields;
    for my $Field ( @{$CustomerUserListFieldsMap} ) {
        my @FieldNames = map { $_->[0] } grep { $_->[2] eq $Field } @{ $Self->{CustomerUserMap}->{Map} };
        push @CustomerUserListFields, $FieldNames[0];
    }

    my $UserMailString = '';
    my @UserMailStringParts;

    FIELD:
    for my $Field (@CustomerUserListFields) {
        next FIELD if !$Data{$Field};

        push @UserMailStringParts, $Data{$Field};
    }
    $UserMailString = join ' ', @UserMailStringParts;
    $UserMailString =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;

    # add the UserMailString to the data hash
    $Data{UserMailString} = $UserMailString;

    # compat!
    $Data{UserID} = $Data{UserLogin};

    # get preferences
    my %Preferences = $Self->GetPreferences( UserID => $Data{UserID} );

    # add last login timestamp
    if ( $Preferences{UserLastLogin} ) {

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $Preferences{UserLastLogin},
            },
        );

        $Preferences{UserLastLoginTimestamp} = $DateTimeObject->ToString();

    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => "CustomerUserDataGet::$Param{User}",
            Value => { %Data, %Preferences },
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }

    return ( %Data, %Preferences );
}

sub CustomerUserAdd {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Customer backend is read only!',
        );
        return;
    }

    # check needed stuff
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( !$Param{ $Entry->[0] } && $Entry->[4] ) {

            # skip UserLogin, will be checked later
            next ENTRY if ( $Entry->[0] eq 'UserLogin' );

            # ignore dynamic fields here
            next ENTRY if $Entry->[5] eq 'dynamic_field';

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Entry->[0]!",
            );
            return;
        }
    }
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # if no UserLogin is given
    if ( !$Param{UserLogin} && $Self->{CustomerUserMap}->{AutoLoginCreation} ) {

        # get time object
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        my $DateTimeString = $DateTimeObject->Format( Format => '%Y%m%d%H%M' );

        my $Prefix = $Self->{CustomerUserMap}->{AutoLoginCreationPrefix} || 'auto';
        $Param{UserLogin} = "$Prefix-$DateTimeString" . int( rand(99) );
    }

    # check if user login exists
    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserLogin!',
        );
        return;
    }

    # check email address if already exists
    if ( $Param{UserEmail} && $Self->{CustomerUserMap}->{CustomerUserEmailUniqCheck} ) {
        my %Result = $Self->CustomerSearch(
            Valid            => 0,
            PostMasterSearch => $Param{UserEmail},
        );
        if (%Result) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $Kernel::OM->Get('Kernel::Language')
                    ->Translate('This email address is already in use for another customer user.'),
            );
            return;
        }
    }

    # get check item object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    # check email address mx
    if (
        $Param{UserEmail}
        && !$CheckItemObject->CheckEmail( Address => $Param{UserEmail} )
        && grep { $_ eq $Param{ValidID} } $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet()
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Email address ($Param{UserEmail}) not valid ("
                . $CheckItemObject->CheckError() . ")!",
        );
        return;
    }

    # quote values
    my %Value;
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[5] =~ /^int$/i ) {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] } = $Param{ $Entry->[0] };
            }
            else {
                $Value{ $Entry->[0] } = 0;
            }
        }
        else {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] } = $Param{ $Entry->[0] };
            }
            else {
                $Value{ $Entry->[0] } = '';
            }
        }
    }

    # build insert
    my $SQL = "INSERT INTO $Self->{CustomerTable} (";
    my @Bind;
    my %SeenKey;    # If the map contains duplicated field names, insert only once.
    my @ColumnNames;

    MAPENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next MAPENTRY if $Entry->[5] eq 'dynamic_field';            # skip dynamic fields
        next MAPENTRY if ( lc( $Entry->[0] ) eq "userpassword" );
        next MAPENTRY if $SeenKey{ $Entry->[2] }++;
        push @ColumnNames, $Entry->[2];
    }

    $SQL .= join ', ', @ColumnNames;

    if ( !$Self->{ForeignDB} ) {
        $SQL .= ', create_time, create_by, change_time, change_by';
    }

    $SQL .= ') VALUES (';

    my %SeenValue;
    my $BindColumns = 0;

    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next ENTRY if $Entry->[5] eq 'dynamic_field';            # skip dynamic fields
        next ENTRY if ( lc( $Entry->[0] ) eq "userpassword" );
        next ENTRY if $SeenValue{ $Entry->[2] }++;
        $BindColumns++;
        push @Bind, \$Value{ $Entry->[0] };
    }

    $SQL .= join ', ', ('?') x $BindColumns;

    if ( !$Self->{ForeignDB} ) {
        $SQL .= ', current_timestamp, ?, current_timestamp, ?';
        push @Bind, \$Param{UserID};
        push @Bind, \$Param{UserID};
    }

    $SQL .= ')';

    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind
    );

    # log notice
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "CustomerUser: '$Param{UserLogin}' created successfully ($Param{UserID})!",
    );

    # set password
    if ( $Param{UserPassword} ) {
        $Self->SetPassword(
            UserLogin => $Param{UserLogin},
            PW        => $Param{UserPassword}
        );
    }

    $Self->_CustomerUserCacheClear( UserLogin => $Param{UserLogin} );

    return $Param{UserLogin};
}

sub CustomerUserUpdate {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Customer backend is read only!',
        );
        return;
    }

    # check needed stuff
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if (
            !$Param{ $Entry->[0] }
            && $Entry->[5] ne 'dynamic_field'    # ignore dynamic fields here
            && $Entry->[4]                       # only check required fields
            && $Entry->[0] ne 'UserPassword'     # ignore UserPassword field
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Entry->[0]!",
            );
            return;
        }
    }

    # get check item object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    # check email address
    if (
        $Param{UserEmail}
        && !$CheckItemObject->CheckEmail( Address => $Param{UserEmail} )
        && grep { $_ eq $Param{ValidID} } $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet()
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Email address ($Param{UserEmail}) not valid ("
                . $CheckItemObject->CheckError() . ")!",
        );
        return;
    }

    # get old user data (pw)
    my %UserData = $Self->CustomerUserDataGet( User => $Param{ID} );

    # if we update the email address, check if it already exists
    if (
        $Param{UserEmail}
        && $Self->{CustomerUserMap}->{CustomerUserEmailUniqCheck}
        && lc $Param{UserEmail} ne lc $UserData{UserEmail}
        )
    {
        my %Result = $Self->CustomerSearch(
            Valid            => 0,
            PostMasterSearch => $Param{UserEmail},
        );
        if (%Result) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $Kernel::OM->Get('Kernel::Language')
                    ->Translate('This email address is already in use for another customer user.'),
            );
            return;
        }
    }

    # quote values
    my %Value;
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[5] =~ /^int$/i ) {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] } = $Param{ $Entry->[0] };
            }
            else {
                $Value{ $Entry->[0] } = 0;
            }
        }
        else {
            if ( $Param{ $Entry->[0] } ) {
                $Value{ $Entry->[0] } = $Param{ $Entry->[0] };
            }
            else {
                $Value{ $Entry->[0] } = "";
            }
        }
    }

    # update db
    my $SQL = "UPDATE $Self->{CustomerTable} SET ";
    my @Bind;

    my %SeenKey;    # If the map contains duplicated field names, insert only once.
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next ENTRY if $Entry->[5] eq 'dynamic_field';            # skip dynamic fields
        next ENTRY if $Entry->[7];                               # skip readonly fields
        next ENTRY if ( lc( $Entry->[0] ) eq "userpassword" );
        next ENTRY if $SeenKey{ $Entry->[2] }++;
        $SQL .= " $Entry->[2] = ?, ";
        push @Bind, \$Value{ $Entry->[0] };
    }

    if ( !$Self->{ForeignDB} ) {
        $SQL .= 'change_time = current_timestamp, change_by = ?';
        push @Bind, \$Param{UserID};
    }
    else {
        chop $SQL;
        chop $SQL;
    }

    $SQL .= ' WHERE ';

    if ( $Self->{CaseSensitive} ) {
        $SQL .= "$Self->{CustomerKey} = ?";
    }
    else {
        $SQL .= "LOWER($Self->{CustomerKey}) = LOWER(?)";
    }
    push @Bind, \$Param{ID};

    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind
    );

    # check if we need to update Customer Preferences
    if ( $Param{UserLogin} ne $UserData{UserLogin} ) {

        # update the preferences
        $Self->{PreferencesObject}->RenamePreferences(
            NewUserID => $Param{UserLogin},
            OldUserID => $UserData{UserLogin},
        );
    }

    # log notice
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "CustomerUser: '$Param{UserLogin}' updated successfully ($Param{UserID})!",
    );

    # check pw
    if ( $Param{UserPassword} ) {
        $Self->SetPassword(
            UserLogin => $Param{UserLogin},
            PW        => $Param{UserPassword}
        );
    }

    $Self->_CustomerUserCacheClear( UserLogin => $Param{UserLogin} );
    if ( $Param{UserLogin} ne $UserData{UserLogin} ) {
        $Self->_CustomerUserCacheClear( UserLogin => $UserData{UserLogin} );
    }

    return 1;
}

sub SetPassword {
    my ( $Self, %Param ) = @_;

    my $Login = $Param{UserLogin};
    my $Pw    = $Param{PW} || '';

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Customer backend is read only!',
        );
        return;
    }

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserLogin!',
        );
        return;
    }
    my $CryptedPw = '';

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $CryptType = $ConfigObject->Get('Customer::AuthModule::DB::CryptType') || 'sha2';

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # crypt plain (no crypt at all)
    if ( $CryptType eq 'plain' ) {
        $CryptedPw = $Pw;
    }

    # crypt with unix crypt
    elsif ( $CryptType eq 'crypt' ) {

        # encode output, needed by crypt() only non utf8 signs
        $EncodeObject->EncodeOutput( \$Pw );
        $EncodeObject->EncodeOutput( \$Login );

        $CryptedPw = crypt( $Pw, $Login );
        $EncodeObject->EncodeInput( \$CryptedPw );
    }

    # crypt with md5 crypt
    elsif ( $CryptType eq 'md5' || !$CryptType ) {

        # encode output, needed by unix_md5_crypt() only non utf8 signs
        $EncodeObject->EncodeOutput( \$Pw );
        $EncodeObject->EncodeOutput( \$Login );

        $CryptedPw = unix_md5_crypt( $Pw, $Login );
        $EncodeObject->EncodeInput( \$CryptedPw );
    }

    # crypt with md5 crypt (compatible with Apache's .htpasswd files)
    elsif ( $CryptType eq 'apr1' ) {

        # encode output, needed by apache_md5_crypt() only non utf8 signs
        $EncodeObject->EncodeOutput( \$Pw );
        $EncodeObject->EncodeOutput( \$Login );

        $CryptedPw = apache_md5_crypt( $Pw, $Login );
        $EncodeObject->EncodeInput( \$CryptedPw );
    }

    # crypt with sha1
    elsif ( $CryptType eq 'sha1' ) {

        my $SHAObject = Digest::SHA->new('sha1');
        $EncodeObject->EncodeOutput( \$Pw );
        $SHAObject->add($Pw);
        $CryptedPw = $SHAObject->hexdigest();
    }

    elsif ( $CryptType eq 'sha512' ) {

        my $SHAObject = Digest::SHA->new('sha512');
        $EncodeObject->EncodeOutput( \$Pw );
        $SHAObject->add($Pw);
        $CryptedPw = $SHAObject->hexdigest();
    }

    # bcrypt
    elsif ( $CryptType eq 'bcrypt' ) {

        # get main object
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        if ( !$MainObject->Require('Crypt::Eksblowfish::Bcrypt') ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "CustomerUser: '$Login' tried to store password with bcrypt but 'Crypt::Eksblowfish::Bcrypt' is not installed!",
            );
            return;
        }

        my $Cost = $ConfigObject->Get('Customer::AuthModule::DB::bcryptCost') // 12;

        # Don't allow values smaller than 9 for security.
        $Cost = 9 if $Cost < 9;

        # Current Crypt::Eksblowfish::Bcrypt limit is 31.
        $Cost = 31 if $Cost > 31;

        my $Salt = $MainObject->GenerateRandomString( Length => 16 );

        # remove UTF8 flag, required by Crypt::Eksblowfish::Bcrypt
        $EncodeObject->EncodeOutput( \$Pw );

        # calculate password hash
        my $Octets = Crypt::Eksblowfish::Bcrypt::bcrypt_hash(
            {
                key_nul => 1,
                cost    => $Cost,
                salt    => $Salt,
            },
            $Pw
        );

        # We will store cost and salt in the password string so that it can be decoded
        #   in future even if we use a higher cost by default.
        $CryptedPw = "BCRYPT:$Cost:$Salt:" . Crypt::Eksblowfish::Bcrypt::en_base64($Octets);
    }

    # crypt with sha2 as fallback
    else {

        my $SHAObject = Digest::SHA->new('sha256');

        # encode output, needed by sha256_hex() only non utf8 signs
        $EncodeObject->EncodeOutput( \$Pw );

        $SHAObject->add($Pw);
        $CryptedPw = $SHAObject->hexdigest();
    }

    # update db
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        if ( $Entry->[0] =~ /^UserPassword$/i ) {
            $Param{PasswordCol} = $Entry->[2];
        }
        if ( $Entry->[0] =~ /^UserLogin$/i ) {
            $Param{LoginCol} = $Entry->[2];
        }
    }

    # check if needed pw col. exists (else there is no pw col.)
    if ( $Param{PasswordCol} && $Param{LoginCol} ) {
        my $SQL = "UPDATE $Self->{CustomerTable} SET "
            . " $Param{PasswordCol} = ? "
            . " WHERE ";

        if ( $Self->{CaseSensitive} ) {
            $SQL .= "$Param{LoginCol} = ?";
        }
        else {
            $SQL .= "LOWER($Param{LoginCol}) = LOWER(?)";
        }

        return if !$Self->{DBObject}->Do(
            SQL  => $SQL,
            Bind => [ \$CryptedPw, \$Param{UserLogin} ],
        );

        # log notice
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "CustomerUser: '$Param{UserLogin}' changed password successfully!",
        );

        $Self->_CustomerUserCacheClear( UserLogin => $Param{UserLogin} );

        return 1;
    }

    # need no pw to set
    return 1;
}

sub GenerateRandomPassword {
    my ( $Self, %Param ) = @_;

    # generated passwords are eight characters long by default
    my $Size = $Param{Size} || 8;

    my $Password = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => $Size,
    );

    return $Password;
}

sub SetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    $Self->_CustomerUserCacheClear( UserLogin => $Param{UserID} );

    return $Self->{PreferencesObject}->SetPreferences(%Param);
}

sub GetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    return $Self->{PreferencesObject}->GetPreferences(%Param);
}

sub SearchPreferences {
    my ( $Self, %Param ) = @_;

    return $Self->{PreferencesObject}->SearchPreferences(%Param);
}

sub _CustomerUserCacheClear {
    my ( $Self, %Param ) = @_;

    return if !$Self->{CacheObject};

    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserLogin!',
        );
        return;
    }

    $Self->{CacheObject}->Delete(
        Type => $Self->{CacheType},
        Key  => "CustomerUserDataGet::$Param{UserLogin}",
    );
    $Self->{CacheObject}->Delete(
        Type => $Self->{CacheType},
        Key  => "CustomerName::$Param{UserLogin}",
    );
    $Self->{CacheObject}->Delete(
        Type => $Self->{CacheType},
        Key  => "CustomerIDs::$Param{UserLogin}",
    );

    # delete all search cache entries
    $Self->{CacheObject}->CleanUp(
        Type => $Self->{CacheType} . '_CustomerIDList',
    );
    $Self->{CacheObject}->CleanUp(
        Type => $Self->{CacheType} . '_CustomerSearch',
    );
    $Self->{CacheObject}->CleanUp(
        Type => $Self->{CacheType} . '_CustomerSearchDetail',
    );
    $Self->{CacheObject}->CleanUp(
        Type => $Self->{CacheType} . '_CustomerSearchDetailDynamicFields',
    );

    $Self->{CacheObject}->CleanUp(
        Type => 'CustomerGroup',
    );

    for my $Function (qw(CustomerUserList)) {
        for my $Valid ( 0 .. 1 ) {
            $Self->{CacheObject}->Delete(
                Type => $Self->{CacheType},
                Key  => "${Function}::${Valid}",
            );
        }
    }

    return 1;
}

sub DESTROY {
    my $Self = shift;

    # disconnect if it's not a parent DBObject
    if ( $Self->{NotParentDBObject} ) {
        if ( $Self->{DBObject} ) {
            $Self->{DBObject}->Disconnect();
        }
    }

    return 1;
}

1;
