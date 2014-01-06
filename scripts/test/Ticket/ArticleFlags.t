# --
# ArticleFlags.t - ticket module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: ArticleFlags.t,v 1.1 2011-08-30 11:53:51 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Time::HiRes qw( usleep );

use Kernel::Config;
use Kernel::System::Ticket;

# create local objects
my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    From           => 'Some Agent <email@example.com>',
    To             => 'Some Customer <customer-a@example.com>',
    Subject        => 'some short description',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify => 1,    # if you don't want to send agent notifications
);

$Self->True(
    $ArticleID,
    'ArticleCreate()',
);

# article flag tests
my @Tests = (
    {
        Name   => 'seen flag',
        Key    => 'seen',
        Value  => 1,
        UserID => 1,
    },
    {
        Name   => 'not seend flag',
        Key    => 'not seen',
        Value  => 2,
        UserID => 1,
    },
);

for my $Test (@Tests) {
    my %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'ArticleFlagGet()',
    );
    my $Set = $TicketObject->ArticleFlagSet(
        ArticleID => $ArticleID,
        Key       => $Test->{Key},
        Value     => $Test->{Value},
        UserID    => 1,
    );
    $Self->True(
        $Set,
        'ArticleFlagSet()',
    );
    %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->Is(
        $Flag{ $Test->{Key} },
        $Test->{Value},
        'ArticleFlagGet()',
    );
    my $Delete = $TicketObject->ArticleFlagDelete(
        ArticleID => $ArticleID,
        Key       => $Test->{Key},
        UserID    => 1,
    );
    $Self->True(
        $Delete,
        'ArticleFlagDelete()',
    );
    %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleID,
        UserID    => 1,
    );
    $Self->False(
        $Flag{ $Test->{Key} },
        'ArticleFlagGet()',
    );
}

# the ticket is no longer needed
$TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

1;
