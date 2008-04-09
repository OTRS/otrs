# --
# Kernel/System/Priority.pm - all ticket priority function
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Priority.pm,v 1.13 2008-04-09 00:31:19 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Priority;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

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
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Priority;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $PriorityObject = Kernel::System::Priority->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
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

=item PriorityList()

return a priority list as hash

    my %List = $PriorityObject->PriorityList(
        Valid => 0,
    );

=cut

sub PriorityList {
    my ( $Self, %Param ) = @_;

    # check valid param
    if ( !defined( $Param{Valid} ) ) {
        $Param{Valid} = 1;
    }

    # sql
    my %Data = ();
    my $SQL  = 'SELECT id, name FROM ticket_priority ';
    if ( $Param{Valid} ) {
        $SQL .= "WHERE valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )";
    }

    if ( $Self->{DBObject}->Prepare( SQL => $SQL ) ) {
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Data{ $Row[0] } = $Row[1];
        }
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

    # quote
    for (qw(PriorityID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql
    my %Data = ();
    my $SQL  = "SELECT id, name, valid_id, create_time, create_by, change_time, change_by "
        . "FROM ticket_priority WHERE id = $Param{PriorityID}";

    if ( $Self->{DBObject}->Prepare( SQL => $SQL ) ) {
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Data{ID}         = $Row[0];
            $Data{Name}       = $Row[1];
            $Data{ValidID}    = $Row[2];
            $Data{CreateTime} = $Row[3];
            $Data{CreateBy}   = $Row[4];
            $Data{ChangeTime} = $Row[5];
            $Data{ChangeBy}   = $Row[6];
        }
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

    # quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    for (qw(ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    my $SQL
        = "INSERT INTO ticket_priority (name, valid_id, create_time, create_by, change_time, change_by) VALUES "
        . "('$Param{Name}', $Param{ValidID}, current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    my $Return = $Self->{DBObject}->Do( SQL => $SQL );

    return $Return;
}

=item PriorityUpdate()

update a existing ticket priority

    my $True = $PriorityObject->PriorityUpdate(
        PriorityID => 123,
        Name       => 'New Prio',
        ValidID    => 1,
        UserID     => 1,
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

    # quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    for (qw(PriorityID ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    my $SQL = "UPDATE ticket_priority SET name = '$Param{Name}', valid_id = $Param{ValidID}, "
        . "change_time = current_timestamp, change_by = $Param{UserID} WHERE id = $Param{PriorityID}";
    my $Return = $Self->{DBObject}->Do( SQL => $SQL );

    return $Return;
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
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Priority or PriorityID!" );
        return;
    }

    # check if we ask the same request?
    if ( $Param{Priority} ) {
        if ( exists $Self->{"Ticket::Priority::PriorityLookup::$Param{Priority}"} ) {
            return $Self->{"Ticket::Priority::PriorityLookup::$Param{Priority}"};
        }
    }
    else {
        if ( exists $Self->{"Ticket::Priority::PriorityIDLookup::$Param{PriorityID}"} ) {
            return $Self->{"Ticket::Priority::PriorityIDLookup::$Param{PriorityID}"};
        }
    }

    # db query
    my $SQL;
    my @Bind;
    if ( $Param{Priority} ) {
        $SQL = "SELECT id FROM ticket_priority WHERE name = ?";
        push @Bind, \$Param{Priority};
    }
    else {
        $SQL = "SELECT name FROM ticket_priority WHERE id = ?";
        push @Bind, \$Param{PriorityID};
    }
    $Self->{DBObject}->Prepare( SQL  => $SQL, Bind => \@Bind );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # store result
        if ( $Param{Priority} ) {
            $Self->{"Ticket::Priority::PriorityLookup::$Param{Priority}"} = $Row[0];
        }
        else {
            $Self->{"Ticket::Priority::PriorityIDLookup::$Param{PriorityID}"} = $Row[0];
        }
    }

    # check if data exists
    if ( $Param{Priority} ) {
        if ( !exists $Self->{"Ticket::Priority::PriorityLookup::$Param{Priority}"} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No PriorityID for $Param{Priority} found!",
            );
            return;
        }
        else {
            return $Self->{"Ticket::Priority::PriorityLookup::$Param{Priority}"};
        }
    }
    else {
        if ( !exists $Self->{"Ticket::Priority::PriorityIDLookup::$Param{PriorityID}"} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No Priority for $Param{PriorityID} found!",
            );
            return;
        }
        else {
            return $Self->{"Ticket::Priority::PriorityIDLookup::$Param{PriorityID}"};
        }
    }
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

$Revision: 1.13 $ $Date: 2008-04-09 00:31:19 $

=cut
