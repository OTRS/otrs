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

# Get Selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $UserObject        = $Kernel::OM->Get('Kernel::System::User');
        my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
        my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
        my $TicketObject      = $Kernel::OM->Get('Kernel::System::Ticket');
        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
        my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');

        # Set link object view mode to 'Complex'.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'LinkObject::ViewMode',
            Value => 'Complex',
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "GroupID $GroupID - created",
        );

        # Create test user.
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users', $GroupName ],
            Language => $Language,
        ) || die 'Did not get test user';

        # Get test user ID.
        my $UserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test calendar.
        my %Calendar = $CalendarObject->CalendarCreate(
            CalendarName => "My Calendar $RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );
        my $CalendarID = $Calendar{CalendarID};
        $Self->True(
            $CalendarID,
            "CalendarID $CalendarID - created",
        );

        # Create test ticket.
        my $TicketTitle  = "Ticket-$RandomID";
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => $TicketTitle,
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => '123465',
            CustomerUser => 'customerOne@example.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID - created",
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentAppointmentCalendarOverview.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");

        my $AppointmentName = "Appointment-$RandomID";

        # Add appointments and link with test ticket.
        $Selenium->find_element( "#AppointmentCreateButton", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );
        $Selenium->find_element( "#Title",       'css' )->send_keys("$AppointmentName");
        $Selenium->find_element( "#Description", 'css' )->send_keys('Test repeating appointment');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $CalendarID
        );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Daily',
        );
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#RecurrenceLimit').length" );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#RecurrenceCount').length" );
        $Selenium->find_element( "#RecurrenceCount", 'css' )->send_keys('3');

        my $AutoCompleteString = "$TicketNumber $TicketTitle";
        $Selenium->find_element( "input.PluginField.ui-autocomplete-input", 'css' )->send_keys($RandomID);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item a").length === 1' );
        $Selenium->execute_script("\$('a.ui-menu-item-wrapper:contains($AutoCompleteString)').click()");
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );
        $Selenium->VerifiedRefresh();

        # Get test appointments.
        my @Appointments = $AppointmentObject->AppointmentList(
            CalendarID => $CalendarID,
        );

        # Get parent and child appointments.
        my $ParentAppointment;
        my @ChildAppointments;
        for my $Appointment (@Appointments) {
            if ( !defined $Appointment->{Recurring} ) {
                push @ChildAppointments, $Appointment;
            }
            else {
                $ParentAppointment = $Appointment;
            }
        }

        # Get the last child appointment ID.
        my $LastChildAppointmentID = $ChildAppointments[-1]->{AppointmentID};

        # Navigate to AgentTicketZoom.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check appointment links - all appointments should be in the table.
        for my $Appointment (@Appointments) {
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#Appointment tbody a[href*=\"Action=AgentAppointmentCalendarOverview;AppointmentID="
                        . $Appointment->{AppointmentID}
                        . "\"]').length;"
                ),
                "Added appointment - AppointmentID $Appointment->{AppointmentID} - found"
            );
        }

        # Delete the last recurring appointment link.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentAppointmentCalendarOverview;AppointmentID=$LastChildAppointmentID' )]"
        )->VerifiedClick();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );
        $Selenium->find_element( ".RemoveButton", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && !\$('.PluginContainer:visible').length"
        );
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );
        $Selenium->VerifiedRefresh();

        # Navigate to AgentTicketZoom.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check appointment links - only the last appointment should not be in the table.
        for my $Appointment (@Appointments) {
            my $AppointmentID = $Appointment->{AppointmentID};
            my $Length        = $AppointmentID != $LastChildAppointmentID ? 1 : 0;
            my $IsFound       = $Length ? 'found' : 'not found';

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#Appointment tbody a[href*=\"Action=AgentAppointmentCalendarOverview;AppointmentID=$AppointmentID\"]').length;"
                ),
                $Length,
                "After delete child appointment link - AppointmentID $AppointmentID - $IsFound"
            );
        }

        # Edit parent appointment name to check if all child appointments will be recreated.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentAppointmentCalendarOverview;AppointmentID="
                . $ParentAppointment->{AppointmentID}
                . "')]"
        )->VerifiedClick();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );
        $Selenium->find_element( "#Title",          'css' )->clear();
        $Selenium->find_element( "#Title",          'css' )->send_keys("$AppointmentName-Edit");
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );
        $Selenium->VerifiedRefresh();

        # Clean the cache and get the same parent appointment with new children.
        $CacheObject->CleanUp( Type => 'AppointmentList' . $CalendarID );

        # Navigate to AgentTicketZoom.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Wait until Appointment table is shown.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Appointment tbody").length' );

        # Verify the table exists on AgentTicketZoom.
        $Self->True(
            $Selenium->execute_script("return \$('#Appointment tbody').length"),
            "Table with appointments on AgentTicketZoom - found",
        );

        # Check if there are no previous child appointments.
        for my $Appointment (@ChildAppointments) {
            $Self->False(
                $Selenium->execute_script(
                    "return \$('#Appointment tbody a[href*=\"Action=AgentAppointmentCalendarOverview;AppointmentID="
                        . $Appointment->{AppointmentID}
                        . "\"]').length;"
                ),
                "After change parent appointment - Old child appointmentID $Appointment->{AppointmentID} - not found"
            );
        }

        @Appointments = $AppointmentObject->AppointmentList(
            CalendarID => $CalendarID,
        );

        # Check if new child appointments are linked to the ticket.
        APPOINTMENT:
        for my $Appointment (@Appointments) {
            next APPOINTMENT if $Appointment->{AppointmentID} == $ParentAppointment->{AppointmentID};

            $Self->True(
                $Selenium->execute_script(
                    "return \$('#Appointment tbody a[href*=\"Action=AgentAppointmentCalendarOverview;AppointmentID="
                        . $Appointment->{AppointmentID}
                        . "\"]').length;"
                ),
                "After change parent appointment - New child appointment $Appointment->{AppointmentID} - found"
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test ticket.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "TicketID $TicketID - deleted",
        );

        # Delete parent with all child appointments.
        $Success = $AppointmentObject->AppointmentDelete(
            AppointmentID => $ParentAppointment->{AppointmentID},
            UserID        => $UserID,
        );
        $Self->True(
            $Success,
            "Parent AppointmentID $ParentAppointment->{AppointmentID} and all its children - deleted",
        );

        # Delete test calendar.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM calendar WHERE id = ?",
            Bind => [ \$CalendarID ],
        );
        $Self->True(
            $Success,
            "CalendarID $CalendarID - deleted",
        );

        # Delete group-user relation.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE group_id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "Group-user relation for group ID $GroupID - deleted",
        );

        # Delete test group.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM groups WHERE id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "GroupID $GroupID - deleted",
        );

        # Make sure cache is correct.
        $CacheObject->CleanUp();

    },
);

1;
