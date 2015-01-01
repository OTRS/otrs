# --
# Entity.t - ProcessManagement DB entity tests
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

use Kernel::Config;
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::UnitTest::Helper;

use Kernel::System::VariableCheck qw(:all);

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);

my $ConfigObject = Kernel::Config->new();

my $EntityObject = Kernel::System::ProcessManagement::DB::Entity->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# define needed variables
my $RandomID = $HelperObject->GetRandomID();
my $UserID   = 1;

#
# EntityCounterGet
#

my @Tests = (
    {
        Name    => 'EntityCounterGet Test 1: No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'EntityCounterGet Test 2: No EntityType',
        Config => {
            EntityType => undef,
            UserID     => 1,
        },
        Success => 0,
    },
    {
        Name   => 'EntityCounterGet Test 3: No UserID',
        Config => {
            EntityType => 'Process',
            UserID     => undef,
        },
        Success => 0,
    },
    {
        Name   => 'EntityCounterGet Test 4: Wrong EntityType',
        Config => {
            EntityType => 'NotExistent',
            UserID     => undef,
        },
        Success => 0,
    },
    {
        Name   => 'EntityCounterGet Test 5: EntityType Process',
        Config => {
            EntityType => 'Process',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityCounterGet Test 6: EntityType Activity',
        Config => {
            EntityType => 'Activity',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityCounterGet Test 7: EntityType ActivityDialog',
        Config => {
            EntityType => 'ActivityDialog',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityCounterGet Test 8: EntityType Transition',
        Config => {
            EntityType => 'Transition',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityCounterGet Test 6: EntityType TransitionAction',
        Config => {
            EntityType => 'TransitionAction',
            UserID     => $UserID,
        },
        Success => 1,
    },
);

my %OriginalEntityIDs;
for my $Test (@Tests) {
    my $EntityCounter = $EntityObject->EntityCounterGet( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $EntityCounter,
            undef,
            "$Test->{Name} | EntityCounter should not be undef",
        );

        $Self->True(
            IsNumber($EntityCounter),
            "$Test->{Name} | EntityCounter is numeric",
        );

        # check cache
        my $CacheKey = "EntityCounterGet::EntityType::$Test->{Config}->{EntityType}";

        my $Cache = $EntityObject->{CacheObject}->Get(
            Type => 'ProcessManagement_Entity',
            Key  => $CacheKey,
        );

        $Self->IsNot(
            $$Cache,
            undef,
            "$Test->{Name} | Cache should not be undef",
        );
        $Self->Is(
            $$Cache,
            $EntityCounter,
            "$Test->{Name} | Cache match EntityCounter",
        );

        my $EntityPrefix = $Self->{ConfigObject}->Get('Process::Entity::Prefix')
            ->{ $Test->{Config}->{EntityType} };

        $OriginalEntityIDs{ $Test->{Config}->{EntityType} } = "$EntityPrefix$EntityCounter";
    }
    else {
        $Self->Is(
            $EntityCounter,
            undef,
            "$Test->{Name} | EntityCounter should be undef",
        );
    }
}

#
# Tests for EntityIDGenerate
#
@Tests = (
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

        my $EntityPrefix = $Self->{ConfigObject}->Get('Process::Entity::Prefix')
            ->{ $Test->{Config}->{EntityType} };

        my $Match;
        if ( $EntityID =~ m{\A $EntityPrefix \d+ \z}smx ) {
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

#
# EntityIDUpdate()
#

@Tests = (
    {
        Name    => 'EntityID Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'EntityIDUpdate Test 2: No EntityType',
        Config => {
            EntityType => undef,
            EntityID   => 'P-test1',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntityIDUpdate Test 3: No UserID',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P999999',
            UserID     => undef,
        },
        Success => 0,
    },
    {
        Name   => 'EntityIDUpdate Test 4: Wrong EntityID 1',
        Config => {
            EntityType => 'Process',
            EntityID   => 'NotExistent1',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntityIDUpdate Test 5: Wrong EntityID 2',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P2P',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntityIDUpdate Test 6: EntityType: Process, WO/EntityID',
        Config => {
            EntityType => 'Process',
            EntityID   => undef,
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 7: EntityType: Activity, WO/EntityID',
        Config => {
            EntityType => 'Activity',
            EntityID   => undef,
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 8: EntityType: ActivityDialog, WO/EntityID',
        Config => {
            EntityType => 'ActivityDialog',
            EntityID   => undef,
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 9: EntityType: Transition, WO/EntityID',
        Config => {
            EntityType => 'Transition',
            EntityID   => undef,
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 10: EntityType: TransitionAction, WO/EntityID',
        Config => {
            EntityType => 'TransitionAction',
            EntityID   => undef,
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 11: EntityType: Process, W/EntityID: P100',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P100000',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 12: EntityType: Activity, W/EntityID: A200',
        Config => {
            EntityType => 'Activity',
            EntityID   => 'A120000',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 13: EntityType: ActivityDialog, W/EntityID: AD300',
        Config => {
            EntityType => 'ActivityDialog',
            EntityID   => 'AD130000',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 14: EntityType: Transition, W/EntityID: T400',
        Config => {
            EntityType => 'Transition',
            EntityID   => 'T140000',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 10: EntityType: TransitionAction, WO/EntityID: TA500',
        Config => {
            EntityType => 'TransitionAction',
            EntityID   => 'TA150000',
            UserID     => $UserID,
        },
        Success => 1,
    },

);

for my $Test (@Tests) {

    if ( $Test->{Success} ) {
        my $CurrentEntityCounter = $EntityObject->EntityCounterGet( %{ $Test->{Config} } );

        # sanity check
        $Self->IsNot(
            $CurrentEntityCounter,
            undef,
            "$Test->{Name} | EntityCounter is not undef",
        );

        # check cache
        my $CacheKey = "EntityCounterGet::EntityType::$Test->{Config}->{EntityType}";

        my $CurrentCache = $EntityObject->{CacheObject}->Get(
            Type => 'ProcessManagement_Entity',
            Key  => $CacheKey,
        );

        $Self->IsNot(
            $$CurrentCache,
            undef,
            "$Test->{Name} | Cache should not be undef",
        );

        my $Success = $EntityObject->EntityIDUpdate( %{ $Test->{Config} } );

        $Self->True(
            $Success,
            "$Test->{Name} | EntityID updated for EntityType: $Test->{Config}->{EntityType}"
        );

        # check cache
        $CacheKey = "EntityCounterGet::EntityType::$Test->{Config}->{EntityType}";

        $CurrentCache = $EntityObject->{CacheObject}->Get(
            Type => 'ProcessManagement_Entity',
            Key  => $CacheKey,
        );

        $Self->Is(
            $$CurrentCache,
            undef,
            "$Test->{Name} | Cache should be undef",
        );

        my $NewEntityCounter = $EntityObject->EntityCounterGet( %{ $Test->{Config} } );

        if ( $Test->{Config}->{EntityID} ) {
            my $EntityID = $Test->{Config}->{EntityID};

            my $EntityPrefix = $Self->{ConfigObject}->Get('Process::Entity::Prefix')
                ->{ $Test->{Config}->{EntityType} };

            # remove prefix
            $EntityID =~ s{\A$EntityPrefix}{};
            $Self->Is(
                $NewEntityCounter,
                $EntityID,
                "$Test->{Name} | Entity counter should be equal to the EntityID set without the prefix",
            );

        }
        else {
            $Self->Is(
                $NewEntityCounter,
                $CurrentEntityCounter + 1,
                "$Test->{Name} | Entity counter should be incremented by 1",
            );
        }
    }
    else {
        my $Success => $EntityObject->EntityIDUpdate( %{ $Test->{Config} } );

        $Self->IsNot(
            $Success,
            1,
            "$Test->{Name} | EntityID should not be updated"
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
print "---------------------- Restore original counters ----------------------\n";
for my $EntityType ( sort keys %OriginalEntityIDs ) {

    my $Success = $EntityObject->EntityIDUpdate(
        EntityType => $EntityType,
        EntityID   => $OriginalEntityIDs{$EntityType},
        UserID     => $UserID,
    );

    $Self->True(
        $Success,
        "Entinty Counter restored for EntityType:$EntityType using EntityID:$OriginalEntityIDs{$EntityType} "
    );
}

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
