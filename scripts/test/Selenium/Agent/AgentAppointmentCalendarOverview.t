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

my $ElementReadOnly = sub {
    my (%Param) = @_;

    # Value is optional parameter
    for my $Needed (qw(UnitTestObject Element)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Param{UnitTestObject}->Is(
        $Selenium->execute_script(
            "return \$('#$Param{Element}.ReadOnlyValue').length;"
        ),
        $Param{Value},
        "$Param{Element} read only ($Param{Value})",
    );
};

my $ElementExists = sub {
    my (%Param) = @_;

    # Value is optional parameter
    for my $Needed (qw(UnitTestObject Element)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Length = $Selenium->execute_script(
        "return \$('#" . $Param{Element} . "').length;"
    );

    if ( $Param{Value} ) {
        $Param{UnitTestObject}->True(
            $Length,
            "$Param{Element} exists",
        );
    }
    else {
        $Param{UnitTestObject}->False(
            $Length,
            "$Param{Element} not exists",
        );
    }
};

$Selenium->RunTest(
    sub {
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                DisableAsyncCalls => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $GroupObject    = $Kernel::OM->Get('Kernel::System::Group');
        my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');
        my $UserObject     = $Kernel::OM->Get('Kernel::System::User');
        my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');

        my $RandomID = $Helper->GetRandomID();

        # create test group
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );

        # create test group
        my $GroupName2 = "test-calendar-group2-$RandomID";
        my $GroupID2   = $GroupObject->GroupAdd(
            Name    => $GroupName2,
            ValidID => 1,
            UserID  => 1,
        );

        # add root to the created group
        $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID2,
            UID        => 1,
            Permission => {
                ro        => 1,
                move_into => 1,
                create    => 1,
                owner     => 1,
                priority  => 1,
                rw        => 1,
            },
            UserID => 1,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # change resolution (desktop mode)
        $Selenium->set_window_size( 768, 1050 );

        # create test user
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'users', $GroupName ],
            Language => $Language,
        ) || die 'Did not get test user';

        # get UserID
        my $UserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate()
            || die 'Did not get test customer user';

        # start test
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # create a few test calendars
        my %Calendar1 = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar1 $RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );
        my %Calendar2 = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar2 $RandomID",
            Color        => '#EC9073',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );
        my %Calendar3 = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar3 $RandomID",
            Color        => '#6BAD54',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );
        my %Calendar4 = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar4 $RandomID",
            Color        => '#78A7FC',
            GroupID      => $GroupID2,
            UserID       => 1,
            ValidID      => 1,
        );

        # create a test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => "Link Ticket $RandomID",
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerNo   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => $UserID,
            UserID       => $UserID,
        );
        $Self->True(
            $TicketID,
            "TicketCreate() - $TicketID",
        );
        my $TicketNumber = $TicketObject->TicketNumberLookup(
            TicketID => $TicketID,
            UserID   => $UserID,
        );
        $Self->True(
            $TicketNumber,
            "TicketNumberLookup() - $TicketNumber",
        );

        # go to calendar overview page
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        # go to previous week
        $Selenium->find_element( '.fc-toolbar .fc-prev-button', 'css' )->VerifiedClick();

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        # verify all three calendars are visible
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.CalendarSwitch:visible').length;"
            ),
            3,
            'All three calendars visible',
        );

        # Verify copy-to-clipboard link.
        my $URL = $Selenium->find_element( '.CopyToClipboard', 'css' )->get_attribute('data-clipboard-text');

        $Self->True(
            $URL,
            'CopyToClipboard URL present'
        );

        # URL should not contain OTRS specific URL delimiter of semicolon (;).
        #   For better compatibility, use standard ampersand (&) instead.
        #   Please see bug#12667 for more information.
        $Self->False(
            ( $URL =~ /[;]/ ) ? 1 : 0,
            'CopyToClipboard URL does not contain forbidden characters'
        );

        # click on the timeline view for an appointment dialog
        $Selenium->find_element( '.fc-timelineWeek-view .fc-slats td.fc-widget-content:nth-child(5)', 'css' )
            ->VerifiedClick();

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

        # elements that are not allowed in dialog
        for my $Element (qw(EditFormDelete EditFormCopy)) {
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 0,
            );
        }

        # enter some data
        $Selenium->find_element( 'Title',    'name' )->send_keys('Appointment 1');
        $Selenium->find_element( 'Location', 'name' )->send_keys('Straubing');
        $Selenium->execute_script(
            "return \$('#CalendarID').val("
                . $Calendar1{CalendarID}
                . ").trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( 'EndHour',      'name' )->send_keys('18');
        $Selenium->find_element( '.PluginField', 'css' )->send_keys($TicketNumber);

        # wait for autocomplete to load
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length'
        );

        # link the ticket
        $Selenium->execute_script(
            "return \$('li.ui-menu-item').click();"
        );

        # verify correct ticket is listed
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.PluginContainer div a[target=\"_blank\"]').text();"
            ),
            "$TicketNumber Link Ticket $RandomID",
            'Link ticket visible',
        );

        # check location link contains correct value
        my $LocationLinkURL = $Selenium->find_element( '.LocationLink', 'css' )->get_attribute('href');
        $Self->True(
            $LocationLinkURL =~ /Straubing$/,
            'Location link contains correct value',
        );

        # click on Save
        $Selenium->find_element( '#EditFormSubmit', 'css' )->VerifiedClick();

        # wait for dialog to close and AJAX to finish
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length'
        );

        # verify first appointment is visible
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').text();"
            ),
            'Appointment 1',
            'First appointment visible',
        );

        # go to the ticket zoom screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=${TicketID}");

        # Find link to the appointment on page.
        my $LinkedAppointment = $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentAppointmentCalendarOverview;AppointmentID=' )]"
        );
        $Selenium->VerifiedGet( $LinkedAppointment->get_attribute('href') );

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

        # check data
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Title').val();"
            ),
            'Appointment 1',
            'Title matches',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#CalendarID').val();"
            ),
            $Calendar1{CalendarID},
            'Calendar matches',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.PluginContainer div a[href*=\"Action=AgentTicketZoom;TicketID=$TicketID\"]').text();"
            ),
            "$TicketNumber Link Ticket $RandomID",
            'Link ticket matches',
        );

        # check location link contains correct value
        $LocationLinkURL = $Selenium->find_element( '.LocationLink', 'css' )->get_attribute('href');
        $Self->True(
            $LocationLinkURL =~ /Straubing$/,
            'Location link contains correct value',
        );

        # cancel the dialog
        $Selenium->find_element( '#EditFormCancel', 'css' )->VerifiedClick();

        # go to previous week
        $Selenium->find_element( '.fc-toolbar .fc-prev-button', 'css' )->VerifiedClick();

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        # click on the timeline view for another appointment dialog
        $Selenium->find_element( '.fc-timelineWeek-view .fc-slats td.fc-widget-content:nth-child(5)', 'css' )
            ->VerifiedClick();

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

        # enter some data
        $Selenium->find_element( 'Title', 'name' )->send_keys('Appointment 2');
        $Selenium->execute_script(
            "return \$('#CalendarID').val("
                . $Calendar2{CalendarID}
                . ").trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( 'AllDay', 'name' )->VerifiedClick();

        # click on Save
        $Selenium->find_element( '#EditFormSubmit', 'css' )->VerifiedClick();

        # wait for dialog to close and AJAX to finish
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length'
        );

        # hide the first calendar from view
        $Selenium->find_element( 'Calendar' . $Calendar1{CalendarID}, 'id' )->VerifiedClick();

        # verify second appointment is visible
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').text();"
            ),
            'Appointment 2',
            'Second appointment visible',
        );

        # verify second appointment is an all day appointment
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fa-sun-o').length;"
            ),
            '1',
            'Second appointment in an all day appointment',
        );

        # click again on the timeline view for an appointment dialog
        $Selenium->find_element( '.fc-timelineWeek-view .fc-slats td.fc-widget-content:nth-child(5)', 'css' )
            ->VerifiedClick();

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

        # enter some data
        $Selenium->find_element( 'Title', 'name' )->send_keys('Appointment 3');
        $Selenium->execute_script(
            "return \$('#CalendarID').val("
                . $Calendar3{CalendarID}
                . ").trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( 'EndHour', 'name' )->send_keys('18');
        $Selenium->execute_script(
            "return \$('#RecurrenceType').val('Daily').trigger('redraw.InputField').trigger('change');"
        );

        # click on Save
        $Selenium->find_element( '#EditFormSubmit', 'css' )->VerifiedClick();

        # wait for dialog to close and AJAX to finish
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length'
        );

        # hide the second calendar from view
        $Selenium->find_element( 'Calendar' . $Calendar2{CalendarID}, 'id' )->VerifiedClick();

        # verify all third appointment occurences are visible
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').length;"
            ),
            '4',
            'All third appointment occurrences visible',
        );

        # click on an appointment
        $Selenium->find_element( '.fc-timeline-event', 'css' )->VerifiedClick();

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

        # click on Delete
        $Selenium->find_element( '#EditFormDelete', 'css' )->click();

        # confirm
        $Selenium->accept_alert();

        # wait for dialog to close and AJAX to finish
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length'
        );

        # verify all third appointment occurences have been removed
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').length;"
            ),
            '0',
            'All third appointment occurrences removed',
        );

        # show all three calendars
        $Selenium->find_element( 'Calendar' . $Calendar1{CalendarID}, 'id' )->VerifiedClick();

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        $Selenium->find_element( 'Calendar' . $Calendar2{CalendarID}, 'id' )->VerifiedClick();

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        # verify only two appointments are visible
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').length;"
            ),
            '2',
            'First and second appointment visible',
        );

        # open datepicker
        $Selenium->find_element( '.fc-toolbar .fc-jump-button', 'css' )->VerifiedClick();

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoading").length' );

        # verify exactly one day with appointments is highlighted
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.ui-datepicker .ui-datepicker-calendar .Highlight').length;"
            ),
            1,
            'Datepicker properly highlighted',
        );

        # close datepicker
        $Selenium->find_element( 'div#DatepickerOverlay', 'css' )->VerifiedClick();

        # filter just third calendar
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->send_keys('Calendar3');

        # wait for filter to finish
        sleep 1;

        # verify only one calendar is shown in the list
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.CalendarSwitch:visible').length;"
            ),
            1,
            'Calendars are filtered correctly',
        );

        # Create new Appointment (as root user).
        my $StartTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $StartTimeObject->Subtract(
            Weeks => 1,
        );
        my $EndTimeObject = $StartTimeObject->Clone();
        $EndTimeObject->Add(
            Hours => 2,
        );

        my $AppointmentID = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentCreate(
            CalendarID  => $Calendar4{CalendarID},
            Title       => 'Permissions check appointment',
            Description => 'How to use Process tickets...',
            Location    => 'Straubing',
            StartTime   => $StartTimeObject->ToString(),
            EndTime     => $EndTimeObject->ToString(),
            UserID      => 1,
            TimezoneID  => 0,
        );

        $Self->True(
            $AppointmentID,
            'Permission Appointment created.',
        );

        # add ro permissions to the user
        $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID2,
            UID        => $UserID,
            Permission => {
                ro => 1,
            },
            UserID => 1,
        );

        # reload page
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        # show the fourth calendar and hide all others
        $Selenium->find_element( 'Calendar' . $Calendar4{CalendarID}, 'id' )->VerifiedClick();
        $Selenium->find_element( 'Calendar' . $Calendar1{CalendarID}, 'id' )->VerifiedClick();
        $Selenium->find_element( 'Calendar' . $Calendar2{CalendarID}, 'id' )->VerifiedClick();
        $Selenium->find_element( 'Calendar' . $Calendar3{CalendarID}, 'id' )->VerifiedClick();

        # go to previous week
        $Selenium->find_element( '.fc-toolbar .fc-prev-button', 'css' )->VerifiedClick();

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        # find the appointment link
        my $AppointmentLink = $Selenium->find_element( '.fc-event-container a', 'css' );
        $Selenium->mouse_move_to_location($AppointmentLink);

        # click on appointment
        $AppointmentLink->VerifiedClick();

        # wait for appointment
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

        # check if fields are disabled
        ELEMENT:
        for my $Element (
            qw(Title Description Location CalendarID TeamID ResourceID StartDay EndDay AllDay
            RecurrenceType
            )
            )
        {
            # check if team object is registered
            if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar::Team', Silent => 1 ) ) {
                next ELEMENT if $Element eq 'TeamID' || $Element eq 'ResourceID';
            }

            $ElementReadOnly->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 1,
            );
        }

        # elements that are not allowed on page
        for my $Element (qw(EditFormSubmit EditFormDelete EditFormCopy)) {
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 0,
            );
        }

        # elements that should be on page
        for my $Element (qw(EditFormCancel)) {
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 1,
            );
        }

        # click on cancel
        $Selenium->find_element( '#EditFormCancel', 'css' )->VerifiedClick();

        # add move_into permissions to the user
        $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID2,
            UID        => $UserID,
            Permission => {
                ro        => 1,
                move_into => 1,
            },
            UserID => 1,
        );

        # click on appointment
        $AppointmentLink->VerifiedClick();

        # wait for appointment
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

        # check if fields are disabled
        for my $Element (qw( CalendarID )) {
            $ElementReadOnly->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 1,
            );
        }

        # check if fields are enabled
        ELEMENT:
        for my $Element (
            qw(Title Description Location TeamID ResourceID StartDay EndDay AllDay RecurrenceType)
            )
        {
            # check if team object is registered
            if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar::Team', Silent => 1 ) ) {
                next ELEMENT if $Element eq 'TeamID' || $Element eq 'ResourceID';
            }

            $ElementReadOnly->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 0,
            );
        }

        # elements that are not allowed on page
        for my $Element (qw(EditFormDelete EditFormCopy)) {
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 0,
            );
        }

        # elements that should be on page
        for my $Element (qw(EditFormSubmit EditFormCancel)) {
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 1,
            );
        }

        # click on cancel
        $Selenium->find_element( '#EditFormCancel', 'css' )->VerifiedClick();

        # add create permissions to the user
        $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID2,
            UID        => $UserID,
            Permission => {
                ro        => 1,
                move_into => 1,
                create    => 1,
            },
            UserID => 1,
        );

        # click on appointment
        $AppointmentLink->VerifiedClick();

        # wait for appointment
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

        # check if fields are enabled
        ELEMENT:
        for my $Element (
            qw(Title Description Location CalendarID TeamID ResourceID StartDay EndDay AllDay
            RecurrenceType
            )
            )
        {
            # check if team object is registered
            if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar::Team', Silent => 1 ) ) {
                next ELEMENT if $Element eq 'TeamID' || $Element eq 'ResourceID';
            }

            $ElementReadOnly->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 0,
            );
        }

        # elements that should be on page
        for my $Element (qw(EditFormCopy EditFormSubmit EditFormDelete EditFormCancel)) {
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 1,
            );
        }

        #
        # Cleanup
        #

        my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');
        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
        my $DBObject          = $Kernel::OM->Get('Kernel::System::DB');

        # Delete appointments and calendars.
        for my $CalendarID (
            $Calendar1{CalendarID},
            $Calendar2{CalendarID},
            $Calendar3{CalendarID},
            $Calendar4{CalendarID}
            )
        {
            my @Appointments = $AppointmentObject->AppointmentList(
                CalendarID => $CalendarID,
                Result     => 'ARRAY',
            );
            for my $AppointmentID (@Appointments) {
                $AppointmentObject->AppointmentDelete(
                    AppointmentID => $AppointmentID,
                    UserID        => 1,
                );
            }

            # Delete test calendars.
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM calendar WHERE id = $CalendarID",
            );
            $Self->True(
                $Success,
                "Deleted test calendar - $CalendarID",
            );
        }

        # Delete test ticket.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Deleted test ticket - $TicketID",
        );

        # Delete group-user relations.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM group_user WHERE group_id = $GroupID OR group_id = $GroupID2",
        );
        if ($Success) {
            $Self->True(
                $Success,
                "GroupUserDelete - $RandomID",
            );
        }

        # Delete groups.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM groups WHERE id = $GroupID OR id = $GroupID2",
        );
        $Self->True(
            $Success,
            "GroupDelete - $RandomID",
        );

        # Make sure cache is correct.
        for my $Cache (qw(Appointment Calendar Group Ticket)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }
    },
);

1;
