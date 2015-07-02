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

use Kernel::System::VariableCheck (qw(IsHashRefWithData));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get SysConfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # disable all dashboard plugins
        my $Config = $Kernel::OM->Get('Kernel::Config')->Get('DashboardBackend');
        $SysConfigObject->ConfigItemUpdate(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => \%$Config,
        );

        my %EventsTicketCalendarSysConfig = $SysConfigObject->ConfigItemGet(
            Name    => 'DashboardBackend###0280-DashboardEventsTicketCalendar',
            Default => 1,
        );

        %EventsTicketCalendarSysConfig = map { $_->{Key} => $_->{Content} }
            grep { defined $_->{Key} } @{ $EventsTicketCalendarSysConfig{Setting}->[1]->{Hash}->[1]->{Item} };

        # enable EventsTicketCalendar and set it to load as default plugin
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'DashboardBackend###0280-DashboardEventsTicketCalendar',
            Value => {
                %EventsTicketCalendarSysConfig,
                Default => 1,
                }
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
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

        # get dynamic field object
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        # check for event ticket calendar dynamic fields, if there are none create them
        my @DynamicFieldIDs;
        for my $DynamicFieldName (qw(TicketCalendarStartTime TicketCalendarEndTime)) {
            my $DynamicFieldExist = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicFieldName,
            );
            if ( !IsHashRefWithData($DynamicFieldExist) ) {
                my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
                    Name       => $DynamicFieldName,
                    Label      => $DynamicFieldName,
                    FieldOrder => 9991,
                    FieldType  => 'DateTime',
                    ObjectType => 'Ticket',
                    Config     => {
                        DefaultValue  => 0,
                        YearsInFuture => 0,
                        YearsInPast   => 0,
                        YearsPeriod   => 0,
                    },
                    ValidID => 1,
                    UserID  => $TestUserID,
                );
                $Self->True(
                    $DynamicFieldID,
                    "Dynamic field $DynamicFieldName - ID $DynamicFieldID - created",
                );

                push @DynamicFieldIDs, $DynamicFieldID;
            }
        }

        # create test ticket
        my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
            Title        => 'Ticket One Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customerOne@example.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Test ticket is created - $TicketID",
        );

        # get backend object
        my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # get time object
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

        # get current system time
        my $Now = $TimeObject->SystemTime();

        my %DynamicFieldValue = (
            TicketCalendarStartTime => $TimeObject->SystemTime2TimeStamp(
                SystemTime => $Now,
            ),
            TicketCalendarEndTime => $TimeObject->SystemTime2TimeStamp(
                SystemTime => $Now + 60 * 60,
            ),
        );

        # set value of ticket's dynamic fields
        for my $DynamicFieldName (qw(TicketCalendarStartTime TicketCalendarEndTime)) {

            my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicFieldName,
            );

            $BackendObject->ValueSet(
                DynamicFieldConfig => $DynamicField,
                ObjectID           => $TicketID,
                Value              => $DynamicFieldValue{$DynamicFieldName},
                UserID             => 1,
            );
        }

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to dashboard screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentDashboard");

        # test if link to test created ticket is available when only EventsTicketCalendar is valid plugin
        $Self->True(
            index( $Selenium->get_page_source(), "Action=AgentTicketZoom;TicketID=$TicketID" ) > -1,
            "Link to created test ticket ID - $TicketID - available on EventsTicketCalendar plugin",
        );

        # delete created test ticket
        my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Ticket with ticket id $TicketID is deleted"
        );

        # # delete created test calendar dynamic fields
        for my $DynamicFieldDelete (@DynamicFieldIDs) {
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldDelete,
                UserID => $TestUserID,
            );
            $Self->True(
                $Success,
                "Dynamic field - ID $DynamicFieldDelete - deleted",
            );
        }

        # make sure the cache is correct.
        for my $Cache (
            qw (Ticket DynamicField)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
