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
use Kernel::System::VariableCheck qw(IsHashRefWithData);

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');

        # Do not check RichText and Service.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );

        # Enable Type feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 1
        );

        # Disable CheckEmailAddresses feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0
        );

        # Disable CheckMXRecord feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckMXRecord',
            Value => 0
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        my $TestUserOwner = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
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
            {
                Name       => 'TestTextZeroProcess',
                Label      => 'TestTextZeroProcess',
                FieldOrder => 9991,
                FieldType  => 'Text',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue => '',
                    Link         => '',
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
        );

        my @DynamicFieldIDs;

        # Create test DynamicFields.
        for my $DynamicField (@DynamicFields) {

            my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicField->{Name},
            );

            if ( !IsHashRefWithData($DynamicFieldGet) ) {
                my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
                    %{$DynamicField},
                );

                $Self->True(
                    $DynamicFieldID,
                    "Dynamic field $DynamicField->{Name} - ID $DynamicFieldID - created",
                );

                push @DynamicFieldIDs, $DynamicFieldID;
            }
        }

        my $RandomID = $Helper->GetRandomID();

        # Create Ticket types.
        my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');
        my @Types;
        for my $Count ( 1 .. 2 ) {
            my $TypeName = 'TicketType' . $Count . $RandomID;
            my $TypeID   = $TypeObject->TypeAdd(
                Name    => $TypeName,
                ValidID => 1,
                UserID  => 1,
            );
            $Self->True(
                $TypeID,
                "TypeID $TypeID is created"
            );
            push @Types, {
                ID   => $TypeID,
                Name => $TypeName,
            };
        }

        my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');

        # Set previous ACLs on invalid.
        my $ACLList = $ACLObject->ACLList(
            ValidIDs => ['1'],
            UserID   => 1,
        );

        for my $Item ( sort keys %{$ACLList} ) {

            $ACLObject->ACLUpdate(
                ID   => $Item,
                Name => $ACLList->{$Item},
                ,
                ValidID => 2,
                UserID  => 1,
            );
        }

        my @ACLs = (
            {
                Name           => '1-ACL' . $RandomID,
                Comment        => 'Selenium Process ACL',
                Description    => 'Description',
                StopAfterMatch => 1,
                ConfigMatch    => {
                    Properties => {
                        'Frontend' => {
                            'Action' => [
                                'AgentTicketProcess',
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
                Name           => '2-ACL' . $RandomID,
                Comment        => 'Selenium Process ACL',
                Description    => 'Description',
                StopAfterMatch => 1,
                ConfigMatch    => {
                    Properties => {
                        'Frontend' => {
                            'Action' => [
                                'AgentTicketProcess',
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
            {
                Name           => '3-ACL' . $RandomID,
                Comment        => 'Selenium Process ACL',
                Description    => 'Description',
                StopAfterMatch => 1,
                ConfigMatch    => {
                    Properties => {
                        'Ticket' => {
                            'DynamicField_TestDropdownACLProcess' => [
                                'c',
                            ],
                        },
                    },
                },
                ConfigChange => {
                    Possible => {
                        'Ticket' => {
                            'Type' => [ $Types[1]->{Name} ],
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

        # Get all processes.
        my $ProcessList = $ProcessObject->ProcessListGet(
            UserID => $TestUserID,
        );

        my @DeactivatedProcesses;
        my $ProcessName = "TestProcess";
        my $TestProcessExists;

        # If there had been some active processes before testing, set them to inactive.
        PROCESS:
        for my $Process ( @{$ProcessList} ) {
            if ( $Process->{State} eq 'Active' ) {

                # Check if active test process already exists.
                if ( $Process->{Name} eq $ProcessName ) {
                    $TestProcessExists = 1;
                    next PROCESS;
                }

                $ProcessObject->ProcessUpdate(
                    ID            => $Process->{ID},
                    EntityID      => $Process->{EntityID},
                    Name          => $Process->{Name},
                    StateEntityID => 'S2',
                    Layout        => $Process->{Layout},
                    Config        => $Process->{Config},
                    UserID        => $TestUserID,
                );

                # Save process because of restoring on the end of test.
                push @DeactivatedProcesses, $Process;
            }
        }

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminACL and synchronize the created ACL's.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        # Import test process if does not exist in the system.
        if ( !$TestProcessExists ) {
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#OverwriteExistingEntitiesImport').length;"
            );

            # Import test Selenium Process.
            my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/ProcessManagement/AgentTicketProcess.yml";
            $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
            $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript => "return !\$('#OverwriteExistingEntitiesImport:checked').length;"
            );
            $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")
                ->VerifiedClick();
            sleep 1;
            $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

            # We have to allow a 1 second delay for Apache2::Reload to pick up the changed Process cache.
            sleep 1;
        }

        my @DeleteTicketIDs;

        # Get Process list.
        my $List = $ProcessObject->ProcessList(
            UseEntities    => 1,
            StateEntityIDs => ['S1'],
            UserID         => $TestUserID,
        );

        # Get Process entity.
        my %ListReverse = reverse %{$List};

        my $Process = $ProcessObject->ProcessGet(
            EntityID => $ListReverse{$ProcessName},
            UserID   => $TestUserID,
        );

        # Navigate to agent ticket process directly via URL with pre-selected process and activity dialog
        # see bug#12850 ( https://bugs.otrs.org/show_bug.cgi?id=12850 ).
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketProcess;ID=$ListReverse{$ProcessName};ActivityDialogEntityID=$Process->{Activities}->[0]"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        # Check pre-selected process is loaded correctly, see bug#12850 ( https://bugs.otrs.org/show_bug.cgi?id=12850 ).
        $Self->True(
            $Selenium->find_element( "#Subject", 'css' ),
            "Pre-selected process with activity dialog via URL is successful"
        );

        # Navigate to AgentTicketProcess screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketProcess");

        # Create first scenario for test AgentTicketProcess.
        $Selenium->InputFieldValueSet(
            Element => '#ProcessEntityID',
            Value   => $ListReverse{$ProcessName},
        );

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject").length;' );

        # Check on DynamicField change - ACL restriction on Type field.
        # See bug#11512 (https://bugs.otrs.org/show_bug.cgi?id=11512).
        $Self->True(
            $Selenium->execute_script("return \$('#TypeID option:contains(\"$Types[0]->{Name}\")').length;"),
            "All Types are visible before ACL"
        );

        $Selenium->InputFieldValueSet(
            Element => '#DynamicField_TestDropdownACLProcess',
            Value   => 'c',
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        $Self->False(
            $Selenium->execute_script("return \$('#TypeID option:contains(\"$Types[0]->{Name}\")').length;"),
            "DynamicField change - ACL restricted Types"
        );
        $Selenium->InputFieldValueSet(
            Element => '#TypeID',
            Value   => $Types[1]->{ID},
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        # Check further ACLs before the normal process tests.
        $Self->Is(
            $Selenium->execute_script("return \$('#DynamicField_TestDropdownACLProcess > option').length;"),
            3,
            "DynamicField filtered options count",
        );

        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => 4,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        $Self->Is(
            $Selenium->execute_script("return \$('#DynamicField_TestDropdownACLProcess > option').length;"),
            1,
            "DynamicField filtered options count",
        );

        my $SubjectRandom = 'Subject' . $RandomID;
        my $ContentRandom = 'Content' . $RandomID;
        $Selenium->find_element( "#Subject",  'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($ContentRandom);

        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => 2,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # Check for inputed values for first step in test Process ticket.
        $Self->True(
            index( $Selenium->get_page_source(), $SubjectRandom ) > -1,
            "$SubjectRandom found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $ProcessName ) > -1,
            "$ProcessName found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), 'open' ) > -1,
            "Ticket open state found on page",
        );

        # Remember created ticket, to delete the ticket at the end of the test.
        my @TicketID = split( 'TicketID=', $Selenium->get_current_url() );
        push @DeleteTicketIDs, $TicketID[1];

        # Go on next step in Process ticket.
        my $URLNextAction = $Selenium->execute_script("return \$('#DynamicFieldsWidget .Actions a').attr('href');");
        $URLNextAction =~ s/^\///s;
        $Selenium->VerifiedGet($URLNextAction);

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject").length;' );

        # For test scenario to complete, in next step we set ticket Priority to 5 very high.
        $Selenium->InputFieldValueSet(
            Element => '#PriorityID',
            Value   => 5,
        );
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#DynamicFieldsWidget").length;' );

        # Check for inputed values as final step in first scenario.
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

        # Verify in ticket history that invisible dynamic field has been set to correct value in
        #   previous process step.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID[1]");
        $Self->True(
            index( $Selenium->get_page_source(), 'Changed dynamic field TestTextZeroProcess from "" to "0".' ) > -1,
            'Dynamic field set to correct value by process'
        );

        # Create second scenario for test AgentTicketProcess.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketProcess");
        $Selenium->InputFieldValueSet(
            Element => '#ProcessEntityID',
            Value   => $ListReverse{$ProcessName},
        );

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject").length;' );

        # In this scenario we just set ticket queue to junk to finish test.
        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => 3,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );
        $Selenium->InputFieldValueSet(
            Element => '#TypeID',
            Value   => $Types[1]->{ID},
        );
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # Check if we are at the end of test process ticket.
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

        # Check if NotificationOwnerUpdate is trigger for owner update on AgentTicketProcess. See bug#13930.
        # Add NotificationEvent.
        my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');
        my $NotificationName        = "OwnerUpdate$RandomID";
        my $NotificationID          = $NotificationEventObject->NotificationAdd(
            Name => $NotificationName,
            Data => {
                Events     => ['NotificationOwnerUpdate'],
                Recipients => ['AgentOwner'],
                Transports => ['Email'],
            },
            Message => {
                en => {
                    Subject     => 'JobName',
                    Body        => 'JobName',
                    ContentType => 'text/plain',
                },
                de => {
                    Subject     => 'JobName',
                    Body        => 'JobName',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $NotificationID,
            "NotificationID $NotificationID is created",
        );

        my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');
        $List = $ActivityDialogObject->ActivityDialogListGet(
            UserID => 1,
        );

        my %Test;
        for my $Item ( @{$List} ) {
            if ( $Item->{Name} eq 'Make order' ) {
                %Test = (
                    EntityID => $Item->{EntityID},
                    ID       => $Item->{ID},
                    Name     => $Item->{Name},
                );
            }
        }

        # Add owner to activity dialog.
        my $Success = $ActivityDialogObject->ActivityDialogUpdate(
            %Test,
            UserID => 1,
            Config => {
                DescriptionLong  => '',
                DescriptionShort => 'Make order',
                FieldOrder       => [
                    'Article',
                    'Owner',
                ],
                Fields => {
                    Article => {
                        DefaultValue     => '',
                        DescriptionLong  => '',
                        DescriptionShort => '',
                        Display          => 1,
                    },
                    Owner => {
                        DefaultValue     => '',
                        DescriptionLong  => '',
                        DescriptionShort => '',
                        Display          => 1,
                    },
                },
                Interface => [
                    'AgentInterface',
                    'CustomerInterface'
                ],
                Permission       => '',
                RequiredLock     => 0,
                SubmitAdviceText => '',
                SubmitButtonText => ''
            },

        );
        $Self->True(
            $Success,
            "Activity Dialog Update is successful",
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement;Subaction=ProcessSync");

        # Navigate to AgentTicketProcess screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketProcess");

        $Selenium->InputFieldValueSet(
            Element => '#ProcessEntityID',
            Value   => $ListReverse{$ProcessName},
        );

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject").length;' );

        $Selenium->find_element( "#Subject",              'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText",             'css' )->send_keys($ContentRandom);
        $Selenium->find_element( "#OwnerSelectionGetAll", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        my $UserObject       = $Kernel::OM->Get('Kernel::System::User');
        my $TestUserOwnwerID = $UserObject->UserLookup( UserLogin => $TestUserOwner );

        $Selenium->InputFieldValueSet(
            Element => '#OwnerID',
            Value   => $TestUserOwnwerID,
        );

        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        my @TicketOwnerID = split( 'TicketID=', $Selenium->get_current_url() );
        push @DeleteTicketIDs, $TicketOwnerID[1];

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Check if created process ticket is locked.
        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketOwnerID[1],
        );

        $Self->Is(
            $Ticket{Lock},
            'unlock',
            "TicketID $TicketOwnerID[1] is unlocked",
        );

        # Go to ticket history.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketOwnerID[1]");

        # Check if ticket history has notification send.
        my $OwnerMsg = 'Sent "'
            . $NotificationName
            . '" notification to "'
            . $TestUserOwner
            . '" via "Email". (SendAgentNotification)';
        $Self->True(
            index( $Selenium->get_page_source(), $OwnerMsg ) > -1,
            "Ticket owner notification action completed",
        );

        # Delete notification.
        $NotificationEventObject->NotificationDelete(
            ID     => $NotificationID,
            UserID => 1,
        );

        for my $TicketID (@DeleteTicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );
            }
            $Self->True(
                $Success,
                "TicketID $TicketID is deleted",
            );
        }

        # Clean up activities.
        my $ActivityObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');

        for my $Item ( @{ $Process->{Activities} } ) {
            my $Activity = $ActivityObject->ActivityGet(
                EntityID            => $Item,
                UserID              => $TestUserID,
                ActivityDialogNames => 0,
            );

            # Clean up activity dialogs.
            for my $ActivityDialogItem ( @{ $Activity->{ActivityDialogs} } ) {
                my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
                    EntityID => $ActivityDialogItem,
                    UserID   => $TestUserID,
                );

                # Delete test activity dialog.
                $Success = $ActivityDialogObject->ActivityDialogDelete(
                    ID     => $ActivityDialog->{ID},
                    UserID => $TestUserID,
                );
                $Self->True(
                    $Success,
                    "ActivityDialog $ActivityDialog->{Name} is deleted",
                );
            }

            # Delete test activity.
            $Success = $ActivityObject->ActivityDelete(
                ID     => $Activity->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "Activity $Activity->{Name} is deleted",
            );
        }

        # Clean up transition actions
        my $TransitionActionsObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
        for my $Item ( @{ $Process->{TransitionActions} } ) {
            my $TransitionAction = $TransitionActionsObject->TransitionActionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # Delete test transition action.
            $Success = $TransitionActionsObject->TransitionActionDelete(
                ID     => $TransitionAction->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "TransitionAction $TransitionAction->{Name} is deleted",
            );
        }

        # Clean up transition.
        my $TransitionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');
        for my $Item ( @{ $Process->{Transitions} } ) {
            my $Transition = $TransitionObject->TransitionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # Delete test transition.
            $Success = $TransitionObject->TransitionDelete(
                ID     => $Transition->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "Transition $Transition->{Name} is deleted",
            );
        }

        # Delete test Process.
        $Success = $ProcessObject->ProcessDelete(
            ID     => $Process->{ID},
            UserID => $TestUserID,
        );
        $Self->True(
            $Success,
            "Process $Process->{Name} is deleted",
        );

        # Delete test Types.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        for my $Type (@Types) {
            $Type->{Name} = $DBObject->Quote( $Type->{Name} );
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM ticket_type WHERE name = ?",
                Bind => [ \$Type->{Name} ],
            );
            $Self->True(
                $Success,
                "TypeID $Type->{ID} is deleted",
            );
        }

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Synchronize Process after deleting test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # Cleanup ACL.
        for my $ACLID (@ACLIDs) {

            # Delete test ACL.
            $Success = $ACLObject->ACLDelete(
                ID     => $ACLID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "ACLID $ACLID is deleted",
            );
        }

        # Navigate to AdminACL to synchronize after test ACL cleanup.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # Click 'Deploy ACLs'.
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        # Cleanup DynamicField.
        for my $DynamicFieldID (@DynamicFieldIDs) {

            # Delete created test DynamicField.
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "DynamicFieldID $DynamicFieldID is deleted",
            );
        }

        # Restore state of process.
        for my $Process (@DeactivatedProcesses) {
            $ProcessObject->ProcessUpdate(
                ID            => $Process->{ID},
                EntityID      => $Process->{EntityID},
                Name          => $Process->{Name},
                StateEntityID => 'S1',
                Layout        => $Process->{Layout},
                Config        => $Process->{Config},
                UserID        => $TestUserID,
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (
            qw (ProcessManagement_Activity ProcessManagement_ActivityDialog ProcessManagement_Transition ProcessManagement_TransitionAction )
            )
        {
            $CacheObject->CleanUp( Type => $Cache );
        }
    },
);

1;
