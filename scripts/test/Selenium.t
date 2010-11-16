# --
# Selenium.t - run frontend tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Selenium.t,v 1.1 2010-11-16 13:32:55 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use File::Glob qw(bsd_glob);

use vars qw($Self);

if ( $Self->{ConfigObject}->Get('SeleniumTestsActive') ) {

    my $Home  = $Self->{ConfigObject}->Get('Home');
    my @Files = bsd_glob("$Home/scripts/test/Selenium/*.t");

    FILE:
    for my $File (@Files) {

        my $ConfigFile = $Self->{MainObject}->FileRead( Location => $File );

        print STDERR $File, "\n";

        if ( !$ConfigFile ) {
            die "$! ($File)";
        }
        else {
            if ( !eval ${$ConfigFile} ) {
                die "$@ ($File)";
            }
        }
    }
}
else {
    $Self->True( 1, 'Selenium testing is not active' );
}

1;
