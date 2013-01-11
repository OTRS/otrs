# --
# YAML.t - tests for the YAML parser
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: YAML.t,v 1.7 2013-01-11 04:38:37 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use YAML;

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
#    {
#        Name => 'Very long string', # see https://bugzilla.redhat.com/show_bug.cgi?id=19240_0000
#        Data => 'a ' x 40_000,
#    },
#    {
#        Name => 'Very long string, double quoted', # see https://bugzilla.redhat.com/show_bug.cgi?id=19240_0000
#        Data => 'a ' x 40_000,
#        YAMLString => '--- "' . ('a ' x 40_000) . "\"\n"  
#    },
#    {
#        Name => 'Very long string, single quoted', # see https://bugzilla.redhat.com/show_bug.cgi?id=19240_0000
#        Data => 'a ' x 40_000,
#        YAMLString => '--- \'' . ('a ' x 40_000) . "'\n"  
#    },
    {
        Name => 'Compiled Regexp',
        Data => {
            Key => qr{My[ ]Regexp}msx,
        },
    },
);

for my $Test (@Tests) {
    my $YAMLString = $Test->{YAMLString} || YAML::Dump( $Test->{Data} );
    my $YAMLData   = YAML::Load( $YAMLString );
    
    
    $Self->IsDeeply(
        $Test->{Data},
        $YAMLData,
        $Test->{Name},
    );
}

1;
