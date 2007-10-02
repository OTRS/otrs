# --
# Kernel/System/PID.pm - all system pid functions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: PID.pm,v 1.8 2007-10-02 10:38:20 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PID;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

=head1 NAME

Kernel::System::PID - to manage PIDs

=head1 SYNOPSIS

All functions to manage process ids

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::PID;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $PIDObject = Kernel::System::PID->new(
        LogObject => $LogObject,
        ConfigObject => $ConfigObject,
        DBObject => $DBObject,
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

    # get common config options
    $Self->{Host} = $Self->{ConfigObject}->Get('FQDN');
    $Self->{PID}  = $$;

    return $Self;
}

=item PIDCreate()

create a new process id lock

    $PIDObject->PIDCreate(
        Name => 'PostMasterPOP3',
    );

=cut

sub PIDCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if already exists
    my %PID = $Self->PIDGet(%Param);
    if (%PID) {
        if ( $PID{Created} > ( time() - ( 60 * 60 ) ) ) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message =>
                    "Can't create PID $PID{Name}, because it's already running ($PID{Host}/$PID{PID})!",
            );
            return;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Removed PID ($PID{Name}/$PID{Host}/$PID{PID}, because 1 hour old!",
            );
            $Self->PIDDelete(%Param);
        }
    }

    # remember to delete it in DESTROY
    $Self->{Name} = $Param{Name};

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }

    # sql
    my $SQL
        = "INSERT INTO process_id "
        . " (process_name, process_id, process_host, process_create) "
        . " VALUES "
        . " ('$Param{Name}', '$Self->{PID}', '$Self->{Host}', "
        . time() . ")";

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return;
    }
}

=item PIDGet()

get process id lock info

    my %PID = $PIDObject->PIDGet(
        Name => 'PostMasterPOP3',
    );

=cut

sub PIDGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }

    # sql
    my $SQL
        = "SELECT process_name, process_id, process_host, process_create "
        . " FROM "
        . " process_id "
        . " WHERE "
        . " process_name = '$Param{Name}'";
    if ( !$Self->{DBObject}->Prepare( SQL => $SQL ) ) {
        return;
    }
    my %Data = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            PID     => $Row[1],
            Name    => $Row[0],
            Host    => $Row[2],
            Created => $Row[3],
        );
    }
    return %Data;
}

=item PIDDelete()

delete the process id lock

    $PIDObject->PIDDelete(
        Name => 'PostMasterPOP3',
    );

=cut

sub PIDDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }

    # sql
    my $SQL = "DELETE FROM process_id WHERE "
        . " process_name = '$Param{Name}' AND process_host = '$Self->{Host}'";

    if ( $Self->{DBObject}->Do( SQL => $SQL ) ) {
        return 1;
    }
    else {
        return;
    }
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.8 $ $Date: 2007-10-02 10:38:20 $

=cut
