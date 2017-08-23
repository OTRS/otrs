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

use Kernel::GenericInterface::Debugger;

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper           = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

        # define needed variables
        my $RandomID       = $Helper->GetRandomID();
        my $WebserviceName = "Selenium $RandomID web service";

        # create test web service
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

        # create debugger object
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

        # create different debug log types
        my $Count = 1;
        my @Summaries;
        for my $LogType (qw( Debug Info Notice Error )) {

            my $Summary = "Debug log nr. $Count - type $LogType";
            my $Result  = $DebuggerObject->$LogType(
                Summary => $Summary,
                Data    => "Selenium test log data type $LogType",
            ) || 0;
            $Self->True(
                $Result,
                "Debug log type $LogType is created"
            );

            $Count++;

            push @Summaries, $Summary;
        }

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
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminGenericInterfaceWebservice screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click on created web service
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();

        # click on 'Debugger' button
        $Selenium->find_element( "span .fa.fa-bug", 'css' )->VerifiedClick();

        # check screen
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

        # check breadcrumb on Debugger screen
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

        # verify CommunicationDetails are not visible
        $Self->Is(
            $Selenium->execute_script("return \$('#CommunicationDetails:visible').length;"),
            0,
            "Communication details are not visible"
        );

        # wait if necessary
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".RequestListWidget.Loading").length'
        );

        # verify Provider log is present in table
        $Self->True(
            $Selenium->execute_script("return \$('#RequestList').find('tbody tr td a').text().trim();") =~ /^Provider/,
            "Debugger log type Provider is found in table"
        );

        # click on it
        $Selenium->find_element( "Provider", 'link_text' )->VerifiedClick();

        # wait if necessary
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#CommunicationDetails:visible").length'
        );

        # verify CommunicationDetails are visible
        $Self->Is(
            $Selenium->execute_script("return \$('#CommunicationDetails:visible').length;"),
            1,
            "Communication details are visible"
        );

        # verify request details are present
        for my $RequestSummary (@Summaries) {
            $Self->True(
                index( $Selenium->get_page_source(), $RequestSummary ) > -1,
                "'$RequestSummary' is found"
            );
        }

        # change filter type to Requester
        $Selenium->execute_script("\$('#FilterType').val('Requester').trigger('redraw.InputField').trigger('change');");

        # click on 'Refresh' button and test JS GetRequestList function, expecting no result to find
        $Selenium->find_element( "#FilterRefresh", 'css' )->VerifiedClick();

        # wait if necessary
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".RequestListWidget.Loading").length'
        );

        # verify log table is empty
        $Self->Is(
            $Selenium->execute_script("return \$('#RequestList').find('tbody tr td a').text().trim();"),
            "",
            "Debugger log type Requester is not found in table- JS success"
        );

        # click to clear debugger log
        $Selenium->find_element( "#DeleteButton", 'css' )->VerifiedClick();

        # verify delete dialog text
        $Self->Is(
            $Selenium->execute_script("return \$('p#DeleteDialog').text().trim();"),
            "Do you really want to clear the debug log of this web service?",
            'Delete dialog text is found'
        );

        # click to clear debug log
        $Selenium->find_element( "#DialogButton2", 'css' )->VerifiedClick();

        # verify log table is empty
        $Self->Is(
            $Selenium->execute_script("return \$('#RequestList').find('tbody tr td a').text().trim();"),
            "",
            "Debugger log table is empty after clear"
        );

        # delete test created web service
        my $Success = $WebserviceObject->WebserviceDelete(
            ID     => $WebserviceID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Web service ID $WebserviceID is deleted"
        );

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Webservice' );
    }
);

1;
