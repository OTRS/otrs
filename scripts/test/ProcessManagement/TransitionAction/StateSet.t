# --
# StateSet.t - StateSet testscript
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: StateSet.t,v 1.2 2012-09-10 03:15:37 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars qw($Self);

use Kernel::Config;
use Kernel::System::UnitTest::Helper;
use Kernel::System::Ticket;
use Kernel::System::DynamicField;
use Kernel::System::ProcessManagement::TransitionAction::StateSet;

use Kernel::System::VariableCheck qw(:all);

# create local objects
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);
my $ConfigObject = Kernel::Config->new();
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $DynamicFieldObject = Kernel::System::DynamicField->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $BackendObject = Kernel::System::DynamicField::Backend->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $ModuleObject = Kernel::System::ProcessManagement::TransitionAction::StateSet->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    TicketObject => $TicketObject,
);

# define variables
my $UserID     = 1;
my $ModuleName = 'StateSet';
my $RandomID   = $HelperObject->GetRandomID();

my $NumericRandomID = int rand 1000_000;
my $DFName1         = 'Test1' . $NumericRandomID;
my $DFValue1        = 'Test1';

# ----------------------------------------
# Create the dynamic fields for testing
# ----------------------------------------

my @NewDynamicFieldConfig = (
    {
        Name       => $DFName1,
        Label      => $DFName1,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue => '',
        },
    },
);

my @AddedDynamicFields;
for my $DynamicFieldConfig (@NewDynamicFieldConfig) {

    # add the new dynamic field
    my $ID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicFieldConfig},
        FieldOrder => 99999,
        ValidID    => 1,
        UserID     => 1,
    );

    push @AddedDynamicFields, $ID;

    # sanity check
    $Self->True(
        $ID,
        "DynamicFieldAdd() - DynamicField: $ID for DynamicFieldSet"
            . " checks with True",
    );
}

# ----------------------------------------

# ----------------------------------------
# Create a test ticket
# ----------------------------------------
my $TicketID = $TicketObject->TicketCreate(
    TN            => undef,
    Title         => 'test',
    QueueID       => 1,
    Lock          => 'unlock',
    Priority      => '3 normal',
    StateID       => 1,
    TypeID        => 1,
    Service       => undef,
    SLA           => undef,
    CustomerID    => undef,
    CustomerUser  => undef,
    OwnerID       => 1,
    ResponsibleID => 1,
    ArchiveFlag   => undef,
    UserID        => $UserID,
);

# sanity checks
$Self->True(
    $TicketID,
    "TicketCreate() - $TicketID",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => $UserID,
);
$Self->True(
    IsHashRefWithData( \%Ticket ),
    "TicketGet() - Get Ticket with ID $TicketID.",
);

# set dynamic field
my $Success = $BackendObject->ValueSet(
    DynamicFieldConfig => {
        %{ $NewDynamicFieldConfig[0] },
        ID => $AddedDynamicFields[0],
    },

    ObjectID => $TicketID,
    Value    => $DFValue1,
    UserID   => $UserID,
);

$Self->True(
    $Success,
    "DynamicFieldSet() - Set DynamicFIeld_" . $DFName1 . " to $DFValue1",
);

%Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
    UserID        => $UserID,
);
$Self->True(
    IsHashRefWithData( \%Ticket ),
    "TicketGet() - Get Ticket (Inc. Dynamic Fields) with ID $TicketID.",
);

# ----------------------------------------

# Run() tests
my @Tests = (
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name   => 'No UserID',
        Config => {
            UserID => undef,
            Ticket => \%Ticket,
            Config => {
                CustomerID => 'test',
            },
        },
        Success => 0,
    },
    {
        Name   => 'No Ticket',
        Config => {
            UserID => $UserID,
            Ticket => undef,
            Config => {
                CustomerID => 'test',
            },
        },
        Success => 0,
    },
    {
        Name   => 'No Config',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {},
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Config',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                NoAgentNotify => 0,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Ticket Format',
        Config => {
            UserID => $UserID,
            Ticket => 1,
            Config => {
                State => 'open',
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Config Format',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong State',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                State => 'NotExisting' . $RandomID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong StateID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                StateID => 'NotExisting' . $RandomID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing DynamicFieldMapping',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField => $DFName1,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing DynamicField',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField        => undef,
                DynamicFieldMapping => {
                    $DFValue1 => {
                        State => 'Open',
                    },
                },
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong DynamicFieldMapping format',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField        => $DFName1,
                DynamicFieldMapping => 1,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong State in DynamicField',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField        => $DFName1,
                DynamicFieldMapping => {
                    $DFValue1 => {
                        State => 'NotExisiting' . $RandomID,
                    },
                },
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong StateID in DynamicField',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField        => $DFName1,
                DynamicFieldMapping => {
                    $DFValue1 => {
                        StateID => 'NotExisiting' . $RandomID,
                    },
                },
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong DynamicFieldMapping',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField        => $DFName1,
                DynamicFieldMapping => {
                    $DFValue1 => {
                        Other => 'closed successful',
                    },
                },
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong DynamicField (Should Success)',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField        => 'Notexisting' . $NumericRandomID,
                DynamicFieldMapping => {
                    $DFValue1 => {
                        State => 'closed successful',
                    },
                },

            },
        },
        Success  => 1,
        NewValue => 0,
    },
    {
        Name   => 'Correct State',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                State => 'open',
            },
        },
        Success  => 1,
        NewValue => 1,
    },
    {
        Name   => 'Correct StateID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                StateID => 5,
            },
        },
        Success  => 1,
        NewValue => 1,
    },
    {
        Name   => 'Correct State in DynamicFieldMapping',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField        => $DFName1,
                DynamicFieldMapping => {
                    $DFValue1 => {
                        State => 'pending reminder',
                    },
                },
            },
        },
        Success  => 1,
        NewValue => 1,
    },
    {
        Name   => 'Correct StateID in DynamicFieldMapping',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField        => $DFName1,
                DynamicFieldMapping => {
                    $DFValue1 => {
                        StateID => 7,
                    },
                },
            },
        },
        Success  => 1,
        NewValue => 1,
    },
    {
        Name   => 'Correct State in DynamicFieldMapping Full DF Name',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField        => 'DynamicField_' . $DFName1,
                DynamicFieldMapping => {
                    $DFValue1 => {
                        State => 'pending reminder',
                    },
                },
            },
        },
        Success  => 1,
        NewValue => 1,
    },
    {
        Name   => 'Correct StateID in DynamicFieldMapping Full DF Name',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                DynamicField        => 'DynamicField_' . $DFName1,
                DynamicFieldMapping => {
                    $DFValue1 => {
                        StateID => 7,
                    },
                },
            },
        },
        Success  => 1,
        NewValue => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $ModuleObject->Run( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {

        $Self->True(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | excecuted with True"
        );

        # get ticket
        %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,
            UserID        => 1,
        );

        if ( $Test->{Config}->{Config}->{State} || $Test->{Config}->{Config}->{StateID} ) {

            ATTRIBUTE:
            for my $Attribute ( keys %{ $Test->{Config}->{Config} } ) {

                $Self->True(
                    $Ticket{$Attribute},
                    "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for TicketID:"
                        . " $TicketID exists with True",
                );

                $Self->Is(
                    $Ticket{$Attribute},
                    $Test->{Config}->{Config}->{$Attribute},
                    "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for TicketID:"
                        . " $TicketID match expected value",
                );
            }
        }
        else {

            ATTRIBUTE:
            for my $Attribute (
                keys %{ $Test->{Config}->{Config}->{DynamicFieldMapping}->{$DFValue1} }
                )
            {

                $Self->True(
                    $Ticket{$Attribute},
                    "$ModuleName - Test:'$Test->{Name}' | Attribute: $DFValue1 -> $Attribute for"
                        . " TicketID: $TicketID exists with True",
                );

                if ( $Test->{NewValue} ) {
                    $Self->Is(
                        $Ticket{$Attribute},
                        $Test->{Config}->{Config}->{DynamicFieldMapping}->{$DFValue1}->{$Attribute},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $DFValue1 -> $Attribute"
                            . " for TicketID: $TicketID match expected value",
                    );
                }
                else {
                    $Self->IsNot(
                        $Test->{Config}->{Config}->{DynamicFieldMapping}->{$DFValue1}->{$Attribute},
                        $Ticket{$Attribute},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $DFValue1 -> $Attribute"
                            . " for TicketID: $TicketID differs from expected value: "
                            . "'$Ticket{$Attribute}'",
                    );
                }
            }
        }
    }
    else {
        $Self->False(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | excecuted with False"
        );
    }
}

#-----------------------------------------
# Destructors to remove our Testitems
# ----------------------------------------

# Ticket
my $Delete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Delete,
    "TicketDelete() - $TicketID",
);

# DynamicFields
for my $ID (@AddedDynamicFields) {
    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID      => $ID,
        UserID  => 1,
        Reorder => 1,
    );

    $Self->True(
        $Success,
        "DynamicFieldDelete() - Remove DynamicField $ID from the system with True"
    );
}

# ----------------------------------------

1;
