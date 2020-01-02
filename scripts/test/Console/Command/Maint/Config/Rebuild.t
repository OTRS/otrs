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

use File::stat();

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ZZZAAuto = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZAAuto.pm';
my $Before   = File::stat::stat($ZZZAAuto);
sleep 2;

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
my $ExitCode      = $CommandObject->Execute();

my $After = File::stat::stat($ZZZAAuto);

$Self->Is(
    $ExitCode,
    0,
    "Exit code",
);

$Self->IsNot(
    $Before->ctime(),
    $After->ctime(),
    "ZZZAAuto ctime",
);

# cleanup cache is done by RestoreDatabase

1;
