# --
# Kernel/System/PID.pm - all system pid functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PID;

use strict;
use warnings;

use vars qw(@ISA);

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
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::PID;

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

    or to create a new PID with extra TTL time

    $PIDObject->PIDCreate(
        Name  => 'PostMasterPOP3',
        TTL   => 60 * 60 * 24 * 3, # for 3 days, per default 1h is used
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

        my $TTL = $Param{TTL} || 3600;
        if ( $ProcessID{Created} > ( time() - $TTL ) ) {
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
    my $PIDCurrent = $$;
    return 1 if $ProcessID{PID} && $PIDCurrent eq $ProcessID{PID};

    # delete if exists
    $Self->PIDDelete(%Param);

    # add new entry
    my $Time = time();
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO process_id'
            . ' (process_name, process_id, process_host, process_create, process_change)'
            . ' VALUES (?, ?, ?, ?, ?)',
        Bind => [ \$Param{Name}, \$PIDCurrent, \$Self->{Host}, \$Time, \$Time ],
    );

    return 1;
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
        SQL => 'SELECT process_name, process_id, process_host, process_create, process_change'
            . ' FROM process_id WHERE process_name = ?',
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            PID     => $Row[1],
            Name    => $Row[0],
            Host    => $Row[2],
            Created => $Row[3],
            Changed => $Row[4],
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
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Name' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM process_id WHERE process_name = ? AND process_host = ?',
        Bind => [ \$Param{Name}, \$Self->{Host} ],
    );

    return 1;
}

=item PIDUpdate()

update the process id change time.
this might be useful as a keep alive signal.

    my $Success = $PIDObject->PIDUpdate(
        Name    => 'PostMasterPOP3',
    );

=cut

sub PIDUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Name' );
        return;
    }

    my %PID = $Self->PIDGet( Name => $Param{Name} );

    if ( !%PID ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Can not get PID' );
        return;
    }

    # sql
    my $Time = time();
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE process_id SET process_change = ? '
            . 'WHERE process_name = ?',
        Bind => [ \$Time, \$Param{Name} ],
    );

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
