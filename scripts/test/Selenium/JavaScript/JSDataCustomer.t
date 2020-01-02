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
use Time::HiRes qw(sleep);

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        my @Tests = (
            {
                Key           => 'UserLanguage',
                ExpectedValue => 'en',
                Environment   => 1,
            },
            {
                Key           => 'Action',
                ExpectedValue => 'CustomerTicketMessage',
                Environment   => 1,
            },
            {
                Key           => 'Subaction',
                ExpectedValue => 'StoreNew',
                Environment   => 1,
            },
            {
                Key           => 'Frontend::WebPath',
                JSKey         => 'WebPath',
                ExpectedValue => $ConfigObject->Get('Frontend::WebPath'),
                Environment   => 1,
            },
            {
                Key           => 'CustomerPanelSessionName',
                ExpectedValue => 'OTRSUTValue',
            },
            {
                Key           => 'CheckEmailAddresses',
                ExpectedValue => '3',
            },
            {
                Key           => 'ModernizeCustomerFormFields',
                JSKey         => 'InputFieldsActivated',
                ExpectedValue => '9',
            },
        );

        # set the expected values
        TEST:
        for my $Test (@Tests) {

            next TEST if $Test->{Environment};

            # set the item to the expected value
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => $Test->{Key},
                Value => $Test->{ExpectedValue}
            );
        }

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # login test customer user
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketMessage;Subaction=StoreNew;Expand=1");

        for my $Test (@Tests) {

            my $Key = $Test->{JSKey} // $Test->{Key};

            # check value
            $Self->Is(
                $Selenium->execute_script(
                    "return Core.Config.Get('$Key');"
                ),
                $Test->{ExpectedValue},
                "$Key matches expected value.",
            );
        }
    }
);

1;
