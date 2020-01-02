# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::Package::Upgrade;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand Kernel::System::Console::Command::Admin::Package::List);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Package',
    'Kernel::Config',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Upgrade an OTRS package.');
    $Self->AddOption(
        Name        => 'force',
        Description => 'Force package upgrade even if validation fails.',
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddArgument(
        Name => 'location',
        Description =>
            "Specify a file path, a remote repository (http://ftp.otrs.org/pub/otrs/packages/:Package-1.0.0.opm) or just any online repository (online:Package).",
        Required   => 1,
        ValueRegex => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Upgrading package...</yellow>\n");

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Enable in-memory cache to improve SysConfig performance, which is normally disabled for commands.
    $CacheObject->Configure(
        CacheInMemory => 1,
    );

    my $FileString = $Self->_PackageContentGet( Location => $Self->GetArgument('location') );
    return $Self->ExitCodeError() if !$FileString;

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    # Parse package.
    my %Structure = $PackageObject->PackageParse(
        String => $FileString,
    );

    my $Verified = $PackageObject->PackageVerify(
        Package   => $FileString,
        Structure => \%Structure,
    ) || 'verified';
    my %VerifyInfo = $PackageObject->PackageVerifyInfo();

    # Check if installation of packages, which are not verified by us, is possible.
    my $PackageAllowNotVerifiedPackages = $Kernel::OM->Get('Kernel::Config')->Get('Package::AllowNotVerifiedPackages');

    if ( $Verified ne 'verified' ) {

        if ( !$PackageAllowNotVerifiedPackages ) {

            $Self->PrintError(
                "$Structure{Name}->{Content}-$Structure{Version}->{Content} is not verified by the OTRS Group!\n\nThe installation of packages which are not verified by the OTRS Group is not possible by default."
            );
            return $Self->ExitCodeError();
        }
        else {

            $Self->Print(
                "<yellow>Package $Structure{Name}->{Content}-$Structure{Version}->{Content} not verified by the OTRS Group! It is recommended not to use this package.</yellow>\n"
            );
        }
    }

    # Intro screen.
    if ( $Structure{IntroUpgrade} ) {
        my %Data = $Self->_PackageMetadataGet(
            Tag                  => $Structure{IntroUpgrade},
            AttributeFilterKey   => 'Type',
            AttributeFilterValue => 'pre',
        );
        if ( $Data{Description} ) {
            print "+----------------------------------------------------------------------------+\n";
            print "| $Structure{Name}->{Content}-$Structure{Version}->{Content}\n";
            print "$Data{Title}";
            print "$Data{Description}";
            print "+----------------------------------------------------------------------------+\n";
        }
    }

    # Upgrade.
    my $Success = $Kernel::OM->Get('Kernel::System::Package')->PackageUpgrade(
        String => $FileString,
        Force  => $Self->GetOption('force'),
    );

    if ( !$Success ) {
        $Self->PrintError("Package upgrade failed.");
        return $Self->ExitCodeError();
    }

    # Intro screen.
    if ( $Structure{IntroUpgrade} ) {
        my %Data = $Self->_PackageMetadataGet(
            Tag                  => $Structure{IntroUpgrade},
            AttributeFilterKey   => 'Type',
            AttributeFilterValue => 'post',
        );
        if ( $Data{Description} ) {
            print "+----------------------------------------------------------------------------+\n";
            print "| $Structure{Name}->{Content}-$Structure{Version}->{Content}\n";
            print "$Data{Title}";
            print "$Data{Description}";
            print "+----------------------------------------------------------------------------+\n";
        }
    }

    # Disable in memory cache.
    $CacheObject->Configure(
        CacheInMemory => 0,
    );

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
