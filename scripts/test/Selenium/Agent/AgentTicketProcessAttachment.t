# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

# Get Selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
        my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

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
        }

        # Login.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Import test process if does not exist in the system.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#OverwriteExistingEntitiesImport').length;"
        );

        # Import test Selenium Process.
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/ProcessManagement/TestProcess.yml";
        $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
        $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return !\$('#OverwriteExistingEntitiesImport:checked').length;"
        );
        $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")->VerifiedClick();
        sleep 1;
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # We have to allow a 1 second delay for Apache2::Reload to pick up the changed Process cache.
        sleep 1;

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

        # Navigate to AdminACL and synchronize ACL's.
        if ( IsHashRefWithData($ACLList) ) {
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");
            $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();
        }

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
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#AttachmentDeleteButton1").length === 1;'
        );

        # Check if uploaded.
        $Self->True(
            index(
                $Selenium->execute_script("return \$('#AttachmentDeleteButton1').closest('li').text().trim()"),
                'Main-Test1.txt'
            ) > -1,
            "'Main-Test1.txt' - uploaded"
        );

        # Submit.
        $Selenium->find_element("//button[\@type='submit']")->click();

        # Wait until 'Error' class appears in Subject element.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#Subject.Error").length;'
        );

        # Check if validation error is on the screen.
        $Self->True(
            $Selenium->execute_script("return \$('#Subject.Error').length"),
            "Validation is executed",
        );

        $Selenium->find_element( "#Subject",  'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Test');

        # Submit.
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".TicketZoom").length;'
        );

        my $Url = $Selenium->get_current_url();

        # Check if ticket is created (sent to AgentTicketZoom screen).
        $Self->True(
            index( $Url, 'Action=AgentTicketZoom;TicketID=' ) > -1,
            "Current URL is correct - AgentTicketZoom",
        );

        # Get test ticket ID.
        my @TicketZoomUrl = split( 'Action=AgentTicketZoom;TicketID=', $Url );
        my $TicketID      = $TicketZoomUrl[1];

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

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Delete test ticket.
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
        }
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
