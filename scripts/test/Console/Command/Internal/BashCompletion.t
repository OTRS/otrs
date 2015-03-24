# --
# BashCompletion.t - bash completion tests
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

my @Tests = (
    {
        Name      => 'Command completion',
        COMP_LINE => 'bin/otrs.Console.pl H',
        Arguments => [ 'bin/otrs.Console.pl', 'H', 'bin/otrs.Console.pl' ],
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
