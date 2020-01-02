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

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $DBObject           = $Kernel::OM->Get('Kernel::System::DB');

# get helper object
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

my $DatabaseCaseSensitive      = $DBObject->{Backend}->{'DB::CaseSensitive'};
my $SearchCaseSensitiveDefault = $ConfigObject->{CustomerUser}->{Params}->{SearchCaseSensitive};

my $UserID = '';
for my $Key ( 1 .. 3, 'ä', 'カス', '_', '&' ) {

    # create non existing customer user login
    my $UserRand;
    TRY:
    for my $Try ( 1 .. 20 ) {

        $UserRand = 'unittest-' . $Key . $Helper->GetRandomID();

        my %UserData = $CustomerUserObject->CustomerUserDataGet(
            User => $UserRand,
        );

        last TRY if !%UserData;

        next TRY if $Try ne 20;

        $Self->True(
            0,
            'Find non existing customer user login.',
        );
    }

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

    # check customer ids
    my @CustomerIDs = $CustomerUserObject->CustomerIDs(
        User => $UserID,
    );
    $Self->IsDeeply(
        \@CustomerIDs,
        [ $UserRand . '-Customer-Update-Id' ],
        'CustomerIDs() - User',
    );

    # search by CustomerID
    my %List = $CustomerUserObject->CustomerSearch(
        CustomerID => $UserRand . '-Customer-Update-Id',
        ValidID    => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - CustomerID=\'$UserRand-Customer-Update-Id\' - $UserID is found",
    );

    # search by CustomerIDRaw
    %List = $CustomerUserObject->CustomerSearch(
        CustomerIDRaw => $UserRand . '-Customer-Update-Id',
        ValidID       => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - CustomerIDRaw=\'$UserRand-Customer-Update-Id\' - $UserID is found",
    );

    # search by CustomerID with asterisk
    %List = $CustomerUserObject->CustomerSearch(
        CustomerID => '*',
        Limit      => 100000,
        ValidID    => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - CustomerID=\'*\' - $UserID is found",
    );

    # search by CustomerIDRaw with asterisk
    %List = $CustomerUserObject->CustomerSearch(
        CustomerIDRaw => '*',
        ValidID       => 1,
    );
    $Self->False(
        $List{$UserID},
        "CustomerSearch() - CustomerIDRaw=\'*\' - $UserID is not found",
    );

    # search by CustomerID with asterisk
    %List = $CustomerUserObject->CustomerSearch(
        CustomerID => $UserRand . '-Customer*',
        ValidID    => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - CustomerID=\'$UserRand-Customer*\' - $UserID is found",
    );

    # search by CustomerIDRaw with asterisk
    %List = $CustomerUserObject->CustomerSearch(
        CustomerIDRaw => $UserRand . '-Customer*',
        ValidID       => 1,
    );
    $Self->False(
        $List{$UserID},
        "CustomerSearch() - CustomerIDRaw=\'$UserRand-Customer*\' - $UserID is not found",
    );

    # search by CustomerID with %
    %List = $CustomerUserObject->CustomerSearch(
        CustomerID => '%',
        Limit      => 100000,
        ValidID    => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - CustomerID=\'%\' - $UserID is found",
    );

    # search by CustomerIDRaw with %
    %List = $CustomerUserObject->CustomerSearch(
        CustomerIDRaw => '%',
        ValidID       => 1,
    );
    $Self->False(
        $List{$UserID},
        "CustomerSearch() - CustomerIDRaw=\'%\' - $UserID is not found",
    );

    # search by CustomerID with %
    %List = $CustomerUserObject->CustomerSearch(
        CustomerID => $UserRand . '-Customer%',
        ValidID    => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - CustomerID=\'$UserRand-Customer%\' - $UserID is found",
    );

    # search by CustomerIDRaw with %
    %List = $CustomerUserObject->CustomerSearch(
        CustomerIDRaw => $UserRand . '-Customer%',
        ValidID       => 1,
    );
    $Self->False(
        $List{$UserID},
        "CustomerSearch() - CustomerIDRaw=\'$UserRand-Customer%\' - $UserID is not found",
    );

    # START CaseSensitive
    $ConfigObject->{CustomerUser}->{Params}->{SearchCaseSensitive} = 1;

    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::CustomerUser'] );
    $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    $CacheObject->CleanUp();

    # Customer Search
    %List = $CustomerUserObject->CustomerSearch(
        Search  => lc( $UserRand . '-Customer-Update-Id' ),
        ValidID => 1,
    );

    if ($DatabaseCaseSensitive) {

        $Self->False(
            $List{$UserID},
            "CustomerSearch() - CustomerID - $UserID (SearchCaseSensitive = 1)",
        );
    }
    else {
        $Self->True(
            $List{$UserID},
            "CustomerSearch() - CustomerID - $UserID (SearchCaseSensitive = 1)",
        );
    }

    # CustomerIDList
    my @List = $CustomerUserObject->CustomerIDList(
        SearchTerm => lc( $UserRand . '-Customer-Update-Id' ),
        ValidID    => 1,
    );

    if ($DatabaseCaseSensitive) {

        $Self->IsNotDeeply(
            \@List,
            [ $UserRand . '-Customer-Update-Id' ],
            "CustomerIDList() - no SearchTerm - $UserID (SearchCaseSensitive = 1)",
        );
    }
    else {
        $Self->IsDeeply(
            \@List,
            [ $UserRand . '-Customer-Update-Id' ],
            "CustomerIDList() - no SearchTerm - $UserID (SearchCaseSensitive = 1)",
        );
    }

    $ConfigObject->{CustomerUser}->{Params}->{SearchCaseSensitive} = 0;

    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::CustomerUser'] );
    $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    $CacheObject->CleanUp();

    # Customer Search
    %List = $CustomerUserObject->CustomerSearch(
        Search  => lc( $UserRand . '-Customer-Update-Id' ),
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - CustomerID - $UserID (SearchCaseSensitive = 0)",
    );

    # CustomerIDList
    @List = $CustomerUserObject->CustomerIDList(
        SearchTerm => lc( $UserRand . '-Customer-Update-Id' ),
        ValidID    => 1,
    );

    $Self->IsDeeply(
        \@List,
        [ $UserRand . '-Customer-Update-Id' ],
        "CustomerIDList() - no SearchTerm - $UserID (SearchCaseSensitive = 0)",
    );

    $ConfigObject->{CustomerUser}->{Params}->{SearchCaseSensitive} = $SearchCaseSensitiveDefault;

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

    %List = $CustomerUserObject->CustomerSearch(
        Search  => uc("*$UserID*"),
        ValidID => 1,
    );
    $Self->True(
        $List{$UserID},
        "CustomerSearch() - Search uc('*\$User*') - $UserID",
    );

    # check password support
    for my $Config (qw( plain crypt apr1 md5 sha1 sha2 bcrypt )) {

        $ConfigObject->Set(
            Key   => 'Customer::AuthModule::DB::CryptType',
            Value => $Config,
        );

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::CustomerAuth'] );
        my $CustomerAuth = $Kernel::OM->Get('Kernel::System::CustomerAuth');

        for my $Password (qw(some_pass someカス someäöü)) {

            my $Set = $CustomerUserObject->SetPassword(
                UserLogin => $UserID,
                PW        => $Password,
            );

            $Self->True(
                $Set,
                "SetPassword() - $Config - $UserID - $Password",
            );

            my $Ok = $CustomerAuth->Auth(
                User => $UserID,
                Pw   => $Password
            );
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

$Self->Is(
    $UserList{$UserID},
    'fr',
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

# search for any value
%UserList = $CustomerUserObject->SearchPreferences(
    Key => 'UserLanguage',
);

$Self->True(
    %UserList || '',
    "SearchPreferences - $UserID",
);

$Self->Is(
    $UserList{$UserID},
    'fr',
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

# Use default CustomerUserListFields config and search for customer.
my $UserLogin     = "NewLogin$UserID";
my $FirstName     = "Firstname Update$UserID";
my $LastName      = "Lastname Update$UserID";
my $CustomerID    = "${UserID}new\@example.com";
my $CustomerEmail = "<${UserID}new\@example.com>";
my %CustomerUser  = $CustomerUserObject->CustomerSearch(
    UserLogin => $UserLogin,
    Valid     => 1,
);

# Verified search result.
$Self->Is(
    $CustomerUser{$UserLogin},
    "\"$FirstName $LastName\" $CustomerEmail",
    "Default 'CustomerUserListFields' config is"
);

# Change CustomerUserListFields config and search for customer again.
#   See bug#13394 (https://bugs.otrs.org/show_bug.cgi?id=13394).
my $CustomerUser = $ConfigObject->Get('CustomerUser');
$CustomerUser->{CustomerUserListFields} = [ 'login', 'first_name', 'last_name', 'customer_id', 'email' ];
$ConfigObject->Set(
    Key   => 'CustomerUser',
    Value => $CustomerUser,
);

$CacheObject->CleanUp();

%CustomerUser = $CustomerUserObject->CustomerSearch(
    UserLogin => $UserLogin,
    Valid     => 1,
);

# Verify search result.
$Self->Is(
    $CustomerUser{$UserLogin},
    "\"$UserLogin $FirstName $LastName $CustomerID\" $CustomerEmail",
    "Changed 'CustomerUserListFields' config is"
);

# cleanup is done by RestoreDatabase

1;
