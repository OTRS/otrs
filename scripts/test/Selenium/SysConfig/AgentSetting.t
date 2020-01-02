# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
## nofilter(TidyAll::Plugin::OTRS::Perl::TestSubs)
use strict;
use warnings;
use utf8;

use vars (qw($Self));
use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my $UserObject      = $Kernel::OM->Get('Kernel::System::User');

        # Disable CSS loader to actually see the CSS files in the html source.
        $HelperObject->ConfigSettingChange(
            Valid => 1,
            Key   => 'Loader::Enabled::CSS',
            Value => 0,
        );

        my $SettingName = 'Loader::Agent::DefaultSelectedSkin';
        my %Setting     = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        my $Language = "en";

        # Create user one.
        my $TestUserLogin1 = $HelperObject->TestUserCreate(
            Groups   => ['users'],
            Language => $Language,
        ) || die "Did not get test user";
        my $TestUserID1 = $UserObject->UserLookup(
            UserLogin => $TestUserLogin1,
        );

        # Create user two.
        my $TestUserLogin2 = $HelperObject->TestUserCreate(
            Groups   => ['users'],
            Language => $Language,
        ) || die "Did not get test user";
        my $TestUserID2 = $UserObject->UserLookup(
            UserLogin => $TestUserLogin2,
        );

        # Add a User setting file.
        my $UserFileContent = <<EOF;
# OTRS config file (testing, remove it)
# VERSION:2.0
package Kernel::Config::Files::User::$TestUserID1;
use strict;
use warnings;
no warnings 'redefine';
use utf8;
sub Load {
    my (\$File, \$Self) = \@_;
\$Self->{'Loader::Agent::DefaultSelectedSkin'} =  'ivory';
}
1;
EOF
        my $Home = $ConfigObject->Get('Home');

        # Create directory if not exists.
        if ( !-e $Home . '/Kernel/Config/Files/User' ) {
            system("mkdir $Home/Kernel/Config/Files/User");
        }

        my $FilePath = $Home . '/Kernel/Config/Files/User/' . $TestUserID1 . '.pm';

        # Define the file to be written (global or user specific).
        $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $FilePath,
            Content  => \$UserFileContent,
        );

        # WebPath is different on each system.
        my $WebPath = $ConfigObject->Get('Frontend::WebPath');

        # Login as the first created user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin1,
            Password => $TestUserLogin1,
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Compile the regex for checking if ivory skin file has been included. Some platforms might sort additional
        #   HTML attributes in unexpected order, therefore this check cannot be simple one.
        my $ExpectedLinkedFile = qr{<link .*? \s href="${WebPath}skins/Agent/ivory/css/Core.Default.css"}x;

        # Link to ivory skin file should be present.
        $Self->True(
            $Selenium->get_page_source() =~ $ExpectedLinkedFile,
            'Ivory skin should be selected'
        );

        # Try to expand the user profile sub menu by clicking the avatar.
        $Selenium->find_element( '.UserAvatar > a', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("li.UserAvatar > div:visible").length'
        );

        # Logout.
        my $Element = $Selenium->find_element( 'a#LogoutButton', 'css' );
        $Element->VerifiedClick();

        # Login with a different user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin2,
            Password => $TestUserLogin2,
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Link to ivory skin file shouldn't be present.
        $Self->True(
            $Selenium->get_page_source() !~ $ExpectedLinkedFile,
            "Ivory skin shouldn't be selected"
        );

        # Cleanup system.
        if ( -e $FilePath ) {
            unlink $FilePath;
        }
    }
);

1;
