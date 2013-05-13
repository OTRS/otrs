# --
# DynamicFieldSet.t - DynamicFieldSet testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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
use Kernel::System::ProcessManagement::TransitionAction::DynamicFieldSet;

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
my $ModuleObject = Kernel::System::ProcessManagement::TransitionAction::DynamicFieldSet->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    TicketObject => $TicketObject,
);

# define variables
my $UserID          = 1;
my $ModuleName      = 'DynamicFieldSet';
my $NumericRandomID = int rand 1000_000;
my $DFName1         = 'Test1' . $NumericRandomID;
my $DFName2         = 'Test2' . $NumericRandomID;

# ----------------------------------------
# Create the dynamic fields for testing
# ----------------------------------------

my @NewDynamicFieldConfig = (
    {
        Name       => $DFName1,
        Label      => $DFName1,
        FieldType  => 'Dropdown',
        ObjectType => 'Ticket',
        Config     => {
            TranslatableValues => '0',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
                3 => 'C',
            },
        },
    },
    {
        Name       => $DFName2,
        Label      => $DFName2,
        FieldType  => 'Checkbox',
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
                $DFName1 => 1,
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
                $DFName1 => 1,
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
                $DFName1 => '1',
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

    #    {
    #        Name   => 'Wrong Field Value',
    #        Config => {
    #            UserID => $UserID,
    #            Ticket => \%Ticket,
    #            Config => {
    #                $DFName2 => 'TestString',
    #            },
    #        },
    #        Success => 0,
    #    },
    {
        Name   => 'Correct ASCII Dropdown',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                $DFName1 => 'TestString',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct ASCII Checkbox',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                $DFName2 => 1,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct ASCII Dropdown && Checkbox',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                $DFName1 => 1,
                $DFName2 => 0,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct UTF8 Dropdown',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                $DFName1 =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
            },
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $ModuleObject->Run(
        %{ $Test->{Config} },
        ProcessEntityID          => 'P1',
        ActivityEntityID         => 'A1',
        TransitionEntityID       => 'T1',
        TransitionActionEntityID => 'TA1',
    );

    if ( $Test->{Success} ) {

        $Self->True(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | excecuted with True"
        );

        # get ticket
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,
            UserID        => 1,
        );

        ATTRIBUTE:
        for my $Attribute ( sort keys %{ $Test->{Config}->{Config} } ) {

            $Self->True(
                defined $Ticket{ 'DynamicField_' . $Attribute },
                "$ModuleName - Test:'$Test->{Name}' | Attribute: DynamicField_" . $Attribute
                    . " for TicketID: $TicketID exists with True",
            );

            $Self->Is(
                $Ticket{ 'DynamicField_' . $Attribute },
                $Test->{Config}->{Config}->{$Attribute},
                "$ModuleName - Test:'$Test->{Name}' | Attribute: DynamicField_" . $Attribute
                    . " for TicketID: $TicketID match expected value",
            );
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
