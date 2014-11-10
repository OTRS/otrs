# --
# Type.t - Type tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::ObjectManager;
my @IDs;

# get needed objects
my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

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

push( @IDs, $TypeID );

# add type with existing name
my $TypeIDWrong = $TypeObject->TypeAdd(
    Name    => $TypeNameRand0,
    ValidID => 1,
    UserID  => 1,
);

$Self->False(
    $TypeIDWrong,
    'TypeAdd( - Try to add type with existing name',
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

# add another type
my $TypeSecondName = $TypeNameRand0 . '2';
my $TypeIDSecond   = $TypeObject->TypeAdd(
    Name    => $TypeSecondName,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $TypeIDSecond,
    "TypeAdd() - Name: \'$TypeSecondName\' ID: \'$TypeIDSecond\'",
);

push( @IDs, $TypeIDSecond );

# update with existing name
my $TypeUpdateWrong = $TypeObject->TypeUpdate(
    ID      => $TypeIDSecond,
    Name    => $TypeNameRand0 . '1',
    ValidID => 1,
    UserID  => 1,
);

$Self->False(
    $TypeUpdateWrong,
    "TypeUpdate() - Try to update the type with existing name",
);

# check function NameExistsCheck()
# check does it exist a type with certain Name or
# check is it possible to set Name for type with certain ID
my $Exist = $TypeObject->NameExistsCheck(
    Name => $TypeSecondName,
);
$Self->True(
    $Exist,
    "NameExistsCheck() - A type with \'$TypeSecondName\' already exists!",
);

# there is a type with certain name, now check if there is another one
$Exist = $TypeObject->NameExistsCheck(
    Name => $TypeSecondName,
    ID   => $TypeIDSecond,
);
$Self->False(
    $Exist,
    "NameExistsCheck() - Another type \'$TypeSecondName\' for ID=$TypeIDSecond does not exists!",
);
$Exist = $TypeObject->NameExistsCheck(
    Name => $TypeSecondName,
    ID   => $TypeID,
);
$Self->True(
    $Exist,
    "NameExistsCheck() - Another type \'$TypeSecondName\' for ID=$TypeID already exists!",
);

# check is there a type whose name has been updated in the meantime
$Exist = $TypeObject->NameExistsCheck(
    Name => $TypeNameRand0,
);
$Self->False(
    $Exist,
    "NameExistsCheck() - A type with \'$TypeNameRand0\' does not exists!",
);
$Exist = $TypeObject->NameExistsCheck(
    Name => $TypeNameRand0,
    ID   => $TypeID,
);
$Self->False(
    $Exist,
    "NameExistsCheck() - Another type \'$TypeNameRand0\' for ID=$TypeID does not exists!",
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

# Since there are no tickets that rely on our test types, we can remove them again
#   from the DB.
for my $ID (@IDs) {
    my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "DELETE FROM ticket_type WHERE id = $ID",
    );
    $Self->True(
        $Success,
        "TypeDelete() - $ID",
    );
}

# Make sure the cache is correct.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'Type',
);

1;
