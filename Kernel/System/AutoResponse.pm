# --
# Kernel/System/AutoResponse.pm - lib for auto responses
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AutoResponse.pm,v 1.14.2.1 2008-06-21 09:29:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::AutoResponse;

use strict;
use warnings;

use Kernel::System::SystemAddress;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14.2.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if !$Self->{$_};
    }

    if ( !$Self->{SystemAddressObject} ) {
        $Self->{SystemAddressObject} = Kernel::System::SystemAddress->new(%Param);
    }

    return $Self;
}

sub AutoResponseAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID Response AddressID TypeID Charset UserID Subject)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name Comment Response Charset Subject)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ValidID TypeID AddressID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "INSERT INTO auto_response "
        . " (name, valid_id, comments, text0, text1, type_id, system_address_id, "
        . " charset,  create_time, create_by, change_time, change_by)"
        . " VALUES "
        . " ('$Param{Name}', $Param{ValidID}, '$Param{Comment}', '$Param{Response}', "
        . " '$Param{Subject}', $Param{TypeID}, $Param{AddressID}, '$Param{Charset}', "
        . " current_timestamp, $Param{UserID}, current_timestamp,  $Param{UserID})";

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return;
    }
}

sub AutoResponseGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # db quote
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "SELECT name, valid_id, comments, text0, text1, "
        . " type_id, system_address_id, charset "
        . " FROM "
        . " auto_response "
        . " WHERE "
        . " id = $Param{ID}";

    if ( !$Self->{DBObject}->Prepare( SQL => $SQL ) ) {
        return;
    }
    if ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        my %Data = (
            ID        => $Param{ID},
            Name      => $Data[0],
            Comment   => $Data[2],
            Response  => $Data[3],
            ValidID   => $Data[1],
            Subject   => $Data[4],
            TypeID    => $Data[5],
            AddressID => $Data[6],
            Charset   => $Data[7],
        );
        return %Data;
    }
    else {
        return;
    }
}

sub AutoResponseUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID Response AddressID Charset UserID Subject)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name Comment Response Charset Subject)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ID ValidID TypeID AddressID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "UPDATE auto_response SET "
        . " name = '$Param{Name}', "
        . " text0 = '$Param{Response}', "
        . " comments = '$Param{Comment}', "
        . " text1 = '$Param{Subject}', "
        . " type_id = $Param{TypeID}, "
        . " system_address_id = $Param{AddressID}, "
        . " charset = '$Param{Charset}', "
        . " valid_id = $Param{ValidID}, "
        . " change_time = current_timestamp, "
        . " change_by = $Param{UserID} "
        . " WHERE "
        . " id = $Param{ID}";

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return;
    }
}

sub AutoResponseGetByTypeQueueID {
    my ( $Self, %Param ) = @_;

    my %Data;

    # check needed stuff
    for (qw(QueueID Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Type)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # SQL query
    my $SQL
        = "SELECT ar.text0, ar.text1, ar.charset, ar.system_address_id "
        . " FROM "
        . " auto_response_type art, auto_response ar, queue_auto_response qar "
        . " WHERE "
        . " qar.queue_id = $Param{QueueID} AND "
        . " art.id = ar.type_id AND "
        . " qar.auto_response_id = ar.id AND "
        . " art.name = '$Param{Type}'";
    $Self->{DBObject}->Prepare( SQL => $SQL );

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{Text}    = $Row[0];
        $Data{Subject} = $Row[1];
        $Data{Charset} = $Row[2];
        $Data{SystemAddressID} = $Row[3];
    }
    my %Adresss = $Self->{SystemAddressObject}->SystemAddressGet(
        ID => $Data{SystemAddressID},
    );

    return if !%Adresss;

    # COMPAT: 2.1
    $Data{Realname} = $Adresss{Realname};
    $Data{Address}  = $Adresss{Name};
    return ( %Adresss, %Data );
}

sub AutoResponseList {
    my ( $Self, %Param ) = @_;

    return $Self->{DBObject}->GetTableData(
        What  => 'id, name, id',
        Valid => 0,
        Clamp => 1,
        Table => 'auto_response',
    );
}

sub AutoResponseTypeList {
    my ( $Self, %Param ) = @_;

    return $Self->{DBObject}->GetTableData(
        What  => 'id, name',
        Valid => 1,
        Clamp => 1,
        Table => 'auto_response_type',
    );
}

1;
