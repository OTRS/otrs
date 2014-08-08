# --
# ObjectManager/ObjectLifecycle.t - ObjectManager tests
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

use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new();

# test that all configured objects can be created and then destroyed;
# that way we know there are no cyclic references in the constructors

my %ObjectAliases = %{ $Kernel::OM->Get('Kernel::Config')->Get('ObjectAliases') };
my @Objects       = sort keys %ObjectAliases;

# some objects need extra data/configuration; exclude them
my %Exclude = (
    CryptObject          => 1,    # needs CryptType
    PostMasterObject     => 1,    # needs Email
    StatsObject          => 1,    # needs UserID
    UnitTestHelperObject => 1,    # needs UnitTestObject
);
@Objects = grep { !$Exclude{$_} } @Objects;

my %AllObjects;

for my $Object (@Objects) {
    my $AliasObject   = $Kernel::OM->Get($Object);
    my $PackageObject = $Kernel::OM->Get( $ObjectAliases{$Object} );
    $AllObjects{$Object} = $PackageObject;
    $Self->True(
        $AliasObject,
        "ObjectManager could create $Object",
    );
    $Self->Is(
        $AliasObject,
        $PackageObject,
        "ObjectManager understands both $Object and $ObjectAliases{$Object}",
    );
}

for my $ObjectName ( sort keys %AllObjects ) {
    weaken( $AllObjects{$ObjectName} );
}

$Kernel::OM->ObjectsDiscard();

for my $ObjectName ( sort keys %AllObjects ) {
    $Self->True(
        !defined( $AllObjects{$ObjectName} ),
        "ObjectsDiscard got rid of $ObjectName",
    );
}

my %SomeObjects = (
    'Kernel::Config'         => $Kernel::OM->Get('Kernel::Config'),
    'Kernel::System::DB'     => $Kernel::OM->Get('Kernel::System::DB'),
    'Kernel::System::Ticket' => $Kernel::OM->Get('Kernel::System::Ticket'),
);

for my $ObjectName ( sort keys %SomeObjects ) {
    weaken( $SomeObjects{$ObjectName} );
}

$Kernel::OM->ObjectsDiscard(
    Objects => ['Kernel::System::DB'],
);

$Self->True(
    !$SomeObjects{'Kernel::System::DB'},
    'ObjectDiscard discarded Kernel::System::DB',
);
$Self->True(
    !$SomeObjects{'Kernel::System::Ticket'},
    'ObjectDiscard discarded Kernel::System::Ticket, because it depends on Kernel::System::DB',
);
$Self->True(
    $SomeObjects{'Kernel::Config'},
    'ObjectDiscard did not discard Kernel::Config',
);

# test custom objects
# note that DummyObject creates a Dummy2Object in its destructor,
# even though it didn't declare a dependency on it.
# The object manager must be robust enough to deal with that.

my $Dummy = eval { $Kernel::OM->Get('DummyObject') };
$Self->True( !$Dummy, 'Can not get dummy object before it is registered' );

$Kernel::OM->{ObjectAliases}->{DummyObject}  = 'scripts::test::ObjectManager::Dummy';
$Kernel::OM->{ObjectAliases}->{Dummy2Object} = 'scripts::test::ObjectManager::Dummy2';

$Kernel::OM->ObjectParamAdd(
    DummyObject => {
        Data => 'Test payload',
    },
);

$Dummy = $Kernel::OM->Get('DummyObject');
my $Dummy2 = $Kernel::OM->Get('Dummy2Object');

$Self->True( $Dummy,  'Can get Dummy object after registration' );
$Self->True( $Dummy2, 'Can get Dummy2 object after registration' );

$Self->Is(
    $Dummy->Data(),
    'Test payload',
    'Speciailization of late registered object',
);

weaken($Dummy);
weaken($Dummy2);

$Self->True( $Dummy, 'Object still alive' );

$Kernel::OM->ObjectsDiscard();

$Self->True( !$Dummy,  'ObjectsDiscard without arguments deleted Dummy' );
$Self->True( !$Dummy2, 'ObjectsDiscard without arguments deleted Dummy2' );

$Self->True(
    !$Kernel::OM->{Objects}{Dummy2Object},
    'ObjecstDiscard also discarded newly autovivified objects'
);

$Dummy = $Kernel::OM->Get('DummyObject');
weaken($Dummy);
$Self->True( $Dummy, 'Object created again' );

$Kernel::OM->ObjectsDiscard(
    Objects => ['DummyObject'],
);
$Self->True( !$Dummy, 'ObjectsDiscard with list of objects deleted object' );

my $NonexistingObject = eval { $Kernel::OM->Get('Nonexisting::Package') };
$Self->True(
    $@,
    "Fetching a nonexisting object causes an exception",
);
$Self->False(
    $NonexistingObject,
    "Cannot construct a nonexisting object",
);

eval { $Kernel::OM->Get() };
$Self->True(
    $@,
    "Invalid object name causes an exception",
);

# Clean up
$Kernel::OM->ObjectsDiscard();

1;
