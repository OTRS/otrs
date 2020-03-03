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

my $ElementReadOnly = sub {
    my (%Param) = @_;

    # Value is optional parameter.
    for my $Needed (qw(UnitTestObject Element)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$Param{Element}').length" );

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

    # Value is optional parameter.
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
        "return \$('#$Param{Element}').length;"
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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $GroupObject    = $Kernel::OM->Get('Kernel::System::Group');
        my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');
        my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );

        # Create test group.
        my $GroupName2 = "test-calendar-group2-$RandomID";
        my $GroupID2   = $GroupObject->GroupAdd(
            Name    => $GroupName2,
            ValidID => 1,
            UserID  => 1,
        );

        # Change resolution (desktop mode).
        $Selenium->set_window_size( 768, 1050 );

        # Create test user.
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'users', $GroupName ],
            Language => $Language,
        ) || die 'Did not get test user';

        # Get UserID.
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $TestUserLogin2 = $Helper->TestUserCreate(
            Groups   => [ 'users', $GroupName2 ],
            Language => $Language,
        ) || die 'Did not get test user';

        # Get UserID.
        my $UserID2 = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin2,
        );

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate()
            || die 'Did not get test customer user';

        # Create a few test calendars.
        my %Calendar1 = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar1 $RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );
        $Self->True(
            $Calendar1{CalendarID},
            "Calendar1 $RandomID created successful.",
        );

        my %Calendar2 = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar2 $RandomID",
            Color        => '#EC9073',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );
        $Self->True(
            $Calendar2{CalendarID},
            "Calendar2 $RandomID created successful.",
        );

        my %Calendar3 = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar3 $RandomID",
            Color        => '#6BAD54',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );
        $Self->True(
            $Calendar3{CalendarID},
            "Calendar3 $RandomID created successful.",
        );

        my %Calendar4 = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar4 $RandomID",
            Color        => '#78A7FC',
            GroupID      => $GroupID2,
            UserID       => $UserID2,
            ValidID      => 1,
        );
        $Self->True(
            $Calendar4{CalendarID},
            "Calendar4 $RandomID created successful.",
        );

        # Create a test ticket.
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

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to calendar overview page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".CalendarWidget.Loading").length && $(".fc-toolbar .fc-prev-button").length;'
        );

        # Go to previous week.
        $Selenium->find_element( '.fc-toolbar .fc-prev-button', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".CalendarWidget.Loading").length && $(".CalendarSwitch:visible").length == 3;'
        );

        # Verify all three calendars are visible.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.CalendarSwitch:visible').length;"
            ),
            3,
            'All three calendars visible',
        );

        # Verify copy-to-clipboard link.
        my $URL = $Selenium->execute_script("return \$('.CopyToClipboard').attr('data-clipboard-text');");

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

        # Click on the timeline view for an appointment dialog.
        $Selenium->find_element( '.fc-timelineWeek-view .fc-slats td.fc-widget-content:nth-child(5)', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );

        # Elements that are not allowed in dialog.
        for my $Element (qw(EditFormDelete EditFormCopy)) {
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 0,
            );
        }

        # Enter some data.
        $Selenium->find_element( "#Title",    'css' )->send_keys('Appointment 1');
        $Selenium->find_element( "#Location", 'css' )->send_keys('Straubing');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );
        $Selenium->find_element( '#EndHour',     'css' )->send_keys('18');
        $Selenium->find_element( '.PluginField', 'css' )->send_keys($TicketNumber);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TicketNumber)').click();");

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.PluginContainer div a[target=\"_blank\"]').length;"
        );

        # Verify correct ticket is listed.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.PluginContainer div a[target=\"_blank\"]').text();"
            ),
            "$TicketNumber Link Ticket $RandomID",
            'Link ticket visible',
        );

        # Check location link contains correct value.
        my $LocationLinkURL = $Selenium->execute_script("return \$('.LocationLink').attr('href');");
        $Self->True(
            $LocationLinkURL =~ /Straubing$/,
            'Location link contains correct value',
        );

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor(
            JavaScript => "return \$.active == 0 && \$('.fc-timeline-event .fc-title').text() == 'Appointment 1';"
        );

        # Verify first appointment is visible.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').text();"
            ),
            'Appointment 1',
            'First appointment visible',
        );

        # Go to the ticket zoom screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=${TicketID}");

        # Find link to the appointment on page.
        $Selenium->WaitFor( JavaScript => "return \$('a.LinkObjectLink').length;" );
        $Selenium->execute_script(
            "\$('.LinkObjectLink')[0].scrollIntoView(true);",
        );
        $Selenium->execute_script('$("a.LinkObjectLink")[0].click();');
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#Title').length && \$('#CalendarID').length;"
        );

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

        # Check location link contains correct value.
        $LocationLinkURL = $Selenium->execute_script("return \$('.LocationLink').attr('href');");
        $Self->True(
            $LocationLinkURL =~ /Straubing$/,
            'Location link contains correct value',
        );

        # Cancel the dialog.
        $Selenium->find_element( '#EditFormCancel', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length && $(".fc-toolbar .fc-prev-button").length;'
        );

        # Go to previous week.
        $Selenium->find_element( '.fc-toolbar .fc-prev-button', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return !$(".CalendarWidget.Loading").length && $(".fc-timelineWeek-view .fc-slats td.fc-widget-content:nth-child(5)").length;'
        );

        # Click on the timeline view for another appointment dialog.
        $Selenium->find_element( '.fc-timelineWeek-view .fc-slats td.fc-widget-content:nth-child(5)', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#Title').length && \$('#CalendarID').length;"
        );

        # Enter some data.
        $Selenium->find_element( 'Title', 'name' )->send_keys('Appointment 2');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar2{CalendarID},
        );

        $Selenium->find_element( '#AllDay', 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#AllDay").prop("checked") === true;' );

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );
        $Selenium->WaitFor(
            JavaScript =>
                'return $("#Calendar' . $Calendar1{CalendarID} . ':checked").length;'
        );

        # Hide the first calendar from view.
        $Selenium->execute_script("\$('#Calendar$Calendar1{CalendarID}').click();");
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Calendar'
                . $Calendar1{CalendarID}
                . '").prop("checked") === false;'
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.fc-timeline-event .fc-title').text() === 'Appointment 2';"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('.fc-timeline-event .fa-sun-o').length == 1;"
        );

        # Verify second appointment is visible.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').text();"
            ),
            'Appointment 2',
            'Second appointment visible',
        );

        # Verify second appointment is an all day appointment.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fa-sun-o').length;"
            ),
            '1',
            'Second appointment in an all day appointment',
        );

        $Selenium->WaitFor(
            JavaScript =>
                "return \$('.fc-timelineWeek-view .fc-slats td.fc-widget-content:nth-child(5)').length;"
        );

        # Click again on the timeline view for an appointment dialog.
        $Selenium->find_element( '.fc-timelineWeek-view .fc-slats td.fc-widget-content:nth-child(5)', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#Title').length && \$('#CalendarID').length;"
        );

        # Enter some data.
        $Selenium->find_element( 'Title', 'name' )->send_keys('Appointment 3');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar3{CalendarID},
        );
        $Selenium->find_element( 'EndHour', 'name' )->send_keys('18');
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Daily',
        );

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0;" );

        $Selenium->WaitFor(
            JavaScript =>
                'return $("#Calendar' . $Calendar2{CalendarID} . ':checked").length;'
        );

        # Hide the second calendar from view.
        $Selenium->execute_script("\$('#Calendar$Calendar2{CalendarID}').click();");
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Calendar'
                . $Calendar2{CalendarID}
                . '").prop("checked") === false;'
        );

        # Verify all third appointment occurences are visible.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').length;"
            ),
            '4',
            'All third appointment occurrences visible',
        );

        # Click on an appointment.
        $Selenium->execute_script(
            "\$('.fc-timeline-event:eq(0) .fc-title').trigger('click');"
        );
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#EditFormDelete').length;" );

        # Click on Delete.
        $Selenium->find_element( '#EditFormDelete', 'css' )->click();

        $Selenium->WaitFor( AlertPresent => 1 );
        $Selenium->accept_alert();

        # Wait for dialog to close and AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".fc-timeline-event .fc-title").length;'
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0;" );

        # Verify all third appointment occurences have been removed.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').length;"
            ),
            '0',
            'All third appointment occurrences removed',
        );

        # Show all three calendars.
        $Selenium->find_element( 'Calendar' . $Calendar1{CalendarID}, 'id' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length;' );
        $Selenium->find_element( 'Calendar' . $Calendar2{CalendarID}, 'id' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length;' );

        # Verify only two appointments are visible.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').length;"
            ),
            '2',
            'First and second appointment visible',
        );

        # Open datepicker.
        $Selenium->find_element( '.fc-toolbar .fc-jump-button', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#Datepicker .ui-datepicker-calendar .Highlight").length === 1;'
        );

        # Verify exactly one day with appointments is highlighted.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.ui-datepicker .ui-datepicker-calendar .Highlight').length;"
            ),
            1,
            'Datepicker properly highlighted',
        );

        # Close datepicker.
        $Selenium->find_element( 'div#DatepickerOverlay', 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$("#DatepickerOverlay").length;' );

        # Filter just third calendar.
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->send_keys('Calendar3');
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".CalendarSwitch:visible").length === 1;'
        );

        # Verify only one calendar is shown in the list.
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

        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
        my $AppointmentID     = $AppointmentObject->AppointmentCreate(
            CalendarID  => $Calendar4{CalendarID},
            Title       => 'Permissions check appointment',
            Description => 'How to use Process tickets...',
            Location    => 'Straubing',
            StartTime   => $StartTimeObject->ToString(),
            EndTime     => $EndTimeObject->ToString(),
            UserID      => $UserID,
            TimezoneID  => 0,
        );

        $Self->True(
            $AppointmentID,
            'Permission Appointment created.',
        );

        # Add ro permissions to the user.
        $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID2,
            UID        => $UserID,
            Permission => {
                ro => 1,
            },
            UserID => $UserID,
        );

        # Reload page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length;' );

        # Show the fourth calendar and hide all others.
        $Selenium->execute_script("\$('#Calendar$Calendar4{CalendarID}').click();");
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Calendar'
                . $Calendar4{CalendarID}
                . '").prop("checked") === true;'
        );
        $Self->True(
            $Selenium->execute_script(
                'return $("#Calendar' . $Calendar4{CalendarID} . '").prop("checked") === true;'
            ),
            "CalendarID $Calendar4{CalendarID} - checked",
        );

        $Selenium->execute_script("\$('#Calendar$Calendar1{CalendarID}').click();");
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Calendar'
                . $Calendar1{CalendarID}
                . '").prop("checked") === false;'
        );
        $Self->True(
            $Selenium->execute_script(
                'return $("#Calendar' . $Calendar1{CalendarID} . '").prop("checked") === false;'
            ),
            "CalendarID $Calendar1{CalendarID} - unchecked",
        );

        $Selenium->execute_script("\$('#Calendar$Calendar2{CalendarID}').click();");
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Calendar'
                . $Calendar2{CalendarID}
                . '").prop("checked") === false;'
        );
        $Self->True(
            $Selenium->execute_script(
                'return $("#Calendar' . $Calendar2{CalendarID} . '").prop("checked") === false;'
            ),
            "CalendarID $Calendar2{CalendarID} - unchecked",
        );

        $Selenium->execute_script("\$('#Calendar$Calendar3{CalendarID}').click();");
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Calendar'
                . $Calendar3{CalendarID}
                . '").prop("checked") === false;'
        );
        $Self->True(
            $Selenium->execute_script(
                'return $("#Calendar' . $Calendar3{CalendarID} . '").prop("checked") === false;'
            ),
            "CalendarID $Calendar3{CalendarID} - unchecked",
        );

        $Selenium->WaitFor( JavaScript => 'return $(".fc-toolbar .fc-prev-button").length;' );

        # Go to previous week.
        $Selenium->find_element( '.fc-toolbar .fc-prev-button', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".CalendarWidget.Loading").length && $(".fc-event-container a").length;'
        );

        # Find the appointment link.
        my $AppointmentLink = $Selenium->find_element( '.fc-event-container a', 'css' );

        # Click on appointment.
        $AppointmentLink->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );

        my $TeamObjectRegistered
            = $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar::Team', Silent => 1 );

        # Check if fields are disabled.
        ELEMENT:
        for my $Element (
            qw(Title Description Location CalendarID TeamID ResourceID StartDay EndDay AllDay
            RecurrenceType
            )
            )
        {
            # Check if team object is registered.
            if ( !$TeamObjectRegistered ) {
                next ELEMENT if $Element eq 'TeamID' || $Element eq 'ResourceID';
            }

            $ElementReadOnly->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 1,
            );
        }

        # Elements that are not allowed on page.
        for my $Element (qw(EditFormSubmit EditFormDelete EditFormCopy)) {
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 0,
            );
        }

        # Elements that should be on page.
        for my $Element (qw(EditFormCancel)) {
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#$Element').length;"
            );
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 1,
            );
        }

        # Click on cancel.
        $Selenium->find_element( '#EditFormCancel', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        # Add move_into permissions to the user.
        $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID2,
            UID        => $UserID,
            Permission => {
                ro        => 1,
                move_into => 1,
            },
            UserID => $UserID,
        );

        # Click on appointment.
        $AppointmentLink->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );

        # Check if fields are disabled.
        for my $Element (qw( CalendarID )) {
            $ElementReadOnly->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 1,
            );
        }

        # Check if fields are enabled.
        ELEMENT:
        for my $Element (
            qw(Title Description Location TeamID ResourceID StartDay EndDay AllDay RecurrenceType)
            )
        {
            # Check if team object is registered.
            if ( !$TeamObjectRegistered ) {
                next ELEMENT if $Element eq 'TeamID' || $Element eq 'ResourceID';
            }

            $ElementReadOnly->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 0,
            );
        }

        # Elements that are not allowed on page.
        for my $Element (qw(EditFormDelete EditFormCopy)) {
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 0,
            );
        }

        # Elements that should be on page.
        for my $Element (qw(EditFormSubmit EditFormCancel)) {
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#$Element').length;"
            );
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 1,
            );
        }

        # Click on cancel.
        $Selenium->find_element( '#EditFormCancel', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        # Add create permissions to the user.
        $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID2,
            UID        => $UserID,
            Permission => {
                ro        => 1,
                move_into => 1,
                create    => 1,
            },
            UserID => $UserID,
        );

        # Click on appointment.
        $AppointmentLink->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );

        # Check if fields are enabled.
        ELEMENT:
        for my $Element (
            qw(Title Description Location CalendarID TeamID ResourceID StartDay EndDay AllDay
            RecurrenceType
            )
            )
        {
            # Check if team object is registered.
            if ( !$TeamObjectRegistered ) {
                next ELEMENT if $Element eq 'TeamID' || $Element eq 'ResourceID';
            }

            $ElementReadOnly->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 0,
            );
        }

        # Elements that should be on page.
        for my $Element (qw(EditFormCopy EditFormSubmit EditFormDelete EditFormCancel)) {
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#$Element').length;"
            );
            $ElementExists->(
                UnitTestObject => $Self,
                Element        => $Element,
                Value          => 1,
            );
        }

        # Click on cancel.
        $Selenium->find_element( '.Close', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length;'
        );

        $Selenium->find_element( '.fc-agendaWeek-button', 'css' )->click();

        # Go to other screen to check if selected Timeline will be saved on return to Calendar overview.
        # See bug#14629 - https://bugs.otrs.org/show_bug.cgi?id=14629.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=${TicketID}");
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");

        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-agendaWeek-button').hasClass('fc-state-active');"
            ),
            "1",
            "Timeline is correctly selected after page reload"
        );

        #
        # Cleanup
        #

        my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');
        my $DBObject          = $Kernel::OM->Get('Kernel::System::DB');

        # Delete appointments and calendars.
        for my $CalendarID (
            $Calendar1{CalendarID},
            $Calendar2{CalendarID},
            $Calendar3{CalendarID},
            $Calendar4{CalendarID},
            )
        {
            my @Appointments = $AppointmentObject->AppointmentList(
                CalendarID => $CalendarID,
                Result     => 'ARRAY',
            );
            for my $AppointmentID (@Appointments) {
                $AppointmentObject->AppointmentDelete(
                    AppointmentID => $AppointmentID,
                    UserID        => $UserID,
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
            UserID   => $UserID,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $UserID,
            );
        }
        $Self->True(
            $Success,
            "Deleted test ticket - $TicketID",
        );

        # Remove scheduled asynchronous tasks from DB, as they may interfere with tests run later.
        my @TaskIDs;
        my @AllTasks = $SchedulerDBObject->TaskList(
            Type => 'AsynchronousExecutor',
        );
        for my $Task (@AllTasks) {
            if ( $Task->{Name} eq 'Kernel::System::Calendar-TicketAppointmentProcessTicket()' ) {
                push @TaskIDs, $Task->{TaskID};
            }
        }
        for my $TaskID (@TaskIDs) {
            my $Success = $SchedulerDBObject->TaskDelete(
                TaskID => $TaskID,
            );
            $Self->True(
                $Success,
                "TaskDelete - Removed scheduled asynchronous task $TaskID",
            );
        }

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

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(Appointment Calendar Group Ticket)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    },
);

1;
