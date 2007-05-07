# --
# Kernel/System/Service.pm - all service function
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Service.pm,v 1.5 2007-05-07 17:23:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Service;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.5 $';
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

    return $Self;
}

=item ServiceList()

return a hash list of services

    my %ServiceList = $ServiceObject->ServiceList(
        UserID => 1,
    );

=cut

sub ServiceList {
    my $Self = shift;
    my %Param = @_;
    my %ServiceList;
    # check needed stuff
    foreach (qw(UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM service",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $ServiceList{$Row[0]} = $Row[1];
    }

    return %ServiceList;
}

=item ServiceGet()

return a service as hash

Return
    $ServiceData{ServiceID}
    $ServiceData{ParentID}
    $ServiceData{Name}
    $ServiceData{NameShort}
    $ServiceData{ValidID}
    $ServiceData{Comment}
    $ServiceData{CreateTime}
    $ServiceData{CreateBy}
    $ServiceData{ChangeTime}
    $ServiceData{ChangeBy}

    my %ServiceData = $ServiceObject->ServiceGet(
        ServiceID => 123,
        UserID => 1,
    );

=cut

sub ServiceGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ServiceID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(ServiceID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get service from db
    my %ServiceData = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name, valid_id, comments, create_time, create_by, change_time, change_by ".
            "FROM service WHERE id = $Param{ServiceID}",
        Limit => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $ServiceData{ServiceID} = $Row[0];
        $ServiceData{Name} = $Row[1];
        $ServiceData{ValidID} = $Row[2];
        $ServiceData{Comment} = $Row[3];
        $ServiceData{CreateTime} = $Row[4];
        $ServiceData{CreateBy} = $Row[5];
        $ServiceData{ChangeTime} = $Row[6];
        $ServiceData{ChangeBy} = $Row[7];
    }
    # create short name and parentid
    $ServiceData{NameShort} = $ServiceData{Name};
    if ($ServiceData{Name} =~ /^(.*)::(.+?)$/) {
        $ServiceData{NameShort} = $2;
        # lookup parent
        my $ServiceID = $Self->ServiceLookup(
            Name => $1,
        );
        $ServiceData{ParentID} = $ServiceID;
    }
    return %ServiceData;
}

=item ServiceLookup()

return a service name and id

    my $ServiceName = $ServiceObject->ServiceLookup(
        ServiceID => 123,
    );

    or

    my $ServiceID = $ServiceObject->ServiceLookup(
        Name => 'Service::SubService',
    );

=cut

sub ServiceLookup {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ServiceID} && !$Param{Name}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ServiceID or Name!");
        return;
    }
    if ($Param{ServiceID}) {
        my $ServiceName;
        # quote
        $Param{ServiceID} = $Self->{DBObject}->Quote($Param{ServiceID}, 'Integer');
        # lookup
        $Self->{DBObject}->Prepare(
            SQL => "SELECT name FROM service WHERE id = $Param{ServiceID}",
            Limit => 1,
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $ServiceName = $Row[0];
        }
        return $ServiceName;
    }
    else {
        my $ServiceID;
        # quote
        $Param{Name} = $Self->{DBObject}->Quote($Param{Name});
        # lookup
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM service WHERE name = '$Param{Name}'",
            Limit => 1,
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $ServiceID = $Row[0];
        }
        return $ServiceID;
    }
}

=item ServiceAdd()

add a service

    my $True = $ServiceObject->ServiceAdd(
        Name => 'Service Name',
        ParentID => 1,           # (optional)
        ValidID => 1,
        Comment => 'Comment',    # (optional)
        UserID => 1,
    );

=cut

sub ServiceAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    chomp($Param{Name});
    # check service name
    if ($Param{Name} =~ /::/) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't add service! Invalid Service name '$Param{Name}'!",
        );
        return;
    }
    # create full name
    $Param{FullName} = $Param{Name};
    # get parent name
    if ($Param{ParentID}) {
        my $ParentName = $Self->ServiceLookup(
            ServiceID => $Param{ParentID},
        );
        if ($ParentName) {
            $Param{FullName} = $ParentName . '::' . $Param{Name};
        }
    }
    # find exists service
    my $Exists;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM service WHERE name = '$Param{FullName}'",
        Limit => 1,
    );
    while ($Self->{DBObject}->FetchrowArray()) {
        $Exists = 1;
    }
    # insert service
    my $Return;
    if (!$Exists) {
        $Self->{DBObject}->Do(
            SQL =>"INSERT INTO service ".
                "(name, valid_id, comments, create_time, create_by, change_time, change_by) VALUES ".
                "('$Param{FullName}', $Param{ValidID}, '$Param{Comment}', ".
                "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})",
        );
        my $ID = '';
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM service WHERE name = '$Param{FullName}'",
            Limit => 1,
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $ID = $Row[0];
        }
        return $ID;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't add service! Service with same name and parent already exists."
        );
        return;
    }
}

=item ServiceUpdate()

update a existing service

    my $True = $ServiceObject->ServiceUpdate(
        ServiceID => 123,
        ParentID => 1,           # (optional)
        Name => 'Service Name',
        ValidID => 1,
        Comment => 'Comment',    # (optional)
        UserID => 1,
    );

=cut

sub ServiceUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ServiceID Name ValidID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ServiceID ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    chomp($Param{Name});
    # check service name
    if ($Param{Name} =~ /::/) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't update service! Invalid Service name '$Param{Name}'!",
        );
        return;
    }
    # get old name of service
    my $OldServiceName = $Self->ServiceLookup(
        ServiceID => $Param{ServiceID},
    );
    # create full name
    $Param{FullName} = $Param{Name};
    # get parent name
    if ($Param{ParentID}) {
        my $ParentName = $Self->ServiceLookup(
            ServiceID => $Param{ParentID},
        );
        if ($ParentName) {
            $Param{FullName} = $ParentName . '::' . $Param{Name};
        }
        # check, if selected parent was a child of this service
        if ($Param{FullName} =~ /^($OldServiceName)::/) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't update service! Invalid parent was selected."
            );
            return;
        }
    }
    # find exists service
    my $Exists;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM service WHERE name = '$Param{FullName}'",
        Limit => 1,
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Param{ServiceID} ne $Row[0]) {
            $Exists = 1;
        }
    }
    # update service
    my $Return;
    if (!$Exists) {
        # update service
        $Self->{DBObject}->Do(
            SQL => "UPDATE service SET name = '$Param{FullName}', valid_id = $Param{ValidID}, ".
                "comments = '$Param{Comment}', change_time = current_timestamp, change_by = $Param{UserID} ".
                "WHERE id = $Param{ServiceID}",
        );
        # find all childs
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id, name FROM service WHERE name LIKE '". $OldServiceName ."::%'",
        );
        my @Childs;
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            my %Child;
            $Child{ServiceID} = $Row[0];
            $Child{Name} = $Row[1];
            push(@Childs, \%Child);
        }
        # update childs
        foreach my $Child (@Childs) {
            $Child->{Name} =~ s/^($OldServiceName)::/$Param{FullName}::/;
            $Self->{DBObject}->Do(
                SQL => "UPDATE service SET name = '$Child->{Name}' WHERE id = $Child->{ServiceID}",
            );
        }
        $Return = 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't update service! Service with same name and parent already exists."
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

$Revision: 1.5 $ $Date: 2007-05-07 17:23:24 $

=cut
