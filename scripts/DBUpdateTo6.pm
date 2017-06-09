# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6;    ## no critic

use strict;
use warnings;

use Time::HiRes ();

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo6 - Perform system upgrade from OTRS 5 to 6.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $DBUpdateTo6Object = $Kernel::OM->Get('scripts::DBUpdateTo6');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # enable auto-flushing of STDOUT
    $| = 1;    ## no critic

    my $AddTiming = $Param{CommandlineOptions}->{Timing} || 0;
    my $GeneralStart;
    my $MessageComplement = '';
    if ($AddTiming) {
        $GeneralStart      = Time::HiRes::time();
        $MessageComplement = " at $GeneralStart ";
    }

    my @Tasks = $Self->_TasksGet();

    print "\nMigration started$MessageComplement...\n\n";

    # get the number of total steps
    my $Steps = scalar @Tasks;
    my $Step  = 1;

    TASK:
    for my $Task (@Tasks) {

        next TASK if !$Task;
        next TASK if !$Task->{Module};

        my $ModuleName = "scripts::DBUpdateTo6::$Task->{Module}";
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($ModuleName) ) {
            next TASK;
        }

        my $StartTime;
        my $MessageTaskComplement = '';
        if ($AddTiming) {
            $StartTime             = Time::HiRes::time();
            $MessageTaskComplement = " started at $StartTime ";
        }

        # Show initial task message.
        print "Step $Step of $Steps: $Task->{Message}$MessageTaskComplement...";

        # Run module.
        $Kernel::OM->ObjectParamAdd(
            "scripts::DBUpdateTo6::$Task->{Module}" => {
                Opts => $Self->{Opts},
            },
        );

        my $Object = $Kernel::OM->Create($ModuleName);
        if ( !$Object ) {
            print "Was not possible to create object for: $ModuleName.";
            die;
        }

        my $Success = $Object->Run(%Param);

        my $StopTime;
        if ($AddTiming) {
            $StopTime = Time::HiRes::time();
            my $TaskTime = $StopTime - $StartTime;
            $MessageTaskComplement = ", finished at $StopTime, it took $TaskTime seconds";
        }

        if ($Success) {
            print "done$MessageTaskComplement.\n\n";
        }
        else {
            print "error$MessageTaskComplement.\n\n";
            die;
        }

        $Step++;
    }

    print "Migration completed!\n";

    return 1;
}

sub _TasksGet {
    my ( $Self, %Param ) = @_;

    my @Tasks = (
        {
            Message => 'Check framework version',
            Module  => 'FrameworkVersionCheck',
        },
        {
            Message => 'Upgrade database structure',
            Module  => 'UpgradeDatabaseStructure',
        },
        {
            Message => 'Migrate configuration',
            Module  => 'MigrateConfigEffectiveValues',
        },
        {
            Message => 'Refresh configuration cache after migration of OTRS 5 settings',
            Module  => 'RebuildConfig',
        },
        {
            Message => 'Migrating ticket storage configuration',
            Module  => 'MigrateTicketStorageModule',
        },
        {
            Message => 'Migrating article search index configuration',
            Module  => 'MigrateArticleSearchIndex',
        },
        {
            Message => 'Drop deprecated table gi_object_lock_state',
            Module  => 'DropObjectLockState',
        },
        {
            Message => 'Migrate PossibleNextActions setting',
            Module  => 'MigratePossibleNextActions',
        },
        {
            Message => 'Migrating time zone configuration',
            Module  => 'MigrateTimeZoneConfiguration',
        },
        {
            Message => 'Create appointment calendar tables',
            Module  => 'CreateAppointmentCalendarTables',
        },
        {
            Message => 'Create ticket number counter tables',
            Module  => 'CreateTicketNumberCounterTables',
        },
        {
            Message => 'Update calendar appointment future tasks',
            Module  => 'UpdateAppointmentCalendarFutureTasks',
        },
        {
            Message => 'Add basic appointment notification for reminders',
            Module  => 'AddAppointmentCalendarNotification',
        },
        {
            Message => 'Clean and drop group_user permission_value column',
            Module  => 'CleanGroupUserPermissionValue',
        },
        {
            Message => 'Migrate GenericAgent jobs configuration',
            Module  => 'MigrateGenericAgentJobs',
        },
        {
            Message => 'Migrate TicketAppointment rules configuration',
            Module  => 'MigrateTicketAppointments',
        },
        {
            Message => 'Migrate ticket statistics',
            Module  => 'MigrateTicketStats',
        },
        {
            Message => 'Create entries in new article table',
            Module  => 'OCBIMigrateArticleData',
        },
        {
            Message => 'Migrates ArticleType in ProcessManagement Data',
            Module  => 'OCBIMigrateProcessManagementData',
        },
        {
            Message => 'Migrates ArticleType in PostMaster filters',
            Module  => 'OCBIMigratePostMasterData',
        },
        {
            Message => 'Migrates ArticleType in GenericAgent jobs',
            Module  => 'OCBIMigrateGenericAgentData',
        },
        {
            Message => 'Migrate chat articles',
            Module  => 'OCBIMigrateChatData',
        },
        {
            Message => 'Migrate ticket history',
            Module  => 'OCBIMigrateTicketHistory',
        },

        # ...

        {
            Message => 'Uninstall Merged Feature Add-Ons',
            Module  => 'UninstallMergedFeatureAddOns',
        },
        {
            Message => 'Clean up the cache',
            Module  => 'CacheCleanup',
        },
        {
            Message => 'Refresh configuration cache another time',
            Module  => 'RebuildConfig',
        },
    );

    return @Tasks;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
