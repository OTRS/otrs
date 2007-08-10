# --
# CustomerUser.t - CustomerUser tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerUser.t,v 1.2 2007-08-10 11:36:03 martin Exp $
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
    my $UserRand = 'Example-Customer-User'.int(rand(1000000));
    $UserID = $UserRand;
    my $UserID = $Self->{CustomerUserObject}->CustomerUserAdd(
        Source => 'CustomerUser',
        UserFirstname => 'Firstname Test'.$Key,
        UserLastname => 'Lastname Test'.$Key,
        UserCustomerID => $UserRand. '-Customer-Id',
        UserLogin => $UserRand,
        UserEmail => $UserRand . '-Email@example.com',
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
        $UserRand.'-Email@example.com',
        "CustomerUserGet$Key() - UserEmail",
    );
    $Self->Is(
        $User{UserCustomerID} || '',
        $UserRand. '-Customer-Id',
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
        UserCustomerID => $UserRand. '-Customer-Update-Id',
        UserLogin => $UserRand,
        UserEmail => $UserRand . '-Update@example.com',
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
        $UserRand. '-Update@example.com',
        "CustomerUserGet$Key() - UserEmail",
    );
    $Self->Is(
        $User{UserCustomerID} || '',
        $UserRand. '-Customer-Update-Id',
        "CustomerUserGet$Key() - UserCustomerID",
    );
    $Self->Is(
        $User{ValidID} || '',
        1,
        "CustomerUserGet$Key() - ValidID",
    );

}
# lc
my %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
    User => lc($UserID),
);
$Self->True(
    $User{UserLogin} || '',
    "CustomerUserGet() - lc()",
);
# uc
%User = $Self->{CustomerUserObject}->CustomerUserDataGet(
    User => uc($UserID),
);
$Self->True(
    $User{UserLogin} || '',
    "CustomerUserGet() - uc()",
);

# search
my %List = $Self->{CustomerUserObject}->CustomerSearch(
    PostMasterSearch => $UserID.'-Update@example.com',
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - PostMasterSearch",
);
%List = $Self->{CustomerUserObject}->CustomerSearch(
    PostMasterSearch => lc($UserID.'-Update@example.com'),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - PostMasterSearch lc()",
);
%List = $Self->{CustomerUserObject}->CustomerSearch(
    PostMasterSearch => uc($UserID.'-Update@example.com'),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - PostMasterSearch uc()",
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
    UserLogin => lc($UserID),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - UserLogin - lc",
);
%List = $Self->{CustomerUserObject}->CustomerSearch(
    UserLogin => uc($UserID),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - UserLogin - uc",
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

# lc()
%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => lc("$UserID"),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search lc('')",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => lc("$UserID*"),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search lc('\$User*')",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => lc("*$UserID"),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search lc('*\$User')",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => lc("*$UserID*"),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search lc('*\$User*')",
);

# uc()
%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => uc("$UserID"),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search uc('')",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => uc("$UserID*"),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search uc('\$User*')",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => uc("*$UserID"),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search uc('*\$User')",
);

%List = $Self->{CustomerUserObject}->CustomerSearch(
    Search => uc("*$UserID*"),
    ValidID => 1, # not required, default 1
);
$Self->True(
    $List{$UserID} || '',
    "CustomerSearch() - Search uc('*\$User*')",
);

1;
