# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users', ],
);

my %Calendar = $Kernel::OM->Get('Kernel::System::Calendar')->CalendarCreate(
    CalendarName => 'Meetings' . $RandomID,
    GroupID      => 1,
    Color        => '#FF7700',
    ValidID      => 1,
    UserID       => $UserID,
);

my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

my $AppointmentID = $AppointmentObject->AppointmentCreate(
    CalendarID           => $Calendar{CalendarID},
    Title                => 'Webinar',
    Description          => 'How to use Process tickets...',
    Location             => 'Straubing',
    StartTime            => '2016-01-01 16:00:00',
    EndTime              => '2016-01-01 17:00:00',
    AllDay               => 0,
    Recurring            => 0,
    NotificationTime     => '2016-01-01 17:00:00',
    NotificationTemplate => 'Custom',
    NotificationCustom   => 'relative',
    UserID               => $UserID,
);

$Self->True(
    $AppointmentID,
    'AppointmentCreate()',
);

my %ExpectedDataRaw = $AppointmentObject->AppointmentGet(
    CalendarID    => $Calendar{CalendarID},
    AppointmentID => $AppointmentID,
    UserID        => $UserID,
);

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing CalendarID',
        Config => {
            Data => {
                AppointmentID => $AppointmentID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing AppointmentID',
        Config => {
            Data => {
                CalendarID => $Calendar{CalendarID},
            },
        },
        Success => 0,
    },

    {
        Name   => 'Success',
        Config => {
            Data => {
                CalendarID    => $Calendar{CalendarID},
                AppointmentID => $AppointmentID,
            },
        },
        Success => 1,
    },
);

my $BackedObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::ObjectType::Appointment');

TEST:
for my $Test (@Tests) {

    my %ObjectData = $BackedObject->DataGet( %{ $Test->{Config} } );

    my %ExpectedData;
    if ( $Test->{Success} ) {
        %ExpectedData = %ExpectedDataRaw;
    }

    $Self->IsDeeply(
        \%ObjectData,
        \%ExpectedData,
        "$Test->{Name} DataGet()"
    );
}

# Cleanup is done by RestoreDatabase.
1;
