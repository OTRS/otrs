# --
# CustomerUser.t - CustomerUser tests
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
use Kernel::System::CustomerAuth;

# create local objects
my $ConfigObject = Kernel::Config->new();

# add three users
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $DatabaseCaseSensitive = $Self->{DBObject}->{Backend}->{'DB::CaseSensitive'};
my $CustomerDatabaseCaseSensitiveDefault = $ConfigObject->{CustomerUser}->{Params}->{CaseSensitive};

my $CustomerUserObject = Kernel::System::CustomerUser->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $CacheObject = Kernel::System::Cache->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $UserID = '';
for my $Key ( 1 .. 3, 'ä', 'カス' ) {
    my $UserRand = 'Example-Customer-User' . $Key . int( rand(1000000) );
    $Self->{EncodeObject}->EncodeInput( \$UserRand );

    $UserID = $UserRand;
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

    $Self->True(
        $UserID,
        "CustomerUserAdd() - $UserID",
    );

    my %User = $CustomerUserObject->CustomerUserDataGet(
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

    %User = $CustomerUserObject->CustomerUserDataGet(
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
    %User = $CustomerUserObject->CustomerUserDataGet(
        User => lc($UserID),
    );
    $Self->True(
        $User{UserLogin},
        "CustomerUserGet() - lc() - $UserID",
    );

    # uc
    %User = $CustomerUserObject->CustomerUserDataGet(
        User => uc($UserID),
    );
    $Self->True(
        $User{UserLogin},
        "CustomerUserGet() - uc() - $UserID",
    );

    # search
    my %List = $CustomerUserObject->CustomerSearch(
        CustomerID => $UserRand . '-Customer-Update-Id',
        ValidID    => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - CustomerID - $UserID",
    );

    # START CaseSensitive
    $ConfigObject->{CustomerUser}->{Params}->{CaseSensitive} = 1;
    $CustomerUserObject = Kernel::System::CustomerUser->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );
    $CacheObject->CleanUp();
    # Customer Search
    %List = $CustomerUserObject->CustomerSearch(
        Search => lc($UserRand . '-Customer-Update-Id'),
        ValidID    => 1,
    );
    
    if ($DatabaseCaseSensitive) {

        $Self->False(
            $List{$UserID},
            "CustomerSearch() - CustomerID - $UserID (CaseSensitive = 1)",
        );
    }
    else {
        $Self->True(
            $List{$UserID},
            "CustomerSearch() - CustomerID - $UserID (CaseSensitive = 1)",
        );
    }

    # CustomerIDList
    my @List = $CustomerUserObject->CustomerIDList(
        SearchTerm => lc($UserRand . '-Customer-Update-Id'),
        ValidID    => 1,
    );

    if ($DatabaseCaseSensitive) {

        $Self->IsNotDeeply(
            \@List,
            [ $UserRand . '-Customer-Update-Id' ],
            "CustomerIDList() - no SearchTerm - $UserID (CaseSensitive = 1)",
        );
    }
    else {
        $Self->IsDeeply(
            \@List,
            [ $UserRand . '-Customer-Update-Id' ],
            "CustomerIDList() - no SearchTerm - $UserID (CaseSensitive = 1)",
        );
    }

    $ConfigObject->{CustomerUser}->{Params}->{CaseSensitive} = 0;
    $CustomerUserObject = Kernel::System::CustomerUser->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );
    $CacheObject->CleanUp();

    # Customer Search
    %List = $CustomerUserObject->CustomerSearch(
        Search => lc($UserRand . '-Customer-Update-Id'),
        ValidID    => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - CustomerID - $UserID (CaseSensitive = 0)",
    );

    # CustomerIDList
    @List = $CustomerUserObject->CustomerIDList(
        SearchTerm => lc($UserRand . '-Customer-Update-Id'),
        ValidID    => 1,
    );

    $Self->IsDeeply(
        \@List,
        [ $UserRand . '-Customer-Update-Id' ],
        "CustomerIDList() - no SearchTerm - $UserID (CaseSensitive = 0)",
    );

    $ConfigObject->{CustomerUser}->{Params}->{CaseSensitive} = $CustomerDatabaseCaseSensitiveDefault;
    # END CaseSensitive

    @List = $CustomerUserObject->CustomerIDList(
        ValidID => 1,
    );

    @List = grep { $_ eq $UserRand . '-Customer-Update-Id' } @List;

    $Self->IsDeeply(
        \@List,
        [ $UserRand . '-Customer-Update-Id' ],
        "CustomerIDList() - no SearchTerm - $UserID",
    );

    @List = $CustomerUserObject->CustomerIDList(
        SearchTerm => $UserRand . '-Customer-Update-Id',
        ValidID    => 1,
    );

    @List = grep { $_ eq $UserRand . '-Customer-Update-Id' } @List;

    $Self->IsDeeply(
        \@List,
        [ $UserRand . '-Customer-Update-Id' ],
        "CustomerIDList() - with SearchTerm - $UserID",
    );

    @List = $CustomerUserObject->CustomerIDList(
        SearchTerm => 'non_existing',
        ValidID    => 1,
    );

    @List = grep { $_ eq $UserRand . '-Customer-Update-Id' } @List;

    $Self->IsDeeply(
        \@List,
        [],
        "CustomerIDList() - wrong SearchTerm - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => $UserID . '-Update@example.com',
        ValidID          => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - PostMasterSearch - $UserID",
    );
    %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => lc( $UserID . '-Update@example.com' ),
        ValidID          => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - PostMasterSearch lc() - $UserID",
    );
    %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => uc( $UserID . '-Update@example.com' ),
        ValidID          => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - PostMasterSearch uc() - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        UserLogin => $UserID,
        ValidID   => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - UserLogin - $UserID",
    );
    %List = $CustomerUserObject->CustomerSearch(
        UserLogin => lc($UserID),
        ValidID   => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - UserLogin - lc - $UserID",
    );
    %List = $CustomerUserObject->CustomerSearch(
        UserLogin => uc($UserID),
        ValidID   => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - UserLogin - uc - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => "$UserID",
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '\$UserID' - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => "$UserID+firstname",
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '\$UserID+firstname' - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => "$UserID+!firstname",
        ValidID => 1,
    );
    $Self->True(
        !$List{$UserID},
        "CustomerSearch() - Search '\$UserID+!firstname' - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => "$UserID+firstname_with_not_match",
        ValidID => 1,
    );
    $Self->True(
        !$List{$UserID},
        "CustomerSearch() - Search '\$UserID+firstname_with_not_match' - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => "$UserID+!firstname_with_not_match",
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '\$UserID+!firstname_with_not_match' - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => "$UserID*",
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '\$User*' - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => "*$UserID",
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '*\$User' - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => "*$UserID*",
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search '*\$User*' - $UserID",
    );

    # lc()
    %List = $CustomerUserObject->CustomerSearch(
        Search  => lc("$UserID"),
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search lc('') - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => lc("$UserID*"),
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search lc('\$User*') - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => lc("*$UserID"),
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search lc('*\$User') - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => lc("*$UserID*"),
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search lc('*\$User*') - $UserID",
    );

    # uc()
    %List = $CustomerUserObject->CustomerSearch(
        Search  => uc("$UserID"),
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search uc('') - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => uc("$UserID*"),
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search uc('\$User*') - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => uc("*$UserID"),
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search uc('*\$User') - $UserID",
    );

    %List = $CustomerUserObject->CustomerSearch(
        Search  => uc("*$UserID*"),
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search uc('*\$User*') - $UserID",
    );

    # check password support
    for my $Config (qw( md5 crypt plain sha1 sha2 )) {
        $ConfigObject->Set(
            Key   => 'Customer::AuthModule::DB::CryptType',
            Value => $Config,
        );
        my $CustomerAuth = Kernel::System::CustomerAuth->new(
            %{$Self},
            ConfigObject => $ConfigObject,
        );

        for my $Password (qw(some_pass someカス someäöü)) {
            $Self->{EncodeObject}->EncodeInput( \$Password );
            my $Set = $CustomerUserObject->SetPassword(
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
my $Token = $CustomerUserObject->TokenGenerate(
    UserID => $UserID,
);
$Self->True(
    $Token,
    "TokenGenerate() - $Token",
);

my $TokenValid = $CustomerUserObject->TokenCheck(
    Token  => $Token,
    UserID => $UserID,
);

$Self->True(
    $TokenValid,
    "TokenCheck() - $Token",
);

$TokenValid = $CustomerUserObject->TokenCheck(
    Token  => $Token,
    UserID => $UserID,
);

$Self->True(
    !$TokenValid,
    "TokenCheck() - $Token",
);

$TokenValid = $CustomerUserObject->TokenCheck(
    Token  => $Token . '123',
    UserID => $UserID,
);

$Self->True(
    !$TokenValid,
    "TokenCheck() - $Token" . "123",
);

# testing preferences

my $SetPreferences = $CustomerUserObject->SetPreferences(
    Key    => 'UserLanguage',
    Value  => 'fr',
    UserID => $UserID,
);

$Self->True(
    $SetPreferences,
    "SetPreferences - $UserID",
);

my %UserPreferences = $CustomerUserObject->GetPreferences(
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

my %UserList = $CustomerUserObject->SearchPreferences(
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

%UserList = $CustomerUserObject->SearchPreferences(
    Key   => 'UserLanguage',
    Value => 'de',
);

$Self->False(
    $UserList{$UserID},
    "SearchPreferences() - $UserID",
);

#update existing prefs
my $UpdatePreferences = $CustomerUserObject->SetPreferences(
    Key    => 'UserLanguage',
    Value  => 'da',
    UserID => $UserID,
);

$Self->True(
    $UpdatePreferences,
    "UpdatePreferences - $UserID",
);

%UserPreferences = $CustomerUserObject->GetPreferences(
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
my $Update = $CustomerUserObject->CustomerUserUpdate(
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

%UserPreferences = $CustomerUserObject->GetPreferences(
    UserID => 'NewLogin' . $UserID,
);

$Self->True(
    %UserPreferences || '',
    "GetPreferences for updated user - Updated NewLogin$UserID",
);

my $Name = $CustomerUserObject->CustomerName(
    UserLogin => 'NewLogin' . $UserID,
);

$Self->True(
    'Firstname Update' . $UserID . ' ' . 'Lastname Update' . $UserID,
    "CustomerName",
);

$Self->Is(
    $UserPreferences{UserLanguage},
    "da",
    "GetPreferences for updated user $UserID - da",
);

my %List = $CustomerUserObject->CustomerSourceList();

$Self->Is(
    scalar( keys %List ),
    1,
    "CustomerSourceList - found 1 source",
);

%List = $CustomerUserObject->CustomerSourceList(
    ReadOnly => 1,
);

$Self->Is(
    scalar( keys %List ),
    0,
    "CustomerSourceList - found 0 readonly sources",
);

%List = $CustomerUserObject->CustomerSourceList(
    ReadOnly => 0,
);

$Self->Is(
    scalar( keys %List ),
    1,
    "CustomerSourceList - found 1 writable sources",
);

1;
