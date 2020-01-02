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

my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');
my %Calendar       = $CalendarObject->CalendarCreate(
    CalendarName => 'Meetings' . $RandomID,
    GroupID      => 1,
    Color        => '#FF7700',
    ValidID      => 1,
    UserID       => $UserID,
);
$Self->True(
    $Calendar{CalendarID},
    'CalendarCreate()',
);

my %ExpectedDataRaw = $CalendarObject->CalendarGet(
    CalendarID => $Calendar{CalendarID},
    UserID     => $UserID,
);

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Success',
        Config => {
            Data => {
                CalendarID => $Calendar{CalendarID},
            },
        },
        Success => 1,
    },
);

my $BackedObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::ObjectType::Calendar');

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
