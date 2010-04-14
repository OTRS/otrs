# --
# CustomerUser.t - CustomerUser tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: CustomerUser.t,v 1.14 2010-04-14 19:42:04 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use Kernel::System::CustomerUser;
use Kernel::System::CustomerAuth;

$Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );

# add three users
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
my $UserID = '';
for my $Key ( 1 .. 3, 'ä', 'カス' ) {
    my $UserRand = 'Example-Customer-User' . $Key . int( rand(1000000) );
    $Self->{EncodeObject}->Encode( \$UserRand );

    $UserID = $UserRand;
    my $UserID = $Self->{CustomerUserObject}->CustomerUserAdd(
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

    $Self->True(
        $UserID,
        "CustomerUserAdd() - $UserID",
    );

    my %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
        User => $UserID,
    );

    $Self->Is(
        $User{UserFirstname},
        "Firstname Test$Key",
        "CustomerUserGet() - UserFirstname - $Key",
    );
    $Self->Is(
        $User{UserLastname},
        "Lastname Test$Key",
        "CustomerUserGet() - UserLastname - $Key",
    );
    $Self->Is(
        $User{UserLogin},
        $UserRand,
        "CustomerUserGet() - UserLogin - $Key",
    );
    $Self->Is(
        $User{UserEmail},
        $UserRand . '-Email@example.com',
        "CustomerUserGet() - UserEmail - $Key",
    );
    $Self->Is(
        $User{UserCustomerID},
        $UserRand . '-Customer-Id',
        "CustomerUserGet() - UserCustomerID - $Key",
    );
    $Self->Is(
        $User{ValidID},
        1,
        "CustomerUserGet() - ValidID - $Key",
    );

    my $Update = $Self->{CustomerUserObject}->CustomerUserUpdate(
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

    %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
        User => $UserID,
    );

    $Self->Is(
        $User{UserFirstname},
        "Firstname Test Update$Key",
        "CustomerUserGet$Key() - UserFirstname",
    );
    $Self->Is(
        $User{UserLastname},
        "Lastname Test Update$Key",
        "CustomerUserGet$Key() - UserLastname",
    );
    $Self->Is(
        $User{UserLogin},
        $UserRand,
        "CustomerUserGet$Key() - UserLogin",
    );
    $Self->Is(
        $User{UserEmail},
        $UserRand . '-Update@example.com',
        "CustomerUserGet$Key() - UserEmail",
    );
    $Self->Is(
        $User{UserCustomerID},
        $UserRand . '-Customer-Update-Id',
        "CustomerUserGet$Key() - UserCustomerID",
    );
    $Self->Is(
        $User{ValidID},
        1,
        "CustomerUserGet$Key() - ValidID",
    );

    # lc
    %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
        User => lc($UserID),
    );
    $Self->True(
        $User{UserLogin},
        "CustomerUserGet() - lc() - $UserID",
    );

    # uc
    %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
        User => uc($UserID),
    );
    $Self->True(
        $User{UserLogin},
        "CustomerUserGet() - uc() - $UserID",
    );

    # search
    my %List = $Self->{CustomerUserObject}->CustomerSearch(
        PostMasterSearch => $UserID . '-Update@example.com',
        ValidID          => 1,                                 # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - PostMasterSearch - $UserID",
    );
    %List = $Self->{CustomerUserObject}->CustomerSearch(
        PostMasterSearch => lc( $UserID . '-Update@example.com' ),
        ValidID          => 1,                                       # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - PostMasterSearch lc() - $UserID",
    );
    %List = $Self->{CustomerUserObject}->CustomerSearch(
        PostMasterSearch => uc( $UserID . '-Update@example.com' ),
        ValidID          => 1,                                       # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - PostMasterSearch uc() - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        UserLogin => $UserID,
        ValidID   => 1,                                              # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - UserLogin - $UserID",
    );
    %List = $Self->{CustomerUserObject}->CustomerSearch(
        UserLogin => lc($UserID),
        ValidID   => 1,                                              # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - UserLogin - lc - $UserID",
    );
    %List = $Self->{CustomerUserObject}->CustomerSearch(
        UserLogin => uc($UserID),
        ValidID   => 1,                                              # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - UserLogin - uc - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => "$UserID",
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '\$UserID' - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => "$UserID+firstname",
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '\$UserID+firstname' - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => "$UserID+!firstname",
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        !$List{$UserID},
        "CustomerSearch() - Search '\$UserID+!firstname' - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => "$UserID+firstname_with_not_match",
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        !$List{$UserID},
        "CustomerSearch() - Search '\$UserID+firstname_with_not_match' - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => "$UserID+!firstname_with_not_match",
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '\$UserID+!firstname_with_not_match' - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => "$UserID*",
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '\$User*' - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => "*$UserID",
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '*\$User' - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => "*$UserID*",
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '*\$User*' - $UserID",
    );

    # lc()
    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => lc("$UserID"),
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search lc('') - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => lc("$UserID*"),
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search lc('\$User*') - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => lc("*$UserID"),
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search lc('*\$User') - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => lc("*$UserID*"),
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search lc('*\$User*') - $UserID",
    );

    # uc()
    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => uc("$UserID"),
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search uc('') - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => uc("$UserID*"),
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search uc('\$User*') - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => uc("*$UserID"),
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search uc('*\$User') - $UserID",
    );

    %List = $Self->{CustomerUserObject}->CustomerSearch(
        Search  => uc("*$UserID*"),
        ValidID => 1,                                                # not required, default 1
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search uc('*\$User*') - $UserID",
    );

    # check password support
    for my $Config qw( md5 crypt plain) {
        $Self->{ConfigObject}->Set(
            Key   => 'Customer::AuthModule::DB::CryptType',
            Value => $Config,
        );
        my $CustomerAuth = Kernel::System::CustomerAuth->new( %{$Self} );

        for my $Password qw(some_pass someカス someäöü) {
            $Self->{EncodeObject}->Encode( \$Password );
            my $Set = $Self->{CustomerUserObject}->SetPassword(
                UserLogin => $UserID,
                PW        => $Password,
            );
            $Self->True(
                $Set,
                "SetPassword() - $Config - $UserID - $Password",
            );

            my $Ok = $CustomerAuth->Auth( User => $UserID, Pw => $Password );
            $Self->True(
                $Ok,
                "Auth() - $Config - $UserID - $Password",
            );
        }
    }
}

# check token support
my $Token = $Self->{CustomerUserObject}->TokenGenerate(
    UserID => $UserID,
);
$Self->True(
    $Token,
    "TokenGenerate() - $Token",
);

my $TokenValid = $Self->{CustomerUserObject}->TokenCheck(
    Token  => $Token,
    UserID => $UserID,
);

$Self->True(
    $TokenValid,
    "TokenCheck() - $Token",
);

$TokenValid = $Self->{CustomerUserObject}->TokenCheck(
    Token  => $Token,
    UserID => $UserID,
);

$Self->True(
    !$TokenValid,
    "TokenCheck() - $Token",
);

$TokenValid = $Self->{CustomerUserObject}->TokenCheck(
    Token  => $Token . '123',
    UserID => $UserID,
);

$Self->True(
    !$TokenValid,
    "TokenCheck() - $Token" . "123",
);

# testing preferences

my $SetPreferences = $Self->{CustomerUserObject}->SetPreferences(
    Key    => 'UserLanguage',
    Value  => 'fr',
    UserID => $UserID,
);

$Self->True(
    $SetPreferences,
    "SetPreferences - $UserID",
);

my %UserPreferences = $Self->{CustomerUserObject}->GetPreferences(
    UserID => $UserID,
);

$Self->True(
    %UserPreferences || '',
    "GetPreferences - $UserID",
);

$Self->Is(
    $UserPreferences{UserLanguage},
    "fr",
    "GetPreferences $UserID - fr",
);

my %UserList = $Self->{CustomerUserObject}->SearchPreferences(
    Key   => 'UserLanguage',
    Value => 'fr',
);

$Self->True(
    %UserList || '',
    "SearchPreferences - $UserID",
);

$Self->True(
    $UserList{$UserID},
    "SearchPreferences() - $UserID",
);

%UserList = $Self->{CustomerUserObject}->SearchPreferences(
    Key   => 'UserLanguage',
    Value => 'de',
);

$Self->False(
    $UserList{$UserID},
    "SearchPreferences() - $UserID",
);

#update existing prefs
my $UpdatePreferences = $Self->{CustomerUserObject}->SetPreferences(
    Key    => 'UserLanguage',
    Value  => 'da',
    UserID => $UserID,
);

$Self->True(
    $UpdatePreferences,
    "UpdatePreferences - $UserID",
);

%UserPreferences = $Self->{CustomerUserObject}->GetPreferences(
    UserID => $UserID,
);

$Self->True(
    %UserPreferences || '',
    "GetPreferences - $UserID",
);

$Self->Is(
    $UserPreferences{UserLanguage},
    "da",
    "UpdatePreferences $UserID - da",
);

#update customer user
my $Update = $Self->{CustomerUserObject}->CustomerUserUpdate(
    Source         => 'CustomerUser',
    UserLogin      => 'NewLogin' . $UserID,
    ValidID        => 1,
    UserFirstname  => 'Firstname Update' . $UserID,
    UserLastname   => 'Lastname Update' . $UserID,
    UserEmail      => $UserID . 'new@example.com',
    UserCustomerID => $UserID . 'new@example.com',
    ID             => $UserID,
    UserID         => 1,
);
$Self->True(
    $Update,
    "CustomerUserUpdate - $UserID",
);

%UserPreferences = $Self->{CustomerUserObject}->GetPreferences(
    UserID => 'NewLogin' . $UserID,
);

$Self->True(
    %UserPreferences || '',
    "GetPreferences for updated user - Updated NewLogin$UserID",
);

$Self->Is(
    $UserPreferences{UserLanguage},
    "da",
    "GetPreferences for updated user $UserID - da",
);

1;
