# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

# Check if needed frontend module is registered in sysconfig.
return 1 if !$ConfigObject->Get('Frontend::Module')->{AdminPackageManager};

my $RandomID = $Helper->GetRandomID();

# Override Request() from WebUserAgent to always return some test data without making any
#   actual web service calls. This should prevent instability in case cloud services are
#   unavailable at the exact moment of this test run.
my $CustomCode = <<"EOS";
sub Kernel::Config::Files::ZZZZUnitTestAdminPackageManager${RandomID}::Load {} # no-op, avoid warning logs
use Kernel::System::WebUserAgent;
package Kernel::System::WebUserAgent;
use strict;
use warnings;
## nofilter(TidyAll::Plugin::OTRS::Perl::TestSubs)
{
    no warnings 'redefine';
    sub Request {
        return;
    }
}
1;
EOS
$Helper->CustomCodeActivate(
    Code       => $CustomCode,
    Identifier => 'AdminPackageManager' . $RandomID,
);

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # For the sake of stability, check if test package is already installed.
        my $TestPackage = $PackageObject->RepositoryGet(
            Name            => 'Test',
            Version         => '0.0.1',
            DisableWarnings => 1,
        );

        # If test package is installed, remove it so we can install it again.
        if ($TestPackage) {
            my $PackageUninstall = $PackageObject->PackageUninstall( String => $TestPackage );
            $Self->True(
                $TestPackage,
                'Test package is uninstalled'
            );
        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die 'Did not get test user';

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get config object.
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Get script alias.
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminPackageManager screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPackageManager");

        # Check overview AdminPackageManager.
        my $Element = $Selenium->find_element( '#FileUpload', 'css' );
        $Element->is_enabled();
        $Element->is_displayed();

        # Install test package.
        my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/PackageManager/TestPackage.opm";

        $Selenium->find_element( '#FileUpload', 'css' )->send_keys($Location);

        $Selenium->find_element("//button[\@value='Install'][\@type='submit']")->VerifiedClick();

        $Selenium->find_element("//button[\@value='Continue'][\@type='submit']")->click();
        $Selenium->WaitFor(
            Time => 120,
            JavaScript =>
                'return typeof($) == "function" && !$("button[value=\'Continue\']").length;'
        );

        my $PackageCheck = $PackageObject->PackageIsInstalled(
            Name => 'Test',
        );
        $Self->True(
            $PackageCheck,
            'Test package is installed'
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPackageManager");

        # Load page with metadata of installed package.
        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=View;Name=Test' )]"
        )->VerifiedClick();

        $Selenium->find_element("//a[contains(\@href, \'Subaction=Download' )]");
        $Selenium->find_element("//a[contains(\@href, \'Subaction=RebuildPackage' )]");
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Reinstall' )]");

        # Go back to overview.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPackageManager' )]")->VerifiedClick();

        # Uninstall package.
        $Selenium->find_element(
            "//a[contains(\@href, \'Subaction=Uninstall;Name=Test' )]"
        )->VerifiedClick();

        $Selenium->find_element("//button[\@value='Uninstall package'][\@type='submit']")->click();
        $Selenium->WaitFor(
            Time => 120,
            JavaScript =>
                'return typeof($) == "function" && !$("button[value=\'Uninstall package\']").length;'
        );

        # Check if test package is uninstalled.
        $Self->True(
            index( $Selenium->get_page_source(), 'Subaction=View;Name=Test' ) == -1,
            'Test package is uninstalled'
        );

        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminPackageManager;Subaction=View;Name=NonexistingPackage;Version=0.0.1"
        );

        $Selenium->find_element( 'div.ErrorScreen', 'css' );

        # Navigate to AdminPackageManager screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPackageManager");

        # Try to install incompatible test package.
        $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/PackageManager/TestPackageIncompatible.opm";

        $Selenium->find_element( '#FileUpload', 'css' )->send_keys($Location);

        $Selenium->find_element("//button[\@value='Install'][\@type='submit']")->VerifiedClick();
        $Selenium->find_element("//button[\@value='Continue'][\@type='submit']")->VerifiedClick();

        # Check if info for incompatible package is shown.
        $Self->True(
            $Selenium->execute_script(
                "return \$('.WidgetSimple .Content h2:contains(\"Package installation requires a patch level update of OTRS.\")').length;"
            ),
            'Info for incompatible package is shown'
        );
    }
);

# Do an implicit cleanup of the test package, in case it's still present in the system.
#   If Selenium Run() method above fails because of an error, it will not proceed to uninstall the test package in an
#   interactive way. Here we check for existence of the test package, and remove it only if it's found.
my $TestPackage = $PackageObject->RepositoryGet(
    Name            => 'Test',
    Version         => '0.0.1',
    DisableWarnings => 1,
);
if ($TestPackage) {
    my $PackageUninstall = $PackageObject->PackageUninstall( String => $TestPackage );
    $Self->True(
        $TestPackage,
        'Test package is cleaned up'
    );
}

1;
