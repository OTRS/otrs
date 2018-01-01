# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Daemon::DaemonModules::SystemConfigurationSyncManager;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::Daemon::BaseDaemon Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SystemConfigurationSyncManager - daemon to keep system configuration deployments in sync

=head1 DESCRIPTION

System Configuration deployment sync daemon

=head1 PUBLIC INTERFACE

=head2 new()

Create system configuration deployment sync object.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless $Self, $Type;

    # Get objects in constructor to save performance.
    $Self->{ConfigObject}    = $Kernel::OM->Get('Kernel::Config');
    $Self->{CacheObject}     = $Kernel::OM->Get('Kernel::System::Cache');
    $Self->{DBObject}        = $Kernel::OM->Get('Kernel::System::DB');
    $Self->{SysConfigObject} = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Disable in memory cache to be clusterable.
    $Self->{CacheObject}->Configure(
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );

    # Get the NodeID from the SysConfig settings, this is used on High Availability systems.
    $Self->{NodeID} = $Self->{ConfigObject}->Get('NodeID') || 1;

    # Check NodeID, if does not match is impossible to continue.
    if ( $Self->{NodeID} !~ m{ \A \d+ \z }xms && $Self->{NodeID} > 0 && $Self->{NodeID} < 1000 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "NodeID '$Self->{NodeID}' is invalid!",
        );
        return;
    }

    # Do not change the following values!
    $Self->{SleepPost} = 60;         # sleep 1 minute after each loop
    $Self->{Discard}   = 60 * 60;    # discard every hour

    $Self->{DiscardCount} = $Self->{Discard} / $Self->{SleepPost};

    $Self->{Debug}      = $Param{Debug};
    $Self->{DaemonName} = 'Daemon: SystemConfigurationSyncManager';

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # Check if database is on-line.
    return 1 if $Self->{DBObject}->Ping();

    sleep 10;

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::Config', ],
    );

    my $OldDeploymentID = $Kernel::OM->Get('Kernel::Config')->Get('CurrentDeploymentID') || 0;

    # Execute the deployment sync
    my $ErrorMessage;
    my $Success;
    if ( $Self->{Debug} ) {
        print "    SystemConfigurationSyncManager executes function: ConfigurationDeploySync\n";
    }

    eval {

        # Restore child signal to default, main daemon set it to 'IGNORE' to be able to create
        #   multiple process at the same time, but in workers this causes problems if function does
        #   system calls (on linux), since system calls returns -1. See bug#12126.
        local $SIG{CHLD} = 'DEFAULT';

        # Localize the standard error, everything will be restored after the eval block.
        local *STDERR;

        # Redirect the standard error to a variable.
        open STDERR, ">>", \$ErrorMessage;

        $Success = $Self->{SysConfigObject}->ConfigurationDeploySync();
    };

    # Check if there are errors.
    if ( $ErrorMessage || !$Success ) {
        $Self->_HandleError(
            TaskName     => 'ConfigurationDeploySync',
            TaskType     => 'SystemConfigurationSyncManager',
            LogMessage   => "There was an error executing ConfigurationDeploySync: $ErrorMessage",
            ErrorMessage => $ErrorMessage || 'ConfigurationDeploySync returns failure.',
        );

        return 1;
    }

    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::Config', ],
    );

    my $NewDeploymentID = $Kernel::OM->Get('Kernel::Config')->Get('CurrentDeploymentID') || 0;

    # If the DeploymentID was not changed, do nothing and return gracefully.
    return 1 if $OldDeploymentID eq $NewDeploymentID;

    # Stop all daemons and reload configuration from main daemon.
    kill 1, getppid;

    return 1;
}

sub PostRun {
    my ( $Self, %Param ) = @_;

    sleep $Self->{SleepPost};

    $Self->{DiscardCount}--;

    if ( $Self->{Debug} && $Self->{DiscardCount} == 0 ) {
        print "  $Self->{DaemonName} will be stopped and set for restart!\n";
    }

    return if $Self->{DiscardCount} <= 0;
    return 1;
}

sub Summary {
    my ( $Self, %Param ) = @_;

    return (
        {
            Header        => "System configuration sync:",
            Column        => [],
            Data          => [],
            NoDataMessage => "Daemon is active.",
        },
    );
}

sub DESTROY {
    my $Self = shift;

    return 1;
}

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
