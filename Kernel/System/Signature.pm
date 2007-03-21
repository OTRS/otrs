# --
# Kernel/System/Signature.pm - All signature related function should be here eventually
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Signature.pm,v 1.1 2007-03-21 11:12:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Signature;

use strict;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Signature - signature lib

=head1 SYNOPSIS

All signature functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Time;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Signature;

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
    my $SignatureObject = Kernel::System::Signature->new(
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

=item SignatureAdd()

add new signatures

    my $ID = $SignatureObject->SignatureAdd(
        Name => 'New Signature',
        Text => "--\nSome Signature Infos",
        Comment => 'some comment',
        ValidID => 1,
        UserID => 123,
    );

=cut

sub SignatureAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name Text ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote params
    foreach (qw(Name Text Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "INSERT INTO signature (name, text, comments, valid_id, " .
        " create_time, create_by, change_time, change_by)" .
        " VALUES " .
        " ('$Param{Name}', '$Param{Text}', '$Param{Comment}', $Param{ValidID}, " .
        " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # get new signature id
        my $SQL = "SELECT id FROM signature WHERE name = '$Param{Name}'";
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

=item SignatureGet()

get signatures attributes

    my %Signature = $SignatureObject->SignatureGet(
        ID => 123,
    );

=cut

sub SignatureGet {
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
    my $SQL = "SELECT id, name, text, comments, valid_id, change_time, create_time " .
        " FROM " .
        " signature " .
        " WHERE " .
        " id = $Param{ID}";
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        my %Data = ();
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            %Data = (
                ID => $Data[0],
                Name => $Data[1],
                Text => $Data[2],
                Comment => $Data[3],
                ValidID => $Data[4],
                ChangeTime => $Data[5],
                CreateTime => $Data[6],
            );
        }
        # no data found
        if (!%Data) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "SignatureType '$Param{Name}' not found!"
            );
        }
        # return data
        return %Data;
    }
    else {
        return;
    }
}

=item SignatureUpdate()

update signature attributes

    $SignatureObject->SignatureUpdate(
        ID => 123,
        Name => 'New Signature',
        Text => "--\nSome Signature Infos",
        Comment => 'some comment',
        ValidID => 1,
        UserID => 123,
    );

=cut

sub SignatureUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name Text ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote params
    foreach (qw(Name Text Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE signature SET name = '$Param{Name}', " .
        " text = '$Param{Text}', " .
        " comments = '$Param{Comment}', " .
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

=item SignatureList()

get signature list

    my %List = $SignatureObject->SignatureList();

    my %List = $SignatureObject->SignatureList(
        Valid => 0,
    );

=cut

sub SignatureList {
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
        Table => 'signature',
    );
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

$Revision: 1.1 $ $Date: 2007-03-21 11:12:39 $

=cut
