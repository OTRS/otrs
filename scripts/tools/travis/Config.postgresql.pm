# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Config;    ## no critic

use strict;
use warnings;
use utf8;

use File::Basename;

sub Load {
    my $Self = shift;

    $Self->{DatabaseHost}     = '127.0.0.1';
    $Self->{Database}         = 'otrs';
    $Self->{DatabaseUser}     = 'otrs';
    $Self->{DatabasePw}       = 'otrs';
    $Self->{DatabaseDSN}      = "DBI:Pg:dbname=$Self->{Database};host=$Self->{DatabaseHost}";
    $Self->{Home}             = dirname dirname __FILE__;
    $Self->{TestHTTPHostname} = 'localhost:5000';
    $Self->{TestDatabase}     = {
        DatabaseDSN  => "DBI:Pg:dbname=otrstest;host=$Self->{DatabaseHost}",
        DatabaseUser => 'otrstest',
        DatabasePw   => 'otrstest',
    };
    return;
}

use parent qw(Kernel::Config::Defaults);

1;
