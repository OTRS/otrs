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

# get type object
my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# add type
my $TypeName = 'Type' . $Helper->GetRandomID();

my $TypeID = $TypeObject->TypeAdd(
    Name    => $TypeName,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $TypeID,
    'TypeAdd()',
);

# add type with existing name
my $TypeIDWrong = $TypeObject->TypeAdd(
    Name    => $TypeName,
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
    $TypeName,
    'TypeGet() - Name (using the type id)',
);
$Self->Is(
    $Type{ValidID} || '',
    1,
    'TypeGet() - ValidID',
);

# get the type by using the type name
%Type = $TypeObject->TypeGet( Name => $TypeName );

$Self->Is(
    $Type{Name} || '',
    $TypeName,
    'TypeGet() - Name (using the type name)',
);

my %TypeList = $TypeObject->TypeList();

$Self->True(
    exists $TypeList{$TypeID} && $TypeList{$TypeID} eq $TypeName,
    'TypeList() contains the type ' . $TypeName . ' with ID ' . $TypeID,
);

my $TypeUpdateName = $TypeName . 'update';
my $TypeUpdate     = $TypeObject->TypeUpdate(
    ID      => $TypeID,
    Name    => $TypeUpdateName,
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
    $TypeUpdateName,
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
    $TypeUpdateName,
    'TypeLookup() - TypeID',
);

my $TypeIDLookup = $TypeObject->TypeLookup( Type => $TypeLookup );

$Self->Is(
    $TypeIDLookup || '',
    $TypeID,
    'TypeLookup() - Type',
);

# add another type
my $TypeSecondName = $TypeName . 'second';
my $TypeIDSecond   = $TypeObject->TypeAdd(
    Name    => $TypeSecondName,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $TypeIDSecond,
    "TypeAdd() - Name: \'$TypeSecondName\' ID: \'$TypeIDSecond\'",
);

# update with existing name
my $TypeUpdateWrong = $TypeObject->TypeUpdate(
    ID      => $TypeIDSecond,
    Name    => $TypeUpdateName,
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
    Name => $TypeName,
);
$Self->False(
    $Exist,
    "NameExistsCheck() - A type with \'$TypeName\' does not exists!",
);
$Exist = $TypeObject->NameExistsCheck(
    Name => $TypeName,
    ID   => $TypeID,
);
$Self->False(
    $Exist,
    "NameExistsCheck() - Another type \'$TypeName\' for ID=$TypeID does not exists!",
);

# set Ticket::Type::Default config item
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Ticket::Type::Default',
    Value => $TypeSecondName,
);

# update the default ticket type
$TypeUpdateWrong = $TypeObject->TypeUpdate(
    ID      => $TypeIDSecond,
    Name    => $TypeSecondName,
    ValidID => 2,
    UserID  => 1,
);

$Self->False(
    $TypeUpdateWrong,
    "The ticket type is set as a default ticket type, so it cannot be changed! - $TypeSecondName",
);

# get all types
my %TypeListAll = $TypeObject->TypeList( Valid => 0 );
$Self->True(
    exists $TypeListAll{$TypeID} && $TypeListAll{$TypeID} eq $TypeUpdateName,
    'TypeList() contains the type ' . $TypeUpdateName . ' with ID ' . $TypeID,
);

# get valid types
my %TypeListValid = $TypeObject->TypeList( Valid => 1 );
$Self->False(
    exists $TypeListValid{$TypeID},
    'TypeList() does not contain the type ' . $TypeUpdateName . ' with ID ' . $TypeID,
);

# Check log message if TypeGet is not found any data.
# See PR#2009 for more information ( https://github.com/OTRS/otrs/pull/2009 ).
my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
%Type = $TypeObject->TypeGet( ID => '999999' );

my $ErrorMessage = $LogObject->GetLogEntry(
    Type => 'error',
    What => 'Message',
);

$Self->Is(
    $ErrorMessage,
    "TypeID '999999' not found!",
    "TypeGet() - '999999' not found",
);

my $NoDataType = 'no_data_type' . $Helper->GetRandomID();
%Type = $TypeObject->TypeGet( Name => $NoDataType );

$ErrorMessage = $LogObject->GetLogEntry(
    Type => 'error',
    What => 'Message',
);

$Self->Is(
    $ErrorMessage,
    "TypeID for Type '$NoDataType' not found!",
    "TypeGet() - $NoDataType not found",
);

# cleanup is done by RestoreDatabase.

1;
