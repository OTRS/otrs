# --
# Kernel/System/AutoResponse.pm - lib for auto responses
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AutoResponse.pm,v 1.24 2009-01-02 18:57:51 martin Exp $
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
$VERSION = qw($Revision: 1.24 $) [1];

=head1 NAME

Kernel::System::AutoResponse - auto response lib

=head1 SYNOPSIS

All auto response functions. E. g. to add auto response or other functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::AutoResponse;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        MainObject   => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $AutoResponseObject = Kernel::System::AutoResponse->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject)) {
        if ( $Param{$_} ) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }

    if ( !$Self->{SystemAddressObject} ) {
        $Self->{SystemAddressObject} = Kernel::System::SystemAddress->new(%Param);
    }

    return $Self;
}

=item AutoResponseAdd()

add auto response with attributes

    $AutoResponseObject->AutoResponseAdd(
        Name      => 'Some::AutoResponse',
        ValidID   => 1,
        Subject   => 'Some Subject..',
        Response  => 'Auto Response Test....',
        Charset   => 'utf8',
        AddressID => 1,
        TypeID    => 1,
        UserID    => 123,
    );

=cut

sub AutoResponseAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID Response AddressID TypeID Charset UserID Subject)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # insert into database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO auto_response '
            . '(name, valid_id, comments, text0, text1, type_id, system_address_id, '
            . 'charset,  create_time, create_by, change_time, change_by)'
            . 'VALUES '
            . '(?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name},    \$Param{ValidID}, \$Param{Comment},   \$Param{Response},
            \$Param{Subject}, \$Param{TypeID},  \$Param{AddressID}, \$Param{Charset},
            \$Param{UserID},  \$Param{UserID},
        ],
    );

    # get id
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM auto_response WHERE name = ? AND type_id = ? AND'
            . ' system_address_id = ? AND charset = ? AND create_by = ?',
        Bind => [
            \$Param{Name}, \$Param{TypeID}, \$Param{AddressID}, \$Param{Charset},
            \$Param{UserID},
        ],
    );
    my $ID;
    if ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item AutoResponseGet()

get auto response with attributes

    my %Data = $AutoResponseObject->AutoResponseGet(
        ID => 123,
    );

=cut

sub AutoResponseGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # select
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT name, valid_id, comments, text0, text1, type_id, system_address_id, charset'
            . ' FROM auto_response WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    my %Data;
    if ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
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
    }
    return %Data;
}

=item AutoResponseUpdate()

update auto response with attributes

    $AutoResponseObject->AutoResponseUpdate(
        ID        => 123,
        Name      => 'Some::AutoResponse',
        ValidID   => 1,
        Subject   => 'Some Subject..',
        Response  => 'Auto Response Test....',
        Charset   => 'utf8',
        AddressID => 1,
        TypeID    => 1,
        UserID    => 123,
    );

=cut

sub AutoResponseUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID Response AddressID Charset UserID Subject)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return $Self->{DBObject}->Do(
        SQL => 'UPDATE auto_response SET '
            . 'name = ?, text0 = ?, comments = ?, text1 = ?, type_id = ?, '
            . 'system_address_id = ?, charset = ?, valid_id = ?, change_time = current_timestamp, '
            . 'change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Response}, \$Param{Comment}, \$Param{Subject}, \$Param{TypeID},
            \$Param{AddressID}, \$Param{Charset}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );
}

sub AutoResponseGetByTypeQueueID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(QueueID Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # SQL query
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT ar.text0, ar.text1, ar.charset, ar.system_address_id FROM '
            . 'auto_response_type art, auto_response ar, queue_auto_response qar '
            . 'WHERE qar.queue_id = ? AND art.id = ar.type_id AND '
            . 'qar.auto_response_id = ar.id AND art.name = ?',
        Bind => [
            \$Param{QueueID}, \$Param{Type},
        ],
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{Text}            = $Row[0];
        $Data{Subject}         = $Row[1];
        $Data{Charset}         = $Row[2];
        $Data{SystemAddressID} = $Row[3];
    }

    # return if no auto response is configured
    return if !%Data;

    # get sender attributes
    my %Adresss = $Self->{SystemAddressObject}->SystemAddressGet(
        ID => $Data{SystemAddressID},
    );

    # COMPAT: 2.1
    $Data{Address} = $Adresss{Name};

    # return both, sender attributes and auto response attributes
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

sub AutoResponseQueue {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(QueueID AutoResponseIDs UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # store queue:auto response relations
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM queue_auto_response WHERE queue_id = ?',
        Bind => [ \$Param{QueueID} ],
    );
    for my $NewID ( @{ $Param{AutoResponseIDs} } ) {
        next if !$NewID;

        $Self->{DBObject}->Do(
            SQL => 'INSERT INTO queue_auto_response (queue_id, auto_response_id, '
                . 'create_time, create_by, change_time, change_by) VALUES '
                . '(?, ?, current_timestamp, ?, current_timestamp, ?)',
            Bind => [
                \$Param{QueueID}, \$NewID, \$Param{UserID}, \$Param{UserID},
            ],
        );
    }
    return 1;
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

$Revision: 1.24 $ $Date: 2009-01-02 18:57:51 $

=cut
