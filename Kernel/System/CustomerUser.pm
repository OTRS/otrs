# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CustomerUser;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::EventHandler);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::Cache',
    'Kernel::System::CustomerCompany',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::CustomerUser - customer user lib

=head1 DESCRIPTION

All customer user functions. E. g. to add and update customer users.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'CustomerUser';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # load generator customer preferences module
    my $GeneratorModule = $ConfigObject->Get('CustomerPreferences')->{Module}
        || 'Kernel::System::CustomerUser::Preferences::DB';

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    if ( $MainObject->Require($GeneratorModule) ) {
        $Self->{PreferencesObject} = $GeneratorModule->new();
    }

    # load customer user backend module
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$ConfigObject->Get("CustomerUser$Count");

        my $GenericModule = $ConfigObject->Get("CustomerUser$Count")->{Module};
        if ( !$MainObject->Require($GenericModule) ) {
            $MainObject->Die("Can't load backend module $GenericModule! $@");
        }

        $Self->{"CustomerUser$Count"} = $GenericModule->new(
            Count             => $Count,
            PreferencesObject => $Self->{PreferencesObject},
            CustomerUserMap   => $ConfigObject->Get("CustomerUser$Count"),
        );
    }

    # init of event handler
    $Self->EventHandlerInit(
        Config => 'CustomerUser::EventModulePost',
    );

    return $Self;
}

=head2 CustomerSourceList()

return customer source list

    my %List = $CustomerUserObject->CustomerSourceList(
        ReadOnly => 0 # optional, 1 returns only RO backends, 0 returns writable, if not passed returns all backends
    );

=cut

sub CustomerSourceList {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$ConfigObject->Get("CustomerUser$Count");
        if ( defined $Param{ReadOnly} ) {
            my $CustomerBackendConfig = $ConfigObject->Get("CustomerUser$Count");
            if ( $Param{ReadOnly} ) {
                next SOURCE if !$CustomerBackendConfig->{ReadOnly} || $CustomerBackendConfig->{Module} !~ /LDAP/i;
            }
            else {
                next SOURCE if $CustomerBackendConfig->{ReadOnly} || $CustomerBackendConfig->{Module} =~ /LDAP/i;
            }
        }
        $Data{"CustomerUser$Count"} = $ConfigObject->Get("CustomerUser$Count")->{Name}
            || "No Name $Count";
    }
    return %Data;
}

=head2 CustomerSearch()

to search users

    # text search
    my %List = $CustomerUserObject->CustomerSearch(
        Search => '*some*', # also 'hans+huber' possible
        Valid  => 1,        # (optional) default 1
        Limit  => 100,      # (optional) overrides limit of the config
    );

    # username search
    my %List = $CustomerUserObject->CustomerSearch(
        UserLogin => '*some*',
        Valid     => 1,         # (optional) default 1
    );

    # email search
    my %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => 'email@example.com',
        Valid            => 1,                    # (optional) default 1
    );

    # search by CustomerID
    my %List = $CustomerUserObject->CustomerSearch(
        CustomerID       => 'CustomerID123',
        Valid            => 1,                # (optional) default 1
    );

=cut

sub CustomerSearch {
    my ( $Self, %Param ) = @_;

    # remove leading and ending spaces
    if ( $Param{Search} ) {
        $Param{Search} =~ s/^\s+//;
        $Param{Search} =~ s/\s+$//;
    }

    # Get dynamic fiekd object.
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $DynamicFieldConfigs = $DynamicFieldObject->DynamicFieldListGet(
        ObjectType => 'CustomerUser',
        Valid      => 1,
    );

    my %DynamicFieldLookup = map { $_->{Name} => $_ } @{$DynamicFieldConfigs};

    # Get dynamic field backend object.
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # search dynamic field values, if configured
        my $Map = $Self->{"CustomerUser$Count"}->{CustomerUserMap}->{Map};
        if ( IsArrayRefWithData($Map) ) {

            # fetch dynamic field names that are configured in Map
            # only these will be considered for any other search config
            # [ 'DynamicField_Name_X', undef, 'Name_X', 0, 0, 'dynamic_field', undef, 0, undef, undef, ],
            my %DynamicFieldNames = map { $_->[2] => 1 } grep { $_->[5] eq 'dynamic_field' } @{$Map};

            if ( IsHashRefWithData( \%DynamicFieldNames ) ) {
                my $FoundDynamicFieldObjectIDs;
                my $SearchFields;
                my $SearchParam;

                # check which of the dynamic fields configured in Map are also
                # configured in SearchFields

                # param Search
                if ( defined $Param{Search} && length $Param{Search} ) {
                    $SearchFields = $Self->{"CustomerUser$Count"}->{CustomerUserMap}->{CustomerUserSearchFields};
                    $SearchParam  = $Param{Search};
                }

                # param PostMasterSearch
                elsif ( defined $Param{PostMasterSearch} && length $Param{PostMasterSearch} ) {
                    $SearchFields
                        = $Self->{"CustomerUser$Count"}->{CustomerUserMap}->{CustomerUserPostMasterSearchFields};
                    $SearchParam = $Param{PostMasterSearch};
                }

                # search dynamic field values
                if ( IsArrayRefWithData($SearchFields) ) {
                    my @SearchDynamicFieldNames = grep { exists $DynamicFieldNames{$_} } @{$SearchFields};
                    my @SearchDynamicFieldIDs;

                    my %FoundDynamicFieldObjectIDs;
                    FIELDNAME:
                    for my $FieldName (@SearchDynamicFieldNames) {

                        my $DynamicFieldConfig = $DynamicFieldLookup{$FieldName};

                        next FIELDNAME if !IsHashRefWithData($DynamicFieldConfig);

                        my $DynamicFieldValues = $DynamicFieldBackendObject->ValueSearch(
                            DynamicFieldConfig => $DynamicFieldConfig,
                            Search             => $SearchParam,
                        );

                        if ( IsArrayRefWithData($DynamicFieldValues) ) {
                            for my $DynamicFieldValue ( @{$DynamicFieldValues} ) {
                                $FoundDynamicFieldObjectIDs{ $DynamicFieldValue->{ObjectID} } = 1;
                            }
                        }
                    }

                    $FoundDynamicFieldObjectIDs = [ keys %FoundDynamicFieldObjectIDs ];
                }

                # execute backend search for found object IDs
                # this data is being merged with the following CustomerSearch call
                if ( IsArrayRefWithData($FoundDynamicFieldObjectIDs) ) {

                    my $ObjectNames = $DynamicFieldObject->ObjectMappingGet(
                        ObjectID   => $FoundDynamicFieldObjectIDs,
                        ObjectType => 'CustomerUser',
                    );

                    OBJECTNAME:
                    for my $ObjectName ( values %{$ObjectNames} ) {
                        next OBJECTNAME if exists $Data{$ObjectName};

                        my %SearchParam = %Param;
                        delete $SearchParam{Search};
                        delete $SearchParam{PostMasterSearch};

                        $SearchParam{UserLogin} = $ObjectName;

                        my %SubData = $Self->{"CustomerUser$Count"}->CustomerSearch(%SearchParam);

                        # UserLogin search does a wild-card search, but in this case only the
                        # exact matching user login is relevant
                        if ( IsHashRefWithData( \%SubData ) && exists $SubData{$ObjectName} ) {
                            %Data = (
                                $ObjectName => $SubData{$ObjectName},
                                %Data
                            );
                        }
                    }
                }
            }
        }

        # get customer search result of backend and merge it
        my %SubData = $Self->{"CustomerUser$Count"}->CustomerSearch(%Param);

        %Data = ( %SubData, %Data );
    }
    return %Data;
}

=head2 CustomerSearchDetail()

To find customer user in the system.

The search criteria are logically AND connected.
When a list is passed as criteria, the individual members are OR connected.
When an undef or a reference to an empty array is passed, then the search criteria
is ignored.

Returns either a list, as an arrayref, or a count of found customer user ids.
The count of results is returned when the parameter C<Result = 'COUNT'> is passed.

    my $CustomerUserIDsRef = $CustomerUserObject->CustomerSearchDetail(

        # all search fields possible which are defined in CustomerUser::EnhancedSearchFields
        UserLogin     => 'example*',                                    # (optional)
        UserFirstname => 'Firstn*',                                     # (optional)

        # special parameters
        CustomerCompanySearchCustomerIDs => [ 'example.com' ],          # (optional)
        ExcludeUserLogins                => [ 'example', 'doejohn' ],   # (optional)

        # array parameters are used with logical OR operator (all values are possible which
        are defined in the config selection hash for the field)
        UserCountry              => [ 'Austria', 'Germany', ],          # (optional)

        # DynamicFields
        #   At least one operator must be specified. Operators will be connected with AND,
        #       values in an operator with OR.
        #   You can also pass more than one argument to an operator: ['value1', 'value2']
        DynamicField_FieldNameX => {
            Equals            => 123,
            Like              => 'value*',                # "equals" operator with wildcard support
            GreaterThan       => '2001-01-01 01:01:01',
            GreaterThanEquals => '2001-01-01 01:01:01',
            SmallerThan       => '2002-02-02 02:02:02',
            SmallerThanEquals => '2002-02-02 02:02:02',
        }

        OrderBy => [ 'UserLogin', 'UserCustomerID' ],                   # (optional)
        # ignored if the result type is 'COUNT'
        # default: [ 'UserLogin' ]
        # (all search fields possible which are defined in
        CustomerUser::EnhancedSearchFields)

        # Additional information for OrderBy:
        # The OrderByDirection can be specified for each OrderBy attribute.
        # The pairing is made by the array indices.

        OrderByDirection => [ 'Down', 'Up' ],                          # (optional)
        # ignored if the result type is 'COUNT'
        # (Down | Up) Default: [ 'Down' ]

        Result => 'ARRAY' || 'COUNT',                                  # (optional)
        # default: ARRAY, returns an array of change ids
        # COUNT returns a scalar with the number of found changes

        Limit => 100,                                                  # (optional)
        # ignored if the result type is 'COUNT'
    );

Returns:

Result: 'ARRAY'

    @CustomerUserIDs = ( 1, 2, 3 );

Result: 'COUNT'

    $CustomerUserIDs = 10;

=cut

sub CustomerSearchDetail {
    my ( $Self, %Param ) = @_;

    # get all general search fields (without a restriction to a source)
    my @AllSearchFields = $Self->CustomerUserSearchFields();

    # generate a hash with the customer user sources which must be searched
    my %SearchCustomerUserSources;

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {
        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get the search fields for the current source
        my @SourceSearchFields = $Self->CustomerUserSearchFields(
            Source => "CustomerUser$Count",
        );
        my %LookupSourceSearchFields = map { $_->{Name} => 1 } @SourceSearchFields;

        # check if all search param exists in the search fields from the current source
        SEARCHFIELD:
        for my $SearchField (@AllSearchFields) {

            next SEARCHFIELD if !$Param{ $SearchField->{Name} };

            next SOURCE if !$LookupSourceSearchFields{ $SearchField->{Name} };
        }
        $SearchCustomerUserSources{"CustomerUser$Count"} = \@SourceSearchFields;
    }

    # set the default behaviour for the return type
    $Param{Result} ||= 'ARRAY';

    if ( $Param{Result} eq 'COUNT' ) {

        my $IDsCount = 0;

        SOURCE:
        for my $Source ( sort keys %SearchCustomerUserSources ) {
            next SOURCE if !$Self->{$Source};

            my $SubIDsCount = $Self->{$Source}->CustomerSearchDetail(
                %Param,
                SearchFields => $SearchCustomerUserSources{$Source},
            );

            return if !defined $SubIDsCount;

            $IDsCount += $SubIDsCount || 0;
        }
        return $IDsCount;
    }
    else {

        my @IDs;

        my $ResultCount = 0;

        SOURCE:
        for my $Source ( sort keys %SearchCustomerUserSources ) {
            next SOURCE if !$Self->{$Source};

            my $SubIDs = $Self->{$Source}->CustomerSearchDetail(
                %Param,
                SearchFields => $SearchCustomerUserSources{$Source},
            );

            return if !defined $SubIDs;

            next SOURCE if !IsArrayRefWithData($SubIDs);

            push @IDs, @{$SubIDs};

            $ResultCount++;
        }

        # if we have more then one search results from diffrent sources, we need a resorting
        # because of the merged single results
        if ( $ResultCount > 1 ) {

            my @UserDataList;

            for my $ID (@IDs) {

                my %UserData = $Self->CustomerUserDataGet(
                    User => $ID,
                );
                push @UserDataList, \%UserData;
            }

            my $OrderBy = 'UserLogin';
            if ( IsArrayRefWithData( $Param{OrderBy} ) ) {
                $OrderBy = $Param{OrderBy}->[0];
            }

            if ( IsArrayRefWithData( $Param{OrderByDirection} ) && $Param{OrderByDirection}->[0] eq 'Up' ) {
                @UserDataList = sort { lc( $a->{$OrderBy} ) cmp lc( $b->{$OrderBy} ) } @UserDataList;
            }
            else {
                @UserDataList = sort { lc( $b->{$OrderBy} ) cmp lc( $a->{$OrderBy} ) } @UserDataList;
            }

            if ( $Param{Limit} && scalar @UserDataList > $Param{Limit} ) {
                splice @UserDataList, $Param{Limit};
            }

            @IDs = map { $_->{UserLogin} } @UserDataList;
        }

        return \@IDs;
    }
}

=head2 CustomerUserSearchFields()

Get a list of the defined search fields (optional only the relevant fields for the given source).

    my @SeachFields = $CustomerUserObject->CustomerUserSearchFields(
        Source => 'CustomerUser', # optional, but important in the CustomerSearchDetail to get the right database fields
    );

Returns an array of hash references.

    @SeachFields = (
        {
            Name          => 'UserEmail',
            Label         => 'Email',
            Type          => 'Input',
            DatabaseField => 'mail',
        },
        {
            Name           => 'UserCountry',
            Label          => 'Country',
            Type           => 'Selection',
            SelectionsData => {
                'Germany'        => 'Germany',
                'United Kingdom' => 'United Kingdom',
                'United States'  => 'United States',
                ...
            },
            DatabaseField => 'country',
        },
        {
            Name          => 'DynamicField_SkypeAccountName',
            Label         => '',
            Type          => 'DynamicField',
            DatabaseField => 'SkypeAccountName',
        },
    );

=cut

sub CustomerUserSearchFields {
    my ( $Self, %Param ) = @_;

    # Get the search fields from all customer user maps (merge from all maps together).
    my @SearchFields;

    my %SearchFieldsExists;

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {
        next SOURCE if !$Self->{"CustomerUser$Count"};
        next SOURCE if $Param{Source} && $Param{Source} ne "CustomerUser$Count";

        ENTRY:
        for my $Entry ( @{ $Self->{"CustomerUser$Count"}->{CustomerUserMap}->{Map} } ) {

            my $SearchFieldName = $Entry->[0];

            next ENTRY if $SearchFieldsExists{$SearchFieldName};
            next ENTRY if $SearchFieldName =~ m{(Password|Pw)\d*$}smxi;

            # Remeber the already collected search field name.
            $SearchFieldsExists{$SearchFieldName} = 1;

            my %FieldConfig = $Self->GetFieldConfig(
                FieldName => $SearchFieldName,
                Source    => $Param{Source},     # to get the right database field for the given source
            );

            next SEARCHFIELDNAME if !%FieldConfig;

            my %SearchFieldData = (
                %FieldConfig,
                Name => $SearchFieldName,
            );

            my %SelectionsData = $Self->GetFieldSelections(
                FieldName => $SearchFieldName,
            );

            if ( $SearchFieldData{StorageType} eq 'dynamic_field' ) {
                $SearchFieldData{Type} = 'DynamicField';
            }
            elsif (%SelectionsData) {
                $SearchFieldData{Type}           = 'Selection';
                $SearchFieldData{SelectionsData} = \%SelectionsData;
            }
            else {
                $SearchFieldData{Type} = 'Input';
            }

            push @SearchFields, \%SearchFieldData;
        }
    }

    return @SearchFields;
}

=head2 GetFieldConfig()

This function collect some field config information from the customer user map.

    my %FieldConfig = $CustomerUserObject->GetFieldConfig(
        FieldName => 'UserEmail',
        Source    => 'CustomerUser', # optional
    );

Returns some field config information:

    my %FieldConfig = (
        Label         => 'Email',
        DatabaseField => 'email',
        StorageType   => 'var',
    );

=cut

sub GetFieldConfig {
    my ( $Self, %Param ) = @_;

    if ( !$Param{FieldName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need FieldName!"
        );
        return;
    }

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {
        next SOURCE if !$Self->{"CustomerUser$Count"};
        next SOURCE if $Param{Source} && $Param{Source} ne "CustomerUser$Count";

        # Search the right field and return some config information from the field.
        ENTRY:
        for my $Entry ( @{ $Self->{"CustomerUser$Count"}->{CustomerUserMap}->{Map} } ) {
            next ENTRY if $Param{FieldName} ne $Entry->[0];

            my %FieldConfig = (
                Label         => $Entry->[1],
                DatabaseField => $Entry->[2],
                StorageType   => $Entry->[5],
            );

            return %FieldConfig;
        }
    }

    return;
}

=head2 GetFieldSelections()

This function collect the selections for the given field name, if the field has some selections.

    my %SelectionsData = $CustomerUserObject->GetFieldSelections(
        FieldName => 'UserTitle',
    );

Returns the selections for the given field name (merged from all sources) or a empty hash:

    my %SelectionData = (
        'Mr.'  => 'Mr.',
        'Mrs.' => 'Mrs.',
    );

=cut

sub GetFieldSelections {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{FieldName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need FieldName!"
        );
        return;
    }

    my %SelectionsData;

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {
        next SOURCE if !$Self->{"CustomerUser$Count"};
        next SOURCE if !$Self->{"CustomerUser$Count"}->{CustomerUserMap}->{Selections}->{ $Param{FieldName} };

        %SelectionsData = (
            %SelectionsData, %{ $Self->{"CustomerUser$Count"}->{CustomerUserMap}->{Selections}->{ $Param{FieldName} } }
        );
    }

    # Make sure the encoding stamp is set.
    for my $Key ( sort keys %SelectionsData ) {
        $SelectionsData{$Key} = $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( $SelectionsData{$Key} );
    }

    # Default handling for field 'ValidID'.
    if ( !%SelectionsData && $Param{FieldName} =~ /^ValidID/i ) {
        %SelectionsData = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    }

    return %SelectionsData;
}

=head2 CustomerIDList()

return a list of with all known unique CustomerIDs of the registered customers users (no SearchTerm),
or a filtered list where the CustomerIDs must contain a search term.

    my @CustomerIDs = $CustomerUserObject->CustomerIDList(
        SearchTerm  => 'somecustomer',    # optional
        Valid       => 1,                 # optional
    );

=cut

sub CustomerIDList {
    my ( $Self, %Param ) = @_;

    my @Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer list result of backend and merge it
        push @Data, $Self->{"CustomerUser$Count"}->CustomerIDList(%Param);
    }

    # make entries unique
    my %Tmp;
    @Tmp{@Data} = undef;
    @Data = sort { lc $a cmp lc $b } keys %Tmp;

    return @Data;
}

=head2 CustomerName()

get customer user name

    my $Name = $CustomerUserObject->CustomerName(
        UserLogin => 'some-login',
    );

=cut

sub CustomerName {
    my ( $Self, %Param ) = @_;

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # Get customer name and return it.
        my $Name = $Self->{"CustomerUser$Count"}->CustomerName(%Param);
        if ($Name) {
            return $Name;
        }
    }
    return;
}

=head2 CustomerIDs()

get customer user customer ids

    my @CustomerIDs = $CustomerUserObject->CustomerIDs(
        User => 'some-login',
    );

=cut

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

    # get customer ids (stop after first source with results)
    my @CustomerIDs;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer ids from source
        my @SourceCustomerIDs = $Self->{"CustomerUser$Count"}->CustomerIDs(%Param);
        next SOURCE if !@SourceCustomerIDs;

        @CustomerIDs = @SourceCustomerIDs;
        last SOURCE;
    }

    # create hash with existing customer ids
    my %CustomerIDs = map { $_ => 1 } @CustomerIDs;

    # get related customer ids
    my @RelatedCustomerIDs = $Self->CustomerUserCustomerMemberList(
        CustomerUserID => $Param{User},
    );

    # add related customer ids if not found in source
    RELATEDCUSTOMERID:
    for my $RelatedCustomerID (@RelatedCustomerIDs) {
        next RELATEDCUSTOMERID if $CustomerIDs{$RelatedCustomerID};

        push @CustomerIDs, $RelatedCustomerID;
    }

    # return customer ids
    return @CustomerIDs;
}

=head2 CustomerUserDataGet()

get user data (UserLogin, UserFirstname, UserLastname, UserEmail, ...)

    my %User = $CustomerUserObject->CustomerUserDataGet(
        User => 'franz',
    );

=cut

sub CustomerUserDataGet {
    my ( $Self, %Param ) = @_;

    return if !$Param{User};

    # fetch dynamic field configurations for CustomerUser.
    my $DynamicFieldConfigs = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'CustomerUser',
        Valid      => 1,
    );

    my %DynamicFieldLookup = map { $_->{Name} => $_ } @{$DynamicFieldConfigs};

    # Get needed objects.
    my $ConfigObject              = $Kernel::OM->Get('Kernel::Config');
    my $CustomerCompanyObject     = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        my %Customer = $Self->{"CustomerUser$Count"}->CustomerUserDataGet(%Param);
        next SOURCE if !%Customer;

        # generate the full name and save it in the hash
        my $UserFullname = $Self->CustomerName(%Customer);

        # save the generated fullname in the hash.
        $Customer{UserFullname} = $UserFullname;

        # add preferences defaults
        my $Config = $ConfigObject->Get('CustomerPreferencesGroups');
        if ($Config) {
            KEY:
            for my $Key ( sort keys %{$Config} ) {

                next KEY if !defined $Config->{$Key}->{DataSelected};
                next KEY if defined $Customer{ $Config->{$Key}->{PrefKey} };

                # set default data
                $Customer{ $Config->{$Key}->{PrefKey} } = $Config->{$Key}->{DataSelected};
            }
        }

        # check if customer company support is enabled and get company data
        my %Company;
        if (
            $ConfigObject->Get("CustomerCompany")
            && $ConfigObject->Get("CustomerUser$Count")->{CustomerCompanySupport}
            )
        {
            %Company = $CustomerCompanyObject->CustomerCompanyGet(
                CustomerID => $Customer{UserCustomerID},
            );

            $Company{CustomerCompanyValidID} = $Company{ValidID};
        }

        # fetch dynamic field values
        if ( IsArrayRefWithData( $Self->{"CustomerUser$Count"}->{CustomerUserMap}->{Map} ) ) {
            CUSTOMERUSERFIELD:
            for my $CustomerUserField ( @{ $Self->{"CustomerUser$Count"}->{CustomerUserMap}->{Map} } ) {
                next CUSTOMERUSERFIELD if $CustomerUserField->[5] ne 'dynamic_field';
                next CUSTOMERUSERFIELD if !$DynamicFieldLookup{ $CustomerUserField->[2] };

                my $Value = $DynamicFieldBackendObject->ValueGet(
                    DynamicFieldConfig => $DynamicFieldLookup{ $CustomerUserField->[2] },
                    ObjectName         => $Customer{UserID},
                );

                $Customer{ $CustomerUserField->[0] } = $Value;
            }
        }

        # return customer data
        return (
            %Company,
            %Customer,
            Source        => "CustomerUser$Count",
            Config        => $ConfigObject->Get("CustomerUser$Count"),
            CompanyConfig => $ConfigObject->Get( $Company{Source} // 'CustomerCompany' ),
        );
    }

    return;
}

=head2 CustomerUserAdd()

to add new customer users

    my $UserLogin = $CustomerUserObject->CustomerUserAdd(
        Source         => 'CustomerUser', # CustomerUser source config
        UserFirstname  => 'Huber',
        UserLastname   => 'Manfred',
        UserCustomerID => 'A124',
        UserLogin      => 'mhuber',
        UserPassword   => 'some-pass', # not required
        UserEmail      => 'email@example.com',
        ValidID        => 1,
        UserID         => 123,
    );

=cut

sub CustomerUserAdd {
    my ( $Self, %Param ) = @_;

    # check data source
    if ( !$Param{Source} ) {
        $Param{Source} = 'CustomerUser';
    }

    # check if user exists
    if ( $Param{UserLogin} ) {
        my %User = $Self->CustomerUserDataGet( User => $Param{UserLogin} );
        if (%User) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $Kernel::OM->Get('Kernel::Language')
                    ->Translate( 'Customer user "%s" already exists.', $Param{UserLogin} ),
            );
            return;
        }
    }

    # store customer user data
    my $Result = $Self->{ $Param{Source} }->CustomerUserAdd(%Param);
    return if !$Result;

    # trigger event
    $Self->EventHandler(
        Event => 'CustomerUserAdd',
        Data  => {
            UserLogin => $Param{UserLogin},
            NewData   => \%Param,
        },
        UserID => $Param{UserID},
    );

    return $Result;

}

=head2 CustomerUserUpdate()

to update customer users

    $CustomerUserObject->CustomerUserUpdate(
        Source        => 'CustomerUser', # CustomerUser source config
        ID            => 'mh'            # current user login
        UserLogin     => 'mhuber',       # new user login
        UserFirstname => 'Huber',
        UserLastname  => 'Manfred',
        UserPassword  => 'some-pass',    # not required
        UserEmail     => 'email@example.com',
        ValidID       => 1,
        UserID        => 123,
    );

=cut

sub CustomerUserUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserLogin!"
        );
        return;
    }

    # check for UserLogin-renaming and if new UserLogin already exists...
    if ( $Param{ID} && ( lc $Param{UserLogin} ne lc $Param{ID} ) ) {
        my %User = $Self->CustomerUserDataGet( User => $Param{UserLogin} );
        if (%User) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $Kernel::OM->Get('Kernel::Language')
                    ->Translate( 'Customer user "%s" already exists.', $Param{UserLogin} ),
            );
            return;
        }
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{ID} || $Param{UserLogin} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserLogin}'!",
        );
        return;
    }

    my $Result = $Self->{ $User{Source} }->CustomerUserUpdate(%Param);
    return if !$Result;

    # trigger event
    $Self->EventHandler(
        Event => 'CustomerUserUpdate',
        Data  => {
            UserLogin => $Param{ID} || $Param{UserLogin},
            NewData   => \%Param,
            OldData   => \%User,
        },
        UserID => $Param{UserID},
    );

    return $Result;
}

=head2 SetPassword()

to set customer users passwords

    $CustomerUserObject->SetPassword(
        UserLogin => 'some-login',
        PW        => 'some-new-password'
    );

=cut

sub SetPassword {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'User UserLogin!'
        );
        return;
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{UserLogin} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserLogin}'!",
        );
        return;
    }
    return $Self->{ $User{Source} }->SetPassword(%Param);
}

=head2 GenerateRandomPassword()

generate a random password

    my $Password = $CustomerUserObject->GenerateRandomPassword();

    or

    my $Password = $CustomerUserObject->GenerateRandomPassword(
        Size => 16,
    );

=cut

sub GenerateRandomPassword {
    my ( $Self, %Param ) = @_;

    return $Self->{CustomerUser}->GenerateRandomPassword(%Param);
}

=head2 SetPreferences()

set customer user preferences

    $CustomerUserObject->SetPreferences(
        Key    => 'UserComment',
        Value  => 'some comment',
        UserID => 'some-login',
    );

=cut

sub SetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!'
        );
        return;
    }

    # Don't allow overwriting of native user data.
    my %Blacklisted = (
        UserID         => 1,
        UserLogin      => 1,
        UserPassword   => 1,
        UserFirstname  => 1,
        UserLastname   => 1,
        UserFullname   => 1,
        UserStreet     => 1,
        UserCity       => 1,
        UserZip        => 1,
        UserCountry    => 1,
        UserComment    => 1,
        UserCustomerID => 1,
        UserTitle      => 1,
        UserEmail      => 1,
        ChangeTime     => 1,
        ChangeBy       => 1,
        CreateTime     => 1,
        CreateBy       => 1,
        UserPhone      => 1,
        UserMobile     => 1,
        UserFax        => 1,
        UserMailString => 1,
        ValidID        => 1,
    );

    return 0 if $Blacklisted{ $Param{Key} };

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{UserID} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserID}'!",
        );
        return;
    }

    # call new api (2.4.8 and higher)
    if ( $Self->{ $User{Source} }->can('SetPreferences') ) {
        return $Self->{ $User{Source} }->SetPreferences(%Param);
    }

    # call old api
    return $Self->{PreferencesObject}->SetPreferences(%Param);
}

=head2 GetPreferences()

get customer user preferences

    my %Preferences = $CustomerUserObject->GetPreferences(
        UserID => 'some-login',
    );

=cut

sub GetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!'
        );
        return;
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{UserID} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserID}'!",
        );
        return;
    }

    # call new api (2.4.8 and higher)
    if ( $Self->{ $User{Source} }->can('GetPreferences') ) {
        return $Self->{ $User{Source} }->GetPreferences(%Param);
    }

    # call old api
    return $Self->{PreferencesObject}->GetPreferences(%Param);
}

=head2 SearchPreferences()

search in user preferences

    my %UserList = $CustomerUserObject->SearchPreferences(
        Key   => 'UserSomeKey',
        Value => 'SomeValue',   # optional, limit to a certain value/pattern
    );

=cut

sub SearchPreferences {
    my ( $Self, %Param ) = @_;

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer search result of backend and merge it
        # call new api (2.4.8 and higher)
        my %SubData;
        if ( $Self->{"CustomerUser$Count"}->can('SearchPreferences') ) {
            %SubData = $Self->{"CustomerUser$Count"}->SearchPreferences(%Param);
        }

        # call old api
        else {
            %SubData = $Self->{PreferencesObject}->SearchPreferences(%Param);
        }
        %Data = ( %SubData, %Data );
    }

    return %Data;
}

=head2 TokenGenerate()

generate a random token

    my $Token = $CustomerUserObject->TokenGenerate(
        UserID => 123,
    );

=cut

sub TokenGenerate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!"
        );
        return;
    }

    my $Token = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => 14,
    );

    # save token in preferences
    $Self->SetPreferences(
        Key    => 'UserToken',
        Value  => $Token,
        UserID => $Param{UserID},
    );

    return $Token;
}

=head2 TokenCheck()

check password token

    my $Valid = $CustomerUserObject>TokenCheck(
        Token  => $Token,
        UserID => 123,
    );

=cut

sub TokenCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Token} || !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Token and UserID!"
        );
        return;
    }

    # get preferences token
    my %Preferences = $Self->GetPreferences(
        UserID => $Param{UserID},
    );

    # check requested vs. stored token
    return if !$Preferences{UserToken};
    return if $Preferences{UserToken} ne $Param{Token};

    # reset password token
    $Self->SetPreferences(
        Key    => 'UserToken',
        Value  => '',
        UserID => $Param{UserID},
    );

    return 1;
}

=head2 CustomerUserCacheClear()

clear cache of customer user data

    $CustomerUserObject->CustomerUserCacheClear(
        UserLogin => 'mhuber',
    );

=cut

sub CustomerUserCacheClear {
    my ( $Self, %Param ) = @_;

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};
        $Self->{"CustomerUser$Count"}->_CustomerUserCacheClear(
            UserLogin => $Param{UserLogin},
        );
    }

    return 1;
}

=head2 CustomerUserCustomerMemberAdd()

to add a customer user to a customer

    my $Success = $CustomerUserObject->CustomerUserCustomerMemberAdd(
        CustomerUserID => 123,
        CustomerID     => 123,
        Active         => 1,        # optional
        UserID         => 123,
    );

=cut

sub CustomerUserCustomerMemberAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CustomerUserID CustomerID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # delete affected caches
    my $CacheKey = 'Cache::CustomerUserCustomerMemberList::';
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => $CacheKey . 'CustomerUserID::' . $Param{CustomerUserID},
    );
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => $CacheKey . 'CustomerID::' . $Param{CustomerID},
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete existing relation
    return if !$DBObject->Do(
        SQL => 'DELETE FROM customer_user_customer
            WHERE user_id = ?
            AND customer_id = ?',
        Bind => [ \$Param{CustomerUserID}, \$Param{CustomerID} ],
    );

    # return if relation is not active
    return 1 if !$Param{Active};

    # insert new relation
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO customer_user_customer (user_id, customer_id, create_time, create_by,
            change_time, change_by)
            VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [ \$Param{CustomerUserID}, \$Param{CustomerID}, \$Param{UserID}, \$Param{UserID}, ],
    );

    return 1;
}

=head2 CustomerUserCustomerMemberList()

get related customer IDs of a customer user

    my @CustomerIDs = $CustomerUserObject->CustomerUserCustomerMemberList(
        CustomerUserID => 123,
    );

Returns:
    @CustomerIDs = (
        '123',
        '456',
    );

get related customer users of a customer ID

    my @CustomerUsers = $CustomerUserObject->CustomerUserCustomerMemberList(
        CustomerID => 123,
    );

Returns:
    @CustomerUsers = (
        '123',
        '456',
    );

=cut

sub CustomerUserCustomerMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{CustomerUserID} && !$Param{CustomerID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no CustomerUserID or CustomerID!',
        );
        return;
    }

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $CacheKey = 'Cache::CustomerUserCustomerMemberList::';

    if ( $Param{CustomerUserID} ) {

        # check if this result is present (in cache)
        $CacheKey .= 'CustomerUserID::' . $Param{CustomerUserID};
        my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        return @{$Cache} if $Cache;

        # get customer ids
        return if !$DBObject->Prepare(
            SQL =>
                'SELECT customer_id
                FROM customer_user_customer
                WHERE user_id = ?
                ORDER BY customer_id',
            Bind => [ \$Param{CustomerUserID}, ],
        );

        # fetch the result
        my @CustomerIDs;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @CustomerIDs, $Row[0];
        }

        # cache the result
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => \@CustomerIDs,

        );

        return @CustomerIDs;
    }
    else {

        # check if this result is present (in cache)
        $CacheKey .= 'CustomerID::' . $Param{CustomerID};
        my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        return @{$Cache} if $Cache;

        # get customer users
        return if !$DBObject->Prepare(
            SQL =>
                'SELECT user_id
                FROM customer_user_customer WHERE
                customer_id = ?
                ORDER BY user_id',
            Bind => [ \$Param{CustomerID}, ],
        );

        # fetch the result
        my @CustomerUserIDs;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @CustomerUserIDs, $Row[0];
        }

        # cache the result
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => \@CustomerUserIDs,
        );

        return @CustomerUserIDs;
    }
}

sub DESTROY {
    my $Self = shift;

    # execute all transaction events
    $Self->EventHandlerTransaction();

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
