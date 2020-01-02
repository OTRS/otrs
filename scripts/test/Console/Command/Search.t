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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Search');

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Search exit code without arguments",
);

# Check command search
my $Result;

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $CommandObject->Execute('Lis');
}

$Self->Is(
    $ExitCode,
    0,
    "Exit code searching for commands",
);

$Self->False(
    index( $Result, 'otrs.Console.pl Help command' ) > -1,
    "Help for 'Help' command not found",
);

$Self->True(
    index( $Result, 'List all installed OTRS packages' ) > -1,
    "Found Admin::Package::List command entry",
);

# Check command search (empty)

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $CommandObject->Execute('NonExistingSearchTerm');
}

$Self->Is(
    $ExitCode,
    0,
    "Exit code searching for commands",
);

$Self->False(
    index( $Result, 'otrs.Console.pl Help command' ) > -1,
    "Help for 'Help' command not found",
);

$Self->True(
    index( $Result, 'No commands found.' ) > -1,
    "No commands found.",
);

1;
