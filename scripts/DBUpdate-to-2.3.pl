#!/usr/bin/perl -w
# --
# DBUpdate-to-2.3.pl - update script to migrate OTRS 2.2.x to 2.3.x
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: DBUpdate-to-2.3.pl,v 1.14 2008-06-27 16:17:25 mh Exp $
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
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::CheckItem;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::Config;
use Kernel::System::Ticket;

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
$CommonObject{MainObject}      = Kernel::System::Main->new(%CommonObject);
$CommonObject{CheckItemObject} = Kernel::System::CheckItem->new(%CommonObject);
$CommonObject{EncodeObject}    = Kernel::System::Encode->new(%CommonObject);
$CommonObject{TimeObject}      = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}        = Kernel::System::DB->new(%CommonObject);
$CommonObject{SysConfigObject} = Kernel::System::Config->new(%CommonObject);

print STDOUT "Start migration of the system...\n\n";

# rebuild config
RebuildConfig();

# instance needed objects
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

# start migration process
CleanUpCacheDir();
CleanUpDatabase();
MigrateServiceSLARelation();
MigrateLinkObject();
MigrateEscalation();

print STDOUT "\nMigration of the system completed!\n";

exit 0;

=item RebuildConfig()

rebuild config files (based on Kernel/Config/Files/*.xml)

    RebuildConfig();

=cut

sub RebuildConfig {

    print STDOUT "NOTICE: Rebuild config... ";

    my $Success = $CommonObject{SysConfigObject}->WriteDefault();

    if ($Success) {
        print STDOUT " done.\n";
    }
    else {
        print STDOUT " failed.\n";
    }

    return 1;
}

=item CleanUpCacheDir()

this function removes all cache files

    CleanUpCacheDir();

=cut

sub CleanUpCacheDir {

    print STDOUT "NOTICE: Clean up old cache files... ";

    my $CacheDirectory = $CommonObject{ConfigObject}->Get('TempDir');

    # delete all cache files
    my @CacheFiles = glob( $CacheDirectory . '/*' );
    for my $CacheFile (@CacheFiles) {
        next if ( !-f $CacheFile );
        unlink $CacheFile;
    }
    print STDOUT " done.\n";

    return 1;
}

=item CleanUpDatabase()

this function removes all non existing table references

    CleanUpDatabase();

=cut

sub CleanUpDatabase {

    print STDOUT "NOTICE: Clean up non existing table references... ";

    my $Success = $CommonObject{DBObject}->Prepare(
        SQL => 'SELECT ticket_id FROM ticket_watcher',
    );
    if ( !$Success ) {
        print STDOUT " error.!\n";
        return;
    }

    # fetch watched ticket ids
    my %TicketIDsWatcher;
    while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
        $TicketIDsWatcher{ $Row[0] } = 1;
    }

    # check if ticket still exists
    for my $TicketIDWatched ( keys %TicketIDsWatcher ) {
        $CommonObject{DBObject}->Prepare(
            SQL  => 'SELECT id FROM ticket WHERE id = ?',
            Bind => [ \$TicketIDWatched ],
        );
        my $Exists = 0;
        while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
            $Exists = 1;
        }

        next if $Exists;

        # delete ticket watcher recorde
        $CommonObject{DBObject}->Do(
            SQL  => 'DELETE FROM ticket_watcher WHERE ticket_id = ?',
            Bind => [ \$TicketIDWatched ],
        );
    }

    # article flags
    $Success = $CommonObject{DBObject}->Prepare(
        SQL => 'SELECT article_id FROM article_flag',
    );
    if ( !$Success ) {
        print STDOUT " error.!\n";
        return;
    }

    # fetch article ids of article flags
    my %ArticleIDsFlag;
    while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
        $ArticleIDsFlag{ $Row[0] } = 1;
    }

    # check if article still exists
    for my $ArticleIDFlag ( keys %ArticleIDsFlag ) {
        $CommonObject{DBObject}->Prepare(
            SQL  => 'SELECT id FROM article WHERE id = ?',
            Bind => [ \$ArticleIDFlag ],
        );
        my $Exists = 0;
        while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
            $Exists = 1;
        }

        next if $Exists;

        # delete article watcher recorde
        $CommonObject{DBObject}->Do(
            SQL  => 'DELETE FROM article_flag WHERE article_id = ?',
            Bind => [ \$ArticleIDFlag ],
        );
    }

    print STDOUT " done.\n";

    return 1;
}

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

    print STDOUT " done.\n";

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
        SQL => 'SELECT id, service_id FROM sla ORDER BY id ASC',
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

    print STDOUT " done.\n";

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

        # add the link
        LinkAdd(
            SourceObject => $SourceObject,
            SourceKey    => $SourceKey,
            TargetObject => $TargetObject,
            TargetKey    => $TargetKey,
            Type         => $Type,
            State        => 'Valid',
            UserID       => 1,
        );
    }

    print STDOUT " done.\n";

    return 1;
}

=item LinkAdd()

add a new link between two elements

    $True = LinkAdd(
        SourceObject => 'Ticket',
        SourceKey    => '321',
        TargetObject => 'FAQ',
        TargetKey    => '5',
        Type         => 'ParentChild',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkAdd {
    my (%Param) = @_;

    # check needed stuff
    for my $Argument (qw(SourceObject SourceKey TargetObject TargetKey Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check if source and target are the same object
    if ( $Param{SourceObject} eq $Param{TargetObject} && $Param{SourceKey} eq $Param{TargetKey} ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => 'Impossible to link object with itself!',
        );
        return;
    }

    # lookup the object ids
    OBJECT:
    for my $Object (qw(SourceObject TargetObject)) {

        # lookup the object id
        $Param{ $Object . 'ID' } = ObjectLookup(
            Name   => $Param{$Object},
            UserID => $Param{UserID},
        );

        next OBJECT if $Param{ $Object . 'ID' };

        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Invalid $Object is given!",
        );

        return;
    }

    # lookup state id
    my $StateID = StateLookup(
        Name   => $Param{State},
        UserID => 1,
    );

    # lookup type id
    my $TypeID = TypeLookup(
        Name   => $Param{Type},
        UserID => $Param{UserID},
    );

    # check if link already exists in database
    $CommonObject{DBObject}->Prepare(
        SQL => 'SELECT source_object_id, source_key, state_id '
            . 'FROM link_relation '
            . 'WHERE ( ( source_object_id = ? AND source_key = ? '
            . 'AND target_object_id = ? AND target_key = ? ) '
            . 'OR ( source_object_id = ? AND source_key = ? '
            . 'AND target_object_id = ? AND target_key = ? ) ) '
            . 'AND type_id = ? ',
        Bind => [
            \$Param{SourceObjectID}, \$Param{SourceKey},
            \$Param{TargetObjectID}, \$Param{TargetKey},
            \$Param{TargetObjectID}, \$Param{TargetKey},
            \$Param{SourceObjectID}, \$Param{SourceKey},
            \$TypeID,
        ],
        Limit => 1,
    );

    # fetch the result
    my %Existing;
    while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
        $Existing{SourceObjectID} = $Row[0];
        $Existing{SourceKey}      = $Row[1];
        $Existing{StateID}        = $Row[2];
    }

    # link exists already
    if (%Existing) {

        # existing link has a different StateID than the new link
        if ( $Existing{StateID} ne $StateID ) {

            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Link already exists between these two objects "
                    . "with a different state id '$Existing{StateID}'!",
            );
            return;
        }

        # get type data
        my %TypeData = TypeGet(
            TypeID => $TypeID,
            UserID => $Param{UserID},
        );

        return 1 if !$TypeData{Pointed};
        return 1 if $Existing{SourceObjectID} eq $Param{SourceObjectID}
            && $Existing{SourceKey} eq $Param{SourceKey};

        # log error
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => 'Link already exists between these two objects in opposite direction!',
        );
        return;
    }

    return $CommonObject{DBObject}->Do(
        SQL => 'INSERT INTO link_relation '
            . '(source_object_id, source_key, target_object_id, target_key, '
            . 'type_id, state_id, create_time, create_by) '
            . 'VALUES (?, ?, ?, ?, ?, ?, current_timestamp, ?)',
        Bind => [
            \$Param{SourceObjectID}, \$Param{SourceKey},
            \$Param{TargetObjectID}, \$Param{TargetKey},
            \$TypeID, \$StateID, \$Param{UserID},
        ],
    );
}

=item ObjectLookup()

lookup a link object

    $ObjectID = ObjectLookup(
        Name   => 'Ticket',
        UserID => 1,
    );

=cut

sub ObjectLookup {
    my (%Param) = @_;

    # check needed stuff
    for my $Argument (qw(Name UserID)) {
        if ( !$Param{$Argument} ) {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check cache
    return $CommonObject{Cache}->{ObjectLookup}->{ $Param{Name} }
        if $CommonObject{Cache}->{ObjectLookup}->{ $Param{Name} };

    # investigate the object id
    my $ObjectID;
    TRY:
    for my $Try ( 1 .. 3 ) {

        # ask the database
        $CommonObject{DBObject}->Prepare(
            SQL   => 'SELECT id FROM link_object WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );

        # fetch the result
        while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
            $ObjectID = $Row[0];
        }

        last TRY if $ObjectID;

        # cleanup the given name
        $CommonObject{CheckItemObject}->StringClean(
            StringRef => \$Param{Name},
        );

        # check if name is valid
        if ( !$Param{Name} || $Param{Name} =~ m{ :: }xms || $Param{Name} =~ m{ \s }xms ) {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Invalid object name '$Param{Name}' is given!",
            );
            return;
        }

        next TRY if $Try == 1;

        # insert the new object
        return if !$CommonObject{DBObject}->Do(
            SQL  => 'INSERT INTO link_object (name) VALUES (?)',
            Bind => [ \$Param{Name} ],
        );
    }

    # cache result
    $CommonObject{Cache}->{ObjectLookup}->{ $Param{Name} } = $ObjectID;

    return $ObjectID;
}

=item StateLookup()

lookup a link state

    $StateID = StateLookup(
        Name   => 'Valid',
        UserID => 1,
    );

=cut

sub StateLookup {
    my (%Param) = @_;

    # check needed stuff
    for my $Argument (qw(Name UserID)) {
        if ( !$Param{$Argument} ) {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check cache
    return $CommonObject{Cache}->{StateLookup}->{ $Param{Name} }
        if $CommonObject{Cache}->{StateLookup}->{ $Param{Name} };

    # ask the database
    $CommonObject{DBObject}->Prepare(
        SQL   => 'SELECT id FROM link_state WHERE name = ?',
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $StateID;
    while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
        $StateID = $Row[0];
    }

    # check the state id
    if ( !$StateID ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Link state '$Param{Name}' not found in the database!",
        );
        return;
    }

    # cache result
    $CommonObject{Cache}->{StateLookup}->{ $Param{Name} } = $StateID;

    return $StateID;
}

=item TypeLookup()

lookup a link type

    $TypeID = TypeLookup(
        Name   => 'Normal',
        UserID => 1,
    );

=cut

sub TypeLookup {
    my (%Param) = @_;

    # check needed stuff
    for my $Argument (qw(Name UserID)) {
        if ( !$Param{$Argument} ) {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # cleanup the given name
    $CommonObject{CheckItemObject}->StringClean(
        StringRef => \$Param{Name},
    );

    # check cache
    return $CommonObject{Cache}->{TypeLookup}->{ $Param{Name} }
        if $CommonObject{Cache}->{TypeLookup}->{ $Param{Name} };

    # investigate the type id
    my $TypeID;
    TRY:
    for my $Try ( 1 .. 2 ) {

        # ask the database
        $CommonObject{DBObject}->Prepare(
            SQL   => 'SELECT id FROM link_type WHERE name = ?',
            Bind  => [ \$Param{Name} ],
            Limit => 1,
        );

        # fetch the result
        while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
            $TypeID = $Row[0];
        }

        last TRY if $TypeID;

        # check if name is valid
        if ( !$Param{Name} || $Param{Name} =~ m{ :: }xms || $Param{Name} =~ m{ \s }xms ) {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Invalid type name '$Param{Name}' is given!",
            );
            return;
        }

        # insert the new type
        return if !$CommonObject{DBObject}->Do(
            SQL => 'INSERT INTO link_type '
                . '(name, valid_id, create_time, create_by, change_time, change_by) '
                . 'VALUES (?, 1, current_timestamp, ?, current_timestamp, ?)',
            Bind => [ \$Param{Name}, \$Param{UserID}, \$Param{UserID} ],
        );
    }

    # check the state id
    if ( !$TypeID ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Link type '$Param{Name}' not found in the database!",
        );
        return;
    }

    # cache result
    $CommonObject{Cache}->{TypeLookup}->{ $Param{Name} } = $TypeID;

    return $TypeID;
}

1;
