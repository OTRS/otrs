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

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::PostMaster::MailAccountFetch');

my $ExitCode = $CommandObject->Execute();

# Just check exit code; should be 0 also if no accounts are configured.
$Self->Is(
    $ExitCode,
    0,
    'Maint::PostMaster::MailAccountFetch exit code',
);

$ExitCode = $CommandObject->Execute( '--mail-account-id', 99999 );

# Just check exit code; should be 1 since account does not exit.
$Self->Is(
    $ExitCode,
    1,
    'Maint::PostMaster::MailAccountFetch exit code for non-existing mail account'
);

1;
