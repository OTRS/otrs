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

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');
        my $Home         = $ConfigObject->Get('Home');

        # Navigate to AdminGenericInterfaceWebservice screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # Click on created web service.
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();

        # Select 'HTTP::SOAP' as provider network transport.
        $Selenium->InputFieldValueSet(
            Element => '#ProviderTransportList',
            Value   => 'HTTP::SOAP',
        );

        # Select 'HTTP::SOAP' as requester network transport.
        $Selenium->InputFieldValueSet(
            Element => '#RequesterTransportList',
            Value   => 'HTTP::SOAP',
        );

        # Click on 'Save'.
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SubmitAndContinue").length' );

        # Click to configure provider network transport.
        $Selenium->find_element( "#ProviderTransportProperties", 'css' )->VerifiedClick();

        # Verify screen.
        for my $ID (
            qw(
            NameSpace MaxLength
            RequestNameScheme RequestNameFreeText ResponseNameScheme ResponseNameFreeText
            SOAPAction SOAPActionSeparator SOAPActionScheme SOAPActionFreeText
            )
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
            $Selenium->InputFieldValueSet(
                Element => "#$OptionField",
                Value   => 'Append',
            );

            $Self->True(
                $Selenium->execute_script(
                    "return \$('.$SelectField.Hidden').length === 0"
                ),
                "$SelectField name free text field is shown",
            );
        }

        # Click to 'Save' and verify client side validation for missing fields.
        $Selenium->find_element( "#Submit", 'css' )->click();

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

        # Add one additional response header line.
        $Selenium->find_element( "#AddValue", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.DefaultValueKeyItem:visible').length  && \$('.DefaultValueItem:visible').length"
        );

        # Click on 'Save' without entering anything to trigger client-side validation.
        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.DefaultValueKeyItem.Error').length  && \$('.DefaultValueItem.Error').length"
        );

        # Verify errors are shown.
        $Self->True(
            $Selenium->execute_script(
                "return \$('.DefaultValueKeyItem.Error').length;"
            ),
            'Default key field highlighted as an error'
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('.DefaultValueItem.Error').length;"
            ),
            'Default key field highlighted as an error'
        );

        # Input key and value for additional response headers.
        $Selenium->find_element( '.DefaultValueKeyItem', 'css' )->send_keys('Key1');
        $Selenium->find_element( '.DefaultValueItem',    'css' )->send_keys('Value1');

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
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();

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
        $Self->Is(
            $Selenium->find_element( '.DefaultValueKeyItem', 'css' )->get_value(),
            'Key1',
            'Input value for DefaultValueKeyItem field is correct'
        );
        $Self->Is(
            $Selenium->find_element( '.DefaultValueItem', 'css' )->get_value(),
            'Value1',
            'Input value for DefaultValueItem field is correct'
        );

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
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceWebservice/,
            "Click on 'Save and finish' button - JS is successful"
        );

        # Click to configure requester network transport.
        $Selenium->find_element("//button[\@id='RequesterTransportProperties']")->VerifiedClick();

        # Verify screen.
        for my $ID (
            qw(
            Endpoint NameSpace Encoding Timeout
            RequestNameScheme RequestNameFreeText ResponseNameScheme ResponseNameFreeText
            SOAPAction SOAPActionSeparator SOAPActionScheme SOAPActionFreeText
            AuthType BasicAuthUser BasicAuthPassword
            UseSSL SSLCertificate SSLKey SSLPassword SSLCAFile SSLCADir
            UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude
            )
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
        $Selenium->InputFieldValueSet(
            Element => '#SOAPAction',
            Value   => 'No',
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
                CheckField  => 'SOAPActionSchemeField',
                OptionField => 'SOAPAction',
                OptionValue => 'Yes',
            },
            {
                CheckField     => 'SOAPActionFreeTextField',
                OptionField    => 'SOAPActionScheme',
                OptionValuePre => 'SeparatorOperation',
                OptionValue    => 'FreeText',
            },
            {
                CheckField     => 'SOAPActionSeparatorField',
                OptionField    => 'SOAPActionScheme',
                OptionValuePre => 'FreeText',
                OptionValue    => 'SeparatorOperation',
            },
            {
                CheckField     => 'SOAPActionSeparatorField',
                OptionField    => 'SOAPActionScheme',
                OptionValuePre => 'FreeText',
                OptionValue    => 'NameSpaceSeparatorOperation',
            },
            {
                CheckField  => 'BasicAuthField',
                OptionField => 'AuthType',
                OptionValue => 'BasicAuth',
            },
            {
                CheckField  => 'SSLField',
                OptionField => 'UseSSL',
                OptionValue => 'Yes',
            },
            {
                CheckField  => 'ProxyField',
                OptionField => 'UseProxy',
                OptionValue => 'Yes',
            },
        );

        for my $Field (@RequesterJSFields) {

            # Change field to trigger JS (if necessary).
            if ( $Field->{OptionValuePre} ) {
                $Selenium->InputFieldValueSet(
                    Element => "#$Field->{OptionField}",
                    Value   => $Field->{OptionValuePre},
                );
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('.$Field->{CheckField}.Hidden').length === 1"
                );
            }

            # Verify field is hidden.
            $Self->True(
                $Selenium->execute_script(
                    "return \$('.$Field->{CheckField}.Hidden').length === 1"
                ),
                "$Field->{CheckField} field is hidden",
            );

            # Change field to trigger JS.
            $Selenium->InputFieldValueSet(
                Element => "#$Field->{OptionField}",
                Value   => $Field->{OptionValue},
            );

            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('.$Field->{CheckField}.Hidden').length === 0"
            );

            # Verify JS removed Hidden class, fields are shown.
            $Self->True(
                $Selenium->execute_script(
                    "return \$('.$Field->{CheckField}.Hidden').length === 0"
                ),
                "$Field->{CheckField} field is shown",
            );
        }

        # Click to 'Save' and verify client side validation for missing fields.
        $Selenium->find_element( "#Submit", 'css' )->click();
        for my $ValidationField (qw( Endpoint NameSpace RequestNameFreeText ResponseNameFreeText )) {
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
            BasicAuthUser        => 'User' . $RandomID,
            BasicAuthPassword    => 'Pass' . $RandomID,
            ProxyHost            => 'http://proxy_hostname:8080',
            ProxyUser            => 'SSLUser' . $RandomID,
            ProxyPassword        => 'SSLPass' . $RandomID,
            SSLCertificate       => "$Home/scripts/test/sample/SSL/certificate.pem",
            SSLKey               => "$Home/scripts/test/sample/SSL/certificate.key.pem",
            SSLPassword          => 'SSLPass' . $RandomID,
            SSLCAFile            => "$Home/scripts/test/sample/SSL/ca-certificate.pem",
            SSLCADir             => "$Home/scripts/test/sample/SSL/",

        );
        for my $InputField ( sort keys %RequesterInputData ) {
            $Selenium->find_element( "#$InputField", 'css' )->send_keys( $RequesterInputData{$InputField} );
        }

        # Click on 'Save'.
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();

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
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
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
