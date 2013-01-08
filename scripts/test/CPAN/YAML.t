# --
# YAML.t - tests for the YAML parser
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: YAML.t,v 1.3 2013-01-08 12:40:36 mg Exp $
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
        Data => 'Teststring <tag> äß@ø',
    },
#    {
#        Name => 'Very long string', # see https://bugzilla.redhat.com/show_bug.cgi?id=192400
#        Data => 'a ' x 40_000,
#    },
);

for my $Test (@Tests) {
    my $YAMLString = YAML::Dump( $Test->{Data} );
    my $YAMLData   = YAML::Load( $YAMLString );
    
    $Self->IsDeeply(
        $Test->{Data},
        $YAMLData,
        $Test->{Name},
    );
}

1;
