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

        my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
        my $ACLObject     = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $QueueObject   = $Kernel::OM->Get('Kernel::System::Queue');
        my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

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

        my $RandomID = $Helper->GetRandomID();

        # Create test user.
        my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );

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

        # Create test queues.
        my @Queues;
        for my $Item (qw( process activity dialog )) {
            my $QueueName = "Queue$Item-$RandomID";
            my $QueueID   = $QueueObject->QueueAdd(
                Name            => $QueueName,
                ValidID         => 1,
                GroupID         => 1,
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                Comment         => 'Selenium Queue',
                UserID          => $TestUserID,
            );
            $Self->True(
                $QueueID,
                "QueueID $QueueID is created"
            );
            push @Queues, {
                ID   => $QueueID,
                Name => $QueueName,
            };
        }

        # Login.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Import test process if does not exist in the system.
        if ( !$TestProcessExists ) {
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#OverwriteExistingEntitiesImport').length;"
            );

            # Import test Selenium Process.
            my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/ProcessManagement/TestProcess.yml";
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

            $Self->True(
                1,
                "Process information is synchronized",
            );
        }

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

        my $InvalidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( Valid => 'invalid' );

        # Set previous ACLs on invalid.
        my $ACLList = $ACLObject->ACLList(
            ValidIDs => ['1'],
            UserID   => $TestUserID,
        );

        for my $Item ( sort keys %{$ACLList} ) {
            $ACLObject->ACLUpdate(
                ID      => $Item,
                Name    => $ACLList->{$Item},
                ValidID => $InvalidID,
                UserID  => $TestUserID,
            );
        }

        # Synchronize test ACLs.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");

        $Self->True(
            1,
            "ACL information is synchronized after update",
        );

        # Create test ACLs.
        my @ACLs = (
            {
                Name           => "100-ACL-$RandomID",
                Comment        => 'Disable test queues',
                Description    => 'Disable test queues',
                StopAfterMatch => 0,
                ConfigMatch    => '',
                ConfigChange   => {
                    PossibleNot => {
                        Ticket => {
                            Queue => [ $Queues[0]->{Name}, $Queues[1]->{Name}, $Queues[2]->{Name} ],
                        },
                    },
                },
            },
            {
                Name           => "200-ACL-$RandomID",
                Comment        => 'Enable queue for appropriate process',
                Description    => 'Enable queue for appropriate process',
                StopAfterMatch => 0,
                ConfigMatch    => {
                    Properties => {
                        Process => {
                            'ProcessEntityID' => [ $Process->{EntityID} ],
                        },
                    },
                },
                ConfigChange => {
                    PossibleAdd => {
                        Ticket => {
                            Queue => [ $Queues[0]->{Name} ],
                        },
                    },
                },
            },
            {
                Name           => "300-ACL-$RandomID",
                Comment        => 'Enable queue for appropriate (the first) activity',
                Description    => 'Enable queue for appropriate (the first) activity',
                StopAfterMatch => 0,
                ConfigMatch    => {
                    Properties => {
                        Process => {
                            'ActivityEntityID' => [ $Process->{Config}->{StartActivity} ],
                        },
                    },
                },
                ConfigChange => {
                    PossibleAdd => {
                        Ticket => {
                            Queue => [ $Queues[1]->{Name} ],
                        },
                    },
                },
            },
            {
                Name           => "400-ACL-$RandomID",
                Comment        => 'Enable queue for appropriate (the first) activity dialog',
                Description    => 'Enable queue for appropriate (the first) activity dialog',
                StopAfterMatch => 0,
                ConfigMatch    => {
                    Properties => {
                        Process => {
                            'ActivityDialogEntityID' => [ $Process->{Config}->{StartActivityDialog} ],
                        },
                    },
                },
                ConfigChange => {
                    PossibleAdd => {
                        Ticket => {
                            Queue => [ $Queues[2]->{Name} ],
                        },
                    },
                },
            },
        );

        for my $ACL (@ACLs) {

            my $ACLID = $ACLObject->ACLAdd(
                %{$ACL},
                ValidID => 1,
                UserID  => $TestUserID,
            );

            $Self->True(
                $ACLID,
                "ACLID $ACLID is created",
            );

            # Add ACLID to test ACL data.
            $ACL->{ACLID} = $ACLID;
        }

        # Navigate to AdminACL and synchronize ACL's.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # Click 'Deploy ACLs'.
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        # Verify ACL are
        for my $ACL (@ACLs) {
            $Self->True(
                $Selenium->find_element("//a[text()=\"$ACL->{Name}\"]")->is_displayed(),
                "ACLName '$ACL->{Name}' found on page.",
            );
        }

        # Navigate to agent ticket process directly via URL with pre-selected process and activity dialog.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketProcess;ID=$Process->{EntityID};ActivityDialogEntityID=$Process->{Config}->{StartActivityDialog}"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        # Verify all test queues exist for appropriate process, activity and activity dialog (see bug#14775).
        $Selenium->WaitFor( ElementExists => [ '#QueueID', 'css' ] );
        for my $Queue (@Queues) {
            $Self->True(
                $Selenium->execute_script("return \$('#QueueID option[value=\"$Queue->{ID}\"]').length;"),
                "QueueID $Queue->{ID} is found"
            );
        }

        # Set to invalid all test ACLs except the first one (which disables all test queues).
        ACL:
        for my $ACL (@ACLs) {

            # Do not invalidate the first ACL.
            next ACL if $ACL->{ACLID} == $ACLs[0]->{ACLID};

            my $Success = $ACLObject->ACLUpdate(
                ID             => $ACL->{ACLID},
                Name           => $ACL->{Name},
                ValidID        => $InvalidID,
                UserID         => $TestUserID,
                Comment        => $ACL->{Comment},
                Description    => $ACL->{Description},
                StopAfterMatch => $ACL->{StopAfterMatch},
                ConfigMatch    => $ACL->{ConfigMatch},
                ConfigChange   => $ACL->{ConfigChange},
            );
            $Self->True(
                $Success,
                "ACLID $ACL->{ACLID}, ACLName '$ACL->{Name}' is set to invalid"
            );
        }

        # Synchronize test ACLs.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");
        $Self->True(
            index(
                $Selenium->get_page_source(),
                'ACL information from database is not in sync with the system configuration, please deploy all ACLs.'
                )
                > -1,
            "ACL deployment successful."
        );
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Self->False(
            index(
                $Selenium->get_page_source(),
                'ACL information from database is not in sync with the system configuration, please deploy all ACLs.'
                )
                > -1,
            "ACL deployment successful."
        );

        # Navigate again to agent ticket process directly via URL with pre-selected process and activity dialog.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketProcess;ID=$Process->{EntityID};ActivityDialogEntityID=$Process->{Config}->{StartActivityDialog}"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        # Verify all test queues don't exist now.
        for my $Queue (@Queues) {
            $Self->True(
                $Selenium->execute_script("return !\$('#QueueID option[value=\"$Queue->{ID}\"]').length;"),
                "QueueID $Queue->{ID} is not found"
            );
        }

        # Cleanup.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success;

        # Clean up activities.
        my $ActivityObject       = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
        my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');

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

        # Clean up transition actions.
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

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Synchronize Process after deleting test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        $Self->True(
            1,
            "Process information is synchronized after removing '$Process->{Name}'",
        );

        # Cleanup ACL.
        for my $ACL (@ACLs) {

            # Delete test ACL.
            $Success = $ACLObject->ACLDelete(
                ID     => $ACL->{ACLID},
                UserID => $TestUserID,
            );
            $Self->True(
                $Success,
                "ACLID $ACL->{ACLID} is deleted",
            );
        }

        # Navigate to AdminACL to synchronize after test ACL cleanup.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # Click 'Deploy ACLs'.
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        $Self->True(
            1,
            "ACL information is synchronized after removing test ACLs",
        );

        # Delete test queues.
        for my $Queue (@Queues) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM queue WHERE id = ?",
                Bind => [ \$Queue->{ID} ],
            );
            $Self->True(
                $Success,
                "QueueID $Queue->{ID} is deleted",
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
            qw (ProcessManagement_Activity ProcessManagement_ActivityDialog ProcessManagement_Transition ProcessManagement_TransitionAction)
            )
        {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
