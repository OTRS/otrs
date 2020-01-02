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

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::UnlockTicket');

my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'lock',
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

my $ExitCode = $CommandObject->Execute($TicketID);

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::UnlockTicket exit code",
);

my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID => $TicketID,
);

$Self->Is(
    $Ticket{Lock},
    'unlock',
    "Ticket unlocked",
);

# cleanup cache is done by RestoreDatabase

1;
