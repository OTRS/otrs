# --
# Kernel/System/Service.pm - all service function
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Service.pm,v 1.14 2007-06-28 22:10:05 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Service;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.14 $';
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
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

=item ServiceList()

return a hash list of services

    my %ServiceList = $ServiceObject->ServiceList(
        Valid => 0,   # (optional) default 1 (0|1)
        UserID => 1,
    );

=cut

sub ServiceList {
    my $Self = shift;
    my %Param = @_;
    my %ServiceList;
    my %ServiceValidList;
    # check needed stuff
    foreach (qw(UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # check valid param
    if (!defined($Param{Valid})) {
        $Param{Valid} = 1;
    }
    # quote
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # ask database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name, valid_id FROM service",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $ServiceList{$Row[0]} = $Row[1];
        $ServiceValidList{$Row[0]} = $Row[2];
    }
    if ($Param{Valid}) {
        # get valid ids
        my @ValidIDs = $Self->{ValidObject}->ValidIDsGet();
        # duplicate service list
        my %ServiceListTmp = %ServiceList;
        # add suffix for correct sorting
        foreach my $ServiceID (keys %ServiceListTmp) {
            $ServiceListTmp{$ServiceID} .= '::';
        }
        my %ServiceInvalidList;
        foreach my $ServiceID (sort {$ServiceListTmp{$a} cmp $ServiceListTmp{$b}} keys %ServiceListTmp) {
            my $Invalid = 1;
            foreach my $ValidID (@ValidIDs) {
                if ($ServiceValidList{$ServiceID} eq $ValidID) {
                    $Invalid = 0;
                    last;
                }
            }
            if ($Invalid) {
                $ServiceInvalidList{$ServiceList{$ServiceID}} = 1;
                delete($ServiceList{$ServiceID});
            }
        }
        # delete invalid services an childs
        foreach my $ServiceID (keys %ServiceList) {
            foreach my $InvalidName (keys %ServiceInvalidList) {
                if ($ServiceList{$ServiceID} =~ /^($InvalidName)::/) {
                    delete($ServiceList{$ServiceID});
                    last;
                }
            }
        }
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
        $ServiceData{Comment} = $Row[3] || '';
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
        # check cache
        if ($Self->{"Cache::ServiceLookup::ID::$Param{ServiceID}"}) {
            return $Self->{"Cache::ServiceLookup::ID::$Param{ServiceID}"};
        }
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
        # cache
        $Self->{"Cache::ServiceLookup::ID::$Param{ServiceID}"} = $ServiceName;
        return $ServiceName;
    }
    else {
        # check cache
        if ($Self->{"Cache::ServiceLookup::Name::$Param{Name}"}) {
            return $Self->{"Cache::ServiceLookup::Name::$Param{Name}"};
        }
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
        # cache
        $Self->{"Cache::ServiceLookup::Name::$Param{Name}"} = $ServiceID;
        return $ServiceID;
    }
}

=item ServiceAdd()

add a service

    my $ServiceID = $ServiceObject->ServiceAdd(
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
    $Param{Comment} = $Param{Comment} || '';
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
        # quote
        $Param{ParentID} = $Self->{DBObject}->Quote($Param{ParentID}, 'Integer');
    }
    # find existing service
    my $Exists;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM service WHERE name = '$Param{FullName}'",
        Limit => 1,
    );
    while ($Self->{DBObject}->FetchrowArray()) {
        $Exists = 1;
    }
    # add service to database
    my $Return;
    if (!$Exists) {
        if ($Self->{DBObject}->Do(
            SQL =>"INSERT INTO service ".
                "(name, valid_id, comments, create_time, create_by, change_time, change_by) VALUES ".
                "('$Param{FullName}', $Param{ValidID}, '$Param{Comment}', ".
                "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})",
        )) {
            # get service id
            $Self->{DBObject}->Prepare(
                SQL => "SELECT id FROM service WHERE name = '$Param{FullName}'",
                Limit => 1,
            );
            my $ServiceID;
            while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                $ServiceID = $Row[0];
            }
            return $ServiceID;
        }
        else {
            return;
        }
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
    $Param{Comment} = $Param{Comment} || '';
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
        # quote
        $Param{ParentID} = $Self->{DBObject}->Quote($Param{ParentID}, 'Integer');
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

=item ServiceSearch()

return service ids as an array

    my @ServiceList = $ServiceObject->ServiceSearch(
        Name => 'Service Name',  # (optional)
        Limit => 122,            # (optional) default 1000
        UserID => 1,
    );

=cut

sub ServiceSearch {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    $Param{Limit} = $Param{Limit} || 1000;
    $Param{Name} =~ s/^\s+//;
    $Param{Name} =~ s/\s+$//;
    # quote
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "SELECT id FROM service WHERE valid_id = 1 ";
    if ($Param{Name}) {
        $Param{Name} =~ s/\*/%/g;
        $Param{Name} =~ s/%%/%/g;
        $SQL .= "AND name LIKE '$Param{Name}' ";
    }
    $SQL .= "ORDER BY name";
    # search service in db
    $Self->{DBObject}->Prepare(SQL => $SQL);
    my @ServiceList;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@ServiceList, $Row[0]);
    }
    return @ServiceList;
}

=item CustomerUserServiceMemberList()

returns a list of customeruser/service members

    ServiceID: service id
    CustomerUserLogin: customer user login
    ServiceIDs: service ids (array ref)
    CustomerUserLogins: customer user logins (array ref)

    Result: HASH -> returns a hash of key => service id, value => service name
            Name -> returns an array of user names
            ID   -> returns an array of user ids

    Example (get services of customer user):

    $ServiceObject->CustomerUserServiceMemberList(
        CustomerUserLogin => 'Test',
        Result => 'HASH',
    );

    Example (get customer user of service):

    $ServiceObject->CustomerUserServiceMemberList(
        ServiceID => $ID,
        Result => 'HASH',
    );

=cut

sub CustomerUserServiceMemberList {
    my $Self = shift;
    my %Param = @_;
    my @ServiceIDs;
    my @CustomerUserLogins;
    # check needed stuff
    foreach (qw(Result)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Param{ServiceID} && !$Param{CustomerUserLogin} && !$Param{ServiceIDs} && !$Param{CustomerUserLogins}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need ServiceID or CustomerUserLogin or ServiceIDs or CustomerUserLogins!"
        );
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ServiceID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # create cache key
    my $CacheKey = 'CustomerUserServiceMemberList::'.$Param{Result}.'::';
    if ($Param{ServiceID}) {
        $CacheKey .= 'ServiceID::'.$Param{ServiceID};
    }
    elsif ($Param{CustomerUserLogin}) {
        $CacheKey .= 'CustomerUserLogin::'.$Param{CustomerUserLogin};
    }
    elsif ($Param{ServiceIDs}) {
        @ServiceIDs = sort(@{$Param{ServiceIDs}});
    }
    elsif ($Param{CustomerUserLogins}) {
        @CustomerUserLogins = sort(@{$Param{CustomerUserLogins}});
    }
    # check cache
    if ($Param{ServiceID} || $Param{CustomerUserLogin}) {
        if ($Self->{ForceCache}) {
            $Param{Cached} = $Self->{ForceCache};
        }
        if ($Param{Cached} && $Self->{$CacheKey}) {
            if (ref($Self->{$CacheKey}) eq 'ARRAY') {
                return @{$Self->{$CacheKey}};
            }
            elsif (ref($Self->{$CacheKey}) eq 'HASH') {
                return %{$Self->{$CacheKey}};
            }
        }
    }
    # sql
    my %Data = ();
    my @Name = ();
    my @ID = ();
    my $SQL = "SELECT scu.service_id, scu.customer_user_login, s.name ".
        " FROM ".
        " service_customer_user scu, service s".
        " WHERE " .
        " s.valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} ) ".
        " AND ".
        " s.id = scu.service_id ".
        " AND ";
    if ($Param{ServiceID}) {
        $SQL .= " scu.service_id = $Param{ServiceID}";
    }
    elsif ($Param{CustomerUserLogin}) {
        $SQL .= " scu.customer_user_login = '$Param{CustomerUserLogin}'";
    }
    elsif ($Param{ServiceIDs}) {
        my @ServiceIDsQuote;
        foreach (@ServiceIDs) {
            push (@ServiceIDsQuote, $Self->{DBObject}->Quote($_, 'Integer'));
        }
        my $ServiceString = join(',', @ServiceIDsQuote);
        $SQL .= " scu.service_id IN ($ServiceString)";
    }
    elsif ($Param{CustomerUserLogins}) {
        $SQL .= " LOWER(scu.customer_user_login) IN (";
        my $Exists = 0;
        foreach (@CustomerUserLogins) {
            if ($Exists) {
                $SQL .= ", ";
            }
            else {
                $Exists = 1;
            }
            $SQL .= "LOWER('".$Self->{DBObject}->Quote($_)."')";
        }
        $SQL .= ") ";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my $Key = '';
        my $Value = '';
        if ($Param{ServiceID} || $Param{ServiceIDs}) {
            $Key = $Row[1];
            $Value = $Row[0];
        }
        else {
            $Key = $Row[0];
            $Value = $Row[2];
        }
        # remember permissions
        if (!defined($Data{$Key})) {
            $Data{$Key} = $Value;
            push (@Name, $Value);
            push (@ID, $Key);
        }
    }
    # return result
    if ($Param{Result} && $Param{Result} eq 'ID') {
        if ($Param{ServiceID} || $Param{CustomerUserLogin}) {
            # cache result
            $Self->{$CacheKey} = \@ID;
        }
        return @ID;
    }
    if ($Param{Result} && $Param{Result} eq 'Name') {
        if ($Param{ServiceID} || $Param{CustomerUserLogin}) {
            # cache result
            $Self->{$CacheKey} = \@Name;
        }
        return @Name;
    }
    else {
        if ($Param{ServiceID} || $Param{CustomerUserLogin}) {
            # cache result
            $Self->{$CacheKey} = \%Data;
        }
        return %Data;
    }
}

=item CustomerUserServiceMemberAdd()

to add a member to a service

    $ServiceObject->CustomerUserServiceMemberAdd(
        CustomerUserLogin => 'Test1',
        ServiceID => 6,
        Active => 1,
        UserID => 123,
    );

=cut

sub CustomerUserServiceMemberAdd {
    my $Self = shift;
    my %Param = @_;
    my $count;
    # check needed stuff
    foreach (qw(CustomerUserLogin ServiceID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # db quote
    foreach (qw(CustomerUserLogin)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ServiceID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # delete existing relation
    my $SQL = "DELETE FROM service_customer_user ".
        " WHERE ".
        " customer_user_login = '$Param{CustomerUserLogin}' ".
        " AND ".
        " service_id = $Param{ServiceID}";
    $Self->{DBObject}->Do(SQL => $SQL);
    if ($Param{Active}) {
        # insert new permission
        $SQL = "INSERT INTO service_customer_user ".
            " (customer_user_login, service_id, create_time, create_by) ".
            " VALUES ".
            " ('$Param{CustomerUserLogin}', $Param{ServiceID}, ".
            " current_timestamp, $Param{UserID})";
        return $Self->{DBObject}->Do(SQL => $SQL);
    }
    else {
        return;
    }
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

$Revision: 1.14 $ $Date: 2007-06-28 22:10:05 $

=cut
