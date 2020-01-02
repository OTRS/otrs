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

use Kernel::System::VariableCheck (qw(IsHashRefWithData));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed object

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # disable all dashboard plugins
        my $Config = $ConfigObject->Get('DashboardBackend');
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => \%$Config,
        );

        my %EventsTicketCalendarSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'DashboardBackend###0280-DashboardEventsTicketCalendar',
            Default => 1,
        );

        # enable EventsTicketCalendar and set it to load as default plugin
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0280-DashboardEventsTicketCalendar',
            Value => {
                %{ $EventsTicketCalendarSysConfig{EffectiveValue} },
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
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
            "Ticket is created - ID $TicketID",
        );

        # get backend object
        my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # create datetime object
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        my %DynamicFieldValue = (
            TicketCalendarStartTime => $DateTimeObject->ToString(),
            TicketCalendarEndTime   => $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    Epoch => $DateTimeObject->ToEpoch() + 60 * 60,
                }
            )->ToString(),
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

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentDashboard screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # test if link to test created ticket is available when only EventsTicketCalendar is valid plugin
        $Self->True(
            index( $Selenium->get_page_source(), "Action=AgentTicketZoom;TicketID=$TicketID" ) > -1,
            "Link to created test ticket ID - $TicketID - available on EventsTicketCalendar plugin",
        );

        # delete created test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
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
            "Ticket with ticket ID $TicketID is deleted"
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

        # make sure the cache is correct
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
