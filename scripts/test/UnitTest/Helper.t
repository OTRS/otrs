# --
# Helper.t - unit tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new();

$Self->True(
    $HelperObject,
    "Instance created",
);

my %Seen;
my $DuplicateFound;

LOOP:
for my $I (1 .. 1_000_000) {
    my $RandomID = $HelperObject->GetRandomID();
    if ($Seen{$RandomID}++) {
        $Self->True(
            0,
            "GetRandomID iteration $I returned a duplicate RandomID $RandomID",
        );
        $DuplicateFound++;
        last LOOP;
    }
}

$Self->False(
    $DuplicateFound,
    "GetRandomID() returned no duplicates",
);
1;
