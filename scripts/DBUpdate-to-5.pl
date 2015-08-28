#!/usr/bin/perl
# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use Getopt::Std qw();
use Kernel::Config;
use Kernel::System::Cache;
use Kernel::System::ObjectManager;
use Kernel::System::Package;
use Kernel::System::SysConfig;

use Kernel::System::VariableCheck qw(:all);

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-DBUpdate-to-5.pl',
    },
);

{

    # get options
    my %Opts;
    Getopt::Std::getopt( 'h', \%Opts );

    if ( exists $Opts{h} ) {
        print <<"EOF";

DBUpdate-to-5.pl - Upgrade script for OTRS 4 to 5 migration.
Copyright (C) 2001-2015 OTRS AG, http://otrs.com/

Usage: $0 [-h]
    Options are as follows:
        -h      display this help

EOF
        exit 1;
    }

    # UID check
    if ( $> == 0 ) {    # $EFFECTIVE_USER_ID
        die "
Cannot run this program as root.
Please run it as the 'otrs' user or with the help of su:
    su -c \"$0\" -s /bin/bash otrs
";
    }

    # enable auto-flushing of STDOUT
    $| = 1;             ## no critic

    # define tasks and their messages
    my @Tasks = (
        {
            Message => 'Refresh configuration cache',
            Command => \&RebuildConfig,
        },
        {
            Message => 'Check framework version',
            Command => \&_CheckFrameworkVersion,
        },
        {
            Message => 'Migrate Database Column Types',
            Command => \&_MigrateDatabaseColumnTypes,
        },
        {
            Message => 'Migrate charset to UTF-8 on auto_response table',
            Command => \&_MigrateCharsetAndDeleteCharsetColumnsAutoResponse,
        },
        {
            Message => 'Migrate charset to UTF-8 on notification_event table',
            Command => \&_MigrateCharsetAndDeleteCharsetColumnsNotificationEvent,
        },
        {
            Message => 'Migrate event based notifications to support multiple languages',
            Command => \&_MigrateEventNotificationsToMultiLanguage,
        },
        {
            Message => 'Migrate notifications to event based notifications',
            Command => \&_MigrateNotifications,
        },
        {
            Message => 'Migrate send notification user preferences',
            Command => \&_MigrateSettings,
        },
        {
            Message => 'Migrate Output configurations to the new module locations',
            Command => \&_MigrateConfigs,
        },
        {
            Message => 'Add TicketZoom menu cluster configurations',
            Command => \&_AddZoomMenuClusters,
        },
        {
            Message => 'Uninstall Merged Feature Add-Ons',
            Command => \&_UninstallMergedFeatureAddOns,
        },
        {
            Message => 'Clean up the cache',
            Command => sub {
                $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
            },
        },
        {
            Message => 'Refresh configuration cache another time',
            Command => \&RebuildConfig,
        },
    );

    print "\nMigration started...\n\n";

    # get the number of total steps
    my $Steps = scalar @Tasks;
    my $Step  = 1;
    for my $Task (@Tasks) {

        # show task message
        print "Step $Step of $Steps: $Task->{Message}...";

        # run task command
        if ( &{ $Task->{Command} } ) {
            print "done.\n\n";
        }
        else {
            print "error.\n\n";
            die;
        }

        $Step++;
    }

    print "Migration completed!\n";

    exit 0;
}

=item RebuildConfig()

refreshes the configuration to make sure that a ZZZAAuto.pm is present
after the upgrade.

    RebuildConfig();

=cut

sub RebuildConfig {

    my $SysConfigObject = Kernel::System::SysConfig->new();

    # Rebuild ZZZAAuto.pm with current values
    if ( !$SysConfigObject->WriteDefault() ) {
        die "Error: Can't write default config files!";
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    # reload config object
    print "\nIf you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";

    # create common objects with new default config
    $Kernel::OM->ObjectsDiscard();

    return 1;
}

=item _CheckFrameworkVersion()

Check if framework it's the correct one for Dynamic Fields migration.

    _CheckFrameworkVersion();

=cut

sub _CheckFrameworkVersion {
    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # load RELEASE file
    if ( -e !"$Home/RELEASE" ) {
        die "Error: $Home/RELEASE does not exist!";
    }
    my $ProductName;
    my $Version;
    if ( open( my $Product, '<', "$Home/RELEASE" ) ) {    ## no critic
        while (<$Product>) {

            # filtering of comment lines
            if ( $_ !~ /^#/ ) {
                if ( $_ =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $ProductName = $1;
                }
                elsif ( $_ =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Version = $1;
                }
            }
        }
        close($Product);
    }
    else {
        die "Error: Can't read $Home/RELEASE: $!";
    }

    if ( $ProductName ne 'OTRS' ) {
        die "Error: No OTRS system found"
    }
    if ( $Version !~ /^5\.0(.*)$/ ) {

        die "Error: You are trying to run this script on the wrong framework version $Version!"
    }

    return 1;
}

=item _MigrateDatabaseColumnTypes()

Migrate the column type from INTEGER to BIGINT for all columns on all tables where it was originally
defined (applies only to PostgreSQL databases).

    _MigrateDatabaseColumnTypes();

=cut

sub _MigrateDatabaseColumnTypes {

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # do nothing if current DB is not postgressql
    return 1 if $DBObject->GetDatabaseFunction('Type') ne 'postgresql';

    # read otrs schema file
    my $Home       = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $SchemaFile = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => "$Home/scripts/database/otrs-schema.xml",
        Result   => 'ARRAY',
    );

    # get needed SQL statements to update affected columns
    my @SQL = _GetColumnUpdateSQL($SchemaFile);

    # get package object
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    # get a list of all installed packages (only the meta-data as content is parsed in this function)
    my @PackageList = $PackageObject->RepositoryList(
        Result => 'short',
    );

    # check installed packages
    PACKAGE:
    for my $Package (@PackageList) {

        # skip package if it does not have the needed meta-data to get its contents
        next PACKAGE if !$Package->{Name};
        next PACKAGE if !$Package->{Version};

        # get package XML content
        my $PackageContent = $PackageObject->RepositoryGet(
            %{$Package},
        );

        # skip package if it does not have DatabaseInstall section
        next PACKAGE if $PackageContent !~ m{<DatabaseInstall [^>]+ >}msxig;

        # remove any other sections in the file but DatabaseInstall
        $PackageContent =~ s{(?: .*) ( <DatabaseInstall [^>]+ > (.*) </DatabaseInstall> ) (?: .*) }{$1}msxig;

        # skip if resulting content is empty
        next PACKAGE if !$PackageContent;

        # convert columns tags into self closing from <Column ...></Column ...> to <Column .../>
        $PackageContent =~ s{( <Column (?:Change|Add)? [^>]+ ) (>) </Column (?:Change|Add)? >}{$1/$2}msxig;

        # convert package content into an array (be sure to keep the line feed)
        my @Schema = map { $_ . "\n" } split /\n/, $PackageContent;

        # get needed SQL statements to update affected columns
        my @PackageSQL = _GetColumnUpdateSQL( \@Schema );

        # skip if there are no SQL statements
        next PACKAGE if !@PackageSQL;

        # join the SQL statements with the ones from the framework and other packages
        @SQL = ( @SQL, @PackageSQL );
    }

    # execute SQL
    for my $SQL (@SQL) {
        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }

    return 1;
}

=item _GetColumnUpdateSQL

Gets the SQL statements to update a column type to BIGINT from an XML schema string.

    my @SQL _GetColumnUpdateSQL(
        $XMLContent,                    # Database table and column definitions
                                        #   (e.g  the contents of otrs.schema.xml).
    );

=cut

sub _GetColumnUpdateSQL {
    my $XML = shift;

    # define a top level tag
    my $SourceXML = "<Database>\n";
    my $Table;
    my $SaveTable;

    # check each line
    LINE:
    for my $Line ( @{$XML} ) {

        # skip if line is not a table start or end tag or if is not a column tag
        next LINE if $Line !~ m{< /? (?: Table | Column)}msx;

        # skip line if is a column tag but the type is not BIGINT
        next LINE if $Line =~ m{<Column}msx && $Line !~ m (BIGINT)msx;

        # remember line as a part of the whole table tag (opening table tag or column tag)
        $Table .= $Line;

        # got to next line if current is an opening table tag
        next LINE if $Line =~ m{<Table}msxi;

        # check if line is a BIGINT column and mark table for save and go to next line
        if ( $Line =~ m{BIGINT} ) {
            $SaveTable = 1;
            next LINE;
        }

        # otherwise (closing table tag), save table if it has at least a column
        if ($SaveTable) {
            $SourceXML .= $Table;
        }

        # reset for next table
        $Table     = '';
        $SaveTable = 0;
    }

    # convert <Table ...> and <TableCreate...> tags into <TableAlter ...> tags
    #   preserving the rest of the attributes
    $SourceXML =~ s{(<Table) (?:Create|Alter)? ([^>]+)}{$1Alter$2}msxig;

    # convert </Table> and </TableCreate> tags into </TableAlter> tags
    $SourceXML =~ s{(</Table) (?:Create|Alter)?}{$1Alter}msxig;

    # convert <Column ... Name="###" ...> and <ColumnAdd ... Name="###" ...> tags into
    # <ColumnChange ... NameOld="###" NameNew="###" ...>  tags preserving the rest of the attributes
    $SourceXML =~ s{(<Column) (?:Add)? (.*) Name(="[^"]+") ([^>]+) >}{$1Change$2 NameOld$3 NameNew$3$4>}mxig;

    # close top level tag
    $SourceXML .= '</Database>';

    # parse XML update schema
    my @XMLARRAY = $Kernel::OM->Get('Kernel::System::XML')->XMLParse(
        String => $SourceXML,
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @SQL;

    # create database specific SQL
    push @SQL, $DBObject->SQLProcessor(
        Database => \@XMLARRAY,
    );

    my @SQLPost;

    # create database specific PostSQL
    push @SQLPost, $DBObject->SQLProcessorPost();

    return ( @SQL, @SQLPost );
}

=item _MigrateCharsetAndDeleteCharsetColumnsAutoResponse()

Migrate the charset of the auto_response table and the notification_event table to UTF-8 and delete the charset columns.

    _MigrateCharsetAndDeleteCharsetColumnsAutoResponse();

=cut

sub _MigrateCharsetAndDeleteCharsetColumnsAutoResponse {

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $ErrorOutput;
    my $CharsetIsPresent = 1;

    # use do for restoring STDERR
    do {
        local *STDERR;
        open STDERR, '>:utf8', \$ErrorOutput;    ## no critic

        # sanity check to verify the charset column is present
        $CharsetIsPresent = $DBObject->Prepare(
            SQL => 'SELECT charset FROM auto_response',
        );
    };

    return 1 if !$CharsetIsPresent;

    # read auto_response table
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, text0, text1, charset FROM auto_response',
    );

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # read the auto responses and store in array
    my @AutoResponses;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        my %Data = (
            ID      => $Row[0],
            Text0   => $Row[1],
            Text1   => $Row[2],
            Charset => $Row[3],
        );

        # convert body
        $Data{Text0} = $EncodeObject->Convert(
            Text  => $Data{Text0},
            From  => $Data{Charset},
            To    => 'utf-8',
            Check => 1,
        );

        # convert subject
        $Data{Text1} = $EncodeObject->Convert(
            Text  => $Data{Text1},
            From  => $Data{Charset},
            To    => 'utf-8',
            Check => 1,
        );

        # skip if nothing was changed and charset column is already in utf-8
        if ( ( $Data{Text0} eq $Row[1] ) && ( $Data{Text1} eq $Row[2] ) && ( $Data{Charset} eq 'utf-8' ) ) {
            next ROW;
        }

        # update charset column to utf-8
        $Data{Charset} = 'utf-8';

        push @AutoResponses, \%Data;
    }

    # write converted responses back to database
    for my $AutoResponse (@AutoResponses) {

        # update the database
        return if !$DBObject->Do(
            SQL  => 'UPDATE auto_response SET text0 = ?, text1 = ?, charset = ? WHERE id = ?',
            Bind => [
                \$AutoResponse->{Text0},
                \$AutoResponse->{Text1},
                \$AutoResponse->{Charset},
                \$AutoResponse->{ID},
            ],
        );
    }

    # drop charset column from auto_response table
    my $XMLString = '
        <TableAlter Name="auto_response">
            <ColumnDrop Name="charset"/>
        </TableAlter>';

    my @SQL;
    my @SQLPost;

    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    # create database specific SQL and PostSQL commands
    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # create database specific SQL
    push @SQL, $DBObject->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # create database specific PostSQL
    push @SQLPost, $DBObject->SQLProcessorPost();

    # execute SQL
    for my $SQL ( @SQL, @SQLPost ) {
        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }

    return 1;
}

=item _MigrateCharsetAndDeleteCharsetColumnsNotificationEvent()

Migrate the charset of the auto_response table and the notification_event table to UTF-8 and delete the charset columns.

    _MigrateCharsetAndDeleteCharsetColumnsNotificationEvent();

=cut

sub _MigrateCharsetAndDeleteCharsetColumnsNotificationEvent {

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $ErrorOutput;
    my $CharsetIsPresent = 1;

    # use do for restoring STDERR
    do {
        local *STDERR;
        open STDERR, '>:utf8', \$ErrorOutput;    ## no critic

        # sanity check to verify the charset column is present
        $CharsetIsPresent = $DBObject->Prepare(
            SQL => 'SELECT charset FROM notification_event',
        );
    };
    return 1 if !$CharsetIsPresent;

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # read notification_event
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, subject, text, charset FROM notification_event',
    );

    # read the notification_event entries and store in array
    my @NotificationsEvent;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        my %Data = (
            ID      => $Row[0],
            Subject => $Row[1],
            Body    => $Row[2],
            Charset => $Row[3],
        );

        # convert subject
        $Data{Subject} = $EncodeObject->Convert(
            Text  => $Data{Subject},
            From  => $Data{Charset},
            To    => 'utf-8',
            Check => 1,
        );

        # convert body
        $Data{Body} = $EncodeObject->Convert(
            Text  => $Data{Body},
            From  => $Data{Charset},
            To    => 'utf-8',
            Check => 1,
        );

        # skip if nothing was changed and charset column is already in utf-8
        if ( ( $Data{Subject} eq $Row[1] ) && ( $Data{Body} eq $Row[2] ) && ( $Data{Charset} eq 'utf-8' ) ) {
            next ROW;
        }

        # update Charset column to utf-8
        $Data{Charset} = 'utf-8';

        push @NotificationsEvent, \%Data;
    }

    # write converted event notifications back to database
    for my $Notification (@NotificationsEvent) {

        # update the database
        return if !$DBObject->Do(
            SQL  => 'UPDATE notification_event SET subject = ?, text = ?, charset = ? WHERE id = ?',
            Bind => [
                \$Notification->{Subject},
                \$Notification->{Body},
                \$Notification->{Charset},
                \$Notification->{ID},
            ],
        );
    }

    # drop charset column from notification_event table
    my $XMLString = '
        <TableAlter Name="notification_event">
            <ColumnDrop Name="charset"/>
        </TableAlter>';

    my @SQL;
    my @SQLPost;

    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    # create database specific SQL and PostSQL commands
    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # create database specific SQL
    push @SQL, $DBObject->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # create database specific PostSQL
    push @SQLPost, $DBObject->SQLProcessorPost();

    # execute SQL
    for my $SQL ( @SQL, @SQLPost ) {
        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }

    return 1;
}

=item _MigrateEventNotificationsToMultiLanguage()

Migrate event based notifications to support multiple languages.

    _MigrateEventNotificationsToMultiLanguage();

=cut

sub _MigrateEventNotificationsToMultiLanguage {

    # get needed objects
    my $DBObject                = $Kernel::OM->Get('Kernel::System::DB');
    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

    my $ErrorOutput;
    my $ColumnsArePresent = 1;

    # use do for restoring STDERR
    do {
        local *STDERR;
        open STDERR, '>:utf8', \$ErrorOutput;    ## no critic

        # sanity check to verify the subject, text and content_type columns are present
        $ColumnsArePresent = $DBObject->Prepare(
            SQL => 'SELECT subject, text, content_type FROM notification_event',
        );
    };
    return 1 if !$ColumnsArePresent;

    # get the systems default language
    my $Language = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage') || 'en';

    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name, subject, text, content_type, valid_id, comments
            FROM notification_event',
    );

    # read the notification_event entries and store in array
    my @NotificationsEvent;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        if ( !$Row[2] || !$Row[3] || !$Row[4] ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Notification: $Row[1] is invalid and will not be migrated, or was migrated previously.",
            );
            next ROW;
        }

        my %Data = (
            ID      => $Row[0],
            Name    => $Row[1],
            Message => {
                $Language => {
                    Subject     => $Row[2],
                    Body        => $Row[3],
                    ContentType => $Row[4],
                },
            },
            ValidID => $Row[5],
            Comment => $Row[6],
        );

        push @NotificationsEvent, \%Data;
    }

    # read notification event item data
    for my $Notification (@NotificationsEvent) {

        $DBObject->Prepare(
            SQL => 'SELECT event_key, event_value
                FROM notification_event_item
                WHERE notification_id = ?',
            Bind => [ \$Notification->{ID} ],
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @{ $Notification->{Data}->{ $Row[0] } }, $Row[1];
        }
    }

    # update notifications
    for my $Notification (@NotificationsEvent) {

        # update
        my $Success = $NotificationEventObject->NotificationUpdate(
            %{$Notification},
            UserID => 1,
        );

        # error handling
        return if !$Success;
    }

    # drop migrated columns from notification_event table
    my $XMLString = '
        <TableAlter Name="notification_event">
            <ColumnDrop Name="subject"/>
            <ColumnDrop Name="text"/>
            <ColumnDrop Name="content_type"/>
        </TableAlter>';

    my @SQL;
    my @SQLPost;

    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    # create database specific SQL and PostSQL commands
    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # create database specific SQL
    push @SQL, $DBObject->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # create database specific PostSQL
    push @SQLPost, $DBObject->SQLProcessorPost();

    # execute SQL
    for my $SQL ( @SQL, @SQLPost ) {
        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }

    return 1;
}

=item _MigrateNotifications()

Migrate notifications to event based notifications.

    _MigrateNotifications();

=cut

sub _MigrateNotifications {

    # get needed objects
    my $DBObject                = $Kernel::OM->Get('Kernel::System::DB');
    my $EncodeObject            = $Kernel::OM->Get('Kernel::System::Encode');
    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');
    my $ConfigObject            = $Kernel::OM->Get('Kernel::Config');

    my $ErrorOutput;
    my $NotificationsTableIsPresent = 1;

    # use do for restoring STDERR
    do {
        local *STDERR;
        open STDERR, '>:utf8', \$ErrorOutput;    ## no critic

        # sanity check to verify the notifications table is present
        $NotificationsTableIsPresent = $DBObject->Prepare(
            SQL => 'SELECT notification_type FROM notifications',
        );
    };
    return 1 if !$NotificationsTableIsPresent;

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    my %NotificationList        = $NotificationEventObject->NotificationList();
    my %NotificationListReverse = reverse %NotificationList;

    # mapping array based on notification type
    my %NotificationTypeMapping = (
        'Agent::NewTicket' => [
            {
                Name                   => 'Ticket create notification',
                VisibleForAgent        => [1],
                VisibleForAgentTooltip => [
                    'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".'
                ],
                Events     => ['NotificationNewTicket'],
                Recipients => [ 'AgentMyQueues', 'AgentMyServices' ],
                Transports => ['Email'],
            },
        ],
        'Agent::FollowUp' => [
            {
                Name                   => 'Ticket follow-up notification (unlocked)',
                VisibleForAgent        => [1],
                VisibleForAgentTooltip => [
                    'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".'
                ],
                Events     => ['NotificationFollowUp'],
                Recipients => [ 'AgentOwner', 'AgentWatcher', 'AgentMyQueues', 'AgentMyServices' ],
                LockID     => [1],                                                                    # unlocked
                Transports => ['Email'],
            },
            {
                Name                   => 'Ticket follow-up notification (locked)',
                VisibleForAgent        => [1],
                VisibleForAgentTooltip => [
                    'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.'
                ],
                Events     => ['NotificationFollowUp'],
                Recipients => [ 'AgentOwner', 'AgentResponsible', 'AgentWatcher' ],
                LockID => [ 2, 3 ],                                                                   # locked
                Transports => ['Email'],
            },
        ],
        'Agent::LockTimeout' => [
            {
                Name            => 'Ticket lock timeout notification',
                VisibleForAgent => [1],
                VisibleForAgentTooltip =>
                    ['You will receive a notification as soon as a ticket owned by you is automatically unlocked.'],
                Events     => ['NotificationLockTimeout'],
                Recipients => ['AgentOwner'],
                Transports => ['Email'],
            },
        ],
        'Agent::OwnerUpdate' => [
            {
                Name       => 'Ticket owner update notification',
                Events     => ['NotificationOwnerUpdate'],
                Recipients => ['AgentOwner'],
                Transports => ['Email'],
            },
        ],
        'Agent::ResponsibleUpdate' => [
            {
                Name       => 'Ticket responsible update notification',
                Events     => ['NotificationResponsibleUpdate'],
                Recipients => ['AgentResponsible'],
                Transports => ['Email'],
            },
        ],
        'Agent::AddNote' => [
            {
                Name       => 'Ticket new note notification',
                Events     => ['NotificationAddNote'],
                Recipients => [ 'AgentOwner', 'AgentResponsible', 'AgentWatcher' ],
                Transports => ['Email'],
            },
        ],
        'Agent::Move' => [
            {
                Name            => 'Ticket queue update notification',
                VisibleForAgent => [1],
                VisibleForAgentTooltip =>
                    ['You will receive a notification if a ticket is moved into one of your "My Queues".'],
                Events     => ['NotificationMove'],
                Recipients => ['AgentMyQueues'],
                Transports => ['Email'],
            },
        ],
        'Agent::PendingReminder' => [
            {
                Name       => 'Ticket pending reminder notification (locked)',
                Events     => ['NotificationPendingReminder'],
                Recipients => [ 'AgentOwner', 'AgentResponsible' ],
                OncePerDay => [1],
                LockID     => [ 2, 3 ],                                          # locked
                Transports => ['Email'],
            },
            {
                Name       => 'Ticket pending reminder notification (unlocked)',
                Events     => ['NotificationPendingReminder'],
                Recipients => [ 'AgentOwner', 'AgentResponsible', 'AgentMyQueues' ],
                OncePerDay => [1],
                LockID     => [1],                                                     # unlocked
                Transports => ['Email'],
            },
        ],
        'Agent::Escalation' => [
            {
                Name       => 'Ticket escalation notification',
                Events     => ['NotificationEscalation'],
                Recipients => [ 'AgentMyQueues', 'AgentWritePermissions' ],
                OncePerDay => [1],
                Transports => ['Email'],
            },
        ],
        'Agent::EscalationNotifyBefore' => [
            {
                Name       => 'Ticket escalation warning notification',
                Events     => ['NotificationEscalationNotifyBefore'],
                Recipients => [ 'AgentMyQueues', 'AgentWritePermissions' ],
                OncePerDay => [1],
                Transports => ['Email'],
            },
        ],
        'Agent::ServiceUpdate' => [
            {
                Name                   => 'Ticket service update notification',
                VisibleForAgent        => [1],
                VisibleForAgentTooltip => [
                    'You will receive a notification if a ticket\'s service is changed to one of your "My Services".'
                ],
                Events     => ['NotificationServiceUpdate'],
                Recipients => ['AgentMyServices'],
                Transports => ['Email'],
            },
        ],
    );

    # for all standard otrs notification types included in the framework
    NOTIFICATIONTYPE:
    for my $NotificationType ( sort keys %NotificationTypeMapping ) {

        # read notifications for this notification type
        return if !$DBObject->Prepare(
            SQL => 'SELECT notification_type, notification_charset,
                notification_language, subject, text, content_type
                FROM notifications
                WHERE notification_type = ?',
            Bind => [ \$NotificationType ],
        );

        my %Message;
        while ( my @Row = $DBObject->FetchrowArray() ) {

            my %Data = (
                NotificationType => $Row[0],
                Charset          => $Row[1],
                Language         => $Row[2],
                Subject          => $Row[3],
                Body             => $Row[4],
                ContentType      => $Row[5] || 'text/plain',
            );

            # convert subject
            $Data{Subject} = $EncodeObject->Convert(
                Text  => $Data{Subject},
                From  => $Data{Charset},
                To    => 'utf-8',
                Check => 1,
            );

            # convert body
            $Data{Body} = $EncodeObject->Convert(
                Text  => $Data{Body},
                From  => $Data{Charset},
                To    => 'utf-8',
                Check => 1,
            );

            # store each language data
            $Message{ $Data{Language} } = {
                Subject     => $Data{Subject},
                Body        => $Data{Body},
                ContentType => $Data{ContentType},
            };
        }

        # sanity check in case notification table is already present,
        # but not a row for this specific notification type is present,
        # perhaps notifications for other modules are still there
        next NOTIFICATIONTYPE if !%Message;

        for my $NotificationDataOri ( @{ $NotificationTypeMapping{$NotificationType} } ) {

            my $NotificationData = $NotificationDataOri;

            my $NotificationName = $NotificationData->{Name};
            delete $NotificationData->{Name};

            # check for special settings on system
            if (
                $NotificationType eq 'Agent::PendingReminder'
                && $ConfigObject->Get('Ticket::PendingNotificationNotToResponsible')
                )
            {
                if ( $NotificationName eq 'Ticket pending reminder notification (locked)' ) {
                    $NotificationData->{Recipients} = ['AgentOwner'];
                }
                elsif ( $NotificationName eq 'Ticket pending reminder notification (unlocked)' ) {
                    $NotificationData->{Recipients} = [ 'AgentOwner', 'AgentMyQueues' ];
                }
            }
            elsif (
                $NotificationType eq 'Agent::FollowUp'
                && $ConfigObject->Get('PostmasterFollowUpOnUnlockAgentNotifyOnlyToOwner')
                && $NotificationName eq 'Ticket follow-up notification (unlocked)'
                )
            {
                $NotificationData->{Recipients} = ['AgentOwner'];
            }

            if ( $NotificationListReverse{ 'Old ' . $NotificationName } ) {
                $NotificationName .= ' ( Duplicate Name )';
            }

            # add new event notification
            my $ID = $NotificationEventObject->NotificationAdd(
                Name    => 'Old ' . $NotificationName,
                Data    => $NotificationData,
                Message => \%Message,
                Comment => '',
                ValidID => $ValidListReverse{invalid},
                UserID  => 1,
            );

            # put the suffix back
            $NotificationData->{Name} = $NotificationName;

            # error handling
            return if !$ID;
        }
    }

    # delete old notifications from notification table
    for my $NotificationType ( sort keys %NotificationTypeMapping ) {

        return if !$DBObject->Do(
            SQL  => 'DELETE FROM notifications WHERE notification_type = ?',
            Bind => [ \$NotificationType ],
        );
    }

    # get number of remaining entries
    return if !$DBObject->Prepare(
        SQL => 'SELECT COUNT(id) FROM notifications',
    );

    my $Count;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
    }

    # delete table but only if table is empty
    # if there are some entries left, these must be deleted by other modules
    # so we give them a chance to be migrated from these modules
    if ( !$Count ) {

        # drop table 'notifications'
        my $XMLString = '<TableDrop Name="notifications"/>';

        my @SQL;
        my @SQLPost;

        my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

        # create database specific SQL and PostSQL commands
        my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

        # create database specific SQL
        push @SQL, $DBObject->SQLProcessor(
            Database => \@XMLARRAY,
        );

        # create database specific PostSQL
        push @SQLPost, $DBObject->SQLProcessorPost();

        # execute SQL
        for my $SQL ( @SQL, @SQLPost ) {
            my $Success = $DBObject->Do( SQL => $SQL );
            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Error during execution of '$SQL'!",
                );
                return;
            }
        }
    }

    # insert new and valid notifications
    my %NotificationLanguages = _NewAgentNotificationsLanguageGet();

    # for all standard otrs notification types included in the framework
    NEWNOTIFICATION:
    for my $NotificationType ( sort keys %NotificationTypeMapping ) {

        for my $NotificationData ( @{ $NotificationTypeMapping{$NotificationType} } ) {

            my $NotificationName = $NotificationData->{Name};
            delete $NotificationData->{Name};

            my %Message = %{ $NotificationLanguages{$NotificationName} };

            if ( $NotificationListReverse{$NotificationName} ) {
                $NotificationName .= ' ( Duplicate Name )';
            }

            # add new event notification
            my $ID = $NotificationEventObject->NotificationAdd(
                Name    => $NotificationName,
                Data    => $NotificationData,
                Message => \%Message,
                Comment => '',
                ValidID => $ValidListReverse{valid},
                UserID  => 1,
            );

            # error handling
            return if !$ID;
        }
    }

    return 1;
}

=item _MigrateConfigs()

Change tool-bar configurations to match the new module location.

    _MigrateConfigs();

=cut

sub _MigrateConfigs {

    # get needed objects
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    print "\n--- Toolbar modules...";

    # Toolbar Modules
    my $Setting = $ConfigObject->Get('Frontend::ToolBarModule');

    TOOLBARMODULE:
    for my $ToolbarModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$ToolbarModule}->{'Module'};
        if ( $Module !~ m{Kernel::Output::HTML::ToolBar(\w+)} ) {
            next TOOLBARMODULE;
        }

        $Module =~ s{Kernel::Output::HTML::ToolBar(\w+)}{Kernel::Output::HTML::ToolBar::$1}xmsg;
        $Setting->{$ToolbarModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###' . $ToolbarModule,
            Value => $Setting->{$ToolbarModule},
        );
    }

    print "...done.\n";
    print "--- Ticket menu modules...";

    # Ticket Menu Modules
    $Setting = $ConfigObject->Get('Ticket::Frontend::MenuModule');

    MENUMODULE:
    for my $MenuModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$MenuModule}->{'Module'};
        if ( $Module !~ m{Kernel::Output::HTML::TicketMenu(\w+)} ) {
            next MENUMODULE;
        }

        $Module =~ s{Kernel::Output::HTML::TicketMenu(\w+)}{Kernel::Output::HTML::TicketMenu::$1}xmsg;
        $Setting->{$MenuModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::MenuModule###' . $MenuModule,
            Value => $Setting->{$MenuModule},
        );
    }

    print "...done.\n";
    print "--- Ticket overview menu modules...";

    # Ticket Menu Modules
    $Setting = $ConfigObject->Get('Ticket::Frontend::OverviewMenuModule');

    MENUMODULE:
    for my $MenuModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$MenuModule}->{'Module'};
        if ( $Module !~ m{Kernel::Output::HTML::TicketOverviewMenu(\w+)} ) {
            next MENUMODULE;
        }

        $Module =~ s{Kernel::Output::HTML::TicketOverviewMenu(\w+)}{Kernel::Output::HTML::TicketOverviewMenu::$1}xmsg;
        $Setting->{$MenuModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::OverviewMenuModule###' . $MenuModule,
            Value => $Setting->{$MenuModule},
        );
    }

    print "...done.\n";
    print "--- Ticket overview modules...";

    # Ticket Menu Modules
    $Setting = $ConfigObject->Get('Ticket::Frontend::Overview');

    OVERVIEWMODULE:
    for my $OverviewModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$OverviewModule}->{'Module'};
        if ( $Module !~ m{Kernel::Output::HTML::TicketOverview(\w+)} ) {
            next OVERVIEWMODULE;
        }

        $Module =~ s{Kernel::Output::HTML::TicketOverview(\w+)}{Kernel::Output::HTML::TicketOverview::$1}xmsg;
        $Setting->{$OverviewModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::Overview###' . $OverviewModule,
            Value => $Setting->{$OverviewModule},
        );
    }

    print "...done.\n";
    print "--- Preferences group modules...";

    # Preferences groups
    $Setting = $ConfigObject->Get('PreferencesGroups');

    PREFERENCEMODULE:
    for my $PreferenceModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$PreferenceModule}->{'Module'};
        if ( $Module !~ m{Kernel::Output::HTML::Preferences(\w+)} ) {
            next PREFERENCEMODULE;
        }

        $Module =~ s{Kernel::Output::HTML::Preferences(\w+)}{Kernel::Output::HTML::Preferences::$1}xmsg;
        $Setting->{$PreferenceModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'PreferencesGroups###' . $PreferenceModule,
            Value => $Setting->{$PreferenceModule},
        );
    }

    print "...done.\n";
    print "--- SLA/Service/Queue preference modules...";

    # SLA, Service and Queue preferences
    for my $Type (qw(SLA Service Queue)) {

        $Setting = $ConfigObject->Get( $Type . 'Preferences' );

        MODULE:
        for my $PreferenceModule ( sort keys %{$Setting} ) {

            # update module location
            my $Module = $Setting->{$PreferenceModule}->{'Module'};
            my $Regex  = 'Kernel::Output::HTML::' . $Type . 'Preferences(\w+)';
            if ( $Module !~ m{$Regex} ) {
                next MODULE;
            }

            $Module =~ s{$Regex}{Kernel::Output::HTML::${Type}Preferences::$1}xmsg;
            $Setting->{$PreferenceModule}->{'Module'} = $Module;

            # set new setting,
            my $Success = $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => $Type . 'Preferences###' . $PreferenceModule,
                Value => $Setting->{$PreferenceModule},
            );
        }
    }

    print "...done.\n";
    print "--- Article pre view modules...";

    # Article pre view modules
    $Setting = $ConfigObject->Get('Ticket::Frontend::ArticlePreViewModule');

    ARTICLEMODULE:
    for my $ArticlePreViewModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$ArticlePreViewModule}->{'Module'};
        if ( $Module !~ m{Kernel::Output::HTML::ArticleCheck(\w+)} ) {
            next ARTICLEMODULE;
        }

        $Module =~ s{Kernel::Output::HTML::ArticleCheck(\w+)}{Kernel::Output::HTML::ArticleCheck::$1}xmsg;
        $Setting->{$ArticlePreViewModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::ArticlePreViewModule###' . $ArticlePreViewModule,
            Value => $Setting->{$ArticlePreViewModule},
        );
    }

    print "...done.\n";
    print "--- NavBar menu modules...";

    # NavBar menu modules
    my @NavBarTypes = (
        {
            Path => 'Frontend::NavBarModule',
        },
        {
            Path => 'CustomerFrontend::NavBarModule',
        },
    );

    for my $Type (@NavBarTypes) {

        $Setting = $ConfigObject->Get( $Type->{Path} );

        NAVBARMODULE:
        for my $NavBarModule ( sort keys %{$Setting} ) {

            # update module location
            my $Module = $Setting->{$NavBarModule}->{'Module'};

            if ( $Module !~ m{Kernel::Output::HTML::NavBar(\w+)} ) {
                next NAVBARMODULE;
            }

            $Module =~ s{Kernel::Output::HTML::NavBar(\w+)}{Kernel::Output::HTML::NavBar::$1}xmsg;
            $Setting->{$NavBarModule}->{'Module'} = $Module;

            # set new setting,
            my $Success = $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => $Type->{Path} . '###' . $NavBarModule,
                Value => $Setting->{$NavBarModule},
            );
        }
    }

    print "...done.\n";
    print "--- NavBar ModuleAdmin modules...";

    # NavBar module admin
    $Setting = $ConfigObject->Get('Frontend::Module');

    MODULEADMIN:
    for my $ModuleAdmin ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$ModuleAdmin}->{NavBarModule}->{'Module'} // '';

        if ( $Module !~ m{Kernel::Output::HTML::NavBar(\w+)} ) {
            next MODULEADMIN;
        }
        $Setting->{$ModuleAdmin}->{NavBarModule}->{'Module'} = "Kernel::Output::HTML::NavBar::ModuleAdmin";

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::Module###' . $ModuleAdmin,
            Value => $Setting->{$ModuleAdmin},
        );
    }

    print "...done.\n";
    print "--- Dashboard modules...";

    # Dashboard modules
    my @DashboardTypes = (
        {
            Path => 'DashboardBackend',
        },
        {
            Path => 'AgentCustomerInformationCenter::Backend',
        },
    );

    for my $Type (@DashboardTypes) {

        $Setting = $ConfigObject->Get( $Type->{Path} );

        DASHBOARDMODULE:
        for my $DashboardModule ( sort keys %{$Setting} ) {

            # update module location
            my $Module = $Setting->{$DashboardModule}->{'Module'} // '';

            if ( $Module !~ m{Kernel::Output::HTML::Dashboard(\w+)} ) {
                next DASHBOARDMODULE;
            }
            $Module =~ s{Kernel::Output::HTML::Dashboard(\w+)}{Kernel::Output::HTML::Dashboard::$1}xmsg;
            $Setting->{$DashboardModule}->{'Module'} = $Module;

            # set new setting,
            my $Success = $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => $Type->{Path} . '###' . $DashboardModule,
                Value => $Setting->{$DashboardModule},
            );
        }
    }

    print "...done.\n";
    print "--- Customer user generic modules...";

    # customer user generic module
    $Setting = $ConfigObject->Get('Frontend::CustomerUser::Item');

    CUSTOMERUSERGENERICMODULE:
    for my $CustomerUserGenericModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$CustomerUserGenericModule}->{'Module'} // '';

        if ( $Module !~ m{Kernel::Output::HTML::CustomerUser(\w+)} ) {
            next CUSTOMERUSERGENERICMODULE;
        }
        $Module =~ s{Kernel::Output::HTML::CustomerUser(\w+)}{Kernel::Output::HTML::CustomerUser::$1}xmsg;
        $Setting->{$CustomerUserGenericModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::CustomerUser::Item###' . $CustomerUserGenericModule,
            Value => $Setting->{$CustomerUserGenericModule},
        );
    }

    # set new setting for CustomerNewTicketQueueSelectionGeneric
    my $Success = $SysConfigObject->ConfigItemUpdate(
        Valid => 2,
        Key   => 'CustomerPanel::NewTicketQueueSelectionModule',
        Value => 'Kernel::Output::HTML::CustomerNewTicket::QueueSelectionGeneric',
    );

    print "...done.\n";
    print "--- FilterText modules...";

    # output filter module
    $Setting = $ConfigObject->Get('Frontend::Output::FilterText');

    FILTERTEXTMODULE:
    for my $FilterTextModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$FilterTextModule}->{'Module'} // '';

        if ( $Module !~ m{Kernel::Output::HTML::OutputFilter::Text(\w+)} ) {
            next FILTERTEXTMODULE;
        }
        $Module =~ s{Kernel::Output::HTML::OutputFilter::Text(\w+)}{Kernel::Output::HTML::FilterText::$1}xmsg;
        $Setting->{$FilterTextModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::Output::FilterText###' . $FilterTextModule,
            Value => $Setting->{$FilterTextModule},
        );
    }

    print "...done.\n";

    return 1;
}

=item _AddZoomMenuClusters()

Change zoom tool-bar configurations to receive the new cluster feature.

    _AddZoomMenuClusters();

=cut

sub _AddZoomMenuClusters {

    # get needed objects
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Toolbar Modules
    my $Setting = $ConfigObject->Get('Ticket::Frontend::MenuModule');

    # collect icon data for toolbar items
    my %ClusterData = (
        '100-Lock' => {
            'ClusterName'     => 'Miscellaneous',
            'ClusterPriority' => 800,
        },
        '200-History' => {
            'ClusterName'     => 'Miscellaneous',
            'ClusterPriority' => 800,
        },
        '310-FreeText' => {
            'ClusterName'     => 'Miscellaneous',
            'ClusterPriority' => 800,
        },
        '320-Link' => {
            'ClusterName'     => 'Miscellaneous',
            'ClusterPriority' => 800,
        },
        '430-Merge' => {
            'ClusterName'     => 'Miscellaneous',
            'ClusterPriority' => 800,
        },
        '400-Owner' => {
            'ClusterName'     => 'People',
            'ClusterPriority' => 430,
        },
        '410-Responsible' => {
            'ClusterName'     => 'People',
            'ClusterPriority' => 430,
        },
        '420-Customer' => {
            'ClusterName'     => 'People',
            'ClusterPriority' => 430,
        },
        '420-Note' => {
            'ClusterName'     => 'Communication',
            'ClusterPriority' => 435,
        },
        '425-Phone Call Outbound' => {
            'ClusterName'     => 'Communication',
            'ClusterPriority' => 435,
        },
        '426-Phone Call Inbound' => {
            'ClusterName'     => 'Communication',
            'ClusterPriority' => 435,
        },
        '427-Email Outbound' => {
            'ClusterName'     => 'Communication',
            'ClusterPriority' => 435,
        },
    );

    MENUMODULE:
    for my $MenuModule ( sort keys %{$Setting} ) {

        next MENUMODULE if !IsHashRefWithData( $Setting->{$MenuModule} );

        # set cluster data
        for my $Attribute ( sort keys %{ $ClusterData{$MenuModule} } ) {
            $Setting->{$MenuModule}->{$Attribute} = $ClusterData{$MenuModule}->{$Attribute};
        }

        # save setting
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::MenuModule###' . $MenuModule,
            Value => $Setting->{$MenuModule},
        );
    }

    print "...done.\n";

    return 1;
}

=item _MigrateSettings()

Migrate different settings

    _MigrateSettings();

=cut

sub _MigrateSettings {

    # set transport name
    my $TransportName = 'Email';
    my $PreferenceKey = 'NotificationTransport';

    # get needed objects
    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');
    my $DBObject                = $Kernel::OM->Get('Kernel::System::DB');
    my $JSONObject              = $Kernel::OM->Get('Kernel::System::JSON');

    my %NotificationList = $NotificationEventObject->NotificationList();

    # get old preferences by user
    return if !$DBObject->Prepare(
        SQL => '
            SELECT user_id, preferences_key, preferences_value
            FROM user_preferences
            WHERE preferences_key LIKE(\'UserSend%\')
        ',
    );

    my %OldPreferences;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $OldPreferences{ $Row[0] }->{ $Row[1] } = $Row[2];
    }

    # create identifiers per each notification
    my %IdentifierList;
    NOTIFICATION:
    for my $NotificationID ( sort keys %NotificationList ) {
        next NOTIFICATION if !$NotificationList{$NotificationID};
        $IdentifierList{ $NotificationList{$NotificationID} } = "Notification-$NotificationID-$TransportName";
    }

    # set an OldPreference => NewNotification mapping
    my %NotificationsPreferencesMapping = (
        UserSendNewTicketNotification     => 'New ticket created',
        UserSendFollowUpNotification      => 'Follow-up on an unlocked ticket',
        UserSendLockTimeoutNotification   => 'Automatic ticket unlock',
        UserSendMoveNotification          => 'Ticket moved',
        UserSendServiceUpdateNotification => 'Ticket service update',
        UserSendWatcherNotification       => '',                                 #TODO: verify it this should be removed
    );

    # loop over each user
    for my $UserID ( sort keys %OldPreferences ) {

        my %UserNotificationTransport;

        # loop over the stored preferences per user
        PREFERENCE:
        for my $Preference ( sort keys %{ $OldPreferences{$UserID} } ) {

            next PREFERENCE if !$NotificationsPreferencesMapping{$Preference};

            my $PreferenceValue = 1;

            # just if the user explicitly says No Notification it will set to 0
            if ( defined $OldPreferences{$UserID}->{$Preference} && !$OldPreferences{$UserID}->{$Preference} ) {
                $PreferenceValue = 0;
            }

            # get key=>value pair for each notification
            my $NotificationName = $NotificationsPreferencesMapping{$Preference};
            my $Identifier       = $IdentifierList{$NotificationName};

            # set the value for the identifier
            $UserNotificationTransport{$Identifier} = $PreferenceValue;

            if ( $NotificationName eq 'Follow-up on an unlocked ticket' ) {

                $Identifier = $IdentifierList{'Follow-up on a locked ticket'};

                # set the value for the identifier
                $UserNotificationTransport{$Identifier} = $PreferenceValue;
            }
        }

        # encode data
        my $Value = $JSONObject->Encode(
            Data => \%UserNotificationTransport,
        );

        # do the update
        return if !$DBObject->Do(
            SQL => '
                INSERT INTO user_preferences
                (user_id, preferences_key, preferences_value)
                values ( ?, ?, ? )',
            Bind => [ \$UserID, \$PreferenceKey, \$Value ],
        );

    }

    # delete old UserSend preferences
    return if !$DBObject->Prepare(
        SQL => '
            DELETE FROM user_preferences
            WHERE preferences_key LIKE(\'UserSend%\')
        ',
    );

    return 1;
}

=item _UninstallMergedFeatureAddOns()

Safely uninstall packages from the database.

    UninstallMergedFeatureAddOns();

=cut

sub _UninstallMergedFeatureAddOns {
    my $PackageObject = Kernel::System::Package->new();

    # Purge relevant caches before uninstalling to avoid errors because of
    #   inconsistent states.
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'RepositoryList',
    );
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'RepositoryGet',
    );
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'XMLParse',
    );

    # Uninstall FeatureAddons that were merged, keeping the DB structures intact.
    for my $PackageName (
        qw( OTRSGenericInterfaceMappingXSLT )
        )
    {
        my $Success = $PackageObject->_PackageUninstallMerged(
            Name => $PackageName,
        );
        if ( !$Success ) {
            print STDERR "There was an error uninstalling package $PackageName\n";
            return;
        }
    }

    return 1;
}

=item _NewAgentNotificationsLanguageGet()

Retrieve the languages for each notification.

    _NewAgentNotificationsLanguageGet();

=cut

sub _NewAgentNotificationsLanguageGet {

    # notification languages container
    my %NotificationLanguages = (

        'Ticket create notification' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

das Ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] wurde in der Queue <OTRS_TICKET_Queue> erstellt.

<OTRS_CUSTOMER_REALNAME> schrieb:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket erstellt: <OTRS_TICKET_Title>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] has been created in queue <OTRS_TICKET_Queue>.

<OTRS_CUSTOMER_REALNAME> wrote:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket Created: <OTRS_TICKET_Title>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] se ha  creado en la fila <OTRS_TICKET_Queue>.

<OTRS_CUSTOMER_REALNAME> escribió:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Se ha creado un ticket: <OTRS_TICKET_Title>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] foi criado na fila <OTRS_TICKET_Queue>.

<OTRS_CUSTOMER_REALNAME> escreveu:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket criado: <OTRS_TICKET_Title>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据工单 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已在等待队列 已在队列<OTRS_TICKET_Queue> 中被编制完成。中被创建完成

<OTRS_CUSTOMER_REALNAME> 写道：
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => '票据编制 工单已创建：<OTRS_TICKET_Title>'
                }
        },
        'Ticket escalation notification' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

das Ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] ist eskaliert!

Eskaliert am: <OTRS_TICKET_EscalationDestinationDate>
Eskaliert seit: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket-Eskalation! <OTRS_TICKET_Title>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] is escalated!

Escalated at: <OTRS_TICKET_EscalationDestinationDate>
Escalated since: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket Escalation! <OTRS_TICKET_Title>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] se ha escalado!

Escaló: <OTRS_TICKET_EscalationDestinationDate>
Escalado desde: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => '¡Escalación de ticket! <OTRS_TICKET_Title>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] foi escalonado!

Escalonado em: <OTRS_TICKET_EscalationDestinationDate>
Escalonado desde: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Escalonamento do ticket! <OTRS_TICKET_Title>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据工单 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已被升级！

升级地点升级开始时间：<OTRS_TICKET_EscalationDestinationDate>
升级开始时间升级在：<OTRS_TICKET_EscalationDestinationIn>内

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => '票据升级！工单升级！<OTRS_TICKET_Title>'
                }
        },
        'Ticket escalation warning notification' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

das Ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] wird bald eskalieren!

Eskalation um: <OTRS_TICKET_EscalationDestinationDate>
Eskalation in: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket-Eskalations-Warnung! <OTRS_TICKET_Title>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] will escalate!

Escalation at: <OTRS_TICKET_EscalationDestinationDate>
Escalation in: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket Escalation Warning! <OTRS_TICKET_Title>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] se encuentra proximo a escalar!

Escalará: <OTRS_TICKET_EscalationDestinationDate>
Escalará en: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Aviso de escalación de ticket! <OTRS_TICKET_Title>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] será escalonado!

Escalonamento em: <OTRS_TICKET_EscalationDestinationDate>
Escalonamento em: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Aviso de escalonamento do ticket! <OTRS_TICKET_Title>'
            },
            'zh_CN' => {
                'Body' => '您好  <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据工单 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已被升级已被更新！

升级地点升级开始时间：<OTRS_TICKET_EscalationDestinationDate>
升级开始时间升级在：<OTRS_TICKET_EscalationDestinationIn>内

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => '工单升级警告Ticket Escalation Warning! <OTRS_TICKET_Title>'
                }
        },
        'Ticket follow-up notification (locked)' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

zum gesperrten Ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] gibt es eine Nachfrage.

<OTRS_CUSTOMER_REALNAME> schrieb:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Nachfrage zum gesperrten Ticket: <OTRS_CUSTOMER_SUBJECT[24]>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the locked ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] received a follow-up.

<OTRS_CUSTOMER_REALNAME> wrote:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Locked Ticket Follow-Up: <OTRS_CUSTOMER_SUBJECT[24]>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket bloqueado [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] recibió un seguimiento.

<OTRS_CUSTOMER_REALNAME> escribió:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Seguimiento a ticket bloqueado: <OTRS_CUSTOMER_SUBJECT[24]>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket bloqueado [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] recebeu uma resposta.

<OTRS_CUSTOMER_REALNAME> escreveu:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Acompanhamento do ticket bloqueado: <OTRS_CUSTOMER_SUBJECT[24]>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

加锁票据锁定工单 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已获得一项后续作业。

<OTRS_CUSTOMER_REALNAME> 写道：
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => '加锁票据的后续作业 锁定工单后续：<OTRS_CUSTOMER_SUBJECT[24]>'
                }
        },
        'Ticket follow-up notification (unlocked)' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

zum freigegebenen Ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] gibt es eine Nachfrage.

<OTRS_CUSTOMER_REALNAME> schrieb:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Nachfrage zum freigegebenen Ticket: <OTRS_CUSTOMER_SUBJECT[24]>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the unlocked ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] received a follow-up.

<OTRS_CUSTOMER_REALNAME> wrote:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Unlocked Ticket Follow-Up: <OTRS_CUSTOMER_SUBJECT[24]>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket desbloqueado [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] recibió un seguimiento.

<OTRS_CUSTOMER_REALNAME> escribió:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Seguimiento a ticket desbloqueado: <OTRS_CUSTOMER_SUBJECT[24]>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket desbloqueado [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] recebeu uma resposta.

<OTRS_CUSTOMER_REALNAME> escreveu:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Acompanhamento do ticket desbloqueado: <OTRS_CUSTOMER_SUBJECT[24]>'
            },
            'zh_CN' => {
                'Body' => '您好<OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

解锁票据解锁工单[<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已获得一项后续作业。

<OTRS_CUSTOMER_REALNAME> 写道:
<OTRS_CUSTOMER_Body[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => '解锁票据的后续作业解锁工单的后续： <OTRS_CUSTOMER_SUBJECT[24]>'
                }
        },
        'Ticket lock timeout notification' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

die Sperrzeit des Tickets [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] ist abgelaufen. Es ist jetzt freigegeben.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticketsperre aufgehoben: <OTRS_TICKET_Title>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] has reached its lock timeout period and is now unlocked.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket Lock Timeout: <OTRS_TICKET_Title>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>]  ha alcanzado su tiempo de espera como bloqueado y ahora se encuentra desbloqueado.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Terminó tiempo de bloqueo: <OTRS_TICKET_Title>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] atingiu o seu período de tempo limite de bloqueio e agora está desbloqueado.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Tempo limite de bloqueio do ticket: <OTRS_TICKET_Title>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据工单 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已达到其锁定时限，现在解锁。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => '票据加锁超时工单锁定超时：<OTRS_TICKET_Title>'
                }
        },
        'Ticket new note notification' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

<OTRS_CURRENT_UserFullname> schrieb:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket-Notiz: <OTRS_AGENT_SUBJECT[24]>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

<OTRS_CURRENT_UserFullname> wrote:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket Note: <OTRS_AGENT_SUBJECT[24]>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

<OTRS_CURRENT_UserFullname> escribió:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Nota de ticket: <OTRS_AGENT_SUBJECT[24]>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

<OTRS_CURRENT_UserFullname> escreveu:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Observação sobre o ticket: <OTRS_AGENT_SUBJECT[24]>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

<OTRS_CURRENT_UserFullname> 写道：
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => '票据备注工单备注：<OTRS_AGENT_SUBJECT[24]>'
                }
        },
        'Ticket owner update notification' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

der Besitzer des Tickets [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] wurde von <OTRS_CURRENT_UserFullname> geändert auf <OTRS_TICKET_OWNER_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Änderung des Ticket-Besitzers auf <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the owner of ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] has been updated to <OTRS_TICKET_OWNER_UserFullname> by <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket Owner Update to <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el propietario del ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] se ha modificado  a <OTRS_TICKET_OWNER_UserFullname> por <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject' => 'Actualización del propietario de ticket a <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o proprietário do ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] foi atualizado para <OTRS_TICKET_OWNER_UserFullname> por <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject' =>
                    'Atualização de proprietário de ticket para <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据的所有人工单的所有者 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已被该信为 <OTRS_TICKET_OWNER_UserFullname> 的 <OTRS_CURRENT_UserFullname>。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject' =>
                    '票据的拥有人升级为工单所有者更新为 <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>'
                }
        },
        'Ticket pending reminder notification (locked)' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

die Erinnerungszeit für das gesperrte Ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] wurde erreicht.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Erinnerungszeit des gesperrten Tickets erreicht: <OTRS_TICKET_Title>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the pending reminder time of the locked ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] has been reached.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Locked Ticket Pending Reminder Time Reached: <OTRS_TICKET_Title>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el tiempo del recordatorio pendiente para el ticket bloqueado [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] se ha alcanzado.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Recordatorio pendiente en ticket bloqueado se ha alcanzado: <OTRS_TICKET_Title>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o tempo de lembrete pendente do ticket bloqueado [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] foi atingido.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Tempo de Lembrete de Pendência do Ticket Bloqueado Atingido: <OTRS_TICKET_Title>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

锁定票据即将到期的提醒时间锁定工单挂起提醒时间 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已到达。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject' =>
                    '已达到锁定票据即将到期的提醒时间已到达锁定工单挂起提醒时间：<OTRS_TICKET_Title>'
                }
        },
        'Ticket pending reminder notification (unlocked)' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

die Erinnerungszeit für das freigegebene Ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] wurde erreicht.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Erinnerungszeit des freigegebenen Tickets erreicht: <OTRS_TICKET_Title>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the pending reminder time of the unlocked ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] has been reached.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Unlocked Ticket Pending Reminder Time Reached: <OTRS_TICKET_Title>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el tiempo del recordatorio pendiente para el ticket desbloqueado [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] se ha alcanzado.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Recordatorio pendiente en ticket desbloqueado se ha alcanzado: <OTRS_TICKET_Title>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o tempo de lembrete pendente do ticket desbloqueado [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] foi atingido.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Tempo de Lembrete Pendente do Ticket Desbloqueado Atingido: <OTRS_TICKET_Title>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

未锁定票据即将到期的提醒时间未锁定工单的挂起提醒时间 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已到已到达。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject' =>
                    '未锁定票据即将到期的提醒时间已到已到未锁定工单的挂起提醒时间：<OTRS_TICKET_Title>'
                }
        },
        'Ticket queue update notification' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

das Ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] wurde in die Queue <OTRS_TICKET_Queue> verschoben.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket-Queue geändert zu <OTRS_TICKET_Queue>: <OTRS_TICKET_Title>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] has been updated to queue <OTRS_TICKET_Queue>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket Queue Update to <OTRS_TICKET_Queue>: <OTRS_TICKET_Title>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] ha cambiado de fila a <OTRS_TICKET_Queue>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'La fila del ticket ha cambiado a <OTRS_TICKET_Queue>: <OTRS_TICKET_Title>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] foi atualizado na fila <OTRS_TICKET_Queue>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Atualização da fila do ticket para <OTRS_TICKET_Queue>: <OTRS_TICKET_Title>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据工单 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已被升级为序列已被更新为队列 <OTRS_TICKET_Queue>。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => '票据序列已升级为工单队列更新为<OTRS_TICKET_Queue>: <OTRS_TICKET_Title>'
                }
        },
        'Ticket responsible update notification' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

der Verantwortliche für das Ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] wurde von <OTRS_CURRENT_UserFullname> geändert auf <OTRS_TICKET_RESPONSIBLE_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject' =>
                    'Änderung des Ticket-Verantwortlichen auf <OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the responsible agent of ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] has been updated to <OTRS_TICKET_RESPONSIBLE_UserFullname> by <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket Responsible Update to <OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el agente responsable del ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] se ha modificado a <OTRS_TICKET_RESPONSIBLE_UserFullname> por <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject' =>
                    'Actualización del responsable de ticket a <OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o agente responsável do ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] foi atualizado para <OTRS_TICKET_RESPONSIBLE_UserFullname> por <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject' =>
                    'Atualização de responsável de ticket para <OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据的负责代理工单的服务人员 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已被升级为 已被更新为 <OTRS_TICKET_RESPONSIBLE_UserFullname> 的 <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject' =>
                    '票据的负责人 工单负责人更新为<OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>'
                }
        },
        'Ticket service update notification' => {
            'de' => {
                'Body' => 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

der Service des Tickets [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] wurde geändert zu <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket-Service aktualisiert zu <OTRS_TICKET_Service>: <OTRS_TICKET_Title>'
            },
            'en' => {
                'Body' => 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the service of ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] has been updated to <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Ticket Service Update to <OTRS_TICKET_Service>: <OTRS_TICKET_Title>'
            },
            'es_MX' => {
                'Body' => 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el servicio del ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] se ha cambiado a <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'El servicio del ticket ha cambiado a <OTRS_TICKET_Service>: <OTRS_TICKET_Title>'
            },
            'pt_BR' => {
                'Body' => 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o serviço do ticket [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] foi atualizado para <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => 'Atualização do serviço do ticket para <OTRS_TICKET_Service>: <OTRS_TICKET_Title>'
            },
            'zh_CN' => {
                'Body' => '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据服务工单服务 [<OTRS_CONFIG_TicketHook><OTRS_TICKET_TicketNumber>] 已被升级为已被更新为 <OTRS_TICKET_Service>。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>',
                'ContentType' => 'text/plain',
                'Subject'     => '票据服务升级为工单服务更新为<OTRS_TICKET_Service>: <OTRS_TICKET_Title>'
                }
            }

    );

    return %NotificationLanguages;

}

1;
