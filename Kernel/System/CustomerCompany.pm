# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CustomerCompany;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::EventHandler);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::ReferenceData',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::CustomerCompany - customer company lib

=head1 DESCRIPTION

All Customer functions. E.g. to add and update customer companies.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

    # load customer company backend modules
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$ConfigObject->Get("CustomerCompany$Count");

        my $GenericModule = $ConfigObject->Get("CustomerCompany$Count")->{Module}
            || 'Kernel::System::CustomerCompany::DB';
        if ( !$MainObject->Require($GenericModule) ) {
            $MainObject->Die("Can't load backend module $GenericModule! $@");
        }
        $Self->{"CustomerCompany$Count"} = $GenericModule->new(
            Count              => $Count,
            CustomerCompanyMap => $ConfigObject->Get("CustomerCompany$Count"),
        );
    }

    # init of event handler
    $Self->EventHandlerInit(
        Config => 'CustomerCompany::EventModulePost',
    );

    return $Self;
}

=head2 CustomerCompanyAdd()

add a new customer company

    my $ID = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID              => 'example.com',
        CustomerCompanyName     => 'New Customer Inc.',
        CustomerCompanyStreet   => '5201 Blue Lagoon Drive',
        CustomerCompanyZIP      => '33126',
        CustomerCompanyCity     => 'Miami',
        CustomerCompanyCountry  => 'USA',
        CustomerCompanyURL      => 'http://www.example.org',
        CustomerCompanyComment  => 'some comment',
        ValidID                 => 1,
        UserID                  => 123,
    );

NOTE: Actual fields accepted by this API call may differ based on
CustomerCompany mapping in your system configuration.

=cut

sub CustomerCompanyAdd {
    my ( $Self, %Param ) = @_;

    # check data source
    if ( !$Param{Source} ) {
        $Param{Source} = 'CustomerCompany';
    }

    # check needed stuff
    for (qw(CustomerID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # store customer company data
    my $Result = $Self->{ $Param{Source} }->CustomerCompanyAdd(%Param);
    return if !$Result;

    # trigger event
    $Self->EventHandler(
        Event => 'CustomerCompanyAdd',
        Data  => {
            CustomerID => $Param{CustomerID},
            NewData    => \%Param,
        },
        UserID => $Param{UserID},
    );

    return $Result;
}

=head2 CustomerCompanyGet()

get customer company attributes

    my %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => 123,
    );

Returns:

    %CustomerCompany = (
        'CustomerCompanyName'    => 'Customer Inc.',
        'CustomerID'             => 'example.com',
        'CustomerCompanyStreet'  => '5201 Blue Lagoon Drive',
        'CustomerCompanyZIP'     => '33126',
        'CustomerCompanyCity'    => 'Miami',
        'CustomerCompanyCountry' => 'United States',
        'CustomerCompanyURL'     => 'http://example.com',
        'CustomerCompanyComment' => 'Some Comments',
        'ValidID'                => '1',
        'CreateTime'             => '2010-10-04 16:35:49',
        'ChangeTime'             => '2010-10-04 16:36:12',
    );

NOTE: Actual fields returned by this API call may differ based on
CustomerCompany mapping in your system configuration.

=cut

sub CustomerCompanyGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{CustomerID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CustomerID!"
        );
        return;
    }

    # Fetch dynamic field configurations for CustomerCompany.
    my $DynamicFieldConfigs = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        ObjectType => 'CustomerCompany',
        Valid      => 1,
    );

    my %DynamicFieldLookup = map { $_->{Name} => $_ } @{$DynamicFieldConfigs};

    # get needed objects
    my $ConfigObject              = $Kernel::OM->Get('Kernel::Config');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerCompany$Count"};

        my %Company = $Self->{"CustomerCompany$Count"}->CustomerCompanyGet( %Param, );
        next SOURCE if !%Company;

        # fetch dynamic field values
        if ( IsArrayRefWithData( $Self->{"CustomerCompany$Count"}->{CustomerCompanyMap}->{Map} ) ) {
            CUSTOMERCOMPANYFIELD:
            for my $CustomerCompanyField ( @{ $Self->{"CustomerCompany$Count"}->{CustomerCompanyMap}->{Map} } ) {
                next CUSTOMERCOMPANYFIELD if $CustomerCompanyField->[5] ne 'dynamic_field';
                next CUSTOMERCOMPANYFIELD if !$DynamicFieldLookup{ $CustomerCompanyField->[2] };

                my $Value = $DynamicFieldBackendObject->ValueGet(
                    DynamicFieldConfig => $DynamicFieldLookup{ $CustomerCompanyField->[2] },
                    ObjectName         => $Company{CustomerID},
                );

                $Company{ $CustomerCompanyField->[0] } = $Value;
            }
        }

        # return company data
        return (
            %Company,
            Source => "CustomerCompany$Count",
            Config => $ConfigObject->Get("CustomerCompany$Count"),
        );
    }

    return;
}

=head2 CustomerCompanyUpdate()

update customer company attributes

    $CustomerCompanyObject->CustomerCompanyUpdate(
        CustomerCompanyID       => 'oldexample.com', # required for CustomerCompanyID-update
        CustomerID              => 'example.com',
        CustomerCompanyName     => 'New Customer Inc.',
        CustomerCompanyStreet   => '5201 Blue Lagoon Drive',
        CustomerCompanyZIP      => '33126',
        CustomerCompanyLocation => 'Miami',
        CustomerCompanyCountry  => 'USA',
        CustomerCompanyURL      => 'http://example.com',
        CustomerCompanyComment  => 'some comment',
        ValidID                 => 1,
        UserID                  => 123,
    );

=cut

sub CustomerCompanyUpdate {
    my ( $Self, %Param ) = @_;

    $Param{CustomerCompanyID} ||= $Param{CustomerID};

    # check needed stuff
    if ( !$Param{CustomerCompanyID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CustomerCompanyID or CustomerID!"
        );
        return;
    }

    # check if company exists
    my %Company = $Self->CustomerCompanyGet( CustomerID => $Param{CustomerCompanyID} );
    if ( !%Company ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such company '$Param{CustomerCompanyID}'!",
        );
        return;
    }

    my $Result = $Self->{ $Company{Source} }->CustomerCompanyUpdate(%Param);
    return if !$Result;

    # trigger event
    $Self->EventHandler(
        Event => 'CustomerCompanyUpdate',
        Data  => {
            CustomerID    => $Param{CustomerID},
            OldCustomerID => $Param{CustomerCompanyID},
            NewData       => \%Param,
            OldData       => \%Company,
        },
        UserID => $Param{UserID},
    );
    return $Result;
}

=head2 CustomerCompanySourceList()

return customer company source list

    my %List = $CustomerCompanyObject->CustomerCompanySourceList(
        ReadOnly => 0 # optional, 1 returns only RO backends, 0 returns writable, if not passed returns all backends
    );

=cut

sub CustomerCompanySourceList {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$ConfigObject->Get("CustomerCompany$Count");

        if ( defined $Param{ReadOnly} ) {
            my $BackendConfig = $ConfigObject->Get("CustomerCompany$Count");
            if ( $Param{ReadOnly} ) {
                next SOURCE if !$BackendConfig->{ReadOnly};
            }
            else {
                next SOURCE if $BackendConfig->{ReadOnly};
            }
        }

        $Data{"CustomerCompany$Count"} = $ConfigObject->Get("CustomerCompany$Count")->{Name}
            || "No Name $Count";
    }

    return %Data;
}

=head2 CustomerCompanyList()

get list of customer companies.

    my %List = $CustomerCompanyObject->CustomerCompanyList();

    my %List = $CustomerCompanyObject->CustomerCompanyList(
        Valid => 0,
        Limit => 0,     # optional, override configured search result limit (0 means unlimited)
    );

    my %List = $CustomerCompanyObject->CustomerCompanyList(
        Search => 'somecompany',
    );

Returns:

    %List = {
        'example.com' => 'example.com Customer Inc.',
        'acme.com'    => 'acme.com Acme, Inc.'
    };

=cut

sub CustomerCompanyList {
    my ( $Self, %Param ) = @_;

    # Get dynamic field object.
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $DynamicFieldConfigs = $DynamicFieldObject->DynamicFieldListGet(
        ObjectType => 'CustomerCompany',
        Valid      => 1,
    );

    my %DynamicFieldLookup = map { $_->{Name} => $_ } @{$DynamicFieldConfigs};

    # Get dynamic field backend object.
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerCompany$Count"};

        # search dynamic field values, if configured
        my $Map = $Self->{"CustomerCompany$Count"}->{CustomerCompanyMap}->{Map};
        if ( IsArrayRefWithData($Map) ) {

            # fetch dynamic field names that are configured in Map
            # only these will be considered for any other search config
            # [ 'DynamicField_Name_Y', undef, 'Name_Y', 0, 0, 'dynamic_field', undef, 0,],
            my %DynamicFieldNames = map { $_->[2] => 1 } grep { $_->[5] eq 'dynamic_field' } @{$Map};

            if (%DynamicFieldNames) {
                my $FoundDynamicFieldObjectIDs;
                my $SearchFields;
                my $SearchParam;

                # check which of the dynamic fields configured in Map are also
                # configured in SearchFields

                # param Search
                if ( defined $Param{Search} && length $Param{Search} ) {
                    $SearchFields
                        = $Self->{"CustomerCompany$Count"}->{CustomerCompanyMap}->{CustomerCompanySearchFields};
                    $SearchParam = $Param{Search};
                }

                # search dynamic field values
                if ( IsArrayRefWithData($SearchFields) ) {
                    my @SearchDynamicFieldNames = grep { exists $DynamicFieldNames{$_} } @{$SearchFields};

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
                # this data is being merged with the following CustomerCompanyList call
                if ( IsArrayRefWithData($FoundDynamicFieldObjectIDs) ) {

                    my $ObjectNames = $DynamicFieldObject->ObjectMappingGet(
                        ObjectID   => $FoundDynamicFieldObjectIDs,
                        ObjectType => 'CustomerCompany',
                    );

                    my %SearchParam = %Param;
                    delete $SearchParam{Search};
                    my %CompanyList = $Self->{"CustomerCompany$Count"}->CustomerCompanyList(%SearchParam);

                    OBJECTNAME:
                    for my $ObjectName ( values %{$ObjectNames} ) {
                        next OBJECTNAME if exists $Data{$ObjectName};

                        if ( IsHashRefWithData( \%CompanyList ) && exists $CompanyList{$ObjectName} ) {
                            %Data = (
                                $ObjectName => $CompanyList{$ObjectName},
                                %Data
                            );
                        }
                    }
                }
            }
        }

        # get company list result of backend and merge it
        my %SubData = $Self->{"CustomerCompany$Count"}->CustomerCompanyList(%Param);
        %Data = ( %Data, %SubData );
    }
    return %Data;
}

=head2 CustomerCompanySearchDetail()

To find customer companies in the system.

The search criteria are logically AND connected.
When a list is passed as criteria, the individual members are OR connected.
When an undef or a reference to an empty array is passed, then the search criteria
is ignored.

Returns either a list, as an arrayref, or a count of found customer company ids.
The count of results is returned when the parameter C<Result = 'COUNT'> is passed.

    my $CustomerCompanyIDsRef = $CustomerCompanyObject->CustomerCompanySearchDetail(

        # all search fields possible which are defined in CustomerCompany::EnhancedSearchFields
        CustomerID          => 'example*',                                  # (optional)
        CustomerCompanyName => 'Name*',                                     # (optional)

        # array parameters are used with logical OR operator (all values are possible which
        are defined in the config selection hash for the field)
        CustomerCompanyCountry => [ 'Austria', 'Germany', ],                # (optional)

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

        OrderBy => [ 'CustomerID', 'CustomerCompanyCountry' ],              # (optional)
        # ignored if the result type is 'COUNT'
        # default: [ 'CustomerID' ]
        # (all search fields possible which are defined in
        CustomerCompany::EnhancedSearchFields)

        # Additional information for OrderBy:
        # The OrderByDirection can be specified for each OrderBy attribute.
        # The pairing is made by the array indices.

        OrderByDirection => [ 'Down', 'Up' ],                               # (optional)
        # ignored if the result type is 'COUNT'
        # (Down | Up) Default: [ 'Down' ]

        Result => 'ARRAY' || 'COUNT',                                       # (optional)
        # default: ARRAY, returns an array of change ids
        # COUNT returns a scalar with the number of found changes

        Limit => 100,                                                       # (optional)
        # ignored if the result type is 'COUNT'
    );

Returns:

Result: 'ARRAY'

    @CustomerIDs = ( 1, 2, 3 );

Result: 'COUNT'

    $CustomerIDs = 10;

=cut

sub CustomerCompanySearchDetail {
    my ( $Self, %Param ) = @_;

    # Get all general search fields (without a restriction to a source).
    my @AllSearchFields = $Self->CustomerCompanySearchFields();

    # Generate a hash with the customer company sources which must be searched.
    my %SearchCustomerCompanySources;

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {
        next SOURCE if !$Self->{"CustomerCompany$Count"};

        # Get the search fields for the current source.
        my @SourceSearchFields = $Self->CustomerCompanySearchFields(
            Source => "CustomerCompany$Count",
        );
        my %LookupSourceSearchFields = map { $_->{Name} => 1 } @SourceSearchFields;

        # Check if all search param exists in the search fields from the current source.
        SEARCHFIELD:
        for my $SearchField (@AllSearchFields) {

            next SEARCHFIELD if !$Param{ $SearchField->{Name} };

            next SOURCE if !$LookupSourceSearchFields{ $SearchField->{Name} };
        }
        $SearchCustomerCompanySources{"CustomerCompany$Count"} = \@SourceSearchFields;
    }

    # Set the default behaviour for the return type.
    $Param{Result} ||= 'ARRAY';

    if ( $Param{Result} eq 'COUNT' ) {

        my $IDsCount = 0;

        SOURCE:
        for my $Source ( sort keys %SearchCustomerCompanySources ) {
            next SOURCE if !$Self->{$Source};

            my $SubIDsCount = $Self->{$Source}->CustomerCompanySearchDetail(
                %Param,
                SearchFields => $SearchCustomerCompanySources{$Source},
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
        for my $Source ( sort keys %SearchCustomerCompanySources ) {
            next SOURCE if !$Self->{$Source};

            my $SubIDs = $Self->{$Source}->CustomerCompanySearchDetail(
                %Param,
                SearchFields => $SearchCustomerCompanySources{$Source},
            );

            return if !defined $SubIDs;

            next SOURCE if !IsArrayRefWithData($SubIDs);

            push @IDs, @{$SubIDs};

            $ResultCount++;
        }

        # If we have more then one search results from diffrent sources, we need a resorting
        #   and splice (for the limit) because of the merged single results.
        if ( $ResultCount > 1 ) {

            my @CustomerCompanyataList;

            for my $ID (@IDs) {

                my %CustomerCompanyData = $Self->CustomerCompanyGet(
                    CustomerID => $ID,
                );
                push @CustomerCompanyataList, \%CustomerCompanyData;
            }

            my $OrderBy = 'CustomerID';
            if ( IsArrayRefWithData( $Param{OrderBy} ) ) {
                $OrderBy = $Param{OrderBy}->[0];
            }

            if ( IsArrayRefWithData( $Param{OrderByDirection} ) && $Param{OrderByDirection}->[0] eq 'Up' ) {
                @CustomerCompanyataList
                    = sort { lc( $a->{$OrderBy} ) cmp lc( $b->{$OrderBy} ) } @CustomerCompanyataList;
            }
            else {
                @CustomerCompanyataList
                    = sort { lc( $b->{$OrderBy} ) cmp lc( $a->{$OrderBy} ) } @CustomerCompanyataList;
            }

            if ( $Param{Limit} && scalar @CustomerCompanyataList > $Param{Limit} ) {
                splice @CustomerCompanyataList, $Param{Limit};
            }

            @IDs = map { $_->{CustomerID} } @CustomerCompanyataList;
        }

        return \@IDs;
    }
}

=head2 CustomerCompanySearchFields()

Get a list of defined search fields (optional only the relevant fields for the given source).

    my @SeachFields = $CustomerCompanyObject->CustomerCompanySearchFields(
        Source => 'CustomerCompany', # optional, but important in the CustomerCompanySearchDetail to get the right database fields
    );

Returns an array of hash references.

    @SeachFields = (
        {
            Name  => 'CustomerID',
            Label => 'CustomerID',
            Type  => 'Input',
        },
        {
            Name           => 'CustomerCompanyCountry',
            Label          => 'Country',
            Type           => 'Selection',
            SelectionsData => {
                'Germany'        => 'Germany',
                'United Kingdom' => 'United Kingdom',
                'United States'  => 'United States',
                ...
            },
        },
        {
            Name          => 'DynamicField_Branch',
            Label         => '',
            Type          => 'DynamicField',
            DatabaseField => 'Branch',
        },
    );

=cut

sub CustomerCompanySearchFields {
    my ( $Self, %Param ) = @_;

    # Get the search fields from all customer company maps (merge from all maps together).
    my @SearchFields;

    my %SearchFieldsExists;

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {
        next SOURCE if !$Self->{"CustomerCompany$Count"};
        next SOURCE if $Param{Source} && $Param{Source} ne "CustomerCompany$Count";

        ENTRY:
        for my $Entry ( @{ $Self->{"CustomerCompany$Count"}->{CustomerCompanyMap}->{Map} } ) {

            my $SearchFieldName = $Entry->[0];

            next ENTRY if $SearchFieldsExists{$SearchFieldName};

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

    my %FieldConfig = $CustomerCompanyObject->GetFieldConfig(
        FieldName => 'CustomerCompanyName',
        Source    => 'CustomerCompany', # optional
    );

Returns some field config information:

    my %FieldConfig = (
        Label         => 'Name',
        DatabaseField => 'name',
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
        next SOURCE if !$Self->{"CustomerCompany$Count"};
        next SOURCE if $Param{Source} && $Param{Source} ne "CustomerCompany$Count";

        # Search the right field and return the label.
        ENTRY:
        for my $Entry ( @{ $Self->{"CustomerCompany$Count"}->{CustomerCompanyMap}->{Map} } ) {
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

    my %SelectionsData = $CustomerCompanyObject->GetFieldSelections(
        FieldName => 'CustomerCompanyCountry',
    );

Returns the selections for the given field name (merged from all sources) or a empty hash:

    my %SelectionData = (
        'Germany'        => 'Germany',
        'United Kingdom' => 'United Kingdom',
        'United States'  => 'United States',
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
        next SOURCE if !$Self->{"CustomerCompany$Count"};
        next SOURCE if !$Self->{"CustomerCompany$Count"}->{CustomerCompanyMap}->{Selections}->{ $Param{FieldName} };

        %SelectionsData = (
            %SelectionsData,
            %{ $Self->{"CustomerCompany$Count"}->{CustomerCompanyMap}->{Selections}->{ $Param{FieldName} } }
        );
    }

    # Make sure the encoding stamp is set.
    for my $Key ( sort keys %SelectionsData ) {
        $SelectionsData{$Key} = $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( $SelectionsData{$Key} );
    }

    # Default handling for field 'CustomerCompanyCountry'.
    if ( !%SelectionsData && $Param{FieldName} =~ /^CustomerCompanyCountry/i ) {
        %SelectionsData = %{ $Kernel::OM->Get('Kernel::System::ReferenceData')->CountryList() };
    }

    # Default handling for field 'ValidID'.
    elsif ( !%SelectionsData && $Param{FieldName} =~ /^ValidID/i ) {
        %SelectionsData = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    }

    return %SelectionsData;
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
