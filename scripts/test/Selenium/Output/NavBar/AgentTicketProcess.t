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

# get process needed objects
my $ProcessObject           = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
my $TransitionObject        = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');
my $ActivityObject          = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
my $TransitionActionsObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
my $ActivityDialogObject    = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');

        # import test selenium process
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/ProcessManagement/TestProcess.yml";
        $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
        $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->VerifiedClick();
        $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")->VerifiedClick();

        # synchronize process
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # we have to allow a 1 second delay for Apache2::Reload to pick up the changed process cache
        sleep 1;

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

        # check if NavBarAgentTicketProcess button is available when process is available
        $Selenium->VerifiedRefresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketProcess' ) > -1,
            "NavBar 'New process ticket' button available",
        );

        # clean up activities
        my $Success;
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
                $Success = $ActivityDialogObject->ActivityDialogDelete(
                    ID     => $ActivityDialog->{ID},
                    UserID => $TestUserID,
                );
                $Self->True(
                    $Success,
                    "ActivityDialog deleted - $ActivityDialog->{Name},",
                );
            }

            # delete test activity
            $Success = $ActivityObject->ActivityDelete(
                ID     => $Activity->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "Activity deleted - $Activity->{Name},",
            );
        }

        # clean up transition actions
        for my $Item ( @{ $Process->{TransitionActions} } ) {
            my $TransitionAction = $TransitionActionsObject->TransitionActionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # delete test transition action
            $Success = $TransitionActionsObject->TransitionActionDelete(
                ID     => $TransitionAction->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "TransitionAction deleted - $TransitionAction->{Name},",
            );
        }

        # clean up transition
        for my $Item ( @{ $Process->{Transitions} } ) {
            my $Transition = $TransitionObject->TransitionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # delete test transition
            $Success = $TransitionObject->TransitionDelete(
                ID     => $Transition->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "Transition deleted - $Transition->{Name},",
            );
        }

        # delete test process
        $Success = $ProcessObject->ProcessDelete(
            ID     => $Process->{ID},
            UserID => $TestUserID,
        );

        $Self->True(
            $Success,
            "Process deleted - $Process->{Name},",
        );

        # get all processes
        my $ProcessList = $ProcessObject->ProcessListGet(
            UserID => $TestUserID,
        );
        my @DeactivatedProcesses;

        # if there had been some active processes before testing,set them to inactive,
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

                # save process because of restoring on the end of test
                push @DeactivatedProcesses, $Process;
            }
        }

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # we have to allow a 1 second delay for Apache2::Reload to pick up the changed process cache
        sleep 2;

        # check if NavBarAgentTicketProcess button is not available when no process is available
        $Selenium->VerifiedRefresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketProcess' ) == -1,
            "'New process ticket' button NOT available when no process is active when no process is available",
        ) || die;

        # check if NavBarAgentTicketProcess button is available
        # when NavBarAgentTicketProcess module is disabled and no process is available
        my %NavBarAgentTicketProcess = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemGet(
            Name => 'Frontend::NavBarModule###1-TicketProcesses',
        );
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'Frontend::NavBarModule###1-TicketProcesses',
            Value => \%NavBarAgentTicketProcess,
        );

        $Selenium->VerifiedRefresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketProcess' ) > -1,
            "'New process ticket' button IS available when no process is active, but NavBarAgentTicketProcess is disabled",
        );

        # restore state of process
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

        # synchronize process after deleting test process
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # make sure the cache is correct.
        for my $Cache (
            qw (ProcessManagement_Activity ProcessManagement_ActivityDialog ProcessManagement_Transition ProcessManagement_TransitionAction )
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
