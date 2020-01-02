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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::GenericInterface::DebugLog::Cleanup');

my ( $Result, $ExitCode );

my @Tests = (
    {
        Name     => 'No Params',
        Config   => [],
        ExitCode => 1,
    },
    {
        Name     => 'Missing created-before-days value',
        Config   => ['--created-before-days'],
        ExitCode => 1,
    },
    {
        Name     => 'Negative created-before-days value',
        Config   => [ '--created-before-days', '-1' ],
        ExitCode => 1,
    },
    {
        Name     => '0 created-before-days value',
        Config   => [ '--created-before-days', '0' ],
        ExitCode => 1,
    },
    {
        Name     => '20 years ago created-before-days value',
        Config   => [ '--created-before-days', 7_300 ],
        ExitCode => 0,
    },
);

for my $Test (@Tests) {

    {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$Result;
        $ExitCode = $CommandObject->Execute( @{ $Test->{Config} } );
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
    }

    $Self->Is(
        $ExitCode,
        $Test->{ExitCode},
        "$Test->{Name} ExitCode",
    );
}

1;
