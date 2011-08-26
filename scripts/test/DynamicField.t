# --
# DynamicField.t - DynamicField tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DynamicField.t,v 1.14 2011-08-26 16:50:32 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
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
            FieldOrder => 1,
            FieldType  => 'text',
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
            FieldOrder => 1,
            FieldType  => 'date',
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
            FieldOrder => 1,
            FieldType  => 'text',
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
            FieldOrder => 1,
            FieldType  => 'text',
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
            FieldOrder => 1,
            FieldType  => 'text',
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
            FieldOrder => 1,
            FieldType  => 'text',
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
            FieldOrder => 1,
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
            FieldOrder => 1,
            FieldType  => 'int',
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
            FieldType  => 'text',
            FieldOrder => 1,
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
            FieldOrder => 1,
            FieldType  => 'text',
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
            FieldOrder => 1,
            FieldType  => 'text',
            ObjectType => 'Ticket',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
);

my @DynamicFieldIDs;
for my $Test (@Tests) {

    # add config
    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name => $Test->{Name} . $RandomID,
        %{ $Test->{Add} }
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

    # get config
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );

    # verify config
    $Self->Is(
        $Test->{Name} . $RandomID,
        $DynamicField->{Name},
        "$Test->{Name} - DynamicFieldGet()",
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
        %{ $Test->{Update} }
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

# separate ticket and article dynamic fileds
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

    # list check deepy from DB for each object type
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

    # list check deepy from Cache for each object type
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
            FieldType  => 'text',
            ObjectType => 'article',
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
            FieldType  => 'text',
            ObjectType => 'article',
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
            FieldType  => 'text',
            ObjectType => 'article',
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
            FieldType  => 'text',
            ObjectType => 'article',
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
    'OrderLookup tabe elemets is not empty',
);

$Self->Is(
    scalar keys %OrderLookup,
    scalar @Tests,
    'OrderLookup tabe elemets match the number of defined fields in this part of the test'
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

# move last field to the begining
{
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => 'testorder4' . $RandomID,
    );
    $DynamicField->{FieldOrder} = 9001;

    # update the field
    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        %{$DynamicField},
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldUpdate() Order (Moved last to Begining) Test",
    );

    # reorder the OrderLookup Table
    $OrderLookup{ 'testorder4' . $RandomID } = 9001;
    $OrderLookup{ 'testorder1' . $RandomID } = 9002;
    $OrderLookup{ 'testorder2' . $RandomID } = 9003;
    $OrderLookup{ 'testorder3' . $RandomID } = 9004;

    # check that the order is as expected
    for my $DynamicFieldID (@AddedFieldIDs) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        $Self->Is(
            $DynamicField->{FieldOrder},
            $OrderLookup{ $DynamicField->{Name} },
            "Order (Moved last to Begining) Test for field ID $DynamicFieldID",
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
}

# sanity check
for my $DynamicFieldID (@AddedFieldIDs) {

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );

    $Self->Is(
        $DynamicField->{FieldOrder},
        $OrderLookup{ $DynamicField->{Name} },
        "Order (Reverted) Test for field ID $DynamicFieldID",
    );
}

# move last field one position further
{
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => 'testorder4' . $RandomID,
    );
    $DynamicField->{FieldOrder} = 9005;

    # update the field
    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        %{$DynamicField},
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldUpdate() Order (Moved Last one position further) Test",
    );

    # reorder the OrderLookup Table
    $OrderLookup{ 'testorder1' . $RandomID } = 9001;
    $OrderLookup{ 'testorder2' . $RandomID } = 9002;
    $OrderLookup{ 'testorder3' . $RandomID } = 9003;
    $OrderLookup{ 'testorder4' . $RandomID } = 9005;

    # check that the order is as expected
    for my $DynamicFieldID (@AddedFieldIDs) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        $Self->Is(
            $DynamicField->{FieldOrder},
            $OrderLookup{ $DynamicField->{Name} },
            "Order (Moved Last two positions further) Test for field ID $DynamicFieldID",
        );
    }
}

# move pentultimate field to the last
{
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => 'testorder3' . $RandomID,
    );
    $DynamicField->{FieldOrder} = 9006;

    # update the field
    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        %{$DynamicField},
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldUpdate() Order (Moved penultimate to last) Test",
    );

    # reorder the OrderLookup Table
    $OrderLookup{ 'testorder1' . $RandomID } = 9001;
    $OrderLookup{ 'testorder2' . $RandomID } = 9002;
    $OrderLookup{ 'testorder4' . $RandomID } = 9005;
    $OrderLookup{ 'testorder3' . $RandomID } = 9006;

    # check that the order is as expected
    for my $DynamicFieldID (@AddedFieldIDs) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        $Self->Is(
            $DynamicField->{FieldOrder},
            $OrderLookup{ $DynamicField->{Name} },
            "Order (Moved penultimate to last) Test for field ID $DynamicFieldID",
        );
    }
}

# move second to a hole
{
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => 'testorder2' . $RandomID,
    );
    $DynamicField->{FieldOrder} = 9004;

    # update the field
    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        %{$DynamicField},
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldUpdate() Order (Moved second to a hole) Test",
    );

    # reorder the OrderLookup Table
    $OrderLookup{ 'testorder1' . $RandomID } = 9001;
    $OrderLookup{ 'testorder2' . $RandomID } = 9004;
    $OrderLookup{ 'testorder4' . $RandomID } = 9005;
    $OrderLookup{ 'testorder3' . $RandomID } = 9006;

    # check that the order is as expected
    for my $DynamicFieldID (@AddedFieldIDs) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        $Self->Is(
            $DynamicField->{FieldOrder},
            $OrderLookup{ $DynamicField->{Name} },
            "Order (Moved second to a hole) Test for field ID $DynamicFieldID",
        );
    }
}

# move second to a both sides hole
{
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => 'testorder2' . $RandomID,
    );
    $DynamicField->{FieldOrder} = 9003;

    # update the field
    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        %{$DynamicField},
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldUpdate() Order (Moved second to a both sides hole) Test",
    );

    # reorder the OrderLookup Table
    $OrderLookup{ 'testorder1' . $RandomID } = 9001;
    $OrderLookup{ 'testorder2' . $RandomID } = 9003;
    $OrderLookup{ 'testorder4' . $RandomID } = 9005;
    $OrderLookup{ 'testorder3' . $RandomID } = 9006;

    # check that the order is as expected
    for my $DynamicFieldID (@AddedFieldIDs) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        $Self->Is(
            $DynamicField->{FieldOrder},
            $OrderLookup{ $DynamicField->{Name} },
            "Order (Moved second to a both sides hole) Test for field ID $DynamicFieldID",
        );
    }
}

# move first to exaclty match
{
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => 'testorder1' . $RandomID,
    );
    $DynamicField->{FieldOrder} = 9004;

    # update the field
    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        %{$DynamicField},
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "DynamicFieldUpdate() Order (Moved first to exactly match) Test",
    );

    # reorder the OrderLookup Table
    $OrderLookup{ 'testorder2' . $RandomID } = 9003;
    $OrderLookup{ 'testorder1' . $RandomID } = 9004;
    $OrderLookup{ 'testorder4' . $RandomID } = 9005;
    $OrderLookup{ 'testorder3' . $RandomID } = 9006;

    # check that the order is as expected
    for my $DynamicFieldID (@AddedFieldIDs) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        $Self->Is(
            $DynamicField->{FieldOrder},
            $OrderLookup{ $DynamicField->{Name} },
            "Order (Moved second to exactly match) Test for field ID $DynamicFieldID",
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
}

# sanity check
for my $DynamicFieldID (@AddedFieldIDs) {

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );

    $Self->Is(
        $DynamicField->{FieldOrder},
        $OrderLookup{ $DynamicField->{Name} },
        "Order (Reverted) Test for field ID $DynamicFieldID",
    );
}

# place more order tests here (if needed)

# remove DynamicFields
for my $DynamicFieldID (@AddedFieldIDs) {
    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $DynamicFieldID,
        "DynamicFieldDelete() FieldOrderTests for Field ID $DynamicFieldID"
    );
}

# backend tests
@Tests = (
    {
        Name    => 'No Config',
        Success => 0,
    },
    {
        Name        => 'Invalid Config',
        FieldConfig => '',
        Success     => 0,
    },
    {
        Name        => 'Empty Config',
        FieldConfig => {},
        Success     => 0,
    },
    {
        Name        => 'No FieldType',
        FieldConfig => {
            Name => 'text1',
        },
        Success => 0,
    },
    {
        Name        => 'Empty FieldType',
        FieldConfig => {
            Name      => 'text1',
            FieldType => '',
        },
        Success => 0,
    },
    {
        Name        => 'Non existing FieldType',
        FieldConfig => {
            Name      => 'text1',
            FieldType => 'Non_Exising_FieldType_Do_Not_Use_This_Value'
        },
        Success => 0,
    },
    {
        Name        => 'Invalid Module',
        FieldConfig => {
            Name      => 'text1',
            FieldType => 'TestingInvalidModule'
        },
        Success => 0,
    },
    {
        Name        => 'Non Existing Module',
        FieldConfig => {
            Name      => 'text1',
            FieldType => 'TestingNonExisingModule'
        },
        Success => 0,
    },
    {
        Name        => 'Success',
        FieldConfig => {
            Name      => 'text1',
            FieldType => 'Text'
        },
        Success => 1,
    },

);

$Self->{ConfigObject}->Set(
    Key   => 'DynamicFields::Backend###TestingInvalidModule',
    Value => {
        Module => ''
        }
);

$Self->{ConfigObject}->Set(
    Key   => 'DynamicFields::Backend###TestingNonExisingModule',
    Value => {
        Module => 'Kernel::System::DynamicField::Backend::TestingNonExisingModule'
        }
);

$DynamicFieldObject = Kernel::System::DynamicField->new( %{$Self} );

for my $Test (@Tests) {

    # get the new instance
    my $Instance = $DynamicFieldObject->DynamicFieldBackendInstanceGet(
        FieldConfig => $Test->{FieldConfig},
    );

    # check if the instance could be created
    if ( !$Test->{Success} ) {
        $Self->False(
            $Instance,
            "DynamicFieldBackendInstanceGet() $Test->{Name} with False",
        );
    }
    else {
        $Self->True(
            $Instance,
            "DynamicFieldBackendInstanceGet() $Test->{Name} with True",
        );
    }
}

1;
