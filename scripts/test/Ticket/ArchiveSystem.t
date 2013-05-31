# --
# ArchiveSystem.t - ticket module testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::Ticket;

# create local objects
my $ConfigObject = Kernel::Config->new();

$ConfigObject->Set(
    Key   => 'Ticket::ArchiveSystem',
    Value => 1,
);

$ConfigObject->Set(
    Key   => 'Ticket::Watcher',
    Value => 1,
);

my $UserObject = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my @Tests = (
    {
        Name   => 'default archive system',
        Config => {
            RemoveSeenFlags      => 1,
            RemoveTicketWatchers => 1,
        },
    },
    {
        Name   => 'archive system without ticket watcher removal',
        Config => {
            RemoveSeenFlags      => 1,
            RemoveTicketWatchers => 0,
        },
    },
    {
        Name   => 'archive system without seen flags removal',
        Config => {
            RemoveSeenFlags      => 0,
            RemoveTicketWatchers => 1,
        },
    },
);

for my $Test (@Tests) {
    $ConfigObject->Set(
        Key   => 'Ticket::ArchiveSystem::RemoveSeenFlags',
        Value => $Test->{Config}->{RemoveSeenFlags},
    );

    $ConfigObject->Set(
        Key   => 'Ticket::ArchiveSystem::RemoveTicketWatchers',
        Value => $Test->{Config}->{RemoveTicketWatchers},
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

    my $ArticleID2 = $TicketObject->ArticleCreate(
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
        $ArticleID2,
        'ArticleCreate()',
    );

    # Seen flags are set for UserID 1 already
    my %Flag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => 1,
    );

    $Self->Is(
        $Flag{'Seen'},
        1,
        "$Test->{Name} - TicketFlagGet() article 1",
    );

    %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    $Self->Is(
        $Flag{'Seen'},
        1,
        "$Test->{Name} - ArticleFlagGet() article 1",
    );

    # subscribe user to ticket
    my $Success = $TicketObject->TicketWatchSubscribe(
        TicketID    => $TicketID,
        WatchUserID => 1,
        UserID      => 1,
    );

    $Self->True(
        $Success,
        "$Test->{Name} - TicketWatchSubscribe()",
    );

    my @Watchers = $TicketObject->TicketWatchGet(
        TicketID => $TicketID,
        Result   => 'ARRAY',
    );

    $Self->IsDeeply(
        \@Watchers,
        [1],
        "$Test->{Name} - TicketWatchGet()",
    );

    # Now set the archive flag
    $Success = $TicketObject->TicketArchiveFlagSet(
        TicketID    => $TicketID,
        ArchiveFlag => 'y',
        UserID      => 1,
    );

    $Self->True(
        $Success,
        "$Test->{Name} - TicketArchiveFlagSet()",
    );

    my %Ticket = $TicketObject->TicketGet( TicketID => $TicketID );

    $Self->Is(
        $Ticket{ArchiveFlag},
        'y',
        "$Test->{Name} - TicketFlag value",
    );

    # now check the seen flags
    %Flag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => 1,
    );

    $Self->Is(
        $Flag{'Seen'},
        $Test->{Config}->{RemoveSeenFlags} ? undef : 1,
        "$Test->{Name} - TicketFlagGet() after archiving",
    );

    %Flag = $TicketObject->ArticleFlagGet(
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    $Self->Is(
        $Flag{'Seen'},
        $Test->{Config}->{RemoveSeenFlags} ? undef : 1,
        "$Test->{Name} - ArticleFlagGet() article 1 after archiving",
    );

    @Watchers = $TicketObject->TicketWatchGet(
        TicketID => $TicketID,
        Result   => 'ARRAY',
    );

    $Self->IsDeeply(
        \@Watchers,
        $Test->{Config}->{RemoveTicketWatchers} ? [] : [1],
        "$Test->{Name} - TicketWatchGet()",
    );

=cut

    # article flag tests
    my @Tests = (
        {
            Name   => 'seen flag',
            Key    => 'seen',
            Value  => 1,
            UserID => 1,
        },
        {
            Name   => 'not seen flag',
            Key    => 'not seen',
            Value  => 2,
            UserID => 1,
        },
    );

    # delete pre-existing article flags which are created on TicketCreate
    $TicketObject->ArticleFlagDelete(
        ArticleID => $ArticleID,
        Key       => 'Seen',
        UserID    => 1,
    );
    $TicketObject->ArticleFlagDelete(
        ArticleID => $ArticleID2,
        Key       => 'Seen',
        UserID    => 1,
    );

    for my $Test (@Tests) {

        # Set for article 1
        my %Flag = $TicketObject->ArticleFlagGet(
            ArticleID => $ArticleID,
            UserID    => 1,
        );
        $Self->False(
            $Flag{ $Test->{Key} },
            'ArticleFlagGet() article 1',
        );
        my $Set = $TicketObject->ArticleFlagSet(
            ArticleID => $ArticleID,
            Key       => $Test->{Key},
            Value     => $Test->{Value},
            UserID    => 1,
        );
        $Self->True(
            $Set,
            'ArticleFlagSet() article 1',
        );

        # Set for article 2
        %Flag = $TicketObject->ArticleFlagGet(
            ArticleID => $ArticleID2,
            UserID    => 1,
        );
        $Self->False(
            $Flag{ $Test->{Key} },
            'ArticleFlagGet() article 2',
        );
        $Set = $TicketObject->ArticleFlagSet(
            ArticleID => $ArticleID2,
            Key       => $Test->{Key},
            Value     => $Test->{Value},
            UserID    => 1,
        );
        $Self->True(
            $Set,
            'ArticleFlagSet() article 2',
        );
        %Flag = $TicketObject->ArticleFlagGet(
            ArticleID => $ArticleID2,
            UserID    => 1,
        );
        $Self->Is(
            $Flag{ $Test->{Key} },
            $Test->{Value},
            'ArticleFlagGet() article 2',
        );

        # Get all flags of ticket
        %Flag = $TicketObject->ArticleFlagsOfTicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->IsDeeply(
            \%Flag,
            {
                $ArticleID => {
                    $Test->{Key} => $Test->{Value},
                },
                $ArticleID2 => {
                    $Test->{Key} => $Test->{Value},
                },
            },
            'ArticleFlagsOfTicketGet() both articles',
        );

        # Delete for article 1
        my $Delete = $TicketObject->ArticleFlagDelete(
            ArticleID => $ArticleID,
            Key       => $Test->{Key},
            UserID    => 1,
        );
        $Self->True(
            $Delete,
            'ArticleFlagDelete() article 1',
        );
        %Flag = $TicketObject->ArticleFlagGet(
            ArticleID => $ArticleID,
            UserID    => 1,
        );
        $Self->False(
            $Flag{ $Test->{Key} },
            'ArticleFlagGet() article 1',
        );

        %Flag = $TicketObject->ArticleFlagsOfTicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->IsDeeply(
            \%Flag,
            {
                $ArticleID2 => {
                    $Test->{Key} => $Test->{Value},
                },
            },
            'ArticleFlagsOfTicketGet() only one article',
        );

        # Delete for article 2
        $Delete = $TicketObject->ArticleFlagDelete(
            ArticleID => $ArticleID2,
            Key       => $Test->{Key},
            UserID    => 1,
        );
        $Self->True(
            $Delete,
            'ArticleFlagDelete() article 2',
        );

        %Flag = $TicketObject->ArticleFlagsOfTicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->IsDeeply(
            \%Flag,
            {},
            'ArticleFlagsOfTicketGet() empty articles',
        );
    }

=cut

    # the ticket is no longer needed
    $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
}

1;
