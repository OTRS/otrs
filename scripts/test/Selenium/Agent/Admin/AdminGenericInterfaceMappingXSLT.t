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

# Get selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # Get needed objects.
        my $Helper           = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Define needed variable.
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

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminGenericInterfaceWebservice screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # Click on created web service.
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Select 'Ticket::TicketCreate' as option.
        $Selenium->execute_script(
            "\$('#OperationList').val('Ticket::TicketCreate').trigger('redraw.InputField').trigger('change');"
        );

        # Wait for page to load if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Operation").length' );

        # Create web service operation.
        $Selenium->find_element( "#Operation", 'css' )->send_keys('SeleniumOperation');

        # Select XSLT mapping for inbound data.
        $Selenium->execute_script(
            "\$('#MappingInbound').val('XSLT').trigger('redraw.InputField').trigger('change');"
        );

        # Set include ticket data to Yes.
        $Selenium->execute_script(
            "\$('#IncludeTicketData').val('1').trigger('redraw.InputField').trigger('change');"
        );

        # Submit operation.
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Verify ticket data option.
        $Self->Is(
            $Selenium->find_element( '#IncludeTicketData', 'css' )->get_value(),
            '1',
            'Include ticket data set to Yes'
        );

        # Click to configure inbound mapping XSLT.
        $Selenium->find_element("//button[\@id='MappingInboundConfigureButton']")->VerifiedClick();

        # Check screen.
        $Self->True(
            $Selenium->find_element( "#Template", 'css' ),
            "Input field for XSLT data is found"
        );

        # Check for breadcrumb on screen.
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

        # Submit empty form and check client side validation.
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Template').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Input invalid XSLT data.
        $Selenium->find_element( "#Template", 'css' )->send_keys($RandomID);

        # Submit invalid XSLT.
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Click to confirm error and verify it.
        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();
        $Self->True(
            $Selenium->find_element( "#Accessibility_AlertMessage", 'css' ),
            "Error for invalid XSLT data is found"
        );

        # Input correct XSLT data.
        my $XSLTData = '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement><NewKey>NewValue</NewKey></NewRootElement>
</xsl:template>
</xsl:stylesheet>';

        $Selenium->find_element( "#Template", 'css' )->clear();
        $Selenium->find_element( "#Template", 'css' )->send_keys($XSLTData);

        # Add invalid pre XSLT regex.
        $Selenium->find_element( '#WidgetRegExFiltersPre', 'css' )->VerifiedClick();
        $Selenium->find_element( "#PreAddValue",           'css' )->VerifiedClick();

        # Submit invalid pre XSLT regex.
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check client side validation.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#PreKey_1').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Add correct pre XSLT regex.
        $Selenium->find_element( "#PreKey_1",    'css' )->send_keys( $RandomID . 'PreKey_1' );
        $Selenium->find_element( "#PreValue_1",  'css' )->send_keys( $RandomID . 'PreValue_1' );
        $Selenium->find_element( "#PreAddValue", 'css' )->VerifiedClick();
        $Selenium->find_element( "#PreAddValue", 'css' )->VerifiedClick();
        $Selenium->find_element( "#PreKey_2",    'css' )->send_keys( $RandomID . 'PreKey_2' );
        $Selenium->find_element( "#PreKey_3",    'css' )->send_keys( $RandomID . 'PreKey_3' );
        $Selenium->find_element( "#PreValue_3",  'css' )->send_keys( $RandomID . 'PreValue_3' );

        # Add post XSLT regex.
        $Selenium->find_element( '#WidgetRegExFiltersPost', 'css' )->VerifiedClick();
        $Selenium->execute_script("\$('#PostAddValue').click();");

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#PostKey_1").length'
        );

        my $PostKey   = $RandomID . 'PostKey_1';
        my $PostValue = $RandomID . 'PostValue_1';
        $Selenium->execute_script("\$('#PostKey_1').val('$PostKey');");
        $Selenium->execute_script("\$('#PostValue_1').val('$PostValue');");

        # Add data include configuration.
        $Selenium->execute_script(
            "\$('#DataInclude').val('ProviderRequestInput').trigger('redraw.InputField').trigger('change');"
        );

        # Click on 'Save and finish' test JS redirection.
        $Selenium->execute_script("\$('#Submit').click();");

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        $Self->True(
            index( $Selenium->get_current_url(), 'AdminGenericInterfaceOperationDefault' ) > -1,
            'JS redirection is successful to AdminGenericInterfaceOperationDefault screen'
        );

        # Wait for page to load if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#MappingInboundConfigureButton").length'
        );

        # Click on configure inbound mapping XSLT again.
        $Selenium->find_element("//button[\@id='MappingInboundConfigureButton']")->VerifiedClick();

        # Verify saved data.
        $Self->Is(
            $Selenium->find_element( "#Template", 'css' )->get_value(),
            $XSLTData,
            "XSLT data is successfully saved"
        );
        $Self->Is(
            $Selenium->find_element( '#DataInclude', 'css' )->get_value(),
            'ProviderRequestInput',
            "#DataInclude stored value",
        );

        # Verify saved regex data.
        $Self->Is(
            $Selenium->find_element( "#PreKey_1", 'css' )->get_value(),
            $RandomID . 'PreKey_1',
            "Pre RegEx data is successfully saved"
        );

        $Self->Is(
            $Selenium->find_element( "#PreValue_1", 'css' )->get_value(),
            $RandomID . 'PreValue_1',
            "Pre RegEx data is successfully saved"
        );

        $Self->Is(
            $Selenium->find_element( "#PreKey_2", 'css' )->get_value(),
            $RandomID . 'PreKey_2',
            "Pre RegEx data is successfully saved"
        );

        $Self->Is(
            $Selenium->find_element( "#PreValue_2", 'css' )->get_value(),
            '',
            "Pre RegEx data is successfully saved"
        );

        $Self->Is(
            $Selenium->find_element( "#PreKey_3", 'css' )->get_value(),
            $RandomID . 'PreKey_3',
            "Pre RegEx data is successfully saved"
        );

        $Self->Is(
            $Selenium->find_element( "#PreValue_3", 'css' )->get_value(),
            $RandomID . 'PreValue_3',
            "Pre RegEx data is successfully saved"
        );

        $Self->Is(
            $Selenium->find_element( "#PostKey_1", 'css' )->get_value(),
            $RandomID . 'PostKey_1',
            "Post RegEx data is successfully saved"
        );

        $Self->Is(
            $Selenium->find_element( "#PostValue_1", 'css' )->get_value(),
            $RandomID . 'PostValue_1',
            "Post RegEx data is successfully saved"
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
