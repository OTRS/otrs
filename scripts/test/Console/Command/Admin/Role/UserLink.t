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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Role::UserLink');

my ( $Result, $ExitCode );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomName = $Helper->GetRandomID();
my $UserRand   = 'user' . $RandomName;
my $RoleRand   = 'role' . $RandomName;

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options (invalid user)
$ExitCode = $CommandObject->Execute( '--user-name', $UserRand, '--role-name', $RoleRand );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but user doesn't exist)",
);

# disable email checks to create new user
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# add users
my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand,
    UserEmail     => $UserRand . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID,
    "Test user is created - $UserRand",
);

# add role
my $RoleID = $Kernel::OM->Get('Kernel::System::Group')->RoleAdd(
    Name    => $RoleRand,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $RoleID,
    "Test role is created - $RoleRand",
);

# provide minimum options (invalid role)
$ExitCode = $CommandObject->Execute( '--user-name', $UserRand, '--role-name', $RandomName );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but role doesn't exist)",
);

# provide minimum options (OK)
$ExitCode = $CommandObject->Execute( '--user-name', $UserRand, '--role-name', $RoleRand );
$Self->Is(
    $ExitCode,
    0,
    "Minimum options (parameters OK: linked user $UserRand to role $RoleRand)",
);

# cleanup is done by RestoreDatabase

1;
