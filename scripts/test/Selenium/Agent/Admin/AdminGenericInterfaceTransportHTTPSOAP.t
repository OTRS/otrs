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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get some variables
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');
        my $Home         = $ConfigObject->Get('Home');

        # navigate to AdminGenericInterfaceWebservice screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice");

        # click on created web service
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();

        # select 'HTTP::SOAP' as provider network transport
        $Selenium->execute_script(
            "\$('#ProviderTransportList').val('HTTP::SOAP').trigger('redraw.InputField').trigger('change');"
        );

        # select 'HTTP::SOAP' as requester network transport
        $Selenium->execute_script(
            "\$('#RequesterTransportList').val('HTTP::SOAP').trigger('redraw.InputField').trigger('change');"
        );

        # click on 'Save'
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();

        # click to configure provider network transport
        $Selenium->find_element("//button[\@id='ProviderTransportProperties']")->VerifiedClick();

        # verify screen
        for my $ID (
            qw(
            NameSpace MaxLength
            RequestNameScheme RequestNameFreeText ResponseNameScheme ResponseNameFreeText
            SOAPAction SOAPActionSeparator SOAPActionScheme SOAPActionFreeText
            )
            )
        {
            $Selenium->find_element( "#$ID", 'css' )->is_enabled();
        }

        # verify URL
        $Self->True(
            $Selenium->get_current_url()
                =~ /CommunicationType=Provider;Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=Add/,
            "Current URL on Add action is correct"
        );

        # verify requester and response free text fields are hidden with default selected options
        # change option and verify JS successfully removed Hidden class and fields are shown
        for my $Field (qw(Request Response)) {
            my $SelectField = $Field . 'NameFreeTextField';
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('.$SelectField').hasClass('Hidden')"
                ),
                1,
                "$SelectField name free text field is hidden",
            );

            my $OptionField = $Field . 'NameScheme';
            $Selenium->execute_script(
                "\$('#$OptionField').val('Append').trigger('redraw.InputField').trigger('change');"
            );

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('.$SelectField').hasClass('Hidden')"
                ),
                0,
                "$SelectField name free text field is shown",
            );
        }

        # click to 'Save' and verify client side validation for missing fields
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        for my $ValidationField (qw( NameSpace RequestNameFreeText ResponseNameFreeText MaxLength)) {
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#$ValidationField').hasClass('Error')"
                ),
                1,
                "Client side validation for missing field $ValidationField is successful",
            );
        }

        # input fields
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

        # Click on 'Save' without entering anything to trigger client-side validation.
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check if errors are shown.
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

        # add two sort level options
        $Selenium->find_element("//input[\@name='Element']")->send_keys('SortLevel1');
        $Selenium->find_element("//button[\@class='CallForAction']")->VerifiedClick();
        $Selenium->find_element("//input[\@name='Element']")->send_keys('SortLevel2');
        $Selenium->find_element("//button[\@class='CallForAction']")->VerifiedClick();

        # add one sub level of first options
        $Selenium->execute_script("\$(\$('.SortableList').find('li')[1]).find('.Icon').click()");
        $Selenium->execute_script(
            "\$(\$('.SortableList').find('li')[1]).find('ul').find('.Element').val('SortSubLevel1')"
        );

        # click on 'Save'
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();

        # verify URL is changed while we are on the same screen
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=Change/,
            "Current URL after 'Save' button click is correct"
        );

        # verify saved fields
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

        # verify saved sort options
        my $Count = 1;
        for my $VerifySort (qw(SortLevel1 SortSubLevel1 SortLevel2)) {
            $Self->Is(
                $Selenium->execute_script("return \$('.SortableList li:eq($Count)').find('.Element').val()"),
                $VerifySort,
                "Sort level value $VerifySort is found"
            );

            $Count++;
        }

        # try to delete option level that contains sub level, expecting error
        $Selenium->execute_script("\$(\$('.SortableList').find('li')[1]).children('span').children('strong').click()");
        $Selenium->accept_alert();

        # click on 'Save and finish' verify JS redirection
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceWebservice/,
            "Click on 'Save and finish' button - JS is successful"
        );

        # click to configure requester network transport
        $Selenium->find_element("//button[\@id='RequesterTransportProperties']")->VerifiedClick();

        # verify screen
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
            $Selenium->find_element( "#$ID", 'css' )->is_enabled();
        }

        # verify URL
        $Self->True(
            $Selenium->get_current_url()
                =~ /CommunicationType=Requester;Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=Add/,
            "Current URL on Add action is correct"
        );

        # change SOAP action field to No
        $Selenium->execute_script(
            "\$('#SOAPAction').val('No').trigger('redraw.InputField').trigger('change');"
        );

 # verify certain fields are Hidden with default options, select appropriate option to trigger JS to remove Hidden class
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

            # change field to trigger JS (if necessary)
            if ( $Field->{OptionValuePre} ) {
                $Selenium->execute_script(
                    "\$('#$Field->{OptionField}').val('$Field->{OptionValuePre}').trigger('redraw.InputField').trigger('change');"
                );
            }

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

        # click to 'Save' and verify client side validation for missing fields
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        for my $ValidationField (qw( Endpoint NameSpace RequestNameFreeText ResponseNameFreeText )) {
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#$ValidationField').hasClass('Error')"
                ),
                1,
                "Client side validation for missing field $ValidationField is successful",
            );
        }

        # input fields
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
            SSLCertificate       => $Home . '/scripts/test/sample/SSL/certificate.pem',
            SSLKey               => $Home . '/scripts/test/sample/SSL/certificate.key.pem',
            SSLPassword          => 'SSLPass' . $RandomID,
            SSLCAFile            => $Home . '/scripts/test/sample/SSL/ca-certificate.pem',
            SSLCADir             => $Home . '/scripts/test/sample/SSL/',

        );
        for my $InputField ( sort keys %RequesterInputData ) {
            $Selenium->find_element( "#$InputField", 'css' )->send_keys( $RequesterInputData{$InputField} );
        }

        # click on 'Save'
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();

        # verify URL is changed while we are on the same screen
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceTransportHTTPSOAP;Subaction=Change/,
            "Current URL after 'Save' button click is correct"
        );

        # verify saved fields
        for my $VerifyField ( sort keys %RequesterInputData ) {
            $Self->Is(
                $Selenium->find_element( "#$VerifyField", 'css' )->get_value(),
                $RequesterInputData{$VerifyField},
                "Input value for $VerifyField field is correct"
            );
        }

        # click on 'Save and finish' verify JS redirection
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceWebservice/,
            "Click on 'Save and finish' button - JS is successful"
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
