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
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
my $TimeObject   = $Kernel::OM->Get('Kernel::System::Time');

#
# Group tests
#
my $GroupNameRandomPartBase = $TimeObject->SystemTime();
my %GroupIDByGroupName      = (
    'example-group-' . $GroupNameRandomPartBase . '-1' => undef,
    'example-group-' . $GroupNameRandomPartBase . '-2' => undef,
    'example-group-' . $GroupNameRandomPartBase . '-3' => undef,
);

# try to add groups
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupObject->GroupAdd(
        Name    => $GroupName,
        ValidID => 1,
        UserID  => 1,
    );

    $Self->True(
        $GroupID,
        'GroupAdd() for new group ' . $GroupName,
    );

    if ($GroupID) {
        $GroupIDByGroupName{$GroupName} = $GroupID;
    }
}

# try to add already added groups
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupObject->GroupAdd(
        Name    => $GroupName,
        ValidID => 1,
        UserID  => 1,
    );

    $Self->False(
        $GroupID,
        'GroupAdd() for already existing group ' . $GroupName,
    );
}

# try to fetch data of existing groups
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupIDByGroupName{$GroupName};
    my %Group = $GroupObject->GroupGet( ID => $GroupID );

    $Self->Is(
        $Group{Name},
        $GroupName,
        'GroupGet() for group ' . $GroupName,
    );
}

# look up existing groups
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupIDByGroupName{$GroupName};

    my $FetchedGroupID = $GroupObject->GroupLookup( Group => $GroupName );
    $Self->Is(
        $FetchedGroupID,
        $GroupID,
        'GroupLookup() for group name ' . $GroupName,
    );

    my $FetchedGroupName = $GroupObject->GroupLookup( GroupID => $GroupID );
    $Self->Is(
        $FetchedGroupName,
        $GroupName,
        'GroupLookup() for group ID ' . $GroupID,
    );
}

# list groups
my %Groups = $GroupObject->GroupList();
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupIDByGroupName{$GroupName};

    $Self->True(
        exists $Groups{$GroupID} && $Groups{$GroupID} eq $GroupName,
        'GroupList() contains group ' . $GroupName . ' with ID ' . $GroupID,
    );
}

# group data list
my %GroupDataList = $GroupObject->GroupDataList();
for my $GroupName ( sort keys %GroupIDByGroupName ) {
    my $GroupID = $GroupIDByGroupName{$GroupName};

    $Self->True(
        exists $GroupDataList{$GroupID} && $GroupDataList{$GroupID}->{Name} eq $GroupName,
        'GroupDataList() contains group ' . $GroupName . ' with ID ' . $GroupID,
    );
}

# change name of a single group
my $GroupNameToChange = 'example-group-' . $GroupNameRandomPartBase . '-1';
my $ChangedGroupName  = $GroupNameToChange . '-changed';
my $GroupIDToChange   = $GroupIDByGroupName{$GroupNameToChange};

my $GroupUpdateResult = $GroupObject->GroupUpdate(
    ID      => $GroupIDToChange,
    Name    => $ChangedGroupName,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupUpdateResult,
    'GroupUpdate() for changing name of group ' . $GroupNameToChange . ' to ' . $ChangedGroupName,
);

$GroupIDByGroupName{$ChangedGroupName} = $GroupIDToChange;
delete $GroupIDByGroupName{$GroupNameToChange};

# try to add group with previous name
my $GroupID = $GroupObject->GroupAdd(
    Name    => $GroupNameToChange,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID,
    'GroupAdd() for new group ' . $GroupNameToChange,
);

if ($GroupID) {
    $GroupIDByGroupName{$GroupNameToChange} = $GroupID;
}

# try to add group with changed name
$GroupID = $GroupObject->GroupAdd(
    Name    => $ChangedGroupName,
    ValidID => 1,
    UserID  => 1,
);

$Self->False(
    $GroupID,
    'GroupAdd() for new group ' . $ChangedGroupName,
);

#
# Permission tests
#

# create test users
my %UserIDByUserLogin;
for my $UserCount ( 0 .. 2 ) {
    my $UserLogin = $HelperObject->TestUserCreate();
    my $UserID = $UserObject->UserLookup( UserLogin => $UserLogin );

    $UserIDByUserLogin{$UserLogin} = $UserID;
}

my @UserIDs  = values %UserIDByUserLogin;
my @GroupIDs = values %GroupIDByGroupName;

my @PermissionTests = (
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

for my $PermissionTest (@PermissionTests) {

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
