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
