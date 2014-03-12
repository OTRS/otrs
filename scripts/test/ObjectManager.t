# --
# ObjectManager.t - Customer Group tests
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

local $Kernel::OM = Kernel::System::ObjectManager->new(
);

$Self->True( $Kernel::OM, 'Could build object manager' );

# test that all configured objects can be created and then destroyed;
# that way we know there are no cyclic references in the constructors

my @Objects = sort keys %{ $Kernel::OM->Get('ConfigObject')->Get('Objects') };

# some objects need extra data/configuration; exlcude them
my %Exclude = (
    CryptObject          => 1,    # needs CryptType
    PostMasterObject     => 1,    # needs Email
    StatsObject          => 1,    # needs UserID
    UnitTestHelperObject => 1,    # needs UnitTestObject
);
@Objects = grep { !$Exclude{$_} } @Objects;

my %AllObjects = $Kernel::OM->ObjectHash(
    Objects => \@Objects,
);

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

my %SomeObjects = $Kernel::OM->ObjectHash(
    Objects => [ 'ConfigObject', 'TicketObject', 'DBObject' ],
);
for my $ObjectName ( sort keys %SomeObjects ) {
    weaken( $SomeObjects{$ObjectName} );
}

$Kernel::OM->ObjectsDiscard(
    Objects => ['DBObject'],
);

$Self->True(
    !$SomeObjects{DBObject},
    'ObjectDiscard discared DBObject',
);
$Self->True(
    !$SomeObjects{TicketObject},
    'ObjectDiscard discared TicketObject, because it depends on DBObject',
);
$Self->True(
    $SomeObjects{ConfigObject},
    'ObjectDiscard did not discard ConfigObject',
);

# test custom configured objects
# note that DummyObject creates a Dummy2Object in its destructor,
# even though it didn't declare a dependency on it.
# The object manager must be robust enough to deal with that.

my $Dummy = eval { $Kernel::OM->Get('DummyObject') };
$Self->True( !$Dummy, 'Can not get dummy object before it is registered' );

$Kernel::OM->ObjectRegister(
    Name         => 'Dummy2Object',
    ClassName    => 'scripts::test::sample::Dummy2',
    Dependencies => [],
);

$Kernel::OM->ObjectRegister(
    Name         => 'DummyObject',
    ClassName    => 'scripts::test::sample::Dummy',
    Dependencies => [],
    Param        => {
        Data => 'Test payload',
        }
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

# Clean up
$Kernel::OM->ObjectsDiscard();

1;
