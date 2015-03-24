# --
# Admin/Group/RoleLink.t - command tests
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Group::RoleLink');

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName   = $HelperObject->GetRandomID();

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

# remove test role
my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => "DELETE FROM group_role WHERE role_id = $RoleID",
);
$Self->True(
    $Success,
    "GroupRoleDelete - $RandomName",
);

$Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => "DELETE FROM roles WHERE name = '$RandomName'",
);
$Self->True(
    $Success,
    "RoleDelete - $RandomName",
);

# Make sure the cache is correct.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'Group',
);

1;
