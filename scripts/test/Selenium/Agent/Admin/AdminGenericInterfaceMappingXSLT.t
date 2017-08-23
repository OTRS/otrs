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

        # define needed variable
        my $RandomID = $Helper->GetRandomID();

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
            Name    => "Selenium $RandomID web service",
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

        # click on created web service
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # select 'Ticket::TicketCreate' as option
        $Selenium->execute_script(
            "\$('#OperationList').val('Ticket::TicketCreate').trigger('redraw.InputField').trigger('change');"
        );

        # wait for page to load if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Operation").length' );

        # create web service operation
        $Selenium->find_element( "#Operation", 'css' )->send_keys('SeleniumOperation');

        # select XSLT mapping for inbound data
        $Selenium->execute_script(
            "\$('#MappingInbound').val('XSLT').trigger('redraw.InputField').trigger('change');"
        );

        # Set include ticket data to Yes.
        $Selenium->execute_script(
            "\$('#IncludeTicketData').val('1').trigger('redraw.InputField').trigger('change');"
        );

        # submit operation
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Verify ticket data option.
        $Self->Is(
            $Selenium->find_element( '#IncludeTicketData', 'css' )->get_value(),
            '1',
            'Include ticket data set to Yes'
        );

        # click to configure inbound mapping XSLT
        $Selenium->find_element("//button[\@id='MappingInboundConfigureButton']")->VerifiedClick();

        # check screen
        $Self->True(
            $Selenium->find_element( "#Template", 'css' ),
            "Input field for XSLT data is found"
        );

        # check for breadcrumb on screen
        my $Count = 1;
        for my $Breadcrumb (
            "Web Service Management",
            "Selenium $RandomID web service",
            "Operation: SeleniumOperation",
            "XSLT Mapping for Incoming Data"
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $Breadcrumb,
                "Breadcrumb text '$Breadcrumb' is found on screen"
            );

            $Count++;
        }

        # submit empty form and check client side validation
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Template').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # input invalid XSLT data
        $Selenium->find_element( "#Template", 'css' )->send_keys($RandomID);

        # submit invalid XSLT
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # click to confirm error and verify it
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Self->True(
            $Selenium->find_element( "#Accessibility_AlertMessage", 'css' ),
            "Error for invalid XSLT data is found"
        );

        # input correct XSLT data
        my $XSLTData = '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement><NewKey>NewValue</NewKey></NewRootElement>
</xsl:template>
</xsl:stylesheet>';

        $Selenium->find_element( "#Template", 'css' )->clear();
        $Selenium->find_element( "#Template", 'css' )->send_keys($XSLTData);

        # click on 'Save'
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();

        # verify we are still on same screen
        $Self->True(
            $Selenium->find_element( "#Template", 'css' ),
            'After click on Save it is the same screen'
        );

        # click on 'Save and finish' test JS redirection
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_current_url(), 'AdminGenericInterfaceOperationDefault' ) > -1,
            'JS redirection is successful to AdminGenericInterfaceOperationDefault screen'
        );

        # wait for page to load if necessary
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#MappingInboundConfigureButton").length'
        );

        # click on configure inbound mapping XSLT again
        $Selenium->find_element("//button[\@id='MappingInboundConfigureButton']")->VerifiedClick();

        # verify saved data
        $Self->Is(
            $Selenium->find_element( "#Template", 'css' )->get_value(),
            $XSLTData,
            "XSLT data is successfully saved"
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
