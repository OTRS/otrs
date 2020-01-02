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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Code::CPANAudit');

my $ExitCode = $CommandObject->Execute();

my $Output;
{
    local *STDOUT;
    open STDOUT, '>:encoding(UTF-8)', \$Output;
    $ExitCode = $CommandObject->Execute();
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Output );
}

$Self->Is(
    $ExitCode,
    0,
    "Dev::Tools::CPANAudit exit code",
);

$Self->Is(
    $Output,
    'Collecting all installed modules. This can take a while...
No advisories found
',
    "Dev::Tools::CPANAudit reports no vulnerabilities",
);

1;
