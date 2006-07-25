# --
# Kernel/System/LinkObject.pm - to link objects
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: LinkObject.pm,v 1.8 2006-07-25 17:48:54 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::LinkObject;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::LinkObject - to link objects like tickets, faqs, ...

=head1 SYNOPSIS

All functions to link objects like tickets, faqs, ... configured
in Kernel/Config.pm.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::DB;
  use Kernel::System::LinkObject;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $LinkObject = Kernel::System::LinkObject->new(
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
    foreach (qw(DBObject ConfigObject LogObject TicketObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # lib object
#    my $GenericModule = "Kernel::System::Link::$Param{Module}";
#    if (!eval "require $GenericModule") {
#        die "Can't load link backend module $GenericModule! $@";
#    }
#    $Self->Backend(Module => 'Ticket');
    return $Self;
}

=item LinkObjects()

get a all linable objects

    my %LinkObjects = $LinkObject->LinkObjects(SourceObject => 'Ticket');

=cut

sub LinkObjects {
    my $Self = shift;
    my %Param = @_;
    my %ObjectList = ();
    # check needed object
    if (!$Param{SourceObject}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need SourceObject!");
        return;
    }
    # get config options
    if (!$Self->{ConfigObject}->Get('LinkObject')) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "LinkObject in Config!");
        return;
    }
    # get objects
    my %Objects = %{$Self->{ConfigObject}->Get('LinkObject')};
    if (!$Objects{$Param{SourceObject}}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No Object '$Param{SourceObject}' configured!");
        return;
    }
    # get linkable objects
    if ($Objects{$Param{SourceObject}}->{LinkObjects}) {
        foreach (@{$Objects{$Param{SourceObject}}->{LinkObjects}}) {
            if ($Objects{$_}) {
                $ObjectList{$_} = $Objects{$_}->{Name};
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message => "No LinkObject '$_' configured!",
                );
            }
        }
    }
    return %ObjectList;
}

=item LoadBackend()

to load a link object backend module, returns true (if module
is loaded) and returns false (if module load is failed)

    $LinkObject->LoadBackend(Module => $Object);

    $LinkObject->LoadBackend(Module => 'Ticket');
    $LinkObject->LoadBackend(Module => 'FAQ');

=cut

sub LoadBackend {
    my $Self = shift;
    my %Param = @_;
    if (!$Param{Module}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Module!");
        return;
    }
    # lib object
    my $GenericModule = "Kernel::System::LinkObject::$Param{Module}";
    if (!eval "require $GenericModule") {
        die "Can't load link backend module $GenericModule! $@";
    }
    @ISA = ($GenericModule);
    $Self->Init(%Param);
    return 1;
}

sub LinkObject {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(LinkType LinkID1 LinkObject1 LinkID2 LinkObject2)) {
        if (!$Param{$_}) {
             $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $SQL = "INSERT INTO object_link ".
        " (object_link_a_id, object_link_b_id, object_link_a_object, object_link_b_object, object_link_type) ".
        " VALUES ".
        " ('$Param{LinkID1}', '$Param{LinkID2}', ".
        " '$Param{LinkObject1}', '$Param{LinkObject2}', ".
        " '$Param{LinkType}')";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        $Self->BackendLinkObject(%Param);
        return 1;
    }
    else {
        return;
    }
}

sub UnlinkObject {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(LinkType LinkID1 LinkObject1 LinkID2 LinkObject2)) {
        if (!$Param{$_}) {
             $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $SQL = "DELETE FROM object_link WHERE ".
        " (object_link_a_id = '$Param{LinkID1}' ".
        " AND ".
        " object_link_b_id = '$Param{LinkID2}' ".
        " AND ".
        " object_link_a_object = '$Param{LinkObject1}' ".
        " AND ".
        " object_link_b_object = '$Param{LinkObject2}' ".
        " AND ".
        " object_link_type = '$Param{LinkType}') ".
        " OR ".
        " (object_link_a_id = '$Param{LinkID2}' ".
        " AND ".
        " object_link_b_id = '$Param{LinkID1}' ".
        " AND ".
        " object_link_a_object = '$Param{LinkObject2}' ".
        " AND ".
        " object_link_b_object = '$Param{LinkObject1}' ".
        " AND ".
        " object_link_type = '$Param{LinkType}') ";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        $Self->BackendUnlinkObject(%Param);
        return 1;
    }
    else {
        return;
    }
}

sub RemoveLinkObject {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(Object ID)) {
        if (!$Param{$_}) {
             $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $SQL = "DELETE FROM object_link WHERE ".
        " (object_link_a_id = '$Param{ID}' ".
        " AND ".
        " object_link_a_object = '$Param{Object}') ".
        " OR ".
        " (object_link_b_id = '$Param{ID}' ".
        " AND ".
        " object_link_b_object = '$Param{Object}')";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

sub LinkedObjects {
    my $Self = shift;
    my %Param = @_;
    my %Linked = ();
    my @LinkedIDs = ();
    my $SQLA = '';
    my $SQLB = '';
    foreach (qw(LinkType)) {
        if (!$Param{$_}) {
             $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # get parents
    if ($Param{LinkType} eq 'Parent' && (!$Param{LinkID2} || !$Param{LinkObject2} || !$Param{LinkObject1})) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need LinkID2, LinkObject2 and LinkObject1 for $Param{LinkType}!",
        );
        return;
    }
    # get childs
    elsif ($Param{LinkType} eq 'Child' && (!$Param{LinkID1} || !$Param{LinkObject1} || !$Param{LinkObject2})) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need LinkID1, LinkObject1 and LinkObject2 for $Param{LinkType}!",
        );
        return;
    }
    # get sisters
    elsif ($Param{LinkType} eq 'Normal' && (!$Param{LinkID1} || !$Param{LinkObject1} || !$Param{LinkObject2})) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need LinkID1, LinkObject1 and LinkObject2 for $Param{LinkType}!",
        );
        return;
    }

    if ($Param{LinkType} eq 'Parent') {
      $SQLA = "SELECT object_link_a_id FROM object_link ".
        " WHERE ".
        " object_link_b_id = '$Param{LinkID2}' ".
        " AND ".
        " object_link_b_object = '$Param{LinkObject2}' ".
        " AND ".
        " object_link_a_object = '$Param{LinkObject1}'".
        " AND ".
        " object_link_type = '$Param{LinkType}'";
      $SQLB = "SELECT object_link_a_id FROM object_link ".
        " WHERE ".
        " object_link_b_id = '$Param{LinkID2}' ".
        " AND ".
        " object_link_b_object = '$Param{LinkObject2}' ".
        " AND ".
        " object_link_a_object = '$Param{LinkObject1}'".
        " AND ".
        " object_link_type = 'Child'";

    }
    elsif ($Param{LinkType} eq 'Child') {
      $SQLA = "SELECT object_link_b_id FROM object_link ".
        " WHERE ".
        " object_link_a_id = '$Param{LinkID1}' ".
        " AND ".
        " object_link_a_object = '$Param{LinkObject1}' ".
        " AND ".
        " object_link_b_object = '$Param{LinkObject2}' ".
        " AND ".
        " object_link_type = 'Parent'";
      $SQLB = "SELECT object_link_b_id FROM object_link ".
        " WHERE ".
        " object_link_a_id = '$Param{LinkID1}' ".
        " AND ".
        " object_link_a_object = '$Param{LinkObject1}' ".
        " AND ".
        " object_link_b_object = '$Param{LinkObject2}' ".
        " AND ".
        " object_link_type = '$Param{LinkType}'";
    }
    elsif ($Param{LinkType} eq 'Normal') {
        $SQLA = "SELECT object_link_a_id ".
          " FROM ".
          " object_link ".
          " WHERE ".
          " object_link_b_id = '$Param{LinkID1}' ".
          " AND ".
          " object_link_b_object = '$Param{LinkObject1}' ".
          " AND ".
          " object_link_a_object = '$Param{LinkObject2}' ".
          " AND ".
          " object_link_type = '$Param{LinkType}'";
        $SQLB = " SELECT object_link_b_id ".
          " FROM ".
          " object_link ".
          " WHERE ".
          " object_link_a_id = '$Param{LinkID1}' ".
          " AND ".
          " object_link_a_object = '$Param{LinkObject1}' ".
          " AND ".
          " object_link_b_object = '$Param{LinkObject2}' ".
          " AND ".
          " object_link_type = '$Param{LinkType}'";
    }

    $Self->{DBObject}->Prepare(SQL => $SQLA);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@LinkedIDs, $Row[0]);
    }
    $Self->{DBObject}->Prepare(SQL => $SQLB);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@LinkedIDs, $Row[0]);
    }
    # fill up data
    foreach (@LinkedIDs) {
        my %Hash = $Self->FillDataMap(ID => $_, UserID => $Self->{UserID});
        $Linked{$_} = \%Hash;
    }
    return %Linked;
}
sub AllLinkedObjects {
    my $Self = shift;
    my %Param = @_;
    my %Links = ();
    foreach (qw(Object ObjectID)) {
        if (!$Param{$_}) {
             $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # get objects
    my %Objects = %{$Self->{ConfigObject}->Get('LinkObject')};
    foreach my $Object (keys %Objects) {
        $Param{Module} = $Object;
        $Self->LoadBackend(%Param);
        my %CLinked = $Self->LinkedObjects(
            LinkType => 'Child',
            LinkObject1 => $Param{Object},
            LinkID1 => $Param{ObjectID},
            LinkObject2 => $Object,
        );
        $Links{Child}->{$Object} = \%CLinked;
        my %PLinked = $Self->LinkedObjects(
            LinkType => 'Parent',
            LinkObject2 => $Param{Object},
            LinkID2 => $Param{ObjectID},
            LinkObject1 => $Object,
        );
        $Links{Parent}->{$Object} = \%PLinked;
        my %NLinked = $Self->LinkedObjects(
            LinkType => 'Normal',
            LinkObject1 => $Param{Object},
            LinkID1 => $Param{ObjectID},
            LinkObject2 => $Object,
        );
        $Links{Normal}->{$Object} = \%NLinked;
    }
    return %Links;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.8 $ $Date: 2006-07-25 17:48:54 $

=cut
