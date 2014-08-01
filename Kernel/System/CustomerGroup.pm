# --
# Kernel/System/CustomerGroup.pm - All CustomerGroups related functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerGroup;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Valid',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::CustomerGroup - customer group lib

=head1 SYNOPSIS

All customer group functions. E. g. to add groups or to get a member list of a group.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CustomerGroupObject = $Kernel::OM->Get('Kernel::System::CustomerGroup');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{DBObject} = $Kernel::OM->Get('Kernel::System::DB');

    $Self->{CacheType} = 'CustomerGroup';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=item GroupMemberAdd()

to add a member to a group

    Permission: ro,move_into,priority,create,rw

    my $Success = $CustomerGroupObject->GroupMemberAdd(
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
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check rw rule (set only rw and remove rest, because it's including all in rw)
    if ( $Param{Permission}->{rw} ) {
        %{ $Param{Permission} } = ( rw => 1 );
    }

    # update permission
    TYPE:
    for my $Type ( sort keys %{ $Param{Permission} } ) {

        # delete existing permission
        $Self->{DBObject}->Do(
            SQL => 'DELETE FROM group_customer_user WHERE '
                . ' group_id = ? AND user_id = ? AND permission_key = ?',
            Bind => [ \$Param{GID}, \$Param{UID}, \$Type ],
        );

        # debug
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message =>
                    "Add UID:$Param{UID} to GID:$Param{GID}, $Type:$Param{Permission}->{$Type}!",
            );
        }

        # insert new permission (if needed)
        next TYPE if !$Param{Permission}->{$Type};
        $Self->{DBObject}->Do(
            SQL => 'INSERT INTO group_customer_user '
                . '(user_id, group_id, permission_key, permission_value, '
                . 'create_time, create_by, change_time, change_by) '
                . 'VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
            Bind => [
                \$Param{UID}, \$Param{GID}, \$Type, \$Param{Permission}->{$Type}, \$Param{UserID},
                \$Param{UserID},
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

if GroupID is passed:
returns a list of users of a group with ro/move_into/create/owner/priority/rw permissions

if UserID is passed:
returns a list of groups for userID with ro/move_into/create/owner/priority/rw permissions
    UserID: user id
    GroupID: group id
    Type: ro|move_into|priority|create|rw
    Result: HASH -> returns a hash of key => group id, value => group name
            Name -> returns an array of user names
            ID   -> returns an array of user names
    Example:
    $CustomerGroupObject->GroupMemberList(
        UserID => $ID,
        Type   => 'move_into',
        Result => 'HASH',
    );

=cut

sub GroupMemberList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Result Type)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !$Param{UserID} && !$Param{GroupID} ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need UserID or GroupID!' );
        return;
    }
    my %Data;
    my @Name;
    my @ID;

    # check if customer group feature is active, if not, return all groups
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupSupport') ) {

        # get permissions
        %Data = $Kernel::OM->Get('Kernel::System::Group')->GroupList( Valid => 1 );
        for ( sort keys %Data ) {
            push @Name, $Data{$_};
            push @ID,   $_;
        }
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

    # if it's active, return just the permitted groups
    my $SQL = "SELECT g.id, g.name, gu.permission_key, gu.permission_value, gu.user_id "
        . " FROM groups g, group_customer_user gu WHERE "
        . " g.valid_id IN ( ${\(join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet())} ) AND "
        . " g.id = gu.group_id AND gu.permission_value = 1 AND "
        . " gu.permission_key IN ('" . $Self->{DBObject}->Quote( $Param{Type} ) . "', 'rw') "
        . " AND ";

    if ( $Param{UserID} ) {
        $SQL .= " gu.user_id = '" . $Self->{DBObject}->Quote( $Param{UserID} ) . "'";
    }
    else {
        $SQL .= " gu.group_id = " . $Self->{DBObject}->Quote( $Param{GroupID}, 'Integer', ) . "";
    }
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my $Key   = '';
        my $Value = '';
        if ( $Param{UserID} ) {
            $Key   = $Row[0];
            $Value = $Row[1];
        }
        else {
            $Key   = $Row[4];
            $Value = $Row[1];
        }

        # get permissions
        $Data{$Key} = $Value;
        push @Name, $Value;
        push @ID,   $Key;
    }

    # add always groups
    if ( $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupAlwaysGroups') ) {

        my %Groups = $Kernel::OM->Get('Kernel::System::Group')->GroupList( Valid => 1 );
        for ( @{ $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupAlwaysGroups') } ) {
            for my $GroupID ( sort keys %Groups ) {
                if ( $_ eq $Groups{$GroupID} && !$Data{$GroupID} ) {
                    $Data{$GroupID} = $_;
                    push @Name, $_;
                    push @ID,   $GroupID;
                }
            }
        }
    }

    # return type
    if ( $Param{Result} && $Param{Result} eq 'ID' ) {

        # set cache
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => \@ID,
        );
        return @ID;
    }
    if ( $Param{Result} && $Param{Result} eq 'Name' ) {

        # set cache
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => \@Name,
        );
        return @Name;
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Data,
    );
    return %Data;
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
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Got no Group or GroupID!' );
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

    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return ${$Cache} if ( ref $Cache eq 'SCALAR' );

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

        # store result
        $Result = $Row[0];
    }

    # check if data exists
    if ( !$Result ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \$Result,
    );

    # return result
    return $Result;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
