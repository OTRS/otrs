#!/usr/bin/perl -w
# --
# DBUpdate-to-2.3.pl - update script to migrate OTRS 2.2.x to 2.3.x
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: DBUpdate-to-2.3.pl,v 1.7 2008-05-16 07:19:37 martin Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::Ticket;
use Kernel::System::LinkObject;

# get options
my %Opts;
getopt( 'h', \%Opts );
if ( $Opts{'h'} ) {
    print STDOUT "DBUpdate-to-2.3.pl <Revision $VERSION> - Database migration script\n";
    print STDOUT "Copyright (c) 2001-2008 OTRS AG, http://otrs.org/\n";
    exit 1;
}

# create needed objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-DBUpdate-to-2.3',
    %CommonObject,
);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);
$CommonObject{LinkObject}   = Kernel::System::LinkObject->new(
    %CommonObject,
    UserID => 1,
);

print STDOUT "Start migration of the system...\n\n";

# start migration process
MigrateServiceSLARelation();
MigrateLinkObject();
MigrateEscalation();

print STDOUT "\nMigration of the system completed!\n";

exit 0;

=item MigrateEscalation()

this function migrates the escalation calculation

    MigrateEscalation();

=cut

sub MigrateEscalation {

    print STDOUT "NOTICE: Migrate the escalation calculation... ";

    # get all tickets
    my @TicketIDs = $CommonObject{TicketObject}->TicketSearch(

        # result (required)
        Result => 'ARRAY',

        # result limit
        Limit      => 100_000_000,
        UserID     => 1,
        Permission => 'ro',
    );

    for my $TicketID (@TicketIDs) {
        $CommonObject{TicketObject}->TicketEscalationIndexBuild(
            TicketID => $TicketID,
            UserID   => 1,
        );
    }

    print STDOUT " done\n";

    return 1;
}

=item MigrateServiceSLARelation()

this function migrates the service sla relations

    MigrateServiceSLARelation();

=cut

sub MigrateServiceSLARelation {

    print STDOUT "NOTICE: Migrate the service sla relations... ";

    # get all existing relations
    my $Success = $CommonObject{DBObject}->Prepare(
        SQL => "SELECT id, service_id FROM sla ORDER BY id ASC",
    );

    if ( !$Success ) {
        print STDOUT "impossible or not required!\n";
        return;
    }

    # fetch the result
    my @ServiceSLARelation;
    while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {

        my %Relation;
        $Relation{SLAID}     = $Row[0];
        $Relation{ServiceID} = $Row[1];

        push @ServiceSLARelation, \%Relation;
    }

    # add the new relations
    RELATION:
    for my $Relation (@ServiceSLARelation) {

        next RELATION if !$Relation->{SLAID};
        next RELATION if !$Relation->{ServiceID};

        # add one relation
        $CommonObject{DBObject}->Do(
            SQL => "INSERT INTO service_sla "
                . "(service_id, sla_id) VALUES ($Relation->{ServiceID}, $Relation->{SLAID})",
        );
    }

    print STDOUT " done\n";

    return 1;
}

=item MigrateLinkObject()

this function migrates the links between the objects

    MigrateLinkObject();

=cut

sub MigrateLinkObject {

    print STDOUT "NOTICE: Migrate the link object... ";

    # get all existing links
    my $Success = $CommonObject{DBObject}->Prepare(
        SQL => 'SELECT object_link_a_id, object_link_b_id, '
            . 'object_link_a_object, object_link_b_object, object_link_type FROM object_link',
    );

    if ( !$Success ) {
        print STDOUT "impossible or not required!\n";
        return;
    }

    # fetch the result
    my @Links;
    while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {

        my %Link;
        $Link{AID}     = $Row[0];
        $Link{BID}     = $Row[1];
        $Link{AObject} = $Row[2];
        $Link{BObject} = $Row[3];
        $Link{Type}    = $Row[4];

        push @Links, \%Link;
    }

    return if !scalar @Links;

    # lookup the object state id
    my $StateID = $CommonObject{LinkObject}->LinkStateLookup(
        Name => 'Valid',
    );

    # add the new links
    RELATION:
    for my $Link (@Links) {

        my $SourceObject = $Link->{AObject};
        my $SourceKey    = $Link->{AID};
        my $TargetObject = $Link->{BObject};
        my $TargetKey    = $Link->{BID};
        my $Type         = 'Normal';

        if ( $Link->{Type} eq 'Parent' || $Link->{Type} eq 'Child' ) {
            $Type = 'ParentChild';
        }

        # lookup the object type id
        my $TypeID = $CommonObject{LinkObject}->LinkTypeLookup(
            Name => $Type,
        );

        # add the link
        $CommonObject{LinkObject}->LinkAdd(
            SourceObject => $SourceObject,
            SourceKey    => $SourceKey,
            TargetObject => $TargetObject,
            TargetKey    => $TargetKey,
            TypeID       => $TypeID,
            StateID      => $StateID,
            UserID       => 1,
        );
    }

    print STDOUT " done\n";

    return 1;
}

1;
