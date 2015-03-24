# --
# Kernel/System/Console/Command/Maint/Ticket/InvalidUserCleanup.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::InvalidUserCleanup;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
    'Kernel::System::User',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(
        'Deletes ticket/article seen flags and ticket watcher entries of users which have been invalid for more than a month.'
    );
    $Self->AddOption(
        Name        => 'micro-sleep',
        Description => "Specify microseconds to sleep after every ticket to reduce system load (e.g. 1000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $InvalidID = 2;

    # Users must be invalid for at least one month
    my $Offset        = 60 * 60 * 24 * 31;
    my $InvalidBefore = $Kernel::OM->Get('Kernel::System::Time')->SystemTime() - $Offset;

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $MicroSleep = $Self->GetOption('micro-sleep');

    # First, find all invalid users which are invalid for more than one month
    my %AllUsers = $UserObject->UserList( Valid => 0 );
    my @CleanupInvalidUsers;
    USERID:
    for my $UserID ( sort keys %AllUsers ) {

        my %User = $UserObject->GetUserData(
            UserID => $UserID,
        );

        # Only take invalid users
        next USERID if ( $User{ValidID} != $InvalidID );

        # Only take users which are invalid for more than one month
        my $InvalidTime = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
            String => $User{ChangeTime},
        );

        next USERID if ( $InvalidTime >= $InvalidBefore );

        push @CleanupInvalidUsers, $UserID;
    }

    if ( !@CleanupInvalidUsers ) {
        $Self->Print("<green>No cleanup for invalid users is needed.</green>\n");
        return $Self->ExitCodeOk();
    }

    $Self->Print( "<green>Cleanup for " . ( scalar @CleanupInvalidUsers ) . " starting...</green>\n" );

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    for my $UserID (@CleanupInvalidUsers) {

        my %User = $UserObject->GetUserData(
            UserID => $UserID,
        );

        $Self->Print("Checking for tickets with seen flags for user <yellow>$User{UserLogin}</yellow>...\n");

        return if !$DBObject->Prepare(
            SQL => "
                SELECT DISTINCT(ticket.id)
                FROM ticket
                    INNER JOIN ticket_flag ON ticket.id = ticket_flag.ticket_id
                WHERE ticket_flag.create_by = $UserID
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
                UserID   => $UserID,
            );
            $Count++;
            $Self->Print("    Removing seen flags of ticket $TicketID for user <yellow>$User{UserLogin}</yellow>\n");
            Time::HiRes::usleep($MicroSleep) if $MicroSleep;
        }

        $Self->Print(
            "<green>Done</green> (changed <yellow>$Count</yellow> tickets for user <yellow>$User{UserLogin}</yellow>).\n"
        );
        $Self->Print("Checking for articles with seen flags for user <yellow>$User{UserLogin}</yellow>...\n");

        return if !$DBObject->Prepare(
            SQL => "
                SELECT DISTINCT(article.id)
                FROM article
                    INNER JOIN ticket ON ticket.id = article.ticket_id
                    INNER JOIN article_flag ON article.id = article_flag.article_id
                WHERE article_flag.create_by = $UserID
                    AND article_flag.article_key = 'Seen'",
            Limit => 1_000_000,
        );

        my @ArticleIDs;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @ArticleIDs, $Row[0];
        }

        $Count = 0;
        for my $ArticleID (@ArticleIDs) {
            $TicketObject->ArticleFlagDelete(
                ArticleID => $ArticleID,
                Key       => 'Seen',
                UserID    => $UserID,
            );
            $Count++;
            $Self->Print(
                "    Removing seen flags of article <yellow>$ArticleID</yellow> for user <yellow>$User{UserLogin}</yellow>\n"
            );
            Time::HiRes::usleep($MicroSleep) if $MicroSleep;
        }

        $Self->Print(
            "<green>Done</green> (changed <yellow>$Count</yellow> articles for user <yellow>$User{UserLogin}</yellow>).\n"
        );

        if ( $ConfigObject->Get('Ticket::Watcher') ) {

            $Self->Print(
                "Checking for tickets with ticket watcher entries for user <yellow>$User{UserLogin}</yellow>...\n"
            );

            return if !$DBObject->Prepare(
                SQL => "
                    SELECT DISTINCT(ticket.id)
                    FROM ticket
                        INNER JOIN ticket_watcher ON ticket.id = ticket_watcher.ticket_id",
                Limit => 1_000_000,
            );

            @TicketIDs = ();
            while ( my @Row = $DBObject->FetchrowArray() ) {
                push @TicketIDs, $Row[0];
            }

            my $Count = 0;
            for my $TicketID (@TicketIDs) {

                $TicketObject->TicketWatchUnsubscribe(
                    TicketID    => $TicketID,
                    WatchUserID => $UserID,
                    UserID      => 1,
                );
                $Count++;
                print
                    "    Removing ticket watcher entries of ticket <yellow>$TicketID</yellow> for user <yellow>$User{UserLogin}</yellow>\n";
                Time::HiRes::usleep($MicroSleep) if $MicroSleep;
            }

            $Self->Print(
                "<green>Done</green> (changed <yellow>$Count</yellow> tickets for user <yellow>$User{UserLogin}</yellow>).\n"
            );
        }
    }
    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
