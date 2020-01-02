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

my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Tools::Shell');

my $DependencyMissing;
for my $Dependency ( 'Devel::REPL', 'Data::Printer' ) {
    $DependencyMissing = 1 if !$Kernel::OM->Get('Kernel::System::Main')->Require( $Dependency, Silent => 1 );
}

if ($DependencyMissing) {
    $Self->True( 1, "Not all prerequisites installed, skipping tests" );
    return 1;
}

my @Tests = (
    {
        Name     => 'Hello World',
        Code     => "'Hello World!';",
        Result   => '"Hello World!"',
        ExitCode => 0,
    },
    {
        Name     => 'OTRS Version string',
        Code     => '$Kernel::OM->Get("Kernel::Config")->Get("Version");',
        Result   => '"' . $ConfigObject->Get('Version') . '"',
        ExitCode => 0,
    },
    {
        Name     => 'OTRS Version variable',
        Code     => 'my $OTRSVersion = $Kernel::OM->Get("Kernel::Config")->Get("Version");',
        Result   => '"' . $ConfigObject->Get('Version') . '"',
        ExitCode => 0,
    },
    {
        Name   => 'Hash variable',
        Code   => 'my %Hash = ( Test1 => 1, Test2 => 2 )',
        Result => '\ {
    Test1   1,
    Test2   2
}',
        ExitCode => 0,
    },
    {
        Name   => 'List variable',
        Code   => 'my @List = ( "Test1", 1, "Test1", 2 )',
        Result => '\ [
    [0] "Test1",
    [1] 1,
    [2] "Test1",
    [3] 2
]',
        ExitCode => 0,
    },
);

for my $Test (@Tests) {

    my $Result;
    my $ExitCode;
    {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$Result;
        $ExitCode = $CommandObject->Execute( '--eval', $Test->{Code} );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }

    $Self->Is(
        $ExitCode,
        $Test->{ExitCode},
        "Dev::Tools::Shell exit code '$Test->{Name}'",
    );

    chomp $Result;

    $Self->Is(
        $Result,
        $Test->{Result},
        "Dev::Tools::Shell output '$Test->{Name}'",
    );
}

1;
