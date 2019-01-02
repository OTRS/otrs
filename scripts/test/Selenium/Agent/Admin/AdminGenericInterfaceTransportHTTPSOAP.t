# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

        my $Helper           = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminGenericInterfaceWebservice screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # Click on created web service.
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();

        # Select 'HTTP::SOAP' as provider network transport.
        $Selenium->execute_script(
            "\$('#ProviderTransportList').val('HTTP::SOAP').trigger('redraw.InputField').trigger('change');"
        );

        # Select 'HTTP::SOAP' as requester network transport.
        $Selenium->execute_script(
            "\$('#RequesterTransportList').val('HTTP::SOAP').trigger('redraw.InputField').trigger('change');"
        );

        # Click on 'Save'.
        $Selenium->find_element("//button[\@value='Save and continue']")->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#ProviderTransportProperties").length'
        );

        # Click to configure provider network transport.
        $Selenium->find_element( "#ProviderTransportProperties", 'css' )->VerifiedClick();

        # Verify screen.
        for my $ID (
            qw(NameSpace RequestNameScheme RequestNameFreeText ResponseNameScheme ResponseNameFreeText MaxLength )
            )
        {
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length" );
            $Selenium->find_element( "#$ID", 'css' )->is_enabled();
        }

        # Verify URL.
        $Self->True(
            $Selenium->get_current_url()
                =~ /CommunicationType=Provider;Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=Add/,
            "Current URL on Add action is correct"
        );

        # Verify requester and response free text fields are hidden with default selected options.
        # Change option and verify JS successfully removed Hidden class and fields are shown.
        for my $Field (qw(Request Response)) {
            my $SelectField = $Field . 'NameFreeTextField';
            $Self->True(
                $Selenium->execute_script(
                    "return \$('.$SelectField.Hidden').length === 1"
                ),
                "$SelectField name free text field is hidden",
            );

            my $OptionField = $Field . 'NameScheme';
            $Selenium->execute_script(
                "\$('#$OptionField').val('Append').trigger('redraw.InputField').trigger('change');"
            );

            $Self->True(
                $Selenium->execute_script(
                    "return \$('.$SelectField.Hidden').length === 0"
                ),
                "$SelectField name free text field is shown",
            );
        }

        # Click to 'Save' and verify client side validation for missing fields.
        $Selenium->find_element("//button[\@value='Save and continue']")->click();
        for my $ValidationField (qw( NameSpace RequestNameFreeText ResponseNameFreeText MaxLength)) {
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#$ValidationField.Error').length === 1"
            );
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#$ValidationField.Error').length === 1"
                ),
                "Client side validation for missing field $ValidationField is successful",
            );
        }

        # Input fields.
        my %ProviderInputData = (
            NameSpace            => 'ProviderName' . $RandomID,
            RequestNameFreeText  => 'RequestName' . $RandomID,
            ResponseNameFreeText => 'ResponseName' . $RandomID,
            MaxLength            => '100',
        );
        for my $InputField ( sort keys %ProviderInputData ) {
            $Selenium->find_element( "#$InputField", 'css' )->send_keys( $ProviderInputData{$InputField} );
        }

        my @SortLevelOptions = ( 'SortLevel1', 'SortSubLevel1', 'SortLevel2' );

        # Add two sort level options.
        $Selenium->find_element("//input[\@name='Element']")->send_keys("$SortLevelOptions[0]");
        $Selenium->find_element("//button[\@class='CallForAction']")->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.SortableList input.SortLevel1').length  && \$('input[name=Element]').val() == ''"
        );

        $Selenium->find_element("//input[\@name='Element']")->send_keys("$SortLevelOptions[2]");
        $Selenium->find_element("//button[\@class='CallForAction']")->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.SortableList input.SortLevel2').length  && \$('input[name=Element]').val() == ''"
        );

        # Add one sub level of first options.
        $Selenium->execute_script("\$('.SortableList li:eq(1) .Icon').click()");
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.SortableList li:eq(1) ul .Element').length"
        );
        $Selenium->execute_script(
            "\$('.SortableList li:eq(1) ul .Element').val('$SortLevelOptions[1]')"
        );

        # Click on 'Save'.
        $Selenium->find_element("//button[\@value='Save and continue']")->VerifiedClick();

        # Verify URL is changed while we are on the same screen.
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=Change/,
            "Current URL after 'Save' button click is correct"
        );

        # Verify saved fields.
        for my $VerifyField ( sort keys %ProviderInputData ) {
            $Self->Is(
                $Selenium->find_element( "#$VerifyField", 'css' )->get_value(),
                $ProviderInputData{$VerifyField},
                "Input value for $VerifyField field is correct"
            );
        }

        # Verify saved sort options.
        my $Count = 1;
        for my $VerifySort (@SortLevelOptions) {
            $Self->Is(
                $Selenium->execute_script("return \$('.SortableList li:eq($Count)').find('.Element').val()"),
                $VerifySort,
                "Sort level value $VerifySort is found"
            );

            $Count++;
        }

        # Try to delete option level that contains sub level, expecting error.
        $Selenium->execute_script("\$(\$('.SortableList').find('li')[1]).children('span').children('strong').click()");
        $Selenium->WaitFor( AlertPresent => 1 );
        $Selenium->accept_alert();

        # Click on 'Save and finish' to verify JS redirection.
        $Selenium->find_element("//button[\@value='Save and finish']")->VerifiedClick();
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceWebservice/,
            "Click on 'Save and finish' button - JS is successful"
        );

        # Click to configure requester network transport.
        $Selenium->find_element("//button[\@id='RequesterTransportProperties']")->VerifiedClick();

        # Verify screen.
        for my $ID (
            qw( Endpoint NameSpace RequestNameScheme RequestNameFreeText ResponseNameScheme ResponseNameFreeText Encoding
            SOAPAction SOAPActionSeparator Authentication User Password SSLProxy SSLProxyUser SSLProxyPassword
            UseSSL SSLP12Certificate SSLP12Password SSLCAFile SSLCADir)
            )
        {
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length" );
            $Selenium->find_element( "#$ID", 'css' )->is_enabled();
        }

        # Verify URL.
        $Self->True(
            $Selenium->get_current_url()
                =~ /CommunicationType=Requester;Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=Add/,
            "Current URL on Add action is correct"
        );

        # Change SOAP action field to No.
        $Selenium->execute_script(
            "\$('#SOAPAction').val('No').trigger('redraw.InputField').trigger('change');"
        );

        # Verify certain fields are Hidden with default options,
        # select appropriate option to trigger JS to remove Hidden class.
        my @RequesterJSFields = (
            {
                CheckField  => 'RequestNameFreeTextField',
                OptionField => 'RequestNameScheme',
                OptionValue => 'Append',
            },
            {
                CheckField  => 'ResponseNameFreeTextField',
                OptionField => 'ResponseNameScheme',
                OptionValue => 'Append',
            },
            {
                CheckField  => 'SOAPActionField',
                OptionField => 'SOAPAction',
                OptionValue => 'Yes',
            },
            {
                CheckField  => 'BasicAuthField',
                OptionField => 'Authentication',
                OptionValue => 'BasicAuth',
            },
            {
                CheckField  => 'SSLField',
                OptionField => 'UseSSL',
                OptionValue => 'Yes',
            },
        );

        for my $Field (@RequesterJSFields) {

            # verify field is hidden
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('.$Field->{CheckField}').hasClass('Hidden')"
                ),
                1,
                "$Field->{CheckField} field is hidden",
            );

            # change field to trigger JS
            $Selenium->execute_script(
                "\$('#$Field->{OptionField}').val('$Field->{OptionValue}').trigger('redraw.InputField').trigger('change');"
            );

            # verify JS removed Hidden class, fields are shown
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('.$Field->{CheckField}').hasClass('Hidden')"
                ),
                0,
                "$Field->{CheckField} field is shown",
            );
        }

        # Click to 'Save' and verify client side validation for missing fields.
        $Selenium->find_element("//button[\@value='Save and continue']")->VerifiedClick();
        for my $ValidationField (qw( Endpoint NameSpace RequestNameFreeText SSLP12Certificate SSLP12Password )) {
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#$ValidationField.Error').length === 1"
            );
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#$ValidationField.Error').length === 1"
                ),
                "Client side validation for missing field $ValidationField is successful",
            );
        }

        # Input fields.
        my %RequesterInputData = (
            Endpoint             => 'http://local.otrs.com:8000/Selenium/' . $RandomID,
            NameSpace            => 'http://www.otrs.com/GenericInterface/' . $RandomID,
            RequestNameFreeText  => 'RequestName' . $RandomID,
            ResponseNameFreeText => 'ResponseName' . $RandomID,
            Encoding             => 'utf-8',
            User                 => 'User' . $RandomID,
            Password             => 'Pass' . $RandomID,
            SSLProxy             => 'http://proxy_hostname:8080',
            SSLProxyUser         => 'SSLUser' . $RandomID,
            SSLProxyPassword     => 'SSLPass' . $RandomID,
            SSLP12Certificate    => '/opt/otrs/var/Selenium/SOAP/certificate.p12',
            SSLP12Password       => 'SSLP12Pass' . $RandomID,
            SSLCAFile            => '/opt/otrs/var/Selenium/SOAP/CA/ca.pem',
            SSLCADir             => '/opt/otrs/var/Selenium/SOAP/CA',

        );
        for my $InputField ( sort keys %RequesterInputData ) {
            $Selenium->find_element( "#$InputField", 'css' )->send_keys( $RequesterInputData{$InputField} );
        }

        # Click on 'Save'.
        $Selenium->find_element("//button[\@value='Save and continue']")->VerifiedClick();

        # Verify URL is changed while we are on the same screen.
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=Change/,
            "Current URL after 'Save' button click is correct"
        );

        # Verify saved fields.
        for my $VerifyField ( sort keys %RequesterInputData ) {
            $Self->Is(
                $Selenium->find_element( "#$VerifyField", 'css' )->get_value(),
                $RequesterInputData{$VerifyField},
                "Input value for $VerifyField field is correct"
            );
        }

        # Click on 'Save and finish' to verify JS redirection.
        $Selenium->find_element("//button[\@value='Save and finish']")->VerifiedClick();
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceWebservice/,
            "Click on 'Save and finish' button - JS is successful"
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
