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

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Name          => 'WrapPlainText() - #1 Check if already cleanly wrapped text is not changed.',
        Type          => 'Is',
        MaxCharacters => 80,
        String        => "123456789_123456789_123456789_ 123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_
",
        Result => "123456789_123456789_123456789_ 123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_
",
        Type => 'Is',
    },
    {
        Name =>
            'WrapPlainText() - #2 Check if newline is added at EOL if a string does not end with it.',
        Type          => 'Is',
        MaxCharacters => 80,
        String =>
            "123456789_123456789_123456789_ 123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_",
        Result => "123456789_123456789_123456789_ 123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_
",
        Type => 'Is',
    },
    {
        Name          => 'WrapPlainText() - #3 Check if cited text does not get wrapped',
        Type          => 'Is',
        MaxCharacters => 80,
        String =>
            "> 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_
> 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_",
        Result =>
            "> 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_
> 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_
",
    },
    {
        Name =>
            'WrapPlainText() - #4 Check if regular text containing spaces gets wrapped after 80 chars.',
        Type          => 'Is',
        MaxCharacters => 80,
        String =>
            "123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_",
        Result => "123456789_123456789_123456789_123456789_
123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_
123456789_123456789_123456789_123456789_123456789_
123456789_123456789_123456789_
123456789_123456789_123456789_123456789_123456789_
123456789_123456789_123456789_
123456789_123456789_123456789_123456789_123456789_
",
    },
    {
        Name =>
            'WrapPlainText() - #5 Check if a line that is longer than 80 chars containing no spaces does not get wrapped.',
        Type          => 'Is',
        MaxCharacters => 80,
        String =>
            "_123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_ _123456789_123456789_123456789_",
        Result => "_123456789_123456789_123456789_
123456789_123456789_123456789_123456789_123456789_123456789_
123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_
_123456789_123456789_123456789_
",
    },
    {
        Name          => 'WrapPlainText() - #6 Check if undef does not get modified.',
        Type          => 'Is',
        MaxCharacters => 80,
        String        => undef,
        Result        => undef,
    },
    {
        Name          => 'WrapPlainText() - #7 Check if empty strings do not get modified.',
        Type          => 'Is',
        MaxCharacters => 80,
        String        => '',
        Result        => '',
    },
    {
        Name          => 'WrapPlainText() - #8 Check if missing MaxCharacters raise an exception.',
        Type          => 'False',
        MaxCharacters => undef,
        String        => "123456789_123456789_123456789_ 123456789_123456789_",
    },
    {
        Name =>
            'WrapPlainText() - #9 Check if a submitting non-string variables raise an exception.',
        Type          => 'False',
        MaxCharacters => 80,
        String        => [ '12345', '12345', '12345', ]
    },
    {
        Name          => 'WrapPlainText() - #10 bug#110778 check that no additional newlines are produced.',
        Type          => 'Is',
        MaxCharacters => 78,
        String =>
            "
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\r
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\r
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\r
",
        Result => "
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
",
    },
);

for my $Test (@Tests) {
    my $Result = $LayoutObject->WrapPlainText(
        PlainText     => $Test->{String},
        MaxCharacters => $Test->{MaxCharacters},
    );
    if ( $Test->{Type} eq 'Is' ) {
        $Self->Is(
            $Result,
            $Test->{Result},
            $Test->{Name},
        );
    }
    elsif ( $Test->{Type} eq 'False' ) {
        $Self->False(
            $Result,
            $Test->{Name},
        );
    }
}

1;
