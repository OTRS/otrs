# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::PendingCheck');
my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');

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
my $SystemTime = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2014-01-01 12:00:00',
    },
)->ToEpoch();

# set the fixed time
$Helper->FixedTimeSet($SystemTime);

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
$SystemTime = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2014-01-03 03:00:00',
    },
)->ToEpoch();

# set the fixed time
$Helper->FixedTimeSet($SystemTime);

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

# cleanup is done by RestoreDatabase

1;
