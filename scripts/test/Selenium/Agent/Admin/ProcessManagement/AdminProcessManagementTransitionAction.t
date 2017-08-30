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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
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

        # define needed variables
        my $ProcessRandom          = 'Process' . $Helper->GetRandomID();
        my $TransitionActionRandom = 'TransitionAction' . $Helper->GetRandomID();

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminProcessManagement screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # create new test Process
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessNew' )]")->VerifiedClick();
        $Selenium->find_element( "#Name",        'css' )->send_keys($ProcessRandom);
        $Selenium->find_element( "#Description", 'css' )->send_keys("Selenium Test Process");
        $Selenium->find_element( "#Name",        'css' )->VerifiedSubmit();

        # click on Transition Actions dropdown
        $Selenium->find_element( "Transition Actions", 'link_text' )->VerifiedClick();

        # wait to toggle element
        sleep 1;

        # click "Create New Transition Action"
        $Selenium->find_element("//a[contains(\@href, \'Subaction=TransitionActionNew' )]")->VerifiedClick();

        # switch to pop up window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until form has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

        # check AdminProcessManagementTransitionAction screen
        for my $ID (
            qw(Name Module ConfigKey[1] ConfigValue[1] ConfigAdd Submit)
            )
        {
            my $Element = $Selenium->find_element(".//*[\@id='$ID']");
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # input fields and submit
        my $TransitionActionModule = "Kernel::System::ProcessManagement::TransitionAction::TicketArticleCreate";
        my $TransitionActionKey    = "Key" . $Helper->GetRandomID();
        my $TransitionActionValue  = "Value" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name", 'css' )->send_keys($TransitionActionRandom);
        $Selenium->execute_script(
            "\$('#Module').val('$TransitionActionModule').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->send_keys($TransitionActionKey);
        $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->send_keys($TransitionActionValue);
        $Selenium->find_element( "#Name", 'css' )->submit();

        # switch back to main window
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        sleep 2;

        # check for created test TransitionAction using filter on AdminProcessManagement screen
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('ul#TransitionActions li:contains($TransitionActionRandom)').length"
        );
        $Selenium->find_element( "Transition Actions",      'link_text' )->VerifiedClick();
        $Selenium->find_element( "#TransitionActionFilter", 'css' )->send_keys($TransitionActionRandom);

        # Wait for filter to kick in.
        sleep 1;

        $Self->True(
            $Selenium->find_element("//*[text()=\"$TransitionActionRandom\"]")->is_displayed(),
            "$TransitionActionRandom transition action found on page",
        );

        # get test TransitionActionID
        my $DBObject               = $Kernel::OM->Get('Kernel::System::DB');
        my $TransitionActionQuoted = $DBObject->Quote($TransitionActionRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM pm_transition_action WHERE name = ?",
            Bind => [ \$TransitionActionQuoted ]
        );
        my $TransitionActionID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TransitionActionID = $Row[0];
        }

        # go to edit test TransitionAction screen
        $Selenium->find_element("//a[contains(\@href, \'Subaction=TransitionActionEdit;ID=$TransitionActionID' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until form has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

        # check stored value
        $Self->Is(
            $Selenium->find_element( "#Name", 'css' )->get_value(),
            $TransitionActionRandom,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( "#Module option[value='$TransitionActionModule']", 'css' )->get_value(),
            $TransitionActionModule,
            "#Module stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->get_value(),
            $TransitionActionKey,
            "ConfigKey stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->get_value(),
            $TransitionActionValue,
            "ConfigValue stored value",
        );

        # try to remove only possible Config Parameters
        $Selenium->find_element( ".RemoveButton", 'css' )->click();
        $Self->True(
            $Selenium->accept_alert(),
            "Unable to remove only field - JS is success"
        );

        # add new Config key and value
        $Selenium->find_element( "#ConfigAdd", 'css' )->click();

        # verify newly added fields
        $Self->True(
            $Selenium->find_element(".//*[\@id='ConfigKey[2]']"),
            "New Config key field is added - JS is success"
        );
        $Self->True(
            $Selenium->find_element(".//*[\@id='ConfigValue[2]']"),
            "New Config value field is added - JS is success"
        );

        # remove new Config key and value fields
        $Self->True(
            $Selenium->execute_script(
                "return \$(\$('#ConfigParams').find('fieldset')[1]).find('.RemoveButton').click()"
            ),
            "New Config key and value fields are removed - JS is success"
        );

        # edit test TransactionAction values
        my $TransitionActionKeyEdit   = $TransitionActionKey . "edit";
        my $TransitionActionValueEdit = $TransitionActionValue . "edit";
        $Selenium->find_element( "#Name", 'css' )->send_keys("edit");
        $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->clear();
        $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->send_keys($TransitionActionKeyEdit);
        $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->clear();
        $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->send_keys($TransitionActionValueEdit);
        $Selenium->find_element( "#Name", 'css' )->submit();

        # return to main window after the popup closed, as the popup sends commands to the main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        sleep 2;

        # check for edited test TransitionAction using filter on AdminProcessManagement screen
        my $TransitionActionRandomEdit = $TransitionActionRandom . "edit";
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#TransitionActionFilter').length" );
        $Selenium->find_element( "Transition Actions", 'link_text' )->VerifiedClick();

        $Selenium->find_element( "#TransitionActionFilter", 'css' )->send_keys($TransitionActionRandomEdit);

        # Wait for filter to kick in.
        sleep 1;

        $Self->True(
            $Selenium->find_element("//*[text()=\"$TransitionActionRandomEdit\"]")->is_displayed(),
            "Edited $TransitionActionRandomEdit transition action dialog found on page",
        );

        # go to edit test TransitionAction screen again
        $Selenium->find_element("//a[contains(\@href, \'Subaction=TransitionActionEdit;ID=$TransitionActionID' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until form has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

        # check edited values
        $Self->Is(
            $Selenium->find_element( "#Name", 'css' )->get_value(),
            $TransitionActionRandomEdit,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->get_value(),
            $TransitionActionKeyEdit,
            "ConfigKey updated value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->get_value(),
            $TransitionActionValueEdit,
            "ConfigValue updated value",
        );

        # return to main window
        $Selenium->close();
        $Selenium->switch_to_window( $Handles->[0] );

        # get process id and return to overview afterwards
        my $ProcessID = $Selenium->execute_script('return $("#ProcessDelete").data("id")') || undef;

        # delete test transition action
        my $Success
            = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction')->TransitionActionDelete(
            ID     => $TransitionActionID,
            UserID => $TestUserID,
            );

        $Self->True(
            $Success,
            "Transition action is deleted - $TransitionActionID",
        );

        # delete test process
        $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessDelete(
            ID     => $ProcessID,
            UserID => $TestUserID,
        );

        $Self->True(
            $Success,
            "Process is deleted - $ProcessID",
        );

        # navigate to AdminProcessmanagement screen again
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # synchronize process after deleting test process
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # make sure cache is correct
        for my $Cache (
            qw( ProcessManagement_Process ProcessManagement_TransitionAction )
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }

    }
);

1;
