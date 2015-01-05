#!/usr/bin/perl -w
# --
# DBUpdate-to-3.1.pl - update script to migrate OTRS 3.0.x to 3.1.x
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: DBUpdate-to-3.1.pl,v 1.85 2012-03-27 13:09:11 mg Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use vars qw($VERSION);
$VERSION = qw($Revision: 1.85 $) [1];

use Getopt::Std qw();
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::State;
use Kernel::System::SysConfig;
use Kernel::System::XML;
use Kernel::System::DynamicField;
use Kernel::System::Cache;

{

    # get options
    my %Opts;
    Getopt::Std::getopt( 'h', \%Opts );

    if ( exists $Opts{h} ) {
        print <<"EOF";

DBUpdate-to-3.1.pl <Revision $VERSION> - Upgrade scripts for OTRS 3.0.x to 3.1.x migration.
Copyright (C) 2001-2011 OTRS AG, http://otrs.org/

EOF
        exit 1;
    }

    print "\nMigration started...\n\n";

    # create common objects
    my $CommonObject = _CommonObjectsBase();

    # define the number of steps
    my $Steps = 24;

    print "Step 1 of $Steps: Refresh configuration cache... ";
    RebuildConfig($CommonObject);
    print "done.\n\n";

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    # check framework version
    print "Step 2 of $Steps: Check framework version... ";
    _CheckFrameworkVersion($CommonObject);
    print "done.\n\n";

    print "Step 3 of $Steps: Creating DynamicField tables (if necessary)... ";
    if ( _CheckDynamicFieldTables($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # insert dynamic field records, if necessary
    print "Step 4 of $Steps: Create new dynamic fields for free fields (text, key, date)... ";
    if ( !_IsFreefieldsMigrationAlreadyDone($CommonObject) ) {
        _DynamicFieldCreation($CommonObject);
    }
    print "done.\n\n";

    # migrate ticket free field
    print "Step 5 of $Steps: Migrate ticket free fields to dynamic fields... \n";
    if ( !_IsFreefieldsMigrationAlreadyDone($CommonObject) ) {
        my $TicketMigrated = _DynamicFieldTicketMigration($CommonObject);
    }
    print "done.\n\n";

    # migrate ticket free field
    print "Step 6 of $Steps: Migrate article free fields to dynamic fields... \n";
    if ( !_IsFreefieldsMigrationAlreadyDone($CommonObject) ) {
        my $ArticleMigrated = _DynamicFieldArticleMigration($CommonObject);
    }
    print "done.\n\n";

    # verify ticket migration
    my $VerificationTicketData = 1;
    print "Step 7 of $Steps: Verify if ticket data was successfully migrated... \n";
    if ( !_IsFreefieldsMigrationAlreadyDone($CommonObject) ) {
        $VerificationTicketData = _VerificationTicketData($CommonObject);
    }
    print "done.\n\n";

    # verify article migration
    my $VerificationArticleData = 1;
    print "Step 8 of $Steps: Verify if article data was successfully migrated... ";
    if ( !_IsFreefieldsMigrationAlreadyDone($CommonObject) ) {
        $VerificationArticleData = _VerificationArticleData($CommonObject);
    }
    print "done.\n\n";

    if ( !$VerificationTicketData || !$VerificationArticleData ) {
        print STDERR "Ticket or article data was not successfully migrated!\n";
        print STDERR
            "DO NOT CONTINUE THE UPGRADING PROCESS UNTIL THIS ISSUE IS FIXED, OTHERWISE YOU MAY LOSE DATA!\n";
        die;
    }

    # Migrate free fields configuration
    print "Step 9 of $Steps: Migrate free fields configuration... ";
    _MigrateFreeFieldsConfiguration($CommonObject);
    print "done.\n\n";

    print
        "Step 10 of $Steps: Update history type from 'TicketFreeTextUpdate' to 'TicketDynamicFieldUpdate'... ";
    if ( _UpdateHistoryType($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields configuration
    print "Step 11 of $Steps: Migrate free fields window configuration... ";
    if ( _MigrateWindowConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields configuration for stats
    print "Step 12 of $Steps: Migrate free fields stats configuration... ";
    if ( _MigrateStatsConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields configuration for generic agent jobs
    print "Step 13 of $Steps: Migrate free fields generic agent jobs configuration... ";
    if ( _MigrateGenericAgentJobConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields configuration for Post Master
    print "Step 14 of $Steps: Migrate free fields post master configuration... ";
    if ( _MigratePostMasterConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields responses configuration
    print "Step 15 of $Steps: Migrate free fields standard responses configuration... ";
    if ( _MigrateResponsesConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields auto responses configuration
    print "Step 16 of $Steps: Migrate free fields auto responses configuration... ";
    if ( _MigrateAutoResponsesConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields salutations configuration
    print "Step 17 of $Steps: Migrate free fields salutations configuration... ";
    if ( _MigrateSalutationsConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields signatures configuration
    print "Step 18 of $Steps: Migrate free fields signatures configuration... ";
    if ( _MigrateSignaturesConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields search profiles configuration
    print "Step 19 of $Steps: Migrate free fields search profiles configuration... ";
    if ( _MigrateSearchProfilesConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields notifications configuration
    print "Step 20 of $Steps: Migrate free fields notifications configuration... ";
    if ( _MigrateNotificationsConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Migrate free fields notification event configuration
    print "Step 21 of $Steps: Migrate free fields notification event configuration... ";
    if ( _MigrateNotificationEventConfiguration($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # remove duplicate entries on ticket_flag table
    print "Step 22 of $Steps: Checking for duplicate entries on ticket_flag table... ";
    if ( _RemoveDuplicatesTicketFlag($CommonObject) ) {
        print "\ndone.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # Clean up the cache completely at the end.
    print "Step 23 of $Steps: Clean up the cache... ";
    my $CacheObject = Kernel::System::Cache->new( %{$CommonObject} );
    $CacheObject->CleanUp();
    print "done.\n\n";

    print "Step 24 of $Steps: Refresh configuration cache another time... ";
    RebuildConfig($CommonObject);
    print "done.\n\n";

    print "Migration completed!\n";

    exit 0;
}

sub _CommonObjectsBase {
    my %CommonObject;
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-DBUpdate-to-3.1',
        %CommonObject,
    );
    $CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
    $CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
    $CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
    $CommonObject{XMLObject}    = Kernel::System::XML->new(%CommonObject);
    return \%CommonObject;
}

=item RebuildConfig($CommonObject)

refreshes the configuration to make sure that a ZZZAAuto.pm is present
after the upgrade.

    RebuildConfig($CommonObject);

=cut

sub RebuildConfig {
    my $CommonObject = shift;

    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );

    # Rebuild ZZZAAuto.pm with current values
    if ( !$SysConfigObject->WriteDefault() ) {
        die "ERROR: Can't write default config files!";
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    # reload config object
    print
        "\nIf you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";
    $CommonObject = _CommonObjectsBase();

    return 1;
}

=item _CheckFrameworkVersion()

Check if framework it's the correct one for Dinamic Fields migration.

    _CheckFrameworkVersion();

=cut

sub _CheckFrameworkVersion {
    my $CommonObject = shift;

    my $Home = $CommonObject->{ConfigObject}->Get('Home');

    # load RELEASE file
    if ( -e !"$Home/RELEASE" ) {
        die "ERROR: $Home/RELEASE does not exist!";
    }
    my $ProductName;
    my $Version;
    if ( open( my $Product, '<', "$Home/RELEASE" ) ) {
        while (<$Product>) {

            # filtering of comment lines
            if ( $_ !~ /^#/ ) {
                if ( $_ =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $ProductName = $1;
                }
                elsif ( $_ =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Version = $1;
                }
            }
        }
        close($Product);
    }
    else {
        die "ERROR: Can't read $CommonObject->{Home}/RELEASE: $!";
    }

    if ( $ProductName ne 'OTRS' ) {
        die "Not framework version required"
    }
    if ( $Version !~ /^3\.1(.*)$/ ) {
        die "Not framework version required"
    }

    return 1;
}

=item _CheckDynamicFieldTables($CommonObject)

Checks if the DynamicField tables exist, and if they don't they will be created.

    _CheckDynamicFieldTables($CommonObject);

=cut

sub _CheckDynamicFieldTables {
    my $CommonObject = shift;

    # execute a count query, it will return a value even
    # if table is empty, and an error if the table is not created yet

    my $SuccessMaster = $CommonObject->{DBObject}->Do(
        SQL => 'SELECT count(id) FROM dynamic_field',
    );

    if ( !$SuccessMaster ) {
        die "Check if dynamic_field table exists, failed!";
    }

    my $SuccessSlave = $CommonObject->{DBObject}->Do(
        SQL => 'SELECT count(field_id) FROM dynamic_field_value',
    );

    if ( !$SuccessSlave ) {
        die "Check if dynamic_field_value table exists, failed!";
    }

    return 1;
}

=item _IsFreefieldsMigrationAlreadyDone($CommonObject)

Checks if the free field were dropped already, then the migration can be skipped.

    my $AlreadyDone = _IsFreefieldsMigrationAlreadyDone($CommonObject);

=cut

sub _IsFreefieldsMigrationAlreadyDone {
    my $CommonObject = shift;

    # First ticket and article added on installation
    # are used to verify if free fields are present
    my $SuccessTicket = $CommonObject->{DBObject}->Do(
        SQL   => 'SELECT freekey1, freetext1, freetime1 FROM ticket',
        LIMIT => 1,
    );

    my $SuccessArticle = $CommonObject->{DBObject}->Do(
        SQL   => 'SELECT a_freekey1, a_freetext1 FROM article',
        LIMIT => 1,
    );

    if ( !$SuccessTicket && !$SuccessArticle ) {
        print "Free fields were deleted, migration is already done!\n";
        return 1
    }

    return 0;
}

=item _DynamicFieldCreation($CommonObject)

Create new dynamic field entries for free fields on ticket and article table, if necessary.

    _DynamicFieldCreation($CommonObject);

=cut

sub _DynamicFieldCreation {
    my $CommonObject = shift;

    # select dynamic field entries
    my $SuccessTicket = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM dynamic_field',
    );

    my %Data;
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[1] } = $Row[0];
    }

    my $FieldOrder = 1;

    # insert new ticket dynamic field entries if necessary
    for my $Index ( 1 .. 16 ) {
        for my $FreeField ( 'TicketFreeKey', 'TicketFreeText' ) {

            if ( !$Data{ $FreeField . $Index } ) {
                my $FieldName = $FreeField . $Index;

                # insert new dynamic field
                my $SuccessTicketField = $CommonObject->{DBObject}->Do(
                    SQL =>
                        "INSERT INTO dynamic_field (name, label, field_order, field_type, object_type, config,
                            valid_id, create_time, create_by, change_time, change_by)
                        VALUES (?, ?, ?, 'Text', 'Ticket', '--- {}\n', 1, current_timestamp, 1, current_timestamp, 1)",
                    Bind => [
                        \$FieldName, \$FieldName, \$FieldOrder,
                    ],
                );
                $FieldOrder++;
                if ( !$SuccessTicketField ) {
                    die "Could not create new DynamicField $FieldName";
                }
            }
        }
    }

    # insert new ticket dynamic field entries if necessary
    for my $Index ( 1 .. 6 ) {

        if ( !$Data{ 'TicketFreeTime' . $Index } ) {
            my $FieldName = 'TicketFreeTime' . $Index;

            # insert new dynamic field
            my $SuccessTicketField = $CommonObject->{DBObject}->Do(
                SQL =>
                    "INSERT INTO dynamic_field (name, label, field_order, field_type, object_type, config,
                        valid_id, create_time, create_by, change_time, change_by)
                    VALUES (?, ?, ?, 'DateTime', 'Ticket', '--- {}\n', 1, current_timestamp, 1, current_timestamp, 1)",
                Bind => [
                    \$FieldName, \$FieldName, \$FieldOrder,
                ],
            );
            $FieldOrder++;
            if ( !$SuccessTicketField ) {
                die "Could not create new DynamicField $FieldName";
            }
        }
    }

    # insert new article dynamic field entries if necessary
    for my $Index ( 1 .. 3 ) {
        for my $FreeField ( 'ArticleFreeKey', 'ArticleFreeText' ) {
            if ( !$Data{ $FreeField . $Index } ) {
                my $FieldName = $FreeField . $Index;

                # insert new dynamic field
                my $SuccessArticleField = $CommonObject->{DBObject}->Do(
                    SQL =>
                        "INSERT INTO dynamic_field (name, label, field_order, field_type, object_type, config,
                            valid_id, create_time, create_by, change_time, change_by)
                        VALUES (?, ?, ?, 'Text', 'Article', '--- {}\n', 1, current_timestamp, 1, current_timestamp, 1)",
                    Bind => [
                        \$FieldName, \$FieldName, \$FieldOrder,
                    ],
                );
                $FieldOrder++;
                if ( !$SuccessArticleField ) {
                    die "Could not create new DynamicField $FieldName";
                }
            }
        }
    }

    return 1;
}

=item _DynamicFieldTicketMigration($CommonObject)

Copy data from ticket free fields to dynamic fields.

    _DynamicFieldTicketMigration($CommonObject);

=cut

sub _DynamicFieldTicketMigration {
    my $CommonObject = shift;

    my $MigratedTicketCounter = 0;
    my %TicketFreeFields      = (
        FreeKey  => 16,
        FreeText => 16,
        FreeTime => 6,
    );

    # create fields string and condition
    my $FreeFieldsTicket   = "";
    my $FreeFieldsTicketDB = "";
    my $TicketCondition    = "";
    for my $FreeField ( sort keys %TicketFreeFields ) {

        for my $Index ( 1 .. $TicketFreeFields{$FreeField} ) {
            $FreeFieldsTicket   .= lc($FreeField) . $Index . ", ";
            $FreeFieldsTicketDB .= "'Ticket" . $FreeField . $Index . "', ";
            $TicketCondition    .= lc($FreeField) . $Index . " IS NOT NULL OR ";
        }
    }

    # remove unnecessary part
    $FreeFieldsTicket   = substr $FreeFieldsTicket,   0, -2;
    $FreeFieldsTicketDB = substr $FreeFieldsTicketDB, 0, -2;
    $TicketCondition    = substr $TicketCondition,    0, -3;

    # get dynamic field ids and names
    my %DynamicFieldIDs;
    my $SuccessFields = $CommonObject->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM dynamic_field
                WHERE name in ($FreeFieldsTicketDB)
                    AND object_type = 'Ticket'
                ",
    );
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $DynamicFieldIDs{ $Row[1] } = $Row[0];
    }

    # select dynamic field entries
    my $SuccessTicketHowMuch = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT count(id) FROM ticket ' .
            'WHERE ' . $TicketCondition,
    );

    my $HowMuchTickets = 0;
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $HowMuchTickets = $Row[0];
    }

    # create new db connection
    my $SecondDBObject = Kernel::System::DB->new( %{ $CommonObject->{DBObject} } );

    # select dynamic field entries
    my $SuccessTicket = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, ' . $FreeFieldsTicket . ' FROM ticket ' .
            'WHERE ' . $TicketCondition . ' ' .
            'ORDER BY id',
    );

    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # select dynamic field entries
        my $SuccessTicketDynamicFields = $SecondDBObject->Prepare(
            SQL => "
                SELECT DISTINCT(dfv.field_id), dfv.object_id
                FROM dynamic_field_value dfv
                WHERE dfv.field_id IN (" . join( ',', values %DynamicFieldIDs ) . ")
                    AND dfv.object_id = $Row[0]",
        );
        my %DynamicFieldRetrieved;
        while ( my @DFVRow = $SecondDBObject->FetchrowArray() ) {
            $DynamicFieldRetrieved{ $DFVRow[0] . $DFVRow[1] } = 1;
        }

        my $FieldCounter  = 0;
        my $SuccessTicket = 1;
        my $TicketCounter = 1;
        for my $FreeField ( sort keys %TicketFreeFields ) {

            for my $Index ( 1 .. $TicketFreeFields{$FreeField} ) {
                $FieldCounter++;
                if ( defined $Row[$FieldCounter] ) {

                    my $FieldID    = $DynamicFieldIDs{ 'Ticket' . $FreeField . $Index };
                    my $FieldType  = ( $FreeField eq 'FreeTime' ? 'DateTime' : 'Text' );
                    my $FieldValue = $Row[$FieldCounter];
                    my $ValueType  = ( $FreeField eq 'FreeTime' ? 'date' : 'text' );
                    my $ObjectID   = $Row[0];
                    if ( !defined $DynamicFieldRetrieved{ $FieldID . $ObjectID } ) {

                        # insert new dinamic field value
                        my $SuccessTicketField = $SecondDBObject->Do(
                            SQL =>
                                'INSERT INTO dynamic_field_value (' .
                                'field_id, object_id, value_' . $ValueType .
                                ') VALUES (?, ?, ?)',
                            Bind => [
                                \$FieldID, \$ObjectID, \$FieldValue,
                            ],
                        );
                        if ( !$SuccessTicketField ) {
                            $SuccessTicket = 0;
                        }
                    }
                }
            }
        }
        if ( !$SuccessTicket ) {
            print "   Free fields from ticket with ID:$Row[0] was not successfully migrated. \n";
        }
        else {

            # ticket counter
            $MigratedTicketCounter++;
            print "   Migrated ticket $MigratedTicketCounter of $HowMuchTickets"
                . " (with Free fields data). \n" if ( $MigratedTicketCounter % 100 ) == 0;
        }
    }

    print "\n Migrated $MigratedTicketCounter tickets of $HowMuchTickets"
        . " (with Free fields data). \n";

    return $MigratedTicketCounter;
}

=item _DynamicFieldArticleMigration($CommonObject)

Copy data from article free fields to dynamic fields.

    _DynamicFieldArticleMigration($CommonObject);

=cut

sub _DynamicFieldArticleMigration {
    my $CommonObject = shift;

    my $MigratedArticleCounter = 0;
    my %ArticleFreeFields      = (
        FreeKey  => 3,
        FreeText => 3,
    );

    # create fields string and condition
    my $FreeFieldsArticle   = "";
    my $FreeFieldsArticleDB = "";
    my $ArticleCondition    = "";
    for my $FreeField ( sort keys %ArticleFreeFields ) {

        for my $Index ( 1 .. $ArticleFreeFields{$FreeField} ) {
            $FreeFieldsArticle   .= 'a_' . lc($FreeField) . $Index . ", ";
            $FreeFieldsArticleDB .= "'Article" . $FreeField . $Index . "', ";
            $ArticleCondition    .= 'a_' . lc($FreeField) . $Index . " IS NOT NULL OR ";
        }
    }

    # remove unnecessary part
    $FreeFieldsArticle   = substr $FreeFieldsArticle,   0, -2;
    $FreeFieldsArticleDB = substr $FreeFieldsArticleDB, 0, -2;
    $ArticleCondition    = substr $ArticleCondition,    0, -3;

    # get dynamic field ids
    my %DynamicFieldIDs;
    my $SuccessFields = $CommonObject->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM dynamic_field
                WHERE name in ($FreeFieldsArticleDB)
                    AND object_type = 'Article'
                ",
    );
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $DynamicFieldIDs{ $Row[1] } = $Row[0];
    }

    # select articles with dynamic field entries
    my $SuccessArticleHowMuch = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT count(id) FROM article ' .
            'WHERE ' . $ArticleCondition,
    );

    my $HowMuchArticles = 0;
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $HowMuchArticles = $Row[0];
    }

    # create new db connection
    my $SecondDBObject = Kernel::System::DB->new( %{ $CommonObject->{DBObject} } );

    # select dynamic field entries
    my $SuccessArticle = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, ' . $FreeFieldsArticle . ' FROM article ' .
            'WHERE ' . $ArticleCondition . ' ' .
            'ORDER BY id',
    );

    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # select dynamic field entries
        my $SuccessArticleDynamicFields = $SecondDBObject->Prepare(
            SQL => "SELECT dfv.field_id, dfv.object_id
                FROM dynamic_field_value dfv
                WHERE dfv.field_id IN (" . join( ',', values %DynamicFieldIDs ) . ")
                    AND dfv.object_id = $Row[0]",
        );
        my %DynamicFieldRetrieved;
        while ( my @Row = $SecondDBObject->FetchrowArray() ) {
            $DynamicFieldRetrieved{ $Row[0] . $Row[1] } = 1;
        }

        my $FieldCounter   = 0;
        my $SuccessArticle = 1;
        my $ArticleCounter = 1;
        for my $FreeField ( sort keys %ArticleFreeFields ) {

            for my $Index ( 1 .. $ArticleFreeFields{$FreeField} ) {
                $FieldCounter++;
                if ( defined $Row[$FieldCounter] ) {

                    my $FieldID    = $DynamicFieldIDs{ 'Article' . $FreeField . $Index };
                    my $FieldType  = ( $FreeField eq 'FreeTime' ? 'DateTime' : 'Text' );
                    my $FieldValue = $Row[$FieldCounter];
                    my $ValueType  = ( $FreeField eq 'FreeTime' ? 'date' : 'text' );
                    my $ObjectID   = $Row[0];
                    if ( !defined $DynamicFieldRetrieved{ $FieldID . $ObjectID } ) {

                        # insert new dynamic field value
                        my $SuccessArticleField = $SecondDBObject->Do(
                            SQL =>
                                'INSERT INTO dynamic_field_value (' .
                                'field_id, object_id, value_' . $ValueType .
                                ') VALUES (?, ?, ?)',
                            Bind => [
                                \$FieldID, \$ObjectID, \$FieldValue,
                            ],
                        );
                        if ( !$SuccessArticleField ) {
                            $SuccessArticle = 0;
                        }
                    }
                }
            }
        }
        if ( !$SuccessArticle ) {
            print "   Free fields from article with ID:$Row[0] was not successfully migrated. \n";
        }
        else {

            # article counter
            $MigratedArticleCounter++;
            print "   Migrated article $MigratedArticleCounter of $HowMuchArticles"
                . " (with Free fields data). \n" if ( $MigratedArticleCounter % 100 ) == 0;
        }
    }

    print "\n Migrated $MigratedArticleCounter articles of $HowMuchArticles"
        . " (with Free fields data). \n";

    return $MigratedArticleCounter;
}

=item _VerificationTicketData($CommonObject)

Checks if the data for ticket was successfully migrated.

    _VerificationTicketData($CommonObject);

=cut

sub _VerificationTicketData {
    my $CommonObject = shift;

    my $MigratedTicketCounter = 0;
    my %TicketFreeFields      = (
        FreeKey  => 16,
        FreeText => 16,
        FreeTime => 6,
    );

    # create fields string and condition
    my $FreeFieldsTicket   = "";
    my $FreeFieldsTicketDB = "";
    my $TicketCondition    = "";
    for my $FreeField ( sort keys %TicketFreeFields ) {

        for my $Index ( 1 .. $TicketFreeFields{$FreeField} ) {
            $FreeFieldsTicket   .= lc($FreeField) . $Index . ", ";
            $FreeFieldsTicketDB .= "'Ticket" . $FreeField . $Index . "', ";
            $TicketCondition    .= lc($FreeField) . $Index . " IS NOT NULL OR ";
        }
    }

    # remove unnecessary part
    $FreeFieldsTicket   = substr $FreeFieldsTicket,   0, -2;
    $FreeFieldsTicketDB = substr $FreeFieldsTicketDB, 0, -2;
    $TicketCondition    = substr $TicketCondition,    0, -3;

    # create new db connection
    my $SecondDBObject = Kernel::System::DB->new( %{ $CommonObject->{DBObject} } );

    # get dynamic field ids and names
    my %DynamicFieldIDs;
    my @DynamicFieldKeys;
    my $SuccessFields = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM dynamic_field ' .
            'WHERE name in (' . $FreeFieldsTicketDB . ')',
    );
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $DynamicFieldIDs{ $Row[1] } = $Row[0];
        push @DynamicFieldKeys, $Row[0];
    }

    # get dinamic fields ids
    my $DynamicFieldIdentifiers = join ',', @DynamicFieldKeys;

    # get how much tickets
    my $HowMuchTickets        = 0;
    my $SuccessHowMuchTickets = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT count(id) FROM ticket ' .
            'WHERE ' . $TicketCondition,
    );
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $HowMuchTickets = $Row[0] || 0;
    }

    # select dynamic field entries
    my $SuccessTicket = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, ' . $FreeFieldsTicket . ' FROM ticket ' .
            'WHERE ' . $TicketCondition . ' ' .
            'ORDER BY id',
    );

    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # set object type
        my $ObjectType = 'Ticket';

        # select dynamic field entries
        my $SuccessDynamicField = $SecondDBObject->Prepare(
            SQL =>
                "SELECT id, field_id,object_id,
                    value_text, value_int, value_date
                FROM dynamic_field_value
                WHERE object_id = $Row[0]
                    AND field_id in ($DynamicFieldIdentifiers)
                ORDER BY field_id",
        );

        my %DynamicFieldValue;
        while ( my @DFVRow = $SecondDBObject->FetchrowArray() ) {
            my $TextValue = defined $DFVRow[3] ? $DFVRow[3] : '';
            my $IntValue  = defined $DFVRow[4] ? $DFVRow[4] : '';
            my $DateValue = defined $DFVRow[5] ? $DFVRow[5] : '';
            $DynamicFieldValue{ $DFVRow[1] . $ObjectType . $DFVRow[2] } = $TextValue . $IntValue . $DateValue;
        }

        my $FieldCounter  = 0;
        my $SuccessTicket = 1;
        my $TicketCounter = 1;
        for my $FreeField ( sort keys %TicketFreeFields ) {

            for my $Index ( 1 .. $TicketFreeFields{$FreeField} ) {
                $FieldCounter++;
                if ( defined $Row[$FieldCounter] ) {

                    my $FieldID    = $DynamicFieldIDs{ 'Ticket' . $FreeField . $Index };
                    my $FieldType  = ( $FreeField eq 'FreeTime' ? 'DateTime' : 'Text' );
                    my $FieldValue = $Row[$FieldCounter];
                    my $ValueType  = ( $FreeField eq 'FreeTime' ? 'date' : 'text' );
                    my $ObjectID   = $Row[0];

                    if ( $DynamicFieldValue{ $FieldID . $ObjectType . $ObjectID } ne $FieldValue ) {
                        print STDERR
                            "A field was not correctly migrated: Field ID $FieldID "
                            . "$ObjectType ID $ObjectID\n";
                        print STDERR "  Found DynamicField value '"
                            . $DynamicFieldValue{ $FieldID . $ObjectType . $ObjectID }
                            . "', expected '"
                            . $Row[$FieldCounter] . "'!\n";
                        return 0;
                    }
                }
            }
        }

        # ticket counter
        $MigratedTicketCounter++;
        print "   Verified ticket $MigratedTicketCounter of $HowMuchTickets"
            . " (with Free fields data). \n" if ( $MigratedTicketCounter % 100 ) == 0;
    }

    print "\n Verified $MigratedTicketCounter tickets of $HowMuchTickets"
        . " (with Free fields data). \n";

    return 1;
}

=item _VerificationArticleData($CommonObject)

Checks if the data for ticket was successfully migrated.

    _VerificationArticleData($CommonObject);

=cut

sub _VerificationArticleData {
    my $CommonObject = shift;

    my $MigratedArticleCounter = 0;
    my %ArticleFreeFields      = (
        FreeKey  => 3,
        FreeText => 3,
    );

    # create fields string and condition
    my $FreeFieldsArticle   = "";
    my $FreeFieldsArticleDB = "";
    my $ArticleCondition    = "";
    for my $FreeField ( sort keys %ArticleFreeFields ) {

        for my $Index ( 1 .. $ArticleFreeFields{$FreeField} ) {
            $FreeFieldsArticle   .= 'a_' . lc($FreeField) . $Index . ", ";
            $FreeFieldsArticleDB .= "'Article" . $FreeField . $Index . "', ";
            $ArticleCondition    .= 'a_' . lc($FreeField) . $Index . " IS NOT NULL OR ";
        }
    }

    # remove unnecessary part
    $FreeFieldsArticle   = substr $FreeFieldsArticle,   0, -2;
    $FreeFieldsArticleDB = substr $FreeFieldsArticleDB, 0, -2;
    $ArticleCondition    = substr $ArticleCondition,    0, -3;

    # create new db connection
    my $SecondDBObject = Kernel::System::DB->new( %{ $CommonObject->{DBObject} } );

    # get dynamic field ids and names
    my %DynamicFieldIDs;
    my @DynamicFieldKeys;
    my $SuccessFields = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM dynamic_field ' .
            'WHERE name in (' . $FreeFieldsArticleDB . ')',
    );
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $DynamicFieldIDs{ $Row[1] } = $Row[0];
        push @DynamicFieldKeys, $Row[0];
    }

    # get dinamic fields ids
    my $DynamicFieldIdentifiers = join ',', @DynamicFieldKeys;

    # select how much articles
    my $HowMuchArticles        = 0;
    my $SuccessHowMuchArticles = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT count(id) FROM article ' .
            'WHERE ' . $ArticleCondition,
    );
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $HowMuchArticles = $Row[0] || 0;
    }

    # select dynamic field entries
    my $SuccessArticle = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, ' . $FreeFieldsArticle . ' FROM article ' .
            'WHERE ' . $ArticleCondition . ' ' .
            'ORDER BY id',
    );

    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # set object type
        my $ObjectType = 'Article';

        # select dynamic field entries
        my $SuccessDynamicField = $SecondDBObject->Prepare(
            SQL =>
                "SELECT id, field_id,object_id,
                    value_text, value_int, value_date
                FROM dynamic_field_value
                WHERE object_id = $Row[0]
                    AND field_id in ($DynamicFieldIdentifiers)
                ORDER BY field_id",
        );

        my %DynamicFieldValue;
        while ( my @DFVRow = $SecondDBObject->FetchrowArray() ) {
            my $TextValue = defined $DFVRow[3] ? $DFVRow[3] : '';
            my $IntValue  = defined $DFVRow[4] ? $DFVRow[4] : '';
            my $DateValue = defined $DFVRow[5] ? $DFVRow[5] : '';
            $DynamicFieldValue{ $DFVRow[1] . $ObjectType . $DFVRow[2] } = $TextValue . $IntValue . $DateValue;
        }

        my $FieldCounter   = 0;
        my $SuccessArticle = 1;
        my $ArticleCounter = 1;
        for my $FreeField ( sort keys %ArticleFreeFields ) {

            for my $Index ( 1 .. $ArticleFreeFields{$FreeField} ) {
                $FieldCounter++;
                if ( defined $Row[$FieldCounter] ) {

                    my $FieldID    = $DynamicFieldIDs{ 'Article' . $FreeField . $Index };
                    my $FieldType  = ( $FreeField eq 'FreeTime' ? 'DateTime' : 'Text' );
                    my $FieldValue = $Row[$FieldCounter];
                    my $ValueType  = ( $FreeField eq 'FreeTime' ? 'date' : 'text' );
                    my $ObjectID   = $Row[0];
                    if ( $DynamicFieldValue{ $FieldID . $ObjectType . $ObjectID } ne $FieldValue ) {
                        print STDERR
                            "A field was not correctly migrated (Field ID $FieldID"
                            . " $ObjectType ID $ObjectID)!\n";
                        print STDERR "  Found DynamicField value '"
                            . $DynamicFieldValue{ $FieldID . $ObjectType . $ObjectID }
                            . "', expected '"
                            . $Row[$FieldCounter] . "'!\n";
                        return 0;
                    }
                }
            }
        }

        # article counter
        $MigratedArticleCounter++;
        print "   Verified article $MigratedArticleCounter of $HowMuchArticles"
            . " (with Free fields data). \n" if ( $MigratedArticleCounter % 100 ) == 0;
    }

    print "\n Verified $MigratedArticleCounter articles of $HowMuchArticles"
        . " (with Free fields data). \n";

    return 1;
}

=item _MigrateFreeFieldsConfiguration($CommonObject)

migrates the configuration of the free fields from SysConfig to the
new dynamic_fields table.

    _MigrateFreeFieldsConfiguration($CommonObject);

=cut

sub _MigrateFreeFieldsConfiguration {
    my $CommonObject = shift;

    # Purge cache first to make sure that the DF API works correctly
    #   after we made inserts by hand.
    my $CacheObject = Kernel::System::Cache->new( %{$CommonObject} );
    $CacheObject->CleanUp(
        Type => 'DynamicField',
    );

    # create additional objects
    my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$CommonObject} );

    my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ResultType => 'HASH',
    );

    $DynamicFields = { reverse %{$DynamicFields} };

    # get valid fields
    my $ValidFreeFields = _GetValidFreeFields($CommonObject);

    for my $Index ( 1 .. 16 ) {
        FIELD:
        for my $FreeField ( 'TicketFreeKey', 'TicketFreeText' ) {

            # default field type
            my $FieldType = 'Dropdown';

            my $FieldName = $FreeField . $Index;

            if ( defined $DynamicFields->{$FieldName} ) {

                my $Valid = $ValidFreeFields->{$FieldName};

                my $FieldConfig = $DynamicFieldObject->DynamicFieldGet(
                    ID => $DynamicFields->{$FieldName},
                ) || {};

                # Get all Attributes from Item
                my $PossibleValues = $CommonObject->{ConfigObject}->Get($FieldName);
                $FieldConfig->{Config}->{PossibleValues} = $PossibleValues;

                if ( !$PossibleValues || !%{$PossibleValues} ) {

                    # Leave it as text field. If the config setting was disabled,
                    $FieldType = 'Text';
                }

                if ( $FreeField eq 'TicketFreeText' ) {

                    # If the corresponding key has only one possible value for this entry,
                    # use it as the label.
                    my $KeyName      = 'TicketFreeKey' . $Index;
                    my $PossibleKeys = $CommonObject->{ConfigObject}->Get($KeyName);

                    if ( ref $PossibleKeys eq 'HASH' && scalar keys %{$PossibleKeys} == 1 ) {
                        for my $Key ( keys %{$PossibleKeys} ) {
                            $FieldConfig->{Label} = $PossibleKeys->{$Key} if $PossibleKeys->{$Key};
                        }
                    }
                }

                # If the key has only one possible value for this entry, disable this field
                if (
                    $FreeField eq 'TicketFreeKey'
                    && ref $PossibleValues eq 'HASH'
                    && scalar keys %{$PossibleValues} == 1
                    )
                {
                    $Valid = 2;
                }

                my $DefaultSelection = $CommonObject->{ConfigObject}->Get( $FieldName . "::DefaultSelection" );
                $FieldConfig->{Config}->{DefaultValue} = $DefaultSelection;

                # migrate free text link setting
                my $Link = $CommonObject->{ConfigObject}->Get( $FieldName . "::Link" );
                $FieldConfig->{Config}->{Link} = $Link if $Link;

                # set new values
                my $SuccessTicketField = $DynamicFieldObject->DynamicFieldUpdate(
                    %{$FieldConfig},
                    FieldType => $FieldType,
                    Reorder   => 0,
                    ValidID   => $Valid,
                    UserID    => 1,
                );

                if ( !$SuccessTicketField ) {
                    die "Could not migrate configuration for dynamic field: $FieldName";
                }
            }
        }
    }

    for my $Index ( 1 .. 6 ) {

        FIELD:
        my $FieldName = 'TicketFreeTime' . $Index;
        if ( defined $DynamicFields->{$FieldName} ) {
            my $FieldConfig = $DynamicFieldObject->DynamicFieldGet(
                ID => $DynamicFields->{$FieldName},
            );

            # Get all Attributes from Item
            my $TimeKey = $CommonObject->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Index );
            $FieldConfig->{Label} = $TimeKey || "Time$Index";

            $FieldConfig->{Config}->{DefaultValue}
                = $CommonObject->{ConfigObject}->Get( 'TicketFreeTimeDiff' . $Index );

            my $FreeTimePeriod = $CommonObject->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Index );

            if ( $FreeTimePeriod && ref $FreeTimePeriod eq 'HASH' ) {
                $FieldConfig->{Config}->{YearsPeriod}   = 1;
                $FieldConfig->{Config}->{YearsInFuture} = $FreeTimePeriod->{YearPeriodFuture};
                $FieldConfig->{Config}->{YearsInPast}   = $FreeTimePeriod->{YearPeriodPast};
            }

            # set new values
            my $SuccessTicketField = $DynamicFieldObject->DynamicFieldUpdate(
                %{$FieldConfig},
                FieldType => 'DateTime',
                Reorder   => 0,
                ValidID   => $ValidFreeFields->{$FieldName},
                UserID    => 1,
            );

            if ( !$SuccessTicketField ) {
                die "Could not migrate configuration for dynamic field: $FieldName";
            }
        }
    }

    for my $Index ( 1 .. 3 ) {

        FIELD:
        for my $FreeField ( 'ArticleFreeKey', 'ArticleFreeText' ) {

            # default field type
            my $FieldType = 'Dropdown';

            my $FieldName = $FreeField . $Index;

            if ( defined $DynamicFields->{$FieldName} ) {

                my $Valid = $ValidFreeFields->{$FieldName};

                my $FieldConfig = $DynamicFieldObject->DynamicFieldGet(
                    ID => $DynamicFields->{$FieldName},
                );

                # Get all Attributes from Item
                my $PossibleValues = $CommonObject->{ConfigObject}->Get($FieldName);

                if ( ref $PossibleValues eq 'HASH' ) {

                    # search for "None" value in possible values list
                    if ( $PossibleValues->{''} && $PossibleValues->{''} eq '-' ) {

                        # delete "None" value from the list
                        delete $PossibleValues->{''};

                        # set possible none configuration inside the field config
                        $FieldConfig->{Config}->{PossibleNone} = 1;
                    }
                }

                # set none empty PossibleValues into the field config
                $FieldConfig->{Config}->{PossibleValues} = $PossibleValues;
                if ( !$PossibleValues || !%{$PossibleValues} ) {

                    # Leave this a text field. If the config setting was disabled,
                    $FieldType = 'Text';
                }

                if ( $FreeField eq 'ArticleFreeText' ) {

                    # If the corresponding key has only one possible value for this entry,
                    # use it as the label.
                    my $KeyName      = 'ArticleFreeKey' . $Index;
                    my $PossibleKeys = $CommonObject->{ConfigObject}->Get($KeyName);

                    if ( ref $PossibleKeys eq 'HASH' && scalar keys %{$PossibleKeys} == 1 ) {
                        for my $Key ( keys %{$PossibleKeys} ) {
                            $FieldConfig->{Label} = $PossibleKeys->{$Key} if $PossibleKeys->{$Key};
                        }
                    }
                }

                # If the key has only one possible value for this entry, disable this field
                if (
                    $FreeField eq 'ArticleFreeKey'
                    && ref $PossibleValues eq 'HASH'
                    && scalar keys %{$PossibleValues} == 1
                    )
                {
                    $Valid = 2;
                }

                $FieldConfig->{Config}->{DefaultValue}
                    = $CommonObject->{ConfigObject}->Get( $FieldName . "::DefaultSelection" )
                    ;

                # set new values
                my $SuccessTicketField = $DynamicFieldObject->DynamicFieldUpdate(
                    %{$FieldConfig},
                    FieldType => $FieldType,
                    Reorder   => 0,
                    ValidID   => $Valid,
                    UserID    => 1,
                );

                if ( !$SuccessTicketField ) {
                    die "Could not migrate configuration for dynamic field: $FieldName";
                }
            }

        }
    }

    return 1;
}

=item _UpdateHistoryType($CommonObject)

remove the old history types ( TicketFreeTextUpdate, TicketFreeTimeUpdate )
and introduce a new one for dynamic fields (TicketDynamicFieldUpdate), all old entries will mere into the new one.

    _UpdateHistoryType($CommonObject);

=cut

sub _UpdateHistoryType {
    my $CommonObject = shift;

    # set fields name
    my $HistoryEntryToRename = 'TicketFreeTextUpdate';
    my $NewHistoryEntry      = 'TicketDynamicFieldUpdate';

    # rename the history type 'TicketFreeTextUpdate' to 'TicketDynamicFieldUpdate'
    my $SuccessUpdate = $CommonObject->{DBObject}->Do(
        SQL =>
            "UPDATE ticket_history_type set name=? WHERE name=?",
        Bind => [
            \$NewHistoryEntry, \$HistoryEntryToRename,
        ],
    );

    if ( !$SuccessUpdate ) {
        print "Could not possible to change the name for the ticket history type!\n";
        return 0;
    }

    return 1;
}

=item _MigrateWindowConfiguration($CommonObject)

migrates the configuration of the free fields for each window to the
new dynamic field structure.

    _MigrateWindowConfiguration($CommonObject);

=cut

sub _MigrateWindowConfiguration {
    my $CommonObject = shift;

    # Purge cache first to make sure that the DF API works correctly
    #   after we made inserts by hand.
    my $CacheObject = Kernel::System::Cache->new( %{$CommonObject} );
    $CacheObject->CleanUp(
        Type => 'DynamicField',
    );

    # create additional objects
    my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$CommonObject} );
    my $SysConfigObject    = Kernel::System::SysConfig->new( %{$CommonObject} );

    my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ResultType => 'HASH',
    );

    $DynamicFields = { reverse %{$DynamicFields} };

    my @Windows = (
        'CustomerTicketMessage',
        'CustomerTicketSearch',
        'AgentTicketResponsible',
        'AgentTicketPriority',
        'AgentTicketPhoneOutbound',
        'AgentTicketPhoneInbound',
        'AgentTicketPhone',
        'AgentTicketPending',
        'AgentTicketOwner',
        'AgentTicketNote',
        'AgentTicketMove',
        'AgentTicketForward',
        'AgentTicketFreeText',
        'AgentTicketEmail',
        'AgentTicketCompose',
        'AgentTicketClose',
    );

    for my $Window (@Windows) {

        my $WindowConfig =
            $CommonObject->{ConfigObject}->Get("Ticket::Frontend::$Window");

        my $KeyString       = "Ticket::Frontend::$Window" . "###DynamicField";
        my $ExistingSetting = $CommonObject->{ConfigObject}->Get("Ticket::Frontend::$Window") || {};
        my %ValuesToSet     = %{ $ExistingSetting->{DynamicField} || {} };

        for my $FreeField ( 'TicketFreeKey', 'TicketFreeText' ) {
            if ( defined $WindowConfig->{$FreeField} ) {

                my $Config = $WindowConfig->{$FreeField};

                for my $Index ( 1 .. 16 ) {

                    my $FieldName = $FreeField . $Index;
                    if ( defined $DynamicFields->{$FieldName} && $Config->{$Index} ) {

                        $ValuesToSet{$FieldName} = $Config->{$Index};

                        if ( $FreeField eq 'TicketFreeText' ) {

                            # If the corresponding key has only more than one possible value for this entry,
                            # enable it.
                            my $KeyName      = 'TicketFreeKey' . $Index;
                            my $PossibleKeys = $CommonObject->{ConfigObject}->Get($KeyName);

                            if (
                                ref $PossibleKeys eq 'HASH'        &&
                                scalar keys %{$PossibleKeys} > 1   &&
                                defined $DynamicFields->{$KeyName} &&
                                !$ValuesToSet{$KeyName}
                                )
                            {

                                $ValuesToSet{$KeyName} = $Config->{$Index};
                            }
                        }
                    }
                }
            }
        }

        # end TicketFree Key and Text

        if ( defined $WindowConfig->{TicketFreeTime} ) {

            my $Config = $WindowConfig->{TicketFreeTime};

            for my $Index ( 1 .. 6 ) {

                my $FieldName = 'TicketFreeTime' . $Index;
                if ( defined $DynamicFields->{$FieldName} && $Config->{$Index} ) {

                    $ValuesToSet{$FieldName} = $Config->{$Index};
                }
            }
        }

        # end TicketFreeTime

        for my $FreeField ( 'ArticleFreeKey', 'ArticleFreeText' ) {
            if ( defined $WindowConfig->{$FreeField} ) {

                my $Config = $WindowConfig->{$FreeField};

                for my $Index ( 1 .. 3 ) {

                    my $FieldName = $FreeField . $Index;
                    if ( defined $DynamicFields->{$FieldName} && $Config->{$Index} ) {

                        $ValuesToSet{$FieldName} = $Config->{$Index};

                        if ( $FreeField eq 'ArticleFreeText' ) {

                            # If the corresponding key has only more than one possible value for this entry,
                            # enable it.
                            my $KeyName      = 'ArticleFreeKey' . $Index;
                            my $PossibleKeys = $CommonObject->{ConfigObject}->Get($KeyName);

                            if (
                                ref $PossibleKeys eq 'HASH'        &&
                                scalar keys %{$PossibleKeys} > 1   &&
                                defined $DynamicFields->{$KeyName} &&
                                !$ValuesToSet{$KeyName}
                                )
                            {

                                $ValuesToSet{$KeyName} = $Config->{$Index};
                            }
                        }
                    }
                }

            }
        }

        # end ArticleFree Key and Text

        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => $KeyString,
            Value => \%ValuesToSet,
        );

        if ( !$Success ) {
            print
                "Could not migrate the config values on $Window window!\n";
            return 0;
        }

    }

    # AgentTicketSearch configuration

    my $WindowConfig =
        $CommonObject->{ConfigObject}->Get('Ticket::Frontend::AgentTicketSearch');

    my $ExistingSetting = $CommonObject->{ConfigObject}->Get('Ticket::Frontend::AgentTicketSearch')
        || {};
    my %ValuesToSet = %{ $ExistingSetting->{DynamicField} || {} };

    if ( defined $WindowConfig->{Defaults} ) {

        my $Config = $WindowConfig->{Defaults};

        for my $Index ( 1 .. 16 ) {

            my $FieldName = 'TicketFreeText' . $Index;
            if ( defined $DynamicFields->{$FieldName} && $Config->{$FieldName} ) {

                $ValuesToSet{$FieldName} = $Config->{$FieldName};
            }
        }

        for my $Index ( 1 .. 5 ) {

            my $FieldName = 'TicketFreeTime' . $Index;
            if ( defined $DynamicFields->{$FieldName} && $Config->{$FieldName} ) {

                $ValuesToSet{$FieldName} = $Config->{$FieldName};
            }
        }
    }

    my $Success = $SysConfigObject->ConfigItemUpdate(
        Valid => 1,
        Key   => 'Ticket::Frontend::AgentTicketSearch###DynamicField',
        Value => \%ValuesToSet,
    );

    if ( !$Success ) {
        print
            "Could not migrate the config values on AgentTicketSearch window!\n";
        return 0;
    }

    # CustomerTicketZoom configuration

    $WindowConfig = $CommonObject->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketZoom')
        || {};
    my %ValuesToSetZoom;
    my $Config;
    if ( defined $WindowConfig->{AttributesView} && ref $WindowConfig->{AttributesView} eq 'HASH' )
    {

        $Config = $WindowConfig->{AttributesView};

        my %FreeFields = (
            TicketFreeText  => 16,
            TicketFreeTime  => 6,
            ArticleFreeText => 3,
        );

        for my $Field ( sort keys %FreeFields ) {
            for my $Index ( 1 .. $FreeFields{$Field} ) {
                my $FieldName = $Field . $Index;
                if ( defined $Config->{$FieldName} && defined $DynamicFields->{$FieldName} ) {

                    # set dynamic field for this screen
                    $ValuesToSetZoom{$FieldName} = $Config->{$FieldName};

                    my $ExtraField = '';
                    $ExtraField = 'TicketFreeKey' . $Index  if $Field eq 'TicketFreeText';
                    $ExtraField = 'ArticleFreeKey' . $Index if $Field eq 'ArticleFreeText';

                    if ( $ExtraField && $DynamicFields->{$ExtraField} ) {
                        $ValuesToSetZoom{$ExtraField} = $Config->{$FieldName};
                    }

                    # delete key from config
                    delete $Config->{$FieldName};
                }
            }
        }

    }

    my $SuccessAttributes = $SysConfigObject->ConfigItemUpdate(
        Valid => 1,
        Key   => 'Ticket::Frontend::CustomerTicketZoom###AttributesView',
        Value => $Config,
    );

    if ( !$SuccessAttributes ) {
        print
            "Could not migrate the config values on CustomerTicketZoom window!\n";
        return 0;
    }

    my $SuccessDynamicField = $SysConfigObject->ConfigItemUpdate(
        Valid => 1,
        Key   => 'Ticket::Frontend::CustomerTicketZoom###DynamicField',
        Value => \%ValuesToSetZoom,
    );

    if ( !$SuccessDynamicField ) {
        print
            "Could not migrate the config values on CustomerTicketZoom window!\n";
        return 0;
    }

    # AgentTicketPrint configuration

    my %ValuesToSetPrint;
    my %FreeFields = (
        TicketFreeKey   => 16,
        TicketFreeText  => 16,
        TicketFreeTime  => 6,
        ArticleFreeKey  => 3,
        ArticleFreeText => 3,
    );

    for my $Field ( sort keys %FreeFields ) {
        for my $Index ( 1 .. $FreeFields{$Field} ) {
            my $FieldName = $Field . $Index;
            if ( defined $DynamicFields->{$FieldName} ) {

                # set dynamic field for this screen
                $ValuesToSetPrint{$FieldName} = 1;
            }
        }
    }

    $SuccessDynamicField = $SysConfigObject->ConfigItemUpdate(
        Valid => 1,
        Key   => 'Ticket::Frontend::AgentTicketPrint###DynamicField',
        Value => \%ValuesToSetPrint,
    );

    if ( !$SuccessDynamicField ) {
        print
            "Could not migrate the config values on AgentTicketPrint window!\n";
        return 0;
    }

    # CustomerTicketPrint configuration

    %ValuesToSetPrint = ();

    for my $Field ( sort keys %FreeFields ) {
        for my $Index ( 1 .. $FreeFields{$Field} ) {
            my $FieldName = $Field . $Index;
            if ( defined $DynamicFields->{$FieldName} ) {

                # set dynamic field for this screen
                $ValuesToSetPrint{$FieldName} = 1;
            }
        }
    }

    $SuccessDynamicField = $SysConfigObject->ConfigItemUpdate(
        Valid => 1,
        Key   => 'Ticket::Frontend::CustomerTicketPrint###DynamicField',
        Value => \%ValuesToSetPrint,
    );

    if ( !$SuccessDynamicField ) {
        print
            "Could not migrate the config values on CustomerTicketPrint window!\n";
        return 0;
    }

    return 1;
}

=item _MigrateStatsConfiguration($CommonObject)

migrates the configuration of the free fields for each statistic to the
new dynamic field structure.

    _MigrateStatsConfiguration($CommonObject);

=cut

sub _MigrateStatsConfiguration {
    my $CommonObject = shift;

    # Purge cache first to make sure that the DF API works correctly
    #   after we made inserts by hand.
    my $CacheObject = Kernel::System::Cache->new( %{$CommonObject} );
    $CacheObject->CleanUp(
        Type => 'DynamicField',
    );

    # Purge xml cache in order to re-read all stats from the database
    # this will be usefull because we are updating DB registers by hand
    $CacheObject->CleanUp(
        Type => 'XML',
    );

    # create additional objects
    my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$CommonObject} );

    # find all statistics parts that need to be updated

    # Oracle data type for xml_content_value might prevent comparisons like
    # " AND xml_content_value like 'TicketFree%', " it has been tested in this query and apparently
    # works with that line, but still this line was removed from the SQL statement in order to
    # prevent errors new perl code was added to filter the value. Bug#8233.
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT xml_type, xml_key, xml_content_key, xml_content_value
            FROM xml_storage
            WHERE xml_type = 'Stats'
                AND xml_content_key like '%UseAs%'
            ORDER BY xml_key",
    );

    my @StatRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get field details
        my %StatRecordConfig = (
            XMLType         => $Row[0],
            XMLKey          => $Row[1],
            XMLContentKey   => $Row[2],
            XMLContentValue => $Row[3],
        );

        # skip all registers where XMLContentValue does not start with TicketFree
        next if $StatRecordConfig{XMLContentValue} !~ m{\A TicketFree }xms;

        # save field details
        push @StatRecordsToChange, \%StatRecordConfig;
    }

    # get DynamicFields list
    my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ResultType => 'HASH',
    );

    # reverse the DynamicFields list to create a lookup table
    $DynamicFields = { reverse %{$DynamicFields} };

    STATSFIELDCONFIG:
    for my $StatRecordConfig (@StatRecordsToChange) {

        # check if the migrated dynamic field is available
        next STATSFIELDCONFIG if !$DynamicFields->{ $StatRecordConfig->{XMLContentValue} };

        # set new field name for stats
        $StatRecordConfig->{XMLContentValueNew} = 'DynamicField_' . $StatRecordConfig->{XMLContentValue};

        # update database

        # Oracle data type for xml_content_value prevents comparisons like
        # AND xml_content_value = ?, so this line was removed from the SQL statement
        # and new perl code was added to filter the value. Bug#8233.
        my $SuccessStatsUpdate = $CommonObject->{DBObject}->Do(
            SQL =>
                'UPDATE xml_storage
                SET xml_content_value = ?
                WHERE xml_type = ?
                    AND xml_key = ?
                    AND xml_content_key = ?',
            Bind => [
                \$StatRecordConfig->{XMLContentValueNew},
                \$StatRecordConfig->{XMLType},
                \$StatRecordConfig->{XMLKey},
                \$StatRecordConfig->{XMLContentKey},
            ],
        );

        # check for errors
        if ( !$SuccessStatsUpdate ) {
            print "Could not migrate the statistic ID $StatRecordConfig->{XMLKEY}"
                . " field $StatRecordConfig->{XMLContentValue}\n";

            # return error
            return 0;
        }
    }

    # return success
    return 1;
}

=item _MigrateGenericAgentJobConfiguration($CommonObject)

migrates the configuration of the free fields for each generic agent job to the
new dynamic field structure.

    _MigrateGenericAgentJobConfiguration($CommonObject);

=cut

sub _MigrateGenericAgentJobConfiguration {
    my $CommonObject = shift;

    # create additional objects
    my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$CommonObject} );

    # get DynamicFields list
    my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ResultType => 'HASH',
    );

    # reverse the DynamicFields list to create a lookup table
    $DynamicFields = { reverse %{$DynamicFields} };

    # find all free fields for search to be migrated
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT gaj.job_name, gaj.job_key, gaj.job_value
            FROM generic_agent_jobs gaj
            WHERE gaj.job_key like 'TicketFree%'
            ORDER BY gaj.job_name",
    );

    my @SearchRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get field details
        my %JobRecordConfig = (
            JobName  => $Row[0],
            JobKey   => $Row[1],
            JobValue => $Row[2],
        );

        # save field details
        push @SearchRecordsToChange, \%JobRecordConfig;
    }

    # set search prefix
    my $SearchPrefix = 'Search_DynamicField_';

    JOBFIELDCONFIG:
    for my $JobRecordConfig (@SearchRecordsToChange) {

        # check if the migrated dynamic field is available
        next JOBFIELDCONFIG if !$DynamicFields->{ $JobRecordConfig->{JobKey} };

        # append search prefix to search free fields
        $JobRecordConfig->{JobKeyNew} = $SearchPrefix . $JobRecordConfig->{JobKey};

        # update database
        my $SuccessJobUpdate = $CommonObject->{DBObject}->Do(
            SQL => "UPDATE generic_agent_jobs
                SET job_key = ?
                WHERE job_name = ?
                    AND job_key = ?
                    AND job_value = ?",
            Bind => [
                \$JobRecordConfig->{JobKeyNew},
                \$JobRecordConfig->{JobName},
                \$JobRecordConfig->{JobKey},
                \$JobRecordConfig->{JobValue},
            ],
        );

        # check for errors
        if ( !$SuccessJobUpdate ) {
            print "Could not migrate the Generic Agent Job $JobRecordConfig->{JobName}"
                . " field $JobRecordConfig->{JobKey}\n";

            return 0;
        }
    }

    # find all free fields for set to be migrated
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT gaj.job_name, gaj.job_key, gaj.job_value
            FROM generic_agent_jobs gaj
            WHERE gaj.job_key like 'NewTicketFree%'
            ORDER BY gaj.job_name",
    );

    my @SetRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get field details
        my %JobRecordConfig = (
            JobName  => $Row[0],
            JobKey   => $Row[1],
            JobValue => $Row[2],
        );

        # save field details
        push @SetRecordsToChange, \%JobRecordConfig;
    }

    # set the set prefix
    my $SetPrefix = 'DynamicField_';

    JOBFIELDCONFIG:
    for my $JobRecordConfig (@SetRecordsToChange) {

        # remove the new prefix
        $JobRecordConfig->{JobKeyTemp} = $JobRecordConfig->{JobKey};
        $JobRecordConfig->{JobKeyTemp} =~ s{New}{};

        # check if the migrated dynamic field is available
        next JOBFIELDCONFIG if !$DynamicFields->{ $JobRecordConfig->{JobKeyTemp} };

        # append set prefix to set free fields
        $JobRecordConfig->{JobKeyNew} = $SetPrefix . $JobRecordConfig->{JobKeyTemp};

        if ( $JobRecordConfig->{JobValue} ) {

            # update database
            my $SuccessJobUpdate = $CommonObject->{DBObject}->Do(
                SQL => "UPDATE generic_agent_jobs
                    SET job_key = ?
                    WHERE job_name = ?
                        AND job_key = ?
                        AND job_value = ?",
                Bind => [
                    \$JobRecordConfig->{JobKeyNew},
                    \$JobRecordConfig->{JobName},
                    \$JobRecordConfig->{JobKey},
                    \$JobRecordConfig->{JobValue},
                ],
            );

            # check for errors
            if ( !$SuccessJobUpdate ) {
                print "Could not migrate the Generic Agent Job $JobRecordConfig->{JobName}"
                    . " field $JobRecordConfig->{JobKey}\n";

                return 0;
            }
        }
        else {

            # delete empty options
            my $SuccessJobDelete = $CommonObject->{DBObject}->Do(
                SQL => "DELETE FROM generic_agent_jobs
                    WHERE job_name = ?
                        AND job_key = ?
                        AND job_value = ?",
                Bind => [
                    \$JobRecordConfig->{JobName},
                    \$JobRecordConfig->{JobKey},
                    \$JobRecordConfig->{JobValue},
                ],
            );

            # check for errors
            if ( !$SuccessJobDelete ) {
                print "Could not delete empty field $JobRecordConfig->{JobKey} from the "
                    . "Generic Agent Job $JobRecordConfig->{JobName}\n";

                return 0;
            }
        }
    }
    return 1;
}

=item _MigratePostMasterConfiguration($CommonObject)

migrates the configuration of the free fields for PostMaster module into the
new dynamic field structure.

    _MigratePostMasterConfiguration($CommonObject);

=cut

sub _MigratePostMasterConfiguration {
    my $CommonObject = shift;

    # Purge cache first to make sure that the DF API works correctly
    #   after we made inserts by hand.
    my $CacheObject = Kernel::System::Cache->new( %{$CommonObject} );
    $CacheObject->CleanUp(
        Type => 'DynamicField',
    );

    # create additional objects
    my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$CommonObject} );
    my $SysConfigObject    = Kernel::System::SysConfig->new( %{$CommonObject} );

    # get current dynamic fields
    my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ResultType => 'HASH',
    );

    # set values as keys
    $DynamicFields = { reverse %{$DynamicFields} };

    # Post Master configuration
    my $ExistingSetting = $CommonObject->{ConfigObject}->Get('PostmasterX-Header');
    my @ValuesToSet = @{ $ExistingSetting || [] };

    if ( scalar @ValuesToSet ) {

        # transform the array from config into a hash
        # in order to facility the interaction with the values
        my %CurrentXHeaders = map { $_ => 1 } @ValuesToSet;

        # migration for ticket fields
        my %XHeadersToChange = (
            'X-OTRS-TicketKey' => {
                Name => 'TicketFreeKey',
                Type => '',
            },
            'X-OTRS-TicketValue' => {
                Name => 'TicketFreeText',
                Type => '',
            },
            'X-OTRS-FollowUp-TicketKey' => {
                Name => 'TicketFreeKey',
                Type => 'FollowUp-',
            },
            'X-OTRS-FollowUp-TicketValue' => {
                Name => 'TicketFreeText',
                Type => 'FollowUp-',
            },
        );

        for my $Key ( sort keys %XHeadersToChange ) {
            for my $Index ( 1 .. 16 ) {

                # set header and field name
                my $HeaderName = $Key . $Index;
                my $FieldName  = $XHeadersToChange{$Key}->{Name} . $Index;
                my $FieldType  = $XHeadersToChange{$Key}->{Type};

                if ( defined $DynamicFields->{$FieldName} && defined $CurrentXHeaders{$HeaderName} )
                {

                    # set header name for dynamic field
                    my $NewHeaderName = 'X-OTRS-' . $FieldType . 'DynamicField-' . $FieldName;

                    # delete old element
                    delete $CurrentXHeaders{$HeaderName};

                    # set new element
                    $CurrentXHeaders{$NewHeaderName} = 1;

                    # update rows in postmaster_filter table
                    my $SuccessUpdate = $CommonObject->{DBObject}->Do(
                        SQL =>
                            "UPDATE postmaster_filter SET f_key=? WHERE f_key=?",
                        Bind => [
                            \$NewHeaderName, \$HeaderName,
                        ],
                    );

                    if ( !$SuccessUpdate ) {
                        print "Could not possible to change the key for the post master filter!\n";
                    }

                }
            }
        }

        # migration for time fields
        %XHeadersToChange = (
            'X-OTRS-TicketTime' => {
                Name => 'TicketFreeTime',
                Type => '',
            },
            'X-OTRS-FollowUp-TicketTime' => {
                Name => 'TicketFreeTime',
                Type => 'FollowUp-',
            },
        );

        for my $Key ( sort keys %XHeadersToChange ) {
            for my $Index ( 1 .. 6 ) {

                my $HeaderName = $Key . $Index;
                my $FieldName  = $XHeadersToChange{$Key}->{Name} . $Index;
                my $FieldType  = $XHeadersToChange{$Key}->{Type};

                if ( defined $DynamicFields->{$FieldName} && defined $CurrentXHeaders{$HeaderName} )
                {

                    # set header name for dynamic field
                    my $NewHeaderName = 'X-OTRS-' . $FieldType . 'DynamicField-' . $FieldName;

                    # delete old element
                    delete $CurrentXHeaders{$HeaderName};

                    # set new element
                    $CurrentXHeaders{$NewHeaderName} = 1;

                    # update rows in postmaster_filter table
                    my $SuccessUpdate = $CommonObject->{DBObject}->Do(
                        SQL =>
                            "UPDATE postmaster_filter SET f_key=? WHERE f_key=?",
                        Bind => [
                            \$NewHeaderName, \$HeaderName,
                        ],
                    );

                    if ( !$SuccessUpdate ) {
                        print "Could not possible to change the key for the post master filter!\n";
                    }

                }
            }
        }

        # migration for article fields
        %XHeadersToChange = (
            'X-OTRS-ArticleKey' => {
                Name => 'ArticleFreeKey',
                Type => '',
            },
            'X-OTRS-ArticleValue' => {
                Name => 'ArticleFreeText',
                Type => '',
            },
            'X-OTRS-FollowUp-ArticleKey' => {
                Name => 'ArticleFreeKey',
                Type => 'FollowUp-',
            },
            'X-OTRS-FollowUp-ArticleValue' => {
                Name => 'ArticleFreeText',
                Type => 'FollowUp-',
            },
        );

        for my $Key ( sort keys %XHeadersToChange ) {
            for my $Index ( 1 .. 3 ) {

                my $HeaderName = $Key . $Index;
                my $FieldName  = $XHeadersToChange{$Key}->{Name} . $Index;
                my $FieldType  = $XHeadersToChange{$Key}->{Type};
                if ( defined $DynamicFields->{$FieldName} && defined $CurrentXHeaders{$HeaderName} )
                {

                    # set header name for dynamic field
                    my $NewHeaderName = 'X-OTRS-' . $FieldType . 'DynamicField-' . $FieldName;

                    # delete old element
                    delete $CurrentXHeaders{$HeaderName};

                    # set new element
                    $CurrentXHeaders{$NewHeaderName} = 1;

                    # update rows in postmaster_filter table
                    my $SuccessUpdate = $CommonObject->{DBObject}->Do(
                        SQL =>
                            "UPDATE postmaster_filter SET f_key=? WHERE f_key=?",
                        Bind => [
                            \$NewHeaderName, \$HeaderName,
                        ],
                    );

                    if ( !$SuccessUpdate ) {
                        print "Could not possible to change the key for the post master filter!\n";
                    }

                }
            }
        }

        # revert values from hash into an array
        @ValuesToSet = sort keys %CurrentXHeaders;

    }

    # execute the update action in sysconfig
    my $Success = $SysConfigObject->ConfigItemUpdate(
        Valid => 1,
        Key   => 'PostmasterX-Header',
        Value => \@ValuesToSet,
    );

    if ( !$Success ) {
        print
            "Could not migrate the config values on AgentTicketSearch window!\n";
        return 0;
    }

    return 1;
}

=item _MigrateResponsesConfiguration($CommonObject)

migrates the configuration of the free fields for each response to the
new dynamic field structure.

    _MigrateResponsesConfiguration($CommonObject);

=cut

sub _MigrateResponsesConfiguration {
    my $CommonObject = shift;

    # set local dynamic fields as OTRS 3.0 Free Fields defaults
    my %LocalDynamicFields;
    for my $Counter ( 1 .. 16 ) {
        $LocalDynamicFields{ 'TicketFreeText' . $Counter } = 1;
        $LocalDynamicFields{ 'TicketFreeKey' . $Counter }  = 1;
    }
    for my $Counter ( 1 .. 6 ) {
        $LocalDynamicFields{ 'TicketFreeTime' . $Counter } = 1;
    }

    # find all responses that has defined free fields tags
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT sr.id, sr.name, sr.text
            FROM standard_response sr
            WHERE sr.text like '%OTRS_TICKET_TicketFree%'
            ORDER BY sr.id",
    );

    my @ResponseRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get response details
        my %ResponseRecordConfig = (
            ResponseID      => $Row[0],
            ResponseName    => $Row[1],
            ResponseText    => $Row[2],
            ResponseTextNew => $Row[2]
        );

        for my $FieldName ( keys %LocalDynamicFields ) {

            # replace all occurrences of this $FieldName
            $ResponseRecordConfig{ResponseTextNew}
                =~ s{\QOTRS_TICKET_$FieldName\E}{OTRS_TICKET_DynamicField_$FieldName}gsx;
        }

        # save record details to update DB later
        push @ResponseRecordsToChange, \%ResponseRecordConfig;
    }

    for my $ResponseRecordConfig (@ResponseRecordsToChange) {

        # update database
        my $SuccessResponseUpdate = $CommonObject->{DBObject}->Do(
            SQL => "UPDATE standard_response
                SET text = ?
                WHERE id = ?
                    AND name = ?",
            Bind => [
                \$ResponseRecordConfig->{ResponseTextNew},
                \$ResponseRecordConfig->{ResponseID},
                \$ResponseRecordConfig->{ResponseName},
            ],
        );

        # check for errors
        if ( !$SuccessResponseUpdate ) {
            print "Could not migrate the Response $ResponseRecordConfig->{ResponseName}\n";
            return 0;
        }
    }
    return 1;
}

=item _MigrateAutoResponsesConfiguration($CommonObject)

migrates the configuration of the free fields for each auto response to the
new dynamic field structure.

    _MigrateResponsesConfiguration($CommonObject);

=cut

sub _MigrateAutoResponsesConfiguration {
    my $CommonObject = shift;

    # set local dynamic fields as OTRS 3.0 Free Fields defaults
    my %LocalDynamicFields;
    for my $Counter ( 1 .. 16 ) {
        $LocalDynamicFields{ 'TicketFreeText' . $Counter } = 1;
        $LocalDynamicFields{ 'TicketFreeKey' . $Counter }  = 1;
    }
    for my $Counter ( 1 .. 6 ) {
        $LocalDynamicFields{ 'TicketFreeTime' . $Counter } = 1;
    }

    # find all auto responses that has defined free fields tags
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT ar.id, ar.name, ar.text0, ar.text1, ar.text2
            FROM auto_response ar
            WHERE ar.text0 like '%OTRS_TICKET_TicketFree%'
                OR ar.text1 like '%OTRS_TICKET_TicketFree%'
                OR ar.text2 like '%OTRS_TICKET_TicketFree%'
            ORDER BY ar.id",
    );

    my @AutoResponseRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get auto response details
        my %AutoResponseRecordConfig = (
            AutoResponseID       => $Row[0],
            AutoResponseName     => $Row[1],
            AutoResponseText0    => $Row[2],
            AutoResponseText0New => $Row[2],
            AutoResponseText1    => $Row[3],
            AutoResponseText1New => $Row[3],
            AutoResponseText2    => $Row[4],
            AutoResponseText2New => $Row[4],
        );

        for my $FieldName ( keys %LocalDynamicFields ) {

            # replace all occurrences of this $FieldName
            $AutoResponseRecordConfig{AutoResponseText0New}
                =~ s{\QOTRS_TICKET_$FieldName\E}{OTRS_TICKET_DynamicField_$FieldName}gsx;

            $AutoResponseRecordConfig{AutoResponseText1New}
                =~ s{\QOTRS_TICKET_$FieldName\E}{OTRS_TICKET_DynamicField_$FieldName}gsx;

            if ( $AutoResponseRecordConfig{AutoResponseText2New} ) {
                $AutoResponseRecordConfig{AutoResponseText2New}
                    =~ s{\QOTRS_TICKET_$FieldName\E}{OTRS_TICKET_DynamicField_$FieldName}gsx;
            }
        }

        # save record details to update DB later
        push @AutoResponseRecordsToChange, \%AutoResponseRecordConfig;
    }

    for my $AutoResponseRecordConfig (@AutoResponseRecordsToChange) {

        # update database
        my $SuccessAutoResponseUpdate = $CommonObject->{DBObject}->Do(
            SQL => "UPDATE auto_response
                SET text0 = ?, text1 = ?, text2 = ?
                WHERE id = ?
                    AND name = ?",
            Bind => [
                \$AutoResponseRecordConfig->{AutoResponseText0New},
                \$AutoResponseRecordConfig->{AutoResponseText1New},
                \$AutoResponseRecordConfig->{AutoResponseText2New},
                \$AutoResponseRecordConfig->{AutoResponseID},
                \$AutoResponseRecordConfig->{AutoResponseName},
            ],
        );

        # check for errors
        if ( !$SuccessAutoResponseUpdate ) {
            print "Could not migrate the Auto Response "
                . "$AutoResponseRecordConfig->{AutoResponseName}\n";
            return 0;
        }
    }
    return 1;
}

=item _MigrateSalutationsConfiguration($CommonObject)

migrates the configuration of the free fields for each salutation to the
new dynamic field structure.

    _MigrateSalutationsConfiguration($CommonObject);

=cut

sub _MigrateSalutationsConfiguration {
    my $CommonObject = shift;

    # set local dynamic fields as OTRS 3.0 Free Fields defaults
    my %LocalDynamicFields;
    for my $Counter ( 1 .. 16 ) {
        $LocalDynamicFields{ 'TicketFreeText' . $Counter } = 1;
        $LocalDynamicFields{ 'TicketFreeKey' . $Counter }  = 1;
    }
    for my $Counter ( 1 .. 6 ) {
        $LocalDynamicFields{ 'TicketFreeTime' . $Counter } = 1;
    }

    # find all salutations that has defined free fields tags
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT s.id, s.name, s.text
            FROM salutation s
            WHERE s.text like '%OTRS_TICKET_TicketFree%'
            ORDER BY s.id",
    );

    my @SalutationRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get salutation details
        my %SalutationRecordConfig = (
            SalutationID      => $Row[0],
            SalutationName    => $Row[1],
            SalutationText    => $Row[2],
            SalutationTextNew => $Row[2]
        );

        for my $FieldName ( keys %LocalDynamicFields ) {

            # replace all occurrences of this $FieldName
            $SalutationRecordConfig{SalutationTextNew}
                =~ s{\QOTRS_TICKET_$FieldName\E}{OTRS_TICKET_DynamicField_$FieldName}gsx;
        }

        # save record details to update DB later
        push @SalutationRecordsToChange, \%SalutationRecordConfig;
    }

    for my $SalutationRecordConfig (@SalutationRecordsToChange) {

        # update database
        my $SuccessSalutationUpdate = $CommonObject->{DBObject}->Do(
            SQL => "UPDATE salutation
                SET text = ?
                WHERE id = ?
                    AND name = ?",
            Bind => [
                \$SalutationRecordConfig->{SalutationTextNew},
                \$SalutationRecordConfig->{SalutationID},
                \$SalutationRecordConfig->{SalutationName},
            ],
        );

        # check for errors
        if ( !$SuccessSalutationUpdate ) {
            print "Could not migrate the Salutation $SalutationRecordConfig->{SalutationName}\n";
            return 0;
        }
    }
    return 1;
}

=item _MigrateSignaturesConfiguration($CommonObject)

migrates the configuration of the free fields for each signature to the
new dynamic field structure.

    _MigrateSignaturesConfiguration($CommonObject);

=cut

sub _MigrateSignaturesConfiguration {
    my $CommonObject = shift;

    # set local dynamic fields as OTRS 3.0 Free Fields defaults
    my %LocalDynamicFields;
    for my $Counter ( 1 .. 16 ) {
        $LocalDynamicFields{ 'TicketFreeText' . $Counter } = 1;
        $LocalDynamicFields{ 'TicketFreeKey' . $Counter }  = 1;
    }
    for my $Counter ( 1 .. 6 ) {
        $LocalDynamicFields{ 'TicketFreeTime' . $Counter } = 1;
    }

    # find all signatures that has defined free fields tags
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT s.id, s.name, s.text
            FROM signature s
            WHERE s.text like '%OTRS_TICKET_TicketFree%'
            ORDER BY s.id",
    );

    my @SignatureRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get signature details
        my %SignatureRecordConfig = (
            SignatureID      => $Row[0],
            SignatureName    => $Row[1],
            SignatureText    => $Row[2],
            SignatureTextNew => $Row[2]
        );

        for my $FieldName ( keys %LocalDynamicFields ) {

            # replace all occurrences of this $FieldName
            $SignatureRecordConfig{SignatureTextNew}
                =~ s{\QOTRS_TICKET_$FieldName\E}{OTRS_TICKET_DynamicField_$FieldName}gsx;
        }

        # save record details to update DB later
        push @SignatureRecordsToChange, \%SignatureRecordConfig;
    }

    for my $SignatureRecordConfig (@SignatureRecordsToChange) {

        # update database
        my $SuccessSignatureUpdate = $CommonObject->{DBObject}->Do(
            SQL => "UPDATE signature
                SET text = ?
                WHERE id = ?
                    AND name = ?",
            Bind => [
                \$SignatureRecordConfig->{SignatureTextNew},
                \$SignatureRecordConfig->{SignatureID},
                \$SignatureRecordConfig->{SignatureName},
            ],
        );

        # check for errors
        if ( !$SuccessSignatureUpdate ) {
            print "Could not migrate the Signature $SignatureRecordConfig->{SignatureName}\n";
            return 0;
        }
    }
    return 1;
}

=item _MigrateSearchProfilesConfiguration($CommonObject)

migrates the configuration of the free fields for each search profile to the
new dynamic field structure.

    _MigrateSearchProfilesConfiguration($CommonObject);

=cut

sub _MigrateSearchProfilesConfiguration {
    my $CommonObject = shift;

    # create additional objects
    my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$CommonObject} );

    # get DynamicFields list
    my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ResultType => 'HASH',
    );

    # reverse the DynamicFields list to create a lookup table
    $DynamicFields = { reverse %{$DynamicFields} };

    # find all free fields for search to be migrated
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT sp.login, sp.profile_name, sp.profile_type, sp.profile_key, sp.profile_value
            FROM search_profile sp
            WHERE sp.profile_key LIKE 'TicketFree%'
            ORDER BY sp.login, sp.profile_name",
    );

    my @ProfileRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get field details
        my %ProfileRecordConfig = (
            ProfileLogin => $Row[0],
            ProfileName  => $Row[1],
            ProfileType  => $Row[2],
            ProfileKey   => $Row[3],
            ProfileValue => $Row[4],
        );

        # save field details
        push @ProfileRecordsToChange, \%ProfileRecordConfig;
    }

    # set search prefix
    my $SearchPrefix = 'Search_DynamicField_';

    PROFILEFIELDCONFIG:
    for my $ProfileRecordConfig (@ProfileRecordsToChange) {

        # check profile entry
        next PROFILEFIELDCONFIG if !$ProfileRecordConfig->{ProfileKey};

        # clean up profile key
        my $ProfileKey = $ProfileRecordConfig->{ProfileKey};
        $ProfileKey =~ s/(Start|Stop)(Year|Day|Month)$//g;

        # check if the migrated dynamic field is available
        next PROFILEFIELDCONFIG if !$DynamicFields->{$ProfileKey};

        # append search prefix to search profile free fields
        $ProfileRecordConfig->{ProfileKeyNew} = $SearchPrefix . $ProfileRecordConfig->{ProfileKey};

        # update database
        my $SuccessProfileUpdate = $CommonObject->{DBObject}->Do(
            SQL => "UPDATE search_profile
                SET profile_key = ?
                WHERE login = ?
                    AND profile_name = ?
                    AND profile_type = ?
                    AND profile_key = ?
                    AND profile_value = ?",
            Bind => [
                \$ProfileRecordConfig->{ProfileKeyNew},
                \$ProfileRecordConfig->{ProfileLogin},
                \$ProfileRecordConfig->{ProfileName},
                \$ProfileRecordConfig->{ProfileType},
                \$ProfileRecordConfig->{ProfileKey},
                \$ProfileRecordConfig->{ProfileValue},
            ],
        );

        # check for errors
        if ( !$SuccessProfileUpdate ) {
            print "Could not migrate the Search Profile $ProfileRecordConfig->{ProfileName}"
                . " field $ProfileRecordConfig->{ProfileKey}\n";

            return 0;
        }
    }
    return 1;
}

=item _MigrateNotificationsConfiguration($CommonObject)

migrates the configuration of the free fields for each notification to the
new dynamic field structure.

    _MigrateNotificationsConfiguration($CommonObject);

=cut

sub _MigrateNotificationsConfiguration {
    my $CommonObject = shift;

    # set local dynamic fields as OTRS 3.0 Free Fields defaults
    my %LocalDynamicFields;
    for my $Counter ( 1 .. 16 ) {
        $LocalDynamicFields{ 'TicketFreeText' . $Counter } = 1;
        $LocalDynamicFields{ 'TicketFreeKey' . $Counter }  = 1;
    }
    for my $Counter ( 1 .. 6 ) {
        $LocalDynamicFields{ 'TicketFreeTime' . $Counter } = 1;
    }

    # find all notifications that has defined free fields tags
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT id, subject, text, notification_type
            FROM notifications
            WHERE subject like '%OTRS_TICKET_TicketFree%' OR text like '%OTRS_TICKET_TicketFree%'
            ORDER BY id",
    );

    my @NotificationRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get signature details
        my %NotificationRecordConfig = (
            NotificationID         => $Row[0],
            NotificationSubject    => $Row[1],
            NotificationSubjectNew => $Row[1],
            NotificationText       => $Row[2],
            NotificationTextNew    => $Row[2],
            NotificationType       => $Row[3]
        );

        for my $FieldName ( keys %LocalDynamicFields ) {

            # replace all occurrences of this $FieldName
            $NotificationRecordConfig{NotificationSubjectNew}
                =~ s{\QOTRS_TICKET_$FieldName\E}{OTRS_TICKET_DynamicField_$FieldName}gsx;
            $NotificationRecordConfig{NotificationTextNew}
                =~ s{\QOTRS_TICKET_$FieldName\E}{OTRS_TICKET_DynamicField_$FieldName}gsx;
        }

        # save record details to update DB later
        push @NotificationRecordsToChange, \%NotificationRecordConfig;
    }

    for my $NotificationRecordConfig (@NotificationRecordsToChange) {

        if (
            $NotificationRecordConfig->{NotificationSubject} ne
            $NotificationRecordConfig->{NotificationSubjectNew}
            ||
            $NotificationRecordConfig->{NotificationText} ne
            $NotificationRecordConfig->{NotificationTextNew}
            )
        {

            # update database
            my $SuccessNotificationUpdate = $CommonObject->{DBObject}->Do(
                SQL => "UPDATE notifications
                    SET subject = ?, text = ?
                    WHERE id = ?",
                Bind => [
                    \$NotificationRecordConfig->{NotificationSubjectNew},
                    \$NotificationRecordConfig->{NotificationTextNew},
                    \$NotificationRecordConfig->{NotificationID},
                ],
            );

            # check for errors
            if ( !$SuccessNotificationUpdate ) {
                print
                    "Could not migrate the Notification $NotificationRecordConfig->{NotificationType}\n";
                return 0;
            }
        }
    }
    return 1;
}

=item _MigrateNotificationEventConfiguration($CommonObject)

migrates the configuration of the free fields for each notification event to the
new dynamic field structure.

    _MigrateNotificationEventConfiguration($CommonObject);

=cut

sub _MigrateNotificationEventConfiguration {
    my $CommonObject = shift;

    # set local dynamic fields as OTRS 3.0 Free Fields defaults
    my %LocalDynamicFields;
    for my $Counter ( 1 .. 16 ) {
        $LocalDynamicFields{ 'TicketFreeText' . $Counter } = 1;
        $LocalDynamicFields{ 'TicketFreeKey' . $Counter }  = 1;
    }
    for my $Counter ( 1 .. 6 ) {
        $LocalDynamicFields{ 'TicketFreeTime' . $Counter } = 1;
    }

    # notification event

    # find all notification events that has defined free fields tags
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT id, subject, text, name
            FROM notification_event
            WHERE subject like '%OTRS_TICKET_TicketFree%' OR text like '%OTRS_TICKET_TicketFree%'
            ORDER BY id",
    );

    my @NotificationRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get signature details
        my %NotificationRecordConfig = (
            NotificationID         => $Row[0],
            NotificationSubject    => $Row[1],
            NotificationSubjectNew => $Row[1],
            NotificationText       => $Row[2],
            NotificationTextNew    => $Row[2],
            NotificationName       => $Row[3]
        );

        for my $FieldName ( keys %LocalDynamicFields ) {

            # replace all occurrences of this $FieldName
            $NotificationRecordConfig{NotificationSubjectNew}
                =~ s{\QOTRS_TICKET_$FieldName\E}{OTRS_TICKET_DynamicField_$FieldName}gsx;
            $NotificationRecordConfig{NotificationTextNew}
                =~ s{\QOTRS_TICKET_$FieldName\E}{OTRS_TICKET_DynamicField_$FieldName}gsx;
        }

        # save record details to update DB later
        push @NotificationRecordsToChange, \%NotificationRecordConfig;
    }

    for my $NotificationRecordConfig (@NotificationRecordsToChange) {

        if (
            $NotificationRecordConfig->{NotificationSubject} ne
            $NotificationRecordConfig->{NotificationSubjectNew}
            ||
            $NotificationRecordConfig->{NotificationText} ne
            $NotificationRecordConfig->{NotificationTextNew}
            )
        {

            # update database
            my $SuccessNotificationUpdate = $CommonObject->{DBObject}->Do(
                SQL => "UPDATE notification_event
                    SET subject = ?, text = ?
                    WHERE id = ?",
                Bind => [
                    \$NotificationRecordConfig->{NotificationSubjectNew},
                    \$NotificationRecordConfig->{NotificationTextNew},
                    \$NotificationRecordConfig->{NotificationID},
                ],
            );

            # check for errors
            if ( !$SuccessNotificationUpdate ) {
                print
                    "Could not migrate the Notification "
                    . "$NotificationRecordConfig->{NotificationName}\n";
                return 0;
            }
        }
    }

    # notification event item
    my %LocalDynamicFieldsItem;
    for my $Counter ( 1 .. 16 ) {
        $LocalDynamicFieldsItem{ 'TicketFreeTextUpdate' . $Counter } = 'TicketFreeText' . $Counter;
    }
    for my $Counter ( 1 .. 6 ) {
        $LocalDynamicFieldsItem{ 'TicketFreeTimeUpdate' . $Counter } = 'TicketFreeTime' . $Counter;
    }

    # find all notification events that has defined free fields tags
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT notification_id, event_value
            FROM notification_event_item
            WHERE event_key='Events' AND event_value like 'TicketFree%'
            ORDER BY notification_id",
    );

    my @NotificationItemRecordsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get signature details
        my %NotificationItemRecordConfig = (
            NotificationID            => $Row[0],
            NotificationEventValue    => $Row[1],
            NotificationEventValueNew => $Row[1],
        );

        for my $FieldName ( keys %LocalDynamicFieldsItem ) {

            # replace all occurrences of this $FieldName
            $NotificationItemRecordConfig{NotificationEventValueNew}
                =~ s{\Q$FieldName\E}{TicketDynamicFieldUpdate_$LocalDynamicFieldsItem{$FieldName}}gsx;
        }

        # save record details to update DB later
        push @NotificationItemRecordsToChange, \%NotificationItemRecordConfig;
    }

    for my $NotificationItemRecordConfig (@NotificationItemRecordsToChange) {

        if (
            $NotificationItemRecordConfig->{NotificationEventValue} ne
            $NotificationItemRecordConfig->{NotificationEventValueNew}
            )
        {

            # update database
            my $SuccessNotificationItemUpdate = $CommonObject->{DBObject}->Do(
                SQL => "UPDATE notification_event_item
                    SET event_value = ?
                    WHERE notification_id = ? AND event_value = ?",
                Bind => [
                    \$NotificationItemRecordConfig->{NotificationEventValueNew},
                    \$NotificationItemRecordConfig->{NotificationID},
                    \$NotificationItemRecordConfig->{NotificationEventValue},
                ],
            );

            # check for errors
            if ( !$SuccessNotificationItemUpdate ) {
                print
                    "Could not migrate the Notification Item "
                    . "$NotificationItemRecordConfig->{NotificationName}\n";
                return 0;
            }
        }
    }

    # notification event item keys

    # create additional objects
    my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$CommonObject} );

    # get DynamicFields list
    my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
        Valid      => 0,
        ResultType => 'HASH',
    );

    # reverse the DynamicFields list to create a lookup table
    $DynamicFields = { reverse %{$DynamicFields} };

    # find all notification events that has defined free fields tags
    return if !$CommonObject->{DBObject}->Prepare(
        SQL => "SELECT notification_id, event_key, event_value
            FROM notification_event_item
            WHERE event_key like 'TicketFree%'
            ORDER BY notification_id",
    );

    # reset notifications array
    @NotificationItemRecordsToChange = ();

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get signature details
        my %NotificationItemRecordConfig = (
            NotificationID          => $Row[0],
            NotificationEventKey    => $Row[1],
            NotificationEventKeyNew => $Row[1],
            NotificationEventValue  => $Row[2],
        );

        # save field details
        push @NotificationItemRecordsToChange, \%NotificationItemRecordConfig;
    }

    # set search prefix
    my $SearchPrefix = 'Search_DynamicField_';

    NOTIFICATIONITEMCONFIG:
    for my $NotificationItemRecordConfig (@NotificationItemRecordsToChange) {

        # check if the migrated dynamic field is available
        next NOTIFICATIONITEMCONFIG
            if !$DynamicFields->{ $NotificationItemRecordConfig->{NotificationEventKey} };

        # append search prefix to the notification key free fields
        $NotificationItemRecordConfig->{NotificationEventKeyNew}
            = $SearchPrefix . $NotificationItemRecordConfig->{NotificationEventKey};

        # update database
        my $SuccessNotificationEventItemUpdate = $CommonObject->{DBObject}->Do(
            SQL => "UPDATE notification_event_item
                SET event_key = ?
                WHERE notification_id = ?
                    AND event_key = ?
                    AND event_value = ?",
            Bind => [
                \$NotificationItemRecordConfig->{NotificationEventKeyNew},
                \$NotificationItemRecordConfig->{NotificationID},
                \$NotificationItemRecordConfig->{NotificationEventKey},
                \$NotificationItemRecordConfig->{NotificationEventValue},
            ],
        );

        # check for errors
        if ( !$SuccessNotificationEventItemUpdate ) {
            print "Could not migrate the Noptification event item "
                . "for Notification ID $NotificationItemRecordConfig->{NotificationID} "
                . "field $NotificationItemRecordConfig->{NotificationEventKey}\n";

            return 0;
        }
    }
    return 1;
}

=item _GetValidFreeFields($CommonObject)

it returns a structure with the information about which
dynamic fields should be enabled or not.

    _GetValidFreeFields($CommonObject);

=cut

sub _GetValidFreeFields {
    my $CommonObject = shift;

    # Purge cache first to make sure that the DF API works correctly
    #   after we made inserts by hand.
    my $CacheObject = Kernel::System::Cache->new( %{$CommonObject} );
    $CacheObject->CleanUp(
        Type => 'DynamicField',
    );

    my %ValidFreeFields;
    my %FreeFields = (
        TicketFreeKey   => 16,
        TicketFreeText  => 16,
        TicketFreeTime  => 6,
        ArticleFreeKey  => 3,
        ArticleFreeText => 3,
    );

    for my $Field ( sort keys %FreeFields ) {
        for my $Index ( 1 .. $FreeFields{$Field} ) {
            my $FieldName = $Field . $Index;
            $ValidFreeFields{$FieldName} = '2';
        }
    }

    my @Windows = (
        'CustomerTicketMessage',
        'CustomerTicketSearch',
        'AgentTicketResponsible',
        'AgentTicketPriority',
        'AgentTicketPhoneOutbound',
        'AgentTicketPhone',
        'AgentTicketPending',
        'AgentTicketOwner',
        'AgentTicketNote',
        'AgentTicketMove',
        'AgentTicketForward',
        'AgentTicketFreeText',
        'AgentTicketEmail',
        'AgentTicketCompose',
        'AgentTicketClose',
    );

    for my $Window (@Windows) {

        my $WindowConfig = $CommonObject->{ConfigObject}->Get("Ticket::Frontend::$Window");

        for my $FreeField ( sort keys %FreeFields ) {

            if ( defined $WindowConfig->{$FreeField} ) {

                my $Config = $WindowConfig->{$FreeField};

                for my $Index ( 1 .. $FreeFields{$FreeField} ) {

                    my $FreeFieldName = $FreeField . $Index;
                    if ( defined $Config->{$Index} && $Config->{$Index} ) {
                        $ValidFreeFields{$FreeFieldName} = '1';

                        # enable its own key field
                        if ( $FreeField eq 'TicketFreeText' ) {
                            $ValidFreeFields{ 'TicketFreeKey' . $Index } = '1';
                        }
                        if ( $FreeField eq 'ArticleFreeText' ) {
                            $ValidFreeFields{ 'ArticleFreeKey' . $Index } = '1';
                        }
                    }
                }
            }
        }
    }

    # AgentTicketSearch configuration

    my $WindowConfig =
        $CommonObject->{ConfigObject}->Get('Ticket::Frontend::AgentTicketSearch');

    if ( defined $WindowConfig->{Defaults} ) {

        my $Config = $WindowConfig->{Defaults};

        for my $FreeField ( sort keys %FreeFields ) {

            for my $Index ( 1 .. $FreeFields{$FreeField} ) {

                my $FreeFieldName = $FreeField . $Index;
                if ( defined $Config->{$FreeFieldName} && $Config->{$FreeFieldName} ) {
                    $ValidFreeFields{$FreeFieldName} = '1';

                    # enable its own key field
                    if ( $FreeField eq 'TicketFreeText' ) {
                        $ValidFreeFields{ 'TicketFreeKey' . $Index } = '1';
                    }
                    if ( $FreeField eq 'ArticleFreeText' ) {
                        $ValidFreeFields{ 'ArticleFreeKey' . $Index } = '1';
                    }
                }
            }
        }
    }

    # CustomerTicketZoom configuration

    $WindowConfig = $CommonObject->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketZoom')
        || {};
    my %ValuesToSetZoom;
    my $Config;
    if ( defined $WindowConfig->{AttributesView} && ref $WindowConfig->{AttributesView} eq 'HASH' )
    {

        $Config = $WindowConfig->{AttributesView};

        for my $FreeField ( sort keys %FreeFields ) {
            for my $Index ( 1 .. $FreeFields{$FreeField} ) {
                my $FreeFieldName = $FreeField . $Index;
                if ( defined $Config->{$FreeFieldName} && $Config->{$FreeFieldName} ) {
                    $ValidFreeFields{$FreeFieldName} = '1';

                    # enable its own key field
                    if ( $FreeField eq 'TicketFreeText' ) {
                        $ValidFreeFields{ 'TicketFreeKey' . $Index } = '1';
                    }
                    if ( $FreeField eq 'ArticleFreeText' ) {
                        $ValidFreeFields{ 'ArticleFreeKey' . $Index } = '1';
                    }
                }
            }
        }
    }

    # avoided configuration for
    # AgentTicketPrint configuration
    # CustomerTicketPrint configuration

    return \%ValidFreeFields;
}

=item _RemoveDuplicatesTicketFlag($CommonObject)

remove any duplicate entries on ticket_flag table. This is neccessary because with
OTRS 3.1, a unique index will be applied to the ticket_flag table to enforce uniqueness.
On older systems, duplicated entries could be created under some rare circumstances.
This function deletes these duplicated flags to make the index creation work correctly.

    _RemoveDuplicatesTicketFlag($CommonObject);

=cut

sub _RemoveDuplicatesTicketFlag {
    my $CommonObject = shift;

    # find all duplicated entries
    $CommonObject->{DBObject}->Prepare(
        SQL =>
            "SELECT ticket_id, ticket_key, create_by, COUNT(*) AS entries
                FROM ticket_flag
                GROUP BY ticket_id, ticket_key, create_by
                HAVING COUNT(*) >1 ",
    );

    my @TicketFlagsToChange;

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # get ticket flag details
        my %TicketFlagEntry = (
            ticket_id  => $Row[0],
            ticket_key => $Row[1],
            create_by  => $Row[2],
        );

        # save record details to use it later
        push @TicketFlagsToChange, \%TicketFlagEntry;
    }

    for my $TicketFlagEntry (@TicketFlagsToChange) {

        my %CurrentTicketFlagValue;

        # get the full current value of the TF
        $CommonObject->{DBObject}->Prepare(
            SQL =>
                "SELECT ticket_id, ticket_key, ticket_value, create_time, create_by
                    FROM ticket_flag
                    WHERE ticket_id = ?
                        AND ticket_key = ?
                        AND create_by = ?
                    ORDER BY create_time ASC",
            Bind => [
                \$TicketFlagEntry->{ticket_id},
                \$TicketFlagEntry->{ticket_key},
                \$TicketFlagEntry->{create_by},
            ],
            Limit => 1,
        );

        # loop through all results
        while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

            # get ticket flag details
            %CurrentTicketFlagValue = (
                ticket_id    => $Row[0],
                ticket_key   => $Row[1],
                ticket_value => $Row[2],
                create_time  => $Row[3],
                create_by    => $Row[4],
            );
        }

        print
            "\nDeleting duplicate ticket_flag entries for ticket $CurrentTicketFlagValue{ticket_id}, key '$CurrentTicketFlagValue{ticket_key}', user $CurrentTicketFlagValue{create_by}";

        # Delete duplicated flags. We'll insert one flag after this.
        my $SuccessFlagDelete = $CommonObject->{DBObject}->Do(
            SQL => "DELETE FROM ticket_flag
                WHERE ticket_id = ?
                    AND ticket_key = ?
                    AND create_by = ?",
            Bind => [
                \$TicketFlagEntry->{ticket_id},
                \$TicketFlagEntry->{ticket_key},
                \$TicketFlagEntry->{create_by},
            ],
        );

        # check for errors
        if ( !$SuccessFlagDelete ) {
            print "Could not delete duplicated field $TicketFlagEntry->{ticket_key} from the "
                . "Ticket Flag\n";
            return 0;
        }

        # Re-insert the original ticket flag value.
        my $SuccessTicketFlag = $CommonObject->{DBObject}->Do(
            SQL =>
                'INSERT INTO ticket_flag (' .
                'ticket_id, ticket_key, ticket_value,create_time, create_by' .
                ') VALUES (?, ?, ?, ?, ?)',
            Bind => [
                \$CurrentTicketFlagValue{ticket_id},    \$CurrentTicketFlagValue{ticket_key},
                \$CurrentTicketFlagValue{ticket_value}, \$CurrentTicketFlagValue{create_time},
                \$CurrentTicketFlagValue{create_by},
            ],
        );

        # check for errors
        if ( !$SuccessTicketFlag ) {
            print
                "Could not insert new single entry for ticket flag $TicketFlagEntry->{ticket_key}\n";
            return 0;
        }
    }

    my @TicketFlagsToVerify;

    # Check again for duplicated entries
    $CommonObject->{DBObject}->Prepare(
        SQL =>
            "SELECT ticket_id, ticket_key, create_by, COUNT(*) AS entries
                FROM ticket_flag
                GROUP BY ticket_id, ticket_key, create_by
                HAVING COUNT(*) > 1 ",
    );

    # loop through all results
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # save record to use it later
        push @TicketFlagsToVerify, $Row[0];
    }

    # verify for not duplicated entries
    return 0 if scalar @TicketFlagsToVerify;

    # everything ok
    return 1;
}

1;
