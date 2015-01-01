# --
# Event.t - Event tests
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
