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

use vars (qw($Self));

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

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
        my $ProcessRandom        = 'Process' . $Helper->GetRandomID();
        my $ActivityDialogRandom = 'ActivityDialog' . $Helper->GetRandomID();
        my $ScriptAlias          = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        my $DescriptionShort     = "Selenium ActivityDialog Test";

        # go to AdminProcessManagement screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # create new test Process
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessNew' )]")->click();
        $Selenium->find_element( "#Name",        'css' )->send_keys($ProcessRandom);
        $Selenium->find_element( "#Description", 'css' )->send_keys("Selenium Test Process");
        $Selenium->find_element( "#Name",        'css' )->submit();

        # click on ActivityDialog dropdown and "Create New Activity Dialog"
        $Selenium->find_element( "Activity Dialogs", 'link_text' )->click();
        sleep 1;
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityDialogNew' )]")->click();

        # switch to pop up window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check AdminProcessManagementActivityDialog screen
        for my $ID (
            qw(Name Interface DescriptionShort DescriptionLong Permission RequiredLock SubmitAdviceText
            SubmitButtonText FilterAvailableFields AvailableFields AssignedFields Submit)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element( "#Name", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # input fields and submit
        $Selenium->find_element( "#Name",                                     'css' )->send_keys($ActivityDialogRandom);
        $Selenium->find_element( "#DescriptionShort",                         'css' )->send_keys($DescriptionShort);
        $Selenium->find_element( "#Interface option[value='BothInterfaces']", 'css' )->click();
        $Selenium->find_element( "#Permission option[value='rw']",            'css' )->click();
        $Selenium->find_element( "#Name",                                     'css' )->submit();

        # switch back to main window
        $Selenium->switch_to_window( $Handles->[0] );

        # check for created test activity dialog using filter on AdminProcessManagement screen
        $Selenium->find_element( "Activity Dialogs", 'link_text' )->click();
        sleep 1;
        $Selenium->find_element( "#ActivityDialogFilter", 'css' )->send_keys($ActivityDialogRandom);
        sleep 1;

        $Self->True(
            $Selenium->find_element("//*[text()=\"$ActivityDialogRandom\"]")->is_displayed(),
            "$ActivityDialogRandom activity found on page",
        );

        # get test ActivityDialogID
        my $DBObject             = $Kernel::OM->Get('Kernel::System::DB');
        my $ActivityDialogQuoted = $DBObject->Quote($ActivityDialogRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM pm_activity_dialog WHERE name = ?",
            Bind => [ \$ActivityDialogQuoted ]
        );
        my $ActivityDialogID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ActivityDialogID = $Row[0];
        }

        # go to edit test ActivityDialog screen
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityDialogEdit;ID=$ActivityDialogID' )]")
            ->click();
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check stored value
        $Self->Is(
            $Selenium->find_element( "#Name", 'css' )->get_value(),
            $ActivityDialogRandom,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( "#DescriptionShort", 'css' )->get_value(),
            $DescriptionShort,
            "#DescriptionShort stored value",
        );
        $Self->Is(
            $Selenium->find_element( "#Interface", 'css' )->get_value(),
            "BothInterfaces",
            "#Interface stored value",
        );
        $Self->Is(
            $Selenium->find_element( "#Permission", 'css' )->get_value(),
            "rw",
            "#Permission stored value",
        );

        # edit test ActivityDialog values
        $Selenium->find_element( "#Name",                                     'css' )->send_keys("edit");
        $Selenium->find_element( "#DescriptionShort",                         'css' )->send_keys(" Edit");
        $Selenium->find_element( "#Interface option[value='AgentInterface']", 'css' )->click();
        $Selenium->find_element( "#Permission option[value='ro']",            'css' )->click();
        $Selenium->find_element( "#Name",                                     'css' )->submit();

        # return to main window
        $Selenium->switch_to_window( $Handles->[0] );

        # check for edited test ActivityDialog using filter on AdminProcessManagement screen
        my $ActivityDialogRandomEdit = $ActivityDialogRandom . "edit";
        my $DescriptionShortEdit     = $DescriptionShort . " Edit";
        $Selenium->find_element( "Activity Dialogs", 'link_text' )->click();
        sleep 1;
        $Selenium->find_element( "#ActivityDialogFilter", 'css' )->send_keys($ActivityDialogRandomEdit);
        sleep 1;

        $Self->True(
            $Selenium->find_element("//*[text()=\"$ActivityDialogRandomEdit\"]")->is_displayed(),
            "Edited $ActivityDialogRandomEdit activity dialog found on page",
        );

        # go to edit test ActivityDialog screen again
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityDialogEdit;ID=$ActivityDialogID' )]")
            ->click();
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check edited values
        $Self->Is(
            $Selenium->find_element( "#Name", 'css' )->get_value(),
            $ActivityDialogRandomEdit,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( "#DescriptionShort", 'css' )->get_value(),
            $DescriptionShortEdit,
            "#DescriptionShort updated value",
        );
        $Self->Is(
            $Selenium->find_element( "#Interface", 'css' )->get_value(),
            "AgentInterface",
            "#Interface updated value",
        );
        $Self->Is(
            $Selenium->find_element( "#Permission", 'css' )->get_value(),
            "ro",
            "#Permission updated value",
        );

        # return to main window
        $Selenium->switch_to_window( $Handles->[0] );

        # get process id and return to overview afterwards
        my $ProcessID = $Selenium->execute_script('return $("#ProcessDelete").data("id")') || undef;
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # delete test ActivityDialog
        my $Success = $DBObject->Do(
            SQL => "DELETE FROM pm_activity_dialog WHERE id = $ActivityDialogID",
        );
        $Self->True(
            $Success,
            "ActivityDialogDelete - $ActivityDialogRandomEdit",
        );

        # delete process
        my $Delete = $DBObject->Do(
            SQL => "DELETE FROM pm_process WHERE id = $ProcessID",
        );

        $Self->True(
            $Delete,
            "Successfully deleted test process.",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'ProcessManagement_ActivityDialog',
        );

    }

);

1;
