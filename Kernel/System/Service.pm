# --
# Kernel/System/Service.pm - all service function
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Service.pm,v 1.1 2007-02-20 10:56:05 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Service;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Service - service lib

=head1 SYNOPSIS

All service functions.

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
    my $ServiceObject = Kernel::System::Service->new(
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
    # check needed params
    foreach (qw(UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item ServiceList()

return an array hash reference list of services

    my $ArrayRef = $ServiceObject->ServiceList(
        ServiceID => 5,  # (optional)
    );

=cut

sub ServiceList {
    my $Self = shift;
    my %Param = @_;
    my $ListRef = [];

    $Self->_ServiceList(
        ServiceID => $Param{ServiceID} || 0,
        ListRef => $ListRef,
    );

    return $ListRef;
}

=item _ServiceList()

recursion function to generate service tree

    $ServiceObject->_ServiceList(
        ServiceID => 5,
        ListRef => $ListRef,
        ParentID => 1,
        ParentString => '',
        Disabled => 1,
    );

=cut

sub _ServiceList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    $Param{ParentString} = $Param{ParentString} || '';
    my $Where = 'parent_id IS NULL';
    if ($Param{ParentID}) {
        $Where = "parent_id = $Param{ParentID}";
    }

    # ask database
    my %Data;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, service FROM service WHERE $Where ORDER BY service",
        LIMIT => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Param{ParentString}) {
            $Data{$Row[0]} = $Param{ParentString} . '::' . $Row[1];
        }
        else {
            $Data{$Row[0]} = $Row[1];
        }
    }
    # start recursion
    foreach my $ServiceID (keys %Data) {
        my $Row = {};
        $Row->{Key} = $ServiceID;
        $Row->{Value} = $Data{$ServiceID};
        # disable row
        my $DisableChild;
        if (($Param{ServiceID} && $Param{ServiceID} eq $ServiceID) ||
            $Param{Disabled}
        ) {
            $DisableChild = 1;
            $Row->{Disabled} = 1;
        }
        push(@{$Param{ListRef}}, $Row);

        $Self->_ServiceList(
            ServiceID => $Param{ServiceID} || 0,
            Disabled => $DisableChild || 0,
            ListRef => $Param{ListRef},
            ParentID => $ServiceID,
            ParentString => $Data{$ServiceID},
        );
    }
    return 1;
}

=item ServiceGet()

return a service as hash reference

Return
    $ServiceData{ServiceID}
    $ServiceData{ParentID}
    $ServiceData{Service}
    $ServiceData{ValidID}
    $ServiceData{Comment}
    $ServiceData{CreateTime}
    $ServiceData{CreateBy}
    $ServiceData{ChangeTime}
    $ServiceData{ChangeBy}

    my $ServiceDataRef = $ServiceObject->ServiceGet(
        ServiceID => 123,
    );

=cut

sub ServiceGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ServiceID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(ServiceID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    # get service from db
    my %ServiceData = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, parent_id, service, valid_id, comments, ".
            "create_time, create_by, change_time, change_by ".
            "FROM service WHERE id = $Param{ServiceID}",
        LIMIT => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $ServiceData{ServiceID} = $Row[0];
        $ServiceData{ParentID} = $Row[1] || '';
        $ServiceData{Service} = $Row[2];
        $ServiceData{ValidID} = $Row[3];
        $ServiceData{Comment} = $Row[4] || '';
        $ServiceData{CreateTime} = $Row[5];
        $ServiceData{CreateBy} = $Row[6];
        $ServiceData{ChangeTime} = $Row[7];
        $ServiceData{ChangeBy} = $Row[8];
    }

    return \%ServiceData;
}

=item ServiceAdd()

add a service

    my $True = $ServiceObject->ServiceAdd(
        ParentID => 5,              # (optional)
        Service => 'Service Name',
        Comment => 'Comment',     # (optional)
        ValidID => 1,
    );

=cut

sub ServiceAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Service ValidID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Service Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ValidID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # check options
    if ($Param{Comment}) {
        $Param{Comment} = "'$Param{Comment}'";
    }
    else {
        $Param{Comment} = 'NULL';
    }
    if ($Param{ParentID}) {
        $Param{ParentID} = $Self->{DBObject}->Quote($Param{ParentID}, 'Integer');
    }
    else {
        $Param{ParentID} = 'NULL';
    }
    # find exists service
    my $Parent = '= ' . $Param{ParentID};
    if ($Param{ParentID} eq 'NULL') {
        $Parent = 'IS NULL';
    }
    my $Exists;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM service WHERE service = '$Param{Service}' AND parent_id $Parent",
        LIMIT => 1,
    );
    while ($Self->{DBObject}->FetchrowArray()) {
        $Exists = 1;
    }
    # insert service
    my $Return;
    if (!$Exists) {
        $Self->{DBObject}->Do(
            SQL =>"INSERT INTO service ".
                "(parent_id, service, valid_id, comments, ".
                "create_time, create_by, change_time, change_by) VALUES ".
                "($Param{ParentID}, '$Param{Service}', $Param{ValidID}, ".
                "$Param{Comment}, current_timestamp, $Self->{UserID}, current_timestamp, $Self->{UserID})",
        );
        $Return = 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't insert service! Service with same name already exists in this hierarchy."
        );
    }
    return $Return;
}

=item ServiceUpdate()

update a existing service

    my $True = $ServiceObject->ServiceUpdate(
        ServiceID => 123,
        ParentID => 5,              # (optional)
        Service => 'Service Name',
        Comment => 'Comment',     # (optional)
        ValidID => 1,
    );

=cut

sub ServiceUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ServiceID Service ValidID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Service Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ValidID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # check options
    if ($Param{Comment}) {
        $Param{Comment} = "'$Param{Comment}'";
    }
    else {
        $Param{Comment} = 'NULL';
    }
    if ($Param{ParentID}) {
        $Param{ParentID} = $Self->{DBObject}->Quote($Param{ParentID}, 'Integer');
    }
    else {
        $Param{ParentID} = 'NULL';
    }
    # find exists service
    my $Parent = '= ' . $Param{ParentID};
    if ($Param{ParentID} eq 'NULL') {
        $Parent = 'IS NULL';
    }
    my $Exists;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM service WHERE service = '$Param{Service}' AND parent_id $Parent",
        LIMIT => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Param{ServiceID} ne $Row[0]) {
            $Exists = 1;
        }
    }
    # update service
    my $Return;
    if (!$Exists) {
        $Self->{DBObject}->Do(
            SQL => "UPDATE service SET parent_id = $Param{ParentID}, service = '$Param{Service}', ".
                "valid_id = $Param{ValidID}, ".
                "comments = $Param{Comment}, change_time = current_timestamp, change_by = $Self->{UserID} ".
                "WHERE id = $Param{ServiceID}",
        );
        $Return = 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't update service! Service with same name already exists in this hierarchy.",
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

$Revision: 1.1 $ $Date: 2007-02-20 10:56:05 $

=cut