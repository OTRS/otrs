# --
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::PendingCheck');

my $TimeObject   = $Kernel::OM->Get('Kernel::System::Time');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'pending auto close+',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    "Ticket created",
);

my $Success = $TicketObject->TicketPendingTimeSet(
    String   => '2014-01-03 00:00:00',
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketID,
    "Set pending time",
);

# test the pending auto close, with a time before the pending time
my $SystemTime = $TimeObject->TimeStamp2SystemTime(
    String => '2014-01-01 12:00:00',
);

# set the fixed time
$HelperObject->FixedTimeSet($SystemTime);

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::PendingCheck exit code",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
);

$Self->Is(
    $Ticket{State},
    'pending auto close+',
    "Ticket pending auto close time not reached",
);

# test the pending auto close, for a reached pending time
$SystemTime = $TimeObject->TimeStamp2SystemTime(
    String => '2014-01-03 03:00:00',
);

# set the fixed time
$HelperObject->FixedTimeSet($SystemTime);

$ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::PendingCheck exit code",
);

%Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
);

$Self->Is(
    $Ticket{State},
    'closed successful',
    "Ticket pending auto closed time reached",
);

my $Deleted = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $Deleted,
    "Ticket deleted",
);

1;
