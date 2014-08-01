# --
# Kernel/System/Priority.pm - all ticket priority functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Priority;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
    'Kernel::System::Valid',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::Priority - priority lib

=head1 SYNOPSIS

All ticket priority functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $LockObject = $Kernel::OM->Get('Kernel::System::Priority');


=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'Priority';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

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

    # create cachekey
    my $CacheKey;
    if ( $Param{Valid} ) {
        $CacheKey = 'PriorityList::Valid';
    }
    else {
        $CacheKey = 'PriorityList::All';
    }

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # create sql
    my $SQL = 'SELECT id, name FROM ticket_priority ';
    if ( $Param{Valid} ) {
        $SQL .= "WHERE valid_id IN ( ${\(join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet())} )";
    }

    return if !$DBObject->Prepare( SQL => $SQL );

    # fetch the result
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Data,
    );

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
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => 'PriorityGet' . $Param{PriorityID},
    );
    return %{$Cache} if $Cache;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name, valid_id, create_time, create_by, change_time, change_by '
            . 'FROM ticket_priority WHERE id = ?',
        Bind  => [ \$Param{PriorityID} ],
        Limit => 1,
    );

    # fetch the result
    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ID}         = $Row[0];
        $Data{Name}       = $Row[1];
        $Data{ValidID}    = $Row[2];
        $Data{CreateTime} = $Row[3];
        $Data{CreateBy}   = $Row[4];
        $Data{ChangeTime} = $Row[5];
        $Data{ChangeBy}   = $Row[6];
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => 'PriorityGet' . $Param{PriorityID},
        Value => \%Data,
    );

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
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Do(
        SQL => 'INSERT INTO ticket_priority (name, valid_id, create_time, create_by, '
            . 'change_time, change_by) VALUES '
            . '(?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get new priority id
    return if !$DBObject->Prepare(
        SQL   => 'SELECT id FROM ticket_priority WHERE name = ?',
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    return if !$ID;

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

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
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check CheckSysConfig param
    if ( !defined $Param{CheckSysConfig} ) {
        $Param{CheckSysConfig} = 1;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Do(
        SQL => 'UPDATE ticket_priority SET name = ?, valid_id = ?, '
            . 'change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{ValidID}, \$Param{UserID}, \$Param{PriorityID},
        ],
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    # check all sysconfig options
    return 1 if !$Param{CheckSysConfig};

    # check all sysconfig options and correct them automatically if neccessary
    $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemCheckAll();
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
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need Priority or PriorityID!' );
        return;
    }

    # get (already cached) priority list
    my %PriorityList = $Self->PriorityList(
        Valid => 0,
    );

    my $Key;
    my $Value;
    my $ReturnData;
    if ( $Param{PriorityID} ) {
        $Key        = 'PriorityID';
        $Value      = $Param{PriorityID};
        $ReturnData = $PriorityList{ $Param{PriorityID} };
    }
    else {
        $Key   = 'Priority';
        $Value = $Param{Priority};
        my %PriorityListReverse = reverse %PriorityList;
        $ReturnData = $PriorityListReverse{ $Param{Priority} };
    }

    # check if data exists
    if ( !defined $ReturnData ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No $Key for $Value found!",
        );
        return;
    }

    return $ReturnData;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
