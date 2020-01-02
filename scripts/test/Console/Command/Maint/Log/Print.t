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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Log::Print');
my $LogObject     = $Kernel::OM->Get('Kernel::System::Log');

$LogObject->CleanUp();

my ( $Result, $ExitCode );
{
    local *STDOUT;
    open STDOUT, '>:encoding(UTF-8)', \$Result;
    $ExitCode = $CommandObject->Execute();
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
}

$LogObject->Log(
    Priority => 'error',
    Message  => 'test',
);

$Self->Is(
    $ExitCode,
    0,
    "Exit code for log output",
);

$Self->Is(
    $Result // '',
    '',
    "Log output empty",
);

{
    local *STDOUT;
    open STDOUT, '>:encoding(UTF-8)', \$Result;
    $ExitCode = $CommandObject->Execute();
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
}

$Self->Is(
    $ExitCode,
    0,
    "Exit code for log output",
);

$Self->True(
    index( $Result, ';test' ) > -1,
    "Test string found in log",
);

1;
