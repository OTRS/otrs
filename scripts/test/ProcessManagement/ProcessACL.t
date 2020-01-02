# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

$ConfigObject->{Process}                   = \%TestProcesses;
$ConfigObject->{'Process::ActivityDialog'} = \%TestActivityDialogs;

my $RandomID = $Helper->GetRandomID();

# define a set of users
my $UserID1 = 1;
my ( $TestUser2, $UserID2 ) = $Helper->TestUserCreate();
$Self->IsNot(
    $UserID2,
    undef,
    "TestUserCreate() - UserID $UserID2 ID"
);
my ( $TestUser3, $UserID3 ) = $Helper->TestUserCreate();
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
my $Success = $GroupObject->PermissionGroupUserAdd(
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
$Success = $GroupObject->PermissionRoleUserAdd(
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
                    Process => ['P1'],
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
                    Process => ['[Not]P1'],
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
                    Process => ['[regexp]^p4$'],
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
                    Process => ['[Notregexp]^p4$'],
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
                    Process => ['P1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['P2'],
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
                    Process => ['P1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['[Not]P1'],
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
                    Process => ['P1'],
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
                    Process => ['P1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['[regexp]^p4$'],
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
                    Process => ['P1'],
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
                    Process => ['P1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['[Notregexp]^p4$'],
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
                    Process => ['P1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['P2'],
                },
            },
            '103-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    Process => ['P4'],
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
                    Process => ['P1'],
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
                    Process => ['[Not]P1'],
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
                    Process => ['[regexp]^p4$'],
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
                    Process => ['[Notregexp]^p4$'],
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
                    Process => [ 'P1', 'P2' ],
                },
            },
            '101-Test' => {
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
                    Process => [ 'P1', 'P4' ],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    Process => ['P2'],
                },
            },
            '103-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    Process => ['P4'],
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
                    Process => [ 'P1', 'P2' ],
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
                    Process => ['P1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        Group_rw => [$GroupName],
                    },
                },
                PossibleAdd => {
                    Process => ['P2'],
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
                    Process => ['P2'],
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
                    Process => ['P4'],
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
                    Process => ['P4'],
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

        my $ProcessList = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process')->ProcessList(
            ProcessState => [ 'Active', 'FadeAway' ],
            Interface    => ['AgentInterface'],
        );

        # prepare process list for ACLs, use only entities instead of names, convert from
        #   P1 => Name to P1 => P1. As ACLs should work only against entities
        my %ProcessListACL = map { $_ => $_ } sort keys %{$ProcessList};

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # validate the ProcessList with stored ACLs
        my $ACL = $TicketObject->TicketAcl(
            ReturnType    => 'Process',
            ReturnSubType => '-',
            Data          => \%ProcessListACL,
            UserID        => $UserID,
        );

        if ($ACL) {

            # get ACL results
            my %ACLData = $TicketObject->TicketAclData();

            # recover process names
            my %ReducedProcessList = map { $_ => $ProcessList->{$_} } sort keys %ACLData;

            # replace original process list with the reduced one
            $ProcessList = \%ReducedProcessList;
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

# cleanup is done by RestoreDatabase

1;
