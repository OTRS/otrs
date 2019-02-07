# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {
        my $Helper         = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');

        my $RandomID = $Helper->GetRandomID();
        my $Limit    = 10;

        # Set CalendarLimitOverview.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'AppointmentCalendar::CalendarLimitOverview',
            Value => $Limit,
        );

        # Create test group.
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );

        # Create test user.
        my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate(
            Groups => [ 'users', $GroupName ],
        );

        # Create test calendars.
        my @CalendarIDs;
        my $LastCalendarIndex = 15;
        for my $Count ( 0 .. $LastCalendarIndex ) {
            my %Calendar = $CalendarObject->CalendarCreate(
                CalendarName => "Calendar$Count-$RandomID",
                Color        => '#3A87AD',
                GroupID      => $GroupID,
                UserID       => $UserID,
                ValidID      => 1,
            );
            $Self->True(
                $Calendar{CalendarID},
                "CalendarID $Calendar{CalendarID} is created",
            );
            push @CalendarIDs, $Calendar{CalendarID};

            $Count++;
        }

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to calendar overview page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        # Verify that only first calendars (limited by CalendarLimitOverview setting) are checked.
        for my $Index ( 0 .. $LastCalendarIndex ) {
            my $Length  = ( $Index < $Limit ) ? 1         : 0;
            my $Checked = $Length             ? 'checked' : 'unchecked';
            my $CalendarID = $CalendarIDs[$Index];

            $Self->Is(
                $Selenium->execute_script("return \$('#Calendar$CalendarID:checked').length;"),
                $Length,
                "By default - CalendarID $CalendarID - $Checked",
            );
        }

        my @CheckedIndices = ( 1, 2, 5, 8, 11, 12, 14 );

        # Uncheck all and then check calendars from the array.
        $Selenium->execute_script("\$('#Calendars tbody input[type=checkbox]').prop('checked', false);");

        for my $Index (@CheckedIndices) {
            my $CalendarID = $CalendarIDs[$Index];
            $Selenium->find_element( "#Calendar$CalendarID", 'css' )->click();
            $Selenium->WaitFor( JavaScript => "return \$('#Calendar$CalendarID:checked').length;" );
            sleep 1;
        }

        # Go again to calendar overview page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length;' );

        # Verify that only calendars from the array are checked (see bug#14054).
        for my $Index ( 0 .. $LastCalendarIndex ) {
            my $Length = ( grep { $_ == $Index } @CheckedIndices ) ? 1 : 0;
            my $Checked = $Length ? 'checked' : 'unchecked';
            my $CalendarID = $CalendarIDs[$Index];

            $Self->Is(
                $Selenium->execute_script("return \$('#Calendar$CalendarID:checked').length;"),
                $Length,
                "After changes - Calendar $CalendarID - $Checked",
            );
        }

        # Cleanup.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success;

        # Delete test calendars.
        for my $CalendarID (@CalendarIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM calendar WHERE id = ?",
                Bind => [ \$CalendarID ],
            );
            $Self->True(
                $Success,
                "CalendarID $CalendarID is deleted",
            );
        }

        # Delete group-user relations.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE group_id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "Group-user relation is deleted",
        );

        # Delete test group.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM groups WHERE id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "GroupID $GroupID is deleted",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(Calendar Group)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    },
);

1;
