# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Language;

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # get needed variables
        my $Daemon   = $ConfigObject->Get('Home') . '/bin/otrs.Daemon.pl';
        my $RandomID = $Helper->GetRandomID();

        # start daemon
        system("perl $Daemon start");

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AdminRegistration screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminRegistration");

        # create test cases with different field values
        my @Tests = (
            {
                Name  => 'Empty email address field',
                Value => '',
            },
            {
                Name  => 'Wrong email address type',
                Value => $RandomID,
            },
            {
                Name  => 'Wrong email address',
                Value => $RandomID . '@test.com',
            }
        );

        for my $Test (@Tests) {

            # set field values and submit
            $Selenium->execute_script("\$('#OTRSID').val('$Test->{Value}')");
            $Selenium->execute_script("\$('#Password').val('$Test->{Value}')");
            $Selenium->find_element( "#OTRSID", 'css' )->VerifiedSubmit();

            if ( $Test->{Name} ne 'Wrong email address' ) {
                $Self->Is(
                    $Selenium->execute_script("return \$('#OTRSID').hasClass('Error')"),
                    '1',
                    $Test->{Name},
                );
            }
            else {
                $Self->True(
                    index( $Selenium->get_page_source(), 'Wrong OTRSID or Password' ) > -1,
                    $Test->{Name},
                );
            }
        }

        # create field ID and modal dialog title pairs for different linked texts
        my %Dialogs = (
            RegistrationMoreInfo       => 'System Registration',
            RegistrationDataProtection => 'Data Protection',
        );

        for my $Dialog ( sort keys %Dialogs ) {

            # click on the linked text
            $Selenium->find_element( "#$Dialog", 'css' )->click();

            # check up if corresponding modal dialog exists on the page
            $Self->Is(
                $Selenium->execute_script("return \$(\$('.Dialog.Modal h1')[0]).text()"),
                $Dialogs{$Dialog},
                "Modal dialog window with title '$Dialogs{$Dialog}' exists on page",
            );

            # close the modal dialog
            $Selenium->find_element( ".Dialog.Modal .fa.fa-times", 'css' )->click();
        }

        # stop daemon
        system("perl $Daemon stop");
    }
);

1;
