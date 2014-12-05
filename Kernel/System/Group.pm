# --
# Kernel/System/Group.pm - All Groups and Roles related functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

    # TODO can be removed after recoding is complete
    $Self->{CacheType} = 'Group';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

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
        Valid => 1,
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
                Message  => "Need $_!"
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

    # log
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "Group: '$Param{Name}' ID: '$GroupID' created successfully ($Param{UserID})!",
    );

    # reset cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Group',
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
        'Comment'    => 'Group of all admins.',
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
        Valid => 1,
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

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    return if !$DBObject->Do(
        SQL => 'UPDATE groups SET name = ?, comments = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );

    # reset cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Group',
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
        Type => 'Group',
        Key  => 'GroupList::0',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%GroupListAll,
    );
    $CacheObject->Set(
        Type => 'Group',
        Key  => 'GroupList::1',
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
            Comment    => $Row[2],
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

=item GroupMemberAdd()

to add a member to a group

    Permission: ro,move_into,priority,create,rw

    my $Success = $GroupObject->GroupMemberAdd(
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

sub GroupMemberAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UID GID UserID Permission)) {
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

    # check if update is needed (fetch current values)
    my %Value;
    if ( !$Self->{"GroupMemberAdd::GID::$Param{GID}"} ) {
        return if !$DBObject->Prepare(
            SQL => 'SELECT group_id, user_id, permission_key, permission_value FROM '
                . 'group_user WHERE group_id = ?',
            Bind => [ \$Param{GID} ],
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Value{ $Row[0] }->{ $Row[1] }->{ $Row[2] } = $Row[3];
        }
        $Self->{"GroupMemberAdd::GID::$Param{GID}"} = \%Value;
    }
    else {
        %Value = %{ $Self->{"GroupMemberAdd::GID::$Param{GID}"} };
    }

    # check rw rule (set only rw and remove rest, because it's including all in rw)
    if ( $Param{Permission}->{rw} ) {
        %{ $Param{Permission} } = ( rw => 1 );
    }

    # update permission
    TYPE:
    for my $Type ( sort keys %{ $Param{Permission} } ) {

        # check if update is needed
        my $ValueCurrent = $Value{ $Param{GID} }->{ $Param{UID} }->{$Type};
        my $ValueNew     = $Param{Permission}->{$Type};

        # No updated needed!
        next TYPE if !$ValueCurrent && !$ValueNew;
        next TYPE if $ValueCurrent  && $ValueNew;

        # update done, reset current values of this group
        $Self->{"GroupMemberAdd::GID::$Param{GID}"} = undef;

        # delete existing permission
        $DBObject->Do(
            SQL => 'DELETE FROM group_user WHERE '
                . ' group_id = ? AND user_id = ? AND permission_key = ?',
            Bind => [ \$Param{GID}, \$Param{UID}, \$Type ],
        );

        # debug
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Add UID:$Param{UID} to GID:$Param{GID}, $Type:$ValueNew!",
            );
        }

        # insert new permission (if needed)
        next TYPE if !$ValueNew;
        $DBObject->Do(
            SQL => 'INSERT INTO group_user '
                . '(user_id, group_id, permission_key, permission_value, '
                . 'create_time, create_by, change_time, change_by) '
                . 'VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
            Bind => [
                \$Param{UID}, \$Param{GID}, \$Type, \$ValueNew,
                \$Param{UserID}, \$Param{UserID},
            ],
        );
    }

    # reset cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=item GroupMemberList()

returns a list of users/groups with ro/move_into/create/owner/priority/rw permissions
based on GroupGroupMemberList() and GroupRoleMemberList().

    UserID:  user id
    GroupID: group id

    Type: ro|move_into|priority|create|rw

    Result: HASH -> returns a hash of key => group id, value => group name
            Name -> returns an array of user names
            ID   -> returns an array of user ids

    Example (get groups of user):

    my %Groups = $GroupObject->GroupMemberList(
        UserID => $ID,
        Type   => 'move_into',
        Result => 'HASH',
    );

    Example (get users of group):

    my %Users = $GroupObject->GroupMemberList(
        GroupID => $ID,
        Type    => 'move_into',
        Result  => 'HASH',
    );

    Attention: The user ids (keys) in the hash returned from this function
        are correct, however the values do not correspond to the user ids.
        This does not affect the correct operation of otrs, this is just a
        note to inform you not to use the values in this hash.

=cut

sub GroupMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Result Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    if ( !$Param{UserID} && !$Param{GroupID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID or GroupID!'
        );
        return;
    }

    # create cache key
    my $CacheKey = 'GroupMemberList::' . $Param{Type} . '::' . $Param{Result} . '::';
    if ( $Param{UserID} ) {
        $CacheKey .= "UserID::$Param{UserID}";
    }
    else {
        $CacheKey .= "GroupID::$Param{GroupID}";
    }

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    if ($Cache) {
        return @{$Cache} if ref $Cache eq 'ARRAY';
        return %{$Cache} if ref $Cache eq 'HASH';
    }

    # return result
    if ( $Param{Result} eq 'ID' || $Param{Result} eq 'Name' ) {
        my @Result = $Self->GroupGroupMemberList(%Param);

        # get roles of user
        if ( $Param{UserID} ) {
            my @Member = $Self->GroupUserRoleMemberList(
                UserID => $Param{UserID},
                Result => 'ID',
            );
            if (@Member) {
                my @ResultGroupRole = $Self->GroupRoleMemberList(
                    %Param,
                    RoleIDs => \@Member,
                );
                push @Result, @ResultGroupRole;
            }
        }

        # get roles of group
        elsif ( $Param{GroupID} ) {
            my @Roles = $Self->GroupRoleMemberList(
                GroupID => $Param{GroupID},
                Type    => $Param{Type},
                Result  => 'ID',
            );
            if (@Roles) {
                my @ResultGroupUserRole = $Self->GroupUserRoleMemberList(
                    %Param,
                    RoleIDs => \@Roles,
                );
                push @Result, @ResultGroupUserRole;
            }
        }

        # set cache
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => \@Result,
        );

        return @Result;
    }

    # get group member list as hash
    my %Result = $Self->GroupGroupMemberList(%Param);

    # get roles of user
    if ( $Param{UserID} ) {
        my @Member = $Self->GroupUserRoleMemberList(
            UserID => $Param{UserID},
            Result => 'ID',
        );

        if (@Member) {
            my %ResultGroupRole = $Self->GroupRoleMemberList( %Param, RoleIDs => \@Member );
            %Result = ( %Result, %ResultGroupRole );
        }
    }

    # get roles of group
    elsif ( $Param{GroupID} ) {
        my @Roles = $Self->GroupRoleMemberList(
            GroupID => $Param{GroupID},
            Type    => $Param{Type},
            Result  => 'ID',
        );
        if (@Roles) {

            my %ResultGroupUserRole = $Self->GroupUserRoleMemberList(
                %Param,
                RoleIDs => \@Roles,
            );
            %Result = ( %Result, %ResultGroupUserRole );
        }
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Result,
    );

    return %Result;

}

=item GroupMemberInvolvedList()

returns a list of users/groups with ro/move_into/create/owner/priority/rw permissions

    my %Users = $GroupObject->GroupMemberInvolvedList(
        UserID => $ID,
        Type   => 'move_into',
    );

=cut

sub GroupMemberInvolvedList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(UserID Type)) {
        if ( !$Param{$Attribute} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Attribute!"
            );
            return;
        }
    }

    # create cache key
    my $CacheKey = 'GroupMemberInvolvedList::' . $Param{Type} . '::' . $Param{UserID};

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # only allow valid system permissions as Type
    my $TypeString = $Self->_GetTypeString( Type => $Param{Type} );

    # get valid ids
    my $ValidID = join( ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet() );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all groups of the given user
    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(g.id) FROM groups g, group_user gu WHERE "
            . "g.valid_id IN ($ValidID) AND "
            . "g.id = gu.group_id AND gu.permission_value = 1 AND "
            . "gu.permission_key IN ( $TypeString ) AND gu.user_id = ?",
        Bind => [
            \$Param{UserID},
        ],
    );
    my %Groups;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Groups{ $Row[0] } = 1;
    }

    # get all roles of the given user
    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(ru.role_id) FROM role_user ru, roles r WHERE "
            . "r.valid_id in ($ValidID) AND r.id = ru.role_id AND ru.user_id = ?",
        Bind => [
            \$Param{UserID},
        ],
    );
    my @Roles;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Roles, $Row[0];
    }

    # get groups of roles of given user
    if (@Roles) {
        return if !$DBObject->Prepare(
            SQL => "SELECT DISTINCT(g.id) FROM groups g, group_role gu WHERE "
                . "g.valid_id in ($ValidID) AND g.id = gu.group_id AND "
                . "gu.permission_value = 1 AND gu.permission_key IN ( $TypeString ) AND "
                . "gu.role_id IN (" . join( ',', @Roles ) . ")",
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Groups{ $Row[0] } = 1;
        }
    }

    # get all users of the groups which are found
    my @ArrayGroups = keys %Groups;
    my %AllUsers;
    if (@ArrayGroups) {
        return if !$DBObject->Prepare(
            SQL => "SELECT DISTINCT(gu.user_id) FROM groups g, group_user gu WHERE "
                . "g.valid_id in ($ValidID) AND g.id = gu.group_id AND "
                . "gu.permission_value = 1 AND gu.permission_key IN ( $TypeString ) AND "
                . "gu.group_id IN (" . join( ',', @ArrayGroups ) . ")",
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $AllUsers{ $Row[0] } = 1;
        }

        # get all roles of the groups
        return if !$DBObject->Prepare(
            SQL => "SELECT DISTINCT(gu.role_id) FROM groups g, group_role gu WHERE "
                . "g.valid_id in ($ValidID) AND g.id = gu.group_id AND "
                . "gu.permission_value = 1 AND gu.permission_key IN ( $TypeString ) AND "
                . "gu.group_id IN (" . join( ',', @ArrayGroups ) . ")",
        );
        my @AllRoles;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @AllRoles, $Row[0];
        }

        # get all users of the roles
        if (@AllRoles) {
            return if !$DBObject->Prepare(
                SQL => "SELECT DISTINCT(ru.user_id) FROM role_user ru, roles r WHERE "
                    . "r.valid_id in ($ValidID) AND r.id = ru.role_id AND "
                    . "ru.role_id IN (" . join( ',', @AllRoles ) . ")",
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
                $AllUsers{ $Row[0] } = 1;
            }
        }
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%AllUsers,
    );

    return %AllUsers;
}

=item GroupGroupMemberList()

returns a list of users/groups with ro/move_into/create/owner/priority/rw permissions

    UserID:   user id
    GroupID:  group id
    UserIDs:  user ids (array ref)
    GroupIDs: group ids (array ref)

    Type: ro|move_into|priority|create|rw

    Result: HASH -> returns a hash of key => group id, value => group name
            Name -> returns an array of user names
            ID   -> returns an array of user ids

    Example (get groups of user):

    $GroupObject->GroupGroupMemberList(
        UserID => $ID,
        Type   => 'move_into',
        Result => 'HASH',
    );

    Example (get users of group):

    $GroupObject->GroupGroupMemberList(
        GroupID => $ID,
        Type    => 'move_into',
        Result  => 'HASH',
    );

=cut

sub GroupGroupMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Result Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    if ( !$Param{UserID} && !$Param{GroupID} && !$Param{UserIDs} && !$Param{GroupIDs} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID or GroupID or UserIDs or GroupIDs!'
        );
        return;
    }

    # create cache key
    my $CacheKey = 'GroupGroupMemberList::' . $Param{Type} . '::' . $Param{Result} . '::';
    my @UserIDs;
    my @GroupIDs;
    if ( $Param{UserID} ) {
        $CacheKey .= 'UserID::' . $Param{UserID};
    }
    elsif ( $Param{GroupID} ) {
        $CacheKey .= 'GroupID::' . $Param{GroupID};
    }
    elsif ( $Param{UserIDs} ) {
        @UserIDs = sort @{ $Param{UserIDs} };
    }
    elsif ( $Param{GroupIDs} ) {
        @GroupIDs = sort @{ $Param{GroupIDs} };
    }

    # check cache
    if ( $Param{UserID} || $Param{GroupID} ) {
        my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        if ($Cache) {
            return @{$Cache} if ref $Cache eq 'ARRAY';
            return %{$Cache} if ref $Cache eq 'HASH';
        }
    }

    # only allow valid system permissions as Type
    my $TypeString = $Self->_GetTypeString( Type => $Param{Type} );

    my $ValidIDs = join( ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet() );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    my $SQL = "SELECT g.id, g.name, gu.permission_key, gu.permission_value, gu.user_id
        FROM groups g, group_user gu, users u
        WHERE g.valid_id IN ($ValidIDs)
            AND g.id = gu.group_id
            AND gu.permission_value = 1
            AND gu.permission_key IN ( $TypeString )
            AND gu.user_id = u.id
            AND u.valid_id IN ( $ValidIDs )
            AND ";

    if ( $Param{UserID} ) {
        $SQL .= 'gu.user_id = ' . $DBObject->Quote( $Param{UserID}, 'Integer' );
    }
    elsif ( $Param{GroupID} ) {
        $SQL .= 'gu.group_id = ' . $DBObject->Quote( $Param{GroupID}, 'Integer' );
    }
    elsif ( $Param{UserIDs} ) {
        for my $UserID (@UserIDs) {
            $UserID = $DBObject->Quote( $UserID, 'Integer' );
        }
        $SQL .= ' ru.user_id IN (' . join( ',', @UserIDs ) . ')';
    }
    elsif ( $Param{GroupIDs} ) {
        for my $GroupID (@GroupIDs) {
            $GroupID = $DBObject->Quote( $GroupID, 'Integer' );
        }
        $SQL .= ' gu.group_id IN (' . join( ',', @GroupIDs ) . ')';
    }

    my %Data;
    my @Name;
    my @ID;
    return if !$DBObject->Prepare( SQL => $SQL );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my $Key   = '';
        my $Value = '';
        if ( $Param{UserID} || $Param{UserIDs} ) {
            $Key   = $Row[0];
            $Value = $Row[1];
        }
        else {
            $Key   = $Row[4];
            $Value = $Row[1];
        }

        # remember permissions
        if ( !defined $Data{$Key} ) {
            $Data{$Key} = $Value;
            push @Name, $Value;
            push @ID,   $Key;
        }
    }

    # role lookup base on UserID or GroupID

    # return result
    if ( $Param{Result} eq 'ID' ) {

        # set cache
        if ( $Param{UserID} || $Param{GroupID} ) {
            $Kernel::OM->Get('Kernel::System::Cache')->Set(
                Type  => $Self->{CacheType},
                TTL   => $Self->{CacheTTL},
                Key   => $CacheKey,
                Value => \@ID,
            );
        }
        return @ID;
    }
    if ( $Param{Result} eq 'Name' ) {

        # set cache
        if ( $Param{UserID} || $Param{GroupID} ) {
            $Kernel::OM->Get('Kernel::System::Cache')->Set(
                Type  => $Self->{CacheType},
                TTL   => $Self->{CacheTTL},
                Key   => $CacheKey,
                Value => \@Name,
            );
        }
        return @Name;
    }

    # set cache
    if ( $Param{UserID} || $Param{GroupID} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => \%Data,
        );
    }
    return %Data;
}

=item GroupRoleMemberList()

returns a list of role/groups with ro/move_into/create/owner/priority/rw permissions

    RoleID:   role id
    GroupID:  group id
    RoleIDs:  role id (array ref)
    GroupIDs: group id (array ref)

    Type: ro|move_into|priority|create|rw

    Result: HASH -> returns a hash of key => group or role id, value => group name
            Name -> returns an array of group names
            ID   -> returns an array of role or group ids

Example: Get the groups for which the Role $ID provides 'move_into' access.

    $GroupObject->GroupRoleMemberList(
        RoleID => $ID,
        Type   => 'move_into',
        Result => 'HASH',
    );

Example: Get the role ids with 'move_into' access to the group $ID.

Passing HASH or Name as the wanted result is discouraged. The returned name is
is a group name, not a role name.

    my $GroupObject->GroupRoleMemberList(
        GroupID => $ID,
        Type   => 'move_into',
        Result => 'ID',
    );

=cut

sub GroupRoleMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Result Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
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

    # create cache key
    my $CacheKey = 'GroupRoleMemberList::' . $Param{Type} . '::' . $Param{Result} . '::';
    my @RoleIDs;
    my @GroupIDs;
    if ( $Param{RoleID} ) {
        $CacheKey .= 'RoleID::' . $Param{RoleID};
    }
    elsif ( $Param{GroupID} ) {
        $CacheKey .= 'GroupID::' . $Param{GroupID};
    }
    elsif ( $Param{RoleIDs} ) {
        @RoleIDs = sort @{ $Param{RoleIDs} };
    }
    elsif ( $Param{GroupIDs} ) {
        @GroupIDs = sort @{ $Param{GroupIDs} };
    }

    # check cache
    if ( $Param{RoleID} || $Param{GroupID} ) {

        my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );
        if ($Cache) {
            return @{$Cache} if ref $Cache eq 'ARRAY';
            return %{$Cache} if ref $Cache eq 'HASH';
        }
    }

    # only allow valid system permissions as Type
    my $TypeString = $Self->_GetTypeString( Type => $Param{Type} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # assemble the query
    my $SQL = ''
        . 'SELECT g.id, g.name, gr.permission_key, gr.permission_value, gr.role_id'
        . ' FROM groups g, group_role gr'
        . ' WHERE g.valid_id IN ('
        . join( ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet() ) . ')'
        . ' AND g.id = gr.group_id'
        . ' AND gr.permission_value = 1'
        . " AND gr.permission_key IN ( $TypeString )"
        . ' AND ';

    if ( $Param{RoleID} ) {
        $SQL .= ' gr.role_id = ' . $DBObject->Quote( $Param{RoleID}, 'Integer' );
    }
    elsif ( $Param{GroupID} ) {
        $SQL .= ' gr.group_id = ' . $DBObject->Quote( $Param{GroupID}, 'Integer' );
    }
    elsif ( $Param{RoleIDs} ) {
        for my $RoleID (@RoleIDs) {
            $RoleID = $DBObject->Quote( $RoleID, 'Integer' );
        }
        $SQL .= ' gr.role_id IN (' . join( ',', @RoleIDs ) . ')';
    }
    elsif ( $Param{GroupIDs} ) {
        for my $GroupID (@GroupIDs) {
            $GroupID = $DBObject->Quote( $GroupID, 'Integer' );
        }
        $SQL .= ' gr.group_id IN (' . join( ',', @GroupIDs ) . ')';
    }

    # run the query
    return if !$DBObject->Prepare( SQL => $SQL );

    # fetch the data
    my %Data;
    my @Name;
    my @ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my ( $Key, $Value ) = ( '', '' );
        if ( $Param{RoleID} || $Param{RoleIDs} ) {

            # map group ID to group name
            $Key   = $Row[0];
            $Value = $Row[1];
        }
        else {

            # map role ID to a group name
            # DANGER: this is fairly non-intuitive
            $Key   = $Row[4];
            $Value = $Row[1];
        }

        # remember permissions
        if ( !defined $Data{$Key} ) {
            $Data{$Key} = $Value;
            push @Name, $Value;
            push @ID,   $Key;
        }
    }

    # role lookup base on UserID or GroupID

    # return result
    if ( $Param{Result} eq 'ID' ) {

        # set cache
        if ( $Param{RoleID} || $Param{GroupID} ) {
            $Kernel::OM->Get('Kernel::System::Cache')->Set(
                Type  => $Self->{CacheType},
                TTL   => $Self->{CacheTTL},
                Key   => $CacheKey,
                Value => \@ID,
            );
        }
        return @ID;
    }
    if ( $Param{Result} eq 'Name' ) {

        # set cache
        if ( $Param{RoleID} || $Param{GroupID} ) {
            $Kernel::OM->Get('Kernel::System::Cache')->Set(
                Type  => $Self->{CacheType},
                TTL   => $Self->{CacheTTL},
                Key   => $CacheKey,
                Value => \@Name,
            );
        }
        return @Name;
    }

    # set cache
    if ( $Param{RoleID} || $Param{GroupID} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => \%Data,
        );
    }
    return %Data;
}

=item GroupRoleMemberAdd()

to add a role to a group

    Permission: ro,move_into,priority,create,rw

    $GroupObject->GroupRoleMemberAdd(
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

sub GroupRoleMemberAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(RID GID UserID Permission)) {
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

    # check if update is needed (fetch current values)
    my %Value;
    if ( !$Self->{"GroupRoleMemberAdd::GID::$Param{GID}"} ) {
        $DBObject->Prepare(
            SQL => 'SELECT group_id, role_id, permission_key, permission_value FROM '
                . ' group_role WHERE group_id = ?',
            Bind => [ \$Param{GID} ],
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Value{ $Row[0] }->{ $Row[1] }->{ $Row[2] } = $Row[3];
        }
        $Self->{"GroupRoleMemberAdd::GID::$Param{GID}"} = \%Value;
    }
    else {
        %Value = %{ $Self->{"GroupRoleMemberAdd::GID::$Param{GID}"} };
    }

    # check rw rule (set only rw and remove rest, because it's including all in rw)
    if ( $Param{Permission}->{rw} ) {
        %{ $Param{Permission} } = ( rw => 1 );
    }

    # update permission
    TYPE:
    for my $Type ( sort keys %{ $Param{Permission} } ) {

        # check if update is needed
        my $ValueCurrent = $Value{ $Param{GID} }->{ $Param{RID} }->{$Type};
        my $ValueNew     = $Param{Permission}->{$Type};

        # no updated needed!
        next TYPE if !$ValueCurrent && !$ValueNew;
        next TYPE if $ValueCurrent  && $ValueNew;

        # delete existing permission
        $DBObject->Do(
            SQL => 'DELETE FROM group_role WHERE '
                . 'group_id = ? AND role_id = ? AND permission_key = ?',
            Bind => [ \$Param{GID}, \$Param{RID}, \$Type ],
        );

        # debug
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Add RID:$Param{RID} to GID:$Param{GID}, $Type:$ValueNew!",
            );
        }

        # insert new permission (if needed)
        next TYPE if !$ValueNew;
        $DBObject->Do(
            SQL => 'INSERT INTO group_role '
                . '(role_id, group_id, permission_key, permission_value, '
                . 'create_time, create_by, change_time, change_by) '
                . 'VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
            Bind => [
                \$Param{RID}, \$Param{GID}, \$Type, \$ValueNew,
                \$Param{UserID}, \$Param{UserID},
            ],
        );
    }

    # reset cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=item GroupUserRoleMemberList()

returns a list of role/user members

    RoleID:  role id
    UserID:  user id
    RoleIDs: role ids (array ref)
    UserIDs: user ids (array ref)

    Result: HASH -> returns a hash of key => name pairs:
                     either RoleID => RoleName or UserID => UserLogin
            Name -> returns an array of user names
            ID   -> returns an array of user ids

    Example (get roles of user):

    $GroupObject->GroupUserRoleMemberList(
        UserID => $ID,
        Result => 'HASH',
    );

    Example (get users of role):

    $GroupObject->GroupUserRoleMemberList(
        RoleID => $ID,
        Result => 'HASH',
    );

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

    # create cache key
    my $CacheKey = 'GroupUserRoleMemberList::' . $Param{Result} . '::';
    my @RoleIDs;
    my @UserIDs;
    if ( $Param{RoleID} ) {
        $CacheKey .= 'RoleID::' . $Param{RoleID};
    }
    elsif ( $Param{UserID} ) {
        $CacheKey .= 'UserID::' . $Param{UserID};
    }
    elsif ( $Param{RoleIDs} ) {
        @RoleIDs = sort( @{ $Param{RoleIDs} } );
    }
    elsif ( $Param{UserIDs} ) {
        @UserIDs = sort( @{ $Param{UserIDs} } );
    }

    # check cache
    if ( $Param{RoleID} || $Param{UserID} ) {
        my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );

        if ($Cache) {
            return @{$Cache} if ref $Cache eq 'ARRAY';
            return %{$Cache} if ref $Cache eq 'HASH';
        }
    }

    my $ValidIDs = join( ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet() );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    my $SQL = "SELECT ru.role_id, ru.user_id, r.name, u.login FROM role_user ru, roles r, users u
        WHERE r.valid_id IN ($ValidIDs)
            AND r.id = ru.role_id
            AND ru.user_id = u.id
            AND u.valid_id IN ($ValidIDs)
            AND ";

    # db quote
    for (qw(RoleID UserID)) {
        $Param{$_} = $DBObject->Quote( $Param{$_}, 'Integer' );
    }

    if ( $Param{RoleID} ) {
        $SQL .= " ru.role_id = $Param{RoleID}";
    }
    elsif ( $Param{UserID} ) {
        $SQL .= " ru.user_id = $Param{UserID}";
    }
    elsif ( $Param{RoleIDs} ) {
        for my $RoleID (@RoleIDs) {
            $RoleID = $DBObject->Quote( $RoleID, 'Integer' );
        }
        $SQL .= ' ru.role_id IN (' . join( ',', @RoleIDs ) . ')';
    }
    elsif ( $Param{UserIDs} ) {
        for my $UserID (@UserIDs) {
            $UserID = $DBObject->Quote( $UserID, 'Integer' );
        }
        $SQL .= ' ru.user_id IN (' . join( ',', @UserIDs ) . ')';
    }

    my %Data;
    my @Name;
    my @ID;
    return if !$DBObject->Prepare( SQL => $SQL );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my $Key   = '';
        my $Value = '';
        if ( $Param{RoleID} || $Param{RoleIDs} ) {
            $Key   = $Row[1];
            $Value = $Row[3];
        }
        else {
            $Key   = $Row[0];
            $Value = $Row[2];
        }

        # remember permissions
        if ( !defined $Data{$Key} ) {
            $Data{$Key} = $Value;
            push @Name, $Value;
            push @ID,   $Key;
        }
    }

    # role lookup base on UserID or RoleID

    # return result
    if ( $Param{Result} && $Param{Result} eq 'ID' ) {

        # set cache
        if ( $Param{RoleID} || $Param{UserID} ) {
            $Kernel::OM->Get('Kernel::System::Cache')->Set(
                Type  => $Self->{CacheType},
                TTL   => $Self->{CacheTTL},
                Key   => $CacheKey,
                Value => \@ID,
            );
        }
        return @ID;
    }
    if ( $Param{Result} && $Param{Result} eq 'Name' ) {

        # set cache
        if ( $Param{RoleID} || $Param{UserID} ) {
            $Kernel::OM->Get('Kernel::System::Cache')->Set(
                Type  => $Self->{CacheType},
                TTL   => $Self->{CacheTTL},
                Key   => $CacheKey,
                Value => \@Name,
            );
        }
        return @Name;
    }

    # set cache
    if ( $Param{RoleID} || $Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => \%Data,
        );
    }
    return %Data;
}

=item GroupUserRoleMemberAdd()

to add a member to a role

    my $Success = $GroupObject->GroupUserRoleMemberAdd(
        UID    => 12,
        RID    => 6,
        Active => 1,
        UserID => 123,
    );

=cut

sub GroupUserRoleMemberAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(RID UID UserID)) {
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

    # delete existing relation
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM role_user WHERE user_id = ? AND role_id = ?',
        Bind => [ \$Param{UID}, \$Param{RID} ],
    );

    # return if user is not longer in role
    if ( !$Param{Active} ) {

        # reset cache
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => $Self->{CacheType},
        );

        return;
    }

    # debug
    if ( $Self->{Debug} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Add UID:$Param{UID} to RID:$Param{RID}!",
        );
    }

    # insert new permission
    return if !$DBObject->Do(
        SQL => 'INSERT INTO role_user '
            . '(role_id, user_id, create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [ \$Param{RID}, \$Param{UID}, \$Param{UserID}, \$Param{UserID} ],
    );

    # reset cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
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
        Valid => 1,
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
        'Comment'    => 'Role for helpdesk people.',
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
        Valid => 1,
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

    # log
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "Role: '$Param{Name}' ID: '$RoleID' created successfully ($Param{UserID})!",
    );

    # reset cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Role',
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

    # sql
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'UPDATE roles SET name = ?, comments = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID}
        ],
    );

    # reset cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'Role',
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
        Type => 'Role',
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
        Type => 'Role',
        Key  => 'RoleList::0',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%RoleListAll,
    );
    $CacheObject->Set(
        Type => 'Role',
        Key  => 'RoleList::1',
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
        Type => 'Role',
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
            Comment    => $Row[2],
            ValidID    => $Row[3],
            CreateTime => $Row[4],
            CreateBy   => $Row[5],
            ChangeTime => $Row[6],
            ChangeBy   => $Row[7],
        };
    }

    # set cache
    $CacheObject->Set(
        Type  => 'Role',
        Key   => 'RoleDataList',
        TTL   => 60 * 60 * 24 * 20,
        Value => \%RoleDataList,
    );

    return %RoleDataList;
}

=begin Internal:

=cut

=item _GetTypeString()

returns a string for a sql IN elements which contains a comma separted list of system permissions.

    my $TypeString = $GroupObject->_GetTypeString(
        Type => 'close',
    );

=cut

sub _GetTypeString {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # only allow valid system permissions as Type
    my @Types = grep $_ eq $Param{Type}, @{ $ConfigObject->Get('System::Permission') };
    push @Types, 'rw';
    my $TypeString = join ',', map "'$_'", @Types;

    return $TypeString;
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
