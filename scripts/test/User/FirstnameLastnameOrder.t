# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# create non existing user login
my $UserRand1;
TRY:
for my $Try ( 1 .. 20 ) {

    $UserRand1 = 'unittest-' . time() . int rand 1_000_000;

    my $UserID = $UserObject->UserLookup(
        UserLogin => $UserRand1,
    );

    last TRY if !$UserID;

    next TRY if $Try ne 20;

    $Self->True(
        0,
        'Find non existing user login.',
    );
}

# add user
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
