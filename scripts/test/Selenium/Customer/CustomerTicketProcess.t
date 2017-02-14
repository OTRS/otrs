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

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        my @DynamicFields = (
            {
                Name       => 'TestDropdownACLProcess',
                Label      => 'TestDropdownACLProcess',
                FieldOrder => 9990,
                FieldType  => 'Dropdown',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue   => '',
                    Link           => '',
                    PossibleNone   => 0,
                    PossibleValues => {
                        a => 1,
                        b => 2,
                        c => 3,
                        d => 4,
                        e => 5,
                    },
                    TranslatableValues => 1,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
        );

        my @DynamicFieldIDs;

        # Create test dynamic field of type date
        for my $DynamicField (@DynamicFields) {

            my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
                %{$DynamicField},
            );

            $Self->True(
                $DynamicFieldID,
                "Dynamic field $DynamicField->{Name} - ID $DynamicFieldID - created",
            );

            push @DynamicFieldIDs, $DynamicFieldID;
        }

        my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');

        my @ACLs = (
            {
                Name           => '1-ACL' . $Helper->GetRandomID(),
                Comment        => 'Selenium Process ACL',
                Description    => 'Description',
                StopAfterMatch => 1,
                ConfigMatch    => {
                    Properties => {
                        'Frontend' => {
                            'Action' => [
                                'CustomerTicketProcess',
                            ],
                        },
                        'Ticket' => {
                            'Queue' => [
                                '[Not]Misc',
                            ],
                        },
                    },
                },
                ConfigChange => {
                    Possible => {
                        'Ticket' => {
                            'DynamicField_TestDropdownACLProcess' => [ 'a', 'b', 'c' ],
                        },
                    },
                },
                ValidID => 1,
                UserID  => 1,
            },
            {
                Name           => '2-ACL' . $Helper->GetRandomID(),
                Comment        => 'Selenium Process ACL',
                Description    => 'Description',
                StopAfterMatch => 1,
                ConfigMatch    => {
                    Properties => {
                        'Frontend' => {
                            'Action' => [
                                'CustomerTicketProcess',
                            ],
                        },
                        'Ticket' => {
                            'Queue' => [
                                'Misc',
                            ],
                        },
                    },
                },
                ConfigChange => {
                    Possible => {
                        'Ticket' => {
                            'DynamicField_TestDropdownACLProcess' => ['d'],
                        },
                    },
                },
                ValidID => 1,
                UserID  => 1,
            },
        );

        my @ACLIDs;

        for my $ACL (@ACLs) {

            my $ACLID = $ACLObject->ACLAdd(
                %{$ACL},
            );

            $Self->True(
                $ACLID,
                "ACLID $ACLID is created",
            );

            push @ACLIDs, $ACLID;
        }

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminACL and synchronize the created ACL's.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        # navigate to AdminProcessmanagement screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # import test selenium scenario
        my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/ProcessManagement/CustomerTicketProcess.yml";
        $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
        $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->VerifiedClick();
        $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")->VerifiedClick();
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # we have to allow a 1 second delay for Apache2::Reload to pick up the changed process cache
        sleep 1;

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my @DeleteTicketIDs;

        # get process object
        my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');

        # get process list
        my $List = $ProcessObject->ProcessList(
            UseEntities => 1,
            UserID      => $TestUserID,
        );

        # get process entity
        my %ListReverse = reverse %{$List};
        my $ProcessName = "TestProcess";

        my $Process = $ProcessObject->ProcessGet(
            EntityID => $ListReverse{$ProcessName},
            UserID   => $TestUserID,
        );
        $Self->True(
            $Process,
            "Found TestProcess",
        );

        # create test customer user and login
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # navigate to CustomerTicketProcess screen
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketProcess");

        # create first scenario for test customer ticket process
        $Selenium->execute_script(
            "\$('#ProcessEntityID').val('$ListReverse{$ProcessName}').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Subject').length" );

        # Check some ACLs before the normal process tests.
        $Self->Is(
            $Selenium->execute_script("return \$('#DynamicField_TestDropdownACLProcess > option').length;"),
            3,
            "DynamicField filtered options count",
        );

        $Selenium->execute_script("\$('#QueueID').val('4').trigger('redraw.InputField').trigger('change');");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        $Self->Is(
            $Selenium->execute_script("return \$('#DynamicField_TestDropdownACLProcess > option').length;"),
            1,
            "DynamicField filtered options count",
        );

        my $SubjectRandom  = 'Subject' . $Helper->GetRandomID();
        my $ContentRandom  = 'Content' . $Helper->GetRandomID();
        my $AttachmentName = "StdAttachment-Test1.txt";
        my $AttachmentLocation
            = $Kernel::OM->Get('Kernel::Config')->Get('Home') . "/scripts/test/sample/StdAttachment/$AttachmentName";

        $Selenium->find_element( "#Subject",  'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($ContentRandom);
        $Selenium->execute_script("\$('#QueueID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($AttachmentLocation);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("[id^=\'AttachmentDelete\']").length' );

        # Check if the header is visible on the page (bug#12543).
        my $Element = $Selenium->find_element(
            "//a[contains(\@href, \'Action=CustomerTicketOverview;Subaction=MyTickets' )]"
        );
        $Element->is_enabled();
        $Element->is_displayed();

        my $FooterMessage = 'Powered by ' . $ConfigObject->Get('Product');
        $Self->True(
            index( $Selenium->get_page_source(), $FooterMessage ) > -1,
            "$FooterMessage found in footer on page (after attachment upload)",
        );

        $Selenium->find_element( "#Subject", 'css' )->VerifiedSubmit();

        sleep 1;
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("div#MainBox").length;' );

        # check for inputed values for first step in test process ticket
        $Self->True(
            index( $Selenium->get_page_source(), $SubjectRandom ) > -1,
            "$SubjectRandom found on page",
        ) || die;
        $Self->True(
            index( $Selenium->get_page_source(), $ProcessName ) > -1,
            "$ProcessName found on page",
        ) || die;
        $Self->True(
            index( $Selenium->get_page_source(), 'open' ) > -1,
            "Ticket open state found on page",
        ) || die;

        # Remember created ticket, to delete the ticket at the end of the test.
        my @TicketID = split( 'TicketID=', $Selenium->get_current_url() );
        push @DeleteTicketIDs, $TicketID[1];

        # click on next step in process ticket
        $Selenium->find_element("//a[contains(\@href, \'ProcessEntityID=$ListReverse{$ProcessName}' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject").length;' );

        # for test scenario to complete, in next step we set ticket priority to 5 very high
        $Selenium->execute_script("\$('#PriorityID').val('5').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject", 'css' )->submit();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );
        $Selenium->VerifiedRefresh();

        # check for inputed values as final step in first scenario
        $Self->True(
            index( $Selenium->get_page_source(), 'closed successful' ) > -1,
            "Ticket closed successful state found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), '5 very high' ) > -1,
            "Ticket priority 5 very high found on page",
        );

        my $EndProcessMessage = "There are no dialogs available at this point in the process.";

        $Self->True(
            index( $Selenium->get_page_source(), $EndProcessMessage ) > -1,
            "$EndProcessMessage message found on page",
        );

        # navigate to CustomerTicketProcess screen
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketProcess");

        # create second scenario for test customer ticket process
        $Selenium->execute_script(
            "\$('#ProcessEntityID').val('$ListReverse{$ProcessName}').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject").length;' );

        # in this scenario we just set ticket queue to junk to finish test
        $Selenium->execute_script("\$('#QueueID').val('3').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject", 'css' )->VerifiedSubmit();

        # check if we are at the end of test process ticket
        $Self->True(
            index( $Selenium->get_page_source(), 'Junk' ) > -1,
            "Queue Junk found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $EndProcessMessage ) > -1,
            "$EndProcessMessage message found on page",
        );

        # Remember created ticket, to delete the ticket at the end of the test.
        @TicketID = split( 'TicketID=', $Selenium->get_current_url() );
        push @DeleteTicketIDs, $TicketID[1];

        for my $TicketID (@DeleteTicketIDs) {

            my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );

            $Self->True(
                $Success,
                "Process ticket is deleted - ID $TicketID[1]",
            );
        }

        # get needed objects
        my $ActivityObject       = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
        my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');

        # clean up activities
        for my $Item ( @{ $Process->{Activities} } ) {
            my $Activity = $ActivityObject->ActivityGet(
                EntityID            => $Item,
                UserID              => $TestUserID,
                ActivityDialogNames => 0,
            );

            # clean up activity dialogs
            for my $ActivityDialogItem ( @{ $Activity->{ActivityDialogs} } ) {
                my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
                    EntityID => $ActivityDialogItem,
                    UserID   => $TestUserID,
                );

                # delete test activity dialog
                my $Success = $ActivityDialogObject->ActivityDialogDelete(
                    ID     => $ActivityDialog->{ID},
                    UserID => $TestUserID,
                );
                $Self->True(
                    $Success,
                    "ActivityDialog deleted - $ActivityDialog->{Name},",
                );
            }

            # delete test activity
            my $Success = $ActivityObject->ActivityDelete(
                ID     => $Activity->{ID},
                UserID => $TestUserID,
            );
            $Self->True(
                $Success,
                "Activity deleted - $Activity->{Name},",
            );
        }

        # get transition action object
        my $TransitionActionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');

        # clean up transition actions
        for my $Item ( @{ $Process->{TransitionActions} } ) {
            my $TransitionAction = $TransitionActionObject->TransitionActionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # delete test transition action
            my $Success = $TransitionActionObject->TransitionActionDelete(
                ID     => $TransitionAction->{ID},
                UserID => $TestUserID,
            );
            $Self->True(
                $Success,
                "TransitionAction deleted - $TransitionAction->{Name},",
            );
        }

        # get transition object
        my $TransitionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');

        # clean up transition
        for my $Item ( @{ $Process->{Transitions} } ) {
            my $Transition = $TransitionObject->TransitionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # delete test transition
            my $Success = $TransitionObject->TransitionDelete(
                ID     => $Transition->{ID},
                UserID => $TestUserID,
            );
            $Self->True(
                $Success,
                "Transition deleted - $Transition->{Name},",
            );
        }

        # delete test process
        my $Success = $ProcessObject->ProcessDelete(
            ID     => $Process->{ID},
            UserID => $TestUserID,
        );
        $Self->True(
            $Success,
            "Process deleted - $Process->{Name},",
        );

        # synchronize process after deleting test process
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # navigate to AdminProcessManagement screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # synchronize process after deleting test process
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        for my $ACLID (@ACLIDs) {

            # delete test ACL
            $Success = $ACLObject->ACLDelete(
                ID     => $ACLID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "ACLID $ACLID is deleted",
            );
        }

        # navigate to AdminACL to synchronize after test ACL cleanup
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # click 'Deploy ACLs'
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        for my $DynamicFieldID (@DynamicFieldIDs) {

            # delete created test dynamic field
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Dynamic field - ID $DynamicFieldID - deleted",
            );
        }

        # make sure cache is correct
        for my $Cache (
            qw(ProcessManagement_Activity ProcessManagement_ActivityDialog ProcessManagement_Process ProcessManagement_Transition ProcessManagement_TransitionAction )
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }

    }
);

1;
