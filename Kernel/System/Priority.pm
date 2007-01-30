# --
# Kernel/System/Priority.pm - all ticket priority function
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Priority.pm,v 1.8 2007-01-30 17:33:24 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Priority;

use strict;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Priority - priority lib

=head1 SYNOPSIS

All ticket priority functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Priority;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $PriorityObject = Kernel::System::Priority->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
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

=item PriorityList()

return a priority list as hash

    my %List = $PriorityObject->PriorityList(
        Valid => 0,
    );

=cut

sub PriorityList {
    my $Self = shift;
    my %Param = @_;
    # check valid param
    if (!defined($Param{Valid})) {
        $Param{Valid} = 1;
    }

    # sql
    my %Data = ();
    my $SQL = 'SELECT id, name FROM ticket_priority ';
    if ($Param{Valid}) {
        $SQL .= "WHERE valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )";
    }

    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Data{$Row[0]} = $Row[1];
        }
    }

    return %Data;
}

=item PriorityGet()

get a priority

    my %List = $PriorityObject->PriorityGet(
        PriorityID => 123,
        UserID => 1,
    );

=cut

sub PriorityGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(PriorityID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(PriorityID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    # sql
    my %Data = ();
    my $SQL = "SELECT id, name, valid_id, create_time, create_by, change_time, change_by ".
        "FROM ticket_priority WHERE id = $Param{PriorityID}";

    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Data{ID} = $Row[0];
            $Data{Name} = $Row[1];
            $Data{ValidID} = $Row[2];
            $Data{CreateTime} = $Row[3];
            $Data{CreateBy} = $Row[4];
            $Data{ChangeTime} = $Row[5];
            $Data{ChangeBy} = $Row[6];
        }
    }

    return %Data;
}

=item PriorityAdd()

add a ticket priority

    my $True = $PriorityObject->PriorityAdd(
        Name => 'Prio',
        ValidID => 1,
        UserID => 1,
    );

=cut

sub PriorityAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    my $SQL = "INSERT INTO ticket_priority (name, valid_id, create_time, create_by, change_time, change_by) VALUES ".
        "('$Param{Name}', $Param{ValidID}, current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    my $Return = $Self->{DBObject}->Do(SQL => $SQL);

    return $Return;
}

=item PriorityUpdate()

update a existing ticket priority

    my $True = $PriorityObject->PriorityUpdate(
        PriorityID => 123,
        Name => 'New Prio',
        ValidID => 1,
        UserID => 1,
    );

=cut

sub PriorityUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(PriorityID Name ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(PriorityID ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    my $SQL = "UPDATE ticket_priority SET name = '$Param{Name}', valid_id = $Param{ValidID}, ".
        "change_time = current_timestamp, change_by = $Param{UserID} WHERE id = $Param{PriorityID}";
    my $Return = $Self->{DBObject}->Do(SQL => $SQL);

    return $Return;
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

$Revision: 1.8 $ $Date: 2007-01-30 17:33:24 $

=cut