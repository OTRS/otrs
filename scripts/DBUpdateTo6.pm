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
use Kernel::System::VariableCheck qw(IsHashRefWithData);

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

    # Enable auto-flushing of STDOUT.
    $| = 1;    ## no critic

    # Enable timing feature in case it is call.
    my $TimingEnabled = $Param{CommandlineOptions}->{Timing} || 0;

    my $GeneralStartTime;
    if ($TimingEnabled) {
        $GeneralStartTime = Time::HiRes::time();
    }

    print "\n Migration started ... \n";

    my $SuccessfulMigration = 1;
    my @Components = ( 'CheckPreviousRequirement', 'Run' );

    COMPONENT:
    for my $Component (@Components) {

        $SuccessfulMigration = $Self->_ExecuteComponent(
            Component => $Component,
            %Param,
        );
        last COMPONENT if !$SuccessfulMigration;
    }

    if ($SuccessfulMigration) {
        print "\n\n\n Migration completed! \n\n";
    }
    else {
        print "\n\n\n Not possible to complete migration, check previous messages for more information. \n\n";
    }

    if ($TimingEnabled) {
        my $GeneralStopTime = Time::HiRes::time();
        my $GeneralExecutionTime = sprintf( "%.6f", $GeneralStopTime - $GeneralStartTime );
        print "    Migration took $GeneralExecutionTime seconds.\n\n";
    }

    return $SuccessfulMigration;
}

sub _ExecuteComponent {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Component} ) {
        print " Error: Need Component!\n\n";
        return;
    }

    my $Component = $Param{Component};

    # Enable timing feature in case it is call.
    my $TimingEnabled = $Param{CommandlineOptions}->{Timing} || 0;

    # Get migration tasks.
    my @Tasks = $Self->_TasksGet();

    # Get the number of total steps.
    my $Steps               = scalar @Tasks;
    my $CurrentStep         = 1;
    my $SuccessfulMigration = 1;

    # Show initial message for current component
    if ( $Component eq 'Run' ) {
        print "\n Executing tasks ... \n\n";
    }
    else {
        print "\n Checking requirements ... \n\n";
    }

    TASK:
    for my $Task (@Tasks) {

        next TASK if !$Task;
        next TASK if !$Task->{Module};

        my $ModuleName = "scripts::DBUpdateTo6::$Task->{Module}";
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($ModuleName) ) {
            $SuccessfulMigration = 0;
            last TASK;
        }

        my $TaskStartTime;
        if ($TimingEnabled) {
            $TaskStartTime = Time::HiRes::time();
        }

        # Run module.
        $Kernel::OM->ObjectParamAdd(
            "scripts::DBUpdateTo6::$Task->{Module}" => {
                Opts => $Self->{Opts},
            },
        );

        my $TaskObject = $Kernel::OM->Create($ModuleName);
        if ( !$TaskObject ) {
            print "\n    Error:Was not possible to create object for: $ModuleName.\n\n";
            $SuccessfulMigration = 0;
            last TASK;
        }

        my $Success = 1;

        # Execute Run-Component
        if ( $Component eq 'Run' ) {
            print "    Step $CurrentStep of $Steps: $Task->{Message} ...\n";
            $Success = $TaskObject->$Component(%Param);
        }

        # Execute previous check, printing a different message
        elsif ( $TaskObject->can($Component) ) {
            print "    Requirement check for: $Task->{Message} ...\n";
            $Success = $TaskObject->$Component(%Param);
        }

        # Do not handle timing if task has no appropriate component.
        else {
            next TASK;
        }

        if ($TimingEnabled) {
            my $StopTaskTime = Time::HiRes::time();
            my $ExecutionTaskTime = sprintf( "%.6f", $StopTaskTime - $TaskStartTime );
            print " ($ExecutionTaskTime seconds).";
        }

        if ( !$Success ) {
            $SuccessfulMigration = 0;
            last TASK;
        }

        $CurrentStep++;
    }

    return $SuccessfulMigration;
}

sub _TasksGet {
    my ( $Self, %Param ) = @_;

    my @Tasks = (
        {
            Message => 'Check framework version',
            Module  => 'FrameworkVersionCheck',
        },
        {
            Message => 'Check required Perl version',
            Module  => 'PerlVersionCheck',
        },
        {
            Message => 'Check required database version.',
            Module  => 'DatabaseVersionCheck',
        },
        {
            Message => 'Check required Perl modules',
            Module  => 'PerlModulesCheck',
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
            Message => 'Migrate Merged Ticket history name values',
            Module  => 'MigrateTicketMergedHistory',
        },
        {
            Message => 'Migrate ticket statistics',
            Module  => 'MigrateTicketStats',
        },
        {
            Message => 'Migrate ticket notifications',
            Module  => 'MigrateTicketNotifications',
        },
        {
            Message => 'Create entries in new article table',
            Module  => 'MigrateArticleData',
        },
        {
            Message => 'Post changes on article related tables',
            Module  => 'PostArticleTableStructureChanges',
        },
        {
            Message => 'Migrate ArticleType in ProcessManagement Data',
            Module  => 'MigrateProcessManagementData',
        },
        {
            Message => 'Migrate ArticleType in PostMaster filters',
            Module  => 'MigratePostMasterData',
        },
        {
            Message => 'Migrate chat articles',
            Module  => 'MigrateChatData',
        },
        {
            Message => 'Initialize default cron jobs',
            Module  => 'InitializeDefaultCronjobs',
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
