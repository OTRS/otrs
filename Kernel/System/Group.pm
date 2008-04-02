# --
# Kernel/System/Group.pm - All Groups related function should be here eventually
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Group.pm,v 1.55 2008-04-02 04:52:27 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Group;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.55 $) [1];

=head1 NAME

Kernel::System::Group - group lib

=head1 SYNOPSIS

All group functions. E. g. to add groups or to get a member list of a group.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Group;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        MainObject => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $GroupObject = Kernel::System::Group->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

=item GroupLookup()

get id or name for group

    my $Group = $GroupObject->GroupLookup(GroupID => $GroupID);

    my $GroupID = $GroupObject->GroupLookup(Group => $Group);

=cut

sub GroupLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Group} && !$Param{GroupID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Got no Group or GroupID!" );
        return;
    }

    # check if we can answer from our cache
    if ( $Param{GroupID} && $Self->{"GL::Group$Param{GroupID}"} ) {
        return $Self->{"GL::Group$Param{GroupID}"};
    }
    if ( $Param{Group} && $Self->{"GL::GroupID$Param{Group}"} ) {
        return $Self->{"GL::GroupID$Param{Group}"};
    }

    # get data
    my $SQL;
    my @Bind;
    my $Suffix;
    if ( $Param{Group} ) {
        $Param{What} = $Param{Group};
        $Suffix      = 'GroupID';
        $SQL         = "SELECT id FROM groups WHERE name = ?";
        push @Bind, \$Param{Group};
    }
    else {
        $Param{What} = $Param{GroupID};
        $Suffix      = 'Group';
        $SQL         = "SELECT name FROM groups WHERE id = ?";
        push @Bind, \$Param{GroupID};
    }
    return if ! $Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # store result
        $Self->{"GL::$Suffix$Param{What}"} = $Row[0];
    }

    # check if data exists
    if ( !exists $Self->{"GL::$Suffix$Param{What}"} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }

    # return result
    return $Self->{"GL::$Suffix$Param{What}"};
}

=item RoleLookup()

get id or name for role

    my $Role = $RoleObject->RoleLookup(RoleID => $RoleID);

    my $RoleID = $RoleObject->RoleLookup(Role => $Role);

=cut

sub RoleLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Role} && !$Param{RoleID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Got no Role or RoleID!" );
        return;
    }

    # check if we can answer from our cache
    if ( $Param{RoleID} && $Self->{"RL::Role$Param{RoleID}"} ) {
        return $Self->{"RL::Role$Param{RoleID}"};
    }
    if ( $Param{Role} && $Self->{"RL::RoleID$Param{Role}"} ) {
        return $Self->{"RL::RoleID$Param{Role}"};
    }

    # get data
    my $SQL;
    my @Bind;
    my $Suffix;
    if ( $Param{Role} ) {
        $Param{What} = $Param{Role};
        $Suffix      = 'RoleID';
        $SQL         = "SELECT id FROM roles WHERE name = ?";
        push @Bind, \$Param{Role};
    }
    else {
        $Param{What} = $Param{RoleID};
        $Suffix      = 'Role';
        $SQL         = "SELECT name FROM roles WHERE id = ?";
        push @Bind, \$Param{RoleID};
    }
    return if ! $Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # store result
        $Self->{"RL::$Suffix$Param{What}"} = $Row[0];
    }

    # check if data exists
    if ( !exists $Self->{"RL::$Suffix$Param{What}"} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }

    # return result
    return $Self->{"RL::$Suffix$Param{What}"};
}

=item GroupMemberAdd()

to add a member to a group

    Permission: ro,move_into,priority,create,rw

    $GroupObject->GroupMemberAdd(
        GID => 12,
        UID => 6,
        Permission => {
            ro => 1,
            move_into => 1,
            create => 1,
            owner => 1,
            priority => 0,
            rw => 0,
        },
        UserID => 123,
    );

=cut

sub GroupMemberAdd {
    my ( $Self, %Param ) = @_;

    my $Count;

    # check needed stuff
    for (qw(UID GID UserID Permission)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if update is needed
    my %Value = ();
    if ( !$Self->{"GroupMemberAdd::GID::$Param{GID}"} ) {
        return if ! $Self->{DBObject}->Prepare(
            SQL => "SELECT group_id, user_id, permission_key, permission_value FROM "
                . " group_user WHERE group_id = ?",
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

    # update permission
    for my $Type ( keys %{ $Param{Permission} } ) {

        # check if update is needed
        if (   ( !$Value{ $Param{GID} }->{ $Param{UID} }->{$Type} && !$Param{Permission}->{$Type} )
            || ( $Value{ $Param{GID} }->{ $Param{UID} }->{$Type} && $Param{Permission}->{$Type} ) )
        {

#            print STDERR "No updated neede! UID:$Param{UID} to GID:$Param{GID}, $Type:$Param{Permission}->{$Type}!\n";
        }
        else {
            $Self->{"GroupMemberAdd::GID::$Param{GID}"} = undef;

#            print STDERR "Updated needed! UID:$Param{UID} to GID:$Param{GID}, $Type:$Param{Permission}->{$Type}!\n";
# delete existing permission
            $Self->{DBObject}->Do(
                SQL => "DELETE FROM group_user WHERE "
                    . " group_id = ? AND user_id = ? AND permission_key = ?",
                Bind => [ \$Param{GID}, \$Param{UID}, \$Type],
            );

            # debug
            if ( $Self->{Debug} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Add UID:$Param{UID} to GID:$Param{GID}, $Type:$Param{Permission}->{$Type}!",
                );
            }

            # insert new permission
            $Self->{DBObject}->Do(
                SQL  => "INSERT INTO group_user "
                    . " (user_id, group_id, permission_key, permission_value, "
                    . " create_time, create_by, change_time, change_by) "
                    . " VALUES "
                    . " (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)",
                Bind => [
                    \$Param{UID}, \$Param{GID}, \$Type, \$Param{Permission}->{$Type}, \$Param{UserID}, \$Param{UserID},
                ],
             );
        }
    }
    return 1;
}

=item GroupAdd()

to add a group

    my $ID = $GroupObject->GroupAdd(
        Name => 'example-group',
        ValidID => 1,
        UserID => 123,
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
    return if ! $Self->{DBObject}->Do(
        SQL  => "INSERT INTO groups (name, comments, valid_id, "
            . " create_time, create_by, change_time, change_by)"
            . " VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)",
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get new group id
    return if ! $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM groups WHERE name = ?",
        Bind => [ \$Param{Name} ],
    );
    my $GroupID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $GroupID = $Row[0];
    }

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message => "Group: '$Param{Name}' ID: '$GroupID' created successfully ($Param{UserID})!",
    );
    return $GroupID;
}

=item GroupGet()

returns a hash with group data

    %GroupData = $GroupObject->GroupGet(ID => 2);

=cut

sub GroupGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # sql
    return if ! $Self->{DBObject}->Prepare(
        SQL => "SELECT name, valid_id, comments, change_time, create_time "
            . " FROM groups WHERE id = ?",
        Bind => [ \$Param{ID} ],
    );
    my %GroupData = ();
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %GroupData = (
            ID         => $Param{ID},
            Name       => $Data[0],
            Comment    => $Data[2],
            ValidID    => $Data[1],
            ChangeTime => $Data[3],
            CreateTime => $Data[4],
        );
    }
    return %GroupData;
}

=item GroupUpdate()

update of a group

    $GroupObject->GroupUpdate(
        ID => 123,
        Name => 'example-group',
        ValidID => 1,
        UserID => 123,
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
    return $Self->{DBObject}->Do(
        SQL  => "UPDATE groups SET name = ?, comments = ?, valid_id = ?, "
            . "change_time = current_timestamp, change_by = ? WHERE id = ?",
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID}
        ],
    );
}

=item GroupList()

returns a hash of all groups

    my %Groups = $GroupObject->GroupList(Valid => 1);

=cut

sub GroupList {
    my ( $Self, %Param ) = @_;

    my $Valid = $Param{Valid} || 0;
    my %Groups = $Self->{DBObject}->GetTableData(
        What  => 'id, name',
        Table => 'groups',
        Valid => $Valid,
    );
    return %Groups;
}

=item GroupMemberList()

returns a list of users/groups with ro/move_into/create/owner/priority/rw permissions
based on GroupGroupMemberList() and GroupRoleMemberList().

    UserID: user id
    GroupID: group id

    Type: ro|move_into|priority|create|rw

    Result: HASH -> returns a hash of key => group id, value => group name
            Name -> returns an array of user names
            ID   -> returns an array of user ids

    Example (get groups of user):

    my %Groups = $GroupObject->GroupMemberList(
        UserID => $ID,
        Type => 'move_into',
        Result => 'HASH',
    );

    Example (get users of group):

    my %Users = $GroupObject->GroupMemberList(
        GroupID => $ID,
        Type => 'move_into',
        Result => 'HASH',
    );

    Attention: The user ids (keys) in the hash returned from this function
               are correct, however the values are not correspond to the user ids.
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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserID or GroupID!" );
        return;
    }

    # create cache key
    my $CacheKey = 'GroupMemberList::' . $Param{Type} . '::' . $Param{Result} . '::';
    if ( $Param{UserID} ) {
        $CacheKey .= 'UserID::' . $Param{UserID};
    }
    else {
        $CacheKey .= 'GroupID::' . $Param{GroupID};
    }

    # check cache
    if ( $Self->{ForceCache} ) {
        $Param{Cached} = $Self->{ForceCache};
    }
    if ( $Param{Cached} && exists( $Self->{$CacheKey} ) ) {

        if ( ref( $Self->{$CacheKey} ) eq 'ARRAY' ) {
            return @{ $Self->{$CacheKey} };
        }
        elsif ( ref( $Self->{$CacheKey} ) eq 'HASH' ) {
            return %{ $Self->{$CacheKey} };
        }
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
                for (@ResultGroupRole) {
                    push @Result, $_ ;
                }
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
                for (@ResultGroupUserRole) {
                    push @Result, $_;
                }
            }
        }

        # cache result
        $Self->{$CacheKey} = \@Result;
        return @Result;
    }
    else {
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

        $Self->{$CacheKey} = \%Result;
        return %Result;
    }
}

=item GroupMemberInvolvedList()

returns a list of users/groups with ro/move_into/create/owner/priority/rw permissions

    %Users = $GroupObject->GroupMemberInvolvedList(
        UserID => $ID,
        Type => 'move_into',
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

    # quote
    for (qw(Type)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    for (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # get valid ids
    my $ValidID = join(', ', $Self->{ValidObject}->ValidIDsGet());

    # get all groups of the given user
    my %Groups;
    my $SQL = "SELECT DISTINCT(g.id) FROM groups g, group_user gu "
        . "WHERE g.valid_id IN ($ValidID) AND "
        . "g.id = gu.group_id AND "
        . "gu.permission_value = 1 AND "
        . "gu.permission_key IN ('$Param{Type}', 'rw') AND "
        . "gu.user_id = $Param{UserID}";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Groups{ $Row[0] } = 1;
    }

    # get all roles of the given user
    $SQL = "SELECT DISTINCT(ru.role_id) FROM role_user ru, roles r "
        . "WHERE r.valid_id in ($ValidID) AND "
        . "r.id = ru.role_id AND "
        . "ru.user_id = $Param{UserID}";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    my @Roles;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push( @Roles, $Row[0] );
    }

    # get groups of roles of given user
    if (@Roles) {
        my $SQL = "SELECT DISTINCT(g.id) FROM groups g, group_role gu "
            . "WHERE g.valid_id in ($ValidID) AND "
            . " g.id = gu.group_id AND "
            . " gu.permission_value = 1 AND "
            . "gu.permission_key IN ('$Param{Type}', 'rw') AND "
            . "gu.role_id IN (".join(',', @Roles).")";
        $Self->{DBObject}->Prepare( SQL => $SQL );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Groups{ $Row[0] } = 1;
        }
    }

    # get all users of the groups which are found
    my @ArrayGroups = keys %Groups;
    my %AllUsers;
    if (@ArrayGroups) {
        my $SQL = "SELECT DISTINCT(gu.user_id) FROM groups g, group_user gu WHERE "
            . "g.valid_id in ($ValidID) AND "
            . "g.id = gu.group_id AND "
            . "gu.permission_value = 1 AND "
            . "gu.permission_key IN ('$Param{Type}', 'rw') AND "
            . "gu.group_id IN (".join(',', @ArrayGroups).")";
        $Self->{DBObject}->Prepare( SQL => $SQL );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $AllUsers{ $Row[0] } = 1;
        }

        # get all roles of the groups
        $SQL = "SELECT DISTINCT(gu.role_id) FROM groups g, group_role gu WHERE "
            . "g.valid_id in ($ValidID) AND "
            . "g.id = gu.group_id AND "
            . "gu.permission_value = 1 AND "
            . "gu.permission_key IN ('$Param{Type}', 'rw') AND "
            . "gu.group_id IN (".join(',', @ArrayGroups).")";
        $Self->{DBObject}->Prepare( SQL => $SQL );
        my @AllRoles;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            push( @AllRoles, $Row[0] );
        }

        # get all users of the roles
        if (@AllRoles) {
            $SQL = "SELECT DISTINCT(ru.user_id) FROM role_user ru, roles r WHERE "
                . "r.valid_id in ($ValidID) AND "
                . "r.id = ru.role_id AND "
                . " ru.role_id IN (".join(',', @AllRoles).")";
            $Self->{DBObject}->Prepare( SQL => $SQL );
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                $AllUsers{ $Row[0] } = 1;
            }
        }
    }

    return %AllUsers;
}

=item GroupGroupMemberList()

returns a list of users/groups with ro/move_into/create/owner/priority/rw permissions

    UserID: user id
    GroupID: group id
    UserIDs: user ids (array ref)
    GroupIDs: group ids (array ref)

    Type: ro|move_into|priority|create|rw

    Result: HASH -> returns a hash of key => group id, value => group name
            Name -> returns an array of user names
            ID   -> returns an array of user ids

    Example (get groups of user):

    $GroupObject->GroupGroupMemberList(
        UserID => $ID,
        Type => 'move_into',
        Result => 'HASH',
    );

    Example (get users of group):

    $GroupObject->GroupGroupMemberList(
        GroupID => $ID,
        Type => 'move_into',
        Result => 'HASH',
    );

=cut

sub GroupGroupMemberList {
    my ( $Self, %Param ) = @_;

    my @UserIDs;
    my @GroupIDs;

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
            Message  => "Need UserID or GroupID or UserIDs or GroupIDs!"
        );
        return;
    }

    # create cache key
    my $CacheKey = 'GroupGroupMemberList::' . $Param{Type} . '::' . $Param{Result} . '::';
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
        if ( $Self->{ForceCache} ) {
            $Param{Cached} = $Self->{ForceCache};
        }
        if ( $Param{Cached} && $Self->{$CacheKey} ) {
            if ( ref( $Self->{$CacheKey} ) eq 'ARRAY' ) {
                return @{ $Self->{$CacheKey} };
            }
            elsif ( ref( $Self->{$CacheKey} ) eq 'HASH' ) {
                return %{ $Self->{$CacheKey} };
            }
        }
    }

    # db quote
    $Param{Type} = $Self->{DBObject}->Quote( $Param{Type} );

    # sql
    my %Data = ();
    my @Name = ();
    my @ID   = ();
    my $SQL = "SELECT g.id, g.name, gu.permission_key, gu.permission_value, "
        . " gu.user_id "
        . " FROM "
        . " groups g, group_user gu"
        . " WHERE "
        . " g.valid_id IN (".join(', ', $Self->{ValidObject}->ValidIDsGet()).") AND "
        . " g.id = gu.group_id AND "
        . " gu.permission_value = 1 AND "
        . " gu.permission_key IN ('$Param{Type}', 'rw') AND ";
    if ( $Param{UserID} ) {
        $SQL .= " gu.user_id = " . $Self->{DBObject}->Quote( $Param{UserID}, 'Integer' );
    }
    elsif ( $Param{GroupID} ) {
        $SQL .= " gu.group_id = " . $Self->{DBObject}->Quote( $Param{GroupID}, 'Integer' );
    }
    elsif ( $Param{UserIDs} ) {
        for my $UserID (@UserIDs) {
            $UserID = $Self->{DBObject}->Quote( $UserID, 'Integer' );
        }
        $SQL .= " ru.user_id IN (".join( ',', @UserIDs ).")";
    }
    elsif ( $Param{GroupIDs} ) {
        for my $GroupID (@GroupIDs) {
            $GroupID = $Self->{DBObject}->Quote( $GroupID, 'Integer' );
        }
        $SQL .= " gu.group_id IN (".join( ',', @GroupIDs ).")";
    }

    $Self->{DBObject}->Prepare( SQL => $SQL );
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
        if ( !defined( $Data{$Key} ) ) {
            $Data{$Key} = $Value;
            push @Name, $Value;
            push @ID,   $Key;
        }
    }

    # role lookup base on UserID or GroupID

    # return result
    if ( $Param{Result} && $Param{Result} eq 'ID' ) {
        if ( $Param{UserID} || $Param{GroupID} ) {

            # cache result
            $Self->{$CacheKey} = \@ID;
        }
        return @ID;
    }
    if ( $Param{Result} && $Param{Result} eq 'Name' ) {
        if ( $Param{UserID} || $Param{GroupID} ) {

            # cache result
            $Self->{$CacheKey} = \@Name;
        }
        return @Name;
    }

    if ( $Param{UserID} || $Param{GroupID} ) {

        # cache result
        $Self->{$CacheKey} = \%Data;
    }
    return %Data;
}

=item GroupRoleMemberList()

returns a list of role/groups with ro/move_into/create/owner/priority/rw permissions

    RoleID: role id
    GroupID: group id
    RoleIDs: role id (array ref)
    GroupIDs: group id (array ref)

    Type: ro|move_into|priority|create|rw

    Result: HASH -> returns a hash of key => group id, value => group name
            Name -> returns an array of user names
            ID   -> returns an array of user ids

    Example (get groups of role):

    $GroupObject->GroupRoleMemberList(
        RoleID => $ID,
        Type => 'move_into',
        Result => 'HASH',
    );

    Example (get roles of group):

    $GroupObject->GroupRoleMemberList(
        GroupID => $ID,
        Type => 'move_into',
        Result => 'HASH',
    );

=cut

sub GroupRoleMemberList {
    my ( $Self, %Param ) = @_;

    my @RoleIDs;
    my @GroupIDs;

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
            Message  => "Need RoleID or GroupID or RoleIDs or GroupIDs!"
        );
        return;
    }

    # create cache key
    my $CacheKey = 'GroupRoleMemberList::' . $Param{Type} . '::' . $Param{Result} . '::';
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
        if ( $Self->{ForceCache} ) {
            $Param{Cached} = $Self->{ForceCache};
        }
        if ( $Param{Cached} && $Self->{$CacheKey} ) {
            if ( ref( $Self->{$CacheKey} ) eq 'ARRAY' ) {
                return @{ $Self->{$CacheKey} };
            }
            elsif ( ref( $Self->{$CacheKey} ) eq 'HASH' ) {
                return %{ $Self->{$CacheKey} };
            }
        }
    }

    # db quote
    $Param{Type} = $Self->{DBObject}->Quote( $Param{Type} );

    # sql
    my %Data = ();
    my @Name = ();
    my @ID   = ();
    my $SQL = "SELECT g.id, g.name, gu.permission_key, gu.permission_value, "
        . " gu.role_id "
        . " FROM "
        . " groups g, group_role gu"
        . " WHERE "
        . " g.valid_id IN (".join(', ', $Self->{ValidObject}->ValidIDsGet()). ") AND "
        . " g.id = gu.group_id AND "
        . " gu.permission_value = 1 AND "
        . " gu.permission_key IN ('$Param{Type}', 'rw') AND ";
    if ( $Param{RoleID} ) {
        $SQL .= " gu.role_id = " . $Self->{DBObject}->Quote( $Param{RoleID}, 'Integer' );
    }
    elsif ( $Param{GroupID} ) {
        $SQL .= " gu.group_id = " . $Self->{DBObject}->Quote( $Param{GroupID}, 'Integer' );
    }
    elsif ( $Param{RoleIDs} ) {
        for my $RoleID (@RoleIDs) {
            $RoleID = $Self->{DBObject}->Quote( $RoleID, 'Integer' );
        }
        $SQL .= " gu.role_id IN (".join( ',', @RoleIDs ).")";
    }
    elsif ( $Param{GroupIDs} ) {
        for my $GroupID (@GroupIDs) {
            $GroupID = $Self->{DBObject}->Quote( $GroupID, 'Integer' );
        }
        $SQL .= " gu.group_id IN (".join( ',', @GroupIDs ).")";
    }

    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my $Key   = '';
        my $Value = '';
        if ( $Param{RoleID} || $Param{RoleIDs} ) {
            $Key   = $Row[0];
            $Value = $Row[1];
        }
        else {
            $Key   = $Row[4];
            $Value = $Row[1];
        }

        # remember permissions
        if ( !defined( $Data{$Key} ) ) {
            $Data{$Key} = $Value;
            push @Name, $Value;
            push @ID,   $Key;
        }
    }

    # role lookup base on UserID or GroupID

    # return result
    if ( $Param{Result} && $Param{Result} eq 'ID' ) {
        if ( $Param{RoleID} || $Param{GroupID} ) {

            # cache result
            $Self->{$CacheKey} = \@ID;
        }
        return @ID;
    }
    if ( $Param{Result} && $Param{Result} eq 'Name' ) {
        if ( $Param{RoleID} || $Param{GroupID} ) {

            # cache result
            $Self->{$CacheKey} = \@Name;
        }
        return @Name;
    }

    if ( $Param{RoleID} || $Param{GroupID} ) {

        # cache result
        $Self->{$CacheKey} = \%Data;
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
            ro => 1,
            move_into => 1,
            create => 1,
            owner => 1,
            priority => 0,
            rw => 0,
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

    # check if update is needed
    my %Value = ();
    if ( !$Self->{"GroupRoleMemberAdd::GID::$Param{GID}"} ) {
        $Self->{DBObject}->Prepare(
            SQL  => "SELECT group_id, role_id, permission_key, permission_value FROM "
                . " group_role WHERE group_id = ?",
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

    # update permission
    for my $Type ( keys %{ $Param{Permission} } ) {

        # check if update is needed
        if ( ( !$Value{ $Param{GID} }->{ $Param{RID} }->{$Type} && !$Param{Permission}->{$Type} )
            || ( $Value{ $Param{GID} }->{ $Param{RID} }->{$Type} && $Param{Permission}->{$Type} ) )
        {

#            print STDERR "No updated neede! UID:$Param{UID} to GID:$Param{GID}, $Type:$Param{Permission}->{$Type}!\n";
        }
        else {

#            print STDERR "Updated neede! UID:$Param{UID} to GID:$Param{GID}, $Type:$Param{Permission}->{$Type}!\n";
# delete existing permission
            $Self->{DBObject}->Do(
                SQL =>  "DELETE FROM group_role WHERE "
                    . " group_id = ? AND role_id = ? AND permission_key = ?",
                Bind => [ \$Param{GID}, \$Param{RID}, \$Type ],
            );

            # debug
            if ( $Self->{Debug} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Add RID:$Param{RID} to GID:$Param{GID}, $Type:$Param{Permission}->{$Type}!",
                );
            }

            # insert new permission
            $Self->{DBObject}->Do(
                SQL  => "INSERT INTO group_role "
                    . " (role_id, group_id, permission_key, permission_value, "
                    . " create_time, create_by, change_time, change_by) "
                    . " VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)",
                Bind => [
                    \$Param{RID}, \$Param{GID}, \$Type, \$Param{Permission}->{$Type}, \$Param{UserID}, \$Param{UserID},
                ],
            );
        }
    }
    return 1;
}

=item GroupUserRoleMemberList()

returns a list of role/user members

    RoleID: role id
    UserID: user id
    RoleIDs: role ids (array ref)
    UserIDs: user ids (array ref)

    Result: HASH -> returns a hash of key => group id, value => group name
            Name -> returns an array of user names
            ID   -> returns an array of user ids

    Example (get roles of user):

    $GroupObject->GroupUserRoleMemberList(
        UserID => $ID,
        Result => 'HASH',
    );

    Example (get user of roles):

    $GroupObject->GroupUserRoleMemberList(
        RoleID => $ID,
        Result => 'HASH',
    );

=cut

sub GroupUserRoleMemberList {
    my ( $Self, %Param ) = @_;

    my @RoleIDs;
    my @UserIDs;

    # check needed stuff
    for (qw(Result)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !$Param{RoleID} && !$Param{UserID} && !$Param{RoleIDs} && !$Param{UserIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need RoleID or UserID or RoleIDs or UserIDs!",
        );
        return;
    }

    # db quote
    for (qw(RoleID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # create cache key
    my $CacheKey = 'GroupUserRoleMemberList::' . $Param{Result} . '::';
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
        if ( $Self->{ForceCache} ) {
            $Param{Cached} = $Self->{ForceCache};
        }
        if ( $Param{Cached} && $Self->{$CacheKey} ) {
            if ( ref( $Self->{$CacheKey} ) eq 'ARRAY' ) {
                return @{ $Self->{$CacheKey} };
            }
            elsif ( ref( $Self->{$CacheKey} ) eq 'HASH' ) {
                return %{ $Self->{$CacheKey} };
            }
        }
    }

    # sql
    my %Data = ();
    my @Name = ();
    my @ID   = ();
    my $SQL = "SELECT ru.role_id, ru.user_id, r.name "
        . " FROM "
        . " role_user ru, roles r"
        . " WHERE "
        . " r.valid_id IN (".join(', ', $Self->{ValidObject}->ValidIDsGet()). ") AND "
        . " r.id = ru.role_id AND ";
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
        $SQL .= " ru.role_id IN (".join( ',', @RoleIDs ).")";
    }
    elsif ( $Param{UserIDs} ) {
        for my $UserID (@UserIDs) {
            $UserID = $Self->{DBObject}->Quote( $UserID, 'Integer' );
        }
        $SQL .= " ru.user_id IN (".join( ',', @UserIDs ).")";
    }

    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my $Key   = '';
        my $Value = '';
        if ( $Param{RoleID} || $Param{RoleIDs} ) {
            $Key   = $Row[1];
            $Value = $Row[0];
        }
        else {
            $Key   = $Row[0];
            $Value = $Row[1];
        }

        # remember permissions
        if ( !defined( $Data{$Key} ) ) {
            $Data{$Key} = $Value;
            push( @Name, $Value );
            push( @ID,   $Key );
        }
    }

    # role lookup base on UserID or GroupID

    # return result
    if ( $Param{Result} && $Param{Result} eq 'ID' ) {
        if ( $Param{RoleID} || $Param{UserID} ) {

            # cache result
            $Self->{$CacheKey} = \@ID;
        }
        return @ID;
    }
    if ( $Param{Result} && $Param{Result} eq 'Name' ) {
        if ( $Param{RoleID} || $Param{UserID} ) {

            # cache result
            $Self->{$CacheKey} = \@Name;
        }
        return @Name;
    }
    else {
        if ( $Param{RoleID} || $Param{UserID} ) {

            # cache result
            $Self->{$CacheKey} = \%Data;
        }
        return %Data;
    }
}

=item GroupUserRoleMemberAdd()

to add a member to a role

    $GroupObject->GroupUserRoleMemberAdd(
        UID => 12,
        RID => 6,
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
    return if ! $Self->{DBObject}->Do(
        SQL => "DELETE FROM role_user WHERE user_id = ? AND role_id = ?",
        Bind => [ \$Param{UID}, \$Param{RID} ],
    );
    if ( ! $Param{Active} ) {
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
    return $Self->{DBObject}->Do(
        SQL  => "INSERT INTO role_user "
            . " (role_id, user_id, create_time, create_by, change_time, change_by) "
            . " VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)",
        Bind => [ \$Param{RID}, \$Param{UID}, \$Param{UserID}, \$Param{UserID} ],
    );
}

=item RoleAdd()

to add a new role

    my $ID = $GroupObject->RoleAdd(
        Name => 'example-group',
        ValidID => 1,
        UserID => 123,
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
    return if ! $Self->{DBObject}->Do(
        SQL => "INSERT INTO roles (name, comments, valid_id, "
            . " create_time, create_by, change_time, change_by)"
            . " VALUES (?, ?, ?, current_timestamp, ?, current_timestamp, ?)",
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID}
        ],
    );

    # get new group id
    my $RoleID;
    return if ! $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM roles WHERE name = ?",
        Bind => [ \$Param{Name}, ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $RoleID = $Row[0];
    }

    # log notice
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "Role: '$Param{Name}' ID: '$RoleID' created successfully ($Param{UserID})!",
    );
    return $RoleID;
}

=item RoleGet()

returns a hash with role data

    %RoleData = $GroupObject->RoleGet(ID => 2);

=cut

sub RoleGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT name, valid_id, comments, change_time, create_time "
            . " FROM roles WHERE id = ?",
        Bind => [ \$Param{ID} ],
    );
    my %Role = ();
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

=item RoleUpdate()

update of a role

    $GroupObject->RoleUpdate(
        ID => 123,
        Name => 'example-group',
        ValidID => 1,
        UserID => 123,
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
    return $Self->{DBObject}->Do(
        SQL => "UPDATE roles SET name = ?, comments = ?, valid_id = ?, "
            . " change_time = current_timestamp, change_by = ? WHERE id = ?",
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID}
        ],
    );
}

=item RoleList()

returns a hash of all roles

    my %Roles = $GroupObject->RoleList(Valid => 1);

=cut

sub RoleList {
    my ( $Self, %Param ) = @_;

    my $Valid = $Param{Valid} || 0;
    my %Roles = $Self->{DBObject}->GetTableData(
        What  => 'id, name',
        Table => 'roles',
        Valid => $Valid,
    );
    return %Roles;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.55 $ $Date: 2008-04-02 04:52:27 $

=cut
