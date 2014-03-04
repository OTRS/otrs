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
    DummyObject => {
        Data => 'Test payload',
    }
);

$Self->True( $Kernel::OM, 'Could build object manager' );

my $Dummy = eval { $Kernel::OM->Get('DummyObject') };
$Self->True( !$Dummy, 'Can not get dummy object before it is registered' );

$Kernel::OM->ObjectRegister(
    Name      => 'DummyObject',
    ClassName => 'scripts::test::sample::Dummy',
);

$Dummy = $Kernel::OM->Get('DummyObject');

$Self->True( $Dummy, 'Can get dummy object after registration' );

$Self->Is(
    $Dummy->Data(),
    'Test payload',
    'Speciailization of late registered object',
);

weaken($Dummy);

$Self->True( $Dummy, 'Object still alive' );

$Kernel::OM->ObjectsDiscard();

$Self->True( !$Dummy, 'ObjectsDiscard without arguments deleted object' );

$Dummy = $Kernel::OM->Get('DummyObject');
weaken($Dummy);
$Self->True( $Dummy, 'Object created again' );

$Kernel::OM->ObjectsDiscard(
    Objects => ['DummyObject'],
);
$Self->True( !$Dummy, 'ObjectsDiscard with list of objects deleted object' );

# now test that all configured objects can be created and then destroyed;
# that way we know there are no cyclic references in the constructors

my @Objects = sort keys %{ $Kernel::OM->Get('ConfigObject')->Get('Objects') };

# some objects need extra data/configuration; exlcude them
my %Exclude = (
    CryptObject          => 1, # needs CryptType
    PostMasterObject     => 1, # needs Email
    StatsObject          => 1, # needs UserID
    UnitTestHelperObject => 1, # needs UnitTestObject
);
@Objects = grep { !$Exclude{ $_ } } @Objects;

my %AllObjects = $Kernel::OM->ObjectHash(
    Objects => \@Objects,
);

for my $ObjectName ( sort keys %AllObjects ) {
    weaken( $AllObjects{ $ObjectName } );
}

$Kernel::OM->ObjectsDiscard();

for my $ObjectName ( sort keys %AllObjects ) {
    $Self->True(
        !defined($AllObjects{ $ObjectName }),
        "ObjectsDiscard got rid of $ObjectName",
    );
}

my %SomeObjects = $Kernel::OM->ObjectHash(
    Objects => ['ConfigObject', 'TicketObject', 'DBObject'],
);
for my $ObjectName ( sort keys %SomeObjects ) {
    weaken( $SomeObjects{ $ObjectName } );
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

1;
