# --
# CustomerUser.t - CustomerUser tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerUser.t,v 1.1 2007-08-09 21:20:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::CustomerUser;

$Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%{$Self});

# add tree users
$Self->{ConfigObject}->Set(
    Key => 'CheckEmailInvalidAddress',
    Value => 0,
);
my $UserID = '';
foreach my $Key (1..3) {
    my $UserRand = 'example-customer-user'.int(rand(1000000));
    $UserID = $UserRand;
    my $UserID = $Self->{CustomerUserObject}->CustomerUserAdd(
        Source => 'CustomerUser',
        UserFirstname => 'Firstname Test'.$Key,
        UserLastname => 'Lastname Test'.$Key,
        UserCustomerID => $UserRand. '-customer-id',
        UserLogin => $UserRand,
        UserEmail => $UserRand . '@example.com',
        ValidID => 1,
        UserID => 1,
    );

    $Self->True(
        $UserID,
        "CustomerUserAdd$Key()",
    );

    my %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
        User => $UserID,
    );

    $Self->Is(
        $User{UserFirstname} || '',
        "Firstname Test$Key",
        "CustomerUserGet$Key() - UserFirstname",
    );
    $Self->Is(
        $User{UserLastname} || '',
        "Lastname Test$Key",
        "CustomerUserGet$Key() - UserLastname",
    );
    $Self->Is(
        $User{UserLogin} || '',
        $UserRand,
        "CustomerUserGet$Key() - UserLogin",
    );
    $Self->Is(
        $User{UserEmail} || '',
        $UserRand. '@example.com',
        "CustomerUserGet$Key() - UserEmail",
    );
    $Self->Is(
        $User{UserCustomerID} || '',
        $UserRand. '-customer-id',
        "CustomerUserGet$Key() - UserCustomerID",
    );
    $Self->Is(
        $User{ValidID} || '',
        1,
        "CustomerUserGet$Key() - ValidID",
    );

    my $Update = $Self->{CustomerUserObject}->CustomerUserUpdate(
        Source => 'CustomerUser',
        ID => $UserRand,
        UserFirstname => 'Firstname Test Update'.$Key,
        UserLastname => 'Lastname Test Update'.$Key,
        UserCustomerID => $UserRand. '-customer-update-id',
        UserLogin => $UserRand,
        UserEmail => $UserRand . '-update@example.com',
        ValidID => 1,
        UserID => 1,
    );
    $Self->True(
        $Update || '',
        "CustomerUserUpdate$Key()",
    );

    %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
        User => $UserID,
    );

    $Self->Is(
        $User{UserFirstname} || '',
        "Firstname Test Update$Key",
        "CustomerUserGet$Key() - UserFirstname",
    );
    $Self->Is(
        $User{UserLastname} || '',
        "Lastname Test Update$Key",
        "CustomerUserGet$Key() - UserLastname",
    );
    $Self->Is(
        $User{UserLogin} || '',
        $UserRand,
        "CustomerUserGet$Key() - UserLogin",
    );
    $Self->Is(
        $User{UserEmail} || '',
        $UserRand. '-update@example.com',
        "CustomerUserGet$Key() - UserEmail",
    );
    $Self->Is(
        $User{UserCustomerID} || '',
        $UserRand. '-customer-update-id',
        "CustomerUserGet$Key() - UserCustomerID",
    );
    $Self->Is(
        $User{ValidID} || '',
        1,
        "CustomerUserGet$Key() - ValidID",
    );

}

my %List = $Self->{CustomerUserObject}->CustomerSearch(
    PostMasterSearch => $UserID.'-update@example.com',
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - PostMasterSearch",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    UserLogin => $UserID,
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - UserLogin",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => "$UserID",
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search ''",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => "$UserID*",
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search '\$User*'",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => "*$UserID",
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search '*\$User'",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => "*$UserID*",
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search '*\$User*'",
);

1;
