# --
# Kernel/System/Signature.pm - All signature related function should be here eventually
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Signature.pm,v 1.7 2009-02-16 11:57:40 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Signature;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

=head1 NAME

Kernel::System::Signature - signature lib

=head1 SYNOPSIS

All signature functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Time;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Signature;

    my $ConfigObject = Kernel::Config->new();
    my $TimeObject   = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

    my $SignatureObject = Kernel::System::Signature->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
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

    return $Self;
}

=item SignatureAdd()

add new signatures

    my $ID = $SignatureObject->SignatureAdd(
        Name    => 'New Signature',
        Text    => "--\nSome Signature Infos",
        Comment => 'some comment',
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub SignatureAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name Text ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO signature (name, text, comments, valid_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Text}, \$Param{Comment}, \$Param{ValidID},
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get new signature id
    $Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM signature WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item SignatureGet()

get signatures attributes

    my %Signature = $SignatureObject->SignatureGet(
        ID => 123,
    );

=cut

sub SignatureGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need ID!" );
        return;
    }

    # quote params
    for (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name, text, comments, valid_id, change_time, create_time '
            . ' FROM signature WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data = ();
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID         => $Data[0],
            Name       => $Data[1],
            Text       => $Data[2],
            Comment    => $Data[3],
            ValidID    => $Data[4],
            ChangeTime => $Data[5],
            CreateTime => $Data[6],
        );
    }

    # no data found
    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "SignatureID '$Param{ID}' not found!"
        );
        return;
    }

    # return data
    return %Data;
}

=item SignatureUpdate()

update signature attributes

    $SignatureObject->SignatureUpdate(
        ID      => 123,
        Name    => 'New Signature',
        Text    => "--\nSome Signature Infos",
        Comment => 'some comment',
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub SignatureUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name Text ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return $Self->{DBObject}->Do(
        SQL => 'UPDATE signature SET name = ?, text = ?, comments = ?, valid_id = ?, '
            . ' change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Text}, \$Param{Comment}, \$Param{ValidID},
            \$Param{UserID}, \$Param{ID},
            ]
    );
}

=item SignatureList()

get signature list

    my %List = $SignatureObject->SignatureList();

    my %List = $SignatureObject->SignatureList(
        Valid => 0,
    );

=cut

sub SignatureList {
    my ( $Self, %Param ) = @_;

    my $Valid = 1;

    # check needed stuff
    if ( !$Param{Valid} && defined( $Param{Valid} ) ) {
        $Valid = 0;
    }

    # sql
    return $Self->{DBObject}->GetTableData(
        What  => 'id, name',
        Valid => $Valid,
        Clamp => 1,
        Table => 'signature',
    );
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.7 $ $Date: 2009-02-16 11:57:40 $

=cut
