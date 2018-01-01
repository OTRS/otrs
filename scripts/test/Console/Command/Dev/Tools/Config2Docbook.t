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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get command object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Tools::Config2Docbook');

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Dev::Tools::Config2Docbook exit code without arguments",
);

my $Result;
{
    local *STDOUT;
    open STDOUT, '>:encoding(UTF-8)', \$Result;
    $ExitCode = $CommandObject->Execute( '--language', 'en' );
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
}

$Self->Is(
    $ExitCode,
    0,
    "Dev::Tools::Config2Docbook exit code",
);

my $Test = '<variablelist id="ConfigReference_Ticket:Frontend::SLA::Preferences">
    <title>Ticket → Frontend::SLA::Preferences</title>';

$Self->True(
    index( $Result, $Test ) > -1,
    "Config entry found in docbook content",
);

print $Result;

# cleanup cache is done by RestoreDatabase

1;
