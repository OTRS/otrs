# --
# Kernel/System/State.pm - All state related function should be here eventually
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: State.pm,v 1.26 2008-04-02 04:52:27 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::State;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.26 $) [1];

=head1 NAME

Kernel::System::State - state lib

=head1 SYNOPSIS

All state functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Time;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::State;

    my $ConfigObject = Kernel::Config->new();
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $StateObject = Kernel::System::State->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
        TimeObject => $TimeObject,
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

    # check needed config options
    for (qw(Ticket::ViewableStateType Ticket::UnlockStateType)) {
        $Self->{ConfigObject}->Get($_) || die "Need $_ in Kernel/Config.pm!\n";
    }

    return $Self;
}

=item StateAdd()

add new states

    my $ID = $StateObject->StateAdd(
        Name => 'New State',
        Comment => 'some comment',
        ValidID => 1,
        TypeID => 1,
        UserID => 123,
    );

=cut

sub StateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID TypeID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # store data
    return if ! $Self->{DBObject}->Do(
        SQL => "INSERT INTO ticket_state (name, valid_id, type_id, comments, "
            . " create_time, create_by, change_time, change_by)"
            . " VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)",
        Bind => [
            \$Param{Name}, \$Param{ValidID}, \$Param{TypeID}, \$Param{Comment},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get new state id
    return if ! $Self->{DBObject}->Prepare(
        SQL  => "SELECT id FROM ticket_state WHERE name = ?",
        Bind => [ \$Param{Name} ],
    );
    my $ID  = '';
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item StateGet()

get states attributes

    my %State = $StateObject->StateGet(
        Name => 'New State',
        Cache => 1, # optional
    );

    my %State = $StateObject->StateGet(
        ID => 123,
        Cache => 1, # optional
    );

=cut

sub StateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID or Name!" );
        return;
    }

    # cache data
    if ( $Param{Cache} ) {
        if ( $Param{Name} && $Self->{"StateGet::$Param{Name}"} ) {
            return %{ $Self->{"StateGet::$Param{Name}"} };
        }
        elsif ( $Param{ID} && $Self->{"StateGet::$Param{ID}"} ) {
            return %{ $Self->{"StateGet::$Param{ID}"} };
        }
    }

    # sql
    my @Bind;
    my $SQL = "SELECT ts.id, ts.name, ts.valid_id, ts.comments, ts.type_id, tst.name, "
        . " ts.change_time, ts.create_time "
        . " FROM ticket_state ts, ticket_state_type tst WHERE ts.type_id = tst.id AND ";
    if ( $Param{Name} ) {
        $SQL .= " ts.name = ?";
        push @Bind, \$Param{Name};
    }
    else {
        $SQL .= " ts.id = ?";
        push @Bind, \$Param{ID};
    }
    return if ! $Self->{DBObject}->Prepare( SQL => $SQL, Bind => \@Bind );
    my %Data = ();
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID         => $Data[0],
            Name       => $Data[1],
            Comment    => $Data[3],
            ValidID    => $Data[2],
            TypeID     => $Data[4],
            TypeName   => $Data[5],
            ChangeTime => $Data[6],
            CreateTime => $Data[7],
        );
    }

    # cache data
    if ( $Param{Name} ) {
        $Self->{"StateGet::$Param{Name}"} = \%Data;
    }
    else {
        $Self->{"StateGet::$Param{ID}"} = \%Data;
    }

    # no data found...
    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "StateType '$Param{Name}' not found!"
        );
        return;
    }

    # return data
    return %Data;
}

=item StateUpdate()

update state attributes

    $StateObject->StateUpdate(
        ID => 123,
        Name => 'New State',
        Comment => 'some comment',
        ValidID => 1,
        TypeID => 1,
        UserID => 123,
    );

=cut

sub StateUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID TypeID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return $Self->{DBObject}->Do(
        SQL => "UPDATE ticket_state SET name = ?, comments = ?, type_id = ?, "
            . " valid_id = ?, change_time = current_timestamp, change_by = ? "
            . " WHERE id = ?",
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{TypeID}, \$Param{ValidID},
            \$Param{UserID}, \$Param{ID},
        ],
    );
}

=item StateGetStatesByType()

get list of state types

    get all states with state type open and new
    (available: new, open, closed, pending reminder, pending auto,
    removed, merged)

    my @List = $StateObject->StateGetStatesByType(
        StateType => ['open', 'new'],
        Result => 'ID', # HASH|ID|Name
    );

    get all state types used by config option named like

    Ticket::ViewableStateType for "Viewable" state types

    my %List = $StateObject->StateGetStatesByType(
        Type => 'Viewable',
        Result => 'HASH', # HASH|ID|Name
    );

=cut

sub StateGetStatesByType {
    my ( $Self, %Param ) = @_;

    my @Name = ();
    my @ID   = ();
    my %Data = ();

    # check needed stuff
    if ( !$Param{Result} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Result!' );
        return;
    }

    if ( !$Param{Type} && !$Param{StateType} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Type or StateType!' );
        return;
    }

    # sql
    my @StateType = ();
    if ( $Param{Type} ) {
        if ( $Self->{ConfigObject}->Get( 'Ticket::' . $Param{Type} . 'StateType' ) ) {
            @StateType = @{ $Self->{ConfigObject}->Get( 'Ticket::' . $Param{Type} . 'StateType' ) };
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Type 'Ticket::$Param{Type}StateType' not found in Kernel/Config.pm!",
            );
            die;
        }
    }
    else {
        @StateType = @{ $Param{StateType} };
    }
    my $SQL = "SELECT ts.id, ts.name, tst.name  "
        . " FROM "
        . " ticket_state ts, ticket_state_type tst "
        . " WHERE "
        . " tst.id = ts.type_id AND "
        . " tst.name IN ('${\(join '\', \'', @StateType)}' ) AND "
        . " ts.valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )";
    return if ! $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @Name, $Data[1] ;
        push @ID,   $Data[0] ;
        $Data{ $Data[0] } = $Data[1];
    }
    if ( $Param{Result} eq 'Name' ) {
        return @Name;
    }
    elsif ( $Param{Result} eq 'HASH' ) {
        return %Data;
    }

    return @ID;
}

=item StateList()

get state list

    my %List = $StateObject->StateList(
        UserID => 123,
    );

    my %List = $StateObject->StateList(
        UserID => 123,
        Valid => 1, # is default
    );

    my %List = $StateObject->StateList(
        UserID => 123,
        Valid => 0,
    );

=cut

sub StateList {
    my ( $Self, %Param ) = @_;

    my $Valid = 1;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "UserID!" );
        return;
    }
    if ( !$Param{Valid} && defined( $Param{Valid} ) ) {
        $Valid = 0;
    }

    # sql
    my $SQL = "SELECT id, name FROM ticket_state";
    if ($Valid) {
        $SQL .= " WHERE valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )";
    }
    return if ! $Self->{DBObject}->Prepare( SQL => $SQL );
    my %Data = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }
    return %Data;
}

=item StateTypeList()

get state type list

    my %ListType = $StateObject->StateTypeList(
        UserID => 123,
    );

=cut

sub StateTypeList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "UserID!" );
        return;
    }

    # sql
    my %Data = ();
    return if ! $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM ticket_state_type",
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }
    return %Data;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.26 $ $Date: 2008-04-02 04:52:27 $

=cut
