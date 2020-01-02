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

        # Select 'HTTP::REST' as provider network transport.
        $Selenium->InputFieldValueSet(
            Element => '#ProviderTransportList',
            Value   => 'HTTP::REST',
        );

        # Select 'HTTP::REST' as requester network transport.
        $Selenium->InputFieldValueSet(
            Element => '#RequesterTransportList',
            Value   => 'HTTP::REST',
        );

        # Click on 'Save'.
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();

        # Click to configure provider network transport.
        $Selenium->find_element("//button[\@id='ProviderTransportProperties']")->VerifiedClick();

        # Verify screen.
        for my $ID (
            qw(MaxLength KeepAlive)
            )
        {
            $Selenium->find_element( "#$ID", 'css' )->is_enabled();
        }

        # Verify URL.
        $Self->True(
            $Selenium->get_current_url()
                =~ /CommunicationType=Provider;Action=AdminGenericInterfaceTransportHTTPREST;Subaction=Add/,
            "Current URL on Add action is correct"
        );

        $Selenium->find_element( "#MaxLength", 'css' )->send_keys('1000');
        $Selenium->InputFieldValueSet(
            Element => '#KeepAlive',
            Value   => 1,
        );

        # Add one additional response header line.
        $Selenium->find_element( "#AddValue", 'css' )->click();

        # Click on 'Save' without entering anything to trigger client-side validation.
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return \$('.DefaultValueKeyItem.Error').length && \$('.DefaultValueItem.Error').length"
        );

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

        # Click on 'Save'.
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();

        # Verify URL is changed while we are on the same screen.
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceTransportHTTPREST;Subaction=Change/,
            "Current URL after 'Save' button click is correct"
        );

        # Verify saved fields.
        $Self->Is(
            $Selenium->find_element( "#MaxLength", 'css' )->get_value(),
            '1000',
            "Inputed value for MaxLength field is correct"
        );
        $Self->Is(
            $Selenium->find_element( "#KeepAlive", 'css' )->get_value(),
            1,
            "Selected value for KeepAlive field is correct"
        );
        $Self->Is(
            $Selenium->find_element( '.DefaultValueKeyItem', 'css' )->get_value(),
            'Key1',
            'Inputed value for DefaultValueKeyItem field is correct'
        );
        $Self->Is(
            $Selenium->find_element( '.DefaultValueItem', 'css' )->get_value(),
            'Value1',
            'Inputed value for DefaultValueItem field is correct'
        );

        # Click on 'Save and finish' verify JS redirection.
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
            Host DefaultCommand Timeout
            AuthType BasicAuthUser BasicAuthPassword
            UseSSL SSLCertificate SSLKey SSLPassword SSLCAFile SSLCADir
            UseProxy ProxyHost ProxyUser ProxyPassword ProxyExclude
            )
            )
        {
            $Selenium->find_element( "#$ID", 'css' )->is_enabled();
        }

        # Verify URL.
        $Self->True(
            $Selenium->get_current_url()
                =~ /CommunicationType=Requester;Action=AdminGenericInterfaceTransportHTTPREST;Subaction=Add/,
            "Current URL on Add action is correct"
        );

        # Click to 'Save' and verify client side validation for missing fields.
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->click();
        for my $ValidationField (qw( Host )) {
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#$ValidationField.Error').length"
            );
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#$ValidationField').hasClass('Error')"
                ),
                1,
                "Client side validation for missing field $ValidationField is successful",
            );
        }

        # Verify certain fields are Hidden with default options,
        # select appropriate option to trigger JS to remove Hidden class.
        my @RequesterJSFields = (
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
            }

            # Verify field is hidden.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('.$Field->{CheckField}').hasClass('Hidden')"
                ),
                1,
                "$Field->{CheckField} field is hidden",
            );

            # Change field to trigger JS.
            $Selenium->InputFieldValueSet(
                Element => "#$Field->{OptionField}",
                Value   => $Field->{OptionValue},
            );

            # Verify JS removed Hidden class, fields are shown.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('.$Field->{CheckField}').hasClass('Hidden')"
                ),
                0,
                "$Field->{CheckField} field is shown",
            );
        }

        # Input fields.
        my %RequesterInputData = (
            Host              => 'TransportHost-' . $RandomID,
            BasicAuthUser     => 'User' . $RandomID,
            BasicAuthPassword => 'Pass' . $RandomID,
            ProxyHost         => 'http://proxy_hostname:8080',
            ProxyUser         => 'SSLUser' . $RandomID,
            ProxyPassword     => 'SSLPass' . $RandomID,
            SSLCertificate    => $Home . '/scripts/test/sample/SSL/certificate.pem',
            SSLKey            => $Home . '/scripts/test/sample/SSL/certificate.key.pem',
            SSLPassword       => 'SSLPass' . $RandomID,
            SSLCAFile         => $Home . '/scripts/test/sample/SSL/ca-certificate.pem',
            SSLCADir          => $Home . '/scripts/test/sample/SSL/',
        );
        for my $InputField ( sort keys %RequesterInputData ) {
            $Selenium->find_element( "#$InputField", 'css' )->send_keys( $RequesterInputData{$InputField} );
        }

        # Click on 'Save'.
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();

        # Verify URL is changed while we are on the same screen.
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceTransportHTTPREST;Subaction=Change/,
            "Current URL after 'Save' button click is correct"
        );

        # Verify saved fields.
        for my $VerifyField ( sort keys %RequesterInputData ) {
            $Self->Is(
                $Selenium->find_element( "#$VerifyField", 'css' )->get_value(),
                $RequesterInputData{$VerifyField},
                "Inputed value for $VerifyField field is correct"
            );
        }

        # Click on 'Save and finish' verify JS redirection.
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
