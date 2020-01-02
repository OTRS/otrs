# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Daemon::DaemonModules::SystemConfigurationSyncManager;

use strict;
use warnings;
use utf8;

use File::Basename qw(basename);
use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::Daemon::BaseDaemon Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::Main',
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
    $Self->{MainObject}      = $Kernel::OM->Get('Kernel::System::Main');

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
        print "    $Self->{DaemonName} Executes function: ConfigurationDeploySync\n";
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
    # Do not log debug messages as Daemon errors. See bug#14722 (https://bugs.otrs.org/show_bug.cgi?id=14722).
    if ( ( $ErrorMessage && $ErrorMessage !~ /Debug: /g ) || !$Success ) {
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

    my $ConfigChange;
    if ( $OldDeploymentID ne $NewDeploymentID ) {
        $ConfigChange = 1;
    }

    my $ConfigDirectory        = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files';
    my %KnownConfigFilesMD5Sum = %{ $Self->{ConfigFilesMD5Sum} // {} };
    my @ChangedFiles;

    # If there is no record for new config files let it run
    my $InitialRun;
    if ( !defined $Self->{ConfigFilesMD5Sum} ) {
        $InitialRun = 1;
    }

    # Check all (perl) config files for changes.
    my @ConfigFiles = $Self->{MainObject}->DirectoryRead(
        Directory => $ConfigDirectory,
        Filter    => '*.pm',
    );

    my $ConfigFileChanged;
    my %NewConfigFilesMD5Sum;
    FILE:
    for my $File (@ConfigFiles) {
        my $Basename = File::Basename::basename($File);

        # Skip deployment based files.
        next FILE if $Basename eq 'ZZZAAuto.pm';

        # Check MD5 against (potentially) stored value.
        my $KnownMD5Sum = delete $KnownConfigFilesMD5Sum{$Basename};
        $NewConfigFilesMD5Sum{$Basename} = $Self->{MainObject}->MD5sum(
            Filename => $File,
        );
        if (
            !$InitialRun
            && (
                !$KnownMD5Sum || $KnownMD5Sum ne $NewConfigFilesMD5Sum{$Basename}
            )
            )
        {
            $ConfigFileChanged = 1;
            push @ChangedFiles, $Basename;
        }
    }

    # Check for missing files.
    if ( scalar keys %KnownConfigFilesMD5Sum ) {
        $ConfigFileChanged = 1;
    }

    $Self->{ConfigFilesMD5Sum} = \%NewConfigFilesMD5Sum;

    # If there was no change in the configuration, do nothing and return gracefully.
    return 1 if ( !$ConfigChange && !$ConfigFileChanged );

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

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
