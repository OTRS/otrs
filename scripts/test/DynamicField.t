# --
# DynamicField.t - DynamicField tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DynamicField.t,v 1.6 2011-08-22 18:10:06 cg Exp $
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
            FieldType  => 'text',
            ObjectType => 'article',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'test2',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Config => {
                Name        => 'OtherName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'alabel',
            FieldType  => 'text',
            ObjectType => 'ticket',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'test3',
        SuccessAdd    => 1,
        SuccessUpdate => 1,
        Add           => {
            Config     => {},
            Label      => 'nothing interesting',
            FieldType  => 'text',
            ObjectType => 'article',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'test4',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config     => undef,
            Label      => 'label',
            FieldType  => 'text',
            ObjectType => 'article',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'test5',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'OtherName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => '',
            FieldType  => 'text',
            ObjectType => 'ticket',
            ValidID    => 2,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'test6',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'OtherName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'Other label',
            FieldType  => '',
            ObjectType => 'article',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'test7',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'OtherName',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'Complex label',
            FieldType  => 'int',
            ObjectType => '',
            ValidID    => 1,
            UserID     => $UserID,
        },
    },
    {
        Name          => 'test8',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'NameTwo',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'Simple Label',
            FieldType  => 'text',
            ObjectType => 'ticket',
            ValidID    => '',
            UserID     => $UserID,
        },
    },
    {
        Name          => 'test9',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'Config Name',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'Other label',
            FieldType  => 'text',
            ObjectType => 'ticket',
            ValidID    => 1,
            UserID     => '',
        },
    },
    {
        Name          => 'Test 10',
        SuccessAdd    => 0,
        SuccessUpdate => 0,
        Add           => {
            Config => {
                Name        => 'Config Name',
                Description => 'Description for Dynamic Field.',
            },
            Label      => 'Other label',
            FieldType  => 'text',
            ObjectType => 'ticket',
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

1;
