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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                DisableAsyncCalls => 1,
            },
        );
        my $Helper      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "Calendar-group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            'Test group created',
        );

        # Create test queue.
        my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => "Queue$RandomID",
            ValidID         => 1,
            GroupID         => $GroupID,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Some comment',
            UserID          => 1,
        );
        $Self->True(
            $QueueID,
            'Test queue created',
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Change resolution (desktop mode).
        $Selenium->set_window_size( 768, 1050 );

        # Create test user.
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', $GroupName ],
            Language => $Language,
        ) || die 'Did not get test user';

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Open AdminAppointmentCalendarManage page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAppointmentCalendarManage");

        # Add new calendar.
        my $CalendarName1 = "Calendar $RandomID 1";
        my $CalendarName2 = "Calendar $RandomID 2";
        $Selenium->find_element( '.SidebarColumn ul.ActionList a#Add',   'css' )->VerifiedClick();
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->send_keys($CalendarName1);
        $Selenium->execute_script(
            "return \$('#GroupID').val($GroupID).trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        # Let's try to add calendar with same name.
        $Selenium->find_element( '.SidebarColumn ul.ActionList a#Add',   'css' )->VerifiedClick();
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->send_keys($CalendarName1);
        $Selenium->execute_script(
            "return \$('#GroupID').val($GroupID).trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('div.Dialog button#DialogButton1').length"
        );
        $Selenium->find_element( 'div.Dialog button#DialogButton1', 'css' )->VerifiedClick();

        # Update calendar name
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->VerifiedClick();
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->clear();
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->send_keys($CalendarName2);

        # Set it to invalid.
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");

        # Add ticket appointment rule.
        $Selenium->find_element( '.WidgetSimple.Collapsed .WidgetAction.Toggle a', 'css' )->VerifiedClick();
        $Selenium->find_element( '#AddRuleButton',                                 'css' )->VerifiedClick();
        $Selenium->execute_script(
            "return \$('#QueueID_1').val('$QueueID').trigger('redraw.InputField').trigger('change');"
        );

        # Add title as search parameter.
        $Selenium->execute_script(
            "return \$('#SearchParams').val('Title').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( '.AddButton',                      'css' )->VerifiedClick();
        $Selenium->find_element( '#SearchParam_1_Title',            'css' )->send_keys('Test*');
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        # Filter added calendars.
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->send_keys($RandomID);

        sleep 1;

        # Verify two calendars are shown.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.ContentColumn table tbody tr:visible').length;"
            ),
            2,
            'All calendars are displayed',
        );

        # Filter just added calendar.
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->clear();
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->send_keys($CalendarName2);
        sleep 1;

        # Verify only one calendar is shown.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.ContentColumn table tbody tr:visible').length;"
            ),
            1,
            'Calendars are filtered correctly',
        );

        # Verify the calendar is invalid.
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        $Self->Is(
            $Selenium->execute_script("return \$('tbody tr:visible:eq(0) td:eq(3)').text()"),
            $LanguageObject->Translate('invalid'),
            'Calendar is marked invalid',
        );

        # Edit invalid calendar.
        $Selenium->find_element( $CalendarName2, 'link_text' )->VerifiedClick();

        # Set it to invalid-temporarily.
        $Selenium->execute_script(
            "return \$('#ValidID').val(3).trigger('redraw.InputField').trigger('change');"
        );

        # Verify rule has been stored properly.
        $Self->IsDeeply(
            $Selenium->execute_script(
                "return \$('select[id*=\"QueueID_\"]').val();"
            ),
            [$QueueID],
            'Queue stored properly',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('input[id*=\"_Title\"]').val();"
            ),
            'Test*',
            'Search param stored properly',
        );

        # Remove the rule.
        $Selenium->find_element( '.RemoveButton',                   'css' )->VerifiedClick();
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        # Verify the calendar is invalid temporarily.
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->clear();
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->send_keys($CalendarName2);
        sleep 1;
        $Self->Is(
            $Selenium->execute_script("return \$('tbody tr:visible:eq(0) td:eq(3)').text()"),,
            $LanguageObject->Translate('invalid-temporarily'),
            'Calendar is marked invalid temporarily',
        );

        #
        # Cleanup
        #

        my $DBObject          = $Kernel::OM->Get('Kernel::System::DB');
        my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
        my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

        # Delete test calendars.
        my $Success = $DBObject->Do(
            SQL  => 'DELETE FROM calendar WHERE name = ? OR name = ?',
            Bind => [ \$CalendarName1, \$CalendarName2, ],
        );

        # Check if the calendars are deleted.
        for my $CalendarName ( $CalendarName1, $CalendarName2 ) {

            my %Calendar = $CalendarObject->CalendarGet(
                CalendarName => $CalendarName,
            );

            $Self->True(
                $Success,
                'Deleted test calendar - $CalendarName',
            ) || die("Calendar is not deleted successfully - $CalendarName");
        }

        # Delete test queue.
        $Success = $DBObject->Do(
            SQL  => 'DELETE FROM queue WHERE id = ?',
            Bind => [ \$QueueID, ],
        );
        $Self->True(
            $Success,
            "Deleted test queue - $QueueID",
        );

        # Delete group-user relations.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM group_user WHERE group_id = $GroupID",
        );
        $Self->True(
            $Success,
            "GroupUserDelete - $GroupName",
        );

        # Delete test group.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM groups WHERE name = ?",
            Bind => [ \$GroupName ],
        );
        $Self->True(
            $Success,
            "Deleted test group - $GroupID"
        );

        # Make sure cache is correct.
        for my $Cache (qw(Calendar Queue)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }
    },
);

1;
