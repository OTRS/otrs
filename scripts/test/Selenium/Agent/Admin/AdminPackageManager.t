# --
# AdminPackageManager.t - frontend tests for AdminPackageManager
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# get OTRS Version
my $OTRSVersion = $ConfigObject->Get('Version');

# leave only mayor and minor level versions
$OTRSVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# add x as patch level version
$OTRSVersion .= '.x';

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminPackageManager");

        my $Element = $Selenium->find_element( "#FileUpload", 'css' );
        $Element->is_enabled();
        $Element->is_displayed();

        # install test package
        my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/PackageManager/TestPackage.opm";

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

        $Selenium->find_element("//button[\@value='Install'][\@type='submit']")->click();
        $Selenium->find_element("//button[\@value='Continue'][\@type='submit']")->click();

        $Self->True(
            $Selenium->find_element(
                "//a[contains(\@href, \'Subaction=View;Name=Test' )]"
                )->is_displayed(),
            'Test package is installed',
        );

        # load page with metadata of installed package
        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=View;Name=Test' )]"
        )->click();

        $Selenium->find_element("//a[contains(\@href, \'Subaction=Download' )]");
        $Selenium->find_element("//a[contains(\@href, \'Subaction=RebuildPackage' )]");
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Reinstall' )]");

        # go back to overview
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPackageManager' )]")->click();

        # uninstall package
        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=Uninstall;Name=Test' )]"
        )->click();

        $Selenium->find_element("//button[\@value='Uninstall package'][\@type='submit']")->click();

        my $Success;
        eval {
            $Success = $Selenium->find_element("//a[contains(\@href, \'Subaction=View;Name=Test' )]")->is_displayed();
        };

        $Self->False(
            $Success,
            'Test package is uninstalled',
        );

        }
);

1;
