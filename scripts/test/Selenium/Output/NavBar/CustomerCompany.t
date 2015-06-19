# --
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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
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

        # get SysConfigObject object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # disable frontend AdminCustomerCompany module
        my %AdminCustomerCompany = $SysConfigObject->ConfigItemGet(
            Name => 'Frontend::Module###AdminCustomerCompany',
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 0,
            Key   => 'Frontend::Module###AdminCustomerCompany',
            Value => \%AdminCustomerCompany,
        );

        # check for NavBarCustomerCompany button when frontend AdminCustomerCompany module is disabled
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentDashboard");
        $Self->True(
            index( $Selenium->get_page_source(), 'AdminCustomerCompany;Nav=Agent' ) == -1,
            "NavBar 'Customer Administration' button NOT available when frontend AdminCustomerCompany module is disabled",
        );

        # Sleep a little bit so that mod_perl can detect that the system configuration changed and reload it.
        sleep 1;

        # enable frontend AdminCustomerCompany module
        $SysConfigObject->ConfigItemReset(
            Name => 'Frontend::Module###AdminCustomerCompany',
        );

        # check for NavBarCustomerCompany button when frontend AdminCustomerCompany module is enabled
        $Selenium->refresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'AdminCustomerCompany;Nav=Agent' ) > -1,
            "NavBar 'Customer Administration' button IS available when frontend AdminCustomerCompany module is enable",
        );
        }
);

1;
