# --
# Kernel/System/Lock.pm - All Lock functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Lock;

use strict;
use warnings;

use Kernel::System::CacheInternal;
use Kernel::System::Valid;

=head1 NAME

Kernel::System::Lock - lock lib

=head1 SYNOPSIS

All lock functions.

The whole lock API is just for "reading" lock states. Per default you have "unlock", "lock" and "lock-tmp".
Usually you will not modify those lock states, because there is not usecase for this.

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
    use Kernel::System::Lock;

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
    my $LockObject = Kernel::System::Lock->new(
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
    $Self->{ValidObject}         = Kernel::System::Valid->new( %{$Self} );
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'Lock',
        TTL  => 60 * 60 * 24 * 20,
    );

    # get ViewableLocks
    $Self->{ViewableLocks} = $Self->{ConfigObject}->Get('Ticket::ViewableLocks')
        || die 'No Config entry "Ticket::ViewableLocks"!';

    return $Self;
}

=item LockViewableLock()

get list of viewable lock types (used to show available tickets)

    my @List = $LockObject->LockViewableLock(
        Type => 'Name', # ID|Name
    );

Returns:

    @List = ( 'unlock', 'lock', 'lock-tmp' );

    my @ListID = $LockObject->LockViewableLock(
        Type => 'ID', # ID|Name
    );

Returns:

    @List = ( 1, 2, 3 );

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

    # check cache
    my $CacheKey = 'LockViewableLock::' . $Param{Type};
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return @{$Cache} if $Cache;

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM ticket_lock_type WHERE "
            . " name IN ( ${\(join ', ', @{$Self->{ViewableLocks}})} ) AND "
            . " valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )",
    );

    my @Name;
    my @ID;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @Name, $Data[1];
        push @ID,   $Data[0];
    }

    # set cache
    $Self->{CacheInternalObject}->Set(
        Key   => 'LockViewableLock::Name',
        Value => \@Name,
    );
    $Self->{CacheInternalObject}->Set(
        Key   => 'LockViewableLock::ID',
        Value => \@ID,
    );

    return @Name if $Param{Type} eq 'Name';
    return @ID;
}

=item LockLookup()

lock state lookup by ID or Name

    my $LockID = $LockObject->LockLookup( Lock => 'lock' );

    my $Lock = $LockObject->LockLookup( LockID => 2 );

=cut

sub LockLookup {
    my ( $Self, %Param ) = @_;

    # get (already cached) lock list
    my %LockList = $Self->LockList(
        UserID => 1,
    );

    my $Key;
    my $Value;
    my $ReturnData;
    if ( $Param{LockID} ) {
        $Key        = 'LockID';
        $Value      = $Param{LockID};
        $ReturnData = $LockList{ $Param{LockID} };
    }
    else {
        $Key   = 'Lock';
        $Value = $Param{Lock};
        my %LockListReverse = reverse %LockList;
        $ReturnData = $LockListReverse{ $Param{Lock} };
    }

    # check if data exists
    if ( !defined $ReturnData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No $Key for $Value found!",
        );
        return;
    }

    return $ReturnData;
}

=item LockList()

get lock state list

    my %List = $LockObject->LockList(
        UserID => 123,
    );

Returns:

    %List = (
        1 => 'unlock',
        2 => 'lock',
        3 => 'lock-tmp',
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
    my $CacheKey = 'LockList';
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return %{$Cache} if $Cache;

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM ticket_lock_type',
    );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # set cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \%Data,
    );

    return %Data;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
