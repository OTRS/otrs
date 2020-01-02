# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Config::Rebuild;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);
use Time::HiRes qw(sleep);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::PID',
    'Kernel::System::SysConfig',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Rebuild the system configuration of OTRS.');

    $Self->AddOption(
        Name        => 'cleanup',
        Description => "Cleanup the database configuration, removing entries not defined in the XML files.",
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name        => 'time',
        Description => "Specify how many seconds should this instance wait to unlock PID if there is another " .
            "instance of this command running at the same time (in cluster environment). Default: 120.",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/^\d+$/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $PIDObject = $Kernel::OM->Get('Kernel::System::PID');

    my $Time = $Self->GetOption('time') || 120;

    my $Locked;
    my $WaitedSeconds = 0;
    my $Interval      = 0.1;
    my $ShowMessage   = 1;

    # Make sure that only one rebuild config command is running at the same time. Wait up to 2 minutes
    #    until other instances are done (see https://bugs.otrs.org/show_bug.cgi?id=14259).
    PID:
    while ( $WaitedSeconds <= $Time ) {
        my %PID = $PIDObject->PIDGet(
            Name => 'RebuildConfig',
        );

        if ( !%PID ) {
            my $Success = $PIDObject->PIDCreate(
                Name => 'RebuildConfig',
            );

            my %PID = $PIDObject->PIDGet(
                Name => 'RebuildConfig',
            );
            $PID{PID} || 0;

            # PID created successfully.
            if ( $Success && $PID{PID} eq $$ ) {
                $Locked = 1;
                last PID;
            }
        }
        Time::HiRes::sleep($Interval);
        $WaitedSeconds += $Interval;

        # Increase waiting interval up to 3 seconds.
        if ( $Interval < 3 ) {
            $Interval += 0.1;
        }

        if ($ShowMessage) {
            $Self->Print("\nThere is another system configuration rebuild in progress, waiting...\n\n");
            $ShowMessage = 0;
        }
    }

    if ( !$Locked ) {
        die "System was unable to create PID for RebuildConfig!\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Rebuilding the system configuration...</yellow>\n");

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Enable in-memory cache to improve SysConfig performance, which is normally disabled for commands.
    $CacheObject->Configure(
        CacheInMemory => 1,
    );

    # Get SysConfig object.
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    if (
        !$SysConfigObject->ConfigurationXML2DB(
            UserID  => 1,
            Force   => 1,
            CleanUp => $Self->GetOption('cleanup'),
        )
        )
    {

        # Disable in memory cache.
        $CacheObject->Configure(
            CacheInMemory => 0,
        );

        $Self->PrintError("There was a problem writing XML to DB.");
        return $Self->ExitCodeError();
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments    => "Configuration Rebuild",
        AllSettings => 1,
        UserID      => 1,
        Force       => 1,
    );
    if ( !$DeploymentResult{Success} ) {

        # Disable in memory cache.
        $CacheObject->Configure(
            CacheInMemory => 0,
        );

        $Self->PrintError("There was a problem writing ZZZAAuto.pm.");
        return $Self->ExitCodeError();
    }

    # Disable in memory cache.
    $CacheObject->Configure(
        CacheInMemory => 0,
    );

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub PostRun {
    my ($Self) = @_;

    my $PIDObject = $Kernel::OM->Get('Kernel::System::PID');

    my %PID = $PIDObject->PIDGet(
        Name => 'RebuildConfig',
    );

    if (%PID) {
        return $PIDObject->PIDDelete( Name => 'RebuildConfig' );
    }

    return 1;
}

1;
