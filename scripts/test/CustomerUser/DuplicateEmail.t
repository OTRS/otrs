# --
# DuplicateEmail.t - CustomerUser tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::CustomerUser;

# create local objects
my $ConfigObject = Kernel::Config->new();

# add two users
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $DatabaseCaseSensitive                = $Self->{DBObject}->{Backend}->{'DB::CaseSensitive'};
my $CustomerDatabaseCaseSensitiveDefault = $ConfigObject->{CustomerUser}->{Params}->{CaseSensitive};

my $CustomerUserObject = Kernel::System::CustomerUser->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my @CustomerLogins;
my $Rand = int( rand(1000000) );
for my $Key ( 1 .. 2 ) {
    my $UserRand = 'Duplicate' . $Key . $Rand;

    my $UserID = $CustomerUserObject->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => 'Firstname Test' . $Key,
        UserLastname   => 'Lastname Test' . $Key,
        UserCustomerID => $UserRand . '-Customer-Id',
        UserLogin      => $UserRand,
        UserEmail      => $UserRand . '-Email@example.com',
        UserPassword   => 'some_pass',
        ValidID        => 1,
        UserID         => 1,
    );
    push @CustomerLogins, $UserID;

    $Self->True(
        $UserID,
        "CustomerUserAdd() - $UserID",
    );

    my $Update = $CustomerUserObject->CustomerUserUpdate(
        Source         => 'CustomerUser',
        ID             => $UserRand,
        UserFirstname  => 'Firstname Test Update' . $Key,
        UserLastname   => 'Lastname Test Update' . $Key,
        UserCustomerID => $UserRand . '-Customer-Update-Id',
        UserLogin      => $UserRand,
        UserEmail      => $UserRand . '-Update@example.com',
        ValidID        => 1,
        UserID         => 1,
    );
    $Self->True(
        $Update,
        "CustomerUserUpdate$Key() - $UserID",
    );
}

print @CustomerLogins;

my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
    User => $CustomerLogins[0],
);

my $Customer1Email = $CustomerData{UserEmail};

# create a new customer with email address of customer 1
my $UserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => "Firstname Add $Rand",
    UserLastname   => "Lastname Add $Rand",
    UserCustomerID => "CustomerID Add $Rand",
    UserLogin      => "UserLogin Add $Rand",
    UserEmail      => $Customer1Email,
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
);

$Self->False(
    $UserID,
    "CustomerUserAdd() - not possible for duplicate email address",
);

%CustomerData = $CustomerUserObject->CustomerUserDataGet(
    User => $CustomerLogins[1],
);

# update user 1 with email address of customer 2
my $Update = $CustomerUserObject->CustomerUserUpdate(
    %CustomerData,
    Source    => 'CustomerUser',
    ID        => $CustomerData{UserLogin},
    UserEmail => $Customer1Email,
    UserID    => 1,
);

$Self->False(
    $Update,
    "CustomerUserUpdate() - not possible for duplicate email address",
);

1;
