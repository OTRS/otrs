# --
# YAML.t - tests for the YAML parser
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: YAML.t,v 1.9 2013-01-15 15:04:21 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use YAML::XS;

my @Tests = (
    {
        Name => 'Simple string',
        Data => 'Teststring <tag> äß@ø " \\" \' \'\'',
    },
    {
        Name => 'Complex data',
        Data => {
            Key => 'Teststring <tag> äß@ø " \\" \' \'\'',
            Value => [
                {
                    Subkey => 'Value',
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
        Name => 'Very long string', # see https://bugzilla.redhat.com/show_bug.cgi?id=19240_0000
        Data => 'äø<>"\'' x 40_000,
    },
);

for my $Test (@Tests) {
    my $YAMLString = $Test->{YAMLString} || Dump( $Test->{Data} );
    my $YAMLData   = Load( $YAMLString );
    
    $Self->IsDeeply(
        $YAMLData,
        $Test->{Data},
        $Test->{Name},
    );
}

1;
