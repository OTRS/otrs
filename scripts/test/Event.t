# --
# Event.t - Event tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::Event;
use Kernel::Config;
use Kernel::System::DynamicField;

# create local object
my $ConfigObject = Kernel::Config->new();

my $DynamicFieldObject = Kernel::System::DynamicField->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# test scenarios
my @Tests = (
);

my $EventObject = Kernel::System::Event->new(
    %{$Self},
    ConfigObject       => $ConfigObject,
    DynamicFieldObject => $DynamicFieldObject,
);

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

#use Data::Dumper;
#print STDERR Dumper(\%EventList);

1;
