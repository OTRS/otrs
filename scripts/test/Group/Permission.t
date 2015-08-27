# --
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

our @ObjectDependencies = (
    'Kernel::System::Group',
    'Kernel::System::Time',
    'Kernel::System::UnitTest::Helper',
    'Kernel::System::User',
);

# get needed objects
my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
my $TimeObject   = $Kernel::OM->Get('Kernel::System::Time');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

# create test users
my %UserIDByUserLogin;
for my $UserCount ( 0 .. 2 ) {
    my $UserLogin = $HelperObject->TestUserCreate();
    my $UserID = $UserObject->UserLookup( UserLogin => $UserLogin );

    $UserIDByUserLogin{$UserLogin} = $UserID;
}
my @UserIDs = values %UserIDByUserLogin;

# create test groups
my %GroupIDByGroupName;
my $GroupNameRandomPartBase = $TimeObject->SystemTime();
for my $GroupCount ( 1 .. 3 ) {
    my $GroupName = 'test-permission-group-' . $GroupNameRandomPartBase . '-' . $GroupCount;
    my $GroupID   = $GroupObject->GroupAdd(
        Name    => $GroupName,
        ValidID => 1,
        UserID  => 1,
    );

    $GroupIDByGroupName{$GroupName} = $GroupID;
}
my @GroupIDs = values %GroupIDByGroupName;

# create test roles
my %RoleIDByRoleName;
my $RoleNameRandomPartBase = $TimeObject->SystemTime();
for my $RoleCount ( 1 .. 3 ) {
    my $RoleName = 'test-permission-role-' . $RoleNameRandomPartBase . '-' . $RoleCount;
    my $RoleID   = $GroupObject->RoleAdd(
        Name    => $RoleName,
        ValidID => 1,
        UserID  => 1,
    );

    $RoleIDByRoleName{$RoleName} = $RoleID;
}
my @RoleIDs = values %RoleIDByRoleName;

#
# Permission tests (users and groups)
#
my @UserGroupPermissionTests = (
    {
        GroupIDs => [
            $GroupIDs[0], $GroupIDs[1],
        ],
        UserIDs => [
            $UserIDs[1], $UserIDs[2],
        ],
        Permissions => {
            ro        => 1,
            move_into => 1,
            create    => 1,
            owner     => 1,
            priority  => 0,
            rw        => 0,
        },
    },
    {
        GroupIDs => [
            $GroupIDs[1],
        ],
        UserIDs => [
            $UserIDs[2],
        ],
        Permissions => {
            ro        => 0,
            move_into => 1,
            create    => 0,
            owner     => 1,
            priority  => 0,
            rw        => 0,
        },
    },
    {
        GroupIDs => [
            $GroupIDs[0], $GroupIDs[2],
        ],
        UserIDs => [
            $UserIDs[0], $UserIDs[2],
        ],
        Permissions => {
            ro        => 1,
            move_into => 1,
            create    => 1,
            owner     => 1,
            priority  => 1,
            rw        => 1,
        },
    },
    {
        GroupIDs => [
            $GroupIDs[0], $GroupIDs[1], $GroupIDs[2],
        ],
        UserIDs => [
            $UserIDs[0], $UserIDs[1], $UserIDs[2],
        ],
        Permissions => {
            ro        => 0,
            move_into => 1,
            create    => 0,
            owner     => 0,
            priority  => 0,
            rw        => 0,
        },
    },
);

for my $PermissionTest (@UserGroupPermissionTests) {

    # add users to groups
    for my $UserID ( @{ $PermissionTest->{UserIDs} } ) {
        for my $GroupID ( @{ $PermissionTest->{GroupIDs} } ) {
            my $Success = $GroupObject->PermissionGroupUserAdd(
                GID        => $GroupID,
                UID        => $UserID,
                Permission => $PermissionTest->{Permissions},
                UserID     => 1,
            );

            $Self->True(
                $Success,
                "PermissionGroupUserAdd() - add permissions for group ID $GroupID and user ID $UserID"
            );
        }
    }

    # check if users are assigned to the groups (PermissionGroupUserGet)
    for my $GroupID (@GroupIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %UserList = $GroupObject->PermissionGroupUserGet(
                GroupID => $GroupID,
                Type    => $Permission,
            );

            for my $UserLogin ( sort keys %UserIDByUserLogin ) {
                my $UserID = $UserIDByUserLogin{$UserLogin};

                my $PermissionSet = $PermissionTest->{Permissions}->{$Permission};

                # If user or group is not part of test, permission is expected to be not set
                if (
                    !( grep /^$GroupID$/, @{ $PermissionTest->{GroupIDs} } )
                    || !( grep /^$UserID$/, @{ $PermissionTest->{UserIDs} } )
                    )
                {
                    $PermissionSet = 0;
                }

                my $PermissionMatch
                    = ( $PermissionSet && exists $UserList{$UserID} && $UserList{$UserID} eq $UserLogin )
                    || ( !$PermissionSet && !exists $UserList{$UserID} );

                $Self->True(
                    $PermissionMatch,
                    "PermissionGroupUserGet() - permission $Permission must be set to $PermissionSet for user ID $UserID and group ID $GroupID"
                );
            }
        }
    }

    # check if groups are assigned to the users (PermissionUserGroupGet)
    for my $UserID (@UserIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %GroupList = $GroupObject->PermissionUserGroupGet(
                UserID => $UserID,
                Type   => $Permission,
            );

            for my $GroupName ( sort keys %GroupIDByGroupName ) {
                my $GroupID = $GroupIDByGroupName{$GroupName};

                my $PermissionSet = $PermissionTest->{Permissions}->{$Permission};

                # If user or group is not part of test, permission is expected to be not set
                if (
                    !( grep /^$GroupID$/, @{ $PermissionTest->{GroupIDs} } )
                    || !( grep /^$UserID$/, @{ $PermissionTest->{UserIDs} } )
                    )
                {
                    $PermissionSet = 0;
                }

                my $PermissionMatch
                    = ( $PermissionSet && exists $GroupList{$GroupID} && $GroupList{$GroupID} eq $GroupName )
                    || ( !$PermissionSet && !exists $GroupList{$GroupID} );

                $Self->True(
                    $PermissionMatch,
                    "PermissionUserGroupGet() - permission $Permission must be set to $PermissionSet for user ID $UserID and group ID $GroupID"
                );
            }
        }

    }

    # check if users are assigned to the groups (PermissionGroupGet)
    for my $GroupID (@GroupIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %UserList = $GroupObject->PermissionGroupGet(
                GroupID => $GroupID,
                Type    => $Permission,
            );

            for my $UserLogin ( sort keys %UserIDByUserLogin ) {
                my $UserID = $UserIDByUserLogin{$UserLogin};

                my $PermissionSet = $PermissionTest->{Permissions}->{$Permission};

                # If user or group is not part of test, permission is expected to be not set
                if (
                    !( grep /^$GroupID$/, @{ $PermissionTest->{GroupIDs} } )
                    || !( grep /^$UserID$/, @{ $PermissionTest->{UserIDs} } )
                    )
                {
                    $PermissionSet = 0;
                }

                my $PermissionMatch
                    = ( $PermissionSet && exists $UserList{$UserID} && $UserList{$UserID} eq $UserLogin )
                    || ( !$PermissionSet && !exists $UserList{$UserID} );

                $Self->True(
                    $PermissionMatch,
                    "PermissionGroupGet() - permission $Permission must be set to $PermissionSet for user ID $UserID and group ID $GroupID"
                );
            }
        }
    }

    # check if groups are assigned to the users (PermissionUserGet)
    for my $UserID (@UserIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %GroupList = $GroupObject->PermissionUserGet(
                UserID => $UserID,
                Type   => $Permission,
            );

            for my $GroupName ( sort keys %GroupIDByGroupName ) {
                my $GroupID = $GroupIDByGroupName{$GroupName};

                my $PermissionSet = $PermissionTest->{Permissions}->{$Permission};

                # If user or group is not part of test, permission is expected to be not set
                if (
                    !( grep /^$GroupID$/, @{ $PermissionTest->{GroupIDs} } )
                    || !( grep /^$UserID$/, @{ $PermissionTest->{UserIDs} } )
                    )
                {
                    $PermissionSet = 0;
                }

                my $PermissionMatch
                    = ( $PermissionSet && exists $GroupList{$GroupID} && $GroupList{$GroupID} eq $GroupName )
                    || ( !$PermissionSet && !exists $GroupList{$GroupID} );

                $Self->True(
                    $PermissionMatch,
                    "PermissionUserGet() - permission $Permission must be set to $PermissionSet for user ID $UserID and group ID $GroupID"
                );
            }
        }
    }

    # check involved users (PermissionUserInvolvedGet)
    for my $UserID (@UserIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %Users = $GroupObject->PermissionUserInvolvedGet(
                UserID => $UserID,
                Type   => $Permission,
            );

            my $PermissionSet = $PermissionTest->{Permissions}->{$Permission};

            # If user is not part of test, permission is expected to be not set
            if ( !( grep /^$UserID$/, @{ $PermissionTest->{UserIDs} } ) ) {
                $PermissionSet = 0;
            }

            my $NumberOfUsers         = keys %Users;
            my $NumberOfExpectedUsers = $PermissionSet
                ? @{ $PermissionTest->{UserIDs} }
                : 0;

            my $UsersCorrect = 1;
            if ( $NumberOfUsers != $NumberOfExpectedUsers ) {
                $UsersCorrect = 0;
            }
            elsif ($NumberOfUsers) {

                # check if the user IDs match
                PERMISSIONTESTUSERID:
                for my $PermissionTestUserID ( @{ $PermissionTest->{UserIDs} } ) {
                    if ( !exists $Users{$PermissionTestUserID} ) {
                        $UsersCorrect = 0;
                        last PERMISSIONTESTUSERID;
                    }
                }
            }

            $Self->True(
                $UsersCorrect,
                "PermissionUserInvolvedGet() - involved users must be correct for permission $Permission and user ID $UserID"
            );
        }
    }

    # remove permissions for all test groups and test users
    my %PermissionsRemoved;
    for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {
        $PermissionsRemoved{$Permission} = 0;
    }

    for my $UserID ( @{ $PermissionTest->{UserIDs} } ) {
        for my $GroupID ( @{ $PermissionTest->{GroupIDs} } ) {
            my $Success = $GroupObject->PermissionGroupUserAdd(
                GID        => $GroupID,
                UID        => $UserID,
                Permission => \%PermissionsRemoved,
                UserID     => 1,
            );

            $Self->True(
                $Success,
                "PermissionGroupUserAdd() - remove permissions for group ID $GroupID and user ID $UserID"
            );
        }
    }

    # check that all test users have been removed from the groups (PermissionGroupUserGet)
    for my $GroupID (@GroupIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %UserList = $GroupObject->PermissionGroupUserGet(
                GroupID => $GroupID,
                Type    => $Permission,
            );

            for my $UserLogin ( sort keys %UserIDByUserLogin ) {
                my $UserID = $UserIDByUserLogin{$UserLogin};

                my $PermissionMatch = !exists $UserList{$UserID};

                $Self->True(
                    $PermissionMatch,
                    "PermissionGroupUserGet() - permission $Permission must not be set for user ID $UserID and group ID $GroupID"
                );
            }
        }
    }

    # check if groups have been removed from users (PermissionGroupGet)
    for my $GroupID (@GroupIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %UserList = $GroupObject->PermissionGroupGet(
                GroupID => $GroupID,
                Type    => $Permission,
            );

            for my $UserLogin ( sort keys %UserIDByUserLogin ) {
                my $UserID = $UserIDByUserLogin{$UserLogin};

                $Self->False(
                    exists $UserList{$UserID},
                    "PermissionGroupGet() - permission $Permission must be set to 0 for user ID $UserID and group ID $GroupID"
                );
            }
        }
    }

    # check if groups have been removed from users via roles (PermissionUserGet)
    for my $UserID (@UserIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %GroupList = $GroupObject->PermissionUserGet(
                UserID => $UserID,
                Type   => $Permission,
            );

            for my $GroupName ( sort keys %GroupIDByGroupName ) {
                my $GroupID = $GroupIDByGroupName{$GroupName};

                $Self->False(
                    exists $GroupList{$GroupID},
                    "PermissionUserGet() - permission $Permission must be set to 0 for user ID $UserID and group ID $GroupID"
                );
            }
        }
    }
}

#
# Permission tests (users and roles)
#
my @UserRolePermissionTests = (
    {
        RoleIDs => [
            $RoleIDs[0],
        ],
        UserIDs => [
            $UserIDs[1], $UserIDs[2],
        ],
    },
    {
        RoleIDs => [
            $RoleIDs[0], $RoleIDs[2],
        ],
        UserIDs => [
            $UserIDs[0],
        ],
    },
    {
        RoleIDs => [
            $RoleIDs[0], $RoleIDs[2],
        ],
        UserIDs => [
            $UserIDs[0],
        ],
    },
    {
        RoleIDs => [
            $RoleIDs[0], $RoleIDs[1], $RoleIDs[2],
        ],
        UserIDs => [
            $UserIDs[0], $UserIDs[1], $UserIDs[2],
        ],
    },
);

for my $PermissionTest (@UserRolePermissionTests) {

    # add users to roles
    for my $UserID ( @{ $PermissionTest->{UserIDs} } ) {
        for my $RoleID ( @{ $PermissionTest->{RoleIDs} } ) {
            my $Success = $GroupObject->PermissionRoleUserAdd(
                RID    => $RoleID,
                UID    => $UserID,
                Active => 1,
                UserID => 1,
            );

            $Self->True(
                $Success,
                "PermissionRoleUserAdd() - add permission for role ID $RoleID and user ID $UserID"
            );
        }
    }

    # check if users are assigned to the roles (PermissionRoleUserGet)
    for my $RoleID (@RoleIDs) {
        my %UserList = $GroupObject->PermissionRoleUserGet(
            RoleID => $RoleID,
        );

        for my $UserLogin ( sort keys %UserIDByUserLogin ) {
            my $UserID = $UserIDByUserLogin{$UserLogin};

            my $PermissionSet = 1;

            # If user or role is not part of test, permission is expected to be not set
            if (
                !( grep /^$RoleID$/, @{ $PermissionTest->{RoleIDs} } )
                || !( grep /^$UserID$/, @{ $PermissionTest->{UserIDs} } )
                )
            {
                $PermissionSet = 0;
            }

            my $PermissionMatch = ( $PermissionSet && exists $UserList{$UserID} && $UserList{$UserID} eq $UserLogin )
                || ( !$PermissionSet && !exists $UserList{$UserID} );

            $Self->True(
                $PermissionMatch,
                "PermissionRoleUserGet() - permission for role must be set to $PermissionSet for user ID $UserID and role ID $RoleID"
            );
        }
    }

    # check if roles are assigned to the users (PermissionUserRoleGet)
    for my $UserID (@UserIDs) {
        my %RoleList = $GroupObject->PermissionUserRoleGet(
            UserID => $UserID,
        );

        for my $RoleName ( sort keys %RoleIDByRoleName ) {
            my $RoleID = $RoleIDByRoleName{$RoleName};

            my $PermissionSet = 1;

            # If user or role is not part of test, permission is expected to be not set
            if (
                !( grep /^$RoleID$/, @{ $PermissionTest->{RoleIDs} } )
                || !( grep /^$UserID$/, @{ $PermissionTest->{UserIDs} } )
                )
            {
                $PermissionSet = 0;
            }

            my $PermissionMatch = ( $PermissionSet && exists $RoleList{$RoleID} && $RoleList{$RoleID} eq $RoleName )
                || ( !$PermissionSet && !exists $RoleList{$RoleID} );

            $Self->True(
                $PermissionMatch,
                "PermissionUserRoleGet() - permission for role must be set to $PermissionSet for user ID $UserID and role ID $RoleID"
            );
        }
    }

    # remove permissions for all test roles and test users
    for my $UserID ( @{ $PermissionTest->{UserIDs} } ) {
        for my $RoleID ( @{ $PermissionTest->{RoleIDs} } ) {
            my $Success = $GroupObject->PermissionRoleUserAdd(
                RID    => $RoleID,
                UID    => $UserID,
                Active => 0,
                UserID => 1,
            );

            $Self->True(
                $Success,
                "PermissionRoleUserAdd() - remove permissions for role ID $RoleID and user ID $UserID"
            );
        }
    }

    # check that all test users have been removed from the roles (PermissionRoleUserGet)
    for my $RoleID (@RoleIDs) {
        my %UserList = $GroupObject->PermissionRoleUserGet(
            RoleID => $RoleID,
        );

        for my $UserLogin ( sort keys %UserIDByUserLogin ) {
            my $UserID = $UserIDByUserLogin{$UserLogin};

            my $PermissionMatch = !exists $UserList{$UserID};

            $Self->True(
                $PermissionMatch,
                "PermissionRoleUserGet() - permission for role must not be set for user ID $UserID and role ID $RoleID"
            );
        }
    }
}

#
# Permission tests (users and roles via groups)
#
my @UserRoleGroupPermissionTests = (
    {
        RoleIDs => [
            $RoleIDs[0], $RoleIDs[1],
        ],
        UserIDs => [
            $UserIDs[0], $UserIDs[1],
        ],
        GroupIDs => [
            $GroupIDs[1], $GroupIDs[2],
        ],
        Permissions => {
            ro        => 1,
            move_into => 1,
            create    => 1,
            owner     => 1,
            priority  => 0,
            rw        => 0,
        },
    },
    {
        RoleIDs => [
            $RoleIDs[1],
        ],
        UserIDs => [
            $UserIDs[2],
        ],
        GroupIDs => [
            $GroupIDs[2],
        ],
        Permissions => {
            ro        => 0,
            move_into => 1,
            create    => 0,
            owner     => 1,
            priority  => 0,
            rw        => 0,
        },
    },
    {
        RoleIDs => [
            $RoleIDs[0], $RoleIDs[2],
        ],
        UserIDs => [
            $UserIDs[0],
        ],
        GroupIDs => [
            $GroupIDs[0], $GroupIDs[2],
        ],
        Permissions => {
            ro        => 1,
            move_into => 1,
            create    => 1,
            owner     => 1,
            priority  => 1,
            rw        => 1,
        },
    },
    {
        RoleIDs => [
            $RoleIDs[0], $RoleIDs[1], $RoleIDs[2],
        ],
        UserIDs => [
            $UserIDs[0], $UserIDs[1], $UserIDs[2],
        ],
        GroupIDs => [
            $GroupIDs[0], $GroupIDs[1], $GroupIDs[2],
        ],
        Permissions => {
            ro        => 0,
            move_into => 1,
            create    => 0,
            owner     => 0,
            priority  => 0,
            rw        => 0,
        },
    },
);

for my $PermissionTest (@UserRoleGroupPermissionTests) {

    # add roles to groups
    for my $RoleID ( @{ $PermissionTest->{RoleIDs} } ) {
        for my $GroupID ( @{ $PermissionTest->{GroupIDs} } ) {
            my $Success = $GroupObject->PermissionGroupRoleAdd(
                GID        => $GroupID,
                RID        => $RoleID,
                Permission => $PermissionTest->{Permissions},
                UserID     => 1,
            );

            $Self->True(
                $Success,
                "PermissionGroupRoleAdd() - add permissions for group ID $GroupID and role ID $RoleID"
            );
        }
    }

    # check if roles are assigned to the groups (PermissionGroupRoleGet)
    for my $GroupID (@GroupIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %RoleList = $GroupObject->PermissionGroupRoleGet(
                GroupID => $GroupID,
                Type    => $Permission,
            );

            for my $RoleName ( sort keys %RoleIDByRoleName ) {
                my $RoleID = $RoleIDByRoleName{$RoleName};

                my $PermissionSet = $PermissionTest->{Permissions}->{$Permission};

                # If role or group is not part of test, permission is expected to be not set
                if (
                    !( grep /^$GroupID$/, @{ $PermissionTest->{GroupIDs} } )
                    || !( grep /^$RoleID$/, @{ $PermissionTest->{RoleIDs} } )
                    )
                {
                    $PermissionSet = 0;
                }

                my $PermissionMatch = ( $PermissionSet && exists $RoleList{$RoleID} && $RoleList{$RoleID} eq $RoleName )
                    || ( !$PermissionSet && !exists $RoleList{$RoleID} );

                $Self->True(
                    $PermissionMatch,
                    "PermissionGroupRoleGet() - permission $Permission must be set to $PermissionSet for role ID $RoleID and group ID $GroupID"
                );
            }
        }
    }

    # check if groups are assigned to the roles (PermissionRoleGroupGet)
    for my $RoleID (@RoleIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %GroupList = $GroupObject->PermissionRoleGroupGet(
                RoleID => $RoleID,
                Type   => $Permission,
            );

            for my $GroupName ( sort keys %GroupIDByGroupName ) {
                my $GroupID = $GroupIDByGroupName{$GroupName};

                my $PermissionSet = $PermissionTest->{Permissions}->{$Permission};

                # If role or group is not part of test, permission is expected to be not set
                if (
                    !( grep /^$GroupID$/, @{ $PermissionTest->{GroupIDs} } )
                    || !( grep /^$RoleID$/, @{ $PermissionTest->{RoleIDs} } )
                    )
                {
                    $PermissionSet = 0;
                }

                my $PermissionMatch
                    = ( $PermissionSet && exists $GroupList{$GroupID} && $GroupList{$GroupID} eq $GroupName )
                    || ( !$PermissionSet && !exists $GroupList{$GroupID} );

                $Self->True(
                    $PermissionMatch,
                    "PermissionRoleGroupGet() - permission $Permission must be set to $PermissionSet for role ID $RoleID and group ID $GroupID"
                );
            }
        }
    }

    # add users to roles
    for my $UserID ( @{ $PermissionTest->{UserIDs} } ) {
        for my $RoleID ( @{ $PermissionTest->{RoleIDs} } ) {
            my $Success = $GroupObject->PermissionRoleUserAdd(
                RID    => $RoleID,
                UID    => $UserID,
                Active => 1,
                UserID => 1,
            );

            $Self->True(
                $Success,
                "PermissionRoleUserAdd() - add permission for role ID $RoleID and user ID $UserID"
            );
        }
    }

    # check if groups are assigned to users via roles (PermissionGroupGet)
    for my $GroupID (@GroupIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %UserList = $GroupObject->PermissionGroupGet(
                GroupID => $GroupID,
                Type    => $Permission,
            );

            for my $UserLogin ( sort keys %UserIDByUserLogin ) {
                my $UserID = $UserIDByUserLogin{$UserLogin};

                my $PermissionSet = $PermissionTest->{Permissions}->{$Permission};

                # If user or group is not part of test, permission is expected to be not set
                if (
                    !( grep /^$GroupID$/, @{ $PermissionTest->{GroupIDs} } )
                    || !( grep /^$UserID$/, @{ $PermissionTest->{UserIDs} } )
                    )
                {
                    $PermissionSet = 0;
                }

                my $PermissionMatch
                    = ( $PermissionSet && exists $UserList{$UserID} && $UserList{$UserID} eq $UserLogin )
                    || ( !$PermissionSet && !exists $UserList{$UserID} );

                $Self->True(
                    $PermissionMatch,
                    "PermissionGroupGet() - permission $Permission must be set to $PermissionSet for user ID $UserID and group ID $GroupID"
                );
            }
        }
    }

    # check if groups are assigned to users via roles (PermissionUserGet)
    for my $UserID (@UserIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %GroupList = $GroupObject->PermissionUserGet(
                UserID => $UserID,
                Type   => $Permission,
            );

            for my $GroupName ( sort keys %GroupIDByGroupName ) {
                my $GroupID = $GroupIDByGroupName{$GroupName};

                my $PermissionSet = $PermissionTest->{Permissions}->{$Permission};

                # If user or group is not part of test, permission is expected to be not set
                if (
                    !( grep /^$GroupID$/, @{ $PermissionTest->{GroupIDs} } )
                    || !( grep /^$UserID$/, @{ $PermissionTest->{UserIDs} } )
                    )
                {
                    $PermissionSet = 0;
                }

                my $PermissionMatch
                    = ( $PermissionSet && exists $GroupList{$GroupID} && $GroupList{$GroupID} eq $GroupName )
                    || ( !$PermissionSet && !exists $GroupList{$GroupID} );

                $Self->True(
                    $PermissionMatch,
                    "PermissionUserGet() - permission $Permission must be set to $PermissionSet for user ID $UserID and group ID $GroupID"
                );
            }
        }
    }

    # remove roles from users
    for my $UserID ( @{ $PermissionTest->{UserIDs} } ) {
        for my $RoleID ( @{ $PermissionTest->{RoleIDs} } ) {
            my $Success = $GroupObject->PermissionRoleUserAdd(
                RID    => $RoleID,
                UID    => $UserID,
                Active => 0,
                UserID => 1,
            );

            $Self->True(
                $Success,
                "PermissionRoleUserAdd() - remove permissions for role ID $RoleID and user ID $UserID"
            );
        }
    }

    # check if groups have been removed from users via roles (PermissionGroupGet)
    for my $GroupID (@GroupIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %UserList = $GroupObject->PermissionGroupGet(
                GroupID => $GroupID,
                Type    => $Permission,
            );

            for my $UserLogin ( sort keys %UserIDByUserLogin ) {
                my $UserID = $UserIDByUserLogin{$UserLogin};

                $Self->False(
                    exists $UserList{$UserID},
                    "PermissionGroupGet() - permission $Permission must be set to 0 for user ID $UserID and group ID $GroupID"
                );
            }
        }
    }

    # check if groups have been removed from users via roles (PermissionUserGet)
    for my $UserID (@UserIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %GroupList = $GroupObject->PermissionUserGet(
                UserID => $UserID,
                Type   => $Permission,
            );

            for my $GroupName ( sort keys %GroupIDByGroupName ) {
                my $GroupID = $GroupIDByGroupName{$GroupName};

                $Self->False(
                    exists $GroupList{$GroupID},
                    "PermissionUserGet() - permission $Permission must be set to 0 for user ID $UserID and group ID $GroupID"
                );
            }
        }
    }

    # remove permissions for all test groups and test roles
    my %PermissionsRemoved;
    for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {
        $PermissionsRemoved{$Permission} = 0;
    }

    for my $RoleID ( @{ $PermissionTest->{RoleIDs} } ) {
        for my $GroupID ( @{ $PermissionTest->{GroupIDs} } ) {
            my $Success = $GroupObject->PermissionGroupRoleAdd(
                GID        => $GroupID,
                RID        => $RoleID,
                Permission => \%PermissionsRemoved,
                UserID     => 1,
            );

            $Self->True(
                $Success,
                "PermissionGroupRoleAdd() - remove permissions for group ID $GroupID and role ID $RoleID"
            );
        }
    }

    # check that all test roles have been removed from the groups (PermissionGroupRoleGet)
    for my $GroupID (@GroupIDs) {
        for my $Permission ( sort keys %{ $PermissionTest->{Permissions} } ) {

            my %RoleList = $GroupObject->PermissionGroupRoleGet(
                GroupID => $GroupID,
                Type    => $Permission,
            );

            for my $RoleName ( sort keys %RoleIDByRoleName ) {
                my $RoleID = $RoleIDByRoleName{$RoleName};

                my $PermissionMatch = !exists $RoleList{$RoleID};

                $Self->True(
                    $PermissionMatch,
                    "PermissionGroupRoleGet() - permission $Permission must not be set for role ID $RoleID and group ID $GroupID"
                );
            }
        }
    }
}

# set created roles to invalid
ROLENAME:
for my $RoleName ( sort keys %RoleIDByRoleName ) {
    next ROLENAME if !$RoleIDByRoleName{$RoleName};

    my $RoleUpdate = $GroupObject->RoleUpdate(
        ID      => $RoleIDByRoleName{$RoleName},
        Name    => $RoleName,
        ValidID => 2,
        UserID  => 1,
    );

    $Self->True(
        $RoleUpdate,
        'RoleUpdate() to set role ' . $RoleName . ' to invalid',
    );
}

# set created groups to invalid
GROUPNAME:
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    next GROUPNAME if !$GroupIDByGroupName{$GroupName};

    my $GroupUpdate = $GroupObject->GroupUpdate(
        ID      => $GroupIDByGroupName{$GroupName},
        Name    => $GroupName,
        ValidID => 2,
        UserID  => 1,
    );

    $Self->True(
        $GroupUpdate,
        'GroupUpdate() to set group ' . $GroupName . ' to invalid',
    );
}

1;
