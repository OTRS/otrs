# --
# YAML/Load.t - YAML module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw( $Self %Param );

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $YAMLObject   = $Kernel::OM->Get('Kernel::System::YAML');

my @Tests = (
    {
        Input  => undef,
        Result => undef,
        Name   => 'YAML - undef test',
    },
    {
        Input  => '',
        Result => "--- ''\n",
        Name   => 'YAML - empty test',
    },
    {
        Input  => 'Some Text',
        Result => "--- Some Text\n",
        Name   => 'YAML - simple',
    },
    {
        Input  => 42,
        Result => "--- 42\n",
        Name   => 'YAML - simple',
    },
    {
        Input => [ 1, 2, "3", "Foo", 5 ],
        Result => "---\n- 1\n- 2\n- '3'\n- Foo\n- 5\n",
        Name   => 'YAML - simple',
    },
    {
        Input => {
            Key1   => "Value1",
            Key2   => 42,
            "Key3" => "Another Value"
        },
        Result => "---\nKey1: Value1\nKey2: 42\nKey3: Another Value\n",
        Name   => 'YAML - simple',
    },
    {
        Input => [
            [ 1, 2, "Foo", "Bar" ],
            {
                Key1 => 'Something',
                Key2 => [ "Foo", "Bar" ],
                Key3 => {
                    Foo => 'Bar',
                },
                Key4 => {
                    Bar => [ "f", "o", "o" ]
                    }
            },
        ],
        Result =>
            "---\n"
            . "- - 1\n"
            . "  - 2\n"
            . "  - Foo\n"
            . "  - Bar\n"
            . "- Key1: Something\n"
            . "  Key2:\n"
            . "  - Foo\n"
            . "  - Bar\n"
            . "  Key3:\n"
            . "    Foo: Bar\n"
            . "  Key4:\n"
            . "    Bar:\n"
            . "    - f\n"
            . "    - o\n"
            . "    - o\n",
        Name => 'YAM - complex structure',
    },
);

for my $Test (@Tests) {

    my $YAML = $YAMLObject->Dump(
        Data => $Test->{Input},
    );

    $Self->IsDeeply(
        $YAML,
        $Test->{Result},
        $Test->{Name},
    );
}

@Tests = (
    {
        Result    => undef,
        InputLoad => undef,
        Name      => 'YAML - undef test',
    },
    {
        Result    => undef,
        InputLoad => "--- Key: malformed\n - 1\n",
        Name      => 'YAML - malformed data test',
    },
    {
        Result    => 'Some Text',
        InputLoad => "--- Some Text\n",
        Name      => 'YAML - simple'
    },
    {
        Result    => 42,
        InputLoad => "--- 42\n",
        Name      => 'YAML - simple'
    },
    {
        Result => [ 1, 2, "3", "Foo", 5 ],
        InputLoad => "---\n- 1\n- 2\n- '3'\n- Foo\n- 5\n",
        Name      => 'YAML - simple'
    },
    {
        Result => {
            Key1   => "Value1",
            Key2   => 42,
            "Key3" => "Another Value"
        },
        InputLoad => "---\nKey1: Value1\nKey2: 42\nKey3: Another Value\n",
        Name      => 'YAML - simple'
    },
    {
        Result => [
            [ 1, 2, "Foo", "Bar" ],
            {
                Key1 => 'Something',
                Key2 => [ "Foo", "Bar" ],
                Key3 => {
                    Foo => 'Bar',
                },
                Key4 => {
                    Bar => [ "f", "o", "o" ]
                    }
            },
        ],
        InputLoad =>
            "---\n"
            . "- - 1\n"
            . "  - 2\n"
            . "  - Foo\n"
            . "  - Bar\n"
            . "- Key1: Something\n"
            . "  Key2:\n"
            . "  - Foo\n"
            . "  - Bar\n"
            . "  Key3:\n"
            . "    Foo: Bar\n"
            . "  Key4:\n"
            . "    Bar:\n"
            . "    - f\n"
            . "    - o\n"
            . "    - o\n",
        Name => 'YAML - complex structure'
    },
);

for my $Test (@Tests) {
    my $Perl = $YAMLObject->Load(
        Data => $Test->{InputLoad},
    );

    $Self->IsDeeply(
        scalar $Perl,
        scalar $Test->{Result},
        $Test->{Name},
    );
}

1;
