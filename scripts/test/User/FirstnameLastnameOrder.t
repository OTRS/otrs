# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
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
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
my $CustomerUserObject   = $Kernel::OM->Get('Kernel::System::CustomerUser');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $UserRandom = 'unittest-' . $Helper->GetRandomID();
my $UserID = $UserObject->UserAdd(
    UserFirstname => 'John',
    UserLastname  => 'Doe',
    UserLogin     => $UserRandom,
    UserEmail     => $UserRandom . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID,
    'UserAdd()',
);

my $CustomerUserLogin= $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'John',
    UserLastname   => 'Doe',
    UserCustomerID => 'johndoe',
    UserLogin      => $UserRandom,
    UserEmail      => $UserRandom . '@example.com',
    ValidID        => 1,
    UserID         => 1,
);

$Self->True(
    $CustomerUserLogin,
    'CustomerUserAdd()',
);


my %Tests = (
    0 => "John Doe",
    1 => "Doe, John",
    2 => "John Doe ($UserRandom)",
    3 => "Doe, John ($UserRandom)",
    4 => "($UserRandom) John Doe",
    5 => "($UserRandom) Doe, John",
    6 => "Doe John",
    7 => "Doe John ($UserRandom)",
    8 => "($UserRandom) Doe John",
    9 => "DoeJohn", # chinese
);

for my $Order ( sort keys %Tests ) {
    $ConfigObject->Set(
        Key   => 'FirstnameLastnameOrder',
        Value => $Order,
    );
    $Self->Is(
        $UserObject->UserName( UserID => $UserID ),
        $Tests{$Order},
        "UserName FirstnameLastnameOrder $Order",
    );
    $Self->Is(
        $CustomerUserObject->CustomerName( UserLogin => $CustomerUserLogin ),
        $Tests{$Order},
        "CustomerName FirstnameLastnameOrder $Order",
    );
}

# cleanup is done by RestoreDatabase.

1;
