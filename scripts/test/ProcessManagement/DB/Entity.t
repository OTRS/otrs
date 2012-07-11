# --
# Entity.t - ProcessManagement DB entity tests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Entity.t,v 1.1 2012-07-11 14:23:55 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

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

        my $EntityPrefix
            = $Self->{ConfigObject}->Get('Process::Entity::Prefix')
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

        my $EntityPrefix
            = $Self->{ConfigObject}->Get('Process::Entity::Prefix')
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
            EntityID   => 'P1',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'EntityIDUpdate Test 3: No UserID',
        Config => {
            EntityType => 'Process',
            EntityID   => 'P1',
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
            EntityID   => 'P100',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 12: EntityType: Activity, W/EntityID: A200',
        Config => {
            EntityType => 'Activity',
            EntityID   => 'A200',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 13: EntityType: ActivityDialog, W/EntityID: AD300',
        Config => {
            EntityType => 'ActivityDialog',
            EntityID   => 'AD300',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 14: EntityType: Transition, W/EntityID: T400',
        Config => {
            EntityType => 'Transition',
            EntityID   => 'T400',
            UserID     => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'EntityIDUpdate Test 10: EntityType: TransitionAction, WO/EntityID: TA500',
        Config => {
            EntityType => 'TransitionAction',
            EntityID   => 'TA500',
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

            my $EntityPrefix
                = $Self->{ConfigObject}->Get('Process::Entity::Prefix')
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

1;
