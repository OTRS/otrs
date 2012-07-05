# --
# Process.t - ProcessManagement process tests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Process.t,v 1.1 2012-07-05 04:19:49 cr Exp $
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
use Kernel::System::ProcessManagement::Activity;
use Kernel::System::ProcessManagement::Process;
use Kernel::System::UnitTest::Helper;
use Kernel::System::VariableCheck qw(:all);

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);

my $ConfigObject = Kernel::Config->new();

my $ProcessObject = Kernel::System::ProcessManagement::Process->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $ActivityObject = Kernel::System::ProcessManagement::Activity->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# define needed variables
my $RandomID          = $HelperObject->GetRandomID();
my $UserID            = 1;
my $ActivityEntityID1 = 'A1-' . $RandomID;
my $ActivityEntityID2 = 'A2-' . $RandomID;
my $ActivityEntityID3 = 'A3-' . $RandomID;
my $ActivityName1     = 'Activity1';
my $ActivityName2     = 'Activity2';
my $ActivityName3     = 'Activity3';

my %ActivityLookup = (
    $ActivityEntityID1 => $ActivityName1,
    $ActivityEntityID2 => $ActivityName2,
    $ActivityEntityID3 => $ActivityName3,
);

my $AcitivityID1 = $ActivityObject->ActivityAdd(
    EntityID => $ActivityEntityID1,
    Name     => $ActivityName1,
    Config   => {},
    UserID   => $UserID,
);
my $AcitivityID2 = $ActivityObject->ActivityAdd(
    EntityID => $ActivityEntityID2,
    Name     => $ActivityName2,
    Config   => {},
    UserID   => $UserID,
);
my $AcitivityID3 = $ActivityObject->ActivityAdd(
    EntityID => $ActivityEntityID3,
    Name     => $ActivityName3,
    Config   => {},
    UserID   => $UserID,
);
my @AddedActivities = ( $AcitivityID1, $AcitivityID2, $AcitivityID3 );
my $ActivityList = $ActivityObject->ActivityList(
    UseEntities => 1,
    UserID      => $UserID,
);

#
# Tests for ProcessAdd
#
my @Tests = (
    {
        Name    => 'ProcessAdd Test 1: No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'ProcessAdd Test 2: No EntityID',
        Config => {
            EntityID => undef,
            Name     => 'Process-$RandomID',
            StateID  => 1,
            Layout   => {},
            Config   => {
                Description => 'a Description',
            },
            UserID => $UserID,
        },
        Success => 0,

    },
    {
        Name   => 'ProcessAdd Test 3: No Name',
        Config => {
            EntityID => $RandomID,
            Name     => undef,
            StateID  => 1,
            Layout   => {},
            Config   => {
                Description => 'a Description',
            },
            UserID => $UserID,
        },
        Success => 0,

    },
    {
        Name   => 'ProcessAdd Test 4: No StateID',
        Config => {
            EntityID => $RandomID,
            Name     => "Process-$RandomID",
            StateID  => undef,
            Layout   => {},
            Config   => {
                Description => 'a Description',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessAdd Test 5: No Layout',
        Config => {
            EntityID => $RandomID,
            Name     => "Process-$RandomID",
            StateID  => 1,
            Layout   => undef,
            Config   => {
                Description => 'a Description',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessAdd Test 6: No Config',
        Config => {
            EntityID => $RandomID,
            Name     => "Process-$RandomID",
            StateID  => 1,
            Layout   => {},
            Config   => undef,
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessAdd Test 7: No Config Description',
        Config => {
            EntityID => $RandomID,
            Name     => "Process-$RandomID",
            StateID  => 1,
            Layout   => {},
            Config   => {
                Data => 1,
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessAdd Test 8: No UserID',
        Config => {
            EntityID => $RandomID,
            Name     => "Process-$RandomID",
            StateID  => 1,
            Layout   => {},
            Config   => {
                Description => 'a Description',
            },
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessAdd Test 9: Wrong Config format',
        Config => {
            EntityID => $RandomID,
            Name     => "Process-$RandomID",
            StateID  => 1,
            Layout   => {},
            Config   => {},
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessAdd Test 10: Wrong Config format 2',
        Config => {
            EntityID => $RandomID,
            Name     => "Process-$RandomID",
            StateID  => 1,
            Layout   => {},
            Config   => 'Config',
            UserID   => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessAdd Test 11: Correct ASCII',
        Config => {
            EntityID => $RandomID,
            Name     => "Process-$RandomID",
            StateID  => 1,
            Layout   => {},
            Config   => {
                Description => 'a Description',
                Path        => {
                    $ActivityEntityID1 => {},
                    }
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessAdd Test 12: Duplicated EntityID',
        Config => {
            EntityID => $RandomID,
            Name     => "Process-$RandomID",
            StateID  => 1,
            Layout   => {},
            Config   => {
                Description => 'a Description',
            },
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessAdd Test 13: Correct UTF8',
        Config => {
            EntityID => "$RandomID-1",
            Name     => "Process-$RandomID-!Â§$%&/()=?Ã*ÃÃL:L@,.-",
            StateID  => 1,
            Layout   => {},
            Config   => {
                Description => 'a Description Â§$%&/()=?Ã*ÃÃL:L@,.-',
                Path        => {
                    $ActivityEntityID1 => {},
                    $ActivityEntityID2 => {},
                    }
            },
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessAdd Test 14: Correct UTF8 2',
        Config => {
            EntityID => "$RandomID-2",
            Name     => "Process-$RandomID-äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ",
            StateID  => 1,
            Layout   => {},
            Config   => {
                Description => 'a Description äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ',
                Path        => {
                    $ActivityEntityID1 => {},
                    $ActivityEntityID2 => {},
                    $ActivityEntityID3 => {},
                    }
            },
            UserID => $UserID,
        },
        Success => 1,
    },

);

my %AddedProcess;
for my $Test (@Tests) {
    my $ProcessID = $ProcessObject->ProcessAdd( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $ProcessID,
            0,
            "$Test->{Name} | ProcessID should not be 0",
        );
        $AddedProcess{$ProcessID} = $Test->{Config};
    }
    else {
        $Self->Is(
            $ProcessID,
            undef,
            "$Test->{Name} | ProcessID should be undef",
        );
    }
}

#
# ProcessGet()
#

my @ProcessList = map {$_} sort keys %AddedProcess;
@Tests = (
    {
        Name    => 'ProcessGet Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'ProcessGet Test 2: No ID and EntityID',
        Config => {
            ID            => undef,
            EntityID      => undef,
            ActivityNames => 0,
            UserID        => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessGet Test 3: No UserID',
        Config => {
            ID            => 1,
            EntityID      => undef,
            ActivityNames => 0,
            UserID        => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessGet Test 4: Wrong ID',
        Config => {
            ID            => 'NotExistent' . $RandomID,
            EntityID      => undef,
            ActivityNames => 0,
            UserID        => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessGet Test 5: Wrong EntityID',
        Config => {
            ID            => undef,
            EntityID      => 'NotExistent' . $RandomID,
            ActivityNames => 0,
            UserID        => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessGet Test 6: Correct ASCII, W/ID, WO/ActivityNames ',
        Config => {
            ID            => $ProcessList[0],
            EntityID      => undef,
            ActivityNames => 0,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 7: Correct ASCII, W/ID, W/ActivityNames ',
        Config => {
            ID            => $ProcessList[0],
            EntityID      => undef,
            ActivityNames => 1,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 8: Correct UTF8, W/ID, WO/ActivityNames ',
        Config => {
            ID            => $ProcessList[1],
            EntityID      => undef,
            ActivityNames => 0,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 9: Correct UTF8, W/ID, W/ActivityNames ',
        Config => {
            ID            => $ProcessList[1],
            EntityID      => undef,
            ActivityNames => 1,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 11: Correct UTF82, W/ID, WO/ActivityNames ',
        Config => {
            ID            => $ProcessList[2],
            EntityID      => undef,
            ActivityNames => 0,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 12: Correct UTF82, W/ID, W/ActivityNames ',
        Config => {
            ID            => $ProcessList[2],
            EntityID      => undef,
            ActivityNames => 1,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 13: Correct ASCII, W/EntityID, WO/ActivityNames ',
        Config => {
            ID            => undef,
            EntityID      => $AddedProcess{ $ProcessList[0] }->{EntityID},
            ActivityNames => 0,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 14: Correct ASCII, W/EntityID, W/ActivityNames ',
        Config => {
            ID            => undef,
            EntityID      => $AddedProcess{ $ProcessList[0] }->{EntityID},
            ActivityNames => 1,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 15: Correct UTF8, W/EntityID, WO/ActivityNames ',
        Config => {
            ID            => undef,
            EntityID      => $AddedProcess{ $ProcessList[1] }->{EntityID},
            ActivityNames => 0,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 16: Correct UTF8, W/EntityID, W/ActivityNames ',
        Config => {
            ID            => undef,
            EntityID      => $AddedProcess{ $ProcessList[1] }->{EntityID},
            ActivityNames => 1,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 17: Correct UTF82, W/EntityID, WO/ActivityNames ',
        Config => {
            ID            => undef,
            EntityID      => $AddedProcess{ $ProcessList[2] }->{EntityID},
            ActivityNames => 0,
            UserID        => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ProcessGet Test 18: Correct UTF82, W/EntityID, W/ActivityNames ',
        Config => {
            ID            => undef,
            EntityID      => $AddedProcess{ $ProcessList[2] }->{EntityID},
            ActivityNames => 1,
            UserID        => $UserID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Process = $ProcessObject->ProcessGet( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            ref $Process,
            'HASH',
            "$Test->{Name} | Process structure is HASH",
        );
        $Self->True(
            IsHashRefWithData($Process),
            "$Test->{Name} | Process structure is non empty HASH",
        );
        if ( $Test->{Config}->{ActivityNames} ) {
            $Self->Is(
                ref $Process->{Activities},
                'HASH',
                "$Test->{Name} | Process Activities structure is HASH",
            );

            my %ExpectedActivities
                = map { $_ => $ActivityLookup{$_} }
                sort keys %{ $AddedProcess{ $Process->{ID} }->{Config}->{Path} };
            $Self->IsDeeply(
                $Process->{Activities},
                \%ExpectedActivities,
                "$Test->{Name} | Process Activities"
            );
        }
        else {
            $Self->Is(
                ref $Process->{Activities},
                'ARRAY',
                "$Test->{Name} | Process Activities structure is ARRAY",
            );

            my @ExpectedActivities
                = map {$_} sort keys %{ $AddedProcess{ $Process->{ID} }->{Config}->{Path} };
            $Self->IsDeeply(
                $Process->{Activities},
                \@ExpectedActivities,
                "$Test->{Name} | Process Activities"
            );
        }

        my $ActivityNames = 0;
        if ( defined $Test->{Config}->{ActivityNames} && $Test->{Config}->{ActivityNames} == 1 ) {
            $ActivityNames = 1;
        }

        # check cache
        my $CacheKey;
        if ( $Process->{ID} ) {
            $CacheKey = 'ProcessGet::ID::' . $Process->{ID} . '::ActivityNames::'
                . $ActivityNames;
        }
        else {
            $CacheKey = 'ProcessGet::EntityID::' . $Process->{EntityID} . '::ActivityNames::'
                . $ActivityNames;
        }

        my $Cache = $ProcessObject->{CacheObject}->Get(
            Type => 'ProcessManagement_Process',
            Key  => $CacheKey,
        );

        $Self->IsDeeply(
            $Cache,
            $Process,
            "$Test->{Name} | Process cache"
        );

        # remove not need parameters
        my %ExpectedProcess = %{ $AddedProcess{ $Process->{ID} } };
        delete $ExpectedProcess{UserID};

        for my $Attribute (qw(ID Activities CreateTime ChangeTime State)) {
            $Self->IsNot(
                $Process->{$Attribute},
                undef,
                "$Test->{Name} | Process->{$Attribute} should not be undef",
            );
            delete $Process->{$Attribute};
        }

        $Self->IsDeeply(
            $Process,
            \%ExpectedProcess,
            "$Test->{Name} | Process"
        );
    }
    else {
        $Self->False(
            ref $Process eq 'HASH',
            "$Test->{Name} | Process structure is not HASH",
        );
        $Self->Is(
            $Process,
            undef,
            "$Test->{Name} | Process should be undefined",
        );
    }
}

#
# ProcessDelete() (test for fail, test for success are done by removing processes at the end)
#
@Tests = (
    {
        Name    => 'ProcessDelete Test 1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'ProcessDelete Test 2: No process ID',
        Config => {
            ID     => undef,
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessDelete Test 3: No UserID',
        Config => {
            ID     => $RandomID,
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'ProcessDelete Test 4: Wrong process ID',
        Config => {
            ID     => $RandomID,
            UserID => $UserID,
        },
        Success => 0,
    },
);

for my $Test (@Tests) {
    my $Success = $ProcessObject->ProcessDelete( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $Success,
            "$Test->{Name} | Process deleted with true",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} | Process delete with false",
        );
    }
}

print "------------System Cleanup------------\n";

# remove added activities
for my $ActivityID (@AddedActivities) {
    my $Success = $ActivityObject->ActivityDelete(
        ID     => $ActivityID,
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "ActivityDelete() ActivityID:$ActivityID | Deleted sucessfully",
    );
}

# remove added processes
for my $ProcessID ( sort keys %AddedProcess ) {
    my $Success = $ProcessObject->ProcessDelete(
        ID     => $ProcessID,
        UserID => $UserID,
    );

    # sanity check
    $Self->True(
        $Success,
        "ProcessDelete() ProcessID:$ProcessID | Deleted sucessfully",
    );
}
1;
