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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Group::UserLink');

my ( $Result, $ExitCode );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName = $Helper->GetRandomID();

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options (invalid user)
$ExitCode = $CommandObject->Execute( '--user-name', $RandomName, '--group-name', $RandomName, '--permission', 'ro' );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but user doesn't exist)",
);

# provide minimum options (invalid group)
$ExitCode
    = $CommandObject->Execute( '--user-name', 'root@localhost', '--group-name', $RandomName, '--permission', 'ro' );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but group doesn't exist)",
);

# provide minimum options (invalid permission)
$ExitCode
    = $CommandObject->Execute( '--user-name', 'root@localhost', '--group-name', $RandomName, '--permission', 'xx' );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but invalid permission parameter)",
);

# disable email checks to create new user
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# add users
my $UserRand = 'user' . $RandomName;
my $UserID   = $Kernel::OM->Get('Kernel::System::User')->UserAdd(
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

# add group
my $GroupRand = 'group' . $RandomName;
my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
    Name    => $GroupRand,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID,
    "Test group is created - $GroupRand",
);

# provide minimum options (okay)
$ExitCode = $CommandObject->Execute( '--user-name', $UserRand, '--group-name', $GroupRand, '--permission', 'ro' );
$Self->Is(
    $ExitCode,
    0,
    "Minimum options (parameters okay - set 'ro' permission for test user in test group)",
);

# set to rw permission
$ExitCode = $CommandObject->Execute( '--user-name', $UserRand, '--group-name', $GroupRand, '--permission', 'rw' );
$Self->Is(
    $ExitCode,
    0,
    "Minimum options (parameters okay - set 'rw' permission for test user in test group)",
);

# cleanup is done by RestoreDatabase

1;
