# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

# add users
my $UserRand1 = 'example-user' . int( rand(1000000) );

my $UserID = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
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
    "Firstname Test1 Lastname Test1 ($UserRand1)",
    'UserName - Order 2',
);

my %NameCheckList2 = $UserObject->UserList( Type => 'Long' );
$Self->Is(
    $NameCheckList2{$UserID},
    "Firstname Test1 Lastname Test1 ($UserRand1)",
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
    $UserRand1,
    'GetUserData() - UserLogin',
);
$Self->Is(
    $UserData{UserEmail} || '',
    $UserRand1 . '@example.com',
    'GetUserData() - UserEmail',
);

my %UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 0,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand1,
    "UserList valid 0",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand1,
    "UserList valid 1",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 0,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand1,
    "UserList valid 0 cached",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand1,
    "UserList valid 1 cached",
);

my $Update = $UserObject->UserUpdate(
    UserID        => $UserID,
    UserFirstname => 'Михаил',
    UserLastname  => 'Lastname Tëst2',
    UserLogin     => $UserRand1 . '房治郎',
    UserEmail     => $UserRand1 . '@example2.com',
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
    $UserRand1 . '房治郎',
    'GetUserData() - UserLogin',
);
$Self->Is(
    $UserData{UserEmail} || '',
    $UserRand1 . '@example2.com',
    'GetUserData() - UserEmail',
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 0,
);

$Self->Is(
    $UserList{$UserID},
    $UserRand1 . '房治郎',
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
    $UserRand1 . '房治郎',
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
    $UserRand1 . '房治郎',
    "UserSearch after update",
);

%UserSearch = $UserObject->UserSearch(
    UserLogin => '*房治郎*',
    Valid     => 0,
);

$Self->Is(
    $UserSearch{$UserID},
    $UserRand1 . '房治郎',
    "UserSearch for login after update",
);

%UserSearch = $UserObject->UserSearch(
    PostMasterSearch => $UserRand1 . '@example2.com',
    Valid            => 0,
);

$Self->Is(
    $UserSearch{$UserID},
    $UserRand1 . '@example2.com',
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

my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $TimeObject->SystemTime2Date(
    SystemTime => $TimeObject->SystemTime(),
);

my %Values = (
    'OutOfOffice'           => 'on',
    'OutOfOfficeStartYear'  => $Year,
    'OutOfOfficeStartMonth' => $Month,
    'OutOfOfficeStartDay'   => $Day,
    'OutOfOfficeEndYear'    => $Year,
    'OutOfOfficeEndMonth'   => $Month,
    'OutOfOfficeEndDay'     => $Day,
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
1;
