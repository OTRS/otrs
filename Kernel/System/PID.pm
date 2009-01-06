# --
# Kernel/System/PID.pm - all system pid functions
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: PID.pm,v 1.18 2009-01-06 12:58:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::PID;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

=head1 NAME

Kernel::System::PID - to manage PIDs

=head1 SYNOPSIS

All functions to manage process ids

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::PID;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $PIDObject = Kernel::System::PID->new(
        LogObject    => $LogObject,
        ConfigObject => $ConfigObject,
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

    or to create a new PID forced, without check if already exists

    $PIDObject->PIDCreate(
        Name  => 'PostMasterPOP3',
        Force => 1,
    );

=cut

sub PIDCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Name' );
        return;
    }

    # check if already exists
    my %ProcessID = $Self->PIDGet(%Param);
    if ( %ProcessID && !$Param{Force} ) {
        if ( $ProcessID{Created} > ( time() - 3600 ) ) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Can't create PID $ProcessID{Name}, because it's already running "
                    . "($ProcessID{Host}/$ProcessID{PID})!",
            );
            return;
        }

        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Removed PID ($ProcessID{Name}/$ProcessID{Host}/$ProcessID{PID}, "
                . "because 1 hour old!",
        );
    }

    # do nothing if PID is the same
    return 1 if $ProcessID{PID} && $Self->{PID} eq $ProcessID{PID};

    # delete if extists
    $Self->PIDDelete(%Param);

    # add new entry
    my $Time = time();
    return $Self->{DBObject}->Do(
        SQL => 'INSERT INTO process_id'
            . ' (process_name, process_id, process_host, process_create)'
            . ' VALUES (?, ?, ?, ?)',
        Bind => [ \$Param{Name}, \$Self->{PID}, \$Self->{Host}, \$Time ],
    );
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
    if ( !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Name' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT process_name, process_id, process_host, process_create'
            . ' FROM process_id WHERE process_name = ?',
        Bind => [ \$Param{Name} ],
    );
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
    if ( !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Name' );
        return;
    }

    # sql
    return $Self->{DBObject}->Do(
        SQL => 'DELETE FROM process_id WHERE process_name = ? AND process_host = ?',
        Bind => [ \$Param{Name}, \$Self->{Host} ],
    );
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

$Revision: 1.18 $ $Date: 2009-01-06 12:58:11 $

=cut
