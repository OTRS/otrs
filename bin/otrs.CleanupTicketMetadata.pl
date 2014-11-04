#!/usr/bin/perl
# --
# bin/otrs.CleanupTicketMetadata.pl - remove unneeded ticket meta data
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Long;
use Time::HiRes qw(usleep);

use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.CleanupTicketMetadata.pl',
    },
);

# disable cache
$Kernel::OM->Get('Kernel::System::Cache')->Configure(
    CacheInMemory  => 0,
    CacheInBackend => 1,
);

# disable ticket events
$Kernel::OM->Get('Kernel::Config')->{'Ticket::EventModulePost'} = {};

sub Run {

    my %Opts;
    Getopt::Long::Configure('no_ignore_case');
    GetOptions(
        'archived|a'      => \$Opts{Archived},
        'invalid-users|i' => \$Opts{InvalidUsers},
        'help|h'          => \$Opts{h},
        'break|b=s'       => \$Opts{b},
    ) or die 'Invalid argument';

    if ( $Opts{h} || ( !$Opts{Archived} && !$Opts{InvalidUsers} ) ) {
        print <<EOF;
otrs.CleanupTicketMetadata.pl - Remove unneeded ticket metadata
Copyright (C) 2001-2012 OTRS AG, http://otrs.org/

Usage:

    otrs.CleanupTicketMetadata.pl --archived [-b sleeptime per ticket in microseconds]

    # Deletes ticket/article seen flags and ticket watcher entries for archived tickets.
    # This does not regularly need to be run as this data will automatically be removed
    #   when tickets are archived (depending on your system's configuration).

    otrs.CleanupTicketMetadata.pl --invalid-users [-b sleeptime per ticket in microseconds]

    # Deletes ticket/article seen flags and ticket watcher entries of users which have been
    #   invalid for more than a month. Run this to clean up this kind of data after invalidating
    #   significant amounts of users.

EOF
        exit 1;
    }

    if ( $Opts{b} && $Opts{b} !~ m{ \A \d+ \z }xms ) {
        print STDERR "ERROR: sleeptime needs to be a numeric value! e.g. 1000\n";
        exit 1;
    }

    CleanupArchived(%Opts)     if $Opts{Archived};
    CleanupInvalidUsers(%Opts) if $Opts{InvalidUsers};
}

sub CleanupArchived {
    my (%Param) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( !$ConfigObject->Get('Ticket::ArchiveSystem') ) {
        print "Ticket::ArchiveSystem is not enabled!\n";
        return;
    }

    # get needed objects
    my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    if ( $ConfigObject->Get('Ticket::ArchiveSystem::RemoveSeenFlags') ) {

        print "Checking for archived tickets with seen flags...\n";

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

        my $Count = 0;
        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {

            $TicketObject->TicketFlagDelete(
                TicketID => $Row[0],
                Key      => 'Seen',
                AllUsers => 1,
            );

            print "    Removing seen flags of ticket $Count\n";

            next ROW if !$Param{b};

            Time::HiRes::usleep( $Param{b} );
        }

        print "Done (changed $Count tickets).\n";
        print "Checking for archived articles with seen flags...\n";

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

        $Count = 0;
        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {

            $TicketObject->ArticleFlagDelete(
                ArticleID => $Row[0],
                Key       => 'Seen',
                AllUsers  => 1,
            );

            print "    Removing seen flags of article $Count\n";

            next ROW if !$Param{b};

            Time::HiRes::usleep( $Param{b} );
        }

        print "Done (changed $Count articles).\n";
    }

    if (
        $ConfigObject->Get('Ticket::ArchiveSystem::RemoveTicketWatchers')
        && $ConfigObject->Get('Ticket::Watcher')
        )
    {

        print "Checking for archived tickets with ticket watcher entries...\n";

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

            print "    Removing ticket watcher entries of ticket $Count\n";

            next ROW if !$Param{b};

            Time::HiRes::usleep( $Param{b} );
        }

        print "Done (changed $Count tickets).\n";
    }
}

sub CleanupInvalidUsers {
    my (%Param) = @_;

    my $InvalidID = 2;

    # Users must be invalid for at least one month
    my $Offset        = 60 * 60 * 24 * 31;
    my $InvalidBefore = $Kernel::OM->Get('Kernel::System::Time')->SystemTime() - $Offset;

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

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
        print "No cleanup for invalid users is needed.";
        return;
    }

    print "Cleanup for " . ( scalar @CleanupInvalidUsers ) . " starting...";

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    for my $UserID (@CleanupInvalidUsers) {

        my %User = $UserObject->GetUserData(
            UserID => $UserID,
        );

        print "\nChecking for tickets with seen flags for user $User{UserLogin}...\n";

        # Find all archived tickets which have ticket seen flags set
        return if !$DBObject->Prepare(
            SQL => "
                SELECT DISTINCT(ticket.id)
                FROM ticket
                    INNER JOIN ticket_flag ON ticket.id = ticket_flag.ticket_id
                WHERE ticket_flag.create_by = $UserID
                    AND ticket_flag.ticket_key = 'Seen'",
            Limit => 1_000_000,
        );

        my $Count = 0;
        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {

            $TicketObject->TicketFlagDelete(
                TicketID => $Row[0],
                Key      => 'Seen',
                UserID   => $UserID,
            );

            print "    Removing seen flags of ticket $Count for user $User{UserLogin}\n";

            next ROW if !$Param{b};

            Time::HiRes::usleep( $Param{b} );
        }

        print "Done (changed $Count tickets for user $User{UserLogin}).\n";
        print "Checking for articles with seen flags for user $User{UserLogin}...\n";

        # Find all articles of archived tickets which have ticket seen flags set
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

        $Count = 0;
        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {

            $TicketObject->ArticleFlagDelete(
                ArticleID => $Row[0],
                Key       => 'Seen',
                UserID    => $UserID,
            );

            print "    Removing seen flags of article $Count for user $User{UserLogin}\n";

            next ROW if !$Param{b};

            Time::HiRes::usleep( $Param{b} );
        }

        print "Done (changed $Count articles for user $User{UserLogin}).\n";

        if ( $ConfigObject->Get('Ticket::Watcher') ) {

            print "Checking for tickets with ticket watcher entries for user $User{UserLogin}...\n";

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
                    TicketID    => $Row[0],
                    WatchUserID => $UserID,
                    UserID      => 1,
                );

                print "    Removing ticket watcher entries of ticket $Count for user $User{UserLogin}\n";

                next ROW if !$Param{b};

                Time::HiRes::usleep( $Param{b} );
            }

            print "Done (changed $Count tickets for user $User{UserLogin}).\n";
        }
    }
}

Run();

exit 0;
