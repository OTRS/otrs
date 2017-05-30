# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Config::Rebuild;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Cache',
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

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Rebuilding the system configuration...</yellow>\n");

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Enable in memory cache, which is normally disabled for commands.
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

    my $DeploySuccess = $SysConfigObject->ConfigurationDeploy(
        Comments    => "Configuration Rebuild",
        AllSettings => 1,
        UserID      => 1,
        Force       => 1,
    );
    if ( !$DeploySuccess ) {

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

1;
