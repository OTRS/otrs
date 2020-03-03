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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        DisableAsyncCalls => 1,
    },
);

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {
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
        $Selenium->InputFieldValueSet(
            Element => '#GroupID',
            Value   => $GroupID,
        );
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        # Verify download and copy-to-clipboard links.
        for my $Class (qw(DownloadLink CopyToClipboard)) {

            my $Attr;
            if ( $Class eq 'DownloadLink' ) {
                $Attr = 'href';
            }
            elsif ( $Class eq 'CopyToClipboard' ) {
                $Attr = 'data-clipboard-text';
            }

            my $URL = $Selenium->execute_script("return \$('.$Class').attr('$Attr');");

            $Self->True(
                $URL,
                "$Class URL present"
            );

            # URL should not contain OTRS specific URL delimiter of semicolon (;).
            #   For better compatibility, use standard ampersand (&) instead.
            #   Please see bug#12667 for more information.
            $Self->False(
                ( $URL =~ /[;]/ ) ? 1 : 0,
                "$Class URL does not contain forbidden characters"
            );
        }

        # Let's try to add calendar with same name.
        $Selenium->find_element( '.SidebarColumn ul.ActionList a#Add',   'css' )->VerifiedClick();
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->send_keys($CalendarName1);
        $Selenium->InputFieldValueSet(
            Element => '#GroupID',
            Value   => $GroupID,
        );
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('div.Dialog button#DialogButton1').length"
        );
        $Selenium->find_element( 'div.Dialog button#DialogButton1', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && !\$('div.Dialog').length"
        );

        # Update calendar name
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->clear();
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->send_keys($CalendarName2);

        # Set it to invalid.
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );

        # Add ticket appointment rule.
        $Selenium->execute_script(
            "\$('.WidgetSimple.Collapsed:contains(Ticket Appointments) .WidgetAction.Toggle a').trigger('click')"
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('.WidgetSimple.Expanded:contains(Ticket Appointments)').length"
        );

        $Selenium->find_element( '#AddRuleButton', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('#QueueID_1').length" );
        $Selenium->InputFieldValueSet(
            Element => '#QueueID_1',
            Value   => $QueueID,
        );

        # Add title as search parameter.
        $Selenium->InputFieldValueSet(
            Element => '#SearchParams',
            Value   => 'Title',
        );
        $Selenium->find_element( '.AddButton', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return \$('#SearchParam_1_Title').length"
        );
        $Selenium->find_element( '#SearchParam_1_Title',            'css' )->send_keys('Test*');
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        # Filter added calendars.
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->send_keys($RandomID);
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.ContentColumn table tbody tr:visible').length === 2"
        );

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
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.ContentColumn table tbody tr:visible').length === 1"
        );

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
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 3,
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
        $Selenium->find_element( '.RemoveButton', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && !\$('#QueueID_1').length" );
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        # Verify the calendar is invalid temporarily.
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->clear();
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->send_keys($CalendarName2);
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.ContentColumn table tbody tr:visible').length === 1"
        );

        $Self->Is(
            $Selenium->execute_script("return \$('tbody tr:visible:eq(0) td:eq(3)').text()"),
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
