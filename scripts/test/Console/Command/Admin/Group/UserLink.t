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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Group::UserLink');

my ( $Result, $ExitCode );

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName   = $HelperObject->GetRandomID();

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

# provide minimum options (okay)
$ExitCode = $CommandObject->Execute( '--user-name', 'root@localhost', '--group-name', 'users', '--permission', 'ro' );
$Self->Is(
    $ExitCode,
    0,
    "Minimum options (parameters okay)",
);

# set back to rw permission
$ExitCode = $CommandObject->Execute( '--user-name', 'root@localhost', '--group-name', 'users', '--permission', 'rw' );
$Self->Is(
    $ExitCode,
    0,
    "Minimum options (parameters okay)",
);

1;
