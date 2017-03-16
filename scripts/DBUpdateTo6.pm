# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)
package scripts::DBUpdateTo6;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo6 - The main db update class.

=head1 DESCRIPTION

Runs DB update (OTRS 5 to the OTRS 6).

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

    $Self->{Opts} = $Param{Opts};

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
    for my $Task (@Tasks) {

        # show task message
        print "Step $Step of $Steps: $Task->{Message}...";

        my $Success = 0;

        # run module
        if ( $Task->{Module} ) {
            $Kernel::OM->ObjectParamAdd(
                "scripts::DBUpdateTo6::$Task->{Module}" => {
                    Opts => $Self->{Opts},
                },
            );
            my $Object = $Kernel::OM->Get("scripts::DBUpdateTo6::$Task->{Module}");

            $Success = $Object->Run()
        }

        # run common methods
        elsif ( $Task->{Common} ) {
            my $Method = $Task->{Common};
            if ( $Self->can($Method) ) {
                $Self->$Method;
                $Success = 1;
            }
        }

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

=head2 RebuildConfig()

Refreshes the configuration to make sure that a ZZZAAuto.pm is present after the upgrade.

    $DBUpdateTo6Object->RebuildConfig();

=cut

sub RebuildConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Convert XML files to entries in the database
    if (
        !$SysConfigObject->ConfigurationXML2DB(
            CleanUp => 1,
            Force   => 1,
            UserID  => 1,
        )
        )
    {
        die "There was a problem writing XML to DB.";
    }

    # Rebuild ZZZAAuto.pm with current values
    if (
        !$SysConfigObject->ConfigurationDeploy(
            Comments => $Param{Comments} || "Configuration Rebuild",
            AllSettings  => 1,
            Force        => 1,
            NoValidation => 1,
            UserID       => 1,
        )
        )
    {
        die "There was a problem writing ZZZAAuto.pm.";
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    print "\nIf you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";

    # create common objects with new default config
    $Kernel::OM->ObjectsDiscard();

    return 1;
}

=head2 CacheCleanUp()

Clean up the cache.

    $DBUpdateTo6Object->CacheCleanUp();

=cut

sub CacheCleanUp {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

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
            Common  => 'RebuildConfig',
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
            Common  => 'CacheCleanUp',
        },
        {
            Message => 'Refresh configuration cache another time',
            Common  => 'RebuildConfig',
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
