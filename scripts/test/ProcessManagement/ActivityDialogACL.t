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
        Name                => 'ActivityDialog 1',
        State               => 'Active',
        StartActivity       => 'A1',
        StartActivityDialog => 'AD1',
        Path                => {
            A1 => {
                T1 => {
                    ActivityEntityID => 'A2',
                },
            },
            A2 => {
                T2 => {
                    ActivityEntityID => 'A3',
                },
            },
        },
    },
);

my %TestActivities = (
    A1 => {
        Name           => 'Activity 1',
        ActivityDialog => {
            1 => 'AD1',
            2 => 'AD2',
            3 => 'AD3',
            4 => 'AD4',
            5 => 'AD5',
        },
    },
);

my %TestActivityDialogs = (
    AD1 => {
        Name             => 'Activity Dialog 1',
        DescriptionShort => '',
        DescriptionLong  => '',
        Interface        => [ 'AgentInterface', 'CustomerInterface' ],
        Fields           => {
            Queue => {
                DescriptionShort => '',
                DescriptionLong  => '',
                DefaultValue     => 'Raw',
                Display          => 2,
            },
        },
        FieldOrder => ['Queue'],
    },
    AD2 => {
        Name             => 'Activity Dialog 2',
        DescriptionShort => '',
        DescriptionLong  => '',
        Interface        => [ 'AgentInterface', 'CustomerInterface' ],
        Fields           => {
            DynamicField_OrderStatus => {
                DescriptionShort => '',
                DescriptionLong  => '',
                DefaultValue     => 4,
                Display          => 2,
            },
        },
        FieldOrder =>
            [ 'DynamicField_OrderStatus', ],
    },
    AD3 => {
        Name             => 'Activity Dialog 3',
        DescriptionShort => '',
        DescriptionLong  => '',
        Interface        => [ 'AgentInterface', 'CustomerInterface' ],
        Fields           => {
            DynamicField_OrderStatus => {
                DescriptionShort => '',
                DescriptionLong  => '',
                DefaultValue     => 4,
                Display          => 2,
            },
        },
        FieldOrder =>
            [ 'DynamicField_OrderStatus', ],
    },
    AD4 => {
        Name             => 'Activity Dialog 4',
        DescriptionShort => '',
        DescriptionLong  => '',
        Interface        => [ 'AgentInterface', 'CustomerInterface' ],
        Fields           => {
            DynamicField_OrderStatus => {
                DescriptionShort => '',
                DescriptionLong  => '',
                DefaultValue     => 4,
                Display          => 2,
            },
        },
        FieldOrder => [ 'DynamicField_OrderStatus', ],
    },
    AD5 => {
        Name             => 'Activity Dialog 5',
        DescriptionShort => '',
        DescriptionLong  => '',
        Interface        => [ 'AgentInterface', 'CustomerInterface' ],
        Fields           => {
            DynamicField_OrderStatus => {
                DescriptionShort => '',
                DescriptionLong  => '',
                DefaultValue     => 4,
                Display          => 2,
            },
        },
        FieldOrder => [ 'DynamicField_OrderStatus', ],
    },
    AD6 => {
        Name             => 'Activity Dialog 6',
        DescriptionShort => '',
        DescriptionLong  => '',
        Interface        => [ 'AgentInterface', 'CustomerInterface' ],
        Fields           => {
            DynamicField_OrderStatus => {
                DescriptionShort => '',
                DescriptionLong  => '',
                DefaultValue     => 4,
                Display          => 2,
            },
        },
        FieldOrder => [ 'DynamicField_OrderStatus', ],
    },
);

$ConfigObject->{ActivityDialog}                   = \%TestProcesses;
$ConfigObject->{'ActivityDialog::ActivityDialog'} = \%TestActivityDialogs;
$ConfigObject->{'ActivityDialog::Activity'}       = \%TestActivities;

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
    Comment => 'comment describing the role',
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

my %TestActivityDialogsList = %{ $TestActivities{A1}->{ActivityDialog} };

my @Tests = (
    {
        Name            => 'No ACLs',
        ACLs            => {},
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
            3 => 'AD3',
            4 => 'AD4',
            5 => 'AD5',
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
                    ActivityDialog => ['AD1'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
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
                    ActivityDialog => ['[Not]AD1'],
                },
            },
        },
        ExpectedResults => {
            2 => 'AD2',
            3 => 'AD3',
            4 => 'AD4',
            5 => 'AD5',
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
                    ActivityDialog => ['[RegExp]4'],
                },
            },
        },
        ExpectedResults => {
            4 => 'AD4',
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
                    ActivityDialog => ['[regexp]^a.+4$'],
                },
            },
        },
        ExpectedResults => {
            4 => 'AD4',
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
                    ActivityDialog => ['[NotRegExp]4'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
            3 => 'AD3',
            5 => 'AD5',
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
                    ActivityDialog => ['[Notregexp]^a.+4$'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
            3 => 'AD3',
            5 => 'AD5',
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
                    ActivityDialog => ['AD1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    ActivityDialog => ['AD2'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
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
                    ActivityDialog => ['AD1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    ActivityDialog => ['[Not]AD1'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
            3 => 'AD3',
            4 => 'AD4',
            5 => 'AD5',
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
                    ActivityDialog => ['AD1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    ActivityDialog => ['[RegExp]4'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            4 => 'AD4',
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
                    ActivityDialog => ['AD1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    ActivityDialog => ['[regexp]^a.+4$'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            4 => 'AD4',
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
                    ActivityDialog => ['AD1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    ActivityDialog => ['[NotRegExp]4'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
            3 => 'AD3',
            5 => 'AD5',
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
                    ActivityDialog => ['AD1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    ActivityDialog => ['[Notregexp]^a.+4$'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
            3 => 'AD3',
            5 => 'AD5',
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
                    ActivityDialog => ['AD1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    ActivityDialog => ['AD2'],
                },
            },
            '103-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                Possible => {
                    ActivityDialog => ['AD4'],
                },
            },
        },
        ExpectedResults => {
            4 => 'AD4',
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
                    ActivityDialog => ['AD1'],
                },
            },
        },
        ExpectedResults => {
            2 => 'AD2',
            3 => 'AD3',
            4 => 'AD4',
            5 => 'AD5',
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
                    ActivityDialog => ['[Not]AD1'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
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
                    ActivityDialog => ['[RegExp]4'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
            3 => 'AD3',
            5 => 'AD5',
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
                    ActivityDialog => ['[regexp]^a.+4$'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
            3 => 'AD3',
            5 => 'AD5',
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
                    ActivityDialog => ['[NotRegExp]4'],
                },
            },
        },
        ExpectedResults => {
            4 => 'AD4',
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
                    ActivityDialog => ['[Notregexp]^a.+4$'],
                },
            },
        },
        ExpectedResults => {
            4 => 'AD4',
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
                    ActivityDialog => [ 'AD1', 'AD2' ],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    ActivityDialog => ['AD1'],
                },
            },

        },
        ExpectedResults => {
            2 => 'AD2',
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
                    ActivityDialog => [ 'AD1', 'AD4' ],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleAdd => {
                    ActivityDialog => ['AD2'],
                },
            },
            '103-Test' => {
                Properties => {
                    User => {
                        UserID => [$UserID2],
                    },
                },
                PossibleNot => {
                    ActivityDialog => ['AD4'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
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
                    ActivityDialog => [ 'AD1', 'AD2' ],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
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
                    ActivityDialog => ['AD1'],
                },
            },
            '101-Test' => {
                Properties => {
                    User => {
                        Group_rw => [$GroupName],
                    },
                },
                PossibleAdd => {
                    ActivityDialog => ['AD2'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
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
                    ActivityDialog => ['AD2'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            3 => 'AD3',
            4 => 'AD4',
            5 => 'AD5',
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
                    ActivityDialog => ['AD4'],
                },
            },
        },
        ExpectedResults => {
            4 => 'AD4',
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
                    ActivityDialog => ['AD4'],
                },
            },
        },
        ExpectedResults => {
            1 => 'AD1',
            2 => 'AD2',
            3 => 'AD3',
            5 => 'AD5',
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

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # validate the ProcessList with stored ACLs
        my $ACL = $TicketObject->TicketAcl(
            ReturnType    => 'ActivityDialog',
            ReturnSubType => '-',
            Data          => \%TestActivityDialogsList,
            UserID        => $UserID,
        );

        my $ActivityDialogs = \%TestActivityDialogsList;
        if ($ACL) {

            my %Result = $TicketObject->TicketAclData();
            $ActivityDialogs = \%Result;
        }

        if ( $UserID == $AffectedUserID ) {
            $Self->IsDeeply(
                $ActivityDialogs,
                $Test->{ExpectedResults},
                "$Test->{Name} ActivityDialogs for $UserType",
            );
        }
        else {
            $Self->IsDeeply(
                $ActivityDialogs,
                \%TestActivityDialogsList,
                "$Test->{Name} ActivityDialogs for $UserType",
            );
        }
    }
}

# cleanup is done by RestoreDatabase

1;
