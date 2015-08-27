# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use Data::Dumper;

use vars (qw($Self));

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject            = $Kernel::OM->Get('Kernel::Config');
my $ProcessObject           = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
my $TransitionObject        = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');
my $ActivityObject          = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
my $TransitionActionsObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
my $ActivityDialogObject    = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');

# get selenium object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Selenium' => {
        Verbose => 1,
        }
);
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 1,
        );

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # do not check RichText, service and type
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # import test selenium process scenario
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/ProcessManagement/TestProcess.yml";
        $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
        $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->click();
        $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")->click();
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->click();

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

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

        # navigate to agent ticket process
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketProcess");

        # create first scenario for test agent ticket process
        $Selenium->execute_script(
            "\$('#ProcessEntityID').val('$ListReverse{$ProcessName}').trigger('redraw.InputField').trigger('change');");

        # wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return $("#Subject").length;' );

        my $SubjectRandom = 'Subject' . $Helper->GetRandomID();
        my $ContentRandom = 'Content' . $Helper->GetRandomID();
        $Selenium->find_element( "#Subject",  'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($ContentRandom);
        $Selenium->execute_script("\$('#QueueID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject", 'css' )->submit();

        # check for inputed values for first step in test process ticket
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

        # click on next step in process ticket
        $Selenium->find_element("//a[contains(\@href, \'ProcessEntityID=$ListReverse{$ProcessName}' )]")->click();
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return $("#Subject").length;' );

        # for test scenario to complete, in next step we set ticket priority to 5 very high
        $Selenium->execute_script("\$('#PriorityID').val('5').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject", 'css' )->submit();

        # return to main window
        $Selenium->switch_to_window( $Handles->[0] );

        # wait until main window has been reloaded
        sleep 1;

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

        # create second scenarion for test agent ticket process
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketProcess");
        $Selenium->execute_script(
            "\$('#ProcessEntityID').val('$ListReverse{$ProcessName}').trigger('redraw.InputField').trigger('change');");

        # wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return $("#Subject").length;' );

        # in this scenarion we just set ticket queue to junk to finish test
        $Selenium->execute_script("\$('#QueueID').val('3').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject", 'css' )->submit();

        # wait until return to AgentTicketZoom, if neccessary
        $Selenium->WaitFor( JavaScript => 'return $("#ArticleTree").length;' );

        # check if we are at the end of test process ticket
        $Self->True(
            index( $Selenium->get_page_source(), 'Junk' ) > -1,
            "Queue Junk found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $EndProcessMessage ) > -1,
            "$EndProcessMessage message found on page",
        );

        # clean up test data
        my @TicketID = split( 'TicketID=', $Selenium->get_current_url() );

        # delete test process ticket
        my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
            TicketID => $TicketID[1],
            UserID   => $TestUserID,
        );

        $Self->True(
            $Success,
            "Process ticket is deleted - $TicketID[1]",
        );

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

        # synchronize process after deleting test process
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminProcessManagement");
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->click();

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
