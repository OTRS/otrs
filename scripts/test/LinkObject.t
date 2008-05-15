# --
# LinkObject.t - link object module testscript
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LinkObject.t,v 1.5 2008-05-15 11:47:58 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Kernel::System::Ticket;
use Kernel::System::LinkObject;

$Self->{TicketObject} = Kernel::System::Ticket->new(
    %{$Self},
);
$Self->{LinkObject} = Kernel::System::LinkObject->new(
    %{$Self},
    UserID => 1,
);
$Self->{LinkObject}->LoadBackend( Module => 'Ticket' );

my $TicketID1 = $Self->{TicketObject}->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

my $TicketID2 = $Self->{TicketObject}->TicketCreate(
    Title        => 'Some Ticket Title2',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# link
my $Link = $Self->{LinkObject}->LinkObject(
    LinkType    => 'Parent',
    LinkID1     => $TicketID1,
    LinkObject1 => 'Ticket',
    LinkID2     => $TicketID2,
    LinkObject2 => 'Ticket',
    UserID      => 1,
);

$Self->True(
    $Link || 0,
    'LinkObject()',
);

my %Links = $Self->{LinkObject}->AllLinkedObjects(
    Object   => 'Ticket',
    ObjectID => $TicketID1,
    UserID   => 1,
);

$Self->True(
    !( %{ $Links{Parent}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Parent - TicketID1',
);
$Self->True(
    ( %{ $Links{Child}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Child - TicketID1',
);
$Self->True(
    !( %{ $Links{Normal}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Normal - TicketID1',
);

%Links = $Self->{LinkObject}->AllLinkedObjects(
    Object   => 'Ticket',
    ObjectID => $TicketID2,
    UserID   => 1,
);
$Self->True(
    ( %{ $Links{Parent}->{Ticket} } ) || 0,
    'AllLinkedObjects() - TicketID2',
);
$Self->True(
    !( %{ $Links{Child}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Child - TicketID1',
);
$Self->True(
    !( %{ $Links{Normal}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Normal - TicketID1',
);

# unlink
my $Unlink = $Self->{LinkObject}->UnlinkObject(
    LinkType    => 'Child',
    LinkID1     => $TicketID1,
    LinkObject1 => 'Ticket',
    LinkID2     => $TicketID2,
    LinkObject2 => 'Ticket',
    UserID      => 1,
);
$Self->True(
    $Unlink || 0,
    'Unlink() - TicketID1/TicketID2',
);

%Links = $Self->{LinkObject}->AllLinkedObjects(
    Object   => 'Ticket',
    ObjectID => $TicketID1,
    UserID   => 1,
);
$Self->True(
    !( %{ $Links{Parent}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Parent - TicketID1',
);
$Self->True(
    !( %{ $Links{Child}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Child - TicketID1',
);
$Self->True(
    !( %{ $Links{Normal}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Normal - TicketID1',
);

%Links = $Self->{LinkObject}->AllLinkedObjects(
    Object   => 'Ticket',
    ObjectID => $TicketID2,
    UserID   => 1,
);
$Self->True(
    !( %{ $Links{Parent}->{Ticket} } ) || 0,
    'AllLinkedObjects() - TicketID2',
);
$Self->True(
    !( %{ $Links{Child}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Child - TicketID1',
);
$Self->True(
    !( %{ $Links{Normal}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Normal - TicketID1',
);

# link
$Link = $Self->{LinkObject}->LinkObject(
    LinkType    => 'Normal',
    LinkID1     => $TicketID1,
    LinkObject1 => 'Ticket',
    LinkID2     => $TicketID2,
    LinkObject2 => 'Ticket',
    UserID      => 1,
);

$Self->True(
    $Link || 0,
    'LinkObject()',
);

%Links = $Self->{LinkObject}->AllLinkedObjects(
    Object   => 'Ticket',
    ObjectID => $TicketID1,
    UserID   => 1,
);
$Self->True(
    !( %{ $Links{Parent}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Parent - TicketID1',
);
$Self->True(
    !( %{ $Links{Child}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Child - TicketID1',
);
$Self->True(
    ( %{ $Links{Normal}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Normal - TicketID1',
);

%Links = $Self->{LinkObject}->AllLinkedObjects(
    Object   => 'Ticket',
    ObjectID => $TicketID2,
    UserID   => 1,
);
$Self->True(
    !( %{ $Links{Parent}->{Ticket} } ) || 0,
    'AllLinkedObjects() - TicketID2',
);
$Self->True(
    !( %{ $Links{Child}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Child - TicketID1',
);
$Self->True(
    ( %{ $Links{Normal}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Normal - TicketID1',
);

$Self->{TicketObject}->TicketDelete(
    TicketID => $TicketID1,
    UserID   => 1,
);
$Self->{TicketObject}->TicketDelete(
    TicketID => $TicketID2,
    UserID   => 1,
);

%Links = $Self->{LinkObject}->AllLinkedObjects(
    Object   => 'Ticket',
    ObjectID => $TicketID1,
    UserID   => 1,
);
$Self->True(
    !( %{ $Links{Parent}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Parent - TicketID1',
);
$Self->True(
    !( %{ $Links{Child}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Child - TicketID1',
);
$Self->True(
    !( %{ $Links{Normal}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Normal - TicketID1',
);

%Links = $Self->{LinkObject}->AllLinkedObjects(
    Object   => 'Ticket',
    ObjectID => $TicketID2,
    UserID   => 1,
);
$Self->True(
    !( %{ $Links{Parent}->{Ticket} } ) || 0,
    'AllLinkedObjects() - TicketID2',
);
$Self->True(
    !( %{ $Links{Child}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Child - TicketID1',
);
$Self->True(
    !( %{ $Links{Normal}->{Ticket} } ) || 0,
    'AllLinkedObjects() - Normal - TicketID1',
);

1;
