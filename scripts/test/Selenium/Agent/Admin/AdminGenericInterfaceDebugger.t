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

use Kernel::GenericInterface::Debugger;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper           = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

        my $RandomID       = $Helper->GetRandomID();
        my $WebserviceName = "Selenium $RandomID web service";

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
            Name    => $WebserviceName,
            ValidID => 1,
            UserID  => 1,
        );

        $Self->True(
            $WebserviceID,
            "Web service ID $WebserviceID is created"
        );

        # Create debugger object.
        my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
            DebuggerConfig => {
                DebugThreshold => 'debug',
                TestMode       => 0,
            },
            WebserviceID      => $WebserviceID,
            CommunicationType => 'Provider',
        );

        $Self->Is(
            ref $DebuggerObject,
            'Kernel::GenericInterface::Debugger',
            'DebuggerObject instantiate correctly',
        );

        # Create different debug log types.
        my $Count = 1;
        my @Summaries;
        for my $LogType (qw( Debug Info Notice Error )) {

            my $Data = "Selenium test log data type $LogType";
            if ( $LogType eq 'Error' ) {
                $Data = <<"EOS";
<?xml version="1.0" encoding="utf-8" ?>
<test_config></test_config>
EOS
            }

            my $Summary = "Debug log nr. $Count - type $LogType";
            my $Result  = $DebuggerObject->$LogType(
                Summary => $Summary,
                Data    => $Data,
            ) || 0;
            $Self->True(
                $Result,
                "Debug log type $LogType is created"
            );

            $Count++;

            push @Summaries, $Summary;
        }

        # Create test user and login.
        my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
            Groups => ['admin'],
        );

        # Set user's time zone.
        my $UserTimeZone = 'Europe/Berlin';
        $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            Key    => 'UserTimeZone',
            Value  => $UserTimeZone,
            UserID => $TestUserID,
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminGenericInterfaceWebservice screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click on created web service.
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();

        # Click on 'Debugger' button.
        $Selenium->find_element( "span .fa.fa-bug", 'css' )->VerifiedClick();

        # Check screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        for my $ID (
            qw(DeleteButton FilterType_Search FilterFromMonth FilterFromDay FilterFromYear FilterFromDayDatepickerIcon
            FilterToMonth FilterToDay FilterToYear FilterRemoteIP FilterLimit_Search FilterSort FilterRefresh)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Debugger screen.
        my @Breadcrumbs = (
            {
                Text => 'Web Service Management',
            },
            {
                Text => $WebserviceName,
            },
            {
                Text => 'Debugger',
            }
        );

        $Count = 1;
        for my $Breadcrumb (@Breadcrumbs) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $Breadcrumb->{Text},
                "Breadcrumb text '$Breadcrumb->{Text}' is found on screen"
            );

            $Count++;
        }

        # Verify CommunicationDetails are not visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#CommunicationDetails:visible').length;"),
            0,
            "Communication details are not visible"
        );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".RequestListWidget.Loading").length'
        );

        # Verify Provider log is present in table.
        $Self->True(
            $Selenium->execute_script("return \$('#RequestList').find('tbody tr td a').text().trim();") =~ /^Provider/,
            "Debugger log type Provider is found in table"
        );

        # Click on it.
        $Selenium->find_element( "Provider", 'link_text' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#CommunicationDetails:visible").length'
        );

        # Verify CommunicationDetails are visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#CommunicationDetails:visible').length;"),
            1,
            "Communication details are visible"
        );

        # Verify request details are present.
        for my $RequestSummary (@Summaries) {
            $Self->True(
                index( $Selenium->get_page_source(), $RequestSummary ) > -1,
                "'$RequestSummary' is found"
            );
        }

        # Verify debug time log informations are in user preference time zone. See bug#14557.
        $Self->True(
            $Selenium->execute_script("return \$('#RequestList tbody tr:contains(\"Europe/Berlin\")').length;"),
            "Request list debug log time stamp is in user preference time zone ($UserTimeZone) format."
        );

        $Self->True(
            $Selenium->execute_script(
                "return \$('#CommunicationDetails .WidgetSimple:eq(0) h3:contains(\"Europe/Berlin\")').length;"
            ),
            "Request details debug log time stamp is in user preference time zone ($UserTimeZone) format."
        );

        # Change filter type to Requester.
        $Selenium->InputFieldValueSet(
            Element => '#FilterType',
            Value   => 'Requester',
        );

        # Click on 'Refresh' button and test JS GetRequestList function, expecting no result to find.
        $Selenium->find_element( "#FilterRefresh", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".RequestListWidget.Loading").length'
        );

        # Verify log table is empty.
        $Self->Is(
            $Selenium->execute_script("return \$('#RequestList').find('tbody tr td a').text().trim();"),
            "",
            "Debugger log type Requester is not found in table- JS success"
        );

        # Click to clear debugger log.
        $Selenium->find_element( "#DeleteButton", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#DeleteDialog").length'
        );

        # Verify delete dialog text.
        $Self->Is(
            $Selenium->execute_script("return \$('#DeleteDialog').text().trim();"),
            "Do you really want to clear the debug log of this web service?",
            'Delete dialog text is found'
        );

        $Selenium->find_element( "#DialogButton2", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog.Modal").length'
        );

        # Verify log table is empty.
        $Self->Is(
            $Selenium->execute_script("return \$('#RequestList').find('tbody tr td a').text().trim();"),
            "",
            "Debugger log table is empty after clear"
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
    }
);

1;
