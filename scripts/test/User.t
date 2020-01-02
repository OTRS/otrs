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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

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

# create non existing user login
my $UserRand;
TRY:
for my $Try ( 1 .. 20 ) {

    $UserRand = 'unittest-' . $Helper->GetRandomID();

    my $UserID = $UserObject->UserLookup(
        UserLogin => $UserRand,
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
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand,
    UserEmail     => $UserRand . '@example.com',
    UserComment   => $UserRand,
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID,
    'UserAdd()',
);

$ConfigObject->Set(
    Key   => 'FirstnameLastnameOrder',
    Value => 0,
);
$Self->Is(
    $UserObject->UserName( UserID => $UserID ),
    'Firstname Test1 Lastname Test1',
    'UserName - Order 0',
);

my %NameCheckList0 = $UserObject->UserList( Type => 'Long' );
$Self->Is(
    $NameCheckList0{$UserID},
    'Firstname Test1 Lastname Test1',
    'Username in List - Order 0',
);

$ConfigObject->Set(
    Key   => 'FirstnameLastnameOrder',
    Value => 1,
);
$Self->Is(
    $ConfigObject->Get('FirstnameLastnameOrder'),
    1,
    'Check if NameOrder option is set correctly',
);

$Self->Is(
    $UserObject->UserName( UserID => $UserID ),
    'Lastname Test1, Firstname Test1',
    'UserName - Order 1',
);

my %NameCheckList1 = $UserObject->UserList( Type => 'Long' );
$Self->Is(
    $NameCheckList1{$UserID},
    'Lastname Test1, Firstname Test1',
    'Username in List - Order 1',
);

$ConfigObject->Set(
    Key   => 'FirstnameLastnameOrder',
    Value => 2,
);
$Self->Is(
    $UserObject->UserName( UserID => $UserID ),
    "Firstname Test1 Lastname Test1 ($UserRand)",
    'UserName - Order 2',
);

my %NameCheckList2 = $UserObject->UserList( Type => 'Long' );
$Self->Is(
    $NameCheckList2{$UserID},
    "Firstname Test1 Lastname Test1 ($UserRand)",
    'Username in List - Order 2',
);

my %UserData = $UserObject->GetUserData( UserID => $UserID );

$Self->Is(
    $UserData{UserFirstname} || '',
    'Firstname Test1',
    'GetUserData() - UserFirstname',
);
$Self->Is(
    $UserData{UserLastname} || '',
    'Lastname Test1',
    'GetUserData() - UserLastname',
);
$Self->Is(
    $UserData{UserLogin} || '',
    $UserRand,
    'GetUserData() - UserLogin',
);
$Self->Is(
    $UserData{UserEmail} || '',
    $UserRand . '@example.com',
    'GetUserData() - UserEmail',
);
$Self->Is(
    $UserData{UserComment} || '',
    $UserRand,
    'GetUserData() - UserComment',
);

my %UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 0,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand,
    "UserList valid 0",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand,
    "UserList valid 1",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 0,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand,
    "UserList valid 0 cached",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand,
    "UserList valid 1 cached",
);

my $Update = $UserObject->UserUpdate(
    UserID        => $UserID,
    UserFirstname => 'Михаил',
    UserLastname  => 'Lastname Tëst2',
    UserLogin     => $UserRand . '房治郎',
    UserEmail     => $UserRand . '@example2.com',
    UserComment   => $UserRand . '房治郎',
    ValidID       => 2,
    ChangeUserID  => 1,
);

$Self->True(
    $Update,
    'UserUpdate()',
);

%UserData = $UserObject->GetUserData( UserID => $UserID );

$Self->Is(
    $UserData{UserFirstname} || '',
    'Михаил',
    'GetUserData() - UserFirstname',
);
$Self->Is(
    $UserData{UserLastname} || '',
    'Lastname Tëst2',
    'GetUserData() - UserLastname',
);
$Self->Is(
    $UserData{UserLogin} || '',
    $UserRand . '房治郎',
    'GetUserData() - UserLogin',
);
$Self->Is(
    $UserData{UserEmail} || '',
    $UserRand . '@example2.com',
    'GetUserData() - UserEmail',
);
$Self->Is(
    $UserData{UserComment} || '',
    $UserRand . '房治郎',
    'GetUserData() - UserComment',
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 0,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand . '房治郎',
    "UserList valid 0",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

$Self->Is(
    $UserList{$UserID},
    undef,
    "UserList valid 1",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 0,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand . '房治郎',
    "UserList valid 0 cached",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

$Self->Is(
    $UserList{$UserID},
    undef,
    "UserList valid 1 cached",
);

my %UserSearch = $UserObject->UserSearch(
    Search => '*Михаил*',
    Valid  => 0,
);

$Self->Is(
    $UserSearch{$UserID},
    $UserRand . '房治郎',
    "UserSearch after update",
);

%UserSearch = $UserObject->UserSearch(
    UserLogin => '*房治郎*',
    Valid     => 0,
);

$Self->Is(
    $UserSearch{$UserID},
    $UserRand . '房治郎',
    "UserSearch for login after update",
);

%UserSearch = $UserObject->UserSearch(
    PostMasterSearch => $UserRand . '@example2.com',
    Valid            => 0,
);

$Self->Is(
    $UserSearch{$UserID},
    $UserRand . '@example2.com',
    "UserSearch for login after update",
);

# check token support
my $Token = $UserObject->TokenGenerate( UserID => 1 );
$Self->True(
    $Token || 0,
    "TokenGenerate() - $Token",
);

my $TokenValid = $UserObject->TokenCheck(
    Token  => $Token,
    UserID => 1,
);

$Self->True(
    $TokenValid || 0,
    "TokenCheck() - $Token",
);

$TokenValid = $UserObject->TokenCheck(
    Token  => $Token,
    UserID => 1,
);

$Self->True(
    !$TokenValid || 0,
    "TokenCheck() - $Token",
);

$TokenValid = $UserObject->TokenCheck(
    Token  => $Token . '123',
    UserID => 1,
);

$Self->True(
    !$TokenValid || 0,
    "TokenCheck() - $Token" . "123",
);

# testing preferences
my $SetPreferences = $UserObject->SetPreferences(
    Key    => 'UserLanguage',
    Value  => 'fr',
    UserID => $UserID,
);

$Self->True(
    $SetPreferences,
    "SetPreferences - $UserID",
);

my %UserPreferences = $UserObject->GetPreferences(
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

%UserList = $UserObject->SearchPreferences(
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

%UserList = $UserObject->SearchPreferences(
    Key   => 'UserLanguage',
    Value => 'de',
);

$Self->False(
    $UserList{$UserID},
    "SearchPreferences() - $UserID",
);

# look for any value
%UserList = $UserObject->SearchPreferences(
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
my $UpdatePreferences = $UserObject->SetPreferences(
    Key    => 'UserLanguage',
    Value  => 'da',
    UserID => $UserID,
);

$Self->True(
    $UpdatePreferences,
    "UpdatePreferences - $UserID",
);

%UserPreferences = $UserObject->GetPreferences(
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

#check no out of office
%UserData = $UserObject->GetUserData(
    UserID        => $UserID,
    Valid         => 0,
    NoOutOfOffice => 0
);

$Self->False(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);

%UserData = $UserObject->GetUserData(
    UserID => $UserID,
    Valid  => 0,

    #       NoOutOfOffice => 0
);

$Self->False(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);

my $CurSysDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

my %Values = (
    'OutOfOffice'           => 'on',
    'OutOfOfficeStartYear'  => $CurSysDTObject->Format( Format => '%Y' ),
    'OutOfOfficeStartMonth' => $CurSysDTObject->Format( Format => '%m' ),
    'OutOfOfficeStartDay'   => $CurSysDTObject->Format( Format => '%d' ),
    'OutOfOfficeEndYear'    => $CurSysDTObject->Format( Format => '%Y' ),
    'OutOfOfficeEndMonth'   => $CurSysDTObject->Format( Format => '%m' ),
    'OutOfOfficeEndDay'     => $CurSysDTObject->Format( Format => '%d' ),
);

for my $Key ( sort keys %Values ) {
    $UserObject->SetPreferences(
        UserID => $UserID,
        Key    => $Key,
        Value  => $Values{$Key},
    );
}
%UserData = $UserObject->GetUserData(
    UserID        => $UserID,
    Valid         => 0,
    NoOutOfOffice => 0
);

$Self->True(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);

%UserData = $UserObject->GetUserData(
    UserID => $UserID,
    Valid  => 0,
);

$Self->True(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);

# Test bug#13986, search by UserLogin with upper case letters.
$UserRand = 'UniT' . $Helper->GetRandomID();
$Update   = $UserObject->UserUpdate(
    UserID        => $UserID,
    UserFirstname => $UserRand,
    UserLastname  => $UserRand,
    UserLogin     => $UserRand,
    UserEmail     => $UserRand . '@example2.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);
$Self->True(
    $Update,
    'UserUpdate()',
);

%UserSearch = $UserObject->UserSearch(
    UserLogin => $UserRand,
    Valid     => 1,
);
$Self->Is(
    $UserSearch{$UserID},
    $UserRand,
    "UserSearch after update",
);

# cleanup is done by RestoreDatabase

1;
