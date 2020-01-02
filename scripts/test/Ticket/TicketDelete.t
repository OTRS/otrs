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

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create a new ticket
my $TicketID = $TicketObject->TicketCreate(
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

my %Ticket = $TicketObject->TicketGet( TicketID => $TicketID );

$Self->Is(
    scalar $Ticket{TicketID},
    $TicketID,
    "TicketGet()",
);

my $Deleted = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $Deleted,
    "TicketDelete()",
);

%Ticket = $TicketObject->TicketGet( TicketID => $TicketID );

# Make sure ticket and all caches are gone.
$Self->Is(
    scalar $Ticket{TicketID},
    undef,
    "TicketGet() after TicketDelete()",
);

# cleanup is done by RestoreDatabase.

1;
