# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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
    "Can load custom object as a singleton",
);

$Self->True(
    $Kernel::OM->Create('scripts::test::ObjectManager::Dummy'),
    "Can load custom object as an instance",
);

my $Object = eval { $Kernel::OM->Get('scripts::test::ObjectManager::Disabled') };
$Self->True(
    $@,
    "Fetching an object that cannot be loaded via OM causes an exception",
);
$Self->False(
    $Object,
    "Cannot construct an object that cannot be loaded via OM",
);

$Object = $Kernel::OM->Get('scripts::test::ObjectManager::Singleton');
$Self->True(
    $Object,
    "Created singleton object."
);

my $Object2 = $Kernel::OM->Get('scripts::test::ObjectManager::Singleton');
$Self->True(
    $Object,
    "Created singleton object."
);

$Self->Is(
    $Object,
    $Object2,
    "Get() returns only one object instance"
);

$Object = eval { $Kernel::OM->Get('scripts::test::ObjectManager::NonSingleton') };
$Self->True(
    $@,
    "Fetching non-singletons via Get() causes an exception",
);
$Self->False(
    $Object,
    "Non-singletons cannot be fetched via Get()",
);

$Object = $Kernel::OM->Create(
    'scripts::test::ObjectManager::NonSingleton',
    ObjectParams => {
        Param1 => 'Value1'
    },
);
$Self->True(
    $Object,
    "Created non-singleton object."
);
$Self->Is(
    $Object->{Param1},
    'Value1',
    "Create() passed in constructor parameters",
);

$Object2 = $Kernel::OM->Create('scripts::test::ObjectManager::NonSingleton');
$Self->True(
    $Object,
    "Created non-singleton object."
);
$Self->False(
    $Object2->{Param1},
    "Create() did not pass in constructor parameters",
);

$Self->IsNot(
    $Object,
    $Object2,
    "Create() returns new instances"
);

1;
