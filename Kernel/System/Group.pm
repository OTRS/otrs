# --
# Kernel/System/Group.pm - All Groups and Roles related functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Group;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::CacheInternal;

use vars qw(@ISA);

=head1 NAME

Kernel::System::Group - group and roles lib

=head1 SYNOPSIS

All group and roles functions. E. g. to add groups or to get a member list of a group.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Group;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $GroupObject = Kernel::System::Group->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject MainObject LogObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'Group',
        TTL  => 60 * 60 * 3,
    );

    return $Self;
}

=item GroupLookup()

get id or name for group

    my $Group = $GroupObject->GroupLookup( GroupID => $GroupID );

    my $GroupID = $GroupObject->GroupLookup( Group => $Group );

=cut

sub GroupLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Group} && !$Param{GroupID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Group or GroupID!' );
        return;
    }

    # check if result is cached
    my $CacheKey;
    if ( $Param{GroupID} ) {
        $CacheKey = "GroupLookup::ID::$Param{GroupID}";
    }
    elsif ( $Param{Group} ) {
        $CacheKey = "GroupLookup::Name::$Param{Group}";
    }
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return $Cache if $Cache;

    # get data
    my $SQL;
    my @Bind;
    my $Suffix;
    if ( $Param{Group} ) {
        $Param{What} = $Param{Group};
        $Suffix      = 'GroupID';
        $SQL         = 'SELECT id FROM groups WHERE name = ?';
        push @Bind, \$Param{Group};
    }
    else {
        $Param{What} = $Param{GroupID};
        $Suffix      = 'Group';
        $SQL         = 'SELECT name FROM groups WHERE id = ?';
        push @Bind, \$Param{GroupID};
    }
    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );
    my $Result;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Result = $Row[0];
    }

    # check if data exists
    if ( !$Result ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }

    # set cache
    $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => $Result );

    # return result
    return $Result;
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # insert new group
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO groups (name, comments, valid_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get new group id
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM groups WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );
    my $GroupID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $GroupID = $Row[0];
    }

    # log 
    $Self->{LogObject}->Log(
        Priority => 'info',
        Message  => "Group: '$Param{Name}' ID: '$GroupID' created successfully ($Param{UserID})!",
    );

    # reset cache
    $Self->{CacheInternalObject}->CleanUp();

    return $GroupID;
}

=item GroupGet()

returns a hash with group data

    my %GroupData = $GroupObject->GroupGet( ID => 2 );

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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT name, valid_id, comments, change_time, create_time '
            . 'FROM groups WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Group;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Group = (
            ID         => $Param{ID},
            Name       => $Data[0],
            Comment    => $Data[2],
            ValidID    => $Data[1],
            ChangeTime => $Data[3],
            CreateTime => $Data[4],
        );
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE groups SET name = ?, comments = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID}
        ],
    );

    # reset cache
    $Self->{CacheInternalObject}->CleanUp();

    return 1;
}

=item GroupList()

returns a hash of all groups

    my %Groups = $GroupObject->GroupList( Valid => 1 );

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

    my $Valid = $Param{Valid} || 0;

    # create cache key
    my $CacheKey = 'GroupList::' . $Valid;

    # check cache
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    if ( ref $Cache eq 'HASH' ) {
        return %{$Cache};
    }

    my $SQL = 'SELECT id, name FROM groups';

    if ($Valid) {

        # get valid ids
        my $ValidIDs = join( ', ', $Self->{ValidObject}->ValidIDsGet() );

        $SQL .= " WHERE valid_id IN ($ValidIDs)";
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => $SQL,
    );
    my %Groups;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $Groups{ $Data[0] } = $Data[1];
    }

    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \%Groups,
    );

    return %Groups;
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if update is needed (fetch current values)
    my %Value;
    if ( !$Self->{"GroupMemberAdd::GID::$Param{GID}"} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT group_id, user_id, permission_key, permission_value FROM '
                . 'group_user WHERE group_id = ?',
            Bind => [ \$Param{GID} ],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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
        $Self->{DBObject}->Do(
            SQL => 'DELETE FROM group_user WHERE '
                . ' group_id = ? AND user_id = ? AND permission_key = ?',
            Bind => [ \$Param{GID}, \$Param{UID}, \$Type ],
        );

        # debug
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Add UID:$Param{UID} to GID:$Param{GID}, $Type:$ValueNew!",
            );
        }

        # insert new permission (if needed)
        next TYPE if !$ValueNew;
        $Self->{DBObject}->Do(
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
    $Self->{CacheInternalObject}->CleanUp();

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !$Param{UserID} && !$Param{GroupID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserID or GroupID!' );
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
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
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
                my @ResultGroupRole = $Self->GroupRoleMemberList( %Param, RoleIDs => \@Member, );
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
        $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \@Result );

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
    $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \%Result );

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Attribute!" );
            return;
        }
    }

    # create cache key
    my $CacheKey = 'GroupMemberInvolvedList::' . $Param{Type} . '::' . $Param{UserID};

    # check cache
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return %{$Cache} if $Cache;

    # only allow valid system permissions as Type
    my $TypeString = $Self->_GetTypeString( Type => $Param{Type} );

    # get valid ids
    my $ValidID = join( ', ', $Self->{ValidObject}->ValidIDsGet() );

    # get all groups of the given user
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT DISTINCT(g.id) FROM groups g, group_user gu WHERE "
            . "g.valid_id IN ($ValidID) AND "
            . "g.id = gu.group_id AND gu.permission_value = 1 AND "
            . "gu.permission_key IN ( $TypeString ) AND gu.user_id = ?",
        Bind => [
            \$Param{UserID},
        ],
    );
    my %Groups;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Groups{ $Row[0] } = 1;
    }

    # get all roles of the given user
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT DISTINCT(ru.role_id) FROM role_user ru, roles r WHERE "
            . "r.valid_id in ($ValidID) AND r.id = ru.role_id AND ru.user_id = ?",
        Bind => [
            \$Param{UserID},
        ],
    );
    my @Roles;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @Roles, $Row[0];
    }

    # get groups of roles of given user
    if (@Roles) {
        return if !$Self->{DBObject}->Prepare(
            SQL => "SELECT DISTINCT(g.id) FROM groups g, group_role gu WHERE "
                . "g.valid_id in ($ValidID) AND g.id = gu.group_id AND "
                . "gu.permission_value = 1 AND gu.permission_key IN ( $TypeString ) AND "
                . "gu.role_id IN (" . join( ',', @Roles ) . ")",
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Groups{ $Row[0] } = 1;
        }
    }

    # get all users of the groups which are found
    my @ArrayGroups = keys %Groups;
    my %AllUsers;
    if (@ArrayGroups) {
        return if !$Self->{DBObject}->Prepare(
            SQL => "SELECT DISTINCT(gu.user_id) FROM groups g, group_user gu WHERE "
                . "g.valid_id in ($ValidID) AND g.id = gu.group_id AND "
                . "gu.permission_value = 1 AND gu.permission_key IN ( $TypeString ) AND "
                . "gu.group_id IN (" . join( ',', @ArrayGroups ) . ")",
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $AllUsers{ $Row[0] } = 1;
        }

        # get all roles of the groups
        return if !$Self->{DBObject}->Prepare(
            SQL => "SELECT DISTINCT(gu.role_id) FROM groups g, group_role gu WHERE "
                . "g.valid_id in ($ValidID) AND g.id = gu.group_id AND "
                . "gu.permission_value = 1 AND gu.permission_key IN ( $TypeString ) AND "
                . "gu.group_id IN (" . join( ',', @ArrayGroups ) . ")",
        );
        my @AllRoles;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            push @AllRoles, $Row[0];
        }

        # get all users of the roles
        if (@AllRoles) {
            return if !$Self->{DBObject}->Prepare(
                SQL => "SELECT DISTINCT(ru.user_id) FROM role_user ru, roles r WHERE "
                    . "r.valid_id in ($ValidID) AND r.id = ru.role_id AND "
                    . "ru.role_id IN (" . join( ',', @AllRoles ) . ")",
            );
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                $AllUsers{ $Row[0] } = 1;
            }
        }
    }

    # set cache
    $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \%AllUsers );

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !$Param{UserID} && !$Param{GroupID} && !$Param{UserIDs} && !$Param{GroupIDs} ) {
        $Self->{LogObject}->Log(
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
        my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
        if ($Cache) {
            return @{$Cache} if ref $Cache eq 'ARRAY';
            return %{$Cache} if ref $Cache eq 'HASH';
        }
    }

    # only allow valid system permissions as Type
    my $TypeString = $Self->_GetTypeString( Type => $Param{Type} );

    my $ValidIDs = join( ', ', $Self->{ValidObject}->ValidIDsGet() );

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
        $SQL .= 'gu.user_id = ' . $Self->{DBObject}->Quote( $Param{UserID}, 'Integer' );
    }
    elsif ( $Param{GroupID} ) {
        $SQL .= 'gu.group_id = ' . $Self->{DBObject}->Quote( $Param{GroupID}, 'Integer' );
    }
    elsif ( $Param{UserIDs} ) {
        for my $UserID (@UserIDs) {
            $UserID = $Self->{DBObject}->Quote( $UserID, 'Integer' );
        }
        $SQL .= ' ru.user_id IN (' . join( ',', @UserIDs ) . ')';
    }
    elsif ( $Param{GroupIDs} ) {
        for my $GroupID (@GroupIDs) {
            $GroupID = $Self->{DBObject}->Quote( $GroupID, 'Integer' );
        }
        $SQL .= ' gu.group_id IN (' . join( ',', @GroupIDs ) . ')';
    }

    my %Data;
    my @Name;
    my @ID;
    return if !$Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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
            $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \@ID );
        }
        return @ID;
    }
    if ( $Param{Result} eq 'Name' ) {

        # set cache
        if ( $Param{UserID} || $Param{GroupID} ) {
            $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \@Name );
        }
        return @Name;
    }

    # set cache
    if ( $Param{UserID} || $Param{GroupID} ) {
        $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \%Data );
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !$Param{RoleID} && !$Param{GroupID} && !$Param{RoleIDs} && !$Param{GroupIDs} ) {
        $Self->{LogObject}->Log(
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

        my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
        if ($Cache) {
            return @{$Cache} if ref $Cache eq 'ARRAY';
            return %{$Cache} if ref $Cache eq 'HASH';
        }
    }

    # only allow valid system permissions as Type
    my $TypeString = $Self->_GetTypeString( Type => $Param{Type} );

    # assemble the query
    my $SQL = ''
        . 'SELECT g.id, g.name, gr.permission_key, gr.permission_value, gr.role_id'
        . ' FROM groups g, group_role gr'
        . ' WHERE g.valid_id IN (' . join( ', ', $Self->{ValidObject}->ValidIDsGet() ) . ')'
        . ' AND g.id = gr.group_id'
        . ' AND gr.permission_value = 1'
        . " AND gr.permission_key IN ( $TypeString )"
        . ' AND ';

    if ( $Param{RoleID} ) {
        $SQL .= ' gr.role_id = ' . $Self->{DBObject}->Quote( $Param{RoleID}, 'Integer' );
    }
    elsif ( $Param{GroupID} ) {
        $SQL .= ' gr.group_id = ' . $Self->{DBObject}->Quote( $Param{GroupID}, 'Integer' );
    }
    elsif ( $Param{RoleIDs} ) {
        for my $RoleID (@RoleIDs) {
            $RoleID = $Self->{DBObject}->Quote( $RoleID, 'Integer' );
        }
        $SQL .= ' gr.role_id IN (' . join( ',', @RoleIDs ) . ')';
    }
    elsif ( $Param{GroupIDs} ) {
        for my $GroupID (@GroupIDs) {
            $GroupID = $Self->{DBObject}->Quote( $GroupID, 'Integer' );
        }
        $SQL .= ' gr.group_id IN (' . join( ',', @GroupIDs ) . ')';
    }

    # run the query
    return if !$Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the data
    my %Data;
    my @Name;
    my @ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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
            $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \@ID );
        }
        return @ID;
    }
    if ( $Param{Result} eq 'Name' ) {

        # set cache
        if ( $Param{RoleID} || $Param{GroupID} ) {
            $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \@Name );
        }
        return @Name;
    }

    # set cache
    if ( $Param{RoleID} || $Param{GroupID} ) {
        $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \%Data );
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if update is needed (fetch current values)
    my %Value;
    if ( !$Self->{"GroupRoleMemberAdd::GID::$Param{GID}"} ) {
        $Self->{DBObject}->Prepare(
            SQL => 'SELECT group_id, role_id, permission_key, permission_value FROM '
                . ' group_role WHERE group_id = ?',
            Bind => [ \$Param{GID} ],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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
        $Self->{DBObject}->Do(
            SQL => 'DELETE FROM group_role WHERE '
                . 'group_id = ? AND role_id = ? AND permission_key = ?',
            Bind => [ \$Param{GID}, \$Param{RID}, \$Type ],
        );

        # debug
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Add RID:$Param{RID} to GID:$Param{GID}, $Type:$ValueNew!",
            );
        }

        # insert new permission (if needed)
        next TYPE if !$ValueNew;
        $Self->{DBObject}->Do(
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
    $Self->{CacheInternalObject}->CleanUp();

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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Result!' );
        return;
    }

    if ( !$Param{RoleID} && !$Param{UserID} && !$Param{RoleIDs} && !$Param{UserIDs} ) {
        $Self->{LogObject}->Log(
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
        my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
        if ($Cache) {
            return @{$Cache} if ref $Cache eq 'ARRAY';
            return %{$Cache} if ref $Cache eq 'HASH';
        }
    }

    my $ValidIDs = join( ', ', $Self->{ValidObject}->ValidIDsGet() );

    # sql
    my $SQL = "SELECT ru.role_id, ru.user_id, r.name, u.login FROM role_user ru, roles r, users u
        WHERE r.valid_id IN ($ValidIDs)
            AND r.id = ru.role_id
            AND ru.user_id = u.id
            AND u.valid_id IN ($ValidIDs)
            AND ";

    # db quote
    for (qw(RoleID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    if ( $Param{RoleID} ) {
        $SQL .= " ru.role_id = $Param{RoleID}";
    }
    elsif ( $Param{UserID} ) {
        $SQL .= " ru.user_id = $Param{UserID}";
    }
    elsif ( $Param{RoleIDs} ) {
        for my $RoleID (@RoleIDs) {
            $RoleID = $Self->{DBObject}->Quote( $RoleID, 'Integer' );
        }
        $SQL .= ' ru.role_id IN (' . join( ',', @RoleIDs ) . ')';
    }
    elsif ( $Param{UserIDs} ) {
        for my $UserID (@UserIDs) {
            $UserID = $Self->{DBObject}->Quote( $UserID, 'Integer' );
        }
        $SQL .= ' ru.user_id IN (' . join( ',', @UserIDs ) . ')';
    }

    my %Data;
    my @Name;
    my @ID;
    return if !$Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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
            $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \@ID );
        }
        return @ID;
    }
    if ( $Param{Result} && $Param{Result} eq 'Name' ) {

        # set cache
        if ( $Param{RoleID} || $Param{UserID} ) {
            $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \@Name );
        }
        return @Name;
    }

    # set cache
    if ( $Param{RoleID} || $Param{UserID} ) {
        $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => \%Data );
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete existing relation
    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM role_user WHERE user_id = ? AND role_id = ?',
        Bind => [ \$Param{UID}, \$Param{RID} ],
    );

    # return if user is not longer in role
    if ( !$Param{Active} ) {

        # reset cache
        $Self->{CacheInternalObject}->CleanUp();

        return;
    }

    # debug
    if ( $Self->{Debug} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Add UID:$Param{UID} to RID:$Param{RID}!",
        );
    }

    # insert new permission
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO role_user '
            . '(role_id, user_id, create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [ \$Param{RID}, \$Param{UID}, \$Param{UserID}, \$Param{UserID} ],
    );

    # reset cache
    $Self->{CacheInternalObject}->CleanUp();

    return 1;
}

=item RoleLookup()

get id or name for role

    my $Role = $RoleObject->RoleLookup( RoleID => $RoleID );

    my $RoleID = $RoleObject->RoleLookup( Role => $Role );

=cut

sub RoleLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Role} && !$Param{RoleID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no Role or RoleID!' );
        return;
    }

    # check if result is cached
    my $CacheKey;
    if ( $Param{RoleID} ) {
        $CacheKey = "RoleLookup::ID::$Param{RoleID}";
    }
    elsif ( $Param{Role} ) {
        $CacheKey = "RoleLookup::Name::$Param{Role}";
    }
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return $Cache if $Cache;

    # get data
    my $SQL;
    my @Bind;
    my $Suffix;
    if ( $Param{Role} ) {
        $Param{What} = $Param{Role};
        $Suffix      = 'RoleID';
        $SQL         = 'SELECT id FROM roles WHERE name = ?';
        push @Bind, \$Param{Role};
    }
    else {
        $Param{What} = $Param{RoleID};
        $Suffix      = 'Role';
        $SQL         = 'SELECT name FROM roles WHERE id = ?';
        push @Bind, \$Param{RoleID};
    }
    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );
    my $Result;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Result = $Row[0];
    }

    # check if data exists
    if ( !$Result ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }

    # set cache
    $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => $Result );

    # return result
    return $Result;
}

=item RoleGet()

returns a hash with role data

    my %RoleData = $GroupObject->RoleGet( ID => 2 );

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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT name, valid_id, comments, change_time, create_time FROM roles WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Role;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Role = (
            ID         => $Param{ID},
            Name       => $Data[0],
            Comment    => $Data[2],
            ValidID    => $Data[1],
            ChangeTime => $Data[3],
            CreateTime => $Data[4],
        );
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # insert
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO roles (name, comments, valid_id, '
            . 'create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID}
        ],
    );

    # get new group id
    my $RoleID;
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM roles WHERE name = ?',
        Bind => [ \$Param{Name}, ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $RoleID = $Row[0];
    }

    # log
    $Self->{LogObject}->Log(
        Priority => 'info',
        Message  => "Role: '$Param{Name}' ID: '$RoleID' created successfully ($Param{UserID})!",
    );

    # reset cache
    $Self->{CacheInternalObject}->CleanUp();

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE roles SET name = ?, comments = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID}
        ],
    );

    # reset cache
    $Self->{CacheInternalObject}->CleanUp();

    return 1;
}

=item RoleList()

returns a hash of all roles

    my %Roles = $GroupObject->RoleList( Valid => 1 );

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

    my $Valid = $Param{Valid} || 0;

    # create cache key
    my $CacheKey = 'RoleList::' . $Valid;

    # check cache
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    if ( ref $Cache eq 'HASH' ) {
        return %{$Cache};
    }

    my $SQL = 'SELECT id, name FROM roles';

    if ($Valid) {

        # get valid ids
        my $ValidIDs = join( ', ', $Self->{ValidObject}->ValidIDsGet() );

        $SQL .= " WHERE valid_id IN ($ValidIDs)";
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => $SQL,
    );
    my %Roles;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $Roles{ $Data[0] } = $Data[1];
    }

    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \%Roles,
    );

    return %Roles;
}

=begin Internal:

=cut

=item _GetTypeString()

returns a string for a sql IN elements which contains a comma separted list of system permissions.

    my $TypeString = $GroupObject->_GetTypeString(Type => 'close');

=cut

sub _GetTypeString {
    my ( $Self, %Param ) = @_;

    # only allow valid system permissions as Type
    my @Types = grep $_ eq $Param{Type}, @{ $Self->{ConfigObject}->Get('System::Permission') };
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
