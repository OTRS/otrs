# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

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

my $Test = '<section id="ConfigReference_Section_Core_Cache">
        <title>Core → Cache</title>
        <variablelist>
            <varlistentry id="ConfigReference_Setting_Cache::InBackend">
                <term>Cache::InBackend</term>';

$Self->True(
    index( $Result, $Test ) > -1,
    "Config entry found in docbook content",
);

print $Result;

1;
