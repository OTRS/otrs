# --
# User.t - User tests
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: User.t,v 1.5 2009-02-16 12:40:23 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

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

1;
