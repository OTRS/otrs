# --
# Kernel/System/SLA.pm - all sla function
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: SLA.pm,v 1.1 2007-02-23 11:37:42 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::SLA;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::SLA - sla lib

=head1 SYNOPSIS

All sla functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

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
        LogObject => $LogObject,
    );
    my $SLAObject = Kernel::System::SLA->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item SLAList()

return a hash list of slas

    my %SLAList = $SLAObject->SLAList(
        ServiceID => 1,  # (optional)
        UserID => 1,
    );

=cut

sub SLAList {
    my $Self = shift;
    my %Param = @_;
    my %SLAList;
    # check needed stuff
    foreach (qw(ServiceID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # check ServiceID
    my $Where = '';
    if ($Param{ServiceID}) {
        $Param{ServiceID} = $Self->{DBObject}->Quote($Param{ServiceID}, 'Integer');
        $Where = "WHERE service_id = $Param{ServiceID}";
    }
    # ask database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM sla $Where",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $SLAList{$Row[0]} = $Row[1];
    }

    return %SLAList;
}

=item SLAGet()

return a sla as hash

Return
    $SLAData{SLAID}
    $SLAData{ServiceID}
    $SLAData{Name}
    $SLAData{CalendarName}
    $SLAData{ResponseTime}
    $SLAData{MaxTimeToRepair}
    $SLAData{MinTimeBetweenIncidents}
    $SLAData{ValidID}
    $SLAData{Comment}
    $SLAData{CreateTime}
    $SLAData{CreateBy}
    $SLAData{ChangeTime}
    $SLAData{ChangeBy}

    my %SLAData = $SLAObject->SLAGet(
        SLAID => 123,
        UserID => 1,
    );

=cut

sub SLAGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SLAID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(SLAID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get sla from db
    my %SLAData = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, service_id, name, calendar_name, response_time, max_time_to_repair, ".
            "min_time_between_incidents, valid_id, comments, create_time, create_by, change_time, change_by ".
            "FROM sla WHERE id = $Param{SLAID}",
        LIMIT => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $SLAData{SLAID} = $Row[0];
        $SLAData{ServiceID} = $Row[1];
        $SLAData{Name} = $Row[2];
        $SLAData{CalendarName} = $Row[3];
        $SLAData{ResponseTime} = $Row[4];
        $SLAData{MaxTimeToRepair} = $Row[5];
        $SLAData{MinTimeBetweenIncidents} = $Row[6];
        $SLAData{ValidID} = $Row[7];
        $SLAData{Comment} = $Row[8];
        $SLAData{CreateTime} = $Row[9];
        $SLAData{CreateBy} = $Row[10];
        $SLAData{ChangeTime} = $Row[11];
        $SLAData{ChangeBy} = $Row[12];
    }
    return %SLAData;
}

=item SLALookup()

return a sla id, name and service_id

    my $SLAName = $SLAObject->SLALookup(
        SLAID => 123,
    );

    or

    my $SLAID = $SLAObject->SLALookup(
        ServiceID => 5,
        Name => 'SLA Name',
    );

=cut

sub SLALookup {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{SLAID} && !($Param{ServiceID} && $Param{Name})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need SLAID OR ServiceID and Name!");
        return;
    }
    if ($Param{SLAID}) {
        my $SLAName;
        # quote
        $Param{SLAID} = $Self->{DBObject}->Quote($Param{SLAID}, 'Integer');
        # lookup
        $Self->{DBObject}->Prepare(
            SQL => "SELECT name FROM sla WHERE id = $Param{SLAID}",
            LIMIT => 1,
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $SLAName = $Row[0];
        }
        return $SLAName;
    }
    else {
        my $SLAID;
        # quote
        $Param{ServiceID} = $Self->{DBObject}->Quote($Param{ServiceID}, 'Integer');
        $Param{Name} = $Self->{DBObject}->Quote($Param{Name});
        # lookup
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM sla WHERE service_id = $Param{ServiceID} AND name = '$Param{Name}'",
            LIMIT => 1,
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $SLAID = $Row[0];
        }
        return $SLAID;
    }
}

=item SLAAdd()

add a sla

    my $True = $SLAObject->SLAAdd(
        ServiceID => 1,
        Name => 'Service Name',
        CalendarName => 'Calendar1',
        ResponseTime => 120,
        MaxTimeToRepair => 500,
        MinTimeBetweenIncidents => 3443,
        ValidID => 1,
        Comment => 'Comment',             # (optional)
        UserID => 1,
    );

=cut

sub SLAAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ServiceID Name CalendarName ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # check integers
    foreach (qw(ResponseTime MaxTimeToRepair MinTimeBetweenIncidents)) {
        chomp($Param{$_});
        if ($Param{$_}) {
            if ($Param{$_} !~ /^\d{1,10}$/) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Invalid integer in $_!",
                );
                return;
            }
        }
        else {
            $Param{$_} = 0;
        }
    }
    # quote
    foreach (qw(Name CalendarName Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ServiceID ResponseTime MaxTimeToRepair MinTimeBetweenIncidents ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    chomp($Param{Name});
    # find exists sla
    my $Exists;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM sla WHERE service_id = $Param{ServiceID} AND name = '$Param{Name}'",
        LIMIT => 1,
    );
    while ($Self->{DBObject}->FetchrowArray()) {
        $Exists = 1;
    }
    # insert sla
    my $Return;
    if (!$Exists) {
        $Self->{DBObject}->Do(
            SQL =>"INSERT INTO sla ".
                "(service_id, name, calendar_name, response_time, max_time_to_repair, min_time_between_incidents, ".
                "valid_id, comments, create_time, create_by, change_time, change_by) VALUES ".
                "($Param{ServiceID}, '$Param{Name}', '$Param{CalendarName}', $Param{ResponseTime}, ".
                "$Param{MaxTimeToRepair}, $Param{MinTimeBetweenIncidents}, $Param{ValidID}, '$Param{Comment}', ".
                "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})",
        );
        $Return = 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't add sla! SLA with same name already exists for this service."
        );
    }
    return $Return;
}

=item SLAUpdate()

update a existing sla

    my $True = $SLAObject->SLAUpdate(
        SLAID => 2,
        ServiceID => 1,
        Name => 'Service Name',
        CalendarName => 'Calendar1',
        ResponseTime => 120,
        MaxTimeToRepair => 500,
        MinTimeBetweenIncidents => 3443,
        ValidID => 1,
        Comment => 'Comment',             # (optional)
        UserID => 1,
    );

=cut

sub SLAUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(SLAID ServiceID Name CalendarName ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # check integers
    foreach (qw(ResponseTime MaxTimeToRepair MinTimeBetweenIncidents)) {
        chomp($Param{$_});
        if ($Param{$_}) {
            if ($Param{$_} !~ /^\d{1,10}$/) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Invalid integer in $_!",
                );
                return;
            }
        }
        else {
            $Param{$_} = 0;
        }
    }
    # quote
    foreach (qw(Name CalendarName Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(SLAID ServiceID ResponseTime MaxTimeToRepair MinTimeBetweenIncidents ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    chomp($Param{Name});
    # find exists sla
    my $Exists;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM sla WHERE service_id = $Param{ServiceID} AND name = '$Param{Name}'",
        LIMIT => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Param{SLAID} ne $Row[0]) {
            $Exists = 1;
        }
    }
    # update service
    my $Return;
    if (!$Exists) {
        # update service
        $Self->{DBObject}->Do(
            SQL => "UPDATE sla SET service_id = $Param{ServiceID}, name = '$Param{Name}', ".
                "calendar_name = '$Param{CalendarName}', response_time = $Param{ResponseTime}, ".
                "max_time_to_repair = $Param{MaxTimeToRepair}, ".
                "min_time_between_incidents = $Param{MinTimeBetweenIncidents}, valid_id = $Param{ValidID}, ".
                "comments = '$Param{Comment}', change_time = current_timestamp, change_by = $Param{UserID} ".
                "WHERE id = $Param{SLAID}",
        );
        $Return = 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't update sla! SLA with same name already exists for this service."
        );
    }
    return $Return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2007-02-23 11:37:42 $

=cut