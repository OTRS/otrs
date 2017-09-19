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
        my $ProcessRandom    = 'Process' . $Helper->GetRandomID();
        my $TransitionRandom = 'Transition' . $Helper->GetRandomID();

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to AdminProcessManagement screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # create new test Process
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessNew' )]")->VerifiedClick();
        $Selenium->find_element( "#Name",        'css' )->send_keys($ProcessRandom);
        $Selenium->find_element( "#Description", 'css' )->send_keys("Selenium Test Process");
        $Selenium->find_element( "#Submit",      'css' )->VerifiedClick();

        # click on Transitions dropdown
        $Selenium->find_element( "Transitions", 'link_text' )->VerifiedClick();

        # wait to toggle element
        sleep 1;

        # click on "Create New Transition"
        $Selenium->find_element("//a[contains(\@href, \'Subaction=TransitionNew' )]")->VerifiedClick();

        # switch to pop up window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until form has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

        # check AdminProcessManagementTransition screen
        for my $ID (
            qw(Name OverallConditionLinking ConditionLinking[_INDEX_] ConditionFieldName[1][1]
            ConditionFieldType[_INDEX_][_FIELDINDEX_] ConditionFieldValue[1][1] ConditionAdd)
            )
        {
            my $Element = $Selenium->find_element(".//*[\@id='$ID']");
            $Element->is_enabled();
            $Element->is_displayed();
        }

        for my $Button (
            qw(RemoveButton ConditionFieldAdd RemoveButton)
            )
        {
            my $Element = $Selenium->find_element( ".$Button", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        $Selenium->find_element( "#Name",   'css' )->clear();
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # input fields and submit
        my $TransitionFieldName = "Field" . $Helper->GetRandomID();
        my $TransitionValueName = "Value" . $Helper->GetRandomID();
        $Selenium->find_element( "#Name", 'css' )->send_keys($TransitionRandom);
        $Selenium->execute_script(
            "\$('#OverallConditionLinking').val('or').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script(
            "\$('#ConditionLinking[_INDEX_]').val('or').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element(".//*[\@id='ConditionFieldName[1][1]']")->send_keys($TransitionFieldName);
        $Selenium->execute_script(
            "\$('#ConditionLinking[_INDEX_]').val('String').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][1]']")->send_keys($TransitionValueName);
        $Selenium->find_element( "#Submit", 'css' )->click();

        # switch back to main window
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        sleep 1;

        # check for created test Transition using filter on AdminProcessManagement screen
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('ul#Transitions li:contains($TransitionRandom)').length"
        );
        $Selenium->find_element( "Transitions",       'link_text' )->VerifiedClick();
        $Selenium->find_element( "#TransitionFilter", 'css' )->send_keys($TransitionRandom);

        # wait for filter to kick in
        sleep 1;

        $Self->True(
            $Selenium->find_element("//*[text()=\"$TransitionRandom\"]")->is_displayed(),
            "$TransitionRandom transition found on page",
        );

        # get test TransitionID
        my $DBObject         = $Kernel::OM->Get('Kernel::System::DB');
        my $TransitionQuoted = $DBObject->Quote($TransitionRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM pm_transition WHERE name = ?",
            Bind => [ \$TransitionQuoted ]
        );
        my $TransitionID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TransitionID = $Row[0];
        }

        # go to edit test Transition screen
        $Selenium->find_element("//a[contains(\@href, \'Subaction=TransitionEdit;ID=$TransitionID' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name').length" );

        # check stored value
        $Self->Is(
            $Selenium->find_element( "#Name", 'css' )->get_value(),
            $TransitionRandom,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( "#OverallConditionLinking option[value='or']", 'css' )->get_value(),
            "or",
            "#OverallConditionLinking stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionLinking[_INDEX_]']/option[2]")->get_value(),
            "or",
            "ConditionLinking stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionFieldName[1][$TransitionFieldName]']")->get_value(),
            $TransitionFieldName,
            "ConditionFieldName stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionFieldType[1][$TransitionFieldName]']/option[4]")->get_value(),
            "String",
            "ConditionFieldType stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][$TransitionFieldName]']")->get_value(),
            $TransitionValueName,
            "ConditionFieldValue stored value",
        );

        # edit test Transition values
        my $TransitionFieldNameEdit = $TransitionFieldName . "edit";
        my $TransitionValueNameEdit = $TransitionValueName . "edit";

        $Selenium->find_element( "#Name", 'css' )->send_keys("edit");
        $Selenium->execute_script(
            "\$('#OverallConditionLinking').val('and').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element(".//*[\@id='ConditionFieldName[1][$TransitionFieldName]']")->clear();
        $Selenium->find_element(".//*[\@id='ConditionFieldName[1][$TransitionFieldName]']")
            ->send_keys($TransitionFieldNameEdit);
        $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][$TransitionFieldName]']")->clear();
        $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][$TransitionFieldName]']")
            ->send_keys($TransitionValueNameEdit);
        $Selenium->find_element( "#Submit", 'css' )->click();

        # return to main window
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        sleep 1;

        # check for edited test Transition using filter on AdminProcessManagement screen
        my $TransitionRandomEdit = $TransitionRandom . "edit";
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#TransitionFilter").length' );
        $Selenium->find_element( "Transitions",       'link_text' )->VerifiedClick();
        $Selenium->find_element( "#TransitionFilter", 'css' )->send_keys($TransitionRandomEdit);

        # wait for filter to kick in
        sleep 1;

        $Self->True(
            $Selenium->find_element("//*[text()=\"$TransitionRandomEdit\"]")->is_displayed(),
            "Edited $TransitionRandomEdit transition found on page",
        );

        # go to edit test ActivityDialog screen again
        $Selenium->find_element("//a[contains(\@href, \'Subaction=TransitionEdit;ID=$TransitionID' )]")
            ->VerifiedClick();
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name').length" );

        # check edited values
        $Self->Is(
            $Selenium->find_element( "#Name", 'css' )->get_value(),
            $TransitionRandomEdit,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( "#OverallConditionLinking option[value='and']", 'css' )->get_value(),
            "and",
            "#OverallConditionLinking updated value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionFieldName[1][$TransitionFieldNameEdit]']")->get_value(),
            $TransitionFieldNameEdit,
            "ConditionFieldName updated value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][$TransitionFieldNameEdit]']")->get_value(),
            $TransitionValueNameEdit,
            "ConditionFieldValue updated value",
        );

        # return to main window
        $Selenium->close();
        $Selenium->switch_to_window( $Handles->[0] );

        # get process id and return to overview afterwards
        my $ProcessID = $Selenium->execute_script('return $("#ProcessDelete").data("id")') || undef;

        # delete test transition
        my $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition')->TransitionDelete(
            ID     => $TransitionID,
            UserID => $TestUserID,
        );

        $Self->True(
            $Success,
            "Transition is deleted - $TransitionID",
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

        # navigate to AdminProcessManagement screen again
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # synchronize process after deleting test process
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # make sure cache is correct
        for my $Cache (
            qw( ProcessManagement_Process ProcessManagement_Transition  )
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }

    }

);

1;
