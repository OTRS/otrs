# --
# Transition.t - ProcessManagement DB transition tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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
use Kernel::System::ProcessManagement::DB::Transition;
use Kernel::System::UnitTest::Helper;
use Kernel::System::VariableCheck qw(:all);

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);

my $ConfigObject = Kernel::Config->new();

my $TransitionObject = Kernel::System::ProcessManagement::DB::Transition->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# set fixed time
$HelperObject->FixedTimeSet();

# define needed variables
my $RandomID = $HelperObject->GetRandomID();
my $UserID   = 1;

# get original Transition list
my $OriginalTransitionList = $TransitionObject->TransitionList( UserID => $UserID ) || {};

#
# Tests for TransitionAdd
#

my @Tests = (
    {
        Name    => 'TransitionAdd Test 1: No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'TransitionAdd Test 2: No EntityID',
        Config => {
            EntityID => undef,
            Name     => 'Transition-$RandomID',
            Config   => {
                Condition => {},
            },
            UserID => $UserID,
        },
        Success => 0,

    },
    {
        Name   => 'TransitionAdd Test 3: No Name',
        Config => {
            EntityID => $RandomID,
            Name     => undef,
            Config   => {
                Condition => {},
            },
            UserID => $UserID,
        },
        Success => 0,

    },
    {
        Name   => 'TransitionAdd Test 4: No Config',
        Config => {
            EntityID => $RandomID,
            Name     => "Transition-$RandomID",
            Config   => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionAdd Test 5: No Config Condition',
        Config => {
            EntityID => $RandomID,
            Name     => "Transition-$RandomID",
            Config   => {},
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionAdd Test 6: No UserID',
        Config => {
            EntityID => $RandomID,
            Name     => "Transition-$RandomID",
            Config   => {
                Condition => {
                    Type  => 'and',
                    Cond1 => {
                        Type   => 'and',
                        Fields => {
                            DynamicField_Test1 => {
                                Type  => 'String',
                                Match => 'Teststring',
                            },
                            DynamicField_Test2 => ['1'],
                        },
                    },
                    Cond2 => {
                        DynamicField_Test1 => ['2'],
                        DynamicField_Test2 => ['1'],
                    },
                },
            },
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionAdd Test 7: Wrong Config format',
        Config => {
            EntityID => $RandomID,
            Name     => "Transition-$RandomID",
            Config   => 'Config',
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionAdd Test 8: Wrong Config Condition format',
        Config => {
            EntityID => $RandomID,
            Name     => "Transition-$RandomID",
            Config   => {
                Condition => 'Condition',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionAdd Test 9: Correct ASCII',
        Config => {
            EntityID => $RandomID,
            Name     => "Transition-$RandomID",
            Config   => {
                Condition => {
                    Type  => 'and',
                    Cond1 => {
                        Type   => 'and',
                        Fields => {
                            DynamicField_Test1 => {
                                Type  => 'String',
                                Match => 'Teststring',
                            },
                            DynamicField_Test2 => ['1'],
                        },
                    },
                    Cond2 => {
                        DynamicField_Test1 => ['2'],
                        DynamicField_Test2 => ['1'],
                    },
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionAdd Test 10: Duplicated EntityID',
        Config => {
            EntityID => $RandomID,
            Name     => "Transition-$RandomID",
            Config   => {
                Condition => {
                    Type  => 'and',
                    Cond1 => {
                        Type   => 'and',
                        Fields => {
                            DynamicField_Test1 => {
                                Type  => 'String',
                                Match => 'Teststring',
                            },
                            DynamicField_Test2 => ['1'],
                        },
                    },
                    Cond2 => {
                        DynamicField_Test1 => ['2'],
                        DynamicField_Test2 => ['1'],
                    },
                },
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionAdd Test 11: Correct UTF8',
        Config => {
            EntityID => "$RandomID-1",
            Name     => "Transition-$RandomID--äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ",
            Config   => {
                Condition => {
                    Type  => 'and',
                    Cond1 => {
                        Type   => 'and',
                        Fields => {
                            DynamicField_Test1 => {
                                Type  => 'String',
                                Match => '-äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ',
                            },
                            DynamicField_Test2 => ['1'],
                        },
                    },
                    Cond2 => {
                        DynamicField_Test1 => ['2'],
                        DynamicField_Test2 => ['1'],
                    },
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionAdd Test 12: Correct UTF8 2',
        Config => {
            EntityID => "$RandomID-2",
            Name     => "Transition-$RandomID--!Â§$%&/()=?Ã*ÃÃL:L@,.-",
            Config   => {
                Condition => {
                    Type  => 'and',
                    Cond1 => {
                        Type   => 'and',
                        Fields => {
                            DynamicField_Test1 => {
                                Type  => 'String',
                                Match => '!Â§$%&/()=?Ã*ÃÃL:L@,.-',
                            },
                            DynamicField_Test2 => ['1'],
                        },
                    },
                    Cond2 => {
                        DynamicField_Test1 => ['2'],
                        DynamicField_Test2 => ['1'],
                    },
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
);

my %AddedTransitions;
for my $Test (@Tests) {
    my $TransitionID = $TransitionObject->TransitionAdd( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $TransitionID,
            undef,
            "$Test->{Name} | TransitionID should not be undef",
        );
        $AddedTransitions{$TransitionID} = $Test->{Config};
    }
    else {
        $Self->Is(
            $TransitionID,
            undef,
            "$Test->{Name} | TransitionID should be undef",
        );
    }
}

#
# TransitionGet()
#

my @AddedTransitionsList = map {$_} sort keys %AddedTransitions;
@Tests = (
    {
        Name    => 'TransitionGet Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'TransitionGet Test 2: No ID and EntityID',
        Config => {
            ID       => undef,
            EntityID => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionGet Test 3: No UserID',
        Config => {
            ID       => 1,
            EntityID => undef,
            UserID   => undef,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionGet Test 4: Wrong ID',
        Config => {
            ID       => 'NotExistent' . $RandomID,
            EntityID => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionGet Test 5: Wrong EntityID',
        Config => {
            ID       => undef,
            EntityID => 'NotExistent' . $RandomID,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionGet Test 6: Correct ASCII, W/ID',
        Config => {
            ID       => $AddedTransitionsList[0],
            EntityID => undef,
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionGet Test 7: Correct UTF8, W/ID',
        Config => {
            ID       => $AddedTransitionsList[1],
            EntityID => undef,
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionGet Test 8: Correct UTF82, W/ID',
        Config => {
            ID       => $AddedTransitionsList[2],
            EntityID => undef,
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionGet Test 9: Correct ASCII, W/EntityID,',
        Config => {
            ID       => undef,
            EntityID => $AddedTransitions{ $AddedTransitionsList[0] }->{EntityID},
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionGet Test 10: Correct UTF8, W/EntityID,',
        Config => {
            ID       => undef,
            EntityID => $AddedTransitions{ $AddedTransitionsList[1] }->{EntityID},
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionGet Test 11: Correct UTF82, W/EntityID,',
        Config => {
            ID       => undef,
            EntityID => $AddedTransitions{ $AddedTransitionsList[2] }->{EntityID},
            UserID   => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Transition = $TransitionObject->TransitionGet( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            ref $Transition,
            'HASH',
            "$Test->{Name} | Transition structure is HASH",
        );
        $Self->True(
            IsHashRefWithData($Transition),
            "$Test->{Name} | Transition structure is non empty HASH",
        );

        # check cache
        my $CacheKey;
        if ( $Test->{Config}->{ID} ) {
            $CacheKey = 'TransitionGet::ID::' . $Test->{Config}->{ID};
        }
        else {
            $CacheKey = 'TransitionGet::EntityID::' . $Test->{Config}->{EntityID};
        }

        my $Cache = $TransitionObject->{CacheObject}->Get(
            Type => 'ProcessManagement_Transition',
            Key  => $CacheKey,
        );

        $Self->IsDeeply(
            $Cache,
            $Transition,
            "$Test->{Name} | Transition cache"
        );

        # remove not need parameters
        my %ExpectedTransition = %{ $AddedTransitions{ $Transition->{ID} } };
        delete $ExpectedTransition{UserID};

        for my $Attribute (qw(ID CreateTime ChangeTime)) {
            $Self->IsNot(
                $Transition->{$Attribute},
                undef,
                "$Test->{Name} | Transition->{$Attribute} should not be undef",
            );
            delete $Transition->{$Attribute};
        }

        $Self->IsDeeply(
            $Transition,
            \%ExpectedTransition,
            "$Test->{Name} | Transition"
        );
    }
    else {
        $Self->False(
            ref $Transition eq 'HASH',
            "$Test->{Name} | Transition structure is not HASH",
        );
        $Self->Is(
            $Transition,
            undef,
            "$Test->{Name} | Transition should be undefined",
        );
    }
}

#
# TransitionUpdate() tests
#
@Tests = (
    {
        Name    => 'TransitionUpdate Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'TransitionUpdate Test 2: No ID',
        Config => {
            ID       => undef,
            EntityID => $RandomID . '-U',
            Name     => "Transition-$RandomID",
            Config   => {
                Description => 'a Description',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionUpdate Test 3: No EntityID',
        Config => {
            ID       => 1,
            EntityID => undef,
            Name     => "Transition-$RandomID",
            Config   => {
                Description => 'a Description',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionUpdate Test 4: No Name',
        Config => {
            ID       => 1,
            EntityID => $RandomID . '-U',
            Name     => undef,
            Config   => {
                Description => 'a Description',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionUpdate Test 5: No Config',
        Config => {
            ID       => 1,
            EntityID => $RandomID . '-U',
            Name     => "Transition-$RandomID",
            Config   => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionUpdate Test 6: No UserID',
        Config => {
            ID       => 1,
            EntityID => $RandomID . '-U',
            Name     => "Transition-$RandomID",
            Config   => {
                Description => 'a Description',
            },
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionUpdate Test 7: Correct ASCII',
        Config => {
            ID       => $AddedTransitionsList[0],
            EntityID => $RandomID . '-U',
            Name     => "Transition-$RandomID -U",
            Config   => {
                Condition => {
                    Type  => 'and',
                    Cond1 => {
                        Type   => 'and',
                        Fields => {
                            DynamicField_Test1 => {
                                Type  => 'String',
                                Match => 'Teststring-U',
                            },
                            DynamicField_Test2 => ['1'],
                        },
                    },
                    Cond2 => {
                        DynamicField_Test1 => ['2'],
                        DynamicField_Test2 => ['1'],
                    },
                },
            },
            UserID => $UserID,
        },
        Success  => 1,
        UpdateDB => 1
    },
    {
        Name   => 'TransitionUpdate Test 8: Correct UTF8',
        Config => {
            ID       => $AddedTransitionsList[1],
            EntityID => $RandomID . '-1-U',
            Name     => "Transition-$RandomID -äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-U",
            Config   => {
                Condition => {
                    Type  => 'and',
                    Cond1 => {
                        Type   => 'and',
                        Fields => {
                            DynamicField_Test1 => {
                                Type  => 'String',
                                Match => '-äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-U',
                            },
                            DynamicField_Test2 => ['1'],
                        },
                    },
                    Cond2 => {
                        DynamicField_Test1 => ['2'],
                        DynamicField_Test2 => ['1'],
                    },
                },
            },
            UserID => $UserID,
        },
        Success  => 1,
        UpdateDB => 1,
    },
    {
        Name   => 'TransitionUpdate Test 9: Correct UTF8 2',
        Config => {
            ID       => $AddedTransitionsList[1],
            EntityID => $RandomID . '-2-U',
            Name     => "Transition-$RandomID--!Â§$%&/()=?Ã*ÃÃL:L@,.-U",
            Config   => {
                Condition => {
                    Type  => 'and',
                    Cond1 => {
                        Type   => 'and',
                        Fields => {
                            DynamicField_Test1 => {
                                Type  => 'String',
                                Match => '!Â§$%&/()=?Ã*ÃÃL:L@,.-U',
                            },
                            DynamicField_Test2 => ['1'],
                        },
                    },
                    Cond2 => {
                        DynamicField_Test1 => ['2'],
                        DynamicField_Test2 => ['1'],
                    },
                },
            },
            UserID => $UserID,
        },
        Success  => 1,
        UpdateDB => 1,
    },
    {
        Name   => 'TransitionUpdate Test 10: Correct ASCII No DBUpdate',
        Config => {
            ID       => $AddedTransitionsList[0],
            EntityID => $RandomID . '-U',
            Name     => "Transition-$RandomID -U",
            Config   => {
                Condition => {
                    Type  => 'and',
                    Cond1 => {
                        Type   => 'and',
                        Fields => {
                            DynamicField_Test1 => {
                                Type  => 'String',
                                Match => 'Teststring-U',
                            },
                            DynamicField_Test2 => ['1'],
                        },
                    },
                    Cond2 => {
                        DynamicField_Test1 => ['2'],
                        DynamicField_Test2 => ['1'],
                    },
                },
            },
            UserID => $UserID,
        },
        Success  => 1,
        UpdateDB => 0,
    },
);

for my $Test (@Tests) {

    # get the old Transition (if any)
    my $OldTransition = $TransitionObject->TransitionGet(
        ID => $Test->{Config}->{ID} || 0,
        UserID => $Test->{Config}->{UserID},
    );

    if ( $Test->{Success} ) {

        # try to update the Transition
        print "Force a gap between create and update Transition, Waiting 2s\n";

        # wait 2 seconds
        $HelperObject->FixedTimeAddSeconds(2);

        my $Success = $TransitionObject->TransitionUpdate( %{ $Test->{Config} } );

        $Self->IsNot(
            $Success,
            0,
            "$Test->{Name} | Result should be 1"
        );

        # check cache
        my $CacheKey = 'TransitionGet::ID::' . $Test->{Config}->{ID};

        my $Cache = $TransitionObject->{CacheObject}->Get(
            Type => 'ProcessManagement_Transition',
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

        # get the new Transition
        my $NewTransition = $TransitionObject->TransitionGet(
            ID     => $Test->{Config}->{ID},
            UserID => $Test->{Config}->{UserID},
        );

        # check cache
        $Cache = $TransitionObject->{CacheObject}->Get(
            Type => 'ProcessManagement_Transition',
            Key  => $CacheKey,
        );

        $Self->IsDeeply(
            $Cache,
            $NewTransition,
            "$Test->{Name} | Cache is equal to updated Transition",
        );

        if ( $Test->{UpdateDB} ) {
            $Self->IsNotDeeply(
                $NewTransition,
                $OldTransition,
                "$Test->{Name} | Updated Transition is different than original",
            );

            # check create and change times
            $Self->Is(
                $NewTransition->{CreateTime},
                $OldTransition->{CreateTime},
                "$Test->{Name} | Updated Transition create time should not change",
            );
            $Self->IsNot(
                $NewTransition->{ChangeTime},
                $OldTransition->{ChangeTime},
                "$Test->{Name} | Updated Transition change time should be different",
            );

            # remove not need parameters
            my %ExpectedTransition = %{ $Test->{Config} };
            delete $ExpectedTransition{UserID};

            for my $Attribute (qw(CreateTime ChangeTime)) {
                delete $NewTransition->{$Attribute};
            }

            $Self->IsDeeply(
                $NewTransition,
                \%ExpectedTransition,
                "$Test->{Name} | Transition"
            );
        }
        else {
            $Self->IsDeeply(
                $NewTransition,
                $OldTransition,
                "$Test->{Name} | Updated Transition is equal than original",
            );
        }
    }
    else {
        my $Success = $TransitionObject->TransitionUpdate( %{ $Test->{Config} } );

        $Self->False(
            $Success,
            "$Test->{Name} | Result should fail",
        );
    }
}

#
# TransitionList() tests
#

# no params
my $TestTransitionList = $TransitionObject->TransitionList();

$Self->Is(
    $TestTransitionList,
    undef,
    "TransitionList Test 1: No Params | Should be undef",
);

# normal Transition list
$TestTransitionList = $TransitionObject->TransitionList( UserID => $UserID );

$Self->Is(
    ref $TestTransitionList,
    'HASH',
    "TransitionList Test 2: All | Should be a HASH",
);

$Self->True(
    IsHashRefWithData($TestTransitionList),
    "TransitionList Test 2: All | Should be not empty HASH",
);

$Self->IsNotDeeply(
    $TestTransitionList,
    $OriginalTransitionList,
    "TransitionList Test 2: All | Should be different than the original",
);

# delete original Transitions
for my $TransitionID ( sort keys %{$OriginalTransitionList} ) {
    delete $TestTransitionList->{$TransitionID};
}

$Self->Is(
    scalar keys %{$TestTransitionList},
    scalar @AddedTransitionsList,
    "TransitionList Test 2: All Transition | Number of Transitions match added Transitions",
);

my $Counter = 0;
for my $TransitionID ( sort { $a <=> $b } keys %{$TestTransitionList} ) {
    $Self->Is(
        $TransitionID,
        $AddedTransitionsList[$Counter],
        "TransitionList Test 2: All | TransitionID match AddedTransitionID",
        ),
        $Counter++;
}

#
# TransitionDelete() (test for fail, test for success are done by removing transitions
# at the end)
#
@Tests = (
    {
        Name    => 'TransitionDelete Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'TransitionDelete Test 2: No Transition ID',
        Config => {
            ID     => undef,
            UserID => $RandomID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionDelete Test 3: No UserID',
        Config => {
            ID     => $RandomID,
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionDelete Test 4: Wrong Transition ID',
        Config => {
            ID     => $RandomID,
            UserID => $UserID,
        },
        Success => 0,
    },
);

for my $Test (@Tests) {
    my $Success = $TransitionObject->TransitionDelete( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} | Transition deleted with true",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} | Transition delete with false",
        );
    }
}

#
# TransitionListGet() tests
#

my $FullList = $TransitionObject->TransitionListGet(
    UserID => undef,
);

$Self->IsNot(
    ref $FullList,
    'ARRAY',
    "TransitionListGet Test 1: No UserID | List Should not be an array",
);

# get the List of transitions with all details
$FullList = $TransitionObject->TransitionListGet(
    UserID => $UserID,
);

# get simple list of transitions
my $List = $TransitionObject->TransitionList(
    UserID => $UserID,
);

# create the list of transitions with details manually
my $ExpectedTransitionList;
for my $TransitionID ( sort { $a <=> $b } keys %{$List} ) {

    my $TransitionData = $TransitionObject->TransitionGet(
        ID     => $TransitionID,
        UserID => $UserID,
    );
    push @{$ExpectedTransitionList}, $TransitionData;
}

$Self->Is(
    ref $FullList,
    'ARRAY',
    "TransitionListGet Test 2: Correct List | Should be an array",
);

$Self->True(
    IsArrayRefWithData($FullList),
    "TransitionListGet Test 2: Correct List | The list is not empty",
);

$Self->IsDeeply(
    $FullList,
    $ExpectedTransitionList,
    "TransitionListGet Test 2: Correct List | Transition List",
);

# check cache
my $CacheKey = 'TransitionListGet';

my $Cache = $TransitionObject->{CacheObject}->Get(
    Type => 'ProcessManagement_Transition',
    Key  => $CacheKey,
);

$Self->IsDeeply(
    $Cache,
    $FullList,
    "TransitionListGet Test 2: Correct List | Cache",
);

print "------------System Cleanup------------\n";

# remove added Transitions
for my $TransitionID ( sort keys %AddedTransitions ) {
    my $Success = $TransitionObject->TransitionDelete(
        ID     => $TransitionID,
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "TransitionDelete() TransitionID:$TransitionID | Deleted sucessfully",
    );
}
1;
