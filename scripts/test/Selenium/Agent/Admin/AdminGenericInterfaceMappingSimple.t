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

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click on created webservice
        $Selenium->find_element("//a[contains(\@href, 'WebserviceID=$WebserviceID')]")->VerifiedClick();

        # select 'Ticket::TicketCreate' as option
        $Selenium->execute_script(
            "\$('#OperationList').val('Ticket::TicketCreate').trigger('redraw.InputField').trigger('change');"
        );

        # create webservice operation
        $Selenium->find_element( "#Operation", 'css' )->send_keys('SeleniumOperation');

        # select simple mapping for inbound and outbound data
        $Selenium->execute_script(
            "\$('#MappingInbound').val('Simple').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script(
            "\$('#MappingOutbound').val('Simple').trigger('redraw.InputField').trigger('change');"
        );

        # Set include ticket data to Yes.
        $Selenium->execute_script(
            "\$('#IncludeTicketData').val('1').trigger('redraw.InputField').trigger('change');"
        );

        # submit operation
        $Selenium->find_element("//button[\@value='Save and continue']")->VerifiedClick();

        # Verify ticket data option.
        $Self->Is(
            $Selenium->find_element( '#IncludeTicketData', 'css' )->get_value(),
            '1',
            'Include ticket data set to Yes'
        );

        # click to configure inbound mapping simple
        $Selenium->find_element("//button[\@id='MappingInboundConfigureButton']")->VerifiedClick();

        # check screen
        for my $ID (
            qw(DefaultKeyType_Search DefaultValueType_Search DefaultKeyMapTo DefaultValueMapTo AddKeyMapping)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check for breadcrumb on screen
        my @Breadcrumbs = (
            {
                Text => 'Web Service Management',
            },
            {
                Text => "Selenium $RandomID webservice",
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

        # verify DefaultKeyMapTo and DefaultValueMapTo are hidden with 'Keep (leave unchanged)' DefaultMapTo
        # and JS will show them when Map to (use provided value as default) is selected
        for my $DefaultMapTo (qw(DefaultKeyMapTo DefaultValueMapTo)) {
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#$DefaultMapTo').hasClass('Hidden')"
                ),
                "Field $DefaultMapTo is hidden"
            );

            # change default type
            if ( $DefaultMapTo eq 'DefaultKeyMapTo' ) {
                $Selenium->execute_script(
                    "\$('#DefaultKeyType').val('MapTo').trigger('redraw.InputField').trigger('change');"
                );
            }
            else {
                $Selenium->execute_script(
                    "\$('#DefaultValueType').val('MapTo').trigger('redraw.InputField').trigger('change');"
                );
            }

            $Self->False(
                $Selenium->execute_script(
                    "return \$('#$DefaultMapTo').hasClass('Hidden')"
                ),
                "Field $DefaultMapTo is shown"
            );

            # submit and check client side validation on MapTo fields
            $Selenium->find_element("//button[\@value='Save']")->click();

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#$DefaultMapTo').hasClass('Error')"
                ),
                '1',
                "Client side validation correctly detected missing input value for field $DefaultMapTo",
            );

            # input field
            $Selenium->find_element( "#$DefaultMapTo", 'css' )->send_keys($DefaultMapTo);
        }

        # add key map
        $Selenium->find_element( "#AddKeyMapping", 'css' )->click();

        # add value map
        $Selenium->find_element( "#AddValueMapping1", 'css' )->click();

        # click on 'Save'
        $Selenium->find_element("//button[\@value='Save']")->click();

        # verify key and value mapping fields and check client side validation
        for my $MapFields (qw(KeyName1 KeyMapNew1 ValueName1_1 ValueMapNew1_1)) {
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#$MapFields').hasClass('Error')"
                ),
                '1',
                "Client side validation correctly detected missing input value for field $MapFields",
            );

            # input checked field
            my $InputField = $MapFields . $RandomID;
            $Selenium->find_element( "#$MapFields", 'css' )->send_keys($InputField);
        }

        # click on 'Save'
        $Selenium->find_element("//button[\@value='Save']")->VerifiedClick();

        # verify after 'Save' click it is the same screen
        $Self->True(
            $Selenium->find_element( "#AddKeyMapping", 'css' ),
            'After click on Save it is the same screen'
        );

        # click on 'Save and finish' test JS redirection
        $Selenium->find_element("//button[\@value='Save and finish']")->VerifiedClick();

        $Self->True(
            $Selenium->get_current_url() =~ /AdminGenericInterfaceOperationDefault/,
            'JS redirection is successful to AdminGenericInterfaceOperationDefault screen'
        );

        # click to configure inbound mapping simple again
        $Selenium->find_element("//button[\@id='MappingInboundConfigureButton']")->VerifiedClick();

        # verify inputed values
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
