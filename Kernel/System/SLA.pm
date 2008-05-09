# --
# Kernel/System/SLA.pm - all sla function
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: SLA.pm,v 1.21 2008-05-09 13:19:08 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::SLA;

use strict;
use warnings;

use Kernel::System::CheckItem;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.21 $) [1];

=head1 NAME

Kernel::System::SLA - sla lib

=head1 SYNOPSIS

All sla functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Service;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

    my $SLAObject = Kernel::System::SLA->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new( %{$Self} );
    $Self->{ValidObject}     = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

=item SLAList()

return a hash list of slas

    my %SLAList = $SLAObject->SLAList(
        ServiceID => 1,  # (optional)
        Valid     => 0,  # (optional) default 1 (0|1)
        UserID    => 1,
    );

=cut

sub SLAList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # set valid param
    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # quote
    $Param{UserID} = $Self->{DBObject}->Quote( $Param{UserID}, 'Integer' );

    # add ServiceID
    my %SQLTable;
    $SQLTable{sla} = 'sla s';
    my @SQLWhere;
    if ( $Param{ServiceID} ) {

        # quote
        $Param{ServiceID} = $Self->{DBObject}->Quote( $Param{ServiceID}, 'Integer' );

        $SQLTable{service} = 'service_sla r';
        push @SQLWhere, "s.id = r.sla_id AND r.service_id = $Param{ServiceID}";
    }

    # add valid part
    if ( $Param{Valid} ) {

        # create the valid list
        my $ValidIDs = join ', ', $Self->{ValidObject}->ValidIDsGet();

        push @SQLWhere, "s.valid_id IN ( $ValidIDs )";
    }

    # create the table and where strings
    my $TableString = join q{, }, values %SQLTable;
    my $WhereString = @SQLWhere ? ' WHERE ' . join q{ AND }, @SQLWhere : '';

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT s.id, s.name FROM $TableString $WhereString",
    );

    # fetch the result
    my %SLAList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $SLAList{ $Row[0] } = $Row[1];
    }

    return %SLAList;
}

=item SLAGet()

return a sla as hash

Return
    $SLAData{SLAID}
    $SLAData{ServiceIDs}
    $SLAData{Name}
    $SLAData{Calendar}
    $SLAData{FirstResponseTime}
    $SLAData{FirstResponseNotify}
    $SLAData{UpdateTime}
    $SLAData{UpdateNotify}
    $SLAData{SolutionTime}
    $SLAData{SolutionNotify}
    $SLAData{ValidID}
    $SLAData{Comment}
    $SLAData{CreateTime}
    $SLAData{CreateBy}
    $SLAData{ChangeTime}
    $SLAData{ChangeBy}

    my %SLAData = $SLAObject->SLAGet(
        SLAID  => 123,
        UserID => 1,
    );

=cut

sub SLAGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SLAID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Argument!" );
            return;
        }
    }

    # check if result is already cached
    return %{ $Self->{Cache}->{SLAGet}->{ $Param{SLAID} } }
        if $Self->{Cache}->{SLAGet}->{ $Param{SLAID} };

    # quote
    for my $Argument ( qw(SLAID UserID) ) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get sla from db
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name, calendar_name, first_response_time, first_response_notify, "
            . "update_time, update_notify, solution_time, solution_notify, "
            . "valid_id, comments, create_time, create_by, change_time, change_by "
            . "FROM sla WHERE id = $Param{SLAID}",
        Limit => 1,
    );

    # fetch the result
    my %SLAData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $SLAData{SLAID}               = $Row[0];
        $SLAData{Name}                = $Row[1];
        $SLAData{Calendar}            = $Row[2] || '';
        $SLAData{FirstResponseTime}   = $Row[3];
        $SLAData{FirstResponseNotify} = $Row[4];
        $SLAData{UpdateTime}          = $Row[5];
        $SLAData{UpdateNotify}        = $Row[6];
        $SLAData{SolutionTime}        = $Row[7];
        $SLAData{SolutionNotify}      = $Row[8];
        $SLAData{ValidID}             = $Row[9];
        $SLAData{Comment}             = $Row[10] || '';
        $SLAData{CreateTime}          = $Row[11];
        $SLAData{CreateBy}            = $Row[12];
        $SLAData{ChangeTime}          = $Row[13];
        $SLAData{ChangeBy}            = $Row[14];
    }

    # check sla
    if ( !$SLAData{SLAID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such SLAID ($Param{SLAID})!",
        );
        return;
    }

    # get all service ids
    $Self->{DBObject}->Prepare(
        SQL => "SELECT service_id FROM service_sla "
            . "WHERE sla_id = $SLAData{SLAID} ORDER BY sla_id",
    );

    # fetch the result
    my @ServiceIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ServiceIDs, $Row[0];
    }

    # add the ids
    $SLAData{ServiceIDs} = \@ServiceIDs;

    # cache the result
    $Self->{Cache}->{SLAGet}->{ $Param{SLAID} } = \%SLAData;

    return %SLAData;
}

=item SLALookup()

return the name or the sla id

    my $SLAName = $SLAObject->SLALookup(
        SLAID => 123,
    );

    or

    my $SLAID = $SLAObject->SLALookup(
        Name => 'SLA Name',
    );

=cut

sub SLALookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SLAID} && !$Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => 'Need SLAID or Name!',
        );
        return;
    }

    if ( $Param{SLAID} ) {

        # check if result is already cached
        return $Self->{Cache}->{SLALookup}->{ID}->{ $Param{SLAID} }
            if $Self->{Cache}->{SLALookup}->{ID}->{ $Param{SLAID} };

        # quote
        $Param{SLAID} = $Self->{DBObject}->Quote( $Param{SLAID}, 'Integer' );

        # ask the database
        $Self->{DBObject}->Prepare(
            SQL   => "SELECT name FROM sla WHERE id = $Param{SLAID}",
            Limit => 1,
        );

        # fetch the result
        my $Name;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Name = $Row[0];
        }

        # cache the result
        $Self->{Cache}->{SLALookup}->{ID}->{ $Param{SLAID} } = $Name;

        return $Name;
    }
    else {

        # check if result is already cached
        return $Self->{Cache}->{SLALookup}->{Name}->{ $Param{Name} }
            if $Self->{Cache}->{SLALookup}->{Name}->{ $Param{Name} };

        # quote
        $Param{Name} = $Self->{DBObject}->Quote( $Param{Name} );

        # lookup
        $Self->{DBObject}->Prepare(
            SQL   => "SELECT id FROM sla WHERE name = '$Param{Name}'",
            Limit => 1,
        );

        # fetch the result
        my $SLAID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $SLAID = $Row[0];
        }

        # cache the result
        $Self->{Cache}->{SLALookup}->{Name}->{ $Param{Name} } = $SLAID;

        return $SLAID;
    }
}

=item SLAAdd()

add a sla

    my $SLAID = $SLAObject->SLAAdd(
        ServiceIDs          => [ 1, 5, 7 ],  # (optional)
        Name                => 'Service Name',
        Calendar            => 'Calendar1',  # (optional)
        FirstResponseTime   => 120,          # (optional)
        FirstResponseNotify => 60,           # (optional) notify agent if first response escalation is 60% reached
        UpdateTime          => 180,          # (optional)
        UpdateNotify        => 80,           # (optional) notify agent if update escalation is 80% reached
        SolutionTime        => 580,          # (optional)
        SolutionNotify      => 80,           # (optional) notify agent if solution escalation is 80% reached
        ValidID             => 1,
        Comment             => 'Comment',    # (optional)
        UserID              => 1,
    );

=cut

sub SLAAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Need $Argument!",
            );
            return;
        }
    }

    # check service ids
    if ( defined $Param{ServiceIDs} && ref $Param{ServiceIDs} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => 'ServiceIDs must be an array reference!',
        );
        return;
    }

    # set default values
    $Param{ServiceIDs}          ||= [];
    $Param{Calendar}            ||= '';
    $Param{Comment}             ||= '';
    $Param{FirstResponseTime}   ||= 0;
    $Param{FirstResponseNotify} ||= 0;
    $Param{UpdateTime}          ||= 0;
    $Param{UpdateNotify}        ||= 0;
    $Param{SolutionTime}        ||= 0;
    $Param{SolutionNotify}      ||= 0;

    # quote
    for my $Argument (qw(Name Calendar Comment)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument ( qw(FirstResponseTime FirstResponseNotify UpdateTime UpdateNotify SolutionTime SolutionNotify ValidID UserID) ) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # cleanup given params
    for my $Argument (qw(Name Comment)) {
        $Self->{CheckItemObject}->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );
    }

    # add sla to database
    my $Success = $Self->{DBObject}->Do(
        SQL => "INSERT INTO sla "
            . "(name, calendar_name, first_response_time, first_response_notify, "
            . "update_time, update_notify, solution_time, solution_notify, "
            . "valid_id, comments, create_time, create_by, change_time, change_by) VALUES "
            . "('$Param{Name}', '$Param{Calendar}', $Param{FirstResponseTime}, "
            . "$Param{FirstResponseNotify}, $Param{UpdateTime}, $Param{UpdateNotify}, "
            . "$Param{SolutionTime}, $Param{SolutionNotify}, $Param{ValidID}, '$Param{Comment}', "
            . "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})",
    );

    return if !$Success;

    # get sla id
    $Self->{DBObject}->Prepare(
        SQL   => "SELECT id FROM sla WHERE name = '$Param{Name}'",
        Limit => 1,
    );

    # fetch the result
    my $SLAID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $SLAID = $Row[0];
    }

    # check sla id
    if (!$SLAID) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => 'New SLA not found in database!',
        );
        return;
    }

    # remove all existing allocations
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM service_sla WHERE sla_id = $SLAID",
    );

    # add the new allocations
    for my $ServiceID ( @{ $Param{ServiceIDs} } ) {

        # quote
        $ServiceID = $Self->{DBObject}->Quote( $ServiceID );

        # add one allocation
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO service_sla (service_id, sla_id) VALUES ($ServiceID, $SLAID)",
        );
    }

    return $SLAID;
}

=item SLAUpdate()

update a existing sla

    my $True = $SLAObject->SLAUpdate(
        SLAID               => 2,
        ServiceIDs          => [ 1, 2, 3 ],  # (optional)
        Name                => 'Service Name',
        Calendar            => 'Calendar1',  # (optional)
        FirstResponseTime   => 120,          # (optional)
        FirstResponseNotify => 60,           # (optional) notify agent if first response escalation is 60% reached
        UpdateTime          => 180,          # (optional)
        UpdateNotify        => 80,           # (optional) notify agent if update escalation is 80% reached
        SolutionTime        => 580,          # (optional)
        SolutionNotify      => 80,           # (optional) notify agent if solution escalation is 80% reached
        ValidID             => 1,
        Comment             => 'Comment',    # (optional)
        UserID              => 1,
    );

=cut

sub SLAUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(SLAID Name ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Need $Argument!",
            );
            return;
        }
    }

    # check service ids
    if ( defined $Param{ServiceIDs} && ref $Param{ServiceIDs} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => 'ServiceIDs must be an array reference!',
        );
        return;
    }

    # reset cache
    delete $Self->{Cache}->{SLAGet}->{ $Param{SLAID} };
    delete $Self->{Cache}->{SLALookup}->{Name}->{ $Param{Name} };
    delete $Self->{Cache}->{SLALookup}->{ID}->{ $Param{SLAID} };

    # set default values
    $Param{ServiceIDs}          ||= [];
    $Param{Calendar}            ||= '';
    $Param{Comment}             ||= '';
    $Param{FirstResponseTime}   ||= 0;
    $Param{FirstResponseNotify} ||= 0;
    $Param{UpdateTime}          ||= 0;
    $Param{UpdateNotify}        ||= 0;
    $Param{SolutionTime}        ||= 0;
    $Param{SolutionNotify}      ||= 0;

    # quote
    for my $Argument (qw(Name Calendar Comment)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument ( qw(SLAID FirstResponseTime FirstResponseNotify UpdateTime UpdateNotify SolutionTime SolutionNotify ValidID UserID) ) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # cleanup given params
    for my $Argument (qw(Name Comment)) {
        $Self->{CheckItemObject}->StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );
    }

    # update service
    my $Success = $Self->{DBObject}->Do(
        SQL => "UPDATE sla SET name = '$Param{Name}', "
            . "calendar_name = '$Param{Calendar}', "
            . "first_response_time = $Param{FirstResponseTime}, "
            . "first_response_notify = $Param{FirstResponseNotify}, "
            . "update_time = $Param{UpdateTime}, "
            . "update_notify = $Param{UpdateNotify}, "
            . "solution_time = $Param{SolutionTime}, "
            . "solution_notify = $Param{SolutionNotify}, "
            . "valid_id = $Param{ValidID}, "
            . "comments = '$Param{Comment}', "
            . "change_time = current_timestamp, "
            . "change_by = $Param{UserID} "
            . "WHERE id = $Param{SLAID}",
    );

    return if !$Success;

    # remove all existing allocations
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM service_sla WHERE sla_id = $Param{SLAID}",
    );

    # add the new allocations
    for my $ServiceID ( @{ $Param{ServiceIDs} } ) {

        # quote
        $ServiceID = $Self->{DBObject}->Quote( $ServiceID );

        # add one allocation
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO service_sla "
                . "(service_id, sla_id) VALUES ($ServiceID, $Param{SLAID})",
        );
    }

    return 1;
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

$Revision: 1.21 $ $Date: 2008-05-09 13:19:08 $

=cut
