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

my @Tests = (
    {
        Name      => 'Command completion',
        COMP_LINE => 'bin/otrs.Console.pl Hel',
        Arguments => [ 'bin/otrs.Console.pl', 'Hel', 'bin/otrs.Console.pl' ],
        Result    => "Help",
    },
    {
        Name      => 'Argument list',
        COMP_LINE => 'bin/otrs.Console.pl Admin::Article::StorageSwitch ',
        Arguments => [ 'bin/otrs.Console.pl', '', 'Admin::Article::SwitchStorage' ],
        Result    => "--target
--tickets-closed-before-date
--tickets-closed-before-days
--tolerant
--micro-sleep
--force-pid",
    },
    {
        Name      => 'Argument list limitted',
        COMP_LINE => 'bin/otrs.Console.pl Admin::Article::StorageSwitch --to',
        Arguments => [ 'bin/otrs.Console.pl', '--to', 'Admin::Article::SwitchStorage' ],
        Result    => "--tolerant",
    },
);

for my $Test (@Tests) {

    my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Internal::BashCompletion');

    my ( $Result, $ExitCode );

    {
        local $ENV{COMP_LINE} = $Test->{COMP_LINE};
        local *STDOUT;
        open STDOUT, '>:utf8', \$Result;    ## no critic
        $ExitCode = $CommandObject->Execute( @{ $Test->{Arguments} } );
    }

    $Self->Is(
        $ExitCode,
        0,
        "$Test->{Name} exit code",
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} result",
    );

}

1;
