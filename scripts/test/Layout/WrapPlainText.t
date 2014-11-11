# --
# scripts/test/Layout/WrapPlainText.t - layout testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Output::HTML::Layout;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

my $LayoutObject = Kernel::Output::HTML::Layout->new(
    UserChallengeToken => 'TestToken',
    UserID             => 1,
    Lang               => 'de',
    SessionID          => 123,
);

my $MaxCharacters = $ConfigObject->Get('Ticket::Frontend::TextAreaEmail');

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
