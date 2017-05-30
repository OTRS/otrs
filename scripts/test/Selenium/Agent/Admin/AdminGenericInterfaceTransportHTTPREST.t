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

        # create test webservice
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
            Name    => "Selenium $RandomID webservice",
            ValidID => 1,
            UserID  => 1,
        );

        $Self->True(
            $WebserviceID,
            "Webservice ID $WebserviceID is created"
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

        # click on created webservice
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();

        # select 'HTTP::REST' as provider network transport
        $Selenium->execute_script(
            "\$('#ProviderTransportList').val('HTTP::REST').trigger('redraw.InputField').trigger('change');"
        );

        # select 'HTTP::REST' as requester network transport
        $Selenium->execute_script(
            "\$('#RequesterTransportList').val('HTTP::REST').trigger('redraw.InputField').trigger('change');"
        );

        # click on 'Save'
        $Selenium->find_element("//button[\@value='Save and continue']")->VerifiedClick();

        # click to configure provider network transport
        $Selenium->find_element("//button[\@id='ProviderTransportProperties']")->VerifiedClick();

        # verify screen
        for my $ID (
            qw(MaxLength KeepAlive)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # verify URL
        $Self->True(
            $Selenium->get_current_url()
                =~ /CommunicationType=Provider;Action=AdminGenericInterfaceTransportHTTPREST;Subaction=Add/,
            "Current URL on Add action is correct"
        );

        # input fields
        $Selenium->find_element( "#MaxLength", 'css' )->send_keys('1000');
        $Selenium->execute_script("\$('#KeepAlive').val('1').trigger('redraw.InputField').trigger('change');");

        # Add one additional response header line.
        $Selenium->find_element( "#AddValue", 'css' )->click();

        # Click on 'Save' without entering anything to trigger client-side validation.
        $Selenium->find_element("//button[\@value='Save and continue']")->click();

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

        # click on 'Save'
        $Selenium->find_element("//button[\@value='Save and continue']")->VerifiedClick();

        # verify URL is changed while we are on the same screen
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceTransportHTTPREST;Subaction=Change/,
            "Current URL after 'Save' button click is correct"
        );

        # verify saved fields
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

        # click on 'Save and finish' verify JS redirection
        $Selenium->find_element("//button[\@value='Save and finish']")->VerifiedClick();
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceWebservice/,
            "Click on 'Save and finish' button - JS is successful"
        );

        # click to configure requester network transport
        $Selenium->find_element("//button[\@id='RequesterTransportProperties']")->VerifiedClick();

        # verify screen
        for my $ID (
            qw(Host DefaultCommand Authentication UseX509 User Password X509CertFile X509KeyFile X509CAFile)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # verify URL
        $Self->True(
            $Selenium->get_current_url()
                =~ /CommunicationType=Requester;Action=AdminGenericInterfaceTransportHTTPREST;Subaction=Add/,
            "Current URL on Add action is correct"
        );

        # verify Authentication fields are hidden
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.BasicAuthField').hasClass('Hidden')"
            ),
            1,
            'Authentication fields are hidden',
        );

        # select BasicAuth as Authentication option, verify JS remove Hidden class and fields are shown
        $Selenium->execute_script(
            "\$('#Authentication').val('BasicAuth').trigger('redraw.InputField').trigger('change');"
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.BasicAuthField').hasClass('Hidden')"
            ),
            0,
            'Authentication fields are shown - JS is successful',
        );

        # verify SSL option fields are hidden
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.X509Field').hasClass('Hidden')"
            ),
            1,
            'SSL option fields are hidden',
        );

        # select Yes to use SSL options, verify JS removed Hidden class and fields are shown
        $Selenium->execute_script("\$('#UseX509').val('Yes').trigger('redraw.InputField').trigger('change');");
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.X509Field').hasClass('Hidden')"
            ),
            0,
            'SLL option fields are shown - JS is successful',
        );

        # click to 'Save' and verify client side validation for missing fields
        $Selenium->find_element("//button[\@value='Save and continue']")->VerifiedClick();
        for my $ValidationField (qw( Host User X509CertFile X509KeyFile)) {
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#$ValidationField').hasClass('Error')"
                ),
                1,
                'Client side validation for missing fields is successful',
            );
        }

        # input fields
        my %InputData = (
            Host         => 'TransportHost-' . $RandomID,
            User         => 'User' . $RandomID,
            Password     => 'Pass' . $RandomID,
            X509CertFile => '/opt/otrs/var/Selenium/ssl.crt',
            X509KeyFile  => '/opt/otrs/var/Selenium/ssl.key',
            X509CAFile   => '/opt/otrs/var/Selenium/ca.file'
        );
        for my $InputField ( sort keys %InputData ) {
            $Selenium->find_element( "#$InputField", 'css' )->send_keys( $InputData{$InputField} );
        }

        # click on 'Save'
        $Selenium->find_element("//button[\@value='Save and continue']")->VerifiedClick();

        # verify URL is changed while we are on the same screen
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceTransportHTTPREST;Subaction=Change/,
            "Current URL after 'Save' button click is correct"
        );

        # verify saved fields
        for my $VerifyField ( sort keys %InputData ) {
            $Self->Is(
                $Selenium->find_element( "#$VerifyField", 'css' )->get_value(),
                $InputData{$VerifyField},
                "Inputed value for $VerifyField field is correct"
            );
        }

        # click on 'Save and finish' verify JS redirection
        $Selenium->find_element("//button[\@value='Save and finish']")->VerifiedClick();
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AdminGenericInterfaceWebservice/,
            "Click on 'Save and finish' button - JS is successful"
        );

        # delete test created webservice
        my $Success = $WebserviceObject->WebserviceDelete(
            ID     => $WebserviceID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Webservice ID $WebserviceID is deleted"
        );

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Webservice' );

    }

);

1;
