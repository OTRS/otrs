# --
# TransitionAction.t - ProcessManagement DB TransitionAction tests
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
use Kernel::System::ProcessManagement::DB::TransitionAction;
use Kernel::System::UnitTest::Helper;
use Kernel::System::VariableCheck qw(:all);

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);

my $ConfigObject = Kernel::Config->new();

my $TransitionActionObject = Kernel::System::ProcessManagement::DB::TransitionAction->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# set fixed time
$HelperObject->FixedTimeSet();

# define needed variables
my $RandomID = $HelperObject->GetRandomID();
my $UserID   = 1;

# get original TransitionAction list
my $OriginalTransitionActionList
    = $TransitionActionObject->TransitionActionList( UserID => $UserID ) || {};

#
# Tests for TransitionActionAdd
#

my @Tests = (
    {
        Name    => 'TransitionActionAdd Test 1: No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'TransitionActionAdd Test 2: No EntityID',
        Config => {
            EntityID => undef,
            Name     => 'TransitionAction-$RandomID',
            Config   => {
                Condition => {},
            },
            UserID => $UserID,
        },
        Success => 0,

    },
    {
        Name   => 'TransitionActionAdd Test 3: No Name',
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
        Name   => 'TransitionActionAdd Test 4: No Config',
        Config => {
            EntityID => $RandomID,
            Name     => "TransitionAction-$RandomID",
            Config   => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionAdd Test 5: No Config Module',
        Config => {
            EntityID => $RandomID,
            Name     => "TransitionAction-$RandomID",
            Config   => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionAdd Test 6: No Config Config',
        Config => {
            EntityID => $RandomID,
            Name     => "TransitionAction-$RandomID",
            Config   => {
                Config => {
                    Key1 => 'String',
                    Key2 => 2,
                },

            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionAdd Test 7: No UserID',
        Config => {
            EntityID => $RandomID,
            Name     => "TransitionAction-$RandomID",
            Config   => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove',
                Config => {
                    Key1 => 'String',
                    Key2 => 2,
                },
            },
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionAdd Test 8: Wrong Config format',
        Config => {
            EntityID => $RandomID,
            Name     => "TransitionAction-$RandomID",
            Config   => 'Config',
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionAdd Test 9: Wrong Config->Module format',
        Config => {
            EntityID => $RandomID,
            Name     => "TransitionAction-$RandomID",
            Config   => {
                Module => {
                    String => 'Kernel::System::Process::Transition::Action::QueueMove',
                },
                Config => {
                    Key1 => 'String',
                    Key2 => 2,
                },
            },
            UserID => $UserID,
        },
        Success => 0,
        Name    => 'TransitionActionAdd Test 10: Wrong Config->Config format',
        Config  => {
            EntityID => $RandomID,
            Name     => "TransitionAction-$RandomID",
            Config   => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove',
                Config => 'Config',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionAdd Test 11: Correct ASCII',
        Config => {
            EntityID => $RandomID,
            Name     => "TransitionAction-$RandomID",
            Config   => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove',
                Config => {
                    Key1 => 'String',
                    Key2 => 2,
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionActionAdd Test 12: Duplicated EntityID',
        Config => {
            EntityID => $RandomID,
            Name     => "TransitionAction-$RandomID",
            Config   => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove',
                Config => {
                    Key1 => 'String',
                    Key2 => 2,
                },
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionAdd Test 13: Correct UTF8',
        Config => {
            EntityID => "$RandomID-1",
            Name   => "TransitionAction-$RandomID--äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ",
            Config => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove',
                Config => {
                    Key1 => '-äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ',
                    Key2 => 2,
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionActionAdd Test 14: Correct UTF8 2',
        Config => {
            EntityID => "$RandomID-2",
            Name     => "TransitionAction-$RandomID--!Â§$%&/()=?Ã*ÃÃL:L@,.",
            Config   => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove',
                Config => {
                    Key1 => '-!Â§$%&/()=?Ã*ÃÃL:L@,.',
                    Key2 => 2,
                },
            },
            UserID => $UserID,
        },
        Success => 1,
    },
);

my %AddedTransitionActions;
for my $Test (@Tests) {
    my $TransitionActionID = $TransitionActionObject->TransitionActionAdd( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $TransitionActionID,
            undef,
            "$Test->{Name} | TransitionActionID should not be undef",
        );
        $AddedTransitionActions{$TransitionActionID} = $Test->{Config};
    }
    else {
        $Self->Is(
            $TransitionActionID,
            undef,
            "$Test->{Name} | TransitionActionID should be undef",
        );
    }
}

#
# TransitionActionGet()
#

my @AddedTransitionActionsList = map {$_} sort keys %AddedTransitionActions;
@Tests = (
    {
        Name    => 'TransitionActionGet Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'TransitionActionGet Test 2: No ID and EntityID',
        Config => {
            ID       => undef,
            EntityID => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionGet Test 3: No UserID',
        Config => {
            ID       => 1,
            EntityID => undef,
            UserID   => undef,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionGet Test 4: Wrong ID',
        Config => {
            ID       => 'NotExistent' . $RandomID,
            EntityID => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionGet Test 5: Wrong EntityID',
        Config => {
            ID       => undef,
            EntityID => 'NotExistent' . $RandomID,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionGet Test 6: Correct ASCII, W/ID',
        Config => {
            ID       => $AddedTransitionActionsList[0],
            EntityID => undef,
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionActionGet Test 7: Correct UTF8, W/ID',
        Config => {
            ID       => $AddedTransitionActionsList[1],
            EntityID => undef,
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionActionGet Test 8: Correct UTF82, W/ID',
        Config => {
            ID       => $AddedTransitionActionsList[2],
            EntityID => undef,
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionActionGet Test 9: Correct ASCII, W/EntityID,',
        Config => {
            ID       => undef,
            EntityID => $AddedTransitionActions{ $AddedTransitionActionsList[0] }->{EntityID},
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionActionGet Test 10: Correct UTF8, W/EntityID,',
        Config => {
            ID       => undef,
            EntityID => $AddedTransitionActions{ $AddedTransitionActionsList[1] }->{EntityID},
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'TransitionActionGet Test 11: Correct UTF82, W/EntityID,',
        Config => {
            ID       => undef,
            EntityID => $AddedTransitionActions{ $AddedTransitionActionsList[2] }->{EntityID},
            UserID   => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $TransitionAction = $TransitionActionObject->TransitionActionGet( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            ref $TransitionAction,
            'HASH',
            "$Test->{Name} | TransitionAction structure is HASH",
        );
        $Self->True(
            IsHashRefWithData($TransitionAction),
            "$Test->{Name} | TransitionAction structure is non empty HASH",
        );

        # check cache
        my $CacheKey;
        if ( $Test->{Config}->{ID} ) {
            $CacheKey = 'TransitionActionGet::ID::' . $Test->{Config}->{ID};
        }
        else {
            $CacheKey = 'TransitionActionGet::EntityID::' . $Test->{Config}->{EntityID};
        }

        my $Cache = $TransitionActionObject->{CacheObject}->Get(
            Type => 'ProcessManagement_TransitionAction',
            Key  => $CacheKey,
        );

        $Self->IsDeeply(
            $Cache,
            $TransitionAction,
            "$Test->{Name} | TransitionAction cache"
        );

        # remove not need parameters
        my %ExpectedTransitionAction = %{ $AddedTransitionActions{ $TransitionAction->{ID} } };
        delete $ExpectedTransitionAction{UserID};

        for my $Attribute (qw(ID CreateTime ChangeTime)) {
            $Self->IsNot(
                $TransitionAction->{$Attribute},
                undef,
                "$Test->{Name} | TransitionAction->{$Attribute} should not be undef",
            );
            delete $TransitionAction->{$Attribute};
        }

        $Self->IsDeeply(
            $TransitionAction,
            \%ExpectedTransitionAction,
            "$Test->{Name} | TransitionAction"
        );
    }
    else {
        $Self->False(
            ref $TransitionAction eq 'HASH',
            "$Test->{Name} | TransitionAction structure is not HASH",
        );
        $Self->Is(
            $TransitionAction,
            undef,
            "$Test->{Name} | TransitionAction should be undefined",
        );
    }
}

#
# TransitionActionUpdate() tests
#
@Tests = (
    {
        Name    => 'TransitionActionUpdate Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'TransitionActionUpdate Test 2: No ID',
        Config => {
            ID       => undef,
            EntityID => $RandomID . '-U',
            Name     => "TransitionAction-$RandomID",
            Config   => {
                Description => 'a Description',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionUpdate Test 3: No EntityID',
        Config => {
            ID       => 1,
            EntityID => undef,
            Name     => "TransitionAction-$RandomID",
            Config   => {
                Description => 'a Description',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionUpdate Test 4: No Name',
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
        Name   => 'TransitionActionUpdate Test 5: No Config',
        Config => {
            ID       => 1,
            EntityID => $RandomID . '-U',
            Name     => "TransitionAction-$RandomID",
            Config   => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionUpdate Test 6: No UserID',
        Config => {
            ID       => 1,
            EntityID => $RandomID . '-U',
            Name     => "TransitionAction-$RandomID",
            Config   => {
                Description => 'a Description',
            },
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionUpdate Test 7: Correct ASCII',
        Config => {
            ID       => $AddedTransitionActionsList[0],
            EntityID => $RandomID . '-U',
            Name     => "TransitionAction-$RandomID -U",
            Config   => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove-U',
                Config => {
                    Key1 => 'String-U',
                    Key2 => 2,
                },
            },
            UserID => $UserID,
        },
        Success  => 1,
        UpdateDB => 1
    },
    {
        Name   => 'TransitionActionUpdate Test 8: Correct UTF8',
        Config => {
            ID       => $AddedTransitionActionsList[1],
            EntityID => $RandomID . '-1-U',
            Name => "TransitionAction-$RandomID -äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-U",
            Config => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove-U',
                Config => {
                    Key1 => '-äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-U',
                    Key2 => 2,
                },
            },
            UserID => $UserID,
        },
        Success  => 1,
        UpdateDB => 1,
    },
    {
        Name   => 'TransitionActionUpdate Test 9: Correct UTF8 2',
        Config => {
            ID       => $AddedTransitionActionsList[1],
            EntityID => $RandomID . '-2-U',
            Name     => "TransitionAction-$RandomID--!Â§$%&/()=?Ã*ÃÃL:L@,.-U",
            Config   => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove-U',
                Config => {
                    Key1 => '-!Â§$%&/()=?Ã*ÃÃL:L@,.-U',
                    Key2 => 2,
                },
            },
            UserID => $UserID,
        },
        Success  => 1,
        UpdateDB => 1,
    },
    {
        Name   => 'TransitionActionUpdate Test 10: Correct ASCII No DBUpdate',
        Config => {
            ID       => $AddedTransitionActionsList[0],
            EntityID => $RandomID . '-U',
            Name     => "TransitionAction-$RandomID -U",
            Config   => {
                Module => 'Kernel::System::Process::Transition::Action::QueueMove-U',
                Config => {
                    Key1 => 'String-U',
                    Key2 => 2,
                },
            },
            UserID => $UserID,
        },
        Success  => 1,
        UpdateDB => 0,
    },
);

for my $Test (@Tests) {

    # get the old TransitionAction (if any)
    my $OldTransitionAction = $TransitionActionObject->TransitionActionGet(
        ID => $Test->{Config}->{ID} || 0,
        UserID => $Test->{Config}->{UserID},
    );

    if ( $Test->{Success} ) {

        # try to update the TransitionAction
        print "Force a gap between create and update TransitionAction, Waiting 2s\n";

        # wait 2 seconds
        $HelperObject->FixedTimeAddSeconds(2);

        my $Success = $TransitionActionObject->TransitionActionUpdate( %{ $Test->{Config} } );

        $Self->IsNot(
            $Success,
            0,
            "$Test->{Name} | Result should be 1"
        );

        # check cache
        my $CacheKey = 'TransitionActionGet::ID::' . $Test->{Config}->{ID};

        my $Cache = $TransitionActionObject->{CacheObject}->Get(
            Type => 'ProcessManagement_TransitionAction',
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

        # get the new TransitionAction
        my $NewTransitionAction = $TransitionActionObject->TransitionActionGet(
            ID     => $Test->{Config}->{ID},
            UserID => $Test->{Config}->{UserID},
        );

        # check cache
        $Cache = $TransitionActionObject->{CacheObject}->Get(
            Type => 'ProcessManagement_TransitionAction',
            Key  => $CacheKey,
        );

        $Self->IsDeeply(
            $Cache,
            $NewTransitionAction,
            "$Test->{Name} | Cache is equal to updated TransitionAction",
        );

        if ( $Test->{UpdateDB} ) {
            $Self->IsNotDeeply(
                $NewTransitionAction,
                $OldTransitionAction,
                "$Test->{Name} | Updated TransitionAction is different than original",
            );

            # check create and change times
            $Self->Is(
                $NewTransitionAction->{CreateTime},
                $OldTransitionAction->{CreateTime},
                "$Test->{Name} | Updated TransitionAction create time should not change",
            );
            $Self->IsNot(
                $NewTransitionAction->{ChangeTime},
                $OldTransitionAction->{ChangeTime},
                "$Test->{Name} | Updated TransitionAction change time should be different",
            );

            # remove not need parameters
            my %ExpectedTransitionAction = %{ $Test->{Config} };
            delete $ExpectedTransitionAction{UserID};

            for my $Attribute (qw(CreateTime ChangeTime)) {
                delete $NewTransitionAction->{$Attribute};
            }

            $Self->IsDeeply(
                $NewTransitionAction,
                \%ExpectedTransitionAction,
                "$Test->{Name} | TransitionAction"
            );
        }
        else {
            $Self->IsDeeply(
                $NewTransitionAction,
                $OldTransitionAction,
                "$Test->{Name} | Updated TransitionAction is equal than original",
            );
        }
    }
    else {
        my $Success = $TransitionActionObject->TransitionActionUpdate( %{ $Test->{Config} } );

        $Self->False(
            $Success,
            "$Test->{Name} | Result should fail",
        );
    }
}

#
# TransitionActionList() tests
#

# no params
my $TestTransitionActionList = $TransitionActionObject->TransitionActionList();

$Self->Is(
    $TestTransitionActionList,
    undef,
    "TransitionActionList Test 1: No Params | Should be undef",
);

# normal TransitionAction list
$TestTransitionActionList = $TransitionActionObject->TransitionActionList( UserID => $UserID );

$Self->Is(
    ref $TestTransitionActionList,
    'HASH',
    "TransitionActionList Test 2: All | Should be a HASH",
);

$Self->True(
    IsHashRefWithData($TestTransitionActionList),
    "TransitionActionList Test 2: All | Should be not empty HASH",
);

$Self->IsNotDeeply(
    $TestTransitionActionList,
    $OriginalTransitionActionList,
    "TransitionActionList Test 2: All | Should be different than the original",
);

# delete original TransitionActions
for my $TransitionActionID ( sort keys %{$OriginalTransitionActionList} ) {
    delete $TestTransitionActionList->{$TransitionActionID};
}

$Self->Is(
    scalar keys %{$TestTransitionActionList},
    scalar @AddedTransitionActionsList,
    "TransitionActionList Test 2: All TransitionAction | Number of TransitionActions match added TransitionActions",
);

my $Counter = 0;
for my $TransitionActionID ( sort { $a <=> $b } keys %{$TestTransitionActionList} ) {
    $Self->Is(
        $TransitionActionID,
        $AddedTransitionActionsList[$Counter],
        "TransitionActionList Test 2: All | TransitionActionID match AddedTransitionActionID",
        ),
        $Counter++;
}

#
# TransitionActionDelete() (test for fail, test for success are done by removing TransitionActions
# at the end)
#
@Tests = (
    {
        Name    => 'TransitionActionDelete Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'TransitionActionDelete Test 2: No TransitionAction ID',
        Config => {
            ID     => undef,
            UserID => $RandomID,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionDelete Test 3: No UserID',
        Config => {
            ID     => $RandomID,
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'TransitionActionDelete Test 4: Wrong TransitionAction ID',
        Config => {
            ID     => $RandomID,
            UserID => $UserID,
        },
        Success => 0,
    },
);

for my $Test (@Tests) {
    my $Success = $TransitionActionObject->TransitionActionDelete( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} | TransitionAction deleted with true",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} | TransitionAction delete with false",
        );
    }
}

#
# TransitionActionListGet() tests
#

my $FullList = $TransitionActionObject->TransitionActionListGet(
    UserID => undef,
);

$Self->IsNot(
    ref $FullList,
    'ARRAY',
    "TransitionActionListGet Test 1: No UserID | List Should not be an array",
);

# get the List of TransitionActions with all details
$FullList = $TransitionActionObject->TransitionActionListGet(
    UserID => $UserID,
);

# get simple list of TransitionActions
my $List = $TransitionActionObject->TransitionActionList(
    UserID => $UserID,
);

# create the list of TransitionActions with details manually
my $ExpectedTransitionActionList;
for my $TransitionActionID ( sort { $a <=> $b } keys %{$List} ) {

    my $TransitionActionData = $TransitionActionObject->TransitionActionGet(
        ID     => $TransitionActionID,
        UserID => $UserID,
    );
    push @{$ExpectedTransitionActionList}, $TransitionActionData;
}

$Self->Is(
    ref $FullList,
    'ARRAY',
    "TransitionActionListGet Test 2: Correct List | Should be an array",
);

$Self->True(
    IsArrayRefWithData($FullList),
    "TransitionActionListGet Test 2: Correct List | The list is not empty",
);

$Self->IsDeeply(
    $FullList,
    $ExpectedTransitionActionList,
    "TransitionActionListGet Test 2: Correct List | TransitionAction List",
);

# check cache
my $CacheKey = 'TransitionActionListGet';

my $Cache = $TransitionActionObject->{CacheObject}->Get(
    Type => 'ProcessManagement_TransitionAction',
    Key  => $CacheKey,
);

$Self->IsDeeply(
    $Cache,
    $FullList,
    "TransitionActionListGet Test 2: Correct List | Cache",
);

print "------------System Cleanup------------\n";

# remove added TransitionActions
for my $TransitionActionID ( sort keys %AddedTransitionActions ) {
    my $Success = $TransitionActionObject->TransitionActionDelete(
        ID     => $TransitionActionID,
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "TransitionActionDelete() TransitionActionID:$TransitionActionID | Deleted sucessfully",
    );
}
1;
