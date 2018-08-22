# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

        # Set TestSimple for Invoker.
        $Helper->ConfigSettingChange(
            Key   => 'GenericInterface::Invoker::Module###Test::TestSimple',
            Valid => 1,
            Value => {
                ConfigDialog => 'AdminGenericInterfaceInvokerDefault',
                Controller   => 'Test',
                Name         => 'TestSimple',
            },
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test web service.
        my $WebserviceID = $WebserviceObject->WebserviceAdd(
            Config => {
                Debugger => {
                    DebugThreshold => 'debug',
                    TestMode       => 1,
                },
                Provider => {
                    Transport => {
                        Type => '',
                    },
                },
            },
            Name    => "Selenium $RandomID web service",
            ValidID => 1,
            UserID  => 1,
        );

        $Self->True(
            $WebserviceID,
            "Web service ID $WebserviceID is created"
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminGenericInterfaceWebservice screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # Select web service.
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();
        $Selenium->execute_script(
            "\$('#RequesterTransportList').val('HTTP::REST').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Select web service.
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();

        # Select Test::TestSimple invoker from list.
        $Selenium->execute_script(
            "\$('#InvokerList').val('Test::TestSimple').trigger('redraw.InputField').trigger('change');"
        );
        my $InvokerName = "Invoker$RandomID";
        $Selenium->find_element( '#Invoker', 'css' )->send_keys($InvokerName);

        # Click on 'Save'.
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check if Modernize class is included to Add Event Trigger select.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#EventType').hasClass('Modernize')"
            ),
            '1',
            'Check if Add Event Trigger select has class "Modernize"',
        );

        # Check if Modernize class is included to Ticket Event.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#TicketEvent').hasClass('Modernize')"
            ),
            '1',
            'Check if Ticket Event select has class "Modernize"',
        );

        # Set select Add Event Trigger to Queue.
        $Selenium->execute_script(
            "\$('#EventType').val('Queue').trigger('redraw.InputField').trigger('change')"
        );
        sleep 1;

        # Add a new event to event triggers.
        my $Count = 0;
        for my $Event (qw (QueueCreate  QueueUpdate)) {
            $Selenium->find_element( "#AddEvent", 'css' )->VerifiedClick();

            $Self->Is(
                $Selenium->execute_script("return \$('#EventsTable tbody tr:eq($Count) td:eq(0)').text().trim()"),
                "$Event",
                "Event Triggers table contains $Event"
            );

            $Count++;
        }

        $Selenium->find_element( "#AddEvent", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => "return \$('.Dialog.Modal').length === 1"
        );

        $Self->Is(
            $Selenium->execute_script("return \$('.Dialog.Modal div.InnerContent').text()"),
            "It is not possible to add a new event trigger because the event is not set.",
            "Event Triggers dialog is shown"
        );

        # Delete test created web service.
        my $Success = $WebserviceObject->WebserviceDelete(
            ID     => $WebserviceID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Web service ID $WebserviceID is deleted"
        );

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Webservice' );

    },
);

1;
