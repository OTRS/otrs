# --
# ArticleSearchIndex.t - ticket module testscript
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: ArticleSearchIndex.t,v 1.2 2011-09-05 10:19:25 mg Exp $
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

# tests for article search index modules
for my $Module (qw(StaticDB RuntimeDB)) {
    $ConfigObject->Set(
        Key   => 'Ticket::SearchIndexModule',
        Value => 'Kernel::System::Ticket::ArticleSearchIndex::' . $Module,
    );
    my $TicketObject = Kernel::System::Ticket->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );

    # create some content
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
        TicketID    => $TicketID,
        ArticleType => 'note-internal',
        SenderType  => 'agent',
        From        => 'Some Agent <email@example.com>',
        To          => 'Some Customer <customer@example.com>',
        Subject     => 'some short description',
        Body        => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify  => 1,                                   # if you don't want to send agent notifications
    );
    $Self->True(
        $ArticleID,
        'ArticleCreate()',
    );

    # search
    my %TicketIDs = $TicketObject->TicketSearch(
        Subject    => '%short%',
        Result     => 'HASH',
        Limit      => 100,
        UserID     => 1,
        Permission => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Subject)',
    );

    $ArticleID = $TicketObject->ArticleCreate(
        TicketID    => $TicketID,
        ArticleType => 'note-internal',
        SenderType  => 'agent',
        From        => 'Some Agent <email@example.com>',
        To          => 'Some Customer <customer@example.com>',
        Subject     => 'Fax Agreement laalala',
        Body        => 'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify  => 1,                                   # if you don't want to send agent notifications
    );
    $Self->True(
        $ArticleID,
        'ArticleCreate()',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Subject    => '%fax agreement%',
        Result     => 'HASH',
        Limit      => 100,
        UserID     => 1,
        Permission => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Subject)',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Body       => '%HELP%',
        Result     => 'HASH',
        Limit      => 100,
        UserID     => 1,
        Permission => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        'TicketSearch() (HASH:Body)',
    );

    # search
    %TicketIDs = $TicketObject->TicketSearch(
        Body       => '%HELP_NOT_FOUND%',
        Result     => 'HASH',
        Limit      => 100,
        UserID     => 1,
        Permission => 'rw',
    );
    $Self->True(
        !$TicketIDs{$TicketID},
        'TicketSearch() (HASH:Body)',
    );

    my $Delete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Delete,
        'TicketDelete()',
    );
}

1;
