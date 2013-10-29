# --
# DynamicField.t - DynamicField tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::DynamicField;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = $HelperObject->GetRandomID();

$RandomID =~ s/\-//g;

# set $UserId
my $UserID = 1;

my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$Self} );

my @Tests = (
    {
        Name          => 'test1',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Config => {
                Name        => 'AnyName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'something for label',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'InternalField',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            InternalField => 1,
            Config        => {
                Name        => 'AnyName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'something for label',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'Test2',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Config => {
                Name        => '!"§$%&/()=?Ü*ÄÖL:L@,.-',
                Description => 'Description for Dynamic Field.',
            },
            Label      => '!"§$%&/()=?Ü*ÄÖL:L@,.-',
            FieldOrder => 10000,
            FieldType  => 'Date',
            ObjectType => 'Ticket',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'Test3',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Config => {
                Name        => 'OtherName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'alabel',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'Test4',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Config     => {},
            Label      => 'nothing interesting',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'Test5',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config     => undef,
            Label      => 'label',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'Test6',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'OtherName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => '',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'Test7',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'OtherName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'Other label',
            FieldOrder => 10000,
            FieldType  => '',
            ObjectType => 'Article',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'Test8',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'OtherName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'Complex label',
            FieldOrder => 10000,
            FieldType  => 'Int',
            ObjectType => '',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'Test9',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'NameTwo',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'Simple Label',
            FieldType  => 'Text',
            FieldOrder => 10000,
            ObjectType => 'Ticket',
            ValidID    => '',
            UserID     => $UserID,
        },
    },
    {
        Name          => 'Test10',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'Config Name',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'Other label',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            ValidID    => 1,
            UserID     => '',
        },
    },
    {
        Name          => 'Test 11',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'Config Name',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'Other label',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'Test1',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'AnyName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'something for label',
            FieldOrder => 10000,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
);

my $OriginalDynamicFields = $DynamicFieldObject->DynamicFieldListGet( Valid => 0 );

my @DynamicFieldIDs;
my %FieldNames;
for my $Test (@Tests) {

    my $FieldName = $Test->{Name} . $RandomID;

    # get nonexisting field first
    my $GetResult = $DynamicFieldObject->DynamicFieldGet(
        Name => $FieldName,
    );

    if (
        !$Self->{DBObject}->GetDatabaseFunction('CaseSensitive')
        && $FieldNames{ lc $FieldName }
        )
    {
        $Self->IsNotDeeply(
            $GetResult,
            {},
            "Get before Add for field $FieldName",
        );
    }
    else {
        $Self->IsDeeply(
            $GetResult,
            {},
            "Get before Add for field $FieldName",
        );
    }

    # add config
    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name => $FieldName,
        %{ $Test->{Add} },
    );
    if ( !$Test->{SuccessAdd} ) {
        $Self->False(
            $DynamicFieldID,
            "$Test->{Name} - DynamicFieldAdd()",
        );
        next;
    }
    else {
        $Self->True(
            $DynamicFieldID,
            "$Test->{Name} - DynamicFieldAdd()",
        );
    }

    # remember id to delete it later
    push @DynamicFieldIDs, $DynamicFieldID;
    $FieldNames{$FieldName} = 1;

    # get config
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . $RandomID,
        $DynamicField->{Name},
        "$Test->{Name} - DynamicFieldGet() Name",
    );
    $Self->Is(
        $DynamicField->{InternalField},
        $Test->{Add}->{InternalField} ? 1 : 0,
        "$Test->{Name} - DynamicFieldGet() - InternalField",
    );
    $Self->IsDeeply(
        $DynamicField->{Config},
        $Test->{Add}->{Config},
        "$Test->{Name} - DynamicFieldGet() - Config",
    );

    my $DynamicFieldByName = $DynamicFieldObject->DynamicFieldGet(
        Name => $Test->{Name} . $RandomID,
    );

    $Self->IsDeeply(
        \$DynamicFieldByName,
        \$DynamicField,
        "$Test->{Name} - DynamicFieldGet() with Name parameter result",
    );

    # get config from cache
    my $DynamicFieldFromCache = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );

    # verify config from cache
    $Self->Is(
        $Test->{Name} . $RandomID,
        $DynamicFieldFromCache->{Name},
        "$Test->{Name} - DynamicFieldGet() from cache",
    );
    $Self->IsDeeply(
        $DynamicFieldFromCache->{Config},
        $Test->{Add}->{Config},
        "$Test->{Name} - DynamicFieldGet() from cache- Config",
    );

    $Self->IsDeeply(
        $DynamicField,
        $DynamicFieldFromCache,
        "$Test->{Name} - DynamicFieldGet() - Cache and DB",
    );

    my $DynamicFieldByNameFromCache = $DynamicFieldObject->DynamicFieldGet(
        Name => $Test->{Name} . $RandomID,
    );

    $Self->IsDeeply(
        \$DynamicFieldByNameFromCache,
        \$DynamicFieldFromCache,
        "$Test->{Name} - DynamicFieldGet() with Name parameter result from cache",
    );

    # update config with a modification
    if ( !$Test->{Update} ) {
        $Test->{Update} = $Test->{Add};
    }
    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        ID   => $DynamicFieldID,
        Name => $Test->{Name} . $RandomID,
        %{ $Test->{Update} },
    );
    if ( !$Test->{SuccessUpdate} ) {
        $Self->False(
            $Success,
            "$Test->{Name} - DynamicFieldUpdate() False",
        );
        next;
    }
    else {
        $Self->True(
            $Success,
            "$Test->{Name} - DynamicFieldUpdate() True",
        );
    }

    # get config
    $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . $RandomID,
        $DynamicField->{Name},
        "$Test->{Name} - DynamicFieldGet()",
    );
    $Self->IsDeeply(
        $DynamicField->{Config},
        $Test->{Update}->{Config},
        "$Test->{Name} - DynamicFieldGet() - Config",
    );

    $DynamicFieldByName = $DynamicFieldObject->DynamicFieldGet(
        Name => $Test->{Name} . $RandomID,
    );

    $Self->IsDeeply(
        \$DynamicFieldByName,
        \$DynamicField,
        "$Test->{Name} - DynamicFieldGet() with Name parameter result",
    );

    # verify if cache was also updated
    if ( $Test->{SuccessUpdate} ) {
        my $DynamicFieldUpdateFromCache = $DynamicFieldObject->DynamicFieldGet(
            ID     => $DynamicFieldID,
            UserID => 1,
        );

        # verify config from cache
        $Self->Is(
            $Test->{Name} . $RandomID,
            $DynamicFieldUpdateFromCache->{Name},
            "$Test->{Name} - DynamicFieldGet() from cache",
        );
        $Self->IsDeeply(
            $DynamicFieldUpdateFromCache->{Config},
            $Test->{Update}->{Config},
            "$Test->{Name} - DynamicFieldGet() from cache- Config",
        );
    }
}

# list check from DB
my $DynamicFieldList = $DynamicFieldObject->DynamicFieldList( Valid => 0, ResultType => 'HASH' );
for my $DynamicFieldID (@DynamicFieldIDs) {
    $Self->True(
        scalar $DynamicFieldList->{$DynamicFieldID},
        "DynamicFieldList() from DB found DynamicField $DynamicFieldID",
    );
}

# list check from cache
$DynamicFieldList = $DynamicFieldObject->DynamicFieldList( Valid => 0, ResultType => 'HASH' );
for my $DynamicFieldID (@DynamicFieldIDs) {
    $Self->True(
        scalar $DynamicFieldList->{$DynamicFieldID},
        "DynamicFieldList() from Cache found DynamicField $DynamicFieldID",
    );
}

# Dynamic Field List Get
$DynamicFieldList = $DynamicFieldObject->DynamicFieldList( Valid => 0 );
my @Data;
for my $DynamicFieldID ( @{$DynamicFieldList} ) {
    my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );
    push @Data, $DynamicFieldGet;
}

# list get check from DB
my $DynamicFieldListGet = $DynamicFieldObject->DynamicFieldListGet( Valid => 0 );
$Self->IsDeeply(
    $DynamicFieldListGet,
    \@Data,
    "DynamicFieldListGet() from DB found DynamicField ",
);

# list get check from cache
$DynamicFieldListGet = $DynamicFieldObject->DynamicFieldListGet( Valid => 0 );
$Self->IsDeeply(
    $DynamicFieldListGet,
    \@Data,
    "DynamicFieldListGet() from Cache found DynamicField ",
);

# list get check from DB for object type Test
$DynamicFieldListGet = $DynamicFieldObject->DynamicFieldListGet(
    Valid      => 0,
    ObjectType => 'Test'
);
$Self->IsDeeply(
    $DynamicFieldListGet,
    [],
    "DynamicFieldListGet() from DB Empty for ObjetType Test ",
);

# list get check from cache for object type Test
$DynamicFieldListGet = $DynamicFieldObject->DynamicFieldListGet(
    Valid      => 0,
    ObjectType => 'Test'
);
$Self->IsDeeply(
    $DynamicFieldListGet,
    [],
    "DynamicFieldListGet() from cache Empty for ObjetType Test ",
);

# list check from DB for object type Test
$DynamicFieldList = $DynamicFieldObject->DynamicFieldList(
    Valid      => 0,
    ObjectType => 'Test',
);
$Self->Is(
    scalar @{$DynamicFieldList},
    0,
    "DynamicFieldList() from DB empty for FieldType Test ",
);

# list check from Cache for object type Test
$DynamicFieldList = $DynamicFieldObject->DynamicFieldList(
    Valid      => 0,
    ObjectType => 'Test',
);
$Self->Is(
    scalar @{$DynamicFieldList},
    0,
    "DynamicFieldList() from Cache empty for FieldType Test ",
);

my %SeparatedData;
my %SeparatedIDs;

# separate ticket and article dynamic fields
for my $DynamicField (@Data) {

    if ( $DynamicField->{ObjectType} eq 'Ticket' ) {
        push @{ $SeparatedData{Ticket} }, $DynamicField;
        push @{ $SeparatedIDs{Ticket} },  $DynamicField->{ID}
    }
    elsif ( $DynamicField->{ObjectType} eq 'Article' ) {
        push @{ $SeparatedData{Article} }, $DynamicField;
        push @{ $SeparatedIDs{Article} },  $DynamicField->{ID}
    }
}

for my $ObjecType (qw(Ticket Article)) {

    # list get check from DB for each object type
    $DynamicFieldListGet = $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 0,
        ObjectType => $ObjecType
    );
    $Self->IsDeeply(
        $DynamicFieldListGet,
        $SeparatedData{$ObjecType},
        "DynamicFieldListGet() from DB for ObjetType $ObjecType ",
    );

    # list get check from cache for each object type
    $DynamicFieldListGet = $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 0,
        ObjectType => $ObjecType
    );
    $Self->IsDeeply(
        $DynamicFieldListGet,
        $SeparatedData{$ObjecType},
        "DynamicFieldListGet() from cache for ObjetType $ObjecType ",
    );

    # list check from DB for each object type
    $DynamicFieldList = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ObjectType => $ObjecType,
    );
    $Self->Is(
        scalar @{$DynamicFieldList},
        scalar @{ $SeparatedData{$ObjecType} },
        "DynamicFieldList() from DB for FieldType $ObjecType ",
    );

    # list check deeply from DB for each object type
    $Self->IsDeeply(
        $DynamicFieldList,
        $SeparatedIDs{$ObjecType},
        "DynamicFieldList() deeply check from DB for FieldType $ObjecType ",
    );

    # list check from Cache for each object type
    $DynamicFieldList = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ObjectType => $ObjecType,
    );
    $Self->Is(
        scalar @{$DynamicFieldList},
        scalar @{ $SeparatedData{$ObjecType} },
        "DynamicFieldList() from Cache for FieldType $ObjecType ",
    );

    # list check deeply from Cache for each object type
    $Self->IsDeeply(
        $DynamicFieldList,
        $SeparatedIDs{$ObjecType},
        "DynamicFieldList() deeply check from Cache for FieldType $ObjecType ",
    );
}

# delete config
for my $DynamicFieldID (@DynamicFieldIDs) {
    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );
    $Self->True(
        $Success,
        "DynamicFieldDelete() deleted DynamicField $DynamicFieldID",
    );
    $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );
    $Self->False(
        $Success,
        "DynamicFieldDelete() deleted DynamicField $DynamicFieldID",
    );
}

# list check from DB
$DynamicFieldList = $DynamicFieldObject->DynamicFieldList( Valid => 0, ResultType => 'HASH' );
for my $DynamicFieldID (@DynamicFieldIDs) {
    $Self->False(
        scalar $DynamicFieldList->{$DynamicFieldID},
        "DynamicFieldList() did not find DynamicField $DynamicFieldID",
    );
}

# list check from cache
$DynamicFieldList = $DynamicFieldObject->DynamicFieldList( Valid => 0, ResultType => 'HASH' );
for my $DynamicFieldID (@DynamicFieldIDs) {
    $Self->False(
        scalar $DynamicFieldList->{$DynamicFieldID},
        "DynamicFieldList() from cache did not find DynamicField $DynamicFieldID",
    );
}

# FieldOrder tests
@Tests = (
    {
        Name => 'testorder1',
        Add  => {
            Config     => {},
            Label      => 'nothing interesting',
            FieldOrder => 9001,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name => 'testorder2',
        Add  => {
            Config     => {},
            Label      => 'nothing interesting',
            FieldOrder => 9002,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name => 'testorder3',
        Add  => {
            Config     => {},
            Label      => 'nothing interesting',
            FieldOrder => 9003,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name => 'testorder4',
        Add  => {
            Config     => {},
            Label      => 'nothing interesting',
            FieldOrder => 9004,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name => 'testorder5',
        Add  => {
            Config     => {},
            Label      => 'nothing interesting',
            FieldOrder => 9005,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name => 'testorder6',
        Add  => {
            Config     => {},
            Label      => 'nothing interesting',
            FieldOrder => 9006,
            FieldType  => 'Text',
            ObjectType => 'Article',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
);

my @AddedFieldIDs;
my %OrderLookup;
for my $Test (@Tests) {

    # add dynamic field
    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name => $Test->{Name} . $RandomID,
        %{ $Test->{Add} }
    );

    # sanity check
    $Self->True(
        $DynamicFieldID,
        "DynamicFieldAdd() FieldOrderTests for FieldID $DynamicFieldID"
    );

    if ($DynamicFieldID) {
        push @AddedFieldIDs, $DynamicFieldID;

        $OrderLookup{ $Test->{Name} . $RandomID } = $Test->{Add}->{FieldOrder};
    }

}

# sanity checks
$Self->Is(
    scalar @AddedFieldIDs,
    scalar @Tests,
    'Added DynamicField numbers match the number of defined fields in this part of the test'
);

$Self->IsNotDeeply(
    \%OrderLookup,
    {},
    'OrderLookup table elements is not empty',
);

$Self->Is(
    scalar keys %OrderLookup,
    scalar @Tests,
    'OrderLookup table elements match the number of defined fields in this part of the test'
);

# backup original order lookup table
my %OrigOrderLookup = %OrderLookup;

# backup original fields configuration
my @OrigFieldsConfig;
for my $DynamicFieldID (@AddedFieldIDs) {

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );
    push @OrigFieldsConfig, $DynamicField;
}

# check that the initial order is as expected
for my $DynamicFieldID (@AddedFieldIDs) {

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );

    $Self->Is(
        $DynamicField->{FieldOrder},
        $OrderLookup{ $DynamicField->{Name} },
        "Order (Initial) Test for field ID $DynamicFieldID",
    );
}

# prepare tests
my @UpdateTests = (
    {
        Name          => 'Moved a field to the beginning',
        MovedField    => 'testorder4',
        NewFieldOrder => 9001,
        OrderLoockup  => {
            'testorder4' . $RandomID => 9001,
            'testorder1' . $RandomID => 9002,
            'testorder2' . $RandomID => 9003,
            'testorder3' . $RandomID => 9004,
            'testorder5' . $RandomID => 9005,
            'testorder6' . $RandomID => 9006,
        },
    },
    {
        Name          => 'Moved a field to the end',
        MovedField    => 'testorder4',
        NewFieldOrder => 9006,
        OrderLoockup  => {
            'testorder1' . $RandomID => 9001,
            'testorder2' . $RandomID => 9002,
            'testorder3' . $RandomID => 9003,
            'testorder5' . $RandomID => 9004,
            'testorder6' . $RandomID => 9005,
            'testorder4' . $RandomID => 9006,
        },
    },
    {
        Name          => 'Moved a field to lower order',
        MovedField    => 'testorder4',
        NewFieldOrder => 9003,
        OrderLoockup  => {
            'testorder1' . $RandomID => 9001,
            'testorder2' . $RandomID => 9002,
            'testorder4' . $RandomID => 9003,
            'testorder3' . $RandomID => 9004,
            'testorder5' . $RandomID => 9005,
            'testorder6' . $RandomID => 9006,
        },
    },
    {
        Name          => 'Moved a field to upper order',
        MovedField    => 'testorder4',
        NewFieldOrder => 9005,
        OrderLoockup  => {
            'testorder1' . $RandomID => 9001,
            'testorder2' . $RandomID => 9002,
            'testorder3' . $RandomID => 9003,
            'testorder5' . $RandomID => 9004,
            'testorder4' . $RandomID => 9005,
            'testorder6' . $RandomID => 9006,
        },
    },
    {
        Name          => 'Moved a field from first to end',
        MovedField    => 'testorder1',
        NewFieldOrder => 9006,
        OrderLoockup  => {
            'testorder2' . $RandomID => 9001,
            'testorder3' . $RandomID => 9002,
            'testorder4' . $RandomID => 9003,
            'testorder5' . $RandomID => 9004,
            'testorder6' . $RandomID => 9005,
            'testorder1' . $RandomID => 9006,
        },
    },
    {
        Name          => 'Moved a field from end to beginning',
        MovedField    => 'testorder6',
        NewFieldOrder => 9001,
        OrderLoockup  => {
            'testorder6' . $RandomID => 9001,
            'testorder1' . $RandomID => 9002,
            'testorder2' . $RandomID => 9003,
            'testorder3' . $RandomID => 9004,
            'testorder4' . $RandomID => 9005,
            'testorder5' . $RandomID => 9006,
        },
    },
    {
        Name          => 'Moved a field from first to middle',
        MovedField    => 'testorder1',
        NewFieldOrder => 9004,
        OrderLoockup  => {
            'testorder2' . $RandomID => 9001,
            'testorder3' . $RandomID => 9002,
            'testorder4' . $RandomID => 9003,
            'testorder1' . $RandomID => 9004,
            'testorder5' . $RandomID => 9005,
            'testorder6' . $RandomID => 9006,
        },
    },
    {
        Name          => 'Moved a field from end to middle',
        MovedField    => 'testorder6',
        NewFieldOrder => 9004,
        OrderLoockup  => {
            'testorder1' . $RandomID => 9001,
            'testorder2' . $RandomID => 9002,
            'testorder3' . $RandomID => 9003,
            'testorder6' . $RandomID => 9004,
            'testorder4' . $RandomID => 9005,
            'testorder5' . $RandomID => 9006,
        },
    },
);

# perform move tests
for my $Test (@UpdateTests) {
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => $Test->{MovedField} . $RandomID,
    );
    $DynamicField->{FieldOrder} = $Test->{NewFieldOrder};

    # update the field
    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        %{$DynamicField},
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldUpdate() Move Order $Test->{Name} Test",
    );

    # reorder the OrderLookup Table
    my %NewOrderLoockup = %{ $Test->{OrderLoockup} };
    %OrderLookup = %NewOrderLoockup;

    # check that the order is as expected
    for my $DynamicFieldID (@AddedFieldIDs) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        $Self->Is(
            $DynamicField->{FieldOrder},
            $OrderLookup{ $DynamicField->{Name} },
            "Move Order $Test->{Name} Test for field ID $DynamicFieldID",
        );
    }

    # revert all changes
    for my $DynamicField (@OrigFieldsConfig) {

        # update dynamic fields without reordering
        my $Success = $DynamicFieldObject->DynamicFieldUpdate(
            %{$DynamicField},
            Reorder => 0,
            UserID  => $UserID,
        );

        # sanity check
        $Self->True(
            $Success,
            "DynamicFielUpdate() revert changes (without reorder) for FieldID $DynamicField->{ID}"
        );
    }

    # revert OrderLookup table
    %OrderLookup = %OrigOrderLookup;

    # sanity check
    for my $DynamicFieldID (@AddedFieldIDs) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        $Self->Is(
            $DynamicField->{FieldOrder},
            $OrderLookup{ $DynamicField->{Name} },
            "Move Order (Reverted) Test for field ID $DynamicFieldID",
        );
    }
}

# test for add and delete
my @AddDeleteTests = (
    {
        Name     => 'Add a field to the beginning',
        AddField => {
            Name       => 'testorder7' . $RandomID,
            Label      => 'nothing interesting',
            FieldOrder => 9001,
            FieldType  => 'Text',
            ObjectType => 'Article',
            Config     => {},
            ValidID    => 2,
            UserID     => $UserID,
        },
        OrderLoockup => {
            'testorder7' . $RandomID => 9001,
            'testorder1' . $RandomID => 9002,
            'testorder2' . $RandomID => 9003,
            'testorder3' . $RandomID => 9004,
            'testorder4' . $RandomID => 9005,
            'testorder5' . $RandomID => 9006,
            'testorder6' . $RandomID => 9007,
        },
    },
    {
        Name     => 'Add a field at the end',
        AddField => {
            Name       => 'testorder7' . $RandomID,
            Label      => 'nothing interesting',
            FieldOrder => 9007,
            FieldType  => 'Text',
            ObjectType => 'Article',
            Config     => {},
            ValidID    => 2,
            UserID     => $UserID,
        },
        OrderLoockup => {
            'testorder1' . $RandomID => 9001,
            'testorder2' . $RandomID => 9002,
            'testorder3' . $RandomID => 9003,
            'testorder4' . $RandomID => 9004,
            'testorder5' . $RandomID => 9005,
            'testorder6' . $RandomID => 9006,
            'testorder7' . $RandomID => 9007,
        },
    },
    {
        Name     => 'Add a field at the middle',
        AddField => {
            Name       => 'testorder7' . $RandomID,
            Label      => 'nothing interesting',
            FieldOrder => 9004,
            FieldType  => 'Text',
            ObjectType => 'Article',
            Config     => {},
            ValidID    => 2,
            UserID     => $UserID,
        },
        OrderLoockup => {
            'testorder1' . $RandomID => 9001,
            'testorder2' . $RandomID => 9002,
            'testorder3' . $RandomID => 9003,
            'testorder7' . $RandomID => 9004,
            'testorder4' . $RandomID => 9005,
            'testorder5' . $RandomID => 9006,
            'testorder6' . $RandomID => 9007,
        },
    },
);

# perform Add Delete tests
for my $Test (@AddDeleteTests) {

    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        %{ $Test->{AddField} },
    );

    # sanity check
    $Self->True(
        $FieldID,
        "DynamicFieldAdd() Add Order - Test ($Test->{Name}) - for field ID $FieldID"
    );

    push @AddedFieldIDs, $FieldID;

    # reorder the OrderLookup Table
    my %NewOrderLoockup = %{ $Test->{OrderLoockup} };
    %OrderLookup = %NewOrderLoockup;

    # check that the order is as expected
    for my $DynamicFieldID (@AddedFieldIDs) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        $Self->Is(
            $DynamicField->{FieldOrder},
            $OrderLookup{ $DynamicField->{Name} },
            "Add Order - Test ($Test->{Name}) - for field ID $DynamicFieldID",
        );
    }

    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $FieldID,
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldDelete() Delete Order - Test ($Test->{Name}) - for Field ID $FieldID"
    );

    # revert OrderLookup
    %OrderLookup = %OrigOrderLookup;

    # remove the FieldID from @AddedFieldIDs
    my $RemovedFieldID = pop @AddedFieldIDs;

    # sanity check
    $Self->Is(
        $RemovedFieldID,
        $FieldID,
        "Field removed from the compare list for FieldID $FieldID",
    );

    # check that the order is reverted
    for my $DynamicFieldID (@AddedFieldIDs) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        $Self->Is(
            $DynamicField->{FieldOrder},
            $OrderLookup{ $DynamicField->{Name} },
            "Delete Order $Test->{Name} Test for field ID $DynamicFieldID",
        );
    }
}

# remove DynamicFields
for my $DynamicFieldID (@AddedFieldIDs) {
    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldDelete() Field Order Tests for Field ID $DynamicFieldID"
    );
}

# restore original fields order
for my $DynamicField ( @{$OriginalDynamicFields} ) {

    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        %{$DynamicField},
        Reorder => 0,
        UserID  => 1,
    );

    # check if update (restore) was successful
    $Self->True(
        $Success,
        "Restored Original Field  - for FieldID $DynamicField->{ID} ",
    );
}

# get fields again
my $RestoredDynamicFields = $DynamicFieldObject->DynamicFieldListGet( Valid => 0 );

# check if fields were restored OK
for my $DynamicField ( @{$OriginalDynamicFields} ) {
    my $RestoredDynamicField = $DynamicFieldObject->DynamicFieldGet( ID => $DynamicField->{ID} );
    for my $Parameter (qw(Name Label FieldOrder FieldType ObjectType ValidID)) {
        $Self->Is(
            $RestoredDynamicField->{$Parameter},
            $DynamicField->{$Parameter},
            "Restored Field matches original field on $Parameter - for FieldID $DynamicField->{ID}",
        );
    }
    $Self->IsDeeply(
        $RestoredDynamicField->{Config},
        $DynamicField->{Config},
        "Restored Field match original field on Config - for FieldID $DynamicField->{ID}",
    );
}

#clean AddedFieldIDs
@AddedFieldIDs = ();

# List and ListGet specific tests
my @ListFields = (
    {
        Name   => 'List1' . $RandomID,
        Label  => 'something for label',
        Config => {
            DefautValue => '',
        },
        FieldOrder => 1101,
        FieldType  => 'Text',
        ObjectType => 'ListTest_Ticket',
        ValidID    => 1,
        UserID     => $UserID,
        Filtered   => 1,
    },
    {
        Name   => 'List2' . $RandomID,
        Label  => 'something for label',
        Config => {
            DefautValue => '',
        },
        FieldOrder => 1102,
        FieldType  => 'Text',
        ObjectType => 'ListTest_Ticket',
        ValidID    => 1,
        UserID     => $UserID,
        Filtered   => 0,
    },
    {
        Name   => 'List3' . $RandomID,
        Label  => 'something for label',
        Config => {
            DefautValue => '',
        },
        FieldOrder => 1103,
        FieldType  => 'Text',
        ObjectType => 'ListTest_Ticket',
        ValidID    => 1,
        UserID     => $UserID,
        Filtered   => 1,
    },
    {
        Name   => 'List4' . $RandomID,
        Label  => 'something for label',
        Config => {
            DefautValue => '',
        },
        FieldOrder => 1104,
        FieldType  => 'Text',
        ObjectType => 'ListTest_Article',
        ValidID    => 1,
        UserID     => $UserID,
        Filtered   => 0,
    },
    {
        Name   => 'List5' . $RandomID,
        Label  => 'something for label',
        Config => {
            DefautValue => '',
        },
        FieldOrder => 1105,
        FieldType  => 'Text',
        ObjectType => 'ListTest_Article',
        ValidID    => 1,
        UserID     => $UserID,
        Filtered   => 1,
    },
    {
        Name   => 'List6' . $RandomID,
        Label  => 'something for label',
        Config => {
            DefautValue => '',
        },
        FieldOrder => 1106,
        FieldType  => 'Text',
        ObjectType => 'ListTest_Other',
        ValidID    => 1,
        UserID     => $UserID,
        Filtered   => 0,
    },

);

# to compare results
my @TicketFieldIDs;
my @TicketFilteredFieldIDs;
my %TicketFieldExtendedIDs;
my %TicketFilteredFieldExtendedIDs;
my @TicketFields;
my @TicketFilteredFields;
my @ArticleFieldIDs;
my @ArticleFilteredFieldIDs;
my %ArticleFieldExtendedIDs;
my %ArticleFilteredFieldExtendedIDs;
my @ArticleFields;
my @ArticleFilteredFields;

# to store the filter list
my %FieldFilter;

# create ListFields and prepare compare structures
for my $FieldConfig (@ListFields) {

    my $FieldID = $DynamicFieldObject->DynamicFieldAdd( %{$FieldConfig} );

    # sanity check
    $Self->True(
        $FieldID,
        "DynamicFieldAdd() for ListField $FieldConfig->{Name}",
    );

    # add to the list to be deleted at the end of the tests
    push @AddedFieldIDs, $FieldID;

    if ( $FieldConfig->{ObjectType} eq 'ListTest_Ticket' ) {

        # add ID to the specific ticket ids
        push @TicketFieldIDs, $FieldID;

        # add ID and name to the ticket extended ids
        $TicketFieldExtendedIDs{$FieldID} = $FieldConfig->{Name};

        my $GotFieldConfig = $DynamicFieldObject->DynamicFieldGet( ID => $FieldID );

        # add field to the ticket fields
        push @TicketFields, $GotFieldConfig;

        if ( $FieldConfig->{Filtered} ) {

            # add the field name to the FieldFilter
            $FieldFilter{ $FieldConfig->{Name} } = 1;

            # add filtered ID to the specific ticket ids
            push @TicketFilteredFieldIDs, $FieldID;

            # add filtered ID and name to the ticket extended ids
            $TicketFilteredFieldExtendedIDs{$FieldID} = $FieldConfig->{Name};

            # add filtered field to the ticket fields
            push @TicketFilteredFields, $GotFieldConfig;
        }
    }
    elsif ( $FieldConfig->{ObjectType} eq 'ListTest_Article' ) {

        # add ID to the specific article ids
        push @ArticleFieldIDs, $FieldID;

        # add ID and name to the article extended ids
        $ArticleFieldExtendedIDs{$FieldID} = $FieldConfig->{Name};

        my $GotFieldConfig = $DynamicFieldObject->DynamicFieldGet( ID => $FieldID );

        # add field to the article fields
        push @ArticleFields, $GotFieldConfig;

        if ( $FieldConfig->{Filtered} ) {

            # add the field name to the FieldFilter
            $FieldFilter{ $FieldConfig->{Name} } = 2;

            # add filtered ID to the specific ticket ids
            push @ArticleFilteredFieldIDs, $FieldID;

            # add filtered ID and name to the ticket extended ids
            $ArticleFilteredFieldExtendedIDs{$FieldID} = $FieldConfig->{Name};

            # add filtered field to the ticket fields
            push @ArticleFilteredFields, $GotFieldConfig;
        }
    }
}

# check ObjectType string and array ref
for my $ObjectType (qw(Ticket Article)) {

    # get the list using an array ref
    my $GotFieldIDs = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ObjectType => [ 'ListTest_' . $ObjectType ],
    );

    # set the correct compare list
    my @CompareFieldIDs = $ObjectType eq 'Ticket' ? @TicketFieldIDs : @ArticleFieldIDs;

    $Self->IsDeeply(
        $GotFieldIDs,
        \@CompareFieldIDs,
        "DynamicFieldList() for ObjecType[$ObjectType]"
    );

    # get the extended list using an array ref
    my $GotExtendedIDs = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ObjectType => [ 'ListTest_' . $ObjectType ],
        ResultType => 'HASH',
    );

    # set the correct compare list
    my %CompareExtendedIDs =
        $ObjectType eq 'Ticket' ? %TicketFieldExtendedIDs : %ArticleFieldExtendedIDs;

    $Self->IsDeeply(
        $GotExtendedIDs,
        \%CompareExtendedIDs,
        "DynamicFieldList() ResultType 'HASH' for ObjecType[$ObjectType]"
    );

    # get the extended list using an array ref
    my $GotFields = $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 0,
        ObjectType => [ 'ListTest_' . $ObjectType ],
    );

    # set the correct compare list
    my @CompareFields =
        $ObjectType eq 'Ticket' ? @TicketFields : @ArticleFields;

    $Self->IsDeeply(
        $GotFields,
        \@CompareFields,
        "DynamicFieldListGet() for ObjecType[$ObjectType]"
    );

    # test with filters
    # get the list using an array ref
    my $GotFilteredFieldIDs = $DynamicFieldObject->DynamicFieldList(
        Valid       => 0,
        ObjectType  => [ 'ListTest_' . $ObjectType ],
        FieldFilter => \%FieldFilter,
    );

    # set the correct compare list
    my @CompareFilteredFieldIDs
        = $ObjectType eq 'Ticket' ? @TicketFilteredFieldIDs : @ArticleFilteredFieldIDs;

    $Self->IsDeeply(
        $GotFilteredFieldIDs,
        \@CompareFilteredFieldIDs,
        "DynamicFieldList() for ObjecType[$ObjectType] with filters"
    );

    # get the extended list using an array ref
    my $GotFilteredExtendedIDs = $DynamicFieldObject->DynamicFieldList(
        Valid       => 0,
        ObjectType  => [ 'ListTest_' . $ObjectType ],
        FieldFilter => \%FieldFilter,
        ResultType  => 'HASH',
    );

    # set the correct compare list
    my %CompareFilteredExtendedIDs =
        $ObjectType eq 'Ticket'
        ? %TicketFilteredFieldExtendedIDs
        : %ArticleFilteredFieldExtendedIDs;

    $Self->IsDeeply(
        $GotFilteredExtendedIDs,
        \%CompareFilteredExtendedIDs,
        "DynamicFieldList() ResultType 'HASH' for ObjecType[$ObjectType] with filters"
    );

    # get the extended list using an array ref
    my $GotFilteredFields = $DynamicFieldObject->DynamicFieldListGet(
        Valid       => 0,
        ObjectType  => [ 'ListTest_' . $ObjectType ],
        FieldFilter => \%FieldFilter,
    );

    # set the correct compare list
    my @CompareFilteredFields =
        $ObjectType eq 'Ticket' ? @TicketFilteredFields : @ArticleFilteredFields;

    $Self->IsDeeply(
        $GotFilteredFields,
        \@CompareFilteredFields,
        "DynamicFieldListGet() for ObjecType[$ObjectType]"
    );
}

# tests with more than one object type
{

    # cobine list for comparisons
    my @ListFieldIDs = (
        @TicketFieldIDs,
        @ArticleFieldIDs,
    );

    my @ListFilteredFieldIDs = (
        @TicketFilteredFieldIDs,
        @ArticleFilteredFieldIDs,
    );

    my %ListExtendendIDs = (
        %TicketFieldExtendedIDs,
        %ArticleFieldExtendedIDs,
    );

    my %ListFilteredExtendendIDs = (
        %TicketFilteredFieldExtendedIDs,
        %ArticleFilteredFieldExtendedIDs,
    );

    my @ListFields = (
        @TicketFields,
        @ArticleFields,
    );

    my @ListFilteredFields = (
        @TicketFilteredFields,
        @ArticleFilteredFields,
    );

    # get the list using an array ref
    my $GotListFieldIDs = $DynamicFieldObject->DynamicFieldList(
        Valid => 0,
        ObjectType => [ 'ListTest_Ticket', 'ListTest_Article' ],
    );

    $Self->IsDeeply(
        $GotListFieldIDs,
        \@ListFieldIDs,
        "DynamicFieldList() for combined object types"
    );

    # get the extended list using an array ref
    my $GotListExtendedIDs = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ObjectType => [ 'ListTest_Ticket', 'ListTest_Article' ],
        ResultType => 'HASH',
    );

    $Self->IsDeeply(
        $GotListExtendedIDs,
        \%ListExtendendIDs,
        "DynamicFieldList() ResultType 'HASH' for combined object types"
    );

    # get the extended list using an array ref
    my $GotListFields = $DynamicFieldObject->DynamicFieldListGet(
        Valid => 0,
        ObjectType => [ 'ListTest_Ticket', 'ListTest_Article' ],
    );

    $Self->IsDeeply(
        $GotListFields,
        \@ListFields,
        "DynamicFieldListGet() for combined object types"
    );

    # filter tests
    # get the list using an array ref
    my $GotListFilteredFieldIDs = $DynamicFieldObject->DynamicFieldList(
        Valid       => 0,
        ObjectType  => [ 'ListTest_Ticket', 'ListTest_Article' ],
        FieldFilter => \%FieldFilter,
    );

    $Self->IsDeeply(
        $GotListFilteredFieldIDs,
        \@ListFilteredFieldIDs,
        "DynamicFieldList() for combined object types"
    );

    # get the extended list using an array ref
    my $GotListFilteredExtendedIDs = $DynamicFieldObject->DynamicFieldList(
        Valid       => 0,
        ObjectType  => [ 'ListTest_Ticket', 'ListTest_Article' ],
        FieldFilter => \%FieldFilter,
        ResultType  => 'HASH',
    );

    $Self->IsDeeply(
        $GotListFilteredExtendedIDs,
        \%ListFilteredExtendendIDs,
        "DynamicFieldList() ResultType 'HASH' for combined object types"
    );

    # get the extended list using an array ref
    my $GotListFilteredFields = $DynamicFieldObject->DynamicFieldListGet(
        Valid       => 0,
        FieldFilter => \%FieldFilter,
        ObjectType  => [ 'ListTest_Ticket', 'ListTest_Article' ],
    );

    $Self->IsDeeply(
        $GotListFilteredFields,
        \@ListFilteredFields,
        "DynamicFieldListGet() for combined object types"
    );
}

# begin order check and reset tests

# reset fields order
my $OrderResetSuccess = $DynamicFieldObject->DynamicFieldOrderReset();

# sanity check (should be success)
$Self->True(
    $OrderResetSuccess,
    'DynamicFieldOrderReset() for initial state, with True',
);

my $OrderCheckSuccess = $DynamicFieldObject->DynamicFieldOrderCheck();

# sanity check (should be success)
$Self->True(
    $OrderCheckSuccess,
    'DynamicFieldOrderCheck() for initial state, with True',
);

# create some duplicated orders
DYNAMICFIELD:
for my $DynamicFieldID (@AddedFieldIDs) {

    next DYNAMICFIELD if $DynamicFieldID == $AddedFieldIDs[0];

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    # substract 1 to the field order to get duplicates at the first added field
    my $FieldOrder = $DynamicField->{FieldOrder} - 1;

    if ( $DynamicFieldID == $AddedFieldIDs[-1] ) {

        # substract an extra one in the last field to also have a duplicate at the last field
        $FieldOrder--;
    }

    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        ID => $DynamicFieldID,
        %{$DynamicField},
        FieldOrder => $FieldOrder,
        UserID     => 1,
        Reorder    => 0,
    );
}

# check that the order list has duplicates
$OrderCheckSuccess = $DynamicFieldObject->DynamicFieldOrderCheck();

$Self->False(
    $OrderCheckSuccess,
    'DynamicFieldOrderCheck() for duplicates, with Flase',
);

# reset fields order
$OrderResetSuccess = $DynamicFieldObject->DynamicFieldOrderReset();

$Self->True(
    $OrderResetSuccess,
    'DynamicFieldOrderReset() remove dulicates, with True',
);

$OrderCheckSuccess = $DynamicFieldObject->DynamicFieldOrderCheck();

$Self->True(
    $OrderCheckSuccess,
    'DynamicFieldOrderCheck() after remove duplicates, with True',
);

# create some gaps in the order
DYNAMICFIELD:
for my $DynamicFieldID (@AddedFieldIDs) {

    # create a get at the first and the last added fields
    next DYNAMICFIELD if $DynamicFieldID ne $AddedFieldIDs[0]
            && $DynamicFieldID ne $AddedFieldIDs[-2];

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    # create a gap in the numbering
    my $FieldOrder = $DynamicField->{FieldOrder} + scalar @AddedFieldIDs + 1;

    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        ID => $DynamicFieldID,
        %{$DynamicField},
        FieldOrder => $FieldOrder,
        UserID     => 1,
        Reorder    => 0,
    );
}

# check that the order list has duplicates
$OrderCheckSuccess = $DynamicFieldObject->DynamicFieldOrderCheck();

$Self->False(
    $OrderCheckSuccess,
    'DynamicFieldOrderCheck() for gaps, with Flase',
);

# reset fields order
$OrderResetSuccess = $DynamicFieldObject->DynamicFieldOrderReset();

$Self->True(
    $OrderResetSuccess,
    'DynamicFieldOrderReset() remove remove gaps, with True',
);

$OrderCheckSuccess = $DynamicFieldObject->DynamicFieldOrderCheck();

$Self->True(
    $OrderCheckSuccess,
    'DynamicFieldOrderCheck() after remove gaps, with True',
);

# remove DynamicFields
for my $DynamicFieldID (@AddedFieldIDs) {
    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldDelete() Field List() and ListGet() for Field ID $DynamicFieldID"
    );
}

1;
