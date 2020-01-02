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

use Kernel::System::ObjectManager;

# get needed objects
my $EventObject = $Kernel::OM->Get('Kernel::System::Event');

my %EventList = $EventObject->EventList();

$Self->Is(
    $EventList{Ticket}[0],
    'TicketCreate',
    "EventList() Ticket"
);

$Self->Is(
    $EventList{Article}[0],
    'ArticleCreate',
    "EventList() Article"
);

my %EventListTicket = $EventObject->EventList(
    ObjectTypes => ['Ticket'],
);

$Self->Is(
    $EventListTicket{Ticket}[0],
    'TicketCreate',
    "EventListTicket() Ticket"
);

$Self->Is(
    $EventListTicket{Article}[0],
    undef,
    "EventListTicket() Article"
);

1;
