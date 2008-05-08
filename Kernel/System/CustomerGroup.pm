# --
# Kernel/System/CustomerGroup.pm - All Groups related function should be here eventually
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CustomerGroup.pm,v 1.17 2008-05-08 09:36:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::CustomerGroup;

use strict;
use warnings;

use Kernel::System::Group;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

=head1 NAME

Kernel::System::CustomerGroup - customer group lib

=head1 SYNOPSIS

All customer group functions. E. g. to add groups or to get a member list of a group.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::CustomerGroup;

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
    my $CustomerGroupObject = Kernel::System::CustomerGroup->new(
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
    $Self->{GroupObject} = Kernel::System::Group->new(%Param);
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

=item GroupMemberAdd()

to add a member to a group

    Permission: ro,move_into,priority,create,rw

    my $ID = $CustomerGroupObject->GroupMemberAdd(
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

    # check needed stuff
    for (qw(UID GID UserID Permission)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # update permission
    for my $Type ( keys %{ $Param{Permission} } ) {

        # delete existing permission
        $Self->{DBObject}->Do(
            SQL => "DELETE FROM group_customer_user WHERE "
                . " group_id = ? AND user_id = ? AND permission_key = ?",
            Bind => [ \$Param{GID}, \$Param{UID}, \$Type ],
        );

        # debug
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message =>
                    "Add UID:$Param{UID} to GID:$Param{GID}, $Type:$Param{Permission}->{$Type}!",
            );
        }

        # insert new permission
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO group_customer_user "
                . " (user_id, group_id, permission_key, permission_value, "
                . " create_time, create_by, change_time, change_by) "
                . " VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)",
            Bind => [
                \$Param{UID}, \$Param{GID}, \$Type, \$Param{Permission}->{$Type}, \$Param{UserID},
                \$Param{UserID},
            ],
        );
    }
    return 1;
}

=item GroupMemberList()

returns a list of users of a group with ro/move_into/create/owner/priority/rw permissions

    UserID: user id
    GroupID: group id
    Type: ro|move_into|priority|create|rw
    Result: HASH -> returns a hash of key => group id, value => group name
            Name -> returns an array of user names
            ID   -> returns an array of user names
    Example:
    $CustomerGroupObject->GroupMemberList(
        UserID => $ID,
        Type => 'move_into',
        Result => 'HASH',
    );

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
    my %Data = ();
    my @Name = ();
    my @ID   = ();

    # check if customer group feature is activ, if not, return all groups
    if ( !$Self->{ConfigObject}->Get('CustomerGroupSupport') ) {

        # get permissions
        %Data = $Self->{GroupObject}->GroupList( Valid => 1 );
        for ( keys %Data ) {
            push( @Name, $Data{$_} );
            push( @ID,   $_ );
        }
    }

    # if it's activ, return just the permitted groups
    my $SQL = "SELECT g.id, g.name, gu.permission_key, gu.permission_value, gu.user_id "
        . " FROM "
        . " groups g, group_customer_user gu"
        . " WHERE "
        . " g.valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} ) AND "
        . " g.id = gu.group_id AND "
        . " gu.permission_value = 1 AND "
        . " gu.permission_key IN ('" . $Self->{DBObject}->Quote( $Param{Type} ) . "', 'rw') "
        . " AND ";

    if ( $Param{UserID} ) {
        $SQL .= " gu.user_id = '" . $Self->{DBObject}->Quote( $Param{UserID} ) . "'";
    }
    else {
        $SQL .= " gu.group_id = " . $Self->{DBObject}->Quote( $Param{GroupID} ) . "";
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
        push( @Name, $Value );
        push( @ID,   $Key );
    }

    # add always groups
    if ( $Self->{ConfigObject}->Get('CustomerGroupAlwaysGroups') ) {
        my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );
        for ( @{ $Self->{ConfigObject}->Get('CustomerGroupAlwaysGroups') } ) {
            for my $GroupID ( keys %Groups ) {
                if ( $_ eq $Groups{$GroupID} && !$Data{$GroupID} ) {
                    $Data{$GroupID} = $_;
                    push( @Name, $_ );
                    push( @ID,   $GroupID );
                }
            }
        }
    }

    # return type
    if ( $Param{Result} && $Param{Result} eq 'ID' ) {
        return @ID;
    }
    if ( $Param{Result} && $Param{Result} eq 'Name' ) {
        return @Name;
    }
    else {
        return %Data;
    }
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

$Revision: 1.17 $ $Date: 2008-05-08 09:36:19 $

=cut
