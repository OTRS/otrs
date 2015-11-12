# --
# DynamicFieldSet.t - DynamicFieldSet testscript
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $HelperObject       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $DBObject           = $Kernel::OM->Get('Kernel::System::DB');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $UserObject         = $Kernel::OM->Get('Kernel::System::User');
my $ModuleObject       = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::DynamicFieldSet');

# define variables
my $UserID          = 1;
my $ModuleName      = 'DynamicFieldSet';
my $NumericRandomID = int rand 1000_000;
my $DFName1         = 'Test1' . $NumericRandomID;
my $DFName2         = 'Test2' . $NumericRandomID;

# set user details
my $TestUserLogin = $HelperObject->TestUserCreate();
my $TestUserID    = $UserObject->UserLookup(
    UserLogin => $TestUserLogin,
);

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
    {
        Name   => 'Correct Ticket->Queue Dropdown',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                $DFName1 => '<OTRS_TICKET_Queue>',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->Queue + Ticket->QueueID Dropdown',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                $DFName1 => '<OTRS_TICKET_Queue> <OTRS_TICKET_QueueID>',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->NotExisting Dropdown',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                $DFName1 => '<OTRS_TICKET_NotExisting>',
            },
        },
        NoValue => 1,
        Success => 1,
    },
    {
        Name   => 'Correct Using Different UserID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                $DFName1 => 'Test',
                UserID   => $TestUserID,
            },
        },
        Success => 1,
    },
);

TEST:
for my $Test (@Tests) {

    # make a deep copy to avoid changing the definition
    my $OrigTest = Storable::dclone($Test);

    my $Success = $ModuleObject->Run(
        %{ $Test->{Config} },
        ProcessEntityID          => 'P1',
        ActivityEntityID         => 'A1',
        TransitionEntityID       => 'T1',
        TransitionActionEntityID => 'TA1',
    );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | executed with False"
        );
        next TEST;
    }

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

        if ( $Test->{NoValue} ) {
            $Self->False(
                defined $Ticket{ 'DynamicField_' . $Attribute },
                "$ModuleName - Test:'$Test->{Name}' | Attribute: DynamicField_" . $Attribute
                    . " for TicketID: $TicketID exists with True",
            );
            next TEST;
        }

        $Self->True(
            defined $Ticket{ 'DynamicField_' . $Attribute },
            "$ModuleName - Test:'$Test->{Name}' | Attribute: DynamicField_" . $Attribute
                . " for TicketID: $TicketID exists with True",
        );

        my $ExpectedValue = $Test->{Config}->{Config}->{$Attribute};
        if (
            $OrigTest->{Config}->{Config}->{$Attribute}
            =~ m{\A<OTRS_TICKET_([A-Za-z0-9_]+)>\z}msx
            )
        {
            $ExpectedValue = $Ticket{$1} // '';
            $Self->IsNot(
                $Test->{Config}->{Config}->{$Attribute},
                $OrigTest->{Config}->{Config}->{$Attribute},
                "$ModuleName - Test:'$Test->{Name}' | Attribute: DynamicField_$Attribute value: $OrigTest->{Config}->{Config}->{$Attribute} should been replaced",
            );
        }
        elsif (
            $OrigTest->{Config}->{Config}->{$Attribute}
            =~ m{\A<OTRS_TICKET_([A-Za-z0-9_]+)> [ ] <OTRS_TICKET_([A-Za-z0-9_]+)>\z}msx
            )
        {
            $ExpectedValue = ( $Ticket{$1} // '' ) . ' ' . ( $Ticket{$2} // '' );
            $Self->IsNot(
                $Test->{Config}->{Config}->{$Attribute},
                $OrigTest->{Config}->{Config}->{$Attribute},
                "$ModuleName - Test:'$Test->{Name}' | Attribute: DynamicField_$Attribute value: $OrigTest->{Config}->{Config}->{$Attribute} should been replaced",
            );
        }

        $Self->Is(
            $Ticket{ 'DynamicField_' . $Attribute },
            $ExpectedValue,
            "$ModuleName - Test:'$Test->{Name}' | Attribute: DynamicField_" . $Attribute
                . " for TicketID: $TicketID match expected value",
        );
    }

    if ( $OrigTest->{Config}->{Config}->{UserID} ) {
        $Self->Is(
            $Test->{Config}->{Config}->{UserID},
            undef,
            "$ModuleName - Test:'$Test->{Name}' | Attribute: UserID for TicketID:"
                . " $TicketID should be removed (as it was used)",
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
