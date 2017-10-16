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

# Get Selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
        my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Get all processes.
        my $ProcessList = $ProcessObject->ProcessListGet(
            UserID => $TestUserID,
        );

        my @DeactivatedProcesses;
        my $ProcessName = "TestProcess";
        my $TestProcessExists;

        # If there had been some active processes before testing, set them to inactive.
        for my $Process ( @{$ProcessList} ) {
            if ( $Process->{State} eq 'Active' ) {
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

            # Check if test process already exists.
            if ( $Process->{Name} eq $ProcessName ) {
                $TestProcessExists = 1;
            }
        }

        # Login.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        my $Location;

        # Import test process if does not exist in the system.
        if ( !$TestProcessExists ) {
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
            $Location = $ConfigObject->Get('Home')
                . "/scripts/test/sample/ProcessManagement/TestProcess.yml";
            $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
            $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->VerifiedClick();
            $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")
                ->VerifiedClick();
            $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

            # We have to allow a 1 second delay for Apache2::Reload to pick up the changed process cache.
            sleep 1;
        }

        # Get process list.
        my $List = $ProcessObject->ProcessList(
            UseEntities => 1,
            UserID      => $TestUserID,
        );

        # Get process entity.
        my %ListReverse = reverse %{$List};

        my $Process = $ProcessObject->ProcessGet(
            EntityID => $ListReverse{$ProcessName},
            UserID   => $TestUserID,
        );

        # Navigate to AgentTicketProcess screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketProcess");

        # Select test process.
        $Selenium->execute_script(
            "\$('#ProcessEntityID').val('$ListReverse{$ProcessName}').trigger('redraw.InputField').trigger('change');"
        );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject").length' );

        # Hide DnDUpload and show input field.
        $Selenium->execute_script(
            "\$('.DnDUpload').css('display', 'none')"
        );
        $Selenium->execute_script(
            "\$('#FileUpload').css('display', 'block')"
        );

        # Add an attachment.
        $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1.txt";
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

        # Wait until attachment is uploaded, i.e. until it appears in the attachment list table.
        #   Additional check for opacity makes sure that animation has been completed.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".AttachmentListContainer tbody tr").filter(function() {
                    return $(this).css("opacity") == 1;
                }).length;'
        );

        # Check if uploaded.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.txt)').length;"
            ),
            1,
            "'Main-Test1.txt' - uploaded"
        );

        # Delete the attachment.
        $Selenium->execute_script(
            "\$('.AttachmentList tbody tr:contains(Main-Test1.txt)').find('a.AttachmentDelete').trigger('click')"
        );

        # Wait until attachment is deleted.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".fa.fa-spinner.fa-spin:visible").length === 0;'
        );

        # Submit.
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        my $Url = $Selenium->get_current_url();

        # Check if ticket is created (sent to AgentTicketZoom screen).
        $Self->True(
            $Url =~ /Action=AgentTicketZoom;TicketID=/,
            "Current URL is correct - AgentTicketZoom",
        );

        # Get test ticket ID.
        my @TicketZoomUrl = split( 'Action=AgentTicketZoom;TicketID=', $Url );
        my $TicketID = $TicketZoomUrl[1];

        my $TransitionObject        = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');
        my $ActivityObject          = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
        my $TransitionActionsObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
        my $ActivityDialogObject    = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');

        my $Success;

        # Clean up test activities.
        for my $Item ( @{ $Process->{Activities} } ) {
            my $Activity = $ActivityObject->ActivityGet(
                EntityID            => $Item,
                UserID              => $TestUserID,
                ActivityDialogNames => 0,
            );

            # Delete test activity dialogs.
            for my $ActivityDialogItem ( @{ $Activity->{ActivityDialogs} } ) {
                my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
                    EntityID => $ActivityDialogItem,
                    UserID   => $TestUserID,
                );
                $Success = $ActivityDialogObject->ActivityDialogDelete(
                    ID     => $ActivityDialog->{ID},
                    UserID => $TestUserID,
                );
                $Self->True(
                    $Success,
                    "ActivityDialog deleted - $ActivityDialog->{Name},",
                );
            }

            # Delete test activity.
            $Success = $ActivityObject->ActivityDelete(
                ID     => $Activity->{ID},
                UserID => $TestUserID,
            );
            $Self->True(
                $Success,
                "Activity deleted - $Activity->{Name},",
            );
        }

        # Clean up transition actions.
        for my $Item ( @{ $Process->{TransitionActions} } ) {
            my $TransitionAction = $TransitionActionsObject->TransitionActionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );
            $Success = $TransitionActionsObject->TransitionActionDelete(
                ID     => $TransitionAction->{ID},
                UserID => $TestUserID,
            );
            $Self->True(
                $Success,
                "TransitionAction deleted - $TransitionAction->{Name},",
            );
        }

        # Clean up transition.
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
                "Transition deleted - $Transition->{Name},",
            );
        }

        # Delete test process.
        $Success = $ProcessObject->ProcessDelete(
            ID     => $Process->{ID},
            UserID => $TestUserID,
        );

        $Self->True(
            $Success,
            "Process deleted - $Process->{Name},",
        );

        # Delete test ticket.
        $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Delete ticket - $TicketID"
        );

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
            qw (ProcessManagement_Activity ProcessManagement_ActivityDialog ProcessManagement_Transition ProcessManagement_TransitionAction Ticket)
            )
        {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
