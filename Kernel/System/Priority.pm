# --
# Kernel/System/Priority.pm - all ticket priority function
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: Priority.pm,v 1.32 2010-09-08 16:39:22 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Priority;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::Time;
use Kernel::System::SysConfig;
use Kernel::System::CacheInternal;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.32 $) [1];

=head1 NAME

Kernel::System::Priority - priority lib

=head1 SYNOPSIS

All ticket priority functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Priority;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $PriorityObject = Kernel::System::Priority->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    $Self->{ValidObject}         = Kernel::System::Valid->new(%Param);
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %Param,
        Type => 'Priority',
        TTL  => 60 * 60 * 3,
    );

    return $Self;
}

=item PriorityList()

return a priority list as hash

    my %List = $PriorityObject->PriorityList(
        Valid => 0,
    );

=cut

sub PriorityList {
    my ( $Self, %Param ) = @_;

    # check valid param
    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # sql
    my $SQL = 'SELECT id, name FROM ticket_priority ';
    if ( $Param{Valid} ) {
        $SQL .= "WHERE valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )";
    }

    return if !$Self->{DBObject}->Prepare( SQL => $SQL );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }
    return %Data;
}

=item PriorityGet()

get a priority

    my %List = $PriorityObject->PriorityGet(
        PriorityID => 123,
        UserID     => 1,
    );

=cut

sub PriorityGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(PriorityID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name, valid_id, create_time, create_by, change_time, change_by '
            . 'FROM ticket_priority WHERE id = ?',
        Bind => [ \$Param{PriorityID} ],
    );
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ID}         = $Row[0];
        $Data{Name}       = $Row[1];
        $Data{ValidID}    = $Row[2];
        $Data{CreateTime} = $Row[3];
        $Data{CreateBy}   = $Row[4];
        $Data{ChangeTime} = $Row[5];
        $Data{ChangeBy}   = $Row[6];
    }
    return %Data;
}

=item PriorityAdd()

add a ticket priority

    my $True = $PriorityObject->PriorityAdd(
        Name    => 'Prio',
        ValidID => 1,
        UserID  => 1,
    );

=cut

sub PriorityAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO ticket_priority (name, valid_id, create_time, create_by, '
            . 'change_time, change_by) VALUES '
            . '(?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get new state id
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id FROM ticket_priority WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return if !$ID;

    # delete cache
    $Self->{CacheInternalObject}->Delete( Key => 'PriorityLookup::Name::' . $Param{Name} );
    $Self->{CacheInternalObject}->Delete( Key => 'PriorityLookup::ID::' . $ID );

    return $ID;
}

=item PriorityUpdate()

update a existing ticket priority

    my $True = $PriorityObject->PriorityUpdate(
        PriorityID     => 123,
        Name           => 'New Prio',
        ValidID        => 1,
        CheckSysConfig => 0,   # (optional) default 1
        UserID         => 1,
    );

=cut

sub PriorityUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(PriorityID Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check CheckSysConfig param
    if ( !defined $Param{CheckSysConfig} ) {
        $Param{CheckSysConfig} = 1;
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE ticket_priority SET name = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{ValidID}, \$Param{UserID}, \$Param{PriorityID},
        ],
    );

    # delete cache
    $Self->{CacheInternalObject}->Delete( Key => 'PriorityLookup::Name::' . $Param{Name} );
    $Self->{CacheInternalObject}->Delete( Key => 'PriorityLookup::ID::' . $Param{PriorityID} );

    # create a time object locally, needed for the local SysConfigObject
    my $TimeObject = Kernel::System::Time->new( %{$Self} );

    # check all sysconfig options
    if ( $Param{CheckSysConfig} ) {

        # create a sysconfig object locally for performance reasons
        my $SysConfigObject = Kernel::System::SysConfig->new(
            %{$Self},
            TimeObject => $TimeObject,
        );

        # check all sysconfig options and correct them automatically if neccessary
        $SysConfigObject->ConfigItemCheckAll();
    }

    return 1;
}

=item PriorityLookup()

returns the id or the name of a priority

    my $PriorityID = $PriorityObject->PriorityLookup(
        Priority => '3 normal',
    );

    my $Priority = $PriorityObject->PriorityLookup(
        PriorityID => 1,
    );

=cut

sub PriorityLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Priority} && !$Param{PriorityID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Priority or PriorityID!' );
        return;
    }

    # check cache
    my $CacheKey;
    my $Key;
    my $Value;
    if ( $Param{Priority} ) {
        $Key      = 'Priority';
        $Value    = $Param{Priority};
        $CacheKey = 'PriorityLookup::Name::' . $Param{Priority};
    }
    else {
        $Key      = 'PriorityID';
        $Value    = $Param{PriorityID};
        $CacheKey = 'PriorityLookup::ID::' . $Param{PriorityID};
    }

    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return $Cache if $Cache;

    # db query
    my $SQL;
    my @Bind;
    if ( $Param{Priority} ) {
        $SQL = 'SELECT id FROM ticket_priority WHERE name = ?';
        push @Bind, \$Param{Priority};
    }
    else {
        $SQL = 'SELECT name FROM ticket_priority WHERE id = ?';
        push @Bind, \$Param{PriorityID};
    }
    return if !$Self->{DBObject}->Prepare( SQL => $SQL, Bind => \@Bind );
    my $Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data = $Row[0];
    }

    # set cache
    $Self->{CacheInternalObject}->Set( Key => $CacheKey, Value => $Data );

    # check if data exists
    if ( !defined $Data ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No $Key for $Value found!",
        );
        return;
    }

    return $Data;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.32 $ $Date: 2010-09-08 16:39:22 $

=cut
