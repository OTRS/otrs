# --
# Maint/CloudServices/ConnectionCheck.t - command tests
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::CloudServices::ConnectionCheck');

my $ExitCode = $CommandObject->Execute();

# we cannot test much more than a 0 exit status here

$Self->Is(
    $ExitCode,
    0,
    "Maint::CloudServices::ConnectionCheck exit code",
);

1;
