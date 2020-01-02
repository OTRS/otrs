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
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
my $UserObject        = $Kernel::OM->Get('Kernel::System::User');

# create test user
my ( $UserLogin, $UserID ) = $Helper->TestUserCreate();

$Self->True(
    $UserID,
    "Test user $UserID created",
);

my $RandomID = $Helper->GetRandomID();

# create test group
my $GroupName = 'test-calendar-group-' . $RandomID;
my $GroupID   = $GroupObject->GroupAdd(
    Name    => $GroupName,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID,
    "Test group $GroupID created",
);

# add test user to test group
my $Success = $GroupObject->PermissionGroupUserAdd(
    GID        => $GroupID,
    UID        => $UserID,
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

$Self->True(
    $Success,
    "Test user $UserID added to test group $GroupID",
);

my @CalendarIDs;

#
# Tests for CalendarCreate()
#
my @Tests = (
    {
        Name    => 'CalendarCreate - No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'CalendarCreate - Missing CalendarName',
        Config => {
            Color   => '#3A87AD',
            GroupID => $GroupID,
            UserID  => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarCreate - Missing UserID',
        Config => {
            CalendarName => "Calendar-$RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarCreate - Missing GroupID',
        Config => {
            CalendarName => "Calendar-$RandomID",
            Color        => '#3A87AD',
            UserID       => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarCreate - Missing Color',
        Config => {
            CalendarName => "Calendar-$RandomID",
            GroupID      => $GroupID,
            UserID       => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarCreate - Wrong Color',
        Config => {
            CalendarName => "Calendar-$RandomID",
            Color        => 'red',
            GroupID      => $GroupID,
            UserID       => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarCreate - All required parameters',
        Config => {
            CalendarName => "Calendar-$RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'CalendarCreate - Same name',
        Config => {
            CalendarName => "Calendar-$RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarCreate - Invalid state',
        Config => {
            CalendarName => "Calendar-$RandomID-2",
            Color        => '#EC9073',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 2,
        },
        Success => 1,
    },
    {
        Name   => 'CalendarCreate - Optional parameters',
        Config => {
            CalendarName       => "Calendar-$RandomID-3",
            Color              => '#3A87AD',
            GroupID            => $GroupID,
            UserID             => $UserID,
            TicketAppointments => [
                {
                    StartDate    => 'FirstResponse',
                    EndDate      => 'Plus_5',
                    QueueID      => [2],
                    SearchParams => {
                        Title => 'This is a title',
                        Types => 'This is a type',
                    },
                },
            ],
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    # make the call
    my %Calendar = $CalendarObject->CalendarCreate(
        %{ $Test->{Config} },
    );

    # check data
    if ( $Test->{Success} ) {
        for my $Key (qw(CalendarID GroupID CalendarName Color CreateTime CreateBy ChangeTime ChangeBy ValidID)) {
            $Self->True(
                $Calendar{$Key},
                "$Test->{Name} - $Key exists",
            );
        }

        KEY:
        for my $Key ( sort keys %{ $Test->{Config} } ) {
            next KEY if $Key eq 'UserID';

            $Self->IsDeeply(
                $Test->{Config}->{$Key},
                $Calendar{$Key},
                "$Test->{Name} - Data for $Key",
            );
        }

        push @CalendarIDs, $Calendar{CalendarID};
    }
    else {
        $Self->False(
            $Calendar{CalendarID},
            "$Test->{Name} - No success",
        );
    }
}

#
# Tests for CalendarGet()
#
@Tests = (
    {
        Name    => 'CalendarGet - No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'CalendarGet - Missing CalendarName and CalendarID',
        Config => {
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarGet - First calendar',
        Config => {
            CalendarName => "Calendar-$RandomID",
            UserID       => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'CalendarGet - Second calendar',
        Config => {
            CalendarName => "Calendar-$RandomID-2",
            UserID       => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'CalendarGet - Third calendar',
        Config => {
            CalendarName => "Calendar-$RandomID-3",
            UserID       => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    # make the call
    my %Calendar = $CalendarObject->CalendarGet(
        %{ $Test->{Config} },
    );

    # check data
    if ( $Test->{Success} ) {
        for my $Key (qw(CalendarID GroupID CalendarName Color CreateTime CreateBy ChangeTime ChangeBy ValidID)) {
            $Self->True(
                $Calendar{$Key},
                "$Test->{Name} - $Key exists",
            );
        }

        # get by id
        my %CalendarByID = $CalendarObject->CalendarGet(
            CalendarID => $Calendar{CalendarID},
        );

        # compare returned data
        $Self->IsDeeply(
            \%Calendar,
            \%CalendarByID,
            "$Test->{Name} - Get by CalendarID",
        );
    }
    else {
        $Self->False(
            $Calendar{CalendarID},
            "$Test->{Name} - No success",
        );
    }
}

#
# Tests for CalendarList()
#
@Tests = (
    {
        Name    => 'CalendarList - No params',
        Config  => {},
        Success => 1,
    },
    {
        Name   => 'CalendarList - With UserID',
        Config => {
            UserID => $UserID,
        },
        Success => 1,
        Count   => 3,
    },
    {
        Name   => 'CalendarList - With UserID and only valid',
        Config => {
            ValidID => 1,
            UserID  => $UserID,
        },
        Success => 1,
        Count   => 2,
    },
    {
        Name   => 'CalendarList - With UserID and only invalid',
        Config => {
            ValidID => 2,
            UserID  => $UserID,
        },
        Success => 1,
        Count   => 1,
    },
);

for my $Test (@Tests) {

    # make the call
    my @Result = $CalendarObject->CalendarList(
        %{ $Test->{Config} },
    );

    # check data
    if ( $Test->{Success} ) {

        # check count
        if ( $Test->{Count} ) {
            $Self->Is(
                scalar @Result,
                $Test->{Count},
                "$Test->{Name} - Result count",
            );

            # compare returned data
            for my $Calendar (@Result) {
                for my $Key (qw(CalendarID GroupID CalendarName Color CreateTime CreateBy ChangeTime ChangeBy ValidID))
                {
                    $Self->True(
                        $Calendar->{$Key},
                        "$Test->{Name} - $Key exists",
                    );
                }

                # get by id
                my %CalendarByID = $CalendarObject->CalendarGet(
                    CalendarID => $Calendar->{CalendarID},
                );

                delete $CalendarByID{TicketAppointments};

                $Self->IsDeeply(
                    $Calendar,
                    \%CalendarByID,
                    "$Test->{Name} - Compare returned data",
                );
            }
        }
        else {
            $Self->True(
                scalar @Result > 1,
                "$Test->{Name} - Has result",
            );
        }
    }
    else {
        $Self->False(
            @Result,
            "$Test->{Name} - No success",
        );
    }
}

#
# Tests for CalendarUpdate()
#
@Tests = (
    {
        Name    => 'CalendarUpdate - No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'CalendarUpdate - Missing CalendarID',
        Config => {
            GroupID      => $GroupID,
            CalendarName => "Change-$RandomID",
            Color        => '#FF9900',
            UserID       => $UserID,
            ValidID      => 2,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarUpdate - Missing GroupID',
        Config => {
            CalendarID   => $CalendarIDs[0],
            CalendarName => "Change-$RandomID",
            Color        => '#FF9900',
            UserID       => $UserID,
            ValidID      => 2,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarUpdate - Missing CalendarName',
        Config => {
            CalendarID => $CalendarIDs[0],
            GroupID    => $GroupID,
            Color      => '#FF9900',
            UserID     => $UserID,
            ValidID    => 2,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarUpdate - Missing Color',
        Config => {
            CalendarID   => $CalendarIDs[0],
            GroupID      => $GroupID,
            CalendarName => "Change-$RandomID",
            UserID       => $UserID,
            ValidID      => 2,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarUpdate - Missing UserID',
        Config => {
            CalendarID   => $CalendarIDs[0],
            GroupID      => $GroupID,
            CalendarName => "Change-$RandomID",
            Color        => '#FF9900',
            ValidID      => 2,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarUpdate - Missing ValidID',
        Config => {
            CalendarID   => $CalendarIDs[0],
            GroupID      => $GroupID,
            CalendarName => "Change-$RandomID",
            Color        => '#FF9900',
            UserID       => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarUpdate - All required params first',
        Config => {
            CalendarID   => $CalendarIDs[0],
            GroupID      => $GroupID,
            CalendarName => "Change-$RandomID",
            Color        => '#FF9900',
            UserID       => $UserID,
            ValidID      => 2,
        },
        Success => 1,
    },
    {
        Name   => 'CalendarUpdate - All required and an optional param second',
        Config => {
            CalendarID         => $CalendarIDs[1],
            GroupID            => $GroupID,
            CalendarName       => "Change-$RandomID-2",
            Color              => '#FF9900',
            TicketAppointments => [
                {
                    StartDate    => 'FirstResponse',
                    EndDate      => 'Plus_5',
                    QueueID      => 2,
                    SearchParams => {
                        Title => 'This is a title',
                        Types => 'This is a type',
                    },
                },
            ],
            UserID  => $UserID,
            ValidID => 1,
        },
        Success => 1,
    },
    {
        Name   => 'CalendarUpdate - All required and an optional param third',
        Config => {
            CalendarID         => $CalendarIDs[1],
            GroupID            => $GroupID,
            CalendarName       => "Change-$RandomID-2",
            Color              => '#FF9900',
            TicketAppointments => undef,
            UserID             => $UserID,
            ValidID            => 1,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    # make the call
    my $Success = $CalendarObject->CalendarUpdate(
        %{ $Test->{Config} },
    );

    # check data
    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} - Success",
        );

        # get by id
        my %Calendar = $CalendarObject->CalendarGet(
            CalendarID => $Test->{Config}->{CalendarID},
        );

        KEY:
        for my $Key ( sort keys %{ $Test->{Config} } ) {
            next KEY if $Key eq 'UserID';

            $Self->IsDeeply(
                $Test->{Config}->{$Key},
                $Calendar{$Key},
                "$Test->{Name} - Data for $Key",
            );
        }
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} - No success",
        );
    }
}

#
# Tests for CalendarPermissionGet()
#
@Tests = (
    {
        Name    => 'CalendarPermissionGet - No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'CalendarPermissionGet - Missing CalendarID',
        Config => {
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarPermissionGet - Missing UserID',
        Config => {
            CalendarID => $CalendarIDs[0],
        },
        Success => 0,
    },
    {
        Name   => 'CalendarPermissionGet - All params first',
        Config => {
            CalendarID => $CalendarIDs[0],
            UserID     => $UserID,
        },
        Success => 1,
        Result  => 'rw',
    },
    {
        Name   => 'CalendarPermissionGet - All params second',
        Config => {
            CalendarID => $CalendarIDs[1],
            UserID     => $UserID,
        },
        Success => 1,
        Result  => 'rw',
    },
);

for my $Test (@Tests) {

    # make the call
    my $Permission = $CalendarObject->CalendarPermissionGet(
        %{ $Test->{Config} },
    );

    # check permission
    if ( $Test->{Success} ) {
        $Self->Is(
            $Permission,
            $Test->{Result},
            "$Test->{Name} - Permission",
        );
    }
    else {
        $Self->False(
            $Permission,
            "$Test->{Name} - No success",
        );
    }
}

#
# Tests for GetTextColor()
#
@Tests = (
    {
        Name    => 'GetTextColor - No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'GetTextColor - Invalid color',
        Config => {
            Background => '#CCCCC',
        },
        Success => 0,
    },
    {
        Name   => 'GetTextColor - White',
        Config => {
            Background => '#FFF',
        },
        Success => 1,
        Result  => '#000',
    },
    {
        Name   => 'GetTextColor - Light Gray',
        Config => {
            Background => '#808080',
        },
        Success => 1,
        Result  => '#000',
    },
    {
        Name   => 'GetTextColor - Dark Gray',
        Config => {
            Background => '#797979',
        },
        Success => 1,
        Result  => '#FFFFFF',
    },
    {
        Name   => 'GetTextColor - Black',
        Config => {
            Background => '#000',
        },
        Success => 1,
        Result  => '#FFFFFF',
    },
);

for my $Test (@Tests) {

    # make the call
    my $TextColor = $CalendarObject->GetTextColor(
        %{ $Test->{Config} },
    );

    # check text color
    if ( $Test->{Success} ) {
        $Self->Is(
            $TextColor,
            $Test->{Result},
            "$Test->{Name} - Text color",
        );
    }
    else {
        $Self->False(
            $TextColor,
            "$Test->{Name} - No success",
        );
    }
}

#
# Tests for CalendarExport() and CalendarImport()
#
@Tests = (
    {
        Name    => 'CalendarExport/Import - No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'CalendarExport/Import - No CalendarData',
        Config => {
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'CalendarExport/Import - All params with overwrite',
        Export => {
            CalendarID => $CalendarIDs[2],
            UserID     => $UserID,
        },
        Config => {
            UserID                    => $UserID,
            OverwriteExistingEntities => 1,
        },
        Appointments => [
            {
                CalendarID => $CalendarIDs[2],
                Title      => "Appointment1-$RandomID",
                StartTime  => '2016-01-01 16:00:00',
                EndTime    => '2016-01-01 17:00:00',
                UserID     => $UserID,
            },
            {
                CalendarID => $CalendarIDs[2],
                Title      => "Appointment2-$RandomID",
                StartTime  => '2016-01-01 16:00:00',
                EndTime    => '2016-01-01 17:00:00',
                UserID     => $UserID,
            },
        ],
        Success => 1,
    },
);

for my $Test (@Tests) {

    # create appointments
    if ( $Test->{Appointments} ) {
        for my $Appointment ( @{ $Test->{Appointments} } ) {
            my $AppointmentID = $AppointmentObject->AppointmentCreate(
                %{$Appointment},
            );
            $Self->True(
                $AppointmentID,
                "$Test->{Name} - Created appointment ($AppointmentID)",
            );
        }
    }

    # export calendar
    if ( $Test->{Export} ) {
        my %Data = $CalendarObject->CalendarExport(
            %{ $Test->{Export} },
        );

        $Test->{Config}->{Data} = \%Data;
    }

    # make the call
    my $Success = $CalendarObject->CalendarImport(
        %{ $Test->{Config} },
    );

    # check result
    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} - Success",
        );

        my %Calendar = $CalendarObject->CalendarGet(
            %{ $Test->{Export} },
        );

        # reset CreateTime and ChangeTime since they might differ
        for my $Key (qw(CreateTime ChangeTime)) {
            $Calendar{$Key} = undef;
            $Test->{Config}->{Data}->{CalendarData}->{$Key} = undef;
        }

        $Self->IsDeeply(
            \%Calendar,
            $Test->{Config}->{Data}->{CalendarData},
            "$Test->{Name} - Calendar data",
        );

        my @Appointments = $AppointmentObject->AppointmentList(
            %{ $Test->{Export} },
            Result => 'ARRAY',
        );

        my @AppointmentData;
        for my $AppointmentID (@Appointments) {
            my %Appointment = $AppointmentObject->AppointmentGet(
                AppointmentID => $AppointmentID,
            );
            $Appointment{AppointmentID} = undef;

            # reset CreateTime and ChangeTime since they might differ
            for my $Key (qw(CreateTime ChangeTime)) {
                $Appointment{$Key} = undef;
            }

            push @AppointmentData, \%Appointment;
        }

        for my $Appointment ( @{ $Test->{Config}->{Data}->{AppointmentData} } ) {
            $Appointment->{AppointmentID} = undef;

            # reset CreateTime and ChangeTime since they might differ
            for my $Key (qw(CreateTime ChangeTime)) {
                $Appointment->{$Key} = undef;
            }
        }

        $Self->IsDeeply(
            \@AppointmentData,
            $Test->{Config}->{Data}->{AppointmentData},
            "$Test->{Name} - Appointment data",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} - No success",
        );
    }
}

1;
