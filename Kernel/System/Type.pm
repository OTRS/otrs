# --
# Kernel/System/Type.pm - All type related function should be here eventually
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Type.pm,v 1.7 2008-04-11 15:51:53 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Type;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

=head1 NAME

Kernel::System::Type - type lib

=head1 SYNOPSIS

All type functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Time;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Type;

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
    );
    my $TypeObject = Kernel::System::Type->new(
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

=item TypeAdd()

add new types

    my $ID = $TypeObject->TypeAdd(
        Name    => 'New Type',
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub TypeAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if ! $Self->{DBObject}->Do(
        SQL => 'INSERT INTO ticket_type (name, valid_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [ \$Param{Name}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID} ],
   );

    # get new type id
    $Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM ticket_type WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item TypeGet()

get types attributes

    my %Type = $TypeObject->TypeGet(
        ID => 123,
    );

=cut

sub TypeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if ! $Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name, valid_id, change_time, create_time FROM ticket_type WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data = ();
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID         => $Data[0],
            Name       => $Data[1],
            ValidID    => $Data[2],
            ChangeTime => $Data[3],
            CreateTime => $Data[4],
        );
    }

    # no data found
    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "TypeID '$Param{ID}' not found!"
        );
        return;
    }

    # return data
    return %Data;
}

=item TypeUpdate()

update type attributes

    $TypeObject->TypeUpdate(
        ID      => 123,
        Name    => 'New Type',
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub TypeUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return $Self->{DBObject}->Do(
        SQL => 'UPDATE ticket_type SET name = ?, valid_id = ?, '
            . ' change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );
}

=item TypeList()

get type list

    my %List = $TypeObject->TypeList();

    my %List = $TypeObject->TypeList(
        Valid => 0,
    );

=cut

sub TypeList {
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
        Table => 'ticket_type',
    );
}

=item TypeLookup()

get id or name for queue

    my $Type = $TypeObject->TypeLookup(TypeID => $TypeID);

    my $TypeID = $TypeObject->TypeLookup(Type => $Type);

=cut

sub TypeLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Type} && !$Param{TypeID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no Type or TypeID!' );
        return;
    }

    # check if we ask the same request (cache)?
    my $CacheKey;
    my $Key;
    my $Value;
    if ( $Param{TypeID} ) {
        $CacheKey = 'QL::Type::' . $Param{TypeID};
        $Key      = 'TypeID';
        $Value    = $Param{TypeID};
    }
    else {
        $CacheKey = 'QL::TypeID::' . $Param{Type};
        $Key      = 'Type';
        $Value    = $Param{Type};
    }
    if ( $Self->{$CacheKey} ) {
        return $Self->{$CacheKey};
    }

    # get data
    my $SQL    = '';
    my @Bind;
    my $Suffix = '';
    if ( $Param{Type} ) {
        $SQL = 'SELECT id FROM ticket_type WHERE name = ?';
        push @Bind, \$Param{Type};
    }
    else {
        $SQL = 'SELECT name FROM ticket_type WHERE id = ?';
        push @Bind, \$Param{TypeID};
    }
    $Self->{DBObject}->Prepare( SQL => $SQL, Bind => \@Bind );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Self->{$CacheKey} = $Row[0];
    }

    # check if data exists
    if ( !$Self->{$CacheKey} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Found no $Key for $Value!",
        );
        return;
    }

    # return result
    return $Self->{$CacheKey};
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

$Revision: 1.7 $ $Date: 2008-04-11 15:51:53 $

=cut
