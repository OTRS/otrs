# --
# ActivityDialogACL.t - ActivityDialog module test script
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
use Kernel::System::ProcessManagement::ActivityDialog;
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

# create common objects to be used in ActivityDialog object creation
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

    $ProcessObject = Kernel::System::ProcessManagement::ActivityDialog->new(
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

        $RecreateObjects->();

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
