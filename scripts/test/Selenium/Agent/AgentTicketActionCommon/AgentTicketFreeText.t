# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

# Create local function for wait on AJAX update.
my $WaitForAJAX = sub {
    $Selenium->WaitFor(
        JavaScript =>
            'return typeof($) === "function" && !$("span.AJAXLoader:visible").length'
    );
};

$Selenium->RunTest(
    sub {

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my $TicketObject    = $Kernel::OM->Get('Kernel::System::Ticket');
        my $QueueObject     = $Kernel::OM->Get('Kernel::System::Queue');
        my $ServiceObject   = $Kernel::OM->Get('Kernel::System::Service');
        my $SLAObject       = $Kernel::OM->Get('Kernel::System::SLA');
        my $StateObject     = $Kernel::OM->Get('Kernel::System::State');
        my $DBObject        = $Kernel::OM->Get('Kernel::System::DB');
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $RandomID = $Helper->GetRandomID();
        my $Success;

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Enable ticket responsible feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Responsible',
            Value => 1,
        );

        # Enable ticket service feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate()
            || die "Did not get test customer user";

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Title' . $RandomID,
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        # Create test queue.
        my $QueueName = 'Queue' . $RandomID;
        my $QueueID   = $QueueObject->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Some comment',
            UserID          => 1,
        );
        $Self->True(
            $QueueID,
            "QueueID $QueueID is created",
        );

        # Create test service.
        my $ServiceName = 'Service' . $RandomID;
        my $ServiceID   = $ServiceObject->ServiceAdd(
            Name    => $ServiceName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $ServiceID,
            "ServiceID $ServiceID is created",
        );

        # Add member customer user to the test service.
        $ServiceObject->CustomerUserServiceMemberAdd(
            CustomerUserLogin => $TestCustomerUserLogin,
            ServiceID         => $ServiceID,
            Active            => 1,
            UserID            => 1,
        );

        # Create test SLA.
        my $SLAName = 'SLA' . $RandomID;
        my $SLAID   = $SLAObject->SLAAdd(
            ServiceIDs => [$ServiceID],
            Name       => $SLAName,
            ValidID    => 1,
            UserID     => 1,
        );
        $Self->True(
            $TicketID,
            "SLAID $SLAID is created",
        );

        # Get 'open' type ID.
        my %ListType = $StateObject->StateTypeList(
            UserID => 1,
        );
        my %ReverseListType = reverse %ListType;
        my $OpenID          = $ReverseListType{"open"};

        # Create test state (type 'open').
        my $StateName = 'State' . $RandomID;
        my $StateID   = $StateObject->StateAdd(
            Name    => $StateName,
            ValidID => 1,
            TypeID  => $OpenID,
            UserID  => 1,
        );
        $Self->True(
            $StateID,
            "StateID $StateID is created",
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Define field IDs and frontend modules.
        my %FreeTextFields = (
            NoMandatory => {
                ServiceID        => 'Service',
                NewQueueID       => 'Queue',
                NewOwnerID       => 'Owner',
                NewResponsibleID => 'Responsible',
                NewStateID       => 'State',
            },
            Mandatory => {
                ServiceID        => 'ServiceMandatory',
                SLAID            => 'SLAMandatory',
                NewQueueID       => 'QueueMandatory',
                NewOwnerID       => 'OwnerMandatory',
                NewResponsibleID => 'ResponsibleMandatory',
                NewStateID       => 'StateMandatory',
                }
        );

        my @Tests = (
            {
                Name          => 'Disable NoMandatory and Mandatory fields, check NoMandatory field IDs',
                CheckFields   => 'NoMandatory',
                NoMandatory   => 0,
                Mandatory     => 0,
                ExpectedExist => 0,
            },
            {
                Name          => 'Enable NoMandatory and disable Mandatory fields, check NoMandatory field IDs',
                CheckFields   => 'NoMandatory',
                NoMandatory   => 1,
                Mandatory     => 0,
                ExpectedExist => 1,
            },
            {
                Name          => 'Disable NoMandatory and enable Mandatory fields, check Mandatory field IDs',
                CheckFields   => 'Mandatory',
                NoMandatory   => 0,
                Mandatory     => 1,
                ExpectedExist => 0,
            },
            {
                Name          => 'Enable NoMandatory and Mandatory fields, check Mandatory field IDs',
                CheckFields   => 'Mandatory',
                NoMandatory   => 1,
                Mandatory     => 1,
                ExpectedExist => 1,
            }
        );

        for my $Test (@Tests) {

            # Write test case description.
            $Self->True(
                1,
                $Test->{Name},
            );

            for my $NoMandatoryField ( values %{ $FreeTextFields{NoMandatory} } ) {

                $Helper->ConfigSettingChange(
                    Valid => 1,
                    Key   => "Ticket::Frontend::AgentTicketFreeText###$NoMandatoryField",
                    Value => $Test->{NoMandatory},
                );
            }

            for my $MandatoryField ( values %{ $FreeTextFields{Mandatory} } ) {

                $Helper->ConfigSettingChange(
                    Valid => 1,
                    Key   => "Ticket::Frontend::AgentTicketFreeText###$MandatoryField",
                    Value => $Test->{Mandatory},
                );
            }

            # Navigate to zoom view of created test ticket.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

            # Force sub menus to be visible in order to be able to click one of the links.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
            );

            # Click on 'Free Fields' and switch window.
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketFreeText;TicketID=$TicketID' )]")
                ->click();

            $Selenium->WaitFor( WindowCount => 2 );
            my $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # Wait until page has loaded, if necessary.
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

            # Get NoMandatory/Mandatory fields for exist checking.
            my $CheckFields = $Test->{CheckFields};

            for my $FieldID ( sort keys %{ $FreeTextFields{$CheckFields} } ) {

                if ( $Test->{ExpectedExist} == 0 ) {
                    $Self->False(
                        $Selenium->execute_script(
                            "return \$('#$FieldID').length"
                        ),
                        "FieldID $FieldID doesn't exist",
                    );
                }
                else {
                    $Self->True(
                        $Selenium->execute_script("return \$('#$FieldID').length"),
                        "FieldID $FieldID exists",
                    );
                    if ( $CheckFields eq 'Mandatory' ) {
                        $Self->Is(
                            $Selenium->execute_script("return \$('label[for=$FieldID]').hasClass('Mandatory')"),
                            1,
                            "FieldID $FieldID is mandatory",
                        );
                    }
                }
            }

            # Close the window and switch back to the first screen.
            $Selenium->find_element( ".CancelClosePopup", 'css' )->click();
            $Selenium->WaitFor( WindowCount => 1 );
            $Selenium->switch_to_window( $Handles->[0] );
        }

        # Define field values.
        my %SetFreeTextFields = (
            ServiceID        => $ServiceID,
            SLAID            => $SLAID,
            NewQueueID       => $QueueID,
            NewOwnerID       => $TestUserID,
            NewResponsibleID => $TestUserID,
            NewStateID       => $StateID,
        );

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );

        # Click on 'Free Fields' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketFreeText;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # Fill all free text fields.
        FREETEXTFIELDS:
        for my $FieldID ( sort keys %SetFreeTextFields ) {

            next FREETEXTFIELDS if $FieldID eq 'SLAID';

            $Selenium->execute_script(
                "\$('#$FieldID').val('$SetFreeTextFields{$FieldID}').trigger('redraw.InputField').trigger('change')"
            );

            # Wait for AJAX to finish.
            $WaitForAJAX->();

            if ( $FieldID eq 'ServiceID' ) {

                $Selenium->execute_script(
                    "\$('#SLAID').val('$SetFreeTextFields{SLAID}').trigger('redraw.InputField').trigger('change')"
                );

                # Wait for AJAX to finish.
                $WaitForAJAX->();
            }
        }

        # Test cases - all fields are set except exactly one, and in the last case all fields are set.
        @Tests = (
            {
                Name      => 'Clear Service field',
                ServiceID => '',
            },
            {
                Name      => 'Clear SLA field and set back Service field',
                ServiceID => $ServiceID,
                SLAID     => '',
            },
            {
                Name       => 'Clear Queue field and set back SLA field',
                SLAID      => $SLAID,
                NewQueueID => '',
            },
            {
                Name       => 'Clear Owner field and set back Queue field',
                NewQueueID => $QueueID,
                NewOwnerID => '',
            },
            {
                Name             => 'Clear Responsible field and set back Owner field',
                NewOwnerID       => $TestUserID,
                NewResponsibleID => '',
            },
            {
                Name             => 'Clear State field and set back Responsible field',
                NewResponsibleID => $TestUserID,
                NewStateID       => '',
            },
            {
                Name       => 'Set back State field - all fields are set',
                NewStateID => $StateID,
            }
        );

        # Run test - in each iteration exactly one field is empty, last case is correct.
        for my $Test (@Tests) {

            # Write test case description.
            $Self->True(
                1,
                $Test->{Name},
            );

            my $ExpectedErrorFieldID;

            TESTFIELD:
            for my $FieldID ( sort keys %{$Test} ) {

                next TESTFIELD if $FieldID eq 'Name';

                if ( $Test->{$FieldID} eq '' ) {
                    $ExpectedErrorFieldID = $FieldID;
                }

                $Selenium->execute_script(
                    "\$('#$FieldID').val('$Test->{$FieldID}').trigger('redraw.InputField').trigger('change')"
                );

                # Wait for AJAX to finish.
                $WaitForAJAX->();
            }

            # Wait until opened field (due to error) has closed.
            $Selenium->WaitFor( JavaScript => 'return $("div.jstree-wholerow:visible").length == 0' );

            # Submit.
            $Selenium->find_element( "#submitRichText", 'css' )->click();

            # Check if class Error exists in expected field ID.
            if ($ExpectedErrorFieldID) {
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('#$ExpectedErrorFieldID').hasClass('Error')"
                    ),
                    "FieldID $ExpectedErrorFieldID is empty",
                );
            }
            else {
                $Self->True(
                    1,
                    "All mandatory fields are filled - successful free text fields update",
                );

                # Switch back to the main window.
                $Selenium->WaitFor( WindowCount => 1 );
                $Selenium->switch_to_window( $Handles->[0] );
            }
        }

        # Define messages in ticket history screen.
        my %FreeFieldMessages = (
            ServiceUpdate     => "Changed service to \"$ServiceName\" ($ServiceID).",
            SLAUpdate         => "Changed SLA to \"$SLAName\" ($SLAID).",
            OwnerUpdate       => "Changed owner to \"$TestUserLogin\" ($TestUserID).",
            ResponsibleUpdate => "Changed responsible to \"$TestUserLogin\" ($TestUserID).",
            QueueUpdate       => "Changed queue to \"$QueueName\" ($QueueID) from \"Raw\" (2).",
            StateUpdate       => "Changed state from \"new\" to \"$StateName\"."
        );

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-History ul").css({ "height": "auto", "opacity": "100" });'
        );

        # Navigate to AgentTicketHistory of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        for my $Action ( sort keys %FreeFieldMessages ) {

            $Self->True(
                index( $Selenium->get_page_source(), $FreeFieldMessages{$Action} ) > -1,
                "Action $Action is completed",
            );
        }

        # Cleanup
        # Delete created test ticket.
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "TicketID $TicketID is deleted"
        );

        # Delete customer user referenced for service.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM service_customer_user WHERE customer_user_login = ?",
            Bind => [ \$TestCustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "Deleted service relations for $TestCustomerUserLogin",
        );

        # Delete sla referenced for service.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM service_sla WHERE service_id = $ServiceID OR sla_id = $SLAID",
        );
        $Self->True(
            $Success,
            "Relation SLAID $SLAID referenced to service ID $ServiceID is deleted",
        );

        # Delete created test service.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM service WHERE id = $ServiceID",
        );
        $Self->True(
            $Success,
            "ServiceID $ServiceID is deleted",
        );

        # Delete created test SLA.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM sla WHERE id = $SLAID",
        );
        $Self->True(
            $Success,
            "SLAID $SLAID is deleted",
        );

        # Delete created test state.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM ticket_state WHERE id = $StateID",
        );
        $Self->True(
            $Success,
            "StateID $StateID is deleted",
        );

        # Delete created test queue.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "QueueID $QueueID is deleted",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw(Ticket Service SLA State Queue)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
