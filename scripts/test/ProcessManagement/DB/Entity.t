# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $EntityObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Entity');

# define needed variables
my $RandomID = $HelperObject->GetRandomID();
my $UserID   = 1;

#
# Tests for EntityIDGenerate
#
my @Tests = (
    {
        Name    => 'EntityIDGenerate Test 1: No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'EntityIDGenerate Test 2: No EntityType',
        Config => {
            EntityType => undef,
            UserID     => 1,
        },
        Success => 0,
    },
    {
        Name   => 'EntityIDGenerate Test 3: No UserID',
        Config => {
            EntityType => 'Process',
            UserID     => undef,
        },
        Success => 0,
    },
    {
        Name   => 'EntityIDGenerate Test 4: Wrong EntityType',
        Config => {
            EntityType => 'NotExistent',
            UserID     => undef,
        },
        Success => 0,
    },
    {
        Name   => 'EntityIDGenerate Test 5: EntityType Process',
        Config => {
            EntityType => 'Process',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDGenerate Test 6: EntityType Activity',
        Config => {
            EntityType => 'Activity',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDGenerate Test 7: EntityType ActivityDialog',
        Config => {
            EntityType => 'ActivityDialog',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDGenerate Test 8: EntityType Transition',
        Config => {
            EntityType => 'Transition',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDGenerate Test 6: EntityType TransitionAction',
        Config => {
            EntityType => 'TransitionAction',
            UserID     => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $EntityID = $EntityObject->EntityIDGenerate( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $EntityID,
            undef,
            "$Test->{Name} | EntityID should not be undef",
        );

        my $EntityPrefix = $ConfigObject->Get('Process::Entity::Prefix')->{ $Test->{Config}->{EntityType} };

        my $Match;
        if ( $EntityID =~ m{\A $Test->{Config}->{EntityType} - [0-9a-f]{32}? \z}smx ) {
            $Match = 1;
        }
        $Self->True(
            $Match,
            "$Test->{Name} | EntityID: $EntityID match expected format",
        );
    }
    else {
        $Self->Is(
            $EntityID,
            undef,
            "$Test->{Name} | EntityID should be undef",
        );
    }
}

# backup current sync states
my $OrigEntitySyncStateList = $EntityObject->EntitySyncStateList( UserID => $UserID );
{

    # purge sync states to work on a clean system
    my $Success = $EntityObject->EntitySyncStatePurge( UserID => $UserID );

    $Self->True(
        $Success,
        "EntintySyncStatePurge executed successfully",
    );

    # check that the list is real emty
    my $EntitySyncStateList = $EntityObject->EntitySyncStateList( UserID => $UserID );

    $Self->Is(
        scalar @{$EntitySyncStateList},
        0,
        "EntitySyncStateList after purge should be empty",
    );
}

#
# EntitySyncStateSet() tests
#

@Tests = (
    {
        Name    => 'EntitySyncStateSet Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateSet Test 2: No EntityType',
        Config => {
            EntityType => undef,
            EntityID   => 'P-test-1',
            SyncState  => 'not_sync',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateSet Test 3: No EntityID',
        Config => {
            EntityType => 'Process',
            EntityID   => undef,
            SyncState  => 'not_sync',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateSet Test 4: No SyncState',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P-test-1',
            SyncState  => undef,
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateSet Test 5: No UserID',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P-test-1',
            SyncState  => 'not_sync',
            UserID     => undef,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateSet Test 6: wrong EntityType',
        Config => {
            EntityType => 'NotExitstentProcess',
            EntityID   => 'P-test-1',
            SyncState  => 'not_sync',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateSet Test 4: Correct ASCII',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P-test-1',
            SyncState  => 'not_sync',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntitySyncStateSet Test 5: Correct UTF8',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P-test-1-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            SyncState  => 'not_sync-äßÄ€исáÁñÑ',
            UserID     => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $EntityObject->EntitySyncStateSet( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} | executed successful",
        );

        my $EntitySyncStateData = $EntityObject->EntitySyncStateGet( %{ $Test->{Config} } );

        # delete dates
        delete $EntitySyncStateData->{CreateTime};
        delete $EntitySyncStateData->{ChangeTime};

        # set expected data
        my %ExpectedData = %{ $Test->{Config} };
        delete $ExpectedData{UserID};

        $Self->IsDeeply(
            $EntitySyncStateData,
            \%ExpectedData,
            "$Test->{Name} | Set data"
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} | should fail",
        );
    }

}

#
# EntitySyncStateGet() tests
# (only wrong tests, since correct tests are already done by EntitySyncStateSet)
#

@Tests = (
    {
        Name    => 'EntitySyncStateGet Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateGet Test 2: No EntityType',
        Config => {
            EntityType => undef,
            EntityID   => 'P-test-1',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateGet Test 3: No EntityID',
        Config => {
            EntityType => 'Process',
            EntityID   => undef,
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateGet Test 4: No UserID',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P-test-1',
            UserID     => undef,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateGet Test 5: wrong EntityType',
        Config => {
            EntityType => 'NotExitstentProcess',
            EntityID   => 'P-test-1',
            UserID     => $UserID,
        },
        Success => 0,
    },
);

for my $Test (@Tests) {
    my $EntitySyncStateGetData = $EntityObject->EntitySyncStateGet( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            0,
            "$Test->{Name} | ERROR: All tests in this block should fail",
        );
    }
    else {
        $Self->Is(
            $EntitySyncStateGetData,
            undef,
            "$Test->{Name} | should be an undef",
        );
    }
}

#
# EntitySyncStateList() tests
#

{

    # purge sync states to work on a clean system
    my $Success = $EntityObject->EntitySyncStatePurge( UserID => $UserID );

    $Self->True(
        $Success,
        "EntintySyncStatePurge executed successfully",
    );

    # check that the list is real emty
    my $EntitySyncStateList = $EntityObject->EntitySyncStateList( UserID => $UserID );

    $Self->Is(
        scalar @{$EntitySyncStateList},
        0,
        "EntitySyncStateList after purge should be empty",
    );
}
{

    # prepare system for list tests
    my @Tests = (
        {
            Name   => 'EntitySyncStateSet for EntitySyncStateList Test 1: Process1 with not_sync',
            Config => {
                EntityType => 'Process',
                EntityID   => 'P-test-1',
                SyncState  => 'not_sync',
                UserID     => $UserID,
            },
        },
        {
            Name   => 'EntitySyncStateSet for EntitySyncStateList Test 2: Process2 with not_sync',
            Config => {
                EntityType => 'Process',
                EntityID   => 'P-test-2',
                SyncState  => 'new',
                UserID     => $UserID,
            },
        },
        {
            Name   => 'EntitySyncStateSet for EntitySyncStateList Test 3: Process3 with deleted',
            Config => {
                EntityType => 'Process',
                EntityID   => 'P-test-3',
                SyncState  => 'deleted',
                UserID     => $UserID,
            },
        },
        {
            Name   => 'EntitySyncStateSet for EntitySyncStateList Test 4: Activity1 with not_sync',
            Config => {
                EntityType => 'Activity',
                EntityID   => 'A-test-1',
                SyncState  => 'new',
                UserID     => $UserID,
            },
        },
    );

    for my $Test (@Tests) {
        my $Success = $EntityObject->EntitySyncStateSet( %{ $Test->{Config} } );

        if ( $Test->{Success} ) {
            $Self->True(
                $Success,
                "$Test->{Name} | executed successfully",
            );
        }
    }
}

@Tests = (
    {
        Name    => 'EntitySyncStateList Test 1: No params',
        Config  => undef,
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateList Test 2: No UserID',
        Config => {
            EntityType => 'Process',
            SyncState  => 'NotSync',
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateList Test 3: Full list',
        Config => {
            EntityType => undef,
            SyncState  => undef,
            UserID     => $UserID,
        },
        Count   => 4,
        Success => 1,
    },
    {
        Name   => 'EntitySyncStateList Test 4: Only Processes',
        Config => {
            EntityType => 'Process',
            SyncState  => undef,
            UserID     => $UserID,
        },
        Count   => 3,
        Success => 1,
    },
    {
        Name   => 'EntitySyncStateList Test 5: Only Activities',
        Config => {
            EntityType => 'Activity',
            SyncState  => undef,
            UserID     => $UserID,
        },
        Count   => 1,
        Success => 1,
    },
    {
        Name   => 'EntitySyncStateList Test 5: All not_sync',
        Config => {
            EntityType => undef,
            SyncState  => 'not_sync',
            UserID     => $UserID,
        },
        Count   => 1,
        Success => 1,
    },
    {
        Name   => 'EntitySyncStateList Test 6: All new',
        Config => {
            EntityType => undef,
            SyncState  => 'new',
            UserID     => $UserID,
        },
        Count   => 2,
        Success => 1,
    },
    {
        Name   => 'EntitySyncStateList Test 7: All deleted',
        Config => {
            EntityType => undef,
            SyncState  => 'deleted',
            UserID     => $UserID,
        },
        Count   => 1,
        Success => 1,
    },
    {
        Name   => 'EntitySyncStateList Test 8: Only new prosesses',
        Config => {
            EntityType => 'Process',
            SyncState  => 'new',
            UserID     => $UserID,
        },
        Count   => 1,
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $EntitySyncStateList = $EntityObject->EntitySyncStateList( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            ref $EntitySyncStateList,
            'ARRAY',
            "$Test->{Name} | List should be an ARRAY",
        );
        $Self->Is(
            scalar @{$EntitySyncStateList},
            $Test->{Count},
            "$Test->{Name} | List number match expected value",
        );
    }
    else {
        $Self->Is(
            $EntitySyncStateList,
            undef,
            "$Test->{Name} | List should be undef",
        );
    }

}

@Tests = (
    {
        Name    => 'EntitySyncStateDelete Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateDelete Test 2: No EntityType',
        Config => {
            EntityType => undef,
            EntityID   => 'P-test-1',
            SyncState  => 'not_sync',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateDelete Test 3: No EntityID',
        Config => {
            EntityType => 'Process',
            EntityID   => undef,
            SyncState  => 'not_sync',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateDelete Test 4: No UserID',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P-test-1',
            SyncState  => 'not_sync',
            UserID     => undef,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateDelete Test 5: wrong EntityType',
        Config => {
            EntityType => 'NotExitstentProcess',
            EntityID   => 'P-test-1',
            SyncState  => 'not_sync',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateDelete Test 6: Correct ASCII',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P-test-1',
            SyncState  => 'not_sync',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntitySyncStateDelete Test 7: Correct ASCII2',
        Config => {
            EntityType => 'Activity',
            EntityID   => 'A-test-1',
            SyncState  => 'new',
            UserID     => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    # get the Sync register before delete
    my $EntitySyncStateGetData = $EntityObject->EntitySyncStateGet( %{ $Test->{Config} } );

    my $Success = $EntityObject->EntitySyncStateDelete( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            ref $EntitySyncStateGetData,
            'HASH',
            "$Test->{Name} | EntitySyncStateGet before delete should be a hash",
        );
        $Self->Is(
            $Success,
            1,
            "$Test->{Name} | should be a executed correclty",
        );

        # get the Sync register after delete
        my $EntitySyncStateGetData = $EntityObject->EntitySyncStateGet( %{ $Test->{Config} } );

        $Self->IsNot(
            ref $EntitySyncStateGetData,
            'HASH',
            "$Test->{Name} | EntitySyncStateGet after delete should not be a hash",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} | should be undef",
        );
    }
}

#
# EntitySyncStatePurge() tests
# (only wrong tests, since correct tests has been done already)
#

@Tests = (
    {
        Name    => 'EntitySyncStateList Test 1: No params',
        Config  => undef,
        Success => 0,
    },
    {
        Name   => 'EntitySyncStateList Test 2: No UserID',
        Config => {
            EntityType => 'Process',
            SyncState  => 'NotSync',
        },
        Success => 0,
    },
);

for my $Test (@Tests) {
    my $Success = $EntityObject->EntitySyncStatePurge( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            0,
            "$Test->{Name} | ERROR: All tests in this block should fail",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} | should fail",
        );
    }
}

# clean up
print "---------------------- Restore original sync states ----------------------\n";
my $Success = $EntityObject->EntitySyncStatePurge( UserID => $UserID );

$Self->True(
    $Success,
    "EntintySyncStatePurge executed successfully"
);

my $EntitySyncStateList = $EntityObject->EntitySyncStateList( UserID => $UserID );

$Self->Is(
    scalar @{$EntitySyncStateList},
    0,
    "EntitySyncStateList after purge should be empty",
);

for my $EntitySyncData (@$OrigEntitySyncStateList) {
    my $Success = $EntityObject->EntitySyncStateSet(
        %{$EntitySyncData},
        UserID => $UserID,
    );

    $Self->True(
        $Success,
        "EntitySyncStateSet reset orgininal syc state for EntityID:$EntitySyncData->{EntityID}"
    );
}

my $FinalEntitySyncStateList = $EntityObject->EntitySyncStateList( UserID => $UserID );

# remove times before compare
for my $EntitySyncState ( @{$OrigEntitySyncStateList} ) {
    delete $EntitySyncState->{CreateTime};
    delete $EntitySyncState->{ChangeTime};
}
for my $EntitySyncState ( @{$FinalEntitySyncStateList} ) {
    delete $EntitySyncState->{CreateTime};
    delete $EntitySyncState->{ChangeTime};
}

$Self->IsDeeply(
    $OrigEntitySyncStateList,
    $FinalEntitySyncStateList,
    "Final Entity Sync State List compared with original",
);

1;
