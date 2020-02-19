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

use Kernel::System::VariableCheck qw(:all);

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

# Check if team object is registered.
if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar::Team', Silent => 1 ) ) {
    $Self->True(
        1,
        "Team object is not registered, skipping test ...",
    );
    return 1;
}

$Selenium->RunTest(
    sub {
        my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
        my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
        my $TeamObject        = $Kernel::OM->Get('Kernel::System::Calendar::Team');
        my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "Test group $GroupID created",
        );

        my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', $GroupName ],
        );

        my $CalendarName = "Calendar-$RandomID";
        my %Calendar     = $CalendarObject->CalendarCreate(
            CalendarName => $CalendarName,
            GroupID      => $GroupID,
            Color        => '#FF7700',
            UserID       => $TestUserID,
            ValidID      => 1,
        );
        $Self->True(
            $Calendar{CalendarID},
            "CalendarID $Calendar{CalendarID} is created",
        );

        # Create test teams.
        my @TeamIDs;
        for my $Counter ( 1 .. 2 ) {
            my $TeamName = "Test team $Counter $RandomID";
            my $TeamID   = $TeamObject->TeamAdd(
                Name    => $TeamName,
                GroupID => $GroupID,
                Comment => 'My comment',
                ValidID => 1,
                UserID  => $TestUserID,
            );
            $Self->True(
                $TeamID,
                "TeamID $TeamID is created",
            );
            push @TeamIDs, $TeamID;
        }

        # Create test team members.
        my @ResourceIDs;
        my $NumberOfResources = 5;
        for my $Counter ( 1 .. $NumberOfResources ) {

            my ( $ResourceUserLogin, $ResourceID ) = $Helper->TestUserCreate(
                Groups => [$GroupName],
            );
            $Self->True(
                $ResourceUserLogin,
                "Resource $ResourceUserLogin created",
            );

            for my $TeamID (@TeamIDs) {
                my $Success = $TeamObject->TeamUserAdd(
                    TeamID     => $TeamID,
                    TeamUserID => $ResourceID,
                    UserID     => $TestUserID,
                );
                $Self->True(
                    $Success,
                    "Test user $ResourceID to TeamID $TeamID is added",
                );
            }

            push @ResourceIDs, $ResourceID;

        }

        my $AppointmentID = $AppointmentObject->AppointmentCreate(
            CalendarID  => $Calendar{CalendarID},
            Title       => 'My Appointment - teams + resources',
            Description => 'Calendar Appointment',
            Location    => 'Mexico',
            StartTime   => '2019-01-02 10:00:00',
            EndTime     => '2019-01-02 12:00:00',
            TeamID      => \@TeamIDs,
            ResourceID  => \@ResourceIDs,
            UserID      => $TestUserID,
        );

        $Self->True(
            $AppointmentID,
            'Added test appointment',
        );
        my %Appointment = $AppointmentObject->AppointmentGet(
            AppointmentID => $AppointmentID,
            CalendarID    => $Calendar{CalendarID},
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Create test user.
        # TODO language will be possible to set on some other languages,
        #     after updating JavaScriptStrings with Dev::Tools::TranslationsUpdate.
        my $Language = 'en';
        my ( $TestUserRoLogin, $TestUserRoID ) = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users' ],
            Language => $Language,
        );

        $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID,
            UID        => $TestUserRoID,
            Permission => {
                ro        => 1,
                move_into => 0,
                create    => 0,
                owner     => 0,
                priority  => 0,
                rw        => 0,
            },
            UserID => $TestUserID,
        ) || die "Could not add test user $TestUserLogin to group $GroupName";

        # Start test.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserRoLogin,
            Password => $TestUserRoLogin,
        );

        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentAppointmentAgendaOverview;Filter=Day;Start=2019-01-02%2009%3A00%3A00"
        );

        $Selenium->WaitFor( ElementExists => "//div[\@title=\'$CalendarName\']" );

        $Selenium->find_element("//div[\@title=\'$CalendarName\']")->click();
        $Selenium->WaitFor( ElementExists => [ '.DialogTooltipLink', 'css' ] );

        $Kernel::OM->ObjectParamAdd(
            'Kernel::Language' => {
                UserLanguage => $Language,
            },
        );
        my $LanguageObject   = $Kernel::OM->Get('Kernel::Language');
        my $TranslatedString = $LanguageObject->Translate( '+%s more', $NumberOfResources - 2 );

        $Self->True(
            $Selenium->find_element("//a[contains(.,\'$TranslatedString\')]"),
            "Check collapse values for teams",
        );

        my $Delete = $AppointmentObject->AppointmentDelete(
            AppointmentID => $AppointmentID,
            UserID        => $TestUserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete,
            "Delete appointment with dynamic field data",
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        for my $TeamID (@TeamIDs) {
            for my $ResourceID (@ResourceIDs) {
                my $Success = $TeamObject->TeamUserRemove(
                    TeamID     => $TeamID,
                    TeamUserID => $ResourceID,
                    UserID     => 1,
                );
                $Self->True(
                    $Success,
                    "Test user $ResourceID from TeamID $TeamID is deleted",
                );
            }

            # Delete test team.
            $DBObject->Do(
                SQL  => 'DELETE FROM calendar_team WHERE id = ?',
                Bind => [ \$TeamID ],
            );
        }

        # Delete test calendars.
        my $Success = $DBObject->Do(
            SQL  => 'DELETE FROM calendar WHERE id = ?',
            Bind => [ \$Calendar{CalendarID} ],
        );
        $Self->True(
            $Success,
            "CalendarID $Calendar{CalendarID} is deleted"
        );

        # Delete group.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE group_id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "Group <-> user relations for GroupID $GroupID are deleted"
        );

        $Success = $DBObject->Do(
            SQL  => "DELETE FROM groups WHERE id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "GroupID $GroupID is deleted"
        );

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    },
);

1;
