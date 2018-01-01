# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::User::Add');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $UserName = 'user' . $Helper->GetRandomID();

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# try to execute command without any options
my $ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options
$ExitCode = $CommandObject->Execute(
    '--user-name', $UserName, '--first-name', 'Test', '--last-name', 'Test',
    '--email-address', $UserName . '@test.test'
);
$Self->Is(
    $ExitCode,
    0,
    "Minimum options",
);

# provide minimum options
$ExitCode = $CommandObject->Execute(
    '--user-name', $UserName, '--first-name', 'Test', '--last-name', 'Test',
    '--email-address', $UserName . '@test.test'
);
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (user already exists)",
);

# cleanup is done by RestoreDatabase

1;
