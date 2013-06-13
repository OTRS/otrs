# --
# User.t - User tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::User;

my $ConfigObject = Kernel::Config->new();
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $UserObject = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# add users
my $UserRand1 = 'example-user' . int( rand(1000000) );

my $UserID1 = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID1,
    'UserAdd()',
);

my %UserData = $UserObject->GetUserData( UserID => $UserID1 );

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
    $UserList{$UserID1},
    $UserRand1,
    "UserList valid 0",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

$Self->Is(
    $UserList{$UserID1},
    $UserRand1,
    "UserList valid 1",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 0,
);

$Self->Is(
    $UserList{$UserID1},
    $UserRand1,
    "UserList valid 0 cached",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

$Self->Is(
    $UserList{$UserID1},
    $UserRand1,
    "UserList valid 1 cached",
);

my $Update = $UserObject->UserUpdate(
    UserID        => $UserID1,
    UserFirstname => 'Firstname Test2',
    UserLastname  => 'Lastname Test2',
    UserLogin     => $UserRand1 . "2",
    UserEmail     => $UserRand1 . '@example2.com',
    ValidID       => 2,
    ChangeUserID  => 1,
);

$Self->True(
    $Update,
    'UserUpdate()',
);

%UserData = $UserObject->GetUserData( UserID => $UserID1 );

$Self->Is(
    $UserData{UserFirstname} || '',
    'Firstname Test2',
    'GetUserData() - UserFirstname',
);
$Self->Is(
    $UserData{UserLastname} || '',
    'Lastname Test2',
    'GetUserData() - UserLastname',
);
$Self->Is(
    $UserData{UserLogin} || '',
    $UserRand1 . "2",
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
    $UserList{$UserID1},
    $UserRand1 . "2",
    "UserList valid 0",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

$Self->Is(
    $UserList{$UserID1},
    undef,
    "UserList valid 1",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 0,
);

$Self->Is(
    $UserList{$UserID1},
    $UserRand1 . "2",
    "UserList valid 0 cached",
);

%UserList = $UserObject->UserList(
    Type  => 'Short',
    Valid => 1,
);

$Self->Is(
    $UserList{$UserID1},
    undef,
    "UserList valid 1 cached",
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

#check no out of office
%UserData = $UserObject->GetUserData(
    UserID        => $UserID1,
    Valid         => 0,
    NoOutOfOffice => 0
);

$Self->False(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);

%UserData = $UserObject->GetUserData(
    UserID => $UserID1,
    Valid  => 0,

    #       NoOutOfOffice => 0
);

$Self->False(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);

my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $Self->{TimeObject}->SystemTime2Date(
    SystemTime => $Self->{TimeObject}->SystemTime(),
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
        UserID => $UserID1,
        Key    => $Key,
        Value  => $Values{$Key},
    );
}
%UserData = $UserObject->GetUserData(
    UserID        => $UserID1,
    Valid         => 0,
    NoOutOfOffice => 0
);

$Self->True(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);

%UserData = $UserObject->GetUserData(
    UserID => $UserID1,
    Valid  => 0,
);

$Self->True(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);
1;
