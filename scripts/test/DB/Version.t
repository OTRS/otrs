# --
# Version.t - database version
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars qw($Self);

my $Version = $Self->{DBObject}->Version();

$Self->True(
    $Version,
    "DBObject Version() generated version $Version",
);

# extract text string and version number from Version
# just as a sanity check
my $Text    = '';
my $Numeral = '';
if ( $Version =~ /(\w*)\s*([0-9\.]*)/ ) {
    $Text    = $1;
    $Numeral = $2;
}

$Self->True(
    $Version,
    "DBObject Version() contains text '$Text'",
);

$Self->True(
    $Version,
    "DBObject Version() contains numeral '$Numeral'",
);

1;
