# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

# Fake a running daemon.
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $NodeID       = $ConfigObject->Get('NodeID') || 1;
my $Running      = $Kernel::OM->Get('Kernel::System::Cache')->Set(
    Type  => 'DaemonRunning',
    Key   => $NodeID,
    Value => 1,
);

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get needed variables
        my $Daemon   = $ConfigObject->Get('Home') . '/bin/otrs.Daemon.pl';
        my $RandomID = $Helper->GetRandomID();

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

        # check breadcrumb on Overview screen
        $Self->Is(
            $Selenium->execute_script("return \$('.BreadCrumb li:eq(1)').text().trim()"),
            'System Registration Management',
            "Breadcrumb text 'System Registration Management' is found on screen"
        );

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
            $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

            if ( $Test->{Name} ne 'Wrong email address' ) {
                $Self->Is(
                    $Selenium->execute_script("return \$('#OTRSID').hasClass('Error')"),
                    '1',
                    $Test->{Name},
                );
            }
            else {

                # wait for message box to show up with the error message
                $Selenium->WaitFor(
                    JavaScript =>
                        'return $("div.MessageBox.Error p").text().match(/Wrong OTRSID or Password/) != null',
                );

                $Self->True(
                    $Selenium->execute_script(
                        'return $("div.MessageBox.Error p").text().match(/Wrong OTRSID or Password/) != null',
                    ),
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
            $Selenium->find_element( "#$Dialog", 'css' )->VerifiedClick();

            # check up if corresponding modal dialog exists on the page
            $Self->Is(
                $Selenium->execute_script("return \$(\$('.Dialog.Modal h1')[0]).text()"),
                $Dialogs{$Dialog},
                "Modal dialog window with title '$Dialogs{$Dialog}' exists on page",
            );

            # close the modal dialog
            $Selenium->find_element( ".Dialog.Modal .fa.fa-times", 'css' )->VerifiedClick();
        }
    }
);

1;
