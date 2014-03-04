# --
# ProcessACL.t - Process module test script
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;
use vars qw($Self);

use Kernel::Config;
use Kernel::System::Group;
use Kernel::System::ProcessManagement::Activity;
use Kernel::System::ProcessManagement::ActivityDialog;
use Kernel::System::ProcessManagement::Process;
use Kernel::System::ProcessManagement::TransitionAction;
use Kernel::System::ProcessManagement::Transition;
use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

my $ConfigObject = Kernel::Config->new();

# create common objects to be used in process object creation
my %CommonObject;
$CommonObject{ActivityObject} = Kernel::System::ProcessManagement::Activity->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
$CommonObject{ActivityDialogObject} = Kernel::System::ProcessManagement::ActivityDialog->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
$CommonObject{TransitionActionObject} = Kernel::System::ProcessManagement::TransitionAction->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
$CommonObject{TransitionObject} = Kernel::System::ProcessManagement::Transition->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $GroupObject = Kernel::System::Group->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $UserObject = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# define a testing environment, set defined processes to be easy to compare, this are done in memory
#   no changes to the real system configuration
my %TestProcesses = (
    P1 => {
        Name => 'P1',
        Path => {
            A1 => {},
        },
        StartActivity       => 'A1',
        StartActivityDialog => 'AD1',
        State               => 'Active',
        StateEntityID       => 'S1',
    },
    P2 => {
        Name => 'P2',
        Path => {
            A1 => {},
        },
        StartActivity       => 'A1',
        StartActivityDialog => 'AD1',
        State               => 'Active',
        StateEntityID       => 'S1',
    },
    P3 => {
        Name => 'P3',
        Path => {
            A1 => {},
        },
        StartActivity       => 'A1',
        StartActivityDialog => 'AD1',
        State               => 'Inactive',
        StateEntityID       => 'S2',
    },
    P4 => {
        Name => 'P4',
        Path => {
            A1 => {},
        },
        StartActivity       => 'A1',
        StartActivityDialog => 'AD1',
        State               => 'Active',
        StateEntityID       => 'S1',
    },
);

my %TestActivityDialogs = (
    AD1 => {
        DescriptionLong  => '',
        DescriptionShort => '',
        FieldOrder       => ['Responsible'],
        Fields           => {
            Responsible => {
                DefaultValue     => '',
                DescriptionLong  => '',
                DescriptionShort => '',
                Display          => '1'
            },
        },
        Interface => [ 'AgentInterface', 'CustomerInterface' ],
        Name => 'AD1',
        Permission       => '',
        RequiredLock     => '',
        SubmitAdviceText => '',
        SubmitButtonText => '',
    },
);

$ConfigObject->{Process} = \%TestProcesses;
$ConfigObject->{'Process::ActivityDialog'} = \%TestActivityDialogs;

# create empty object holders, the following tests requires to set ACLs on the fly and will need to
#   re create the objects for each test.
my $TicketObject;
my $ProcessObject;

# this function is to recreate the objects.
my $RecreateObjects = sub {

    $TicketObject = Kernel::System::Ticket->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );

    $ProcessObject = Kernel::System::ProcessManagement::Process->new(
        %{$Self},
        %CommonObject,
        TicketObject => $TicketObject,
        ConfigObject => $ConfigObject,
    );

    return 1;
};

my $RandomID = $HelperObject->GetRandomID();

# define a set of users
my $UserID1   = 1;
my $TestUser2 = $HelperObject->TestUserCreate();
my $UserID2   = $UserObject->UserLookup(
    UserLogin => $TestUser2,
);
$Self->IsNot(
    $UserID2,
    undef,
    "TestUserCreate() - UserID $UserID2 ID"
);
my $TestUser3 = $HelperObject->TestUserCreate();
my $UserID3   = $UserObject->UserLookup(
    UserLogin => $TestUser3,
);
$Self->IsNot(
    $UserID3,
    undef,
    "TestUserCreate() - UserID $UserID3 ID"
);

# define the affected user
my $AffectedUserID = $UserID2;

# define groups and roles
my $GroupName = 'Group' . $RandomID;
my $GroupID   = $GroupObject->GroupAdd(
    Name    => $GroupName,
    Comment => 'comment describing the group',
    ValidID => 1,
    UserID  => 1,
);
$Self->IsNot(
    $GroupID,
    undef,
    "GroupAdd() - Group $GroupName ID"
);
my $RoleName = 'Role' . $RandomID;
my $RoleID   = $GroupObject->RoleAdd(
    Name    => $RoleName,
    Comment => 'comment describing the role',    # optional
    ValidID => 1,
    UserID  => 1,
);
$Self->IsNot(
    $RoleID,
    undef,
    "RoleAdd() - Role $RoleName ID"
);

# add the groups and roles to the users
my $Success = $GroupObject->GroupMemberAdd(
    GID        => $GroupID,
    UID        => $AffectedUserID,
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 1,
        rw        => 1,
    },
    UserID => 1,
);
$Self->True(
    $Success,
    "GroupMememberAdd() - for Affected User with true"
);
$Success = $GroupObject->GroupUserRoleMemberAdd(
    UID    => $AffectedUserID,
    RID    => $RoleID,
    Active => 1,
    UserID => 1,
);
$Self->True(
    $Success,
    "GroupUserRoleMemberAdd() - for Affected User with true"
);

my %ActiveProcessList = (
    P1 => 'P1',
    P2 => 'P2',
    P4 => 'P4',
);

my @Tests = (
    {
        Name            => 'No ACLs',
        ACLs            => {},
        ExpectedResults => {
            P1 => 'P1',
            P2 => 'P2',
            P4 => 'P4',
        },
    },
    {
        Name => 'ACL UserID W/Possible',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['P1'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'P1',
        },
    },
    {
        Name => 'ACL UserID W/PossibleNot',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    Process => ['P1'],
                },
            },
        },
        ExpectedResults => {
            P2 => 'P2',
            P4 => 'P4',
        },
    },
    {
        Name => 'ACL Group_rw W/Possible',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        Group_rw => [$GroupName],
                    },
                },
                Possible => {
                    Process => [ 'P1', 'P2' ],
                },
            },
        },
        ExpectedResults => {
            P1 => 'P1',
            P2 => 'P2',
        },
    },
    {
        Name => 'ACL Group_rw W/PossibleNot',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        Group_rw => [$GroupName],
                    },
                },
                PossibleNot => {
                    Process => ['P2'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'P1',
            P4 => 'P4',
        },
    },
    {
        Name => 'ACL Role W/Possible',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        Role => [$RoleName],
                    },
                },
                Possible => {
                    Process => ['P4'],
                },
            },
        },
        ExpectedResults => {
            P4 => 'P4',
        },
    },
    {
        Name => 'ACL Role W/PossibleNot',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        Role => [$RoleName],
                    },
                },
                PossibleNot => {
                    Process => ['P4'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'P1',
            P2 => 'P2',
        },
    },
);

for my $Test (@Tests) {
    $ConfigObject->{TicketAcl} = $Test->{ACLs};

    for my $UserID ( $UserID1, $UserID2, $UserID3 ) {

        my $UserType;
        if ( $UserID == 1 ) {
            $UserType = 'Root';
        }
        elsif ( $UserID == $AffectedUserID ) {
            $UserType = 'Affected User';
        }
        else {
            $UserType = 'Not Affected User';
        }

        $RecreateObjects->();

        my $ProcessList = $ProcessObject->ProcessList(
            ProcessState => ['Active'],
            Interface    => ['AgentInterface'],
        );

        # validate the ProcessList with stored ACLs
        $TicketObject->TicketAcl(
            ReturnType    => 'Ticket',
            ReturnSubType => '-',
            Data          => $ProcessList,
            UserID        => $UserID,
        );

        $ProcessList = $TicketObject->TicketAclProcessData(
            Processes => $ProcessList,
        );

        if ( $UserID == $AffectedUserID ) {
            $Self->IsDeeply(
                $ProcessList,
                $Test->{ExpectedResults},
                "$Test->{Name} ProcessList() for $UserType",
            );
        }
        else {
            $Self->IsDeeply(
                $ProcessList,
                \%ActiveProcessList,
                "$Test->{Name} ProcessList() for $UserType",
            );
        }
    }
}

# cleanup the system
# set added groups to invalid
$Success = $GroupObject->GroupUpdate(
    ID      => $GroupID,
    Name    => $GroupName,
    Comment => 'comment describing the group',
    ValidID => 2,
    UserID  => 1,
);
$Self->True(
    $Success,
    "GroupUpdate() - Set group $GroupName to invalid with true",
);

# set added roles to invalid
$Success = $GroupObject->RoleUpdate(
    ID      => $RoleID,
    Name    => $RoleName,
    Comment => 'comment describing the role',
    ValidID => 2,
    UserID  => 1,
);
$Self->True(
    $Success,
    "RoleUpdate() - Set role $RoleName to invalid with true",
);

1;
