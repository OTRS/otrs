# --
# Rebuild.t - command tests
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

use File::stat();

my $ZZZAAuto = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZAAuto.pm';
my $Before   = File::stat::stat($ZZZAAuto);
sleep 2;

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

1;
