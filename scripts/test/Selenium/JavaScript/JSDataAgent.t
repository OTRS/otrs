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
                ExpectedValue => 'AgentTicketPhone',
                Environment   => 1,
            },
            {
                Key           => 'Subaction',
                ExpectedValue => undef,
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
                Key           => 'Frontend::RichText',
                JSKey         => 'RichTextSet',
                ExpectedValue => '5',
            },
            {
                Key           => 'Frontend::MenuDragDropEnabled',
                JSKey         => 'MenuDragDropEnabled',
                ExpectedValue => '7',
            },
            {
                Key           => 'OpenMainMenuOnHover',
                JSKey         => 'OpenMainMenuOnHover',
                ExpectedValue => '8',
            },
            {
                Key           => 'ModernizeFormFields',
                JSKey         => 'InputFieldsActivated',
                ExpectedValue => '9',
            },
            {
                Key           => 'Ticket::Frontend::CustomerInfoCompose',
                JSKey         => 'CustomerInfoSet',
                ExpectedValue => '10',
            },
            {
                Key           => 'Ticket::IncludeUnknownTicketCustomers',
                JSKey         => 'IncludeUnknownTicketCustomers',
                ExpectedValue => '11',
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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # go to some dummy page
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

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
