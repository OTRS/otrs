# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

my $Home = $Self->{ConfigObject}->Get('Home');
my $TmpSumString;

if ( open( $TmpSumString, '-|', "$^X $Home/bin/otrs.CheckModules.pl NoColors" ) ) {    ## no critic

    while (<$TmpSumString>) {
        my $TmpLine = $_;
        $TmpLine =~ s/\n//g;
        if ( $TmpLine =~ m{ok|optional}ismx ) {
            $Self->True(
                $TmpLine,
                "$TmpLine",
            );
        }
        else {
            $Self->False(
                $TmpLine,
                "Error in your installed perl modules: $TmpLine",
            );
        }
    }
    close($TmpSumString);

}
else {
    $Self->False(
        1,
        'Unable to check Perl modules',
    );
}

1;
