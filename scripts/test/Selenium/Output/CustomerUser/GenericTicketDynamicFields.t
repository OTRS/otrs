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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper                    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');
        my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $RandomNumber = $Helper->GetRandomNumber();

        # Create test user.
        my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Get test customer user ID.
        my @CustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
            User => $TestCustomerUserLogin,
        );
        my $CustomerID = $CustomerIDs[0];

        # Create dynamic fields.
        my @Properties = (
            {
                Name       => "Text$RandomNumber",
                FieldOrder => 9991,
                FieldType  => 'Text',
                Config     => {
                    DefaultValue => '',
                },
            },
            {
                Name       => "TextArea$RandomNumber",
                FieldOrder => 9992,
                FieldType  => 'TextArea',
                Config     => {
                    DefaultValue => '',
                },
            },
            {
                Name       => "Dropdown$RandomNumber",
                FieldOrder => 9993,
                FieldType  => 'Dropdown',
                Config     => {
                    DefaultValue   => '',
                    Link           => '',
                    PossibleNone   => 0,
                    PossibleValues => {
                        A1 => 'A1',
                        B1 => 'B1',
                        C1 => 'C1',
                    },
                },
            },
            {
                Name       => "Multiselect$RandomNumber",
                FieldOrder => 9994,
                FieldType  => 'Multiselect',
                Config     => {
                    DefaultValue   => '',
                    Link           => '',
                    PossibleNone   => 0,
                    PossibleValues => {
                        A2 => 'A2',
                        B2 => 'B2',
                        C2 => 'C2',
                    },
                },
            },
            {
                Name       => "Date$RandomNumber",
                FieldOrder => 9995,
                FieldType  => 'Date',
                Config     => {
                    DefaultValue  => 0,
                    YearsInFuture => 0,
                    YearsInPast   => 0,
                    YearsPeriod   => 0,
                },
            },
            {
                Name       => "DateTime$RandomNumber",
                FieldOrder => 9996,
                FieldType  => 'DateTime',
                Config     => {
                    DefaultValue  => 0,
                    YearsInFuture => 0,
                    YearsInPast   => 0,
                    YearsPeriod   => 0,
                },
            },
            {
                Name       => "Checkbox$RandomNumber",
                FieldOrder => 9997,
                FieldType  => 'Checkbox',
                Config     => {
                    DefaultValue => '',
                },
            },
        );

        my @DynamicFields;

        for my $Property (@Properties) {
            my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
                %{$Property},
                Label      => 'Description - ' . $Property->{FieldType},
                ObjectType => 'Ticket',
                ValidID    => 1,
                UserID     => 1,
                Reorder    => 0,
            );
            $Self->True(
                $FieldID,
                "DynamicFieldID $FieldID is created.",
            );

            push @DynamicFields, $DynamicFieldObject->DynamicFieldGet(
                ID => $FieldID,
            );
        }

        # Create test tickets.
        my @TicketIDs;
        for my $Number ( 1 .. 5 ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => "Ticket No. $Number - $RandomNumber",
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerID   => $CustomerID,
                CustomerUser => $TestCustomerUserLogin,
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );
            $Self->True(
                $TicketID,
                "TicketID $TicketID is created.",
            );
            push @TicketIDs, $TicketID;
        }

        # Set dynamic fields.
        my @Settings = (
            {
                DynamicFieldConfig => $DynamicFields[0],
                Values             => [
                    {
                        ObjectID => $TicketIDs[0],
                        Value    => "test123-$RandomNumber",
                    },
                    {
                        ObjectID => $TicketIDs[1],
                        Value    => "test12-$RandomNumber",
                    },
                    {
                        ObjectID => $TicketIDs[2],
                        Value    => "test12-$RandomNumber",
                    },
                ],
            },
            {
                DynamicFieldConfig => $DynamicFields[1],
                Values             => [
                    {
                        ObjectID => $TicketIDs[0],
                        Value    => "test456-$RandomNumber",
                    },
                    {
                        ObjectID => $TicketIDs[1],
                        Value    => "test45-$RandomNumber",
                    },
                    {
                        ObjectID => $TicketIDs[2],
                        Value    => "test45-$RandomNumber",
                    },
                ],
            },
            {
                DynamicFieldConfig => $DynamicFields[2],
                Values             => [
                    {
                        ObjectID => $TicketIDs[0],
                        Value    => 'A1',
                    },
                    {
                        ObjectID => $TicketIDs[1],
                        Value    => 'A1',
                    },
                    {
                        ObjectID => $TicketIDs[2],
                        Value    => 'B1',
                    },
                    {
                        ObjectID => $TicketIDs[3],
                        Value    => 'C1',
                    },
                ],
            },
            {
                DynamicFieldConfig => $DynamicFields[3],
                Values             => [
                    {
                        ObjectID => $TicketIDs[0],
                        Value    => [ 'A2', 'B2' ],
                    },
                    {
                        ObjectID => $TicketIDs[1],
                        Value    => ['B2'],
                    },
                    {
                        ObjectID => $TicketIDs[2],
                        Value    => [ 'B2', 'C2' ],
                    },
                    {
                        ObjectID => $TicketIDs[3],
                        Value    => ['C2'],
                    },
                ],
            },
            {
                DynamicFieldConfig => $DynamicFields[4],
                Values             => [
                    {
                        ObjectID => $TicketIDs[0],
                        Value    => '2019-12-12',
                    },
                    {
                        ObjectID => $TicketIDs[1],
                        Value    => '2019-12-12',
                    },
                    {
                        ObjectID => $TicketIDs[2],
                        Value    => '2019-12-10',
                    },
                    {
                        ObjectID => $TicketIDs[3],
                        Value    => '2019-12-10',
                    },
                    {
                        ObjectID => $TicketIDs[4],
                        Value    => '2019-12-02',
                    },
                ],
            },
            {
                DynamicFieldConfig => $DynamicFields[5],
                Values             => [
                    {
                        ObjectID => $TicketIDs[0],
                        Value    => '2019-12-12 10:00:00',
                    },
                    {
                        ObjectID => $TicketIDs[1],
                        Value    => '2019-12-12 10:00:00',
                    },
                    {
                        ObjectID => $TicketIDs[2],
                        Value    => '2019-12-10 10:00:00',
                    },
                    {
                        ObjectID => $TicketIDs[3],
                        Value    => '2019-12-10 10:00:00',
                    },
                    {
                        ObjectID => $TicketIDs[4],
                        Value    => '2019-12-02 10:00:00',
                    },
                ],
            },
            {
                DynamicFieldConfig => $DynamicFields[6],
                Values             => [
                    {
                        ObjectID => $TicketIDs[0],
                        Value    => '0',
                    },
                    {
                        ObjectID => $TicketIDs[1],
                        Value    => '1',
                    },
                    {
                        ObjectID => $TicketIDs[2],
                        Value    => '1',
                    },
                    {
                        ObjectID => $TicketIDs[3],
                        Value    => '0',
                    },
                    {
                        ObjectID => $TicketIDs[4],
                        Value    => '1',
                    },
                ],
            },
        );

        for my $Setting (@Settings) {
            for my $Values ( @{ $Setting->{Values} } ) {
                my $Success = $DynamicFieldBackendObject->ValueSet(
                    DynamicFieldConfig => $Setting->{DynamicFieldConfig},
                    ObjectID           => $Values->{ObjectID},
                    Value              => $Values->{Value},
                    UserID             => 1,
                );
                $Self->True(
                    $Success,
                    "Dynamic field value for '$Setting->{DynamicFieldConfig}->{Name}' is set successfully.",
                );
            }
        }

        my $SysConfigName = 'Frontend::CustomerUser::Item###15-OpenTickets';

        my %SysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => $SysConfigName,
            Default => 1,
        );

        my $OpenTicketsText = $SysConfig{EffectiveValue}->{Text};

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Define tests.
        my @Tests = (
            {
                Description => "Dynamic field - $DynamicFields[0]->{Name}, search value - test123-$RandomNumber",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[0]->{Name};Search_DynamicField_$DynamicFields[0]->{Name}=test123-$RandomNumber;",
                Count => 1,
            },
            {
                Description => "Dynamic field - $DynamicFields[0]->{Name}, search value - test12-$RandomNumber",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[0]->{Name};Search_DynamicField_$DynamicFields[0]->{Name}=test12-$RandomNumber;",
                Count => 2,
            },
            {
                Description => "Dynamic field - $DynamicFields[0]->{Name}, search value - test12*",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[0]->{Name};Search_DynamicField_$DynamicFields[0]->{Name}=test12*;",
                Count => 3,
            },
            {
                Description => "Dynamic field - $DynamicFields[1]->{Name}, search value - test456-$RandomNumber",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[1]->{Name};Search_DynamicField_$DynamicFields[1]->{Name}=test456-$RandomNumber;",
                Count => 1,
            },
            {
                Description => "Dynamic field - $DynamicFields[1]->{Name}, search value - test45-$RandomNumber",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[1]->{Name};Search_DynamicField_$DynamicFields[1]->{Name}=test45-$RandomNumber;",
                Count => 2,
            },
            {
                Description => "Dynamic field - $DynamicFields[1]->{Name}, search value - test45*",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[1]->{Name};Search_DynamicField_$DynamicFields[1]->{Name}=test45*;",
                Count => 3,
            },
            {
                Description => "Dynamic field - $DynamicFields[2]->{Name}, search value - A1",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[2]->{Name};Search_DynamicField_$DynamicFields[2]->{Name}=A1;",
                Count => 2,
            },
            {
                Description => "Dynamic field - $DynamicFields[2]->{Name}, search value - B1",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[2]->{Name};Search_DynamicField_$DynamicFields[2]->{Name}=B1;",
                Count => 1,
            },
            {
                Description => "Dynamic field - $DynamicFields[2]->{Name}, search values - A1, C1",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[2]->{Name};Search_DynamicField_$DynamicFields[2]->{Name}=A1;Search_DynamicField_$DynamicFields[2]->{Name}=C1;",
                Count => 3,
            },
            {
                Description => "Dynamic field - $DynamicFields[2]->{Name}, search values - A1, B1, C1",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[2]->{Name};Search_DynamicField_$DynamicFields[2]->{Name}=A1;Search_DynamicField_$DynamicFields[2]->{Name}=B1;Search_DynamicField_$DynamicFields[2]->{Name}=C1;",
                Count => 4,
            },
            {
                Description => "Dynamic field - $DynamicFields[3]->{Name}, search value - A2, C2",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[3]->{Name};Search_DynamicField_$DynamicFields[3]->{Name}=A2;Search_DynamicField_$DynamicFields[3]->{Name}=C2;",
                Count => 3,
            },
            {
                Description => "Dynamic field - $DynamicFields[3]->{Name}, search value - B2",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[3]->{Name};Search_DynamicField_$DynamicFields[3]->{Name}=B2;",
                Count => 3,
            },
            {
                Description => "Dynamic field - $DynamicFields[3]->{Name}, search value - B2, C2",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[3]->{Name};Search_DynamicField_$DynamicFields[3]->{Name}=B2;Search_DynamicField_$DynamicFields[3]->{Name}=C2;",
                Count => 4,
            },
            {
                Description =>
                    "Dynamic field - $DynamicFields[4]->{Name}, search value - between 2019-12-01 and 2019-12-11",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[4]->{Name}TimeSlot;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlot=1;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStartYear=2019;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStartMonth=12;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStartDay=01;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStartHour=00;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStartMinute=00;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStartSecond=00;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStopYear=2019;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStopMonth=12;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStopDay=11;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStopHour=23;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStopMinute=59;"
                    . "Search_DynamicField_$DynamicFields[4]->{Name}TimeSlotStopSecond=59;",
                Count => 3,
            },
            {
                Description =>
                    "Dynamic field - $DynamicFields[5]->{Name}, search value - between 2019-12-10 09:00 and 2019-12-12 11:00",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[5]->{Name}TimeSlot;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlot=1;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartYear=2019;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartMonth=12;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartDay=10;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartHour=09;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartMinute=00;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartSecond=00;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopYear=2019;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopMonth=12;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopDay=12;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopHour=11;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopMinute=00;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopSecond=59;",
                Count => 4,
            },
            {
                Description =>
                    "Dynamic field - $DynamicFields[5]->{Name}, search value - between 2019-12-10 11:00 and 2019-12-12 11:00",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[5]->{Name}TimeSlot;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlot=1;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartYear=2019;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartMonth=12;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartDay=10;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartHour=11;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartMinute=00;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStartSecond=00;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopYear=2019;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopMonth=12;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopDay=12;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopHour=11;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopMinute=00;"
                    . "Search_DynamicField_$DynamicFields[5]->{Name}TimeSlotStopSecond=59;",
                Count => 2,
            },
            {
                Description => "Dynamic field - $DynamicFields[6]->{Name}, search value - 0 (unchecked)",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[6]->{Name};Search_DynamicField_$DynamicFields[6]->{Name}=0;",
                Count => 2,
            },
            {
                Description => "Dynamic field - $DynamicFields[6]->{Name}, search value - 1 (checked)",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[6]->{Name};Search_DynamicField_$DynamicFields[6]->{Name}=1;",
                Count => 3,
            },
            {
                Description => "Dynamic field - $DynamicFields[6]->{Name}, search value - 1 (checked)",
                Attributes =>
                    "ShownAttributes=LabelSearch_DynamicField_$DynamicFields[6]->{Name};Search_DynamicField_$DynamicFields[6]->{Name}=0;Search_DynamicField_$DynamicFields[6]->{Name}=1;",
                Count => 5,
            },
        );

        # Run tests.
        for my $Test (@Tests) {

            $SysConfig{EffectiveValue}->{Attributes} = 'States=open;' . $Test->{Attributes};

            # Set Attributes.
            my $Success = $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => $SysConfigName,
                Value => $SysConfig{EffectiveValue},
            );
            $Self->True(
                $Success,
                "Setting '$SysConfigName' is updated successfully.",
            );

            # Clean up 'TicketSearch' cache type to be sure that search result is fresh.
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => 'TicketSearch',
            );

            # Go to AgentTicketZoom of the first test ticket.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('.ItemRow a.OpenTicket:contains(\"$OpenTicketsText ($Test->{Count})\")').length;"
            );

            $Self->True(
                $Selenium->execute_script(
                    "return \$('.ItemRow a.OpenTicket:contains(\"$OpenTicketsText ($Test->{Count})\")').length;"
                ),
                "$Test->{Description}, COUNT - $Test->{Count} - correct.",
            );
        }

        # Delete test tickets.
        for my $TicketID (@TicketIDs) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "TicketID $TicketID is deleted.",
            );
        }

        # Delete test dynamic fields.
        for my $DynamicField (@DynamicFields) {
            my $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicField->{ID},
                UserID => $TestUserID,
            );
            $Self->True(
                $Success,
                "DynamicFieldID $DynamicField->{ID} is deleted."
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(Ticket CustomerUser)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
