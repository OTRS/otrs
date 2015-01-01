# --
# Type.t - Type tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::Type;

my $TypeObject = Kernel::System::Type->new( %{$Self} );

# add type
my $TypeNameRand0 = 'unittest' . int rand 1000000;

my $TypeID = $TypeObject->TypeAdd(
    Name    => $TypeNameRand0,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $TypeID,
    'TypeAdd()',
);

# get the type by using the type id
my %Type = $TypeObject->TypeGet( ID => $TypeID );

$Self->Is(
    $Type{Name} || '',
    $TypeNameRand0,
    'TypeGet() - Name (using the type id)',
);
$Self->Is(
    $Type{ValidID} || '',
    1,
    'TypeGet() - ValidID',
);

# get the type by using the type name
%Type = $TypeObject->TypeGet( Name => $TypeNameRand0 );

$Self->Is(
    $Type{Name} || '',
    $TypeNameRand0,
    'TypeGet() - Name (using the type name)',
);

my %TypeList = $TypeObject->TypeList();

my $Hit = 0;
for ( sort keys %TypeList ) {
    if ( $_ eq $TypeID ) {
        $Hit = 1;
    }
}
$Self->True(
    $Hit,
    'TypeList()',
);

my $TypeUpdate = $TypeObject->TypeUpdate(
    ID      => $TypeID,
    Name    => $TypeNameRand0 . '1',
    ValidID => 2,
    UserID  => 1,
);

$Self->True(
    $TypeUpdate,
    'TypeUpdate()',
);

%Type = $TypeObject->TypeGet( ID => $TypeID );

$Self->Is(
    $Type{Name} || '',
    $TypeNameRand0 . '1',
    'TypeGet() - Name',
);

$Self->Is(
    $Type{ValidID} || '',
    2,
    'TypeGet() - ValidID',
);

my $TypeLookup = $TypeObject->TypeLookup( TypeID => $TypeID );

$Self->Is(
    $TypeLookup || '',
    $TypeNameRand0 . '1',
    'TypeLookup() - TypeID',
);

my $TypeIDLookup = $TypeObject->TypeLookup( Type => $TypeLookup );

$Self->Is(
    $TypeIDLookup || '',
    $TypeID,
    'TypeLookup() - Type',
);

# perform 2 different TypeLists to check the caching
my %TypeListValid = $TypeObject->TypeList( Valid => 1 );

my %TypeListAll = $TypeObject->TypeList( Valid => 0 );

$Hit = 0;
for ( sort keys %TypeListValid ) {
    if ( $_ eq $TypeID ) {
        $Hit = 1;
    }
}
$Self->False(
    $Hit,
    'TypeList() - only valid types',
);

$Hit = 0;
for ( sort keys %TypeListAll ) {
    if ( $_ eq $TypeID ) {
        $Hit = 1;
    }
}
$Self->True(
    $Hit,
    'TypeList() - all types',
);

1;
