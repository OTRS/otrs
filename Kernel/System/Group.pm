# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Group;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::User',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::Group - group and roles lib

=head1 SYNOPSIS

All group and roles functions. E. g. to add groups or to get a member list of a group.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item GroupLookup()

get id or name for group

    my $Group = $GroupObject->GroupLookup(
        GroupID => $GroupID,
    );

    my $GroupID = $GroupObject->GroupLookup(
        Group => $Group,
    );

=cut

sub GroupLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Group} && !$Param{GroupID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Group or GroupID!',
        );
        return;
    }

    # get group list
    my %GroupList = $Self->GroupList(
        Valid => 0,
    );

    return $GroupList{ $Param{GroupID} } if $Param{GroupID};

    # create reverse list
    my %GroupListReverse = reverse %GroupList;

    return $GroupListReverse{ $Param{Group} };
}

=item GroupAdd()

to add a group

    my $ID = $GroupObject->GroupAdd(
        Name    => 'example-group',
        Comment => 'comment describing the group',   # optional
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub GroupAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # insert new group
    return if !$DBObject->Do(
        SQL => 'INSERT INTO groups (name, comments, valid_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get new group id
    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM groups WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );

    my $GroupID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $GroupID = $Row[0];
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # delete caches
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'GroupDataList',
    );
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'GroupList::0',
    );
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'GroupList::1',
    );
    $CacheObject->CleanUp(
        Type => 'CustomerGroup',
    );

    return $GroupID;
}

=item GroupGet()

returns a hash with group data

    my %GroupData = $GroupObject->GroupGet(
        ID => 2,
    );

This returns something like:

    %GroupData = (
        'Name'       => 'admin',
        'ID'         => 2,
        'ValidID'    => '1',
        'CreateTime' => '2010-04-07 15:41:15',
        'ChangeTime' => '2010-04-07 15:41:15',
        'Comment'    => 'Group of all administrators.',
    );

=cut

sub GroupGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID!',
        );
        return;
    }

    # get group list
    my %GroupList = $Self->GroupDataList(
        Valid => 0,
    );

    # extract group data
    my %Group;
    if ( $GroupList{ $Param{ID} } && ref $GroupList{ $Param{ID} } eq 'HASH' ) {
        %Group = %{ $GroupList{ $Param{ID} } };
    }

    return %Group;
}

=item GroupUpdate()

update of a group

    my $Success = $GroupObject->GroupUpdate(
        ID      => 123,
        Name    => 'example-group',
        Comment => 'comment describing the group',   # optional
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub GroupUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # set default value
    $Param{Comment} ||= '';

    # get current group data
    my %GroupData = $Self->GroupGet(
        ID => $Param{ID},
    );

    # check if update is required
    my $ChangeRequired;
    KEY:
    for my $Key (qw(Name Comment ValidID)) {

        next KEY if defined $GroupData{$Key} && $GroupData{$Key} eq $Param{$Key};

        $ChangeRequired = 1;

        last KEY;
    }

    return 1 if !$ChangeRequired;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # update group in database
    return if !$DBObject->Do(
        SQL => 'UPDATE groups SET name = ?, comments = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # delete caches
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'GroupDataList',
    );
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'GroupList::0',
    );
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'GroupList::1',
    );
    $CacheObject->CleanUp(
        Type => 'CustomerGroup',
    );

    return 1 if $GroupData{ValidID} eq $Param{ValidID};

    $CacheObject->CleanUp(
        Type => 'GroupPermissionUserGet',
    );
    $CacheObject->CleanUp(
        Type => 'GroupPermissionGroupGet',
    );

    return 1;
}

=item GroupList()

returns a hash of all groups

    my %Groups = $GroupObject->GroupList(
        Valid => 1,   # (optional) default 0
    );

the result looks like

    %Groups = (
        '1' => 'users',
        '2' => 'admin',
        '3' => 'stats',
        '4' => 'secret',
    );

=cut

sub GroupList {
    my ( $Self, %Param ) = @_;

    # set default value
    my $Valid = $Param{Valid} ? 1 : 0;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # create cache key
    my $CacheKey = 'GroupList::' . $Valid;

    # read cache
    my $Cache = $CacheObject->Get(
        Type => 'Group',
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # get valid ids
    my @ValidIDs = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();

    # get group data list
    my %GroupDataList = $Self->GroupDataList();

    my %GroupListValid;
    my %GroupListAll;
    KEY:
    for my $Key ( sort keys %GroupDataList ) {

        next KEY if !$Key;

        # add group to the list of all groups
        $GroupListAll{$Key} = $GroupDataList{$Key}->{Name};

        my $Match;
        VALIDID:
        for my $ValidID (@ValidIDs) {

            next VALIDID if $ValidID ne $GroupDataList{$Key}->{ValidID};

            $Match = 1;

            last VALIDID;
        }

        next KEY if !$Match;

        # add group to the list of valid groups
        $GroupListValid{$Key} = $GroupDataList{$Key}->{Name};
    }

    # set cache
    $CacheObject->Set(
        Type  => 'Group',
        Key   => 'GroupList::0',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%GroupListAll,
    );
    $CacheObject->Set(
        Type  => 'Group',
        Key   => 'GroupList::1',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%GroupListValid,
    );

    return %GroupListValid if $Valid;
    return %GroupListAll;
}

=item GroupDataList()

returns a hash of all group data

    my %GroupDataList = $GroupObject->GroupDataList();

the result looks like

    %GroupDataList = (
        1 => {
            ID         => 1,
            Name       => 'Group 1',
            Comment    => 'The Comment of Group 1',
            ValidID    => 1,
            CreateTime => '2014-01-01 00:20:00',
            CreateBy   => 1,
            ChangeTime => '2014-01-02 00:10:00',
            ChangeBy   => 1,
        },
        2 => {
            ID         => 2,
            Name       => 'Group 2',
            Comment    => 'The Comment of Group 2',
            ValidID    => 1,
            CreateTime => '2014-11-01 10:00:00',
            CreateBy   => 1,
            ChangeTime => '2014-11-02 01:00:00',
            ChangeBy   => 1,
        },
    );

=cut

sub GroupDataList {
    my ( $Self, %Param ) = @_;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # read cache
    my $Cache = $CacheObject->Get(
        Type => 'Group',
        Key  => 'GroupDataList',
    );
    return %{$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all group data from database
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name, comments, valid_id, create_time, create_by, change_time, change_by FROM groups',
    );

    # fetch the result
    my %GroupDataList;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        $GroupDataList{ $Row[0] } = {
            ID         => $Row[0],
            Name       => $Row[1],
            Comment    => $Row[2] || '',
            ValidID    => $Row[3],
            CreateTime => $Row[4],
            CreateBy   => $Row[5],
            ChangeTime => $Row[6],
            ChangeBy   => $Row[7],
        };
    }

    # set cache
    $CacheObject->Set(
        Type  => 'Group',
        Key   => 'GroupDataList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%GroupDataList,
    );

    return %GroupDataList;
}

=item RoleLookup()

get id or name for role

    my $Role = $RoleObject->RoleLookup(
        RoleID => $RoleID,
    );

    my $RoleID = $RoleObject->RoleLookup(
        Role => $Role,
    );

=cut

sub RoleLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Role} && !$Param{RoleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no Role or RoleID!',
        );
        return;
    }

    # get role list
    my %RoleList = $Self->RoleList(
        Valid => 0,
    );

    return $RoleList{ $Param{RoleID} } if $Param{RoleID};

    # create reverse list
    my %RoleListReverse = reverse %RoleList;

    return $RoleListReverse{ $Param{Role} };
}

=item RoleGet()

returns a hash with role data

    my %RoleData = $GroupObject->RoleGet(
        ID => 2,
    );

This returns something like:

    %RoleData = (
        'Name'       => 'role_helpdesk_agent',
        'ID'         => 2,
        'ValidID'    => '1',
        'CreateTime' => '2010-04-07 15:41:15',
        'ChangeTime' => '2010-04-07 15:41:15',
        'Comment'    => 'Role for help-desk people.',
    );

=cut

sub RoleGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID!'
        );
        return;
    }

    # get role list
    my %RoleList = $Self->RoleDataList(
        Valid => 0,
    );

    # extract role data
    my %Role;
    if ( $RoleList{ $Param{ID} } && ref $RoleList{ $Param{ID} } eq 'HASH' ) {
        %Role = %{ $RoleList{ $Param{ID} } };
    }

    return %Role;
}

=item RoleAdd()

to add a new role

    my $RoleID = $GroupObject->RoleAdd(
        Name    => 'example-role',
        Comment => 'comment describing the role',   # optional
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub RoleAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # insert
    return if !$DBObject->Do(
        SQL => 'INSERT INTO roles (name, comments, valid_id, '
            . 'create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID}
        ],
    );

    # get new group id
    my $RoleID;
    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM roles WHERE name = ?',
        Bind => [ \$Param{Name}, ],
    );

    # fetch the result
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $RoleID = $Row[0];
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # delete caches
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'RoleDataList',
    );
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'RoleList::0',
    );
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'RoleList::1',
    );

    return $RoleID;
}

=item RoleUpdate()

update of a role

    my $Success = $GroupObject->RoleUpdate(
        ID      => 123,
        Name    => 'example-group',
        Comment => 'comment describing the role',   # optional
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub RoleUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # set default value
    $Param{Comment} ||= '';

    # get current role data
    my %RoleData = $Self->RoleGet(
        ID => $Param{ID},
    );

    # check if update is required
    my $ChangeRequired;
    KEY:
    for my $Key (qw(Name Comment ValidID)) {

        next KEY if defined $RoleData{$Key} && $RoleData{$Key} eq $Param{$Key};

        $ChangeRequired = 1;

        last KEY;
    }

    return 1 if !$ChangeRequired;

    # update role in database
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'UPDATE roles SET name = ?, comments = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID}
        ],
    );

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # delete caches
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'RoleDataList',
    );
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'RoleList::0',
    );
    $CacheObject->Delete(
        Type => 'Group',
        Key  => 'RoleList::1',
    );

    return 1 if $RoleData{ValidID} eq $Param{ValidID};

    $CacheObject->CleanUp(
        Type => 'GroupPermissionUserGet',
    );
    $CacheObject->CleanUp(
        Type => 'GroupPermissionGroupGet',
    );

    return 1;
}

=item RoleList()

returns a hash of all roles

    my %Roles = $GroupObject->RoleList(
        Valid => 1,
    );

the result looks like

    %Roles = (
        '1' => 'role_helpdesk_agent',
        '2' => 'role_systemsmanagement_agent',
        '3' => 'role_otrs_admin',
        '4' => 'role_faq_manager',
    );

=cut

sub RoleList {
    my ( $Self, %Param ) = @_;

    # set default value
    my $Valid = $Param{Valid} ? 1 : 0;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # create cache key
    my $CacheKey = 'RoleList::' . $Valid;

    # read cache
    my $Cache = $CacheObject->Get(
        Type => 'Group',
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # get valid ids
    my @ValidIDs = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();

    # get role data list
    my %RoleDataList = $Self->RoleDataList();

    my %RoleListValid;
    my %RoleListAll;
    KEY:
    for my $Key ( sort keys %RoleDataList ) {

        next KEY if !$Key;

        # add role to the list of all roles
        $RoleListAll{$Key} = $RoleDataList{$Key}->{Name};

        my $Match;
        VALIDID:
        for my $ValidID (@ValidIDs) {

            next VALIDID if $ValidID ne $RoleDataList{$Key}->{ValidID};

            $Match = 1;

            last VALIDID;
        }

        next KEY if !$Match;

        # add role to the list of valid roles
        $RoleListValid{$Key} = $RoleDataList{$Key}->{Name};
    }

    # set cache
    $CacheObject->Set(
        Type  => 'Group',
        Key   => 'RoleList::0',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%RoleListAll,
    );
    $CacheObject->Set(
        Type  => 'Group',
        Key   => 'RoleList::1',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%RoleListValid,
    );

    return %RoleListValid if $Valid;
    return %RoleListAll;
}

=item RoleDataList()

returns a hash of all role data

    my %RoleDataList = $GroupObject->RoleDataList();

the result looks like

    %RoleDataList = (
        1 => {
            ID         => 1,
            Name       => 'Role 1',
            Comment    => 'The Comment of Role 1',
            ValidID    => 1,
            CreateTime => '2014-01-01 00:20:00',
            CreateBy   => 1,
            ChangeTime => '2014-01-02 00:10:00',
            ChangeBy   => 1,
        },
        2 => {
            ID         => 2,
            Name       => 'Role 2',
            Comment    => 'The Comment of Role 2',
            ValidID    => 1,
            CreateTime => '2014-11-01 10:00:00',
            CreateBy   => 1,
            ChangeTime => '2014-11-02 01:00:00',
            ChangeBy   => 1,
        },
    );

=cut

sub RoleDataList {
    my ( $Self, %Param ) = @_;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # read cache
    my $Cache = $CacheObject->Get(
        Type => 'Group',
        Key  => 'RoleDataList',
    );
    return %{$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all roles data from database
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name, comments, valid_id, create_time, create_by, change_time, change_by FROM roles',
    );

    # fetch the result
    my %RoleDataList;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        $RoleDataList{ $Row[0] } = {
            ID         => $Row[0],
            Name       => $Row[1],
            Comment    => $Row[2] || '',
            ValidID    => $Row[3],
            CreateTime => $Row[4],
            CreateBy   => $Row[5],
            ChangeTime => $Row[6],
            ChangeBy   => $Row[7],
        };
    }

    # set cache
    $CacheObject->Set(
        Type  => 'Group',
        Key   => 'RoleDataList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%RoleDataList,
    );

    return %RoleDataList;
}

=item PermissionUserInvolvedGet()

returns a list of users with the given permissions

    my %Users = $GroupObject->PermissionUserInvolvedGet(
        UserID => $ID,
        Type   => 'move_into',
    );

=cut

sub PermissionUserInvolvedGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get all groups of the given user
    my %Groups = $Self->PermissionUserGet(
        UserID => $Param{UserID},
        Type   => $Param{Type},
    );

    my %Users;
    for my $GroupID ( sort keys %Groups ) {

        # get all users of this group
        my %UsersOne = $Self->PermissionGroupGet(
            GroupID => $GroupID,
            Type    => $Param{Type},
        );

        %Users = ( %Users, %UsersOne );
    }

    return %Users;
}

=item PermissionUserGet()

Get groups of the given user.

    my %Groups = $GroupObject->PermissionUserGet(
        UserID => $ID,
        Type   => 'move_into',
    );

=cut

sub PermissionUserGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheKey = 'PermissionUserGet::' . $Param{UserID} . '::' . $Param{Type};

    # read cache
    my $Cache = $CacheObject->Get(
        Type => 'GroupPermissionUserGet',
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # get groups a user is member of
    my %GroupList = $Self->PermissionUserGroupGet(
        UserID => $Param{UserID},
        Type   => $Param{Type},
    );

    # get roles a user is member of
    my %RoleList = $Self->PermissionUserRoleGet(
        UserID => $Param{UserID},
    );

    return %GroupList if !%RoleList;

    ROLEID:
    for my $RoleID ( sort keys %RoleList ) {

        next ROLEID if !$RoleID;

        # get groups of the role
        my %RoleGroupList = $Self->PermissionRoleGroupGet(
            RoleID => $RoleID,
            Type   => $Param{Type},
        );

        %GroupList = ( %GroupList, %RoleGroupList );
    }

    # set cache
    $CacheObject->Set(
        Type  => 'GroupPermissionUserGet',
        Key   => $CacheKey,
        TTL   => 60 * 60 * 24 * 20,
        Value => \%GroupList,
    );

    return %GroupList;
}

=item PermissionGroupGet()

Get users of the given group.

    my %Users = $GroupObject->PermissionGroupGet(
        GroupID => $ID,
        Type    => 'move_into',
    );

=cut

sub PermissionGroupGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(GroupID Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheKey = 'PermissionGroupGet::' . $Param{GroupID} . '::' . $Param{Type};

    # read cache
    my $Cache = $CacheObject->Get(
        Type => 'GroupPermissionGroupGet',
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # get users of a given group
    my %UserList = $Self->PermissionGroupUserGet(
        GroupID => $Param{GroupID},
        Type    => $Param{Type},
    );

    # get roles of the given group
    my %RoleList = $Self->PermissionGroupRoleGet(
        GroupID => $Param{GroupID},
        Type    => $Param{Type},
    );

    return %UserList if !%RoleList;

    ROLEID:
    for my $RoleID ( sort keys %RoleList ) {

        next ROLEID if !$RoleID;

        # get users of the role
        my %RoleUserList = $Self->PermissionRoleUserGet(
            RoleID => $RoleID,
        );

        %UserList = ( %UserList, %RoleUserList );
    }

    # set cache
    $CacheObject->Set(
        Type  => 'GroupPermissionGroupGet',
        Key   => $CacheKey,
        TTL   => 60 * 60 * 24 * 20,
        Value => \%UserList,
    );

    return %UserList;
}

=item PermissionGroupUserAdd()

add new permissions or update existing one to the given group of a given user

    my $Success = $GroupObject->PermissionGroupUserAdd(
        GID => 12,
        UID => 6,
        Permission => {
            ro        => 1,
            move_into => 1,
            create    => 1,
            owner     => 1,
            priority  => 0,
            rw        => 0,
        },
        UserID => 123,
    );

=cut

sub PermissionGroupUserAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UID GID UserID Permission)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }
    if ( ref $Param{Permission} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Permission needs to be a hash reference!",
        );
        return;
    }

    # get group user data
    my %DBGroupUser = $Self->_DBGroupUserGet(
        Type => 'UserGroupPerm',
    );

    # extract data from given user id and group id
    my @CurrentPermissions;
    if (
        $DBGroupUser{ $Param{UID} }
        && ref $DBGroupUser{ $Param{UID} } eq 'HASH'
        && $DBGroupUser{ $Param{UID} }->{ $Param{GID} }
        && ref $DBGroupUser{ $Param{UID} }->{ $Param{GID} } eq 'ARRAY'
        )
    {
        @CurrentPermissions = @{ $DBGroupUser{ $Param{UID} }->{ $Param{GID} } };
    }

    # check rw rule (set only rw and remove the rest, because all other are included in rw)
    my @NewPermissions;
    if ( $Param{Permission}->{rw} ) {
        @NewPermissions = ('rw');
    }
    else {

        # get permission type list
        my %PermissionTypeList = $Self->_PermissionTypeList();

        # create new permission array
        TYPE:
        for my $Type ( sort keys %{ $Param{Permission} } ) {

            next TYPE if !$Type;
            next TYPE if !$PermissionTypeList{$Type};
            next TYPE if !$Param{Permission}->{$Type};

            push @NewPermissions, $Type;
        }
    }

    # generate strings to compare the both arrays
    my $CurrentPermissionString = join '-', sort @CurrentPermissions;
    my $NewPermissionString     = join '-', sort @NewPermissions;

    return 1 if $CurrentPermissionString eq $NewPermissionString;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete existing permissions from database
    $DBObject->Do(
        SQL  => 'DELETE FROM group_user WHERE user_id = ? AND group_id = ?',
        Bind => [ \$Param{UID}, \$Param{GID} ],
    );

    # insert new permissions
    TYPE:
    for my $Type (@NewPermissions) {

        my $ValueNew = 1;

        # add to database
        $DBObject->Do(
            SQL => 'INSERT INTO group_user '
                . '(user_id, group_id, permission_key, permission_value, '
                . 'create_time, create_by, change_time, change_by) '
                . 'VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
            Bind => [
                \$Param{UID},
                \$Param{GID},
                \$Type,
                \$ValueNew,
                \$Param{UserID},
                \$Param{UserID},
            ],
        );
    }

    # reset cache
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->CleanUp(
        Type => 'DBGroupUserGet',
    );

    $CacheObject->CleanUp(
        Type => 'GroupPermissionUserGet',
    );

    $CacheObject->CleanUp(
        Type => 'GroupPermissionGroupGet',
    );

    return 1;
}

=item PermissionGroupUserGet()

returns a list with all users of a group

    my %UserList = $GroupObject->PermissionGroupUserGet(
        GroupID => $GroupID,
        Type    => 'move_into',  # ro|move_into|priority|create|rw
    );

    %UserList = (
        1 => 'User1',
        2 => 'User2',
        3 => 'User3',
    );

=cut

sub PermissionGroupUserGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(GroupID Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get permission type list
    my %PermissionTypeList = $Self->_PermissionTypeList(
        Type => $Param{Type},
    );

    return if !%PermissionTypeList;

    # get valid group list
    my %GroupList = $Self->GroupList(
        Valid => 1,
    );

    return if !$GroupList{ $Param{GroupID} };

    # get group user data
    my %Permissions = $Self->_DBGroupUserGet(
        Type => 'GroupPermUser',
    );

    return if !$Permissions{ $Param{GroupID} };
    return if ref $Permissions{ $Param{GroupID} } ne 'HASH';

    # extract users
    my $UsersRaw   = $Permissions{ $Param{GroupID} }->{ $Param{Type} } || [];
    my $UsersRawRw = $Permissions{ $Param{GroupID} }->{rw}             || [];

    if ( ref $UsersRaw ne 'ARRAY' ) {
        $UsersRaw = [];
    }
    if ( ref $UsersRawRw ne 'ARRAY' ) {
        $UsersRawRw = [];
    }

    # get valid user list
    my %UserList = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type => 'Short',
    );

    # calculate users
    my %Users;
    USERID:
    for my $UserID ( @{$UsersRaw}, @{$UsersRawRw} ) {

        next USERID if !$UserID;
        next USERID if !$UserList{$UserID};

        $Users{$UserID} = $UserList{$UserID};
    }

    return %Users;
}

=item PermissionUserGroupGet()

returns a list of groups a user is member of

    my %GroupList = $GroupObject->PermissionUserGroupGet(
        UserID => 123,
        Type   => 'move_into',  # ro|move_into|priority|create|rw
    );

    %GroupList = (
        1 => 'Group1',
        2 => 'Group2',
        3 => 'Group3',
    );

=cut

sub PermissionUserGroupGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get permission type list
    my %PermissionTypeList = $Self->_PermissionTypeList(
        Type => $Param{Type},
    );

    return if !%PermissionTypeList;

    # get valid user list
    my %UserList = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type => 'Short',
    );

    return if !$UserList{ $Param{UserID} };

    # get group user data
    my %Permissions = $Self->_DBGroupUserGet(
        Type => 'UserPermGroup',
    );

    return if !$Permissions{ $Param{UserID} };
    return if ref $Permissions{ $Param{UserID} } ne 'HASH';

    # extract groups
    my $GroupsRaw   = $Permissions{ $Param{UserID} }->{ $Param{Type} } || [];
    my $GroupsRawRw = $Permissions{ $Param{UserID} }->{rw}             || [];

    if ( ref $GroupsRaw ne 'ARRAY' ) {
        $GroupsRaw = [];
    }
    if ( ref $GroupsRawRw ne 'ARRAY' ) {
        $GroupsRawRw = [];
    }

    # get valid group list
    my %GroupList = $Self->GroupList(
        Valid => 1,
    );

    # calculate groups
    my %Groups;
    GROUPID:
    for my $GroupID ( @{$GroupsRaw}, @{$GroupsRawRw} ) {

        next GROUPID if !$GroupID;
        next GROUPID if !$GroupList{$GroupID};

        $Groups{$GroupID} = $GroupList{$GroupID};
    }

    return %Groups;
}

=item PermissionGroupRoleAdd()

add new permissions or update existing one to the given group of a given role

    my $Success = $GroupObject->PermissionGroupRoleAdd(
        GID => 12,
        RID => 6,
        Permission => {
            ro        => 1,
            move_into => 1,
            create    => 1,
            owner     => 1,
            priority  => 0,
            rw        => 0,
        },
        UserID => 123,
    );

=cut

sub PermissionGroupRoleAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(RID GID UserID Permission)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }
    if ( ref $Param{Permission} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Permission needs to be a hash reference!",
        );
        return;
    }

    # get group role data
    my %DBGroupRole = $Self->_DBGroupRoleGet(
        Type => 'RoleGroupPerm',
    );

    # extract data from given user id and group id
    my @CurrentPermissions;
    if (
        $DBGroupRole{ $Param{RID} }
        && ref $DBGroupRole{ $Param{RID} } eq 'HASH'
        && $DBGroupRole{ $Param{RID} }->{ $Param{GID} }
        && ref $DBGroupRole{ $Param{RID} }->{ $Param{GID} } eq 'ARRAY'
        )
    {
        @CurrentPermissions = @{ $DBGroupRole{ $Param{RID} }->{ $Param{GID} } };
    }

    # check rw rule (set only rw and remove the rest, because all other are included in rw)
    my @NewPermissions;
    if ( $Param{Permission}->{rw} ) {
        @NewPermissions = ('rw');
    }
    else {

        # get permission type list
        my %PermissionTypeList = $Self->_PermissionTypeList();

        # create new permission array
        TYPE:
        for my $Type ( sort keys %{ $Param{Permission} } ) {

            next TYPE if !$Type;
            next TYPE if !$PermissionTypeList{$Type};
            next TYPE if !$Param{Permission}->{$Type};

            push @NewPermissions, $Type;
        }
    }

    # generate strings to compare the both arrays
    my $CurrentPermissionString = join '-', sort @CurrentPermissions;
    my $NewPermissionString     = join '-', sort @NewPermissions;

    return 1 if $CurrentPermissionString eq $NewPermissionString;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete existing permissions from database
    $DBObject->Do(
        SQL  => 'DELETE FROM group_role WHERE role_id = ? AND group_id = ?',
        Bind => [ \$Param{RID}, \$Param{GID} ],
    );

    # insert new permissions
    TYPE:
    for my $Type (@NewPermissions) {

        my $ValueNew = 1;

        # add to database
        $DBObject->Do(
            SQL => 'INSERT INTO group_role '
                . '(role_id, group_id, permission_key, permission_value, '
                . 'create_time, create_by, change_time, change_by) '
                . 'VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
            Bind => [
                \$Param{RID},
                \$Param{GID},
                \$Type,
                \$ValueNew,
                \$Param{UserID},
                \$Param{UserID},
            ],
        );
    }

    # reset cache
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->CleanUp(
        Type => 'DBGroupRoleGet',
    );

    $CacheObject->CleanUp(
        Type => 'GroupPermissionUserGet',
    );

    $CacheObject->CleanUp(
        Type => 'GroupPermissionGroupGet',
    );

    return 1;
}

=item PermissionGroupRoleGet()

returns a list with all roles of a group

    my %RoleList = $GroupObject->PermissionGroupRoleGet(
        GroupID => $GroupID,
        Type    => 'move_into',  # ro|move_into|priority|create|rw
    );

    %RoleList = (
        1 => 'Role1',
        2 => 'Role2',
        3 => 'Role3',
    );

=cut

sub PermissionGroupRoleGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(GroupID Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get permission type list
    my %PermissionTypeList = $Self->_PermissionTypeList(
        Type => $Param{Type},
    );

    return if !%PermissionTypeList;

    # get valid group list
    my %GroupList = $Self->GroupList(
        Valid => 1,
    );

    return if !$GroupList{ $Param{GroupID} };

    # get group role data
    my %Permissions = $Self->_DBGroupRoleGet(
        Type => 'GroupPermRole',
    );

    return if !$Permissions{ $Param{GroupID} };
    return if ref $Permissions{ $Param{GroupID} } ne 'HASH';

    # extract roles
    my $RolesRaw   = $Permissions{ $Param{GroupID} }->{ $Param{Type} } || [];
    my $RolesRawRw = $Permissions{ $Param{GroupID} }->{rw}             || [];

    if ( ref $RolesRaw ne 'ARRAY' ) {
        $RolesRaw = [];
    }
    if ( ref $RolesRawRw ne 'ARRAY' ) {
        $RolesRawRw = [];
    }

    # get valid role list
    my %RoleList = $Self->RoleList();

    # calculate roles
    my %Roles;
    ROLEID:
    for my $RoleID ( @{$RolesRaw}, @{$RolesRawRw} ) {

        next ROLEID if !$RoleID;
        next ROLEID if !$RoleList{$RoleID};

        $Roles{$RoleID} = $RoleList{$RoleID};
    }

    return %Roles;
}

=item PermissionRoleGroupGet()

returns a list with all groups of a role

    my %GroupList = $GroupObject->PermissionRoleGroupGet(
        RoleID => 12,
        Type   => 'move_into',  # ro|move_into|priority|create|rw
    );

    %GroupList = (
        1 => 'Group1',
        2 => 'Group2',
        3 => 'Group3',
    );

=cut

sub PermissionRoleGroupGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(RoleID Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get permission type list
    my %PermissionTypeList = $Self->_PermissionTypeList(
        Type => $Param{Type},
    );

    return if !%PermissionTypeList;

    # get valid role list
    my %RoleList = $Self->RoleList();

    return if !$RoleList{ $Param{RoleID} };

    # get group role data
    my %Permissions = $Self->_DBGroupRoleGet(
        Type => 'RolePermGroup',
    );

    return if !$Permissions{ $Param{RoleID} };
    return if ref $Permissions{ $Param{RoleID} } ne 'HASH';

    # extract groups
    my $GroupsRaw   = $Permissions{ $Param{RoleID} }->{ $Param{Type} } || [];
    my $GroupsRawRw = $Permissions{ $Param{RoleID} }->{rw}             || [];

    if ( ref $GroupsRaw ne 'ARRAY' ) {
        $GroupsRaw = [];
    }
    if ( ref $GroupsRawRw ne 'ARRAY' ) {
        $GroupsRawRw = [];
    }

    # get valid group list
    my %GroupList = $Self->GroupList(
        Valid => 1,
    );

    # calculate groups
    my %Groups;
    GROUPID:
    for my $GroupID ( @{$GroupsRaw}, @{$GroupsRawRw} ) {

        next GROUPID if !$GroupID;
        next GROUPID if !$GroupList{$GroupID};

        $Groups{$GroupID} = $GroupList{$GroupID};
    }

    return %Groups;
}

=item PermissionRoleUserAdd()

add new permissions or update existing one to the given group of a given role

    my $Success = $GroupObject->PermissionRoleUserAdd(
        UID    => 12,
        RID    => 6,
        Active => 1,
        UserID => 123,
    );

=cut

sub PermissionRoleUserAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UID RID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get role user data
    my %DBUserRole = $Self->_DBRoleUserGet(
        Type => 'UserRoleHash',
    );

    return 1 if $Param{Active}  && $DBUserRole{ $Param{UID} }->{ $Param{RID} };
    return 1 if !$Param{Active} && !$DBUserRole{ $Param{UID} }->{ $Param{RID} };

    # get needed object
    my $DBObject    = $Kernel::OM->Get('Kernel::System::DB');
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # delete existing relation
    $DBObject->Do(
        SQL  => 'DELETE FROM role_user WHERE user_id = ? AND role_id = ?',
        Bind => [ \$Param{UID}, \$Param{RID} ],
    );

    # reset cache
    $CacheObject->CleanUp(
        Type => 'DBRoleUserGet',
    );

    $CacheObject->CleanUp(
        Type => 'GroupPermissionUserGet',
    );

    $CacheObject->CleanUp(
        Type => 'GroupPermissionGroupGet',
    );

    return 1 if !$Param{Active};

    # insert new relation
    $DBObject->Do(
        SQL => 'INSERT INTO role_user '
            . '(user_id, role_id, create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [ \$Param{UID}, \$Param{RID}, \$Param{UserID}, \$Param{UserID} ],
    );

    return 1;
}

=item PermissionRoleUserGet()

returns a list with all users of a role

    my %UserList = $GroupObject->PermissionRoleUserGet(
        RoleID => $RoleID,
    );

    %UserList = (
        1 => 'User1',
        2 => 'User2',
        3 => 'User3',
    );

=cut

sub PermissionRoleUserGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{RoleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need RoleID!",
        );
        return;
    }

    # get valid role list
    my %RoleList = $Self->RoleList();

    return if !$RoleList{ $Param{RoleID} };

    # get permission data
    my %Permissions = $Self->_DBRoleUserGet(
        Type => 'RoleUser',
    );

    return if !$Permissions{ $Param{RoleID} };
    return if ref $Permissions{ $Param{RoleID} } ne 'ARRAY';

    # extract users
    my $UsersRaw = $Permissions{ $Param{RoleID} } || [];

    # get valid user list
    my %UserList = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type => 'Short',
    );

    # calculate users
    my %Users;
    USERID:
    for my $UserID ( @{$UsersRaw} ) {

        next USERID if !$UserID;
        next USERID if !$UserList{$UserID};

        $Users{$UserID} = $UserList{$UserID};
    }

    return %Users;
}

=item PermissionUserRoleGet()

returns a list with all roles of a user

    my %RoleList = $GroupObject->PermissionUserRoleGet(
        UserID => $UserID,
    );

    %RoleList = (
        1 => 'Role1',
        2 => 'Role2',
        3 => 'Role3',
    );

=cut

sub PermissionUserRoleGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # get valid user list
    my %UserList = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type => 'Short',
    );

    return if !$UserList{ $Param{UserID} };

    # get permission data
    my %Permissions = $Self->_DBRoleUserGet(
        Type => 'UserRole',
    );

    return if !$Permissions{ $Param{UserID} };
    return if ref $Permissions{ $Param{UserID} } ne 'ARRAY';

    # extract roles
    my $RolesRaw = $Permissions{ $Param{UserID} } || [];

    # get valid role list
    my %RoleList = $Self->RoleList();

    # calculate roles
    my %Roles;
    ROLEID:
    for my $RoleID ( @{$RolesRaw} ) {

        next ROLEID if !$RoleID;
        next ROLEID if !$RoleList{$RoleID};

        $Roles{$RoleID} = $RoleList{$RoleID};
    }

    return %Roles;
}

=item GroupMemberAdd()

Function for backward compatibility. Redirected to PermissionGroupUserAdd().

=cut

sub GroupMemberAdd {
    my ( $Self, %Param ) = @_;

    return $Self->PermissionGroupUserAdd(%Param);
}

=item GroupMemberList()

Function for backward compatibility. Redirected to PermissionUserGet() and PermissionGroupGet().

=cut

sub GroupMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Result Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }
    if ( !$Param{UserID} && !$Param{GroupID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID or GroupID!',
        );
        return;
    }

    if ( $Param{UserID} ) {

        # get groups of the give user
        my %Groups = $Self->PermissionUserGet(
            UserID => $Param{UserID},
            Type   => $Param{Type},
        );

        return %Groups if $Param{Result} eq 'HASH';

        if ( $Param{Result} eq 'ID' ) {

            my @IDList = sort keys %Groups;

            return @IDList;
        }

        if ( $Param{Result} eq 'Name' ) {

            my @NameList = sort values %Groups;

            return @NameList;
        }
    }
    else {

        # get users of the give group
        my %Users = $Self->PermissionGroupGet(
            GroupID => $Param{GroupID},
            Type    => $Param{Type},
        );

        return %Users if $Param{Result} eq 'HASH';

        if ( $Param{Result} eq 'ID' ) {

            my @IDList = sort keys %Users;

            return @IDList;
        }

        if ( $Param{Result} eq 'Name' ) {

            my @NameList = sort values %Users;

            return @NameList;
        }
    }

    return;
}

=item GroupMemberInvolvedList()

Function for backward compatibility. Redirected to PermissionUserInvolvedGet().

=cut

sub GroupMemberInvolvedList {
    my ( $Self, %Param ) = @_;

    return $Self->PermissionUserInvolvedGet(%Param);
}

=item GroupGroupMemberList()

Function for backward compatibility. Redirected to PermissionUserGroupGet() and PermissionGroupUserGet().

=cut

sub GroupGroupMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Result Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }
    if ( !$Param{UserID} && !$Param{GroupID} && !$Param{UserIDs} && !$Param{GroupIDs} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID or GroupID or UserIDs or GroupIDs!',
        );
        return;
    }

    my @UserIDList;
    if ( $Param{UserID} ) {
        push @UserIDList, $Param{UserID};
    }
    elsif ( $Param{UserIDs} ) {
        @UserIDList = @{ $Param{UserIDs} };
    }

    my @GroupIDList;
    if ( $Param{GroupID} ) {
        push @GroupIDList, $Param{GroupID};
    }
    elsif ( $Param{GroupIDs} ) {
        @GroupIDList = @{ $Param{GroupIDs} };
    }

    if (@UserIDList) {

        my %GroupList;
        for my $UserID (@UserIDList) {

            my %GroupListOne = $Self->PermissionUserGroupGet(
                UserID => $UserID,
                Type   => $Param{Type},
            );

            %GroupList = ( %GroupList, %GroupListOne );
        }

        return %GroupList if $Param{Result} eq 'HASH';

        if ( $Param{Result} eq 'ID' ) {

            my @IDList = sort keys %GroupList;

            return @IDList;
        }

        if ( $Param{Result} eq 'Name' ) {

            my @NameList = sort values %GroupList;

            return @NameList;
        }
    }

    if (@GroupIDList) {

        my %UserList;
        for my $GroupID (@GroupIDList) {

            my %UserListOne = $Self->PermissionGroupUserGet(
                GroupID => $GroupID,
                Type    => $Param{Type},
            );

            %UserList = ( %UserList, %UserListOne );
        }

        return %UserList if $Param{Result} eq 'HASH';

        if ( $Param{Result} eq 'ID' ) {

            my @IDList = sort keys %UserList;

            return @IDList;
        }

        if ( $Param{Result} eq 'Name' ) {

            my @NameList = sort values %UserList;

            return @NameList;
        }
    }

    return;
}

=item GroupRoleMemberList()

Function for backward compatibility. Redirected to PermissionRoleGroupGet() and PermissionGroupRoleGet().

=cut

sub GroupRoleMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Result Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }
    if ( !$Param{RoleID} && !$Param{GroupID} && !$Param{RoleIDs} && !$Param{GroupIDs} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need RoleID or GroupID or RoleIDs or GroupIDs!'
        );
        return;
    }

    my @RoleIDList;
    if ( $Param{RoleID} ) {
        push @RoleIDList, $Param{RoleID};
    }
    elsif ( $Param{RoleIDs} ) {
        @RoleIDList = @{ $Param{RoleIDs} };
    }

    my @GroupIDList;
    if ( $Param{GroupID} ) {
        push @GroupIDList, $Param{GroupID};
    }
    elsif ( $Param{GroupIDs} ) {
        @GroupIDList = @{ $Param{GroupIDs} };
    }

    if (@RoleIDList) {

        my %GroupList;
        for my $RoleID (@RoleIDList) {

            my %GroupListOne = $Self->PermissionRoleGroupGet(
                RoleID => $RoleID,
                Type   => $Param{Type},
            );

            %GroupList = ( %GroupList, %GroupListOne );
        }

        return %GroupList if $Param{Result} eq 'HASH';

        if ( $Param{Result} eq 'ID' ) {

            my @IDList = sort keys %GroupList;

            return @IDList;
        }

        if ( $Param{Result} eq 'Name' ) {

            my @NameList = sort values %GroupList;

            return @NameList;
        }
    }

    if (@GroupIDList) {

        my %RoleList;
        for my $GroupID (@GroupIDList) {

            my %RoleListOne = $Self->PermissionGroupRoleGet(
                GroupID => $GroupID,
                Type    => $Param{Type},
            );

            %RoleList = ( %RoleList, %RoleListOne );
        }

        return %RoleList if $Param{Result} eq 'HASH';

        if ( $Param{Result} eq 'ID' ) {

            my @IDList = sort keys %RoleList;

            return @IDList;
        }

        if ( $Param{Result} eq 'Name' ) {

            my @NameList = sort values %RoleList;

            return @NameList;
        }
    }

    return;
}

=item GroupRoleMemberAdd()

Function for backward compatibility. Redirected to PermissionGroupRoleAdd().

=cut

sub GroupRoleMemberAdd {
    my ( $Self, %Param ) = @_;

    return $Self->PermissionGroupRoleAdd(%Param);
}

=item GroupUserRoleMemberList()

Function for backward compatibility. Redirected to PermissionUserRoleGet() and PermissionRoleUserGet().

=cut

sub GroupUserRoleMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Result} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Result!'
        );
        return;
    }

    if ( !$Param{RoleID} && !$Param{UserID} && !$Param{RoleIDs} && !$Param{UserIDs} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need RoleID or UserID or RoleIDs or UserIDs!',
        );
        return;
    }

    my @UserIDList;
    if ( $Param{UserID} ) {
        push @UserIDList, $Param{UserID};
    }
    elsif ( $Param{UserIDs} ) {
        @UserIDList = @{ $Param{UserIDs} };
    }

    my @RoleIDList;
    if ( $Param{RoleID} ) {
        push @RoleIDList, $Param{RoleID};
    }
    elsif ( $Param{RoleIDs} ) {
        @RoleIDList = @{ $Param{RoleIDs} };
    }

    if (@UserIDList) {

        my %RoleList;
        for my $UserID (@UserIDList) {

            my %RoleListOne = $Self->PermissionUserRoleGet(
                UserID => $UserID,
            );

            %RoleList = ( %RoleList, %RoleListOne );
        }

        return %RoleList if $Param{Result} eq 'HASH';

        if ( $Param{Result} eq 'ID' ) {

            my @IDList = sort keys %RoleList;

            return @IDList;
        }

        if ( $Param{Result} eq 'Name' ) {

            my @NameList = sort values %RoleList;

            return @NameList;
        }
    }

    if (@RoleIDList) {

        my %UserList;
        for my $RoleID (@RoleIDList) {

            my %UserListOne = $Self->PermissionRoleUserGet(
                RoleID => $RoleID,
            );

            %UserList = ( %UserList, %UserListOne );
        }

        return %UserList if $Param{Result} eq 'HASH';

        if ( $Param{Result} eq 'ID' ) {

            my @IDList = sort keys %UserList;

            return @IDList;
        }

        if ( $Param{Result} eq 'Name' ) {

            my @NameList = sort values %UserList;

            return @NameList;
        }
    }

    return;
}

=item GroupUserRoleMemberAdd()

Function for backward compatibility. Redirected to PermissionRoleUserAdd().

=cut

sub GroupUserRoleMemberAdd {
    my ( $Self, %Param ) = @_;

    return $Self->PermissionRoleUserAdd(%Param);
}

=begin Internal:

=cut

=item _DBGroupUserGet()

returns the content of the database table group_user

    my %Data = $GroupObject->_DBGroupUserGet(
        Type => 'UserGroupPerm',  # UserGroupPerm|UserPermGroup|GroupPermUser
    );

    Example if Type is UserGroupPerm:

    $Data{$UserID}->{$GroupID}->{$Permission}

    %Data = (
        32 => {
            34 => [
                'create',
                'move_into',
                'owner',
                'ro',
            ],
        },
        276 => {
            277 => [
                'rw',
            ],
        },
    );

    Example if Type is UserPermGroup:

    $Data{$UserID}->{$Permission}->{$GroupID}

    %Data = (
        32 => {
            owner     => [ 34 ],
            create    => [ 34 ],
            ro        => [ 34 ],
            move_into => [ 34 ],
        },
        276 => {
            rw => [ 277 ],
        },
    );

    Example if Type is GroupPermUser:

    $Data{$GroupID}->{$Permission}->{$UserID}

    %Data = (
        127 => {
            owner     => [ 128 ],
            create    => [ 128 ],
            ro        => [ 128 ],
            move_into => [ 128 ],
        },
        90 => {
            rw => [ 91 ],
        },
    );

=cut

sub _DBGroupUserGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Type} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Type!",
        );
        return;
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    if ( $Param{Type} eq 'UserGroupPerm' ) {

        # read cache
        my $Cache = $CacheObject->Get(
            Type => 'DBGroupUserGet',
            Key  => 'UserGroupPermList',
        );

        return %{$Cache} if $Cache && ref $Cache eq 'HASH';
    }
    elsif ( $Param{Type} eq 'UserPermGroup' ) {

        # read cache
        my $Cache = $CacheObject->Get(
            Type => 'DBGroupUserGet',
            Key  => 'UserPermGroupList',
        );

        return %{$Cache} if $Cache && ref $Cache eq 'HASH';
    }
    else {

        # read cache
        my $Cache = $CacheObject->Get(
            Type => 'DBGroupUserGet',
            Key  => 'GroupPermUserList',
        );

        return %{$Cache} if $Cache && ref $Cache eq 'HASH';
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all data from table group_user
    $DBObject->Prepare(
        SQL => 'SELECT user_id, group_id, permission_key FROM group_user',
    );

    # fetch the result
    my %UserGroupPermList;
    my %UserPermGroupList;
    my %GroupPermUserList;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        $UserGroupPermList{ $Row[0] }->{ $Row[1] } ||= [];
        $UserPermGroupList{ $Row[0] }->{ $Row[2] } ||= [];
        $GroupPermUserList{ $Row[1] }->{ $Row[2] } ||= [];

        push @{ $UserGroupPermList{ $Row[0] }->{ $Row[1] } }, $Row[2];
        push @{ $UserPermGroupList{ $Row[0] }->{ $Row[2] } }, $Row[1];
        push @{ $GroupPermUserList{ $Row[1] }->{ $Row[2] } }, $Row[0];
    }

    # set cache
    $CacheObject->Set(
        Type  => 'DBGroupUserGet',
        Key   => 'UserGroupPermList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%UserGroupPermList,
    );
    $CacheObject->Set(
        Type  => 'DBGroupUserGet',
        Key   => 'UserPermGroupList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%UserPermGroupList,
    );
    $CacheObject->Set(
        Type  => 'DBGroupUserGet',
        Key   => 'GroupPermUserList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%GroupPermUserList,
    );

    return %UserPermGroupList if $Param{Type} eq 'UserPermGroup';
    return %UserGroupPermList if $Param{Type} eq 'UserGroupPerm';
    return %GroupPermUserList;
}

=item _DBGroupRoleGet()

returns the content of the database table group_role

    my %Data = $GroupObject->_DBGroupRoleGet(
        Type => 'RoleGroupPerm',  # RoleGroupPerm|RolePermGroup|GroupPermRole
    );

    Example if Type is RoleGroupPerm:

    $Data{$RoleID}->{$GroupID}->{$Permission}

    %Data = (
        32 => {
            34 => [
                'create',
                'move_into',
                'owner',
                'ro',
            ],
        },
        276 => {
            277 => [
                'rw',
            ],
        },
    );

    Example if Type is RolePermGroup:

    $Data{$RoleID}->{$Permission}->{$GroupID}

    %Data = (
        32 => {
            owner     => [ 34 ],
            create    => [ 34 ],
            ro        => [ 34 ],
            move_into => [ 34 ],
        },
        276 => {
            rw => [ 277 ],
        },
    );

    Example if Type is GroupPermRole:

    $Data{$GroupID}->{$Permission}->{$RoleID}

    %Data = (
        127 => {
            owner     => [ 128 ],
            create    => [ 128 ],
            ro        => [ 128 ],
            move_into => [ 128 ],
        },
        90 => {
            rw => [ 91 ],
        },
    );

=cut

sub _DBGroupRoleGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Type} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Type!",
        );
        return;
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    if ( $Param{Type} eq 'RoleGroupPerm' ) {

        # read cache
        my $Cache = $CacheObject->Get(
            Type => 'DBGroupRoleGet',
            Key  => 'RoleGroupPermList',
        );

        return %{$Cache} if $Cache && ref $Cache eq 'HASH';
    }
    elsif ( $Param{Type} eq 'RolePermGroup' ) {

        # read cache
        my $Cache = $CacheObject->Get(
            Type => 'DBGroupRoleGet',
            Key  => 'RolePermGroupList',
        );

        return %{$Cache} if $Cache && ref $Cache eq 'HASH';
    }
    else {

        # read cache
        my $Cache = $CacheObject->Get(
            Type => 'DBGroupRoleGet',
            Key  => 'GroupPermRoleList',
        );

        return %{$Cache} if $Cache && ref $Cache eq 'HASH';
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all data from table group_role
    $DBObject->Prepare(
        SQL => 'SELECT role_id, group_id, permission_key FROM group_role',
    );

    # fetch the result
    my %RoleGroupPermList;
    my %RolePermGroupList;
    my %GroupPermRoleList;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        $RoleGroupPermList{ $Row[0] }->{ $Row[1] } ||= [];
        $RolePermGroupList{ $Row[0] }->{ $Row[2] } ||= [];
        $GroupPermRoleList{ $Row[1] }->{ $Row[2] } ||= [];

        push @{ $RoleGroupPermList{ $Row[0] }->{ $Row[1] } }, $Row[2];
        push @{ $RolePermGroupList{ $Row[0] }->{ $Row[2] } }, $Row[1];
        push @{ $GroupPermRoleList{ $Row[1] }->{ $Row[2] } }, $Row[0];
    }

    # set cache
    $CacheObject->Set(
        Type  => 'DBGroupRoleGet',
        Key   => 'RoleGroupPermList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%RoleGroupPermList,
    );
    $CacheObject->Set(
        Type  => 'DBGroupRoleGet',
        Key   => 'RolePermGroupList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%RolePermGroupList,
    );
    $CacheObject->Set(
        Type  => 'DBGroupRoleGet',
        Key   => 'GroupPermRoleList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%GroupPermRoleList,
    );

    return %RolePermGroupList if $Param{Type} eq 'RolePermGroup';
    return %RoleGroupPermList if $Param{Type} eq 'RoleGroupPerm';
    return %GroupPermRoleList;
}

=item _DBRoleUserGet()

returns the content of the database table role_user

    my %Data = $GroupObject->_DBRoleUserGet(
        Type => 'RoleUser',  # UserRole|RoleUser|UserRoleHash
    );

    Example if Type is UserRole:

    $Data{$UserID}->{$RoleID}

    %Data = (
        559 => [ 557 ],
        127 => [ 125 ],
        32  => [ 31 ],
        443 => [ 442 ],
    );

    Example if Type is RoleUser:

    $Data{$RoleID}->{$UserID}

    %Data = (
        559 => [ 560 ],
        127 => [ 128 ],
        32  => [ 33, 34 ],
        443 => [ 444, 445 ],
    );

    Example if Type is UserRoleHash:

    $Data{$UserID}->{$RoleID} = 1

    %Data = (
        559 => {
            557 => 1,
        },
        127 => {
            125 => 1,
        },
        32 => {
            31 => 1,
        },
        443 => {
            442 => 1,
        },
    );

=cut

sub _DBRoleUserGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Type} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Type!",
        );
        return;
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    if ( $Param{Type} eq 'UserRole' ) {

        # read cache
        my $Cache = $CacheObject->Get(
            Type => 'DBRoleUserGet',
            Key  => 'UserRoleList',
        );

        return %{$Cache} if $Cache && ref $Cache eq 'HASH';
    }
    elsif ( $Param{Type} eq 'RoleUser' ) {

        # read cache
        my $Cache = $CacheObject->Get(
            Type => 'DBRoleUserGet',
            Key  => 'RoleUserList',
        );

        return %{$Cache} if $Cache && ref $Cache eq 'HASH';
    }
    else {

        # read cache
        my $Cache = $CacheObject->Get(
            Type => 'DBRoleUserGet',
            Key  => 'UserRoleHash',
        );

        return %{$Cache} if $Cache && ref $Cache eq 'HASH';
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all data from table role_user
    $DBObject->Prepare(
        SQL => 'SELECT user_id, role_id FROM role_user',
    );

    # fetch the result
    my %UserRoleList;
    my %RoleUserList;
    my %UserRoleHash;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        $UserRoleList{ $Row[0] } ||= [];
        $RoleUserList{ $Row[1] } ||= [];

        push @{ $UserRoleList{ $Row[0] } }, $Row[1];
        push @{ $RoleUserList{ $Row[1] } }, $Row[0];

        $UserRoleHash{ $Row[0] }->{ $Row[1] } = 1;
    }

    # set cache
    $CacheObject->Set(
        Type  => 'DBRoleUserGet',
        Key   => 'UserRoleList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%UserRoleList,
    );
    $CacheObject->Set(
        Type  => 'DBRoleUserGet',
        Key   => 'RoleUserList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%RoleUserList,
    );
    $CacheObject->Set(
        Type  => 'DBRoleUserGet',
        Key   => 'UserRoleHash',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%UserRoleHash,
    );

    return %UserRoleList if $Param{Type} eq 'UserRole';
    return %RoleUserList if $Param{Type} eq 'RoleUser';
    return %UserRoleHash;
}

=item _PermissionTypeList()

returns a list of valid system permissions.

    %PermissionTypeList = $GroupObject->_PermissionTypeList(
        Type => 'close',  # (optional)
    );

=cut

sub _PermissionTypeList {
    my ( $Self, %Param ) = @_;

    # get system permission config
    my $SystemPermissionConfig = $Kernel::OM->Get('Kernel::Config')->Get('System::Permission');

    return () if !$SystemPermissionConfig;
    return () if ref $SystemPermissionConfig ne 'ARRAY';

    my %TypeList;
    ROW:
    for my $Row ( @{$SystemPermissionConfig} ) {

        next ROW if !$Row;
        next ROW if $Param{Type} && $Row ne $Param{Type};

        $TypeList{$Row} = 1;
    }

    $TypeList{rw} = 1;

    return %TypeList;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
