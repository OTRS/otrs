# --
# YAML.t - tests for the YAML parser
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::YAML;

# create needed objects
my $ConfigObject = Kernel::Config->new();
my $YAMLObject   = Kernel::System::YAML->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my @Tests = (
    {
        Name => 'Simple string',
        Data => 'Teststring <tag> äß@ø " \\" \' \'\'',
    },
    {
        Name => 'Complex data',
        Data => {
            Key   => 'Teststring <tag> äß@ø " \\" \' \'\'',
            Value => [
                {
                    Subkey  => 'Value',
                    Subkey2 => undef,
                },
                1234,
                0,
                undef,
                'Teststring <tag> äß@ø " \\" \' \'\'',
            ],
        },
    },
    {
        Name => 'Special YAML chars',
        Data => ' a " a " a \'\' a \'\' a',
    },
    {
        Name => 'UTF8 string',
        Data => 'kéy',
    },
    {
        Name       => 'UTF8 string, loader',
        Data       => 'kéy',
        YAMLString => '--- kéy' . "\n",
    },
    {
        Name => 'UTF8 string without UTF8-Flag',
        Data => 'k\x{e9}y',
    },
    {
        Name       => 'UTF8 string without UTF8-Flag, loader',
        Data       => 'k\x{e9}y',
        YAMLString => '--- k\x{e9}y' . "\n",
    },
    {
        Name => 'Very long string',      # see https://bugzilla.redhat.com/show_bug.cgi?id=192400
        Data => ' äø<>"\'' x 40_000,
        SkipEngine => 'YAML',            # This test does not run with plain YAML, see the bug above
    },
    {
        Name => 'Wrong newline',
        Data => {
            DefaultValue => '',
            PossibleValues => undef,
        },
        YAMLString => "---\rDefaultValue: ''\rPossibleValues: ~\r",
    },
    {
        Name => 'Windows newline',
        Data => {
            DefaultValue => '',
            PossibleValues => undef,
        },
        YAMLString => "---\r\nDefaultValue: ''\r\nPossibleValues: ~\r\n",
    },
    {
        Name => 'Unix newline',
        Data => {
            DefaultValue => '',
            PossibleValues => undef,
        },
        YAMLString => "---\nDefaultValue: ''\nPossibleValues: ~\n",
    },
);

ENGINE:
for my $Engine (qw(YAML::XS YAML)) {

    # locally override the internal engine of YAML::Any to force testing
    local @YAML::Any::_TEST_ORDER = ($Engine);    ## no critic

    TEST:
    for my $Test (@Tests) {
        next TEST if defined $Test->{SkipEngine} && $Engine eq $Test->{SkipEngine};

        my $YAMLString = $Test->{YAMLString} || $YAMLObject->Dump( Data => $Test->{Data} );
        my $YAMLData = $YAMLObject->Load( Data => $YAMLString );

        $Self->IsDeeply(
            $YAMLData,
            $Test->{Data},
            "Engine $Engine - $Test->{Name}",
        );
    }
}

1;
