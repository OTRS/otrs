# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CustomerUser::LDAP;

use strict;
use warnings;

use Net::LDAP;
use Net::LDAP::Util qw(escape_filter_value);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::DateTime',
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

    # max shown user a search list
    $Self->{UserSearchListLimit} = $Self->{CustomerUserMap}->{CustomerUserSearchListLimit} || 200;

    # get ldap preferences
    $Self->{Die} = 0;
    if ( defined $Self->{CustomerUserMap}->{Params}->{Die} ) {
        $Self->{Die} = $Self->{CustomerUserMap}->{Params}->{Die};
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # params
    if ( $Self->{CustomerUserMap}->{Params}->{Params} ) {
        $Self->{Params} = $Self->{CustomerUserMap}->{Params}->{Params};
    }

    # Net::LDAP new params
    elsif ( $ConfigObject->Get( 'AuthModule::LDAP::Params' . $Param{Count} ) ) {
        $Self->{Params} = $ConfigObject->Get( 'AuthModule::LDAP::Params' . $Param{Count} );
    }
    else {
        $Self->{Params} = {};
    }

    # host
    if ( $Self->{CustomerUserMap}->{Params}->{Host} ) {
        $Self->{Host} = $Self->{CustomerUserMap}->{Params}->{Host};
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need CustomerUser->Params->Host in Kernel/Config.pm',
        );
        return;
    }

    # base dn
    if ( defined $Self->{CustomerUserMap}->{Params}->{BaseDN} ) {
        $Self->{BaseDN} = $Self->{CustomerUserMap}->{Params}->{BaseDN};
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need CustomerUser->Params->BaseDN in Kernel/Config.pm',
        );
        return;
    }

    # scope
    if ( $Self->{CustomerUserMap}->{Params}->{SSCOPE} ) {
        $Self->{SScope} = $Self->{CustomerUserMap}->{Params}->{SSCOPE};
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need CustomerUser->Params->SSCOPE in Kernel/Config.pm',
        );
        return;
    }

    # search user
    $Self->{SearchUserDN} = $Self->{CustomerUserMap}->{Params}->{UserDN} || '';
    $Self->{SearchUserPw} = $Self->{CustomerUserMap}->{Params}->{UserPw} || '';

    # group dn
    $Self->{GroupDN} = $Self->{CustomerUserMap}->{Params}->{GroupDN} || '';

    # customer key
    if ( $Self->{CustomerUserMap}->{CustomerKey} ) {
        $Self->{CustomerKey} = $Self->{CustomerUserMap}->{CustomerKey};
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need CustomerUser->CustomerKey in Kernel/Config.pm',
        );
        return;
    }

    # customer id
    if ( $Self->{CustomerUserMap}->{CustomerID} ) {
        $Self->{CustomerID} = $Self->{CustomerUserMap}->{CustomerID};
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need CustomerUser->CustomerID in Kernel/Config.pm',
        );
        return;
    }

    # ldap filter always used
    $Self->{AlwaysFilter} = $Self->{CustomerUserMap}->{Params}->{AlwaysFilter} || '';

    $Self->{ExcludePrimaryCustomerID} = $Self->{CustomerUserMap}->{CustomerUserExcludePrimaryCustomerID} || 0;
    $Self->{SearchPrefix}             = $Self->{CustomerUserMap}->{CustomerUserSearchPrefix};
    if ( !defined $Self->{SearchPrefix} ) {
        $Self->{SearchPrefix} = '';
    }
    $Self->{SearchSuffix} = $Self->{CustomerUserMap}->{CustomerUserSearchSuffix};
    if ( !defined $Self->{SearchSuffix} ) {
        $Self->{SearchSuffix} = '*';
    }

    # charset settings
    $Self->{SourceCharset} = $Self->{CustomerUserMap}->{Params}->{SourceCharset} || '';

    # set cache type
    $Self->{CacheType} = 'CustomerUser' . $Param{Count};

    # create cache object, but only if CacheTTL is set in customer config
    if ( $Self->{CustomerUserMap}->{CacheTTL} ) {
        $Self->{CacheObject} = $Kernel::OM->Get('Kernel::System::Cache');
    }

    # get valid filter if used
    $Self->{ValidFilter} = $Self->{CustomerUserMap}->{CustomerUserValidFilter} || '';

    # connect first if Die is enabled, make sure that connection is possible, else die
    if ( $Self->{Die} ) {
        return if !$Self->_Connect();
    }

    # fetch names of configured dynamic fields
    my @DynamicFieldMapEntries = grep { $_->[5] eq 'dynamic_field' } @{ $Self->{CustomerUserMap}->{Map} };
    $Self->{ConfiguredDynamicFieldNames} = { map { $_->[2] => 1 } @DynamicFieldMapEntries };

    return $Self;
}

sub _Connect {
    my ( $Self, %Param ) = @_;

    # return if connection is already open
    return 1 if $Self->{LDAP};

    # ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
    $Self->{LDAP} = Net::LDAP->new( $Self->{Host}, %{ $Self->{Params} } );

    if ( !$Self->{LDAP} ) {
        if ( $Self->{Die} ) {
            die "Can't connect to $Self->{Host}: $@";
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't connect to $Self->{Host}: $@",
            );
            return;
        }
    }

    my $Result;
    if ( $Self->{SearchUserDN} && $Self->{SearchUserPw} ) {
        $Result = $Self->{LDAP}->bind(
            dn       => $Self->{SearchUserDN},
            password => $Self->{SearchUserPw},
        );
    }
    else {
        $Result = $Self->{LDAP}->bind();
    }

    if ( $Result->code() ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'First bind failed! ' . $Result->error(),
        );
        $Self->{LDAP}->disconnect();
        return;
    }

    return 1;
}

sub CustomerName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserLogin!'
        );
        return;
    }

    # build filter
    my $Filter = "($Self->{CustomerKey}=" . escape_filter_value( $Param{UserLogin} ) . ')';

    # prepare filter
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Name = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => 'CustomerName::' . $Param{UserLogin},
        );
        return $Name if defined $Name;
    }

    # create ldap connect
    return if !$Self->_Connect();

    # perform user search
    my $Result = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Self->{UserSearchListLimit},
        attrs     => $Self->{CustomerUserMap}->{CustomerUserNameFields},
    );

    if ( $Result->code() ) {
        if ( $Result->code() == 4 ) {

            # Result code 4 (LDAP_SIZELIMIT_EXCEEDED) is normal if there
            # are more items in LDAP than search limit defined in OTRS or
            # in LDAP server. Avoid spamming logs with such errors.
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => 'LDAP size limit exceeded (' . $Result->error() . ').',
            );
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Search failed! ' . $Result->error(),
            );
        }
        return;
    }

    my %NameParts;

    for my $Entry ( $Result->all_entries() ) {

        for my $Field ( @{ $Self->{CustomerUserMap}->{CustomerUserNameFields} } ) {

            if ( defined $Entry->get_value($Field) ) {
                $NameParts{$Field} = $Self->_ConvertFrom( $Entry->get_value($Field) );
            }
        }
    }

    # fetch dynamic field values, if configured
    my @DynamicFieldCustomerUserNameFields = grep { exists $Self->{ConfiguredDynamicFieldNames}->{$_} }
        @{ $Self->{CustomerUserMap}->{CustomerUserNameFields} };
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
    for my $CustomerUserNameField ( @{ $Self->{CustomerUserMap}->{CustomerUserNameFields} } ) {
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
            Key   => 'CustomerName::' . $Param{UserLogin},
            Value => $Name,
            TTL   => $Self->{CustomerUserMap}->{CacheTTL},
        );
    }

    return $Name;
}

sub CustomerSearch {
    my ( $Self, %Param ) = @_;

    if ( $Param{CustomerIDRaw} ) {
        $Param{CustomerID} = $Param{CustomerIDRaw};
    }

    # check needed stuff
    if ( !$Param{Search} && !$Param{UserLogin} && !$Param{PostMasterSearch} && !$Param{CustomerID} )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Search, UserLogin, PostMasterSearch or CustomerID!'
        );
        return;
    }

    # build filter
    my $Filter = '';
    if ( $Param{Search} ) {

        my $Count = 0;
        my @Parts = split( /\+/, $Param{Search}, 6 );
        for my $Part (@Parts) {

            $Part = $Self->{SearchPrefix} . $Part . $Self->{SearchSuffix};
            $Part =~ s/(\%+)/\%/g;
            $Part =~ s/(\*+)\*/*/g;
            $Count++;

            # remove dynamic field names that are configured in CustomerUserSearchFields
            # as they cannot be retrieved here
            my @CustomerUserSearchFields = grep { !exists $Self->{ConfiguredDynamicFieldNames}->{$_} }
                @{ $Self->{CustomerUserMap}->{CustomerUserSearchFields} };

            if (@CustomerUserSearchFields) {

                # quote LDAP filter value but keep asterisks unescaped (wildcard)
                $Part =~ s/\*/encodedasterisk20160930/g;
                $Part = escape_filter_value( $Self->_ConvertTo($Part) );
                $Part =~ s/encodedasterisk20160930/*/g;

                $Filter .= '(|';
                for my $Field (@CustomerUserSearchFields) {
                    $Filter .= "($Field=" . $Part . ')';
                }
                $Filter .= ')';
            }
            else {

                # quote LDAP filter value but keep asterisks unescaped (wildcard)
                $Part =~ s/\*/encodedasterisk20160930/g;
                $Part = escape_filter_value($Part);
                $Part =~ s/encodedasterisk20160930/*/g;

                $Filter .= "($Self->{CustomerKey}=" . $Part . ')';
            }
        }

        if ( $Count > 1 ) {
            $Filter = "(&$Filter)";
        }
    }
    elsif ( $Param{PostMasterSearch} ) {

        # remove dynamic field names that are configured in CustomerUserPostMasterSearchFields
        # as they cannot be retrieved here
        my @CustomerUserPostMasterSearchFields = grep { !exists $Self->{ConfiguredDynamicFieldNames}->{$_} }
            @{ $Self->{CustomerUserMap}->{CustomerUserPostMasterSearchFields} };

        if (@CustomerUserPostMasterSearchFields) {

            # quote LDAP filter value but keep asterisks unescaped (wildcard)
            $Param{PostMasterSearch} =~ s/\*/encodedasterisk20160930/g;
            $Param{PostMasterSearch} = escape_filter_value( $Param{PostMasterSearch} );
            $Param{PostMasterSearch} =~ s/encodedasterisk20160930/*/g;

            $Filter = '(|';
            for my $Field (@CustomerUserPostMasterSearchFields) {
                $Filter .= "($Field=$Param{PostMasterSearch})";
            }
            $Filter .= ')';
        }
    }
    elsif ( $Param{UserLogin} ) {
        $Filter = "($Self->{CustomerKey}=" . escape_filter_value( $Param{UserLogin} ) . ')';
    }
    elsif ( $Param{CustomerID} ) {
        $Filter = "($Self->{CustomerID}=" . escape_filter_value( $Param{CustomerID} ) . ')';
    }

    # prepare filter
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # add valid filter
    if ( $Self->{ValidFilter} ) {
        $Filter = "(&$Filter$Self->{ValidFilter})";
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

    # create ldap connect
    return if !$Self->_Connect();

    my $CustomerUserListFields = $Self->{CustomerUserMap}->{CustomerUserListFields};

    # remove dynamic field names that are configured in CustomerUserListFields
    # as they cannot be handled here
    my @CustomerUserListFieldsWithoutDynamicFields
        = grep { !exists $Self->{ConfiguredDynamicFieldNames}->{$_} } @{$CustomerUserListFields};

    # combine needed attrs
    my @Attributes = ( @CustomerUserListFieldsWithoutDynamicFields, $Self->{CustomerKey} );

    # perform user search
    my $Result = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Param{Limit} || $Self->{UserSearchListLimit},
        attrs     => \@Attributes,
    );

    # log ldap errors
    if ( $Result->code() ) {
        if ( $Result->code() == 4 ) {

            # Result code 4 (LDAP_SIZELIMIT_EXCEEDED) is normal if there
            # are more items in LDAP than search limit defined in OTRS or
            # in LDAP server. Avoid spamming logs with such errors.
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => 'LDAP size limit exceeded (' . $Result->error() . ').',
            );
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Search failed! ' . $Result->error(),
            );
        }
    }

    # dynamic field handling
    my @CustomerUserListFieldsDynamicFields
        = grep { exists $Self->{ConfiguredDynamicFieldNames}->{$_} } @{$CustomerUserListFields};
    my %CustomerUserListFieldsDynamicFields = map { $_ => 1 } @CustomerUserListFieldsDynamicFields;

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $DynamicFieldConfigs = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'CustomerUser',
        Valid      => 1,
    );
    my %DynamicFieldConfigsByName = map { $_->{Name} => $_ } @{$DynamicFieldConfigs};

    my %Users;
    for my $Entry ( $Result->all_entries() ) {

        my $CustomerString = '';

        my $CustomerKey;
        if ( defined $Entry->get_value( $Self->{CustomerKey} ) ) {
            $CustomerKey = $Self->_ConvertFrom( $Entry->get_value( $Self->{CustomerKey} ) );
        }

        FIELD:
        for my $Field ( @{$CustomerUserListFields} ) {

            # dynamic field value
            if ( $CustomerUserListFieldsDynamicFields{$Field} ) {
                next FIELD if !defined $CustomerKey;
                next FIELD if !exists $DynamicFieldConfigsByName{$Field};

                my $Value = $DynamicFieldBackendObject->ValueGet(
                    DynamicFieldConfig => $DynamicFieldConfigsByName{$Field},
                    ObjectName         => $CustomerKey,
                );

                next FIELD if !defined $Value;

                if ( !IsArrayRefWithData($Value) ) {
                    $Value = [$Value];
                }

                my @Values;

                VALUE:
                for my $CurrentValue ( @{$Value} ) {
                    next VALUE if !defined $CurrentValue || !length $CurrentValue;

                    my $ReadableValue = $DynamicFieldBackendObject->ReadableValueRender(
                        DynamicFieldConfig => $DynamicFieldConfigsByName{$Field},
                        Value              => $CurrentValue,
                    );

                    next VALUE if !IsHashRefWithData($ReadableValue) || !defined $ReadableValue->{Value};

                    my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
                        DynamicFieldConfig => $DynamicFieldConfigsByName{$Field},
                        Behavior           => 'IsACLReducible',
                    );
                    if ($IsACLReducible) {
                        my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                            DynamicFieldConfig => $DynamicFieldConfigsByName{$Field},
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

                $CustomerString .= ( join ' ', @Values ) . ' ';

                next FIELD;
            }

            my $Value = $Self->_ConvertFrom( $Entry->get_value($Field) );

            if ($Value) {
                if ( $Field =~ /^targetaddress$/i ) {
                    $Value =~ s/SMTP:(.*)/$1/;
                }
                $CustomerString .= $Value . ' ';
            }
        }

        $CustomerString =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;

        if ( defined $CustomerKey ) {
            $Users{$CustomerKey} = $CustomerString;
        }
    }

    # check if user need to be in a group!
    if ( $Self->{GroupDN} ) {

        for my $Filter2 ( sort keys %Users ) {

            my $Result2 = $Self->{LDAP}->search(
                base      => $Self->{GroupDN},
                scope     => $Self->{SScope},
                filter    => 'memberUid=' . escape_filter_value($Filter2),
                sizelimit => $Param{Limit} || $Self->{UserSearchListLimit},
                attrs     => ['1.1'],
            );

            if ( !$Result2->all_entries() ) {
                delete $Users{$Filter2};
            }
        }
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

    # Build the ldap filter for the diffrent search params.
    my $Filter = '';

    for my $Field (@ScalarSearchFields) {

        # Search for scalar fields (wildcards are allowed).
        if ( $Param{ $Field->{Name} } ) {

            $Param{ $Field->{Name} } =~ s/(\%+)/\%/g;
            $Param{ $Field->{Name} } =~ s/(\*+)\*/*/g;

            $Filter .= "($Field->{DatabaseField}=" . $Self->_ConvertTo( $Param{ $Field->{Name} } ) . ")";
        }
    }

    if ($Filter) {
        $Filter = "(&$Filter)";
    }

    my $ArrayFilter = '';

    # Special parameter for CustomerIDs from a customer company search result.
    if ( IsArrayRefWithData( $Param{CustomerCompanySearchCustomerIDs} ) ) {
        $ArrayFilter .= '(|';
        for my $OneParam ( @{ $Param{CustomerCompanySearchCustomerIDs} } ) {
            $ArrayFilter .= "($Self->{CustomerID}=" . $Self->_ConvertTo($OneParam) . ")";
        }
        $ArrayFilter .= ')';
    }

    FIELD:
    for my $Field (@ArraySearchFields) {

        # Ignore empty lists.
        next FIELD if !@{ $Param{ $Field->{Name} } };

        $ArrayFilter .= '(|';
        for my $OneParam ( @{ $Param{ $Field->{Name} } } ) {
            $ArrayFilter .= "($Field->{DatabaseField}=" . $Self->_ConvertTo($OneParam) . ")";
        }
        $ArrayFilter .= ')';
    }

    # Add the array filter fields to the ldap filter.
    if ($ArrayFilter) {
        $Filter = "(&$Filter$ArrayFilter)";
    }

    my $DBObject                  = $Kernel::OM->Get('Kernel::System::DB');
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

        # sql uery for the dynamic fields
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

                    # set the used cache flag
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

            my $DynamicFieldUserLoginsFilter = '(|';
            for my $OneParam (@DynamicFieldUserLogins) {
                $DynamicFieldUserLoginsFilter .= "($Self->{CustomerKey}=" . $Self->_ConvertTo($OneParam) . ")";
            }
            $DynamicFieldUserLoginsFilter .= ')';

            # Add the dynamic field user logins filter to the ldap filter.
            $Filter = "(&$Filter$DynamicFieldUserLoginsFilter)";
        }
        else {
            return $Result eq 'COUNT' ? 0 : [];
        }
    }

    # Special parameter to exclude some user logins from the search result.
    if ( IsArrayRefWithData( $Param{ExcludeUserLogins} ) ) {
        my $ExcludeUserLoginsFilter = '(&';
        for my $OneParam ( @{ $Param{ExcludeUserLogins} } ) {
            $ExcludeUserLoginsFilter .= "(!($Self->{CustomerKey}=" . $Self->_ConvertTo($OneParam) . "))";
        }
        $ExcludeUserLoginsFilter .= ')';

        # Add the exclude user logins filter to the ldap filter.
        $Filter = "(&$Filter$ExcludeUserLoginsFilter)";
    }

    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    if ( $Self->{ValidFilter} && $Valid ) {
        $Filter = "(&$Filter$Self->{ValidFilter})";
    }

    # Default filter for the search, if no filter exists.
    if ( !$Filter ) {
        $Filter = "($Self->{CustomerKey}=*)";
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

    # Assemble the ORDER BY clause.
    my @OrderByFields;
    my $OrderByString = '';
    my $Count         = 0;

    ORDERBY:
    for my $OrderBy ( @{ $Param{OrderBy} } ) {
        next ORDERBY if !$OrderByTable{$OrderBy};

        my $Direction = $Param{OrderByDirection}->[$Count] || 'Down';

        $OrderByString .= $OrderByTable{$OrderBy} . $Direction;

        push @OrderByFields, {
            Name          => $OrderBy,
            DatabaseField => $OrderByTable{$OrderBy},
            Direction     => $Direction,
        };
    }
    continue {
        $Count++;
    }

    # If there is a possibility that the ordering is not determined
    #   we add an descending ordering by id.
    if ( !grep { $_ eq 'UserLogin' } ( @{ $Param{OrderBy} } ) ) {
        push @OrderByFields, {
            Name          => 'UserLogin',
            DatabaseField => "$Self->{CustomerKey}",
            Direction     => 'Down',
        };
    }

    my $CacheKey = 'CustomerSearchDetail::' . $Result . $Filter . $Param{Limit} . $OrderByString;

    if ( $Self->{CacheObject} ) {
        my $CacheData = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
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

    return if !$Self->_Connect();

    # cCmbine needed attributes.
    my @Attributes = map { $_->{DatabaseField} } @OrderByFields;

    # Perform the ldap user search.
    my $ResultSearch = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Self->{UserSearchListLimit},
        attrs     => \@Attributes,
    );

    if ( $ResultSearch->code() ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $ResultSearch->error(),
        );
    }

    my @TmpCustomerUsers;
    for my $Entry ( $ResultSearch->all_entries() ) {

        my %Data;
        for my $OrderBy (@OrderByFields) {

            my $FieldValue = $Entry->get_value( $OrderBy->{DatabaseField} );
            $FieldValue = $Self->_ConvertFrom($FieldValue);

            $Data{ $OrderBy->{Name} } = $FieldValue;
        }

        push @TmpCustomerUsers, \%Data;
    }

    # Sort the customer users.
    @TmpCustomerUsers = sort { $Self->_SearchResultSort(@OrderByFields) } @TmpCustomerUsers;

    my @IDs;

    # Check if user need to be in a group!
    if ( $Self->{GroupDN} ) {

        FILTERID:
        for my $Data (@TmpCustomerUsers) {

            my $ResultGroupDN = $Self->{LDAP}->search(
                base      => $Self->{GroupDN},
                scope     => $Self->{SScope},
                filter    => 'memberUid=' . $Data->{UserLogin},
                sizelimit => $Self->{UserSearchListLimit},
                attrs     => ['1.1'],
            );

            next FILTERID if !$ResultGroupDN->all_entries();

            push @IDs, $Data->{UserLogin};
        }
    }
    else {
        @IDs = map { $_->{UserLogin} } @TmpCustomerUsers;
    }

    if ( $Param{Limit} ) {
        splice @IDs, $Param{Limit};
    }

    if ( $Result eq 'COUNT' ) {

        if ( $Self->{CacheObject} ) {
            $Self->{CacheObject}->Set(
                Type  => $Self->{CacheType},
                Key   => $CacheKey,
                Value => scalar @IDs,
                TTL   => $Self->{CustomerUserMap}->{CacheTTL},
            );
        }
        return scalar @IDs;
    }
    else {

        if ( $Self->{CacheObject} ) {
            $Self->{CacheObject}->Set(
                Type  => $Self->{CacheType},
                Key   => $CacheKey,
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

    my $CacheKey = "CustomerIDList::${Valid}::$SearchTerm";

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Result = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        return @{$Result} if ref $Result eq 'ARRAY';
    }

    # prepare filter
    my $Filter = "($Self->{CustomerID}=*)";
    if ($SearchTerm) {

        my $SearchFilter = $Self->{SearchPrefix} . $SearchTerm . $Self->{SearchSuffix};
        $SearchFilter =~ s/(\%+)/\%/g;
        $SearchFilter =~ s/(\*+)\*/*/g;

        # quote LDAP filter value but keep asterisks unescaped (wildcard)
        $SearchFilter =~ s/\*/encodedasterisk20160930/g;
        $SearchFilter = escape_filter_value($SearchFilter);
        $SearchFilter =~ s/encodedasterisk20160930/*/g;

        $Filter = "($Self->{CustomerID}=$SearchFilter)";

    }

    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # add valid filter
    if ( $Self->{ValidFilter} && $Valid ) {
        $Filter = "(&$Filter$Self->{ValidFilter})";
    }

    # create ldap connect
    return if !$Self->_Connect();

    # combine needed attrs
    my @Attributes = ( $Self->{CustomerKey}, $Self->{CustomerID} );

    # perform user search
    my $Result = $Self->{LDAP}->search(
        base      => $Self->{BaseDN},
        scope     => $Self->{SScope},
        filter    => $Filter,
        sizelimit => $Self->{UserSearchListLimit},
        attrs     => \@Attributes,
    );

    # log ldap errors
    if ( $Result->code() ) {

        if ( $Result->code() == 4 ) {

            # Result code 4 (LDAP_SIZELIMIT_EXCEEDED) is normal if there
            # are more items in LDAP than search limit defined in OTRS or
            # in LDAP server. Avoid spamming logs with such errors.
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => 'LDAP size limit exceeded (' . $Result->error() . ').',
            );
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Search failed! ' . $Result->error(),
            );
        }
    }

    my %Users;
    for my $Entry ( $Result->all_entries() ) {

        my $FieldValue = $Entry->get_value( $Self->{CustomerID} );
        $FieldValue = defined $FieldValue ? $FieldValue : '';

        my $KeyValue = $Entry->get_value( $Self->{CustomerKey} );
        $KeyValue = defined $KeyValue ? $KeyValue : '';
        $Users{ $Self->_ConvertFrom($KeyValue) } = $Self->_ConvertFrom($FieldValue);
    }

    # check if user need to be in a group!
    if ( $Self->{GroupDN} ) {
        for my $Filter2 ( sort keys %Users ) {
            my $Result2 = $Self->{LDAP}->search(
                base      => $Self->{GroupDN},
                scope     => $Self->{SScope},
                filter    => 'memberUid=' . escape_filter_value($Filter2),
                sizelimit => $Self->{UserSearchListLimit},
                attrs     => ['1.1'],
            );
            if ( !$Result2->all_entries() ) {
                delete $Users{$Filter2};
            }
        }
    }

    # make CustomerIDs unique
    my %Tmp;
    @Tmp{ values %Users } = undef;
    my @Result = keys %Tmp;

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
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
            Message  => 'Need User!'
        );
        return;
    }

    # perform user search
    my @Attributes;
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next ENTRY if $Entry->[5] eq 'dynamic_field';
        push( @Attributes, $Entry->[2] );
    }
    my $Filter = "($Self->{CustomerKey}=" . escape_filter_value( $Param{User} ) . ')';

    # prepare filter
    if ( $Self->{AlwaysFilter} ) {
        $Filter = "(&$Filter$Self->{AlwaysFilter})";
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Data = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => 'CustomerUserDataGet::' . $Param{User},
        );
        return %{$Data} if ref $Data eq 'HASH';
    }

    # create ldap connect
    return if !$Self->_Connect();

    # perform search
    my $Result = $Self->{LDAP}->search(
        base   => $Self->{BaseDN},
        scope  => $Self->{SScope},
        filter => $Filter,
        attrs  => \@Attributes,
    );

    # log ldap errors
    if ( $Result->code() ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Result->error(),
        );
        return;
    }

    # get first entry
    my $Result2 = $Result->entry(0);
    if ( !$Result2 ) {
        return;
    }

    # get customer user info
    my %Data;
    ENTRY:
    for my $Entry ( @{ $Self->{CustomerUserMap}->{Map} } ) {
        next ENTRY if $Entry->[5] eq 'dynamic_field';

        my $Value = $Self->_ConvertFrom( $Result2->get_value( $Entry->[2] ) ) || '';

        if ( $Value && $Entry->[2] =~ /^targetaddress$/i ) {
            $Value =~ s/SMTP:(.*)/$1/;
        }

        $Data{ $Entry->[0] } = $Value;
    }

    return if !$Data{UserLogin};

    # to build the UserMailString
    my $UserMailString = '';
    my @UserMailStringParts;

    my $CustomerUserListFieldsMap = $Self->{CustomerUserMap}->{CustomerUserListFields};
    if ( !IsArrayRefWithData($CustomerUserListFieldsMap) ) {
        $CustomerUserListFieldsMap = [ 'first_name', 'last_name', 'email', ];
    }

    for my $Field ( @{$CustomerUserListFieldsMap} ) {

        my $Value = $Self->_ConvertFrom( $Result2->get_value($Field) ) || '';

        if ($Value) {
            if ( $Field =~ /^targetaddress$/i ) {
                $Value =~ s/SMTP:(.*)/$1/;
            }
            push @UserMailStringParts, $Value;
        }
    }
    $UserMailString = join ' ', @UserMailStringParts;
    $UserMailString =~ s/^(.*)\s(.+?\@.+?\..+?)(\s|)$/"$1" <$2>/;

    # add the UserMailString to the data hash
    $Data{UserMailString} = $UserMailString;

    # compat!
    $Data{UserID} = $Data{UserLogin};

    # get preferences
    my %Preferences = $Self->GetPreferences( UserID => $Data{UserLogin} );

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
            Key   => 'CustomerUserDataGet::' . $Param{User},
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
            Message  => 'Customer backend is read only!'
        );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => 'Not supported for this module!'
    );

    return;
}

sub CustomerUserUpdate {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Customer backend is read only!'
        );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => 'Not supported for this module!'
    );

    return;
}

sub SetPassword {
    my ( $Self, %Param ) = @_;

    my $Pw = $Param{PW} || '';

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Customer backend is read only!'
        );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => 'Not supported for this module!'
    );

    return;
}

sub GenerateRandomPassword {
    my ( $Self, %Param ) = @_;

    # generated passwords are eight characters long by default.
    my $Size = $Param{Size} || 8;

    # The list of characters that can appear in a randomly generated password.
    # Note that users can put any character into a password they choose themselves.
    my @PwChars = ( 0 .. 9, 'A' .. 'Z', 'a' .. 'z', '-', '_', '!', '@', '#', '$', '%', '^', '&', '*' );

    # number of characters in the list.
    my $PwCharsLen = scalar(@PwChars);

    # generate the password.
    my $Password = '';
    for ( my $i = 0; $i < $Size; $i++ ) {
        $Password .= $PwChars[ rand $PwCharsLen ];
    }

    return $Password;
}

sub SetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!'
        );
        return;
    }

    # cache reset
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Delete(
            Type => $Self->{CacheType},
            Key  => "CustomerUserDataGet::$Param{UserID}",
        );
    }
    return $Self->{PreferencesObject}->SetPreferences(%Param);
}

sub GetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!'
        );
        return;
    }

    return $Self->{PreferencesObject}->GetPreferences(%Param);
}

sub SearchPreferences {
    my ( $Self, %Param ) = @_;

    return $Self->{PreferencesObject}->SearchPreferences(%Param);
}

sub _ConvertFrom {
    my ( $Self, $Text ) = @_;

    return if !defined $Text;

    if ( !$Self->{SourceCharset} ) {
        return $Text;
    }

    return $Kernel::OM->Get('Kernel::System::Encode')->Convert(
        Text => $Text,
        From => $Self->{SourceCharset},
        To   => 'utf-8',
    );
}

sub _ConvertTo {
    my ( $Self, $Text ) = @_;

    return if !defined $Text;

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    if ( !$Self->{SourceCharset} ) {
        $EncodeObject->EncodeInput( \$Text );
        return $Text;
    }

    return $EncodeObject->Convert(
        Text => $Text,
        To   => $Self->{SourceCharset},
        From => 'utf-8',
    );
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

    $Self->{CacheObject}->CleanUp(
        Type => $Self->{CacheType} . '_CustomerSearch',
    );

    $Self->{CacheObject}->CleanUp(
        Type => 'CustomerGroup',
    );

    return 1;
}

sub _SearchResultSort {
    my ( $Self, @OrderByFields ) = @_;

    for my $OrderBy (@OrderByFields) {
        my $Compare;

        if ( $OrderBy->{Direction} && $OrderBy->{Direction} eq 'Up' ) {
            $Compare = lc( $a->{ $OrderBy->{Name} } ) cmp lc( $b->{ $OrderBy->{Name} } );
        }
        else {
            $Compare = lc( $b->{ $OrderBy->{Name} } ) cmp lc( $a->{ $OrderBy->{Name} } );
        }
        return $Compare if $Compare;
    }
    return 0;
}

sub DESTROY {
    my ( $Self, %Param ) = @_;

    # take down session
    if ( $Self->{LDAP} ) {
        $Self->{LDAP}->unbind();
    }

    return 1;
}

1;
