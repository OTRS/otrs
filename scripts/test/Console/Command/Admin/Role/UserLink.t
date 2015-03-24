# --
# Admin/Role/UserLink.t - command tests
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Role::UserLink');

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
$ExitCode = $CommandObject->Execute( '--user-name', $RandomName, '--role-name', $RandomName );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but user doesn't exist)",
);

# provide minimum options (invalid group)
$ExitCode = $CommandObject->Execute( '--user-name', 'root@localhost', '--role-name', $RandomName );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but role doesn't exist)",
);

1;
