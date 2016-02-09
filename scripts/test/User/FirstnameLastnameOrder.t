# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TimeObject   = $Kernel::OM->Get('Kernel::System::Time');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# add users
my $UserRand1 = 'example-user' . int( rand(1000000) );

my $UserID = $UserObject->UserAdd(
    UserFirstname => 'John',
    UserLastname  => 'Doe',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID,
    'UserAdd()',
);

my %Tests = (
    0 => "John Doe",
    1 => "Doe, John",
    2 => "John Doe ($UserRand1)",
    3 => "Doe, John ($UserRand1)",
    4 => "($UserRand1) John Doe",
    5 => "($UserRand1) Doe, John",
    6 => "Doe John",
    7 => "Doe John ($UserRand1)",
    8 => "($UserRand1) Doe John",

);

for my $Order ( sort keys %Tests ) {
    $ConfigObject->Set(
        Key   => 'FirstnameLastnameOrder',
        Value => $Order,
    );
    $Self->Is(
        $UserObject->UserName( UserID => $UserID ),
        $Tests{$Order},
        "FirstnameLastnameOrder $Order",
    );
}

1;
