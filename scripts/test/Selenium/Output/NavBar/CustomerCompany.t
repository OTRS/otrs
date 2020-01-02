# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # disable frontend AdminCustomerCompany module
        my $AdminCustomerCompany = $ConfigObject->Get('Frontend::Module')->{AdminCustomerCompany};
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'Frontend::Module###AdminCustomerCompany',
            Value => {},
        );

        # check for NavBarCustomerCompany button when frontend AdminCustomerCompany module is disabled
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");
        $Self->True(
            index( $Selenium->get_page_source(), 'AdminCustomerCompany;Nav=Agent' ) == -1,
            "NavBar 'Customer Administration' button NOT available when frontend AdminCustomerCompany module is disabled",
        );

        # enable frontend AdminCustomerCompany module
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::Module###AdminCustomerCompany',
            Value => $AdminCustomerCompany,
        );

        # check for NavBarCustomerCompany button when frontend AdminCustomerCompany module is enabled
        $Selenium->VerifiedRefresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'AdminCustomerCompany;Nav=Agent' ) > -1,
            "NavBar 'Customer Administration' button IS available when frontend AdminCustomerCompany module is enable",
        );
    }
);

1;
