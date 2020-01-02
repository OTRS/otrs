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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Group::RoleLink');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName = $Helper->GetRandomID();

# try to execute command without any options
my $ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options (invalid role)
$ExitCode = $CommandObject->Execute( '--role-name', $RandomName, '--group-name', $RandomName, '--permission', 'ro' );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but role doesn't exist)",
);

# create actual role
my $RoleID = $Kernel::OM->Get('Kernel::System::Group')->RoleAdd(
    Name    => $RandomName,
    Comment => 'comment describing the role',
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $RoleID,
    "Test role is created - $RoleID",
);

# provide minimum options (invalid group)
$ExitCode = $CommandObject->Execute( '--role-name', $RandomName, '--group-name', $RandomName, '--permission', 'ro' );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but group doesn't exist)",
);

# provide minimum options (invalid permission)
$ExitCode = $CommandObject->Execute( '--role-name', $RandomName, '--group-name', 'admin', '--permission', 'xx' );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but invalid permission parameter)",
);

# provide minimum options (all ok)
$ExitCode = $CommandObject->Execute( '--role-name', $RandomName, '--group-name', 'admin', '--permission', 'ro' );
$Self->Is(
    $ExitCode,
    0,
    "Minimum options (all ok)",
);

# cleanup is done by RestoreDatabase

1;
