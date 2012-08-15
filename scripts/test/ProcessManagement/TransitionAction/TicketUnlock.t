# --
# TicketUnlock.t - TicketUnlock testscript
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: TicketUnlock.t,v 1.1 2012-08-15 16:39:37 cr Exp $
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
use Kernel::System::ProcessManagement::TransitionAction::TicketUnlock;

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
my $ModuleObject = Kernel::System::ProcessManagement::TransitionAction::TicketUnlock->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    TicketObject => $TicketObject,
);

# define variables
my $UserID     = 1;
my $ModuleName = 'CustomerSet';

# ----------------------------------------
# Create a test ticket
# ----------------------------------------
my $TicketID = $TicketObject->TicketCreate(
    TN            => undef,
    Title         => 'test',
    QueueID       => 1,
    Lock          => 'lock',       # This value is specially important for this test
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

# ---
# Run() tests
# ---
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
            Config => {},
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
        Name   => 'Wrong Ticket Format',
        Config => {
            UserID => $UserID,
            Ticket => 1,
            Config => {},
        },
        Success => 0,
    },
    {
        Name   => 'Correct Locked Ticket',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {},
        },
        Success => 1,
    },
    {
        Name   => 'Correct Already Unlocked Ticket',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {},
        },
        Success => 1,
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
            TicketID => $TicketID,
            UserID   => 1,
        );

        $Self->Is(
            $Ticket{Lock},
            'unlock',
            "$ModuleName - Test:'$Test->{Name}' | Attribute: Lock for TicketID:"
                . " $TicketID match expected value",
        );
    }
    else {
        $Self->False(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | excecuted with False"
        );

        $Self->Is(
            $Ticket{Lock},
            'lock',
            "$ModuleName - Test:'$Test->{Name}' | Attribute: Lock for TicketID:"
                . " $TicketID match expected value",
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

# ----------------------------------------

1;
