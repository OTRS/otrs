# --
# ObjectManager/ObjectManagerDisabled.t - ObjectManager tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Scalar::Util qw/weaken/;

$Self->True(
    $Kernel::OM->Get('scripts::test::ObjectManager::Dummy'),
    "Can load custom object",
);

my $NonexistingObject = eval { $Kernel::OM->Get('scripts::test::ObjectManager::Disabled') };
$Self->True(
    $@,
    "Fetching an object that cannot be loaded via OM causes an exception",
);
$Self->False(
    $NonexistingObject,
    "Cannot construct an object that cannot be loaded via OM",
);

1;
