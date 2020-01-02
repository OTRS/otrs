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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::PostMaster::SpoolMailsReprocess');

my $ExitCode = $CommandObject->Execute();

# just check exit code.
$Self->Is(
    $ExitCode,
    0,
    "Maint::PostMaster::SpoolMailsReprocess exit code",
);

1;
