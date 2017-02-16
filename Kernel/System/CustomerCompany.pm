# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerCompany;

use strict;
use warnings;

use base qw(Kernel::System::EventHandler);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Main',
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

sub DESTROY {
    my $Self = shift;

    # execute all transaction events
    $Self->EventHandlerTransaction();

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
