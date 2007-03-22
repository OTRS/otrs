# --
# Kernel/System/Type.pm - All type related function should be here eventually
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Type.pm,v 1.1 2007-03-22 08:58:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Type;

use strict;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Type - type lib

=head1 SYNOPSIS

All type functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Time;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Type;

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
    my $TypeObject = Kernel::System::Type->new(
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
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

=item TypeAdd()

add new types

    my $ID = $TypeObject->TypeAdd(
        Name => 'New Type',
        ValidID => 1,
        UserID => 123,
    );

=cut

sub TypeAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote params
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "INSERT INTO ticket_type (name, valid_id, " .
        " create_time, create_by, change_time, change_by)" .
        " VALUES " .
        " ('$Param{Name}', $Param{ValidID}, " .
        " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # get new type id
        my $SQL = "SELECT id FROM ticket_type WHERE name = '$Param{Name}'";
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

=item TypeGet()

get types attributes

    my %Type = $TypeObject->TypeGet(
        ID => 123,
    );

=cut

sub TypeGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
        return;
    }
    # quote params
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "SELECT id, name, valid_id, change_time, create_time " .
        " FROM " .
        " ticket_type " .
        " WHERE " .
        " id = $Param{ID}";
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        my %Data = ();
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            %Data = (
                ID => $Data[0],
                Name => $Data[1],
                ValidID => $Data[2],
                ChangeTime => $Data[3],
                CreateTime => $Data[4],
            );
        }
        # no data found
        if (!%Data) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "TypeType '$Param{Name}' not found!"
            );
        }
        # return data
        return %Data;
    }
    else {
        return;
    }
}

=item TypeUpdate()

update type attributes

    $TypeObject->TypeUpdate(
        ID => 123,
        Name => 'New Type',
        ValidID => 1,
        UserID => 123,
    );

=cut

sub TypeUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote params
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE ticket_type SET name = '$Param{Name}', " .
        " valid_id = $Param{ValidID}, " .
        " change_time = current_timestamp, change_by = $Param{UserID} " .
        " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

=item TypeList()

get type list

    my %List = $TypeObject->TypeList();

    my %List = $TypeObject->TypeList(
        Valid => 0,
    );

=cut

sub TypeList {
    my $Self = shift;
    my %Param = @_;
    my $Valid = 1;
    # check needed stuff
    if (!$Param{Valid} && defined($Param{Valid})) {
        $Valid = 0;
    }
    # sql
    return $Self->{DBObject}->GetTableData(
        What => 'id, name',
        Valid => $Valid,
        Clamp => 1,
        Table => 'ticket_type',
    );
}

=item TypeLookup()

get id or name for queue

    my $Type = $TypeObject->TypeLookup(TypeID => $TypeID);

    my $TypeID = $TypeObject->TypeLookup(Type => $Type);

=cut

sub TypeLookup {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Type} && !$Param{TypeID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Got no Type or TypeID!");
        return;
    }
    # check if we ask the same request (cache)?
    if ($Param{TypeID} && $Self->{"QL::Type$Param{TypeID}"}) {
        return $Self->{"QL::Type$Param{TypeID}"};
    }
    if ($Param{Type} && $Self->{"QL::TypeID$Param{Type}"}) {
        return $Self->{"QL::TypeID$Param{Type}"};
    }
    # get data
    my $SQL = '';
    my $Suffix = '';
    if ($Param{Type}) {
        $Param{What} = $Param{Type};
        $Suffix = 'TypeID';
        $SQL = "SELECT id FROM ticket_type WHERE name = '".$Self->{DBObject}->Quote($Param{Type})."'";
    }
    else {
        $Param{What} = $Param{TypeID};
        $Suffix = 'Type';
        $SQL = "SELECT name FROM ticket_type WHERE id = ".$Self->{DBObject}->Quote($Param{TypeID}, 'Integer')."";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"QL::$Suffix$Param{What}"} = $Row[0];
    }
    # check if data exists
    if (!exists $Self->{"QL::$Suffix$Param{What}"}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }
    # return result
    return $Self->{"QL::$Suffix$Param{What}"};
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

$Revision: 1.1 $ $Date: 2007-03-22 08:58:39 $

=cut
