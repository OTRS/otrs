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

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::CustomerCompany::Add');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomName = $Helper->GetRandomID();

# try to execute command without any options
my $ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options
$ExitCode = $CommandObject->Execute(
    '--customer-id', "$RandomName-CID", '--name', "$RandomName-name",
);
$Self->Is(
    $ExitCode,
    0,
    "Minimum options",
);

# cleanup is done by RestoreDatabase

1;
