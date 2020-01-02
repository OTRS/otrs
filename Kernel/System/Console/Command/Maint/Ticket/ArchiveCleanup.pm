# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::ArchiveCleanup;

use strict;
use warnings;

use Time::HiRes();

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Delete ticket/article seen flags and ticket watcher entries for archived tickets.');
    $Self->AddOption(
        Name        => 'micro-sleep',
        Description => "Specify microseconds to sleep after every ticket to reduce system load (e.g. 1000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    if ( !$Kernel::OM->Get('Kernel::Config')->Get('Ticket::ArchiveSystem') ) {
        die "Ticket::ArchiveSystem is not enabled!\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Cleaning up ticket archive...</yellow>\n");

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $MicroSleep   = $Self->GetOption('micro-sleep');

    if ( $ConfigObject->Get('Ticket::ArchiveSystem::RemoveSeenFlags') ) {

        $Self->Print("<yellow>Checking for archived tickets with seen flags...</yellow>\n");

        # Find all archived tickets which have ticket seen flags set
        return if !$DBObject->Prepare(
            SQL => "
                SELECT DISTINCT(ticket.id)
                FROM ticket
                    INNER JOIN ticket_flag ON ticket.id = ticket_flag.ticket_id
                WHERE ticket.archive_flag = 1
                    AND ticket_flag.ticket_key = 'Seen'",
            Limit => 1_000_000,
        );

        my @TicketIDs;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @TicketIDs, $Row[0];
        }

        my $Count = 0;
        for my $TicketID (@TicketIDs) {
            $TicketObject->TicketFlagDelete(
                TicketID => $TicketID,
                Key      => 'Seen',
                AllUsers => 1,
            );
            $Count++;
            $Self->Print("    Removing seen flags of ticket $TicketID\n");
            Time::HiRes::usleep($MicroSleep) if $MicroSleep;
        }

        $Self->Print("<green>Done</green> (changed <yellow>$Count</yellow> tickets).\n");
        $Self->Print("<yellow>Checking for archived articles with seen flags...</yellow>\n");

        # Find all articles of archived tickets which have ticket seen flags set
        return if !$DBObject->Prepare(
            SQL => "
                SELECT DISTINCT(article.id)
                FROM article
                    INNER JOIN ticket ON ticket.id = article.ticket_id
                    INNER JOIN article_flag ON article.id = article_flag.article_id
                WHERE ticket.archive_flag = 1
                    AND article_flag.article_key = 'Seen'",
            Limit => 1_000_000,
        );

        my @ArticleIDs;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @ArticleIDs, $Row[0];
        }

        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        $Count = 0;
        for my $ArticleID (@ArticleIDs) {
            $ArticleObject->ArticleFlagDelete(
                ArticleID => $ArticleID,
                Key       => 'Seen',
                AllUsers  => 1,
            );
            $Count++;
            $Self->Print("    Removing seen flags of article $ArticleID\n");
            Time::HiRes::usleep($MicroSleep) if $MicroSleep;
        }

        $Self->Print("<green>Done</green> (changed <yellow>$Count</yellow> articles).\n");
    }

    if (
        $ConfigObject->Get('Ticket::ArchiveSystem::RemoveTicketWatchers')
        && $ConfigObject->Get('Ticket::Watcher')
        )
    {

        $Self->Print("<yellow>Checking for archived tickets with ticket watcher entries...</yellow>\n");

        # Find all archived tickets which have ticket seen flags set
        return if !$DBObject->Prepare(
            SQL => "
                SELECT DISTINCT(ticket.id)
                FROM ticket
                    INNER JOIN ticket_watcher ON ticket.id = ticket_watcher.ticket_id
                WHERE ticket.archive_flag = 1",
            Limit => 1_000_000,
        );

        my $Count = 0;
        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {

            $TicketObject->TicketWatchUnsubscribe(
                TicketID => $Row[0],
                AllUsers => 1,
                UserID   => 1,
            );

            $Self->Print("    Removing ticket watcher entries of ticket $Count\n");

            Time::HiRes::usleep($MicroSleep) if $MicroSleep;
        }

        $Self->Print("<green>Done</green> (changed <yellow>$Count</yellow> tickets).\n");
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
