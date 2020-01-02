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

        # Select 'Ticket::TicketCreate' as option.
        $Selenium->InputFieldValueSet(
            Element => '#OperationList',
            Value   => 'Ticket::TicketCreate',
        );

        # Wait until AJAX loads new form.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#MappingInbound").length === 1 && $("#MappingOutbound").length === 1;'
        );

        # Create web service operation.
        $Selenium->find_element( "#Operation", 'css' )->send_keys('SeleniumOperation');

        # Select simple mapping for inbound and outbound data.
        $Selenium->InputFieldValueSet(
            Element => '#MappingInbound',
            Value   => 'Simple',
        );
        $Selenium->InputFieldValueSet(
            Element => '#MappingOutbound',
            Value   => 'Simple',
        );

        # Set include ticket data to Yes.
        $Selenium->InputFieldValueSet(
            Element => '#IncludeTicketData',
            Value   => 1,
        );

        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Verify ticket data option.
        $Self->Is(
            $Selenium->find_element( '#IncludeTicketData', 'css' )->get_value(),
            '1',
            'Include ticket data set to Yes'
        );

        # Click to configure inbound mapping simple.
        $Selenium->find_element("//button[\@id='MappingInboundConfigureButton']")->VerifiedClick();

        # Check screen.
        for my $ID (
            qw(DefaultKeyType_Search DefaultValueType_Search DefaultKeyMapTo DefaultValueMapTo AddKeyMapping)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check for breadcrumb on screen.
        my @Breadcrumbs = (
            {
                Text => 'Web Service Management',
            },
            {
                Text => "Selenium $RandomID web service",
            },
            {
                Text => 'Operation: SeleniumOperation',
            },
            {
                Text => 'Simple Mapping for Incoming Data',
            }
        );

        my $Count = 1;
        for my $Breadcrumb (@Breadcrumbs) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $Breadcrumb->{Text},
                "Breadcrumb text '$Breadcrumb->{Text}' is found on screen"
            );

            $Count++;
        }

        # Verify DefaultKeyMapTo and DefaultValueMapTo are hidden with 'Keep (leave unchanged)' DefaultMapTo
        # and JS will show them when Map to (use provided value as default) is selected
        for my $DefaultMapTo (qw(DefaultKeyMapTo DefaultValueMapTo)) {
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#$DefaultMapTo').hasClass('Hidden')"
                ),
                "Field $DefaultMapTo is hidden"
            );

            # Change default type.
            if ( $DefaultMapTo eq 'DefaultKeyMapTo' ) {
                $Selenium->InputFieldValueSet(
                    Element => '#DefaultKeyType',
                    Value   => 'MapTo',
                );
            }
            else {
                $Selenium->InputFieldValueSet(
                    Element => '#DefaultValueType',
                    Value   => 'MapTo',
                );
            }

            $Self->False(
                $Selenium->execute_script(
                    "return \$('#$DefaultMapTo').hasClass('Hidden')"
                ),
                "Field $DefaultMapTo is shown"
            );

            # Submit and check client side validation on MapTo fields.
            $Selenium->find_element( "#Submit", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript => "return \$('#$DefaultMapTo.Error').length"
            );

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#$DefaultMapTo').hasClass('Error')"
                ),
                '1',
                "Client side validation correctly detected missing input value for field $DefaultMapTo",
            );

            $Selenium->find_element( "#$DefaultMapTo", 'css' )->send_keys($DefaultMapTo);
        }

        # Add key map and value map.
        $Selenium->find_element( "#AddKeyMapping",    'css' )->click();
        $Selenium->find_element( "#AddValueMapping1", 'css' )->click();
        $Selenium->find_element( "#Submit",           'css' )->click();

        # Verify key and value mapping fields and check client side validation.
        for my $MapFields (qw(KeyName1 KeyMapNew1 ValueName1_1 ValueMapNew1_1)) {
            $Selenium->WaitFor(
                JavaScript => "return \$('#$MapFields.Error').length"
            );
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#$MapFields').hasClass('Error')"
                ),
                '1',
                "Client side validation correctly detected missing input value for field $MapFields",
            );

            my $InputField = $MapFields . $RandomID;
            $Selenium->find_element( "#$MapFields", 'css' )->send_keys($InputField);
        }

        # Click on 'Save'.
        $Selenium->find_element( "#SubmitAndContinue", 'css' )->VerifiedClick();

        # Verify after 'Save' click it is the same screen.
        $Self->True(
            $Selenium->find_element( "#AddKeyMapping", 'css' ),
            'After click on Save it is the same screen'
        );

        # Click on 'Save and finish' test JS redirection.
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        $Self->True(
            $Selenium->get_current_url() =~ /AdminGenericInterfaceOperationDefault/,
            'JS redirection is successful to AdminGenericInterfaceOperationDefault screen'
        );

        # Click to configure inbound mapping simple again.
        $Selenium->find_element("//button[\@id='MappingInboundConfigureButton']")->VerifiedClick();

        # Verify inputed values.
        my %FieldValues = (
            DefaultKeyMapTo   => 'DefaultKeyMapTo',
            DefaultValueMapTo => 'DefaultValueMapTo',
            KeyName1          => 'KeyName1' . $RandomID,
            KeyMapNew1        => 'KeyMapNew1' . $RandomID,
            ValueName1_1      => 'ValueName1_1' . $RandomID,
            ValueMapNew1_1    => 'ValueMapNew1_1' . $RandomID,
        );

        for my $CheckField ( sort keys %FieldValues ) {
            $Self->Is(
                $Selenium->find_element( "#$CheckField", 'css' )->get_value(),
                $FieldValues{$CheckField},
                "Value for field $CheckField is found",
            );
        }

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
