# --
# Kernel/System/SystemAddress.pm - lib for system addresses
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SystemAddress.pm,v 1.17 2008-04-02 04:52:27 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::SystemAddress;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

=head1 NAME

Kernel::System::SystemAddress - all system address functions

=head1 SYNOPSIS

Global module to add/edit/update system addresses.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::SystemAddress;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $SystemAddressObject = Kernel::System::SystemAddress->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = { %Param };
    bless( $Self, $Type );

    # check all needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if ( !$Self->{$_} );
    }
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

=item SystemAddressAdd()

add system address with attributes

    my $ID = $SystemAddressObject->SystemAddressAdd(
        Name => 'info@example.com',
        Realname => 'Hotline',
        ValidID => 1,
        QueueID => 123,
        Comment => 'some comment',
        UserID => 123,
    );

=cut

sub SystemAddressAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID Realname QueueID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name Realname Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ValidID QueueID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "INSERT INTO system_address (value0, value1, valid_id, comments, queue_id, "
        . " create_time, create_by, change_time, change_by)"
        . " VALUES "
        . " ('$Param{Name}', '$Param{Realname}', $Param{ValidID}, "
        . " '$Param{Comment}', $Param{QueueID}, "
        . " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        my $Id = 0;
        $Self->{DBObject}->Prepare( SQL => "SELECT id FROM system_address WHERE "
                . "value0 = '$Param{Name}' AND value1 = '$Param{Realname}'", );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Id = $Row[0];
        }
        return $Id;
    }
    else {
        return;
    }
}

=item SystemAddressGet()

get system address with attributes

    my %SystemAddress = $SystemAddressObject->SystemAddressGet(
        ID => 1,
    );

=cut

sub SystemAddressGet {
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
        = "SELECT value0, value1, comments, valid_id, queue_id, change_time, create_time "
        . " FROM "
        . " system_address "
        . " WHERE "
        . " id = $Param{ID}";

    if ( !$Self->{DBObject}->Prepare( SQL => $SQL ) ) {
        return;
    }
    my %Data = ();
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID         => $Param{ID},
            Name       => $Data[0],
            Realname   => $Data[1],
            Comment    => $Data[2],
            ValidID    => $Data[3],
            QueueID    => $Data[4],
            ChangeTime => $Data[5],
            CreateTime => $Data[6],
        );
    }
    return %Data;
}

=item SystemAddressUpdate()

update system address with attributes

    $SystemAddressObject->SystemAddressUpdate(
        ID => 1,
        Name => 'info@example.com',
        Realname => 'Hotline',
        ValidID => 1,
        QueueID => 123,
        Comment => 'some comment',
        UserID => 123,
    );

=cut

sub SystemAddressUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID Realname QueueID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name Realname Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} ) || '';
    }
    for (qw(ID ValidID QueueID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my $SQL
        = "UPDATE system_address SET value0 = '$Param{Name}', value1 = '$Param{Realname}', "
        . " comments = '$Param{Comment}', valid_id = $Param{ValidID}, "
        . " change_time = current_timestamp, change_by = $Param{UserID}, queue_id = $Param{QueueID} "
        . " WHERE id = $Param{ID}";
    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return;
    }
}

=item SystemAddressList()

get a system address list

    my %List = $SystemAddessObject->SystemAddressList();

    my %List = $SystemAddessObject->SystemAddressList(Valid => 1);

=cut

sub SystemAddressList {
    my ( $Self, %Param ) = @_;

    my $Valid = 1;
    if ( !$Param{Valid} && defined( $Param{Valid} ) ) {
        $Valid = 0;
    }
    return $Self->{DBObject}->GetTableData(
        What  => 'id, value1, value0',
        Valid => $Valid,
        Clamp => 1,
        Table => 'system_address',
    );
}

=item SystemAddressIsLocalAddress()

check if used system address is a local address

    if ($SystemAddressObject->SystemAddressIsLocalAddress(Address => 'info@example.com')) {
        # is local
    }
    else {
        # is not local
    }

=cut

sub SystemAddressIsLocalAddress {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Address)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $SQL
        = "SELECT value0, value1, comments, valid_id, queue_id "
        . " FROM "
        . " system_address "
        . " WHERE "
        . " valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )";

    if ( !$Self->{DBObject}->Prepare( SQL => $SQL ) ) {
        return;
    }
    my $Hit = 0;
    $Param{Address} =~ s/ //g;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Row[0] =~ /^\Q$Param{Address}\E$/i ) {
            $Hit = 1;
        }
    }
    return $Hit;
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

$Revision: 1.17 $ $Date: 2008-04-02 04:52:27 $

=cut
