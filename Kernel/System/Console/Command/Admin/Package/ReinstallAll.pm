# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::Package::ReinstallAll;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Reinstall all OTRS packages that are not correctly deployed.');
    $Self->AddOption(
        Name        => 'force',
        Description => 'Force package reinstallation even if validation fails.',
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name        => 'hide-deployment-info',
        Description => 'Hide package and files status (package deployment info).',
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $HideDeploymentInfoOption = $Self->GetOption('hide-deployment-info') || 0;

    $Self->Print("<yellow>Reinstalling all OTRS packages that are not correctly deployed...</yellow>\n");

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Enable in-memory cache to improve SysConfig performance, which is normally disabled for commands.
    $CacheObject->Configure(
        CacheInMemory => 1,
    );

    my @ReinstalledPackages;

    # loop all locally installed packages
    for my $Package ( $Kernel::OM->Get('Kernel::System::Package')->RepositoryList() ) {

        # do a deploy check to see if reinstallation is needed
        my $CorrectlyDeployed = $Kernel::OM->Get('Kernel::System::Package')->DeployCheck(
            Name    => $Package->{Name}->{Content},
            Version => $Package->{Version}->{Content},
            Log     => $HideDeploymentInfoOption ? 0 : 1,
        );

        if ( !$CorrectlyDeployed ) {

            push @ReinstalledPackages, $Package->{Name}->{Content};

            my $FileString = $Kernel::OM->Get('Kernel::System::Package')->RepositoryGet(
                Name    => $Package->{Name}->{Content},
                Version => $Package->{Version}->{Content},
            );

            my $Success = $Kernel::OM->Get('Kernel::System::Package')->PackageReinstall(
                String => $FileString,
                Force  => $Self->GetOption('force'),
            );

            if ( !$Success ) {
                $Self->PrintError("Package $Package->{Name}->{Content} could not be reinstalled.\n");
                return $Self->ExitCodeError();
            }
        }
    }

    if (@ReinstalledPackages) {
        $Self->Print( "<green>" . scalar(@ReinstalledPackages) . " package(s) reinstalled.</green>\n" );
    }
    else {
        $Self->Print("<green>No packages needed reinstallation.</green>\n");
    }

    # Disable in memory cache.
    $CacheObject->Configure(
        CacheInMemory => 0,
    );

    return $Self->ExitCodeOk();
}

1;
