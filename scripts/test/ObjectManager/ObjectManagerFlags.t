# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

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

# Test exceptions in Create()
$Object = eval { $Kernel::OM->Create('scripts::test::ObjectManager::WrongPackageName') };
$Self->True(
    $@,
    "Creating a nonexisting object via OM causes an exception",
);
$Self->False(
    $Object,
    "Cannot create a nonexisting object",
);

$Object = eval {
    $Kernel::OM->Create(
        'scripts::test::ObjectManager::WrongPackageName',
        Silent => 1,
    );
};
$Self->False(
    $@,
    "Creating a nonexisting object via OM causes no exception with Silent => 1",
);
$Self->False(
    $Object,
    "Cannot create a nonexisting object with Silent => 1",
);

$Object = eval { $Kernel::OM->Create('scripts::test::ObjectManager::ConstructorFailure') };
$Self->True(
    $@,
    "Creating an object with failing constructor via OM causes an exception",
);
$Self->False(
    $Object,
    "Cannot create an object with failing constructor",
);

$Object = eval {
    $Kernel::OM->Create(
        'scripts::test::ObjectManager::ConstructorFailure',
        Silent => 1,
    );
};
$Self->False(
    $@,
    "Creating an object with failing constructor via OM causes no exception with Silent => 1",
);
$Self->False(
    $Object,
    "Cannot create an object with failing constructor",
);

$Object = eval {
    $Kernel::OM->Create(
        'scripts::test::ObjectManager::AllowConstructorFailure',
    );
};
$Self->False(
    $@,
    "Creating an object with failing constructor via OM causes no exception with AllowConstructorFailure => 1",
);
$Self->False(
    $Object,
    "Cannot create an object with failing constructor",
);

#
# Live example of a Singleton
#

$Object = $Kernel::OM->Get('Kernel::System::Encode');
$Self->True(
    $Object,
    "Created singleton EncodeObject."
);

$Object = eval { $Kernel::OM->Create('Kernel::System::Encode') };
$Self->True(
    $@,
    "Fetching singleton EncodeObject via Create() causes an exception",
);
$Self->False(
    $Object,
    "Singleton EncodeObject cannot be fetched via Create()",
);

1;
