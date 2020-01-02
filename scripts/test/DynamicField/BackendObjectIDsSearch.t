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

use Kernel::System::VariableCheck qw(:all);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# define needed variable
my $RandomID = $Helper->GetRandomNumber();

# create a dynamic field
my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "dynamicfieldtest$RandomID",
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'CustomerUser',
    Config     => {
        DefaultValue => 'a value',
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $FieldID,
    "DynamicFieldAdd() successful for Field ID $FieldID",
);

my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet( ID => $FieldID );

# set dynamic field value via object name
my @ObjectNames;
for my $Count ( 1 .. 3 ) {
    push @ObjectNames, $Helper->GetRandomID();
}

for my $ObjectName (@ObjectNames) {
    my $Success = $BackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        Value              => "This is a sample text for ObjectIDsSearch.",
        UserID             => 1,
        ObjectName         => $ObjectName,
    );
    $Self->True(
        $Success,
        'Creation of dynamic field value via object name must succeed.'
    );
}

# fetch object IDs for object names
my $ObjectIDByObjectName = $Kernel::OM->Get('Kernel::System::DynamicField')->ObjectMappingGet(
    ObjectName => \@ObjectNames,
    ObjectType => 'CustomerUser',
);
$Self->Is(
    scalar keys %{$ObjectIDByObjectName},
    scalar @ObjectNames,
    'Number of found object IDs must match number of object names.',
);

# check that dynamic field search returns expected object IDs
my $DynamicFieldValues = $BackendObject->ValueSearch(
    DynamicFieldConfig => $DynamicFieldConfig,
    Search             => 'sample text for ObjectIDsSearch',
);
my $ObjectIDs = [];
if ( IsArrayRefWithData($DynamicFieldValues) ) {
    my %ObjectIDs = map { $_->{ObjectID} => 1 } @{$DynamicFieldValues};
    $ObjectIDs = [ keys %ObjectIDs ];
}

$Self->True(
    IsArrayRefWithData($ObjectIDs),
    'ObjectIDsSearch must return a result.'
);

my $ObjectIDsMatch = ( scalar keys %{$ObjectIDByObjectName} == scalar @{$ObjectIDs} ) ? 1 : 0;
if ($ObjectIDsMatch) {
    my %ObjectNameByObjectID = reverse %{$ObjectIDByObjectName};
    OBJECTID:
    for my $ObjectID ( @{$ObjectIDs} ) {
        next OBJECTID if $ObjectNameByObjectID{$ObjectID};

        $ObjectIDsMatch = 0;
        last OBJECTID;
    }
}

$Self->True(
    $ObjectIDsMatch,
    'ObjectIDsSearch must return expected object IDs.',
);

# cleanup is done by RestoreDatabase

1;
