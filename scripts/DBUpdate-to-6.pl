#!/usr/bin/perl
# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use Getopt::Long;
use IO::Interactive qw(is_interactive);

use Kernel::Config;
use Kernel::System::Cache;
use Kernel::System::ObjectManager;
use Kernel::System::Package;
use Kernel::System::SysConfig;

use Kernel::System::VariableCheck qw(:all);

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-DBUpdate-to-6.pl',
    },
);

# get options
my %Opts = (
    Help           => 0,
    NonInteractive => 0,
);
Getopt::Long::GetOptions(
    'help',            \$Opts{Help},
    'non-interactive', \$Opts{NonInteractive},
);

{
    if ( $Opts{Help} ) {
        print <<"EOF";

DBUpdate-to-6.pl - Upgrade script for OTRS 5 to 6 migration.
Copyright (C) 2001-2017 OTRS AG, http://otrs.com/

Usage: $0
    Options are as follows:
        --help              display this help
        --non-interactive   skip interactive input and display steps to execute after script has been executed

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
            Message => 'Drop deprecated table gi_object_lock_state',
            Command => \&_DropObjectLockState,
        },
        {
            Message => 'Migrate PossibleNextActions setting',
            Command => \&_MigratePossibleNextActions,
        },
        {
            Message => 'Migrating time zone configuration',
            Command => \&_MigrateTimeZoneConfiguration,
        },
        {
            Message => 'Create appointment calendar tables',
            Command => \&_CreateAppointmentCalendarTables,
        },
        {
            Message => 'Update calendar appointment future tasks',
            Command => \&_UpdateAppointmentCalendarFutureTasks,
        },
        {
            Message => 'Add basic appointment notification for reminders',
            Command => \&_AddAppointmentCalendarNotification,
        },

        # ...

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

Check if framework is the correct one for Dynamic Fields migration.

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
    if ( $Version !~ /^6\.0(.*)$/ ) {

        die "Error: You are trying to run this script on the wrong framework version $Version!"
    }

    return 1;
}

=item _DropObjectLockState()

Drop deprecated gi_object_lock_state table if empty.

    _DropObjectLockState();

=cut

sub _DropObjectLockState {

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %Tables = map { lc($_) => 1 } $DBObject->ListTables();
    return 1 if !$Tables{gi_object_lock_state};

    # get number of remaining entries
    return if !$DBObject->Prepare(
        SQL => 'SELECT COUNT(*) FROM gi_object_lock_state',
    );

    my $Count;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
    }

    # delete table but only if table is empty
    # if there are some entries left, these must be deleted by other modules
    # so we give them a chance to be migrated from these modules
    if ($Count) {
        print STDERR
            "\nThere are still entries in your gi_object_lock_state table, therefore it will not be deleted.\n";
        return 1;
    }

    # drop table 'notifications'
    my $XMLString = '<TableDrop Name="gi_object_lock_state"/>';

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

=item _MigratePossibleNextActions()

The seetting "PossibleNextActions" was changed in OTRS 6. Make sure that it is adopted also for systems
  that had this setting locally modified. Basically keys and values have be swapped, but only once.

=cut

sub _MigratePossibleNextActions {
    my $PossibleNextActions = $Kernel::OM->Get('Kernel::Config')->Get('PossibleNextActions') || {};

    # create a lookup array to no not modify the looping variable
    my @Actions = sort keys %{ $PossibleNextActions // {} };

    my $Updated;
    ACTION:
    for my $Action (@Actions) {

        # skip all keys that looks like an URL (e.g. TT Env('CGIHandle')
        #   or staring with http(s), ftp(s), matilto:, ot www.)
        next ACTION if $Action =~ m{\A \[% [\s]+ Env\( }msxi;
        next ACTION if $Action =~ m{\A http [s]? :// }msxi;
        next ACTION if $Action =~ m{\A ftp [s]? :// }msxi;
        next ACTION if $Action =~ m{\A mailto : }msxi;
        next ACTION if $Action =~ m{\A www \. }msxi;

        # remember the value for the current key
        my $ActionValue = $PossibleNextActions->{$Action};

        # remove current key and add the inverted key value pair
        delete $PossibleNextActions->{$Action};
        $PossibleNextActions->{$ActionValue} = $Action;

        $Updated = 1;
    }

    return 1 if !$Updated;

    my $Success = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
        Valid => 1,
        Key   => 'PossibleNextActions',
        Value => $PossibleNextActions,
    );
    return $Success;
}

=item _MigrateTimeZoneConfiguration()

OTRS 6 uses real time zones (e. g. 'Europe/Berlin') instead of time offsets (e. g. '+2').

=cut

sub _MigrateTimeZoneConfiguration {

    #
    # Remove agent and customer UserTimeZone preferences because they contain
    # offsets instead of time zones
    #
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM user_preferences WHERE preferences_key = ?',
        Bind => [
            \'UserTimeZone',
        ],
    );
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM customer_preferences WHERE preferences_key = ?',
        Bind => [
            \'UserTimeZone',
        ],
    );

    #
    # Check for interactive mode
    #
    if ( $Opts{NonInteractive} || !is_interactive() ) {
        print
            "\n\tMigration of time zone settings is being skipped because this script is being executed in non-interactive mode.\n";
        print "\tPlease make sure to set the following SysConfig options after this script has been executed:\n";
        print "\tOTRSTimeZone\n";
        print "\tUserDefaultTimeZone\n";
        print "\tTimeZone::Calendar1 to TimeZone::Calendar9 (depending on the calendars in use)\n";
        return 1;
    }

    #
    # OTRSTimeZone
    #

    # Get system time zone
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            TimeZone => 'UTC',
        },
    );
    my $SystemTimeZone = $DateTimeObject->SystemTimeZoneGet() || 'UTC';
    $DateTimeObject->ToTimeZone( TimeZone => $SystemTimeZone );

    # Get configured deprecated time zone offset
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $TimeOffset = int( $ConfigObject->Get('TimeZone') || 0 );

    # Calculate complete time offset (server time zone + OTRS time offset)
    my $SuggestedTimeZone = $TimeOffset ? '' : $SystemTimeZone;
    $TimeOffset += $DateTimeObject->Format( Format => '%{offset}' ) / 60 / 60;

    # Show suggestions for time zone
    my %TimeZones = map { $_ => 1 } @{ $DateTimeObject->TimeZoneList() };
    my $TimeZoneByOffset = $DateTimeObject->TimeZoneByOffsetList();
    if ( exists $TimeZoneByOffset->{$TimeOffset} ) {
        print
            "\nThe currently configured time offset is $TimeOffset hours, these are the suggestions for a corresponding OTRS time zone:\n\n";

        print join( "\n", sort @{ $TimeZoneByOffset->{$TimeOffset} } ) . "\n";
    }

    if ( $SuggestedTimeZone && $TimeZones{$SuggestedTimeZone} ) {
        print "\nIt seems that $SuggestedTimeZone should be the correct time zone to set for your OTRS.\n";
    }

    my $Success = _ConfigureTimeZone(
        ConfigKey => 'OTRSTimeZone',
        TimeZones => \%TimeZones,
    );

    return if !$Success;

    #
    # UserDefaultTimeZone
    #
    $Success = _ConfigureTimeZone(
        ConfigKey => 'UserDefaultTimeZone',
        TimeZones => \%TimeZones,
    );

    return if !$Success;

    #
    # TimeZone::Calendar[1..9] (but only those that have already a time offset set)
    #
    CALENDAR:
    for my $Calendar ( 1 .. 9 ) {
        my $ConfigKey        = "TimeZone::Calendar$Calendar";
        my $CalendarTimeZone = $ConfigObject->Get($ConfigKey);
        next CALENDAR if !defined $CalendarTimeZone;

        $Success = _ConfigureTimeZone(
            ConfigKey => $ConfigKey,
            TimeZones => \%TimeZones,
        );

        return if !$Success;
    }

    return 1;
}

sub _ConfigureTimeZone {
    my (%Param) = @_;

    my $TimeZone = _AskForTimeZone(
        ConfigKey => $Param{ConfigKey},
        TimeZones => $Param{TimeZones},
    );

    # Set OTRSTimeZone
    my $Success = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
        Valid => 1,
        Key   => $Param{ConfigKey},
        Value => $TimeZone,
    );

    return $Success;
}

sub _AskForTimeZone {
    my (%Param) = @_;

    my $TimeZone;
    print "\n";
    while ( !defined $TimeZone || !$Param{TimeZones}->{$TimeZone} ) {
        print
            "Enter the time zone to use for $Param{ConfigKey} (leave empty to show a list of all available time zones): ";
        $TimeZone = <>;

        # Remove white space
        $TimeZone =~ s{\s}{}smx;

        if ( length $TimeZone ) {
            if ( !$Param{TimeZones}->{$TimeZone} ) {
                print "Invalid time zone.\n";
            }
        }
        else {
            # Show list of all available time zones
            print join( "\n", sort keys %{ $Param{TimeZones} } ) . "\n";
        }
    }

    return $TimeZone;
}

=item _CreateAppointmentCalendarTables()

Checks if the appointment calendar tables exist, and if they don't they will be created. Also checks
if package version is up to date and executes database upgrade statements if needed.

    _CreateAppointmentCalendarTables();

=cut

sub _CreateAppointmentCalendarTables {
    my $DBObject      = $Kernel::OM->Get('Kernel::System::DB');
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    my $XMLObject     = $Kernel::OM->Get('Kernel::System::XML');

    # Get list of all installed packages.
    my @RepositoryList = $PackageObject->RepositoryList();

    # Check if the appointment calendar tables already exist, by checking if OTRSAppointmentCalendar
    #   package is installed. Also check if version is lower than 5.0.2, in order to execute some
    #   database upgrade statements too.
    my $PackageVersion;
    my $DBUpdateNeeded;

    PACKAGE:
    for my $Package (@RepositoryList) {

        # Package is not the OTRSAppointmentCalendar package.
        next PACKAGE if $Package->{Name}->{Content} ne 'OTRSAppointmentCalendar';

        $PackageVersion = $Package->{Version}->{Content};

        if ($PackageVersion) {
            $DBUpdateNeeded = _CheckVersion(
                Version1 => '5.0.2',
                Version2 => $PackageVersion,
                Type     => 'Max',
            );
        }
    }

    if ($PackageVersion) {
        print "\nFound package OTRSAppointmentCalendar $PackageVersion";

        # Database upgrade is needed, because current version is not the latest.
        if ($DBUpdateNeeded) {
            print ", executing database upgrade...\n";

            my @XMLStrings = (
                '
                    <TableAlter Name="calendar">
                        <UniqueDrop Name="calendar_id" />
                    </TableAlter>
                ', '
                    <TableAlter Name="calendar_appointment">
                        <UniqueDrop Name="calendar_appointment_id" />
                    </TableAlter>
                ',
            );

            # Create database specific SQL.
            my @SQL;
            my @SQLPost;
            for my $XMLString (@XMLStrings) {
                my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

                # Create database specific SQL.
                push @SQL, $DBObject->SQLProcessor(
                    Database => \@XMLARRAY,
                );

                # Create database specific PostSQL.
                push @SQLPost, $DBObject->SQLProcessorPost();
            }

            # Execute SQL.
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

        # Appointment calendar tables exist and are up to date, so we do not have to create or
        #   upgrade them here.
        print ", skipping database upgrade...\n";

        return 1;
    }

    # Define the XML data for the appointment calendar tables.
    my @XMLStrings = (
        '
            <TableCreate Name="calendar">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
                <Column Name="group_id" Required="true" Type="INTEGER" />
                <Column Name="name" Required="true" Size="200" Type="VARCHAR" />
                <Column Name="salt_string" Required="true" Size="64" Type="VARCHAR" />
                <Column Name="color" Required="true" Size="7" Type="VARCHAR" />
                <Column Name="ticket_appointments" Required="false" Type="LONGBLOB" />
                <Column Name="valid_id" Required="true" Type="SMALLINT" />
                <Column Name="create_time" Required="true" Type="DATE" />
                <Column Name="create_by" Required="true" Type="INTEGER" />
                <Column Name="change_time" Required="true" Type="DATE" />
                <Column Name="change_by" Required="true" Type="INTEGER" />
                <Unique Name="calendar_name">
                    <UniqueColumn Name="name" />
                </Unique>
                <ForeignKey ForeignTable="groups">
                    <Reference Local="group_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="valid">
                    <Reference Local="valid_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="users">
                    <Reference Local="create_by" Foreign="id" />
                    <Reference Local="change_by" Foreign="id" />
                </ForeignKey>
            </TableCreate>
        ', '
            <TableCreate Name="calendar_appointment">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
                <Column Name="parent_id" Type="BIGINT" />
                <Column Name="calendar_id" Required="true" Type="BIGINT" />
                <Column Name="unique_id" Required="true" Size="255" Type="VARCHAR" />
                <Column Name="title" Required="true" Size="255" Type="VARCHAR" />
                <Column Name="description" Size="3800" Type="VARCHAR" />
                <Column Name="location" Size="255" Type="VARCHAR" />
                <Column Name="start_time" Required="true" Type="DATE" />
                <Column Name="end_time" Required="true" Type="DATE" />
                <Column Name="all_day" Type="SMALLINT" />
                <Column Name="notify_time" Type="DATE" />
                <Column Name="notify_template" Size="255" Type="VARCHAR" />
                <Column Name="notify_custom" Size="255" Type="VARCHAR" />
                <Column Name="notify_custom_unit_count" Type="BIGINT" />
                <Column Name="notify_custom_unit" Size="255" Type="VARCHAR" />
                <Column Name="notify_custom_unit_point" Size="255" Type="VARCHAR" />
                <Column Name="notify_custom_date" Type="DATE" />
                <Column Name="team_id" Size="3800" Type="VARCHAR" />
                <Column Name="resource_id" Size="3800" Type="VARCHAR" />
                <Column Name="recurring" Type="SMALLINT" />
                <Column Name="recur_type" Size="20" Type="VARCHAR" />
                <Column Name="recur_freq" Size="255" Type="VARCHAR" />
                <Column Name="recur_count" Type="INTEGER" />
                <Column Name="recur_interval" Type="INTEGER" />
                <Column Name="recur_until" Type="DATE" />
                <Column Name="recur_id" Type="DATE" />
                <Column Name="recur_exclude" Size="3800" Type="VARCHAR" />
                <Column Name="ticket_appointment_rule_id" Size="32" Type="VARCHAR" />
                <Column Name="create_time" Type="DATE" />
                <Column Name="create_by" Type="INTEGER" />
                <Column Name="change_time" Type="DATE" />
                <Column Name="change_by" Type="INTEGER" />
                <ForeignKey ForeignTable="calendar">
                    <Reference Local="calendar_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="calendar_appointment">
                    <Reference Local="parent_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="users">
                    <Reference Local="create_by" Foreign="id" />
                    <Reference Local="change_by" Foreign="id" />
                </ForeignKey>
            </TableCreate>
        ', '
            <TableCreate Name="calendar_appointment_ticket">
                <Column Name="calendar_id" Required="true" Type="BIGINT" />
                <Column Name="ticket_id" Required="true" Type="BIGINT" />
                <Column Name="rule_id" Required="true" Size="32" Type="VARCHAR" />
                <Column Name="appointment_id" Required="true" Type="BIGINT" />
                <Unique Name="calendar_appointment_ticket_calendar_id_ticket_id_rule_id">
                    <UniqueColumn Name="calendar_id" />
                    <UniqueColumn Name="ticket_id" />
                    <UniqueColumn Name="rule_id" />
                </Unique>
                <Index Name="calendar_appointment_ticket_calendar_id">
                    <IndexColumn Name="calendar_id" />
                </Index>
                <Index Name="calendar_appointment_ticket_ticket_id">
                    <IndexColumn Name="ticket_id" />
                </Index>
                <Index Name="calendar_appointment_ticket_rule_id">
                    <IndexColumn Name="rule_id" />
                </Index>
                <Index Name="calendar_appointment_ticket_appointment_id">
                    <IndexColumn Name="appointment_id" />
                </Index>
                <ForeignKey ForeignTable="calendar">
                    <Reference Local="calendar_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="ticket">
                    <Reference Local="ticket_id" Foreign="id" />
                </ForeignKey>
                <ForeignKey ForeignTable="calendar_appointment">
                    <Reference Local="appointment_id" Foreign="id" />
                </ForeignKey>
            </TableCreate>
        ',
    );

    # Create database specific SQL and PostSQL commands out of XML.
    my @SQL;
    my @SQLPost;
    for my $XMLString (@XMLStrings) {
        my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

        # Create database specific SQL.
        push @SQL, $DBObject->SQLProcessor(
            Database => \@XMLARRAY,
        );

        # Create database specific PostSQL.
        push @SQLPost, $DBObject->SQLProcessorPost();
    }

    # Execute SQL.
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

=item _CheckVersion()

Compares two version numbers in a specified manner.

    my $Result = _CheckVersion(
        Version1 => '1.3.1',    # (required)
        Version2 => '1.2.4',    # (required)
        Type     => 'Min',      # (required) Type of comparison to test for:
                                #            Min - Version2 should be same or higher than Version1
                                #            Max - Version2 should be lower than Version1
    );

Returns 1 if comparison condition is met (see Type parameter for more info).

=cut

sub _CheckVersion {
    my (%Param) = @_;

    for (qw(Version1 Version2 Type)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$_ not defined!",
            );
            return;
        }
    }

    for my $Type (qw(Version1 Version2)) {
        my @Parts = split( /\./, $Param{$Type} );
        $Param{$Type} = 0;
        for ( 0 .. 4 ) {
            if ( defined $Parts[$_] ) {
                $Param{$Type} .= sprintf( "%04d", $Parts[$_] );
            }
            else {
                $Param{$Type} .= '0000';
            }
        }
        $Param{$Type} = int( $Param{$Type} );
    }

    if ( $Param{Type} eq 'Min' ) {
        return 1 if ( $Param{Version2} >= $Param{Version1} );
        return;
    }
    elsif ( $Param{Type} eq 'Max' ) {
        return 1 if ( $Param{Version2} < $Param{Version1} );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => 'Invalid Type!',
    );
    return;
}

=item _UpdateAppointmentCalendarFutureTasks()

Update possible changes on the calendar appointment future tasks.

    _UpdateAppointmentCalendarFutureTasks();

=cut

sub _UpdateAppointmentCalendarFutureTasks {

    # Update the future tasks.
    my $Success = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentFutureTasksUpdate();

    return $Success;
}

=item _AddAppointmentCalendarNotification()

Add basic appointment notification for reminders.

    _AddAppointmentCalendarNotification();

=cut

sub _AddAppointmentCalendarNotification {
    my %AppointmentNotifications = (
        'Appointment reminder notification' => {
            Data => {
                NotificationType       => ['Appointment'],
                VisibleForAgent        => [1],
                VisibleForAgentTooltip => [
                    'You will receive a notification each time a reminder time is reached for one of your appointments.'
                ],
                Events                => ['AppointmentNotification'],
                Recipients            => ['AppointmentAgentReadPermissions'],
                SendOnOutOfOffice     => [1],
                Transports            => ['Email'],
                AgentEnabledByDefault => ['Email'],
            },
            Message => {
                'de' => {
                    'Body' => 'Hallo &lt;OTRS_NOTIFICATION_RECIPIENT_UserFirstname&gt;,<br />
<br />
Termin &quot;&lt;OTRS_APPOINTMENT_TITLE&gt;&quot; hat seine Benachrichtigungszeit erreicht.<br />
<br />
Beschreibung: &lt;OTRS_APPOINTMENT_DESCRIPTION&gt;<br />
Standort: &lt;OTRS_APPOINTMENT_LOCATION&gt;<br />
Kalender: <span style="color: &lt;OTRS_CALENDAR_COLOR&gt;;">■</span> &lt;OTRS_CALENDAR_CALENDARNAME&gt;<br />
Startzeitpunkt: &lt;OTRS_APPOINTMENT_STARTTIME&gt;<br />
Endzeitpunkt: &lt;OTRS_APPOINTMENT_ENDTIME&gt;<br />
Ganztägig: &lt;OTRS_APPOINTMENT_ALLDAY&gt;<br />
Wiederholung: &lt;OTRS_APPOINTMENT_RECURRING&gt;<br />
<br />
<a href="&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;" title="&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;">&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;</a><br />
<br />
-- &lt;OTRS_CONFIG_NotificationSenderName&gt;',
                    'ContentType' => 'text/html',
                    'Subject'     => 'Erinnerung: <OTRS_APPOINTMENT_TITLE>',
                },
                'en' => {
                    'Body' => 'Hi &lt;OTRS_NOTIFICATION_RECIPIENT_UserFirstname&gt;,<br />
<br />
appointment &quot;&lt;OTRS_APPOINTMENT_TITLE&gt;&quot; has reached its notification time.<br />
<br />
Description: &lt;OTRS_APPOINTMENT_DESCRIPTION&gt;<br />
Location: &lt;OTRS_APPOINTMENT_LOCATION&gt;<br />
Calendar: <span style="color: &lt;OTRS_CALENDAR_COLOR&gt;;">■</span> &lt;OTRS_CALENDAR_CALENDARNAME&gt;<br />
Start date: &lt;OTRS_APPOINTMENT_STARTTIME&gt;<br />
End date: &lt;OTRS_APPOINTMENT_ENDTIME&gt;<br />
All-day: &lt;OTRS_APPOINTMENT_ALLDAY&gt;<br />
Repeat: &lt;OTRS_APPOINTMENT_RECURRING&gt;<br />
<br />
<a href="&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;" title="&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;">&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;</a><br />
<br />
-- &lt;OTRS_CONFIG_NotificationSenderName&gt;',
                    'ContentType' => 'text/html',
                    'Subject'     => 'Reminder: <OTRS_APPOINTMENT_TITLE>',
                },
                'hu' => {
                    'Body' => 'Kedves &lt;OTRS_NOTIFICATION_RECIPIENT_UserFirstname&gt;!<br />
<br />
A következő esemény elérte az értesítési idejét: &lt;OTRS_APPOINTMENT_TITLE&gt;<br />
<br />
Leírás: &lt;OTRS_APPOINTMENT_DESCRIPTION&gt;<br />
Hely: &lt;OTRS_APPOINTMENT_LOCATION&gt;<br />
Naptár: <span style="color: &lt;OTRS_CALENDAR_COLOR&gt;;">■</span> &lt;OTRS_CALENDAR_CALENDARNAME&gt;<br />
Kezdési dátum: &lt;OTRS_APPOINTMENT_STARTTIME&gt;<br />
Befejezési dátum: &lt;OTRS_APPOINTMENT_ENDTIME&gt;<br />
Egész napos: &lt;OTRS_APPOINTMENT_ALLDAY&gt;<br />
Ismétlődés: &lt;OTRS_APPOINTMENT_RECURRING&gt;<br />
<br />
<a href="&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;" title="&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;">&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;</a><br />
<br />
-- &lt;OTRS_CONFIG_NotificationSenderName&gt;',
                    'ContentType' => 'text/html',
                    'Subject'     => 'Emlékeztető: <OTRS_APPOINTMENT_TITLE>',
                },
                'sr_Cyrl' => {
                    'Body' => 'Здраво &lt;OTRS_NOTIFICATION_RECIPIENT_UserFirstname&gt;,<br />
<br />
време је за обавештење у вези термина &quot;&lt;OTRS_APPOINTMENT_TITLE&gt;&quot;.<br />
<br />
Опис: &lt;OTRS_APPOINTMENT_DESCRIPTION&gt;<br />
Локација: &lt;OTRS_APPOINTMENT_LOCATION&gt;<br />
Календар: <span style="color: &lt;OTRS_CALENDAR_COLOR&gt;;">■</span> &lt;OTRS_CALENDAR_CALENDARNAME&gt;<br />
Датум почетка: &lt;OTRS_APPOINTMENT_STARTTIME&gt;<br />
Датум краја: &lt;OTRS_APPOINTMENT_ENDTIME&gt;<br />
Целодневно: &lt;OTRS_APPOINTMENT_ALLDAY&gt;<br />
Понављање: &lt;OTRS_APPOINTMENT_RECURRING&gt;<br />
<br />
<a href="&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;" title="&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;">&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;</a><br />
<br />
-- &lt;OTRS_CONFIG_NotificationSenderName&gt;',
                    'ContentType' => 'text/html',
                    'Subject'     => 'Подсетник: <OTRS_APPOINTMENT_TITLE>',
                },
                'sr_Latn' => {
                    'Body' => 'Zdravo &lt;OTRS_NOTIFICATION_RECIPIENT_UserFirstname&gt;,<br />
<br />
vreme je za obaveštenje u vezi termina &quot;&lt;OTRS_APPOINTMENT_TITLE&gt;&quot;.<br />
<br />
Opis: &lt;OTRS_APPOINTMENT_DESCRIPTION&gt;<br />
Lokacije: &lt;OTRS_APPOINTMENT_LOCATION&gt;<br />
Kalendar: <span style="color: &lt;OTRS_CALENDAR_COLOR&gt;;">■</span> &lt;OTRS_CALENDAR_CALENDARNAME&gt;<br />
Datum početka: &lt;OTRS_APPOINTMENT_STARTTIME&gt;<br />
Datum kraja: &lt;OTRS_APPOINTMENT_ENDTIME&gt;<br />
Celodnevno: &lt;OTRS_APPOINTMENT_ALLDAY&gt;<br />
Ponavljanje: &lt;OTRS_APPOINTMENT_RECURRING&gt;<br />
<br />
<a href="&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;" title="&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;">&lt;OTRS_CONFIG_HttpType&gt;://&lt;OTRS_CONFIG_FQDN&gt;/&lt;OTRS_CONFIG_ScriptAlias&gt;index.pl?Action=AgentAppointmentCalendarOverview;AppointmentID=&lt;OTRS_APPOINTMENT_APPOINTMENTID&gt;</a><br />
<br />
-- &lt;OTRS_CONFIG_NotificationSenderName&gt;',
                    'ContentType' => 'text/html',
                    'Subject'     => 'Podsetnik: <OTRS_APPOINTMENT_TITLE>',
                },
            },
        },
    );

    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

    # Get all notifications of appointment type.
    my %NotificationList = $NotificationEventObject->NotificationList(
        Type => 'Appointment',
    );
    my %NotificationListReverse = reverse %NotificationList;

    NEWNOTIFICATION:
    for my $NotificationName ( sort keys %AppointmentNotifications ) {

        # Do not add new notification if one with the same name exists.
        next NEWNOTIFICATION if $NotificationListReverse{$NotificationName};

        # Add new event notification.
        my $ID = $NotificationEventObject->NotificationAdd(
            Name    => $NotificationName,
            Data    => $AppointmentNotifications{$NotificationName}->{Data},
            Message => $AppointmentNotifications{$NotificationName}->{Message},
            Comment => '',
            ValidID => $ValidListReverse{valid},
            UserID  => 1,
        );

        return if !$ID;
    }

    return 1;
}

=item _UninstallMergedFeatureAddOns()

Safely uninstall packages from the database.

    _UninstallMergedFeatureAddOns();

=cut

sub _UninstallMergedFeatureAddOns {
    my $CacheObject   = $Kernel::OM->Get('Kernel::System::Cache');
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    # Purge relevant caches before uninstalling to avoid errors because of inconsistent states.
    $CacheObject->CleanUp(
        Type => 'RepositoryList',
    );
    $CacheObject->CleanUp(
        Type => 'RepositoryGet',
    );
    $CacheObject->CleanUp(
        Type => 'XMLParse',
    );

    # Uninstall feature add-ons that were merged, keeping the DB structures intact.
    for my $PackageName (
        qw( OTRSAppointmentCalendar )
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

1;
