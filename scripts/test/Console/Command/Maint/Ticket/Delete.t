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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::Delete');

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
$CacheObject->Configure(
    CacheInMemory => 0,
);

# create a new ticket
my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    "Ticket created",
);

my $TicketID2 = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID2,
    "Ticket2 created",
);
my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Maint::Ticket::Delete exit code without arguments",
);

$ExitCode = $CommandObject->Execute( '--ticket-id', $TicketID, '--ticket-id', $TicketID2 );

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::Delete exit code",
);

my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID => $TicketID,
);

$Self->False(
    $Ticket{TicketID},
    "Ticket deleted by ticket id",
);

my %Ticket2 = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID => $TicketID,
);

$Self->False(
    $Ticket2{TicketID},
    "Ticket2 deleted by ticket id",
);

# create a new ticket
$TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    "Ticket created",
);

# create a new ticket
$TicketID2 = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID2,
    "Ticket2 created",
);

%Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID => $TicketID,
);

$Self->True(
    $Ticket{TicketID},
    "Ticket created",
);

%Ticket2 = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID => $TicketID2,
);

$Self->True(
    $Ticket2{TicketID},
    "Ticket2 created",
);

$ExitCode
    = $CommandObject->Execute( '--ticket-number', $Ticket{TicketNumber}, '--ticket-number', $Ticket2{TicketNumber} );

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::Delete exit code",
);

%Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID => $TicketID,
);

$Self->False(
    $Ticket{TicketID},
    "Ticket deleted by ticket number",
);

%Ticket2 = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID => $TicketID2,
);

$Self->False(
    $Ticket2{TicketID},
    "Ticket2 deleted by ticket number",
);

1;
