# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $Version = $DBObject->Version();

$Self->True(
    $Version,
    "DBObject Version() generated version $Version",
);

$Self->IsNot(
    $Version,
    'unknown',
    "DBObject Version() generated version $Version",
);

# extract text string and version number from Version
# just as a sanity check
my ( $Text, $Number ) = $Version =~ /(\w+)\s+([0-9\.]+)/;

$Self->True(
    $Text,
    "DBObject Version() $Version contains a name (found $Text)",
);

$Self->True(
    $Number,
    "DBObject Version() $Version contains a version number (found $Number)",
);

1;
