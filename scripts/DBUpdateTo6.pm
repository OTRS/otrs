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

    my @Tasks = $Self->_TasksGet();

    print "\nMigration started...\n\n";

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

        # Show initial task message.
        print "Step $Step of $Steps: $Task->{Message}...";

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

        if ($Success) {
            print "done.\n\n";
        }
        else {
            print "error.\n\n";
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
            Message => 'Migrate configuration',
            Module  => 'MigrateConfigEffectiveValues',
        },
        {
            Message => 'Refresh configuration cache after migration of OTRS 5 settings.',
            Module  => 'RebuildConfig',
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
            Message => 'Update calendar appointment future tasks',
            Module  => 'UpdateAppointmentCalendarFutureTasks',
        },
        {
            Message => 'Add basic appointment notification for reminders',
            Module  => 'AddAppointmentCalendarNotification',
        },

        # ...

        {
            Message => 'Uninstall Merged Feature Add-Ons',
            Module  => 'UninstallMergedFeatureAddOns',
        },
        {
            Message => 'Clean up the cache',
            Module  => 'CacheCleanUp',
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
