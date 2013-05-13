# --
# TicketType.t - TicketTypeSet testscript
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
use Kernel::System::Type;
use Kernel::System::User;
use Kernel::System::ProcessManagement::TransitionAction::TicketTypeSet;

use Kernel::System::VariableCheck qw(:all);

# create local objects
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);
my $ConfigObject = Kernel::Config->new();

# enable ticket type for this run
$ConfigObject->Set(
    Key   => 'Ticket::Type',
    Value => 1,
);

# set TicketDynamicFieldDefault as no Transation mode to avoid error messages at the end of the
# test (regarding missing TicketIDs)
$ConfigObject->Set(
    Key   => 'Ticket::EventModulePost###TicketDynamicFieldDefault',
    Value => {
        Module      => 'Kernel::System::Ticket::Event::TicketDynamicFieldDefault',
        Transaction => 0,
    },
);

my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TypeObject = Kernel::System::Type->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ModuleObject = Kernel::System::ProcessManagement::TransitionAction::TicketTypeSet->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    TicketObject => $TicketObject,
);

# define variables
my $UserID     = 1;
my $ModuleName = 'TicketTypeSet';
my $RandomID   = $HelperObject->GetRandomID();

my $Type1Name = 'Type1' . $RandomID;
my $Type2Name = 'Type2' . $RandomID;
my $Type3Name = 'Type3' . $RandomID;

my $Type1ID = $TypeObject->TypeAdd(
    Name    => $Type1Name,
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $Type1ID,
    "TypeAdd() - $Type1Name",
);
my $Type2ID = $TypeObject->TypeAdd(
    Name    => $Type2Name,
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $Type2ID,
    "TypeAdd() - $Type2Name",
);
my $Type3ID = $TypeObject->TypeAdd(
    Name    => $Type3Name,
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $Type3ID,
    "TypeAdd() - $Type3Name",
);

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
    TypeID        => $Type1ID,
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
                Type => $Type2ID,
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
        Name   => 'Wrong Type',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Type => 'NotExisting' . $RandomID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong TypeID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                TypeID => 'NotExisting' . $RandomID,
            },
        },
        Success => 0,
    },
    {
        Name   => "Correct Type $Type2Name",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Type => $Type2Name,
            },
        },
        Success => 1,
    },
    {
        Name   => "Correct Type $Type3Name",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Type => $Type3Name,
            },
        },
        Success => 1,
    },
    {
        Name   => "Correct TypeID $Type2Name",
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                TypeID => $Type2ID,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct TypeID $Type3Name',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                TypeID => $Type3ID,
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
        %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        ATTRIBUTE:
        for my $Attribute ( sort keys %{ $Test->{Config}->{Config} } ) {

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

my @Types = (
    {
        ID   => $Type1ID,
        Name => $Type1Name,
    },
    {
        ID   => $Type2ID,
        Name => $Type2Name,
    },
    {
        ID   => $Type3ID,
        Name => $Type3Name,
    },
);

for my $TypeInfo (@Types) {
    my $Success = $TypeObject->TypeUpdate(
        ID      => $TypeInfo->{ID},
        Name    => $TypeInfo->{Name},
        ValidID => 2,
        UserID  => 1,
    );
    $Self->True(
        $Success,
        "TypeUpdate() - Set to invalid - $TypeInfo->{Name}",
    );
}

# ----------------------------------------

1;
