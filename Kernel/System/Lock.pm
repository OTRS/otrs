# --
# Kernel/System/Lock.pm - All Groups related function should be here eventually
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Lock.pm,v 1.24 2009-02-16 11:58:56 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Lock;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.24 $) [1];

=head1 NAME

Kernel::System::Lock - lock lib

=head1 SYNOPSIS

All lock functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Time;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Lock;

    my $ConfigObject = Kernel::Config->new();
    my $TimeObject   = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
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
    my $LockObject = Kernel::System::Lock->new(
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

    # get ViewableLocks
    $Self->{ViewableLocks} = $Self->{ConfigObject}->Get('Ticket::ViewableLocks')
        || die 'No Config entry "Ticket::ViewableLocks"!';

    return $Self;
}

=item LockViewableLock()

get list of lock types

    my @List = $LockObject->LockViewableLock(
        Type   => 'Viewable',
        Result => 'Name', # ID|Name
    );

    my @List = $LockObject->LockViewableLock(
        Type   => 'Viewable',
        Result => 'ID', # ID|Name
    );

=cut

sub LockViewableLock {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM ticket_lock_type WHERE "
            . " name IN ( ${\(join ', ', @{$Self->{ViewableLocks}})} ) AND "
            . " valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )",
    );

    my @Name = ();
    my @ID   = ();
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @Name, $Data[1];
        push @ID,   $Data[0];
    }
    if ( $Param{Type} eq 'Name' ) {
        return @Name;
    }
    else {
        return @ID;
    }
}

=item LockLookup()

lock lookup

    my $LockID = $LockObject->LockLookup( Lock => 'lock' );

    my $Lock = $LockObject->LockLookup( LockID => 2 );

=cut

sub LockLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    my $Key = '';
    if ( !$Param{Lock} && $Param{LockID} ) {
        $Key = 'LockID';
    }
    if ( $Param{Lock} && !$Param{LockID} ) {
        $Key = 'Lock';
    }
    if ( !$Param{Lock} && !$Param{LockID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Lock or LockID!" );
        return;
    }

    # check if we ask the same request?
    my $CacheKey = 'Lock::Lookup::' . $Param{$Key};
    if ( $Self->{$CacheKey} ) {
        return $Self->{$CacheKey};
    }

    # db query
    my $SQL;
    my @Bind;
    if ( $Param{Lock} ) {
        $SQL = 'SELECT id FROM ticket_lock_type WHERE name = ?';
        push @Bind, \$Param{Lock};
    }
    else {
        $SQL = 'SELECT name FROM ticket_lock_type WHERE id = ?';
        push @Bind, \$Param{LockID};
    }
    $Self->{DBObject}->Prepare( SQL => $SQL, Bind => \@Bind );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Self->{$CacheKey} = $Row[0];
    }

    # check if data exists
    if ( !$Self->{$CacheKey} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No Lock/LockID for $Param{$Key} found!",
        );
        return;
    }
    return $Self->{$CacheKey};
}

=item LockList()

get lock list

    my %List = $LockObject->LockList(
        UserID => 123,
    );

=cut

sub LockList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'UserID!' );
        return;
    }

    # check cache
    if ( $Self->{LockList} ) {
        return %{ $Self->{LockList} };
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM ticket_lock_type',
    );
    my %Data = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # cache result
    $Self->{LockList} = \%Data;
    return %Data;
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

$Revision: 1.24 $ $Date: 2009-02-16 11:58:56 $

=cut
