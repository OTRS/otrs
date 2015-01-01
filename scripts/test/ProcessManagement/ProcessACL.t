# --
# ProcessACL.t - Process module test script
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

use Kernel::System::Ticket;
use Kernel::System::ProcessManagement::Process;

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create common objects to be used in ActivityDialog object creation
my %CommonObject;
$CommonObject{ActivityObject}         = $Kernel::OM->Get('Kernel::System::ProcessManagement::Activity');
$CommonObject{ActivityDialogObject}   = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog');
$CommonObject{TransitionObject}       = $Kernel::OM->Get('Kernel::System::ProcessManagement::Transition');
$CommonObject{TransitionActionObject} = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction');

# define a testing environment, set defined processes to be easy to compare, this are done in memory
#   no changes to the real system configuration
my %TestProcesses = (
    P1 => {
        Name => 'Process1',
        Path => {
            A1 => {},
        },
        StartActivity       => 'A1',
        StartActivityDialog => 'AD1',
        State               => 'Active',
        StateEntityID       => 'S1',
    },
    P2 => {
        Name => 'Process2',
        Path => {
            A1 => {},
        },
        StartActivity       => 'A1',
        StartActivityDialog => 'AD1',
        State               => 'Active',
        StateEntityID       => 'S1',
    },
    P3 => {
        Name => 'Process3',
        Path => {
            A1 => {},
        },
        StartActivity       => 'A1',
        StartActivityDialog => 'AD1',
        State               => 'Inactive',
        StateEntityID       => 'S2',
    },
    P4 => {
        Name => 'Process4',
        Path => {
            A1 => {},
        },
        StartActivity       => 'A1',
        StartActivityDialog => 'AD1',
        State               => 'FadeAway',
        StateEntityID       => 'S3',
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
        Interface        => [ 'AgentInterface', 'CustomerInterface' ],
        Name             => 'AD1',
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
    P1 => 'Process1',
    P2 => 'Process2',
    P4 => 'Process4',
);

my @Tests = (
    {
        Name            => 'No ACLs',
        ACLs            => {},
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
            P4 => 'Process4',
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
                    Process => ['Process1'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
        },
    },
    {
        Name => 'ACL UserID W/Possible [Not]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['[Not]Process1'],
                },
            },
        },
        ExpectedResults => {
            P2 => 'Process2',
            P4 => 'Process4',
        },
    },
    {
        Name => 'ACL UserID W/Possible [RegExp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['[RegExp]4'],
                },
            },
        },
        ExpectedResults => {
            P4 => 'Process4',
        },
    },
    {
        Name => 'ACL UserID W/Possible [regexp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['[regexp]^pro.+4$'],
                },
            },
        },
        ExpectedResults => {
            P4 => 'Process4',
        },
    },
    {
        Name => 'ACL UserID W/Possible [NotRegExp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['[NotRegExp]4'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
        },
    },
    {
        Name => 'ACL UserID W/Possible [Notregexp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['[Notregexp]^pro.+4$'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
        },
    },
    {
        Name => 'ACL UserID W/Possible/PossibleAdd',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['Process1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['Process2'],
                },
            },

        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
        },
    },
    {
        Name => 'ACL UserID W/Possible/PossibleAdd [Not]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['Process1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['[Not]Process1'],
                },
            },

        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
            P4 => 'Process4',
        },
    },
    {
        Name => 'ACL UserID W/Possible/PossibleAdd [RegExp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['Process1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['[RegExp]4'],
                },
            },

        },
        ExpectedResults => {
            P1 => 'Process1',
            P4 => 'Process4',
        },
    },
    {
        Name => 'ACL UserID W/Possible/PossibleAdd [regexp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['Process1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['[regexp]^pro.+4$'],
                },
            },

        },
        ExpectedResults => {
            P1 => 'Process1',
            P4 => 'Process4',
        },
    },
    {
        Name => 'ACL UserID W/Possible/PossibleAdd [NotRegExp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['Process1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['[NotRegExp]4'],
                },
            },

        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
        },
    },
    {
        Name => 'ACL UserID W/Possible/PossibleAdd [Notregexp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['Process1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['[Notregexp]^pro.+4$'],
                },
            },

        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
        },
    },
    {
        Name => 'ACL UserID W/Possible/PossibleAdd/Possible',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['Process1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['Process2'],
                },
            },
            '103-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['Process4'],
                },
            },
        },
        ExpectedResults => {
            P4 => 'Process4',
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
                    Process => ['Process1'],
                },
            },
        },
        ExpectedResults => {
            P2 => 'Process2',
            P4 => 'Process4',
        },
    },
    {
        Name => 'ACL UserID W/PossibleNot [Not]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    Process => ['[Not]Process1'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
        },
    },
    {
        Name => 'ACL UserID W/PossibleNot [RegExp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    Process => ['[RegExp]4'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
        },
    },
    {
        Name => 'ACL UserID W/PossibleNot [regexp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    Process => ['[regexp]^pro.+4$'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
        },
    },
    {
        Name => 'ACL UserID W/PossibleNot [NotRegExp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    Process => ['[NotRegExp]4'],
                },
            },
        },
        ExpectedResults => {
            P4 => 'Process4',
        },
    },
    {
        Name => 'ACL UserID W/PossibleNot [Notregexp]',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    Process => ['[Notregexp]^pro.+4$'],
                },
            },
        },
        ExpectedResults => {
            P4 => 'Process4',
        },
    },
    {
        Name => 'ACL UserID W/Possible/PossibleNot',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => [ 'Process1', 'Process2' ],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    Process => ['Process1'],
                },
            },

        },
        ExpectedResults => {
            P2 => 'Process2',
        },
    },
    {
        Name => 'ACL UserID W/Possible/PossibleAdd/PossibleNot',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => [ 'Process1', 'Process4' ],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['Process2'],
                },
            },
            '103-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    Process => ['Process4'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
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
                    Process => [ 'Process1', 'Process2' ],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
        },
    },
    {
        Name => 'ACL Group_rw W/PossibleAdd',
        ACLs => {
            '100-Test' => {
                Properties => {
                    User => {
                        Group_rw => [$GroupName],
                    },
                },
                Possible => {
                    Process => ['Process1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        Group_rw => [$GroupName],
                    },
                },
                PossibleAdd => {
                    Process => ['Process2'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
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
                    Process => ['Process2'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
            P4 => 'Process4',
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
                    Process => ['Process4'],
                },
            },
        },
        ExpectedResults => {
            P4 => 'Process4',
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
                    Process => ['Process4'],
                },
            },
        },
        ExpectedResults => {
            P1 => 'Process1',
            P2 => 'Process2',
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
            ProcessState => [ 'Active', 'FadeAway' ],
            Interface    => ['AgentInterface'],
        );

        # validate the ProcessList with stored ACLs
        my $ACL = $TicketObject->TicketAcl(
            ReturnType    => 'Process',
            ReturnSubType => '-',
            Data          => $ProcessList,
            UserID        => $UserID,
        );

        if ($ACL) {
            %{$ProcessList} = $TicketObject->TicketAclData();
        }

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
