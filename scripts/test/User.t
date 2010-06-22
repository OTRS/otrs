# --
# User.t - User tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: User.t,v 1.7 2010-06-22 22:00:52 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::User;

$Self->{UserObject} = Kernel::System::User->new( %{$Self} );

# add users
my $UserRand1 = 'example-user' . int( rand(1000000) );

$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailInvalidAddress',
    Value => 0,
);

my $UserID1 = $Self->{UserObject}->UserAdd(
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

my %UserData = $Self->{UserObject}->GetUserData(
    UserID => $UserID1,
);

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

my $Update = $Self->{UserObject}->UserUpdate(
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

%UserData = $Self->{UserObject}->GetUserData(
    UserID => $UserID1,
);

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

# check token support
my $Token = $Self->{UserObject}->TokenGenerate(
    UserID => 1,
);
$Self->True(
    $Token || 0,
    "TokenGenerate() - $Token",
);

my $TokenValid = $Self->{UserObject}->TokenCheck(
    Token  => $Token,
    UserID => 1,
);

$Self->True(
    $TokenValid || 0,
    "TokenCheck() - $Token",
);

$TokenValid = $Self->{UserObject}->TokenCheck(
    Token  => $Token,
    UserID => 1,
);

$Self->True(
    !$TokenValid || 0,
    "TokenCheck() - $Token",
);

$TokenValid = $Self->{UserObject}->TokenCheck(
    Token  => $Token . '123',
    UserID => 1,
);

$Self->True(
    !$TokenValid || 0,
    "TokenCheck() - $Token" . "123",
);

#check no out of office
%UserData = $Self->{UserObject}->GetUserData(
    UserID        => $UserID1,
    Valid         => 0,
    NoOutOfOffice => 0
);

$Self->False(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);

%UserData = $Self->{UserObject}->GetUserData(
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

for my $Key ( keys %Values ) {
    $Self->{UserObject}->SetPreferences(
        UserID => $UserID1,
        Key    => $Key,
        Value  => $Values{$Key},
    );
}
%UserData = $Self->{UserObject}->GetUserData(
    UserID        => $UserID1,
    Valid         => 0,
    NoOutOfOffice => 0
);

$Self->True(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);

%UserData = $Self->{UserObject}->GetUserData(
    UserID => $UserID1,
    Valid  => 0,
);

$Self->True(
    $UserData{OutOfOfficeMessage},
    'GetUserData() - OutOfOfficeMessage',
);
1;
