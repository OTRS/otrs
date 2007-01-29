# --
# Kernel/System/State.pm - All state related function should be here eventually
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: State.pm,v 1.18 2007-01-29 15:52:31 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::State;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.18 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::State - state lib

=head1 SYNOPSIS

All state functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

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
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # check needed config options
    foreach (qw(Ticket::ViewableStateType Ticket::UnlockStateType)) {
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name ValidID TypeID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote params
    foreach (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ValidID TypeID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "INSERT INTO ticket_state (name, valid_id, type_id, comments, " .
        " create_time, create_by, change_time, change_by)" .
        " VALUES " .
        " ('$Param{Name}', $Param{ValidID}, " .
        " $Param{TypeID}, '$Param{Comment}', " .
        " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # get new state id
        my $SQL = "SELECT id FROM ticket_state WHERE name = '$Param{Name}'";
        my $ID = '';
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $ID = $Row[0];
        }
        return $ID;
    }
    else {
        return;
    }
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID} && !$Param{Name}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID or Name!");
        return;
    }
    # cache data
    if ($Param{Cache}) {
        if ($Param{Name} && $Self->{"StateGet::$Param{Name}"}) {
            return %{$Self->{"StateGet::$Param{Name}"}};
        }
        elsif ($Param{ID} && $Self->{"StateGet::$Param{ID}"}) {
            return %{$Self->{"StateGet::$Param{ID}"}};
        }
    }
    # sql
    my $SQL = "SELECT ts.id, ts.name, ts.valid_id, ts.comments, ts.type_id, tst.name ".
        " FROM ".
        " ticket_state ts, ticket_state_type tst ".
        " WHERE ".
        " ts.type_id = tst.id ".
        " AND ";
    if ($Param{Name}) {
        $SQL .= " ts.name = '".$Self->{DBObject}->Quote($Param{Name})."'";
    }
    else {
        $SQL .= " ts.id = ".$Self->{DBObject}->Quote($Param{ID}, 'Integer')."";
    }
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        my %Data = ();
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            %Data = (
                ID => $Data[0],
                Name => $Data[1],
                Comment => $Data[3],
                ValidID => $Data[2],
                TypeID => $Data[4],
                TypeName => $Data[5],
            );
        }
        # cache data
        if ($Param{Name}) {
            $Self->{"StateGet::$Param{Name}"} = \%Data;
        }
        else {
            $Self->{"StateGet::$Param{ID}"} = \%Data;
        }
        # no data found...
        if (!%Data) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "StateType '$Param{Name}' not found!"
            );
        }
        # return data
        return %Data;
    }
    else {
        return;
    }
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
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name ValidID TypeID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote params
    foreach (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID ValidID TypeID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE ticket_state SET name = '$Param{Name}', " .
        " comments = '$Param{Comment}', " .
        " type_id = $Param{TypeID}, valid_id = $Param{ValidID}, " .
        " change_time = current_timestamp, change_by = $Param{UserID} " .
        " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
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
    my $Self = shift;
    my %Param = @_;
    my @Name = ();
    my @ID = ();
    my %Data = ();
    # check needed stuff
    foreach (qw(Result)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Param{Type} && !$Param{StateType}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Type or StateType!");
        return;
    }
    # sql
    my @StateType = ();
    if ($Param{Type}) {
        if ($Self->{ConfigObject}->Get('Ticket::'.$Param{Type}.'StateType')) {
            @StateType = @{$Self->{ConfigObject}->Get('Ticket::'.$Param{Type}.'StateType')};
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Type 'Ticket::$Param{Type}StateType' not found in Kernel/Config.pm!",
            );
            die;
        }
    }
    else {
        @StateType = @{$Param{StateType}};
    }
    my $SQL = "SELECT ts.id, ts.name, tst.name  ".
        " FROM ".
        " ticket_state ts, ticket_state_type tst ".
        " WHERE ".
        " tst.id = ts.type_id ".
        " AND ".
        " tst.name IN ('${\(join '\', \'', @StateType)}' )".
        " AND ".
        " ts.valid_id IN ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )";
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            push (@Name, $Data[1]);
            push (@ID, $Data[0]);
            $Data{$Data[0]} = $Data[1];
        }
        if ($Param{Result} eq 'Name') {
            return @Name;
        }
        elsif ($Param{Result} eq 'HASH') {
            return %Data;
        }
        else {
            return @ID;
        }
    }
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
    my $Self = shift;
    my %Param = @_;
    my $Valid = 1;
    # check needed stuff
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "UserID!");
        return;
    }
    if (!$Param{Valid} && defined($Param{Valid})) {
        $Valid = 0;
    }
    # sql
    my $SQL = "SELECT id, name ".
        " FROM ".
        " ticket_state";
    if ($Valid) {
        $SQL .= " WHERE ".
            " valid_id IN ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )";
    }
    my %Data = ();
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Data{$Row[0]} = $Row[1];
        }
        return %Data;
    }
    else {
        return;
    }
}

=item StateTypeList()

get state type list

    my %ListType = $StateObject->StateTypeList(
        UserID => 123,
    );

=cut

sub StateTypeList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "UserID!");
        return;
    }
    # sql
    my $SQL = "SELECT id, name ".
        " FROM ".
        " ticket_state_type";
    my %Data = ();
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Data{$Row[0]} = $Row[1];
        }
        return %Data;
    }
    else {
        return;
    }
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.18 $ $Date: 2007-01-29 15:52:31 $

=cut
