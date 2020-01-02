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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminSelectBox screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSelectBox");

        # Check if needed frontend module is registered in sysconfig.
        if ( !$ConfigObject->Get('Frontend::Module')->{AdminSelectBox} ) {
            $Self->True(
                index(
                    $Selenium->get_page_source(),
                    'Module Kernel::Modules::AdminSelectBox not registered in Kernel/Config.pm!'
                ) > 0,
                'Module AdminSelectBox is not registered in sysconfig, skipping test...'
            );

            return 1;
        }

        # Empty SQL statement, check client side validation.
        $Selenium->find_element( "#SQL", 'css' )->clear();
        $Selenium->find_element( "#Run", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#SQL.Error').length"
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#SQL').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value for #SQL',
        );

        # Wrong SQL statement, check server side validation.
        $Selenium->find_element( "#SQL", 'css' )->clear();
        $Selenium->find_element( "#SQL", 'css' )->send_keys("SELECT * FROM");
        $Selenium->find_element( "#Run", 'css' )->VerifiedClick();

        $Selenium->WaitFor(
            ElementExists => "//textarea[contains(\@class,'ServerError')]"
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#SQL').hasClass('ServerError')"
            ),
            '1',
            'Server side validation correctly detected missing input value for #SQL',
        );

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.Dialog.Modal #DialogButton1').length"
        );
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return !\$('.Dialog.Modal').length"
        );

        # Correct SQL statement.
        $Selenium->find_element( "#SQL", 'css' )->clear();
        $Selenium->find_element( "#SQL", 'css' )->send_keys("SELECT * FROM valid");
        $Selenium->find_element( "#Run", 'css' )->VerifiedClick();

        # Verify results.
        my @Elements = $Selenium->find_elements( 'table thead tr', 'css' );
        $Self->Is(
            scalar @Elements,
            1,
            "Result table header row found",
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Results tbody tr:visible').length"
            ),
            3,
            "Result table body rows found",
        );
    }
);

1;
