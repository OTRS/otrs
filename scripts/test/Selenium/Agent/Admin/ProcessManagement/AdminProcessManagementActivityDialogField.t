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

        # Create test user.
        my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
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

        my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');
        my $ActivityDialogData   = $ActivityDialogObject->ActivityDialogGet(
            EntityID => $Process->{Config}->{StartActivityDialog},
            UserID   => $TestUserID,
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
        $Selenium->find_element( "TestProcess", 'link_text' )->VerifiedClick();

        # Click on ActivityDialog dropdown.
        $Selenium->find_element( "Activity Dialogs", 'link_text' )->click();

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a.AsBlock:contains(\"Activity Dialogs\")').closest('.AccordionElement').hasClass('Active') === true;"
        );

        $Selenium->find_element( "#ActivityDialogFilter", 'css' )->send_keys('Make order');
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ActivityDialogs li:visible').length;"
        );

        # Go to edit test ActivityDialog screen.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityDialogEdit;ID=$ActivityDialogData->{ID}' )]")
            ->click();
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "a[data-id=Article]",
        );

        $Selenium->execute_script(
            "\$('a[data-id=Article]')[0].scrollIntoView(true);",
        );

        $Selenium->execute_script("\$('a[data-id=Article]').click();");

        $Selenium->WaitFor( JavaScript => "return \$('.Dialog.Modal').length;" );

        # Check if there is field name in header of edit dialog for field of an activity dialog.
        # See bug#14667 for more information.
        $Self->Is(
            $Selenium->execute_script("return \$('.Dialog.Modal h1').text().trim();"),
            'Edit Field Details: Article',
            'There is field name in header of edit dialog.',
        );

        # Clean up activities.
        my $ActivityObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
        my $Success;

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

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Synchronize Process after deleting test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

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
