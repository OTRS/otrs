# --
# ACL.t - ACL DB tests
# Copyright (C) 2003-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use utf8;

use Kernel::Config;
use Kernel::System::ACL::DB::ACL;
use Kernel::System::UnitTest::Helper;
use Kernel::System::VariableCheck qw(:all);

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);

my $ConfigObject = Kernel::Config->new();

my $ACLObject = Kernel::System::ACL::DB::ACL->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# define needed variables
my $RandomID = $HelperObject->GetRandomID();
my $UserID   = 1;

# get original ACL list
my $OriginalACLList = $ACLObject->ACLList( UserID => $UserID ) || {};

#
# Tests for ACLAdd
#
my @Tests = (
    {
        Name    => 'ACLAdd Test 1: No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'ACLAdd Test 3: No Name',
        Config => {
            Name           => undef,
            UserID         => $UserID,
            Comment        => 'Comment',
            StopAfterMatch => 1,
            ValidID        => 1,
        },
        Success => 0,

    },
    {
        Name   => 'ACLAdd Test 4: No Comment',
        Config => {
            Name           => undef,
            UserID         => $UserID,
            StopAfterMatch => 1,
            ValidID        => 1,
        },
        Success => 0,

    },
    {
        Name   => 'ACLAdd Test 5: No UserID',
        Config => {
            Name           => "ACL-$RandomID",
            UserID         => undef,
            Comment        => 'Comment',
            StopAfterMatch => 1,
            ValidID        => 1,
        },
        Success => 0,
    },
    {
        Name   => 'ACLAdd Test 6: Wrong Config format',
        Config => {
            Name        => "ACL-$RandomID",
            ConfigMatch => 'Config',
            UserID      => $UserID,
            Comment     => 'Comment',
            ValidID     => 1,
        },
        Success => 0,
    },
    {
        Name   => 'ACLAdd Test 7: Wrong Config format 2',
        Config => {
            Name         => "ACL-$RandomID",
            ConfigChange => 'Config',
            UserID       => $UserID,
            Comment      => 'Comment',
            ValidID      => 1,
        },
        Success => 0,
    },
    {
        Name   => 'ACLAdd Test 8: Valid data',
        Config => {
            Name           => "ACL-$RandomID",
            UserID         => $UserID,
            Comment        => 'Comment',
            StopAfterMatch => 1,
            ValidID        => 1,
        },
        Success => 1,
    },
    {
        Name   => 'ACLAdd Test 9: Duplicated Name',
        Config => {
            Name           => "ACL-$RandomID",
            UserID         => $UserID,
            Comment        => 'Comment',
            StopAfterMatch => 0,
            ValidID        => 1,
        },
        Success => 0,
    },
    {
        Name   => 'ACLAdd Test 10: No ValidID',
        Config => {
            Name           => "ACL-$RandomID",
            UserID         => $UserID,
            Comment        => 'Comment',
            StopAfterMatch => 1,
        },
        Success => 0,
    },
    {
        Name   => 'ACLAdd Test 11: Valid data 2',
        Config => {
            Name           => "ACL2-$RandomID",
            UserID         => $UserID,
            Comment        => 'Comment',
            ValidID        => 1,
            StopAfterMatch => 1,
        },
        Success => 1,
    },
);

my %AddedACL;
for my $Test (@Tests) {
    my $ACLID = $ACLObject->ACLAdd( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $ACLID,
            0,
            "$Test->{Name} | ACLID should not be 0",
        );
        $AddedACL{$ACLID} = $Test->{Config};

        $Self->True(
            $ACLObject->ACLsNeedSync(),
            "$Test->{Name} sync flag set after AclAdd",
        );

        $Self->True(
            $ACLObject->ACLsNeedSyncReset(),
            "$Test->{Name} sync flag reset",
        );

        $Self->False(
            $ACLObject->ACLsNeedSync(),
            "$Test->{Name} sync flag not set after reset",
        );
    }
    else {
        $Self->Is(
            $ACLID,
            undef,
            "$Test->{Name} | ACLID should be undef",
        );
    }
}

#
# ACLGet()
#
my @AddedACLList = map {$_} sort keys %AddedACL;
@Tests = (
    {
        Name    => 'ACLGet Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'ACLGet Test 2: No ID and EntityID',
        Config => {
            ID     => undef,
            Name   => undef,
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ACLGet Test 3: No UserID',
        Config => {
            ID     => 1,
            Name   => undef,
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ACLGet Test 4: Wrong ID',
        Config => {
            ID     => 'NotExistent' . $RandomID,
            Name   => undef,
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ACLGet Test 5: Wrong EntityID',
        Config => {
            ID     => undef,
            Name   => 'NotExistent' . $RandomID,
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ACLGet Test 6: Correct data',
        Config => {
            Name   => "ACL-$RandomID",
            UserID => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $ACL = $ACLObject->ACLGet( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            ref $ACL,
            'HASH',
            "$Test->{Name} | ACL structure is HASH",
        );
        $Self->True(
            IsHashRefWithData($ACL),
            "$Test->{Name} | ACL structure is non empty HASH",
        );

        # check cache
        my $CacheKey;
        if ( $Test->{Config}->{ID} ) {
            $CacheKey = 'ACLGet::ID::' . $Test->{Config}->{ID};
        }
        else {
            $CacheKey = 'ACLGet::Name::' . $Test->{Config}->{Name};
        }

        my $Cache = $ACLObject->{CacheObject}->Get(
            Type => 'ACLEditor_ACL',
            Key  => $CacheKey,
        );

        $Self->IsDeeply(
            $Cache,
            $ACL,
            "$Test->{Name} | ACL cache"
        );

        # remove not need parameters
        my %ExpectedACL = %{ $AddedACL{ $ACL->{ID} } || {} };
        delete $ExpectedACL{UserID};

        for my $Attribute (
            qw(ID CreateTime ChangeTime Comment)
            )
        {
            $Self->IsNot(
                $ACL->{$Attribute},
                undef,
                "$Test->{Name} | ACL->{$Attribute} should not be undef",
            );
        }

        # delete attributes in order to compare
        for my $Attribute (
            qw(ID CreateBy ChangeBy CreateTime ChangeTime ConfigMatch ConfigChange Description)
            )
        {
            delete $ACL->{$Attribute};
        }

        $Self->IsDeeply(
            $ACL,
            \%ExpectedACL,
            "$Test->{Name} | ACL"
        );
    }
    else {
        $Self->False(
            ref $ACL eq 'HASH',
            "$Test->{Name} | ACL structure is not HASH",
        );
        $Self->Is(
            $ACL,
            undef,
            "$Test->{Name} | ACL should be undefined",
        );
    }
}

#
# ACLUpdate() tests
#
@Tests = (
    {
        Name    => 'ACLUpdate Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'ACLUpdate Test 2: No ID',
        Config => {
            ID           => undef,
            Name         => "ACL-$RandomID",
            Comment      => 'Comment',
            ValidID      => 1,
            ConfigMatch  => { 'Properties' => {} },
            ConfigChange => { 'Possible' => {} },
            UserID       => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ACLUpdate Test 4: No Name',
        Config => {
            ID           => 1,
            Name         => undef,
            Comment      => 'Comment',
            ValidID      => 1,
            ConfigMatch  => { 'Properties' => {} },
            ConfigChange => { 'Possible' => {} },
            UserID       => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ACLUpdate Test 5: No Comment',
        Config => {
            ID           => 1,
            Name         => "ACL-$RandomID",
            Comment      => undef,
            ValidID      => 1,
            ConfigMatch  => { 'Properties' => {} },
            ConfigChange => { 'Possible' => {} },
            UserID       => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ACLUpdate Test 6: No UserID',
        Config => {
            ID           => 1,
            Name         => "ACL-$RandomID",
            Comment      => 'Comment',
            ValidID      => 1,
            ConfigMatch  => { 'Possible' => {} },
            ConfigChange => undef,
            UserID       => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ACLUpdate Test 7: Correct data, no DBUpdate',
        Config => {
            ID             => $AddedACLList[0],
            Name           => "ACL-$RandomID",
            Comment        => 'Comment',
            ValidID        => 1,
            ConfigMatch    => '',
            ConfigChange   => '',
            UserID         => $UserID,
            StopAfterMatch => 1,
        },
        Success  => 1,
        UpdateDB => 0,
    },
    {
        Name   => 'ACLUpdate Test 8: Correct data, with DBUpdate',
        Config => {
            ID             => $AddedACLList[0],
            Name           => "ACL-$RandomID -U",
            Comment        => 'Comment234',
            Description    => '',
            ValidID        => 2,
            ConfigMatch    => { 'Properties' => {} },
            ConfigChange   => { 'Possible' => {} },
            UserID         => $UserID,
            CreateBy       => 'root@localhost',
            ChangeBy       => 'root@localhost',
            StopAfterMatch => 1,
        },
        Success  => 1,
        UpdateDB => 1,
    },
);

# try to update the ACL
print "Force a gap between create and update ACL, Sleeping 2s\n";
sleep 2;

TEST:
for my $Test (@Tests) {

    # get the old ACL (if any)
    my $OldACL = $ACLObject->ACLGet(
        ID => $Test->{Config}->{ID} || 0,
        UserID => $Test->{Config}->{UserID},
    );

    if ( $Test->{Success} ) {

        my $Success = $ACLObject->ACLUpdate( %{ $Test->{Config} } );

        $Self->IsNot(
            $Success,
            0,
            "$Test->{Name} | Result should be 1"
        );

        # check cache
        my $CacheKey
            = 'ACLGet::ID::'
            . $Test->{Config}->{ID};

        my $Cache = $ACLObject->{CacheObject}->Get(
            Type => 'ACLEditor_ACL',
            Key  => $CacheKey,
        );

        if ( $Test->{UpdateDB} ) {
            $Self->Is(
                $Cache,
                undef,
                "$Test->{Name} | Cache should be deleted after update, should be undef",
            );
        }
        else {
            $Self->IsNot(
                $Cache,
                undef,
                "$Test->{Name} | Cache should not be deleted after update, since no update needed",
            );
        }

        # get the new ACL
        my $NewACL = $ACLObject->ACLGet(
            ID     => $Test->{Config}->{ID},
            UserID => $Test->{Config}->{UserID},
        );

        # check cache
        $Cache = $ACLObject->{CacheObject}->Get(
            Type => 'ACLEditor_ACL',
            Key  => $CacheKey,
        );

        $Self->IsDeeply(
            $Cache,
            $NewACL,
            "$Test->{Name} | Cache is equal to updated ACL",
        );

        if ( $Test->{UpdateDB} ) {
            $Self->IsNotDeeply(
                $NewACL,
                $OldACL,
                "$Test->{Name} | Updated ACL is different than original",
            );

            # check create and change times
            $Self->Is(
                $NewACL->{CreateTime},
                $OldACL->{CreateTime},
                "$Test->{Name} | Updated ACL create time should not change",
            );
            $Self->IsNot(
                $NewACL->{ChangeTime},
                $OldACL->{ChangeTime},
                "$Test->{Name} | Updated ACL change time should be different",
            );

            # remove not need parameters
            my %ExpectedACL = %{ $Test->{Config} };
            delete $ExpectedACL{UserID};

            for my $Attribute (
                qw( CreateTime ChangeTime )
                )
            {
                delete $NewACL->{$Attribute};
            }

            $Self->IsDeeply(
                $NewACL,
                \%ExpectedACL,
                "$Test->{Name} | ACL"
            );

            $Self->True(
                $ACLObject->ACLsNeedSync(),
                "$Test->{Name} sync flag set after ACLUpdate",
            );

            $Self->True(
                $ACLObject->ACLsNeedSyncReset(),
                "$Test->{Name} sync flag reset",
            );

            $Self->False(
                $ACLObject->ACLsNeedSync(),
                "$Test->{Name} sync flag not set after reset",
            );
        }
        else {
            $Self->IsDeeply(
                $NewACL,
                $OldACL,
                "$Test->{Name} | Updated ACL is equal than original",
            );
        }
    }
    else {
        my $Success = $ACLObject->ACLUpdate( %{ $Test->{Config} } );

        $Self->False(
            $Success,
            "$Test->{Name} | Result should fail",
        );
    }
}

#
# ACLList() tests
#

# no params
my $TestACLList = $ACLObject->ACLList();

$Self->Is(
    $TestACLList,
    undef,
    "ACLList Test 1: No Params | Should be undef",
);

# normal ACL list
$TestACLList = $ACLObject->ACLList( UserID => $UserID );

$Self->Is(
    ref $TestACLList,
    'HASH',
    "ACLList Test 2: All ACL | Should be a HASH",
);

$Self->True(
    IsHashRefWithData($TestACLList),
    "ACLList Test 2: All ACL | Should be not empty HASH",
);

$Self->IsNotDeeply(
    $TestACLList,
    $OriginalACLList,
    "ACLList Test 2: All ACL | Should be different than the original",
);

# delete original ACL
for my $ACLID ( sort keys %{$OriginalACLList} ) {
    delete $TestACLList->{$ACLID};
}

$Self->Is(
    scalar keys %{$TestACLList},
    scalar @AddedACLList,
    "ACLList Test 2: All ACL | Number of ACLs match added ACLs",
);

my $Counter = 0;
for my $ACLID ( sort { $a <=> $b } keys %{$TestACLList} ) {
    $Self->Is(
        $ACLID,
        $AddedACLList[$Counter],
        "ACLList Test 2: All ACL | ACLID match AddedACLID",
        ),
        $Counter++;
}

# prepare ACL for listing
my $ACL = $ACLObject->ACLGet(
    ID     => $AddedACLList[0],
    UserID => $UserID,
);
my $Success = $ACLObject->ACLUpdate(
    ID => $AddedACLList[0],
    %{$ACL},
    ValidID => 2,
    UserID  => 1,
);

$Self->IsNot(
    $Success,
    0,
    "ACLList | Updated ACL for ACLID:'$AddedACLList[0]' result should be 1",
);

for my $Index ( 1, 2 ) {

    my $ACL = $ACLObject->ACLGet(
        ID     => $AddedACLList[$Index],
        UserID => $UserID,
    );
    my $Success = $ACLObject->ACLUpdate(
        ID => $AddedACLList[$Index],
        %{$ACL},
        ValidID => 2,
        UserID  => 1,
    );

    $Self->IsNot(
        $Success,
        0,
        "ACLList | Updated ACL for ACLID:'$AddedACLList[$Index]' result should be 1",
    );
}

#
# ACLDelete() (test for fail, test for success are done by removing ACLs at the end)
#
@Tests = (
    {
        Name    => 'ACLDelete Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'ACLDelete Test 2: No ACL ID',
        Config => {
            ID     => undef,
            UserID => $RandomID,
        },
        Success => 0,
    },
    {
        Name   => 'ACLDelete Test 3: No UserID',
        Config => {
            ID     => $RandomID,
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ACLDelete Test 4: Wrong ACL ID',
        Config => {
            ID     => $RandomID,
            UserID => $UserID,
        },
        Success => 0,
    },
);

for my $Test (@Tests) {
    my $Success = $ACLObject->ACLDelete( %{ $Test->{Config} } );

    $Self->False(
        $Success,
        "$Test->{Name} | ACL delete with false",
    );
}

#
# ACLListGet() tests
#

my $FullList = $ACLObject->ACLListGet(
    UserID => undef,
);

$Self->IsNot(
    ref $FullList,
    'ARRAY',
    "ACLListGet Test 1: No UserID | List Should not be an array",
);

# get the List of ACLs with all details
$FullList = $ACLObject->ACLListGet(
    UserID => $UserID,
);

# get simple list of ACLs
my $List = $ACLObject->ACLList(
    UserID => $UserID,
);

# create the list of ACLs with details manually
my $ExpectedACLList;
for my $ACLID ( sort { $a <=> $b } keys %{$List} ) {

    my $ACLData = $ACLObject->ACLGet(
        ID     => $ACLID,
        UserID => $UserID,
    );
    push @{$ExpectedACLList}, $ACLData;
}

$Self->Is(
    ref $FullList,
    'ARRAY',
    "ACLListGet Test 2: Correct List | Should be an array",
);

$Self->True(
    IsArrayRefWithData($FullList),
    "ACLListGet Test 2: Correct List | The list is not empty",
);

$Self->IsDeeply(
    $FullList,
    $ExpectedACLList,
    "ACLListGet Test 2: Correct List | ACL List",
);

# check cache
my $CacheKey = 'ACLListGet::ValidIDs::ALL';

my $Cache = $ACLObject->{CacheObject}->Get(
    Type => 'ACLEditor_ACL',
    Key  => $CacheKey,
);

$Self->IsDeeply(
    $Cache,
    $FullList,
    "ACLListGet Test 2: Correct List | Cache",
);

print "------------System Cleanup------------\n";

# remove added ACLs
for my $ACLID ( sort keys %AddedACL ) {
    my $Success = $ACLObject->ACLDelete(
        ID     => $ACLID,
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "ACLDelete() ACLID:$ACLID | Deleted sucessfully",
    );

    $Self->True(
        $ACLObject->ACLsNeedSync(),
        "ACLDelete() ACLID:$ACLID sync flag set after ACLDelete",
    );

    $Self->True(
        $ACLObject->ACLsNeedSyncReset(),
        "ACLDelete() ACLID:$ACLID sync flag reset",
    );

    $Self->False(
        $ACLObject->ACLsNeedSync(),
        "ACLDelete() ACLID:$ACLID sync flag not set after reset",
    );
}

1;
