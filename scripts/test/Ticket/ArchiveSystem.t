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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'Ticket::ArchiveSystem',
    Value => 1,
);

$ConfigObject->Set(
    Key   => 'Ticket::Watcher',
    Value => 1,
);

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

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

    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        SenderType           => 'agent',
        IsVisibleForCustomer => 0,
        From                 => 'Some Agent <email@example.com>',
        To                   => 'Some Customer <customer-a@example.com>',
        Subject              => 'some short description',
        Body                 => 'the message text',
        ContentType          => 'text/plain; charset=ISO-8859-15',
        HistoryType          => 'OwnerUpdate',
        HistoryComment       => 'Some free text!',
        UserID               => 1,
        NoAgentNotify        => 1,
    );

    $Self->True(
        $ArticleID,
        'ArticleCreate()'
    );

    my $ArticleID2 = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        SenderType           => 'agent',
        IsVisibleForCustomer => 0,
        From                 => 'Some Agent <email@example.com>',
        To                   => 'Some Customer <customer-a@example.com>',
        Subject              => 'some short description',
        Body                 => 'the message text',
        ContentType          => 'text/plain; charset=ISO-8859-15',
        HistoryType          => 'OwnerUpdate',
        HistoryComment       => 'Some free text!',
        UserID               => 1,
        NoAgentNotify        => 1,
    );

    $Self->True(
        $ArticleID2,
        'ArticleCreate()'
    );

    # Seen flags are set for UserID 1 already
    my %Flag = $TicketObject->TicketFlagGet(
        TicketID => $TicketID,
        UserID   => 1,
    );

    $Self->Is(
        $Flag{'Seen'},
        1,
        "$Test->{Name} - TicketFlagGet() article 1"
    );

    %Flag = $ArticleObject->ArticleFlagGet(
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

    %Flag = $ArticleObject->ArticleFlagGet(
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
    $ArticleObject->ArticleFlagDelete(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        Key       => 'Seen',
        UserID    => 1,
    );
    $ArticleObject->ArticleFlagDelete(
        TicketID  => $TicketID,
        ArticleID => $ArticleID2,
        Key       => 'Seen',
        UserID    => 1,
    );

    for my $Test (@Tests) {

        # Set for article 1
        my %Flag = $ArticleObject->ArticleFlagGet(
            ArticleID => $ArticleID,
            UserID    => 1,
        );
        $Self->False(
            $Flag{ $Test->{Key} },
            'ArticleFlagGet() article 1',
        );
        my $Set = $ArticleObject->ArticleFlagSet(
            TicketID  => $TicketID,
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
        %Flag = $ArticleObject->ArticleFlagGet(
            ArticleID => $ArticleID2,
            UserID    => 1,
        );
        $Self->False(
            $Flag{ $Test->{Key} },
            'ArticleFlagGet() article 2',
        );
        $Set = $ArticleObject->ArticleFlagSet(
            TicketID  => $TicketID,
            ArticleID => $ArticleID2,
            Key       => $Test->{Key},
            Value     => $Test->{Value},
            UserID    => 1,
        );
        $Self->True(
            $Set,
            'ArticleFlagSet() article 2',
        );
        %Flag = $ArticleObject->ArticleFlagGet(
            ArticleID => $ArticleID2,
            UserID    => 1,
        );
        $Self->Is(
            $Flag{ $Test->{Key} },
            $Test->{Value},
            'ArticleFlagGet() article 2',
        );

        # Get all flags of ticket
        %Flag = $ArticleObject->ArticleFlagsOfTicketGet(
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
        my $Delete = $ArticleObject->ArticleFlagDelete(
            TicketID  => $TicketID,
            ArticleID => $ArticleID,
            Key       => $Test->{Key},
            UserID    => 1,
        );
        $Self->True(
            $Delete,
            'ArticleFlagDelete() article 1',
        );
        %Flag = $ArticleObject->ArticleFlagGet(
            ArticleID => $ArticleID,
            UserID    => 1,
        );
        $Self->False(
            $Flag{ $Test->{Key} },
            'ArticleFlagGet() article 1',
        );

        %Flag = $ArticleObject->ArticleFlagsOfTicketGet(
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
        $Delete = $ArticleObject->ArticleFlagDelete(
            TicketID  => $TicketID,
            ArticleID => $ArticleID2,
            Key       => $Test->{Key},
            UserID    => 1,
        );
        $Self->True(
            $Delete,
            'ArticleFlagDelete() article 2',
        );

        %Flag = $ArticleObject->ArticleFlagsOfTicketGet(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->IsDeeply(
            \%Flag,
            {},
            'ArticleFlagsOfTicketGet() empty articles',
        );
    }

}

# cleanup is done by RestoreDatabase.

1;
