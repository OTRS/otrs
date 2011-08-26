#!/usr/bin/perl -w
# --
# DBUpdate-to-3.1.pl - update script to migrate OTRS 2.4.x to 3.0.x
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DBUpdate-to-3.1.pl,v 1.4 2011-08-26 08:56:48 mg Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
$VERSION = qw($Revision: 1.4 $) [1];

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

{

    # get options
    my %Opts;
    Getopt::Std::getopt( 'h', \%Opts );

    if ( exists $Opts{h} ) {
        print <<"EOF";

DBUpdate-to-3.1.pl <Revision $VERSION> - Database migration script for Dynamic Fields
Copyright (C) 2001-2011 OTRS AG, http://otrs.org/

EOF
        exit 1;
    }

    print "\nMigration started...\n\n";

    # create common objects
    my $CommonObject = _CommonObjectsBase();

    print "Step 1 of 10: Refresh configuration cache... ";
    RebuildConfig($CommonObject);
    print "done.\n\n";

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    # check framework version
    print "Step 2 of 10: Check framework version... ";
    _CheckFrameworkVersion($CommonObject);
    print "done.\n\n";

    print "Step 3 of 10: Creating DynamicField tables (if necessary)... ";
    if ( _CheckDynamicFieldTables($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

    # insert dynamic field records, if necessary
    print "Step 4 of 10: Create new dynamic fields for free fields (text, key, date)... ";
    if ( !_IsFreefieldsMigrationAlreadyDone($CommonObject) ) {
        _DynamicFieldCreation($CommonObject);
    }
    print "done.\n\n";

    # migrate ticket free field
    print "Step 5 of 10: Migrate ticket free fields to dynamic fields.. ";
    if ( !_IsFreefieldsMigrationAlreadyDone($CommonObject) ) {
        my $TicketMigrated = _DynamicFieldTicketMigration($CommonObject);
    }
    print "done.\n\n";

    # migrate ticket free field
    print "Step 6 of 10: Migrate article free fields to dynamic fields.. ";
    if ( !_IsFreefieldsMigrationAlreadyDone($CommonObject) ) {
        my $ArticleMigrated = _DynamicFieldArticleMigration($CommonObject);
    }
    print "done.\n\n";

    # verify ticket migration
    my $VerificationTicketData;
    print "Step 10 of 10: Verify if Ticket data were succesfuly migrated.. ";
    if ( !_IsFreefieldsMigrationAlreadyDone($CommonObject) ) {
        $VerificationTicketData = _VerificationTicketData($CommonObject);
    }
    print "done.\n\n";

    # verify article migration
    my $VerificationArticleData;
    print "Step 10 of 10: Verify if Article data were succesfuly migrated.. ";
    if ( !_IsFreefieldsMigrationAlreadyDone($CommonObject) ) {
        $VerificationArticleData = _VerificationArticleData($CommonObject);
    }
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

    # write now default config options
    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );
    if ( !$SysConfigObject->WriteDefault() ) {
        die "ERROR: Can't write default config files!";
    }

    # reload config object
    $CommonObject->{ConfigObject} = Kernel::Config->new( %{$CommonObject} );

    return 1;
}

=item _CheckFrameworVersion()

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

Checks if the free field were drop, then there are nathing to do

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
        for my $FreeField ( 'ticketfreekey', 'ticketfreetext' ) {

            if ( !$Data{ $FreeField . $Index } ) {
                my $FieldName = $FreeField . $Index;

                # insert new dynamic field
                my $SuccessTicketField = $CommonObject->{DBObject}->Do(
                    SQL =>
                        "INSERT INTO dynamic_field (name, label, field_order, field_type, object_type, config,
                            valid_id, create_time, create_by, change_time, change_by)
                        VALUES (?, ?, ?, 'Text', 'Ticket', '', 1, current_timestamp, 1, current_timestamp, 1)",
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

        if ( !$Data{ 'ticketfreetime' . $Index } ) {
            my $FieldName = 'ticketfreetime' . $Index;

            # insert new dynamic field
            my $SuccessTicketField = $CommonObject->{DBObject}->Do(
                SQL =>
                    "INSERT INTO dynamic_field (name, label, field_order, field_type, object_type, config,
                        valid_id, create_time, create_by, change_time, change_by)
                    VALUES (?, ?, ?, 'DateTime', 'Ticket', '', 1, current_timestamp, 1, current_timestamp, 1)",
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
        for my $FreeField ( 'articlefreekey', 'articlefreetext' ) {
            if ( !$Data{ $FreeField . $Index } ) {
                my $FieldName = $FreeField . $Index;

                # insert new dynamic field
                my $SuccessArticleField = $CommonObject->{DBObject}->Do(
                    SQL =>
                        "INSERT INTO dynamic_field (name, label, field_order, field_type, object_type, config,
                            valid_id, create_time, create_by, change_time, change_by)
                        VALUES (?, ?, ?, 'Text', 'Article', '', 1, current_timestamp, 1, current_timestamp, 1)",
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

Checks if the free field were drop, then there are nathing to do

    _DynamicFieldTicketMigration($CommonObject);

=cut

sub _DynamicFieldTicketMigration {
    my $CommonObject = shift;

    my $MigratedTicketCounter = 0;
    my %TicketFreeFields      = (
        freekey  => 16,
        freetext => 16,
        freetime => 6,
    );

    # create fields string and condition
    my $FreeFieldsTicket   = "";
    my $FreeFieldsTicketDB = "";
    my $TicketCondition    = "";
    for my $FreeField ( sort keys %TicketFreeFields ) {

        for my $Index ( 1 .. $TicketFreeFields{$FreeField} ) {
            $FreeFieldsTicket   .= $FreeField . $Index . ", ";
            $FreeFieldsTicketDB .= "'ticket" . $FreeField . $Index . "', ";
            $TicketCondition    .= $FreeField . $Index . " IS NOT NULL OR ";
        }
    }

    # remove unnecessary part
    $FreeFieldsTicket   = substr $FreeFieldsTicket,   0, -2;
    $FreeFieldsTicketDB = substr $FreeFieldsTicketDB, 0, -2;
    $TicketCondition    = substr $TicketCondition,    0, -3;

    # get dynamic field ids and names
    my %DynamicFieldIDs;
    my $SuccessFields = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM dynamic_field ' .
            'WHERE name in (' . $FreeFieldsTicketDB . ')',

        #        Bind => [\$FreeFieldsTicket],
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
    my $DBConnectionObject = Kernel::System::DB->new( %{ $CommonObject->{DBObject} } );

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
        my $SuccessTicketDynamicFields = $DBConnectionObject->Prepare(
            SQL => "SELECT field_id, object_type, object_id FROM dynamic_field_value " .
                "WHERE object_type ='" . $ObjectType . "' and object_id =" . $Row[0],
        );
        my %DynamicFieldRetrieved;
        while ( my @Row = $DBConnectionObject->FetchrowArray() ) {
            $DynamicFieldRetrieved{ $Row[0] . $Row[1] . $Row[2] } = $Row[1];
        }

        my $FieldCounter  = 0;
        my $SuccessTicket = 1;
        my $TicketCounter = 1;
        for my $FreeField ( sort keys %TicketFreeFields ) {

            for my $Index ( 1 .. $TicketFreeFields{$FreeField} ) {
                $FieldCounter++;
                if ( defined $Row[$FieldCounter] ) {

                    my $FieldID    = $DynamicFieldIDs{ 'ticket' . $FreeField . $Index };
                    my $FieldType  = ( $FreeField eq 'freetime' ? 'DateTime' : 'Text' );
                    my $FieldValue = $Row[$FieldCounter];
                    my $ValueType  = ( $FreeField eq 'freetime' ? 'date' : 'text' );
                    my $ObjectID   = $Row[0];
                    if ( !defined $DynamicFieldRetrieved{ $FieldID . $ObjectType . $ObjectID } ) {

                        # insert new dinamic field value
                        # sql
                        my $SuccessTicketField = $DBConnectionObject->Do(
                            SQL =>
                                'INSERT INTO dynamic_field_value (' .
                                'field_id, object_type, object_id, value_' . $ValueType .
                                ') VALUES (?, ?, ?, ?)',
                            Bind => [
                                \$FieldID, \$ObjectType, \$ObjectID, \$FieldValue,
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
            print "\n   Free fields from ticket with ID:$Row[0] was not successfuly migrated. \n";
        }
        else {

            # ticket counter
            $MigratedTicketCounter++;
            print "\n   Migrated ticket $MigratedTicketCounter of $HowMuchTickets. \n";
        }
    }

    return $MigratedTicketCounter;
}

=item _DynamicFieldArticleMigration($CommonObject)

Checks if the free field were drop, then there are nathing to do

    _DynamicFieldArticleMigration($CommonObject);

=cut

sub _DynamicFieldArticleMigration {
    my $CommonObject = shift;

    my $MigratedArticleCounter = 0;
    my %ArticleFreeFields      = (
        freekey  => 3,
        freetext => 3,
    );

    # create fields string and condition
    my $FreeFieldsArticle   = "";
    my $FreeFieldsArticleDB = "";
    my $ArticleCondition    = "";
    for my $FreeField ( sort keys %ArticleFreeFields ) {

        for my $Index ( 1 .. $ArticleFreeFields{$FreeField} ) {
            $FreeFieldsArticle   .= 'a_' . $FreeField . $Index . ", ";
            $FreeFieldsArticleDB .= "'article" . $FreeField . $Index . "', ";
            $ArticleCondition    .= 'a_' . $FreeField . $Index . " IS NOT NULL OR ";
        }
    }

    # remove unnecessary part
    $FreeFieldsArticle   = substr $FreeFieldsArticle,   0, -2;
    $FreeFieldsArticleDB = substr $FreeFieldsArticleDB, 0, -2;
    $ArticleCondition    = substr $ArticleCondition,    0, -3;

    # get dynamic field ids
    my %DynamicFieldIDs;
    my $SuccessFields = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM dynamic_field ' .
            'WHERE name in (' . $FreeFieldsArticleDB . ')',

        #        Bind => [\$FreeFieldsArticle],
    );
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $DynamicFieldIDs{ $Row[1] } = $Row[0];
    }

    # select dynamic field entries
    my $SuccessArticleHowMuch = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT count(id) FROM article ' .
            'WHERE ' . $ArticleCondition,
    );

    my $HowMuchArticles = 0;
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $HowMuchArticles = $Row[0];
    }

    # create new db connection
    my $DBConnectionObject = Kernel::System::DB->new( %{ $CommonObject->{DBObject} } );

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
        my $SuccessArticleDynamicFields = $DBConnectionObject->Prepare(
            SQL => "SELECT field_id, object_type, object_id FROM dynamic_field_value " .
                "WHERE object_type ='" . $ObjectType . "' and object_id =" . $Row[0],
        );
        my %DynamicFieldRetrieved;
        while ( my @Row = $DBConnectionObject->FetchrowArray() ) {
            $DynamicFieldRetrieved{ $Row[0] . $Row[1] . $Row[2] } = $Row[1];
        }

        my $FieldCounter   = 0;
        my $SuccessArticle = 1;
        my $ArticleCounter = 1;
        for my $FreeField ( sort keys %ArticleFreeFields ) {

            for my $Index ( 1 .. $ArticleFreeFields{$FreeField} ) {
                $FieldCounter++;
                if ( defined $Row[$FieldCounter] ) {

                    my $FieldID    = $DynamicFieldIDs{ 'article' . $FreeField . $Index };
                    my $FieldType  = ( $FreeField eq 'freetime' ? 'DateTime' : 'Text' );
                    my $FieldValue = $Row[$FieldCounter];
                    my $ValueType  = ( $FreeField eq 'freetime' ? 'date' : 'text' );
                    my $ObjectID   = $Row[0];
                    if ( !defined $DynamicFieldRetrieved{ $FieldID . $ObjectType . $ObjectID } ) {

                        # insert new dinamic field value
                        # sql
                        my $SuccessArticleField = $DBConnectionObject->Do(
                            SQL =>
                                'INSERT INTO dynamic_field_value (' .
                                'field_id, object_type, object_id, value_' . $ValueType .
                                ') VALUES (?, ?, ?, ?)',
                            Bind => [
                                \$FieldID, \$ObjectType, \$ObjectID, \$FieldValue,
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
            print "\n   Free fields from article with ID:$Row[0] was not successfuly migrated. \n";
        }
        else {

            # article counter
            $MigratedArticleCounter++;
            print "\n   Migrated article $MigratedArticleCounter of $HowMuchArticles. \n";
        }
    }

    return $MigratedArticleCounter;
}

=item _VerificationTicketData($CommonObject)

Checks if the DynamicField tables exist, and if they don't they will be created.

    _VerificationTicketData($CommonObject);

=cut

sub _VerificationTicketData {
    my $CommonObject = shift;

    my $MigratedTicketCounter = 0;
    my %TicketFreeFields      = (
        freekey  => 16,
        freetext => 16,
        freetime => 6,
    );

    # create fields string and condition
    my $FreeFieldsTicket   = "";
    my $FreeFieldsTicketDB = "";
    my $TicketCondition    = "";
    for my $FreeField ( sort keys %TicketFreeFields ) {

        for my $Index ( 1 .. $TicketFreeFields{$FreeField} ) {
            $FreeFieldsTicket   .= $FreeField . $Index . ", ";
            $FreeFieldsTicketDB .= "'ticket" . $FreeField . $Index . "', ";
            $TicketCondition    .= $FreeField . $Index . " IS NOT NULL OR ";
        }
    }

    # remove unnecessary part
    $FreeFieldsTicket   = substr $FreeFieldsTicket,   0, -2;
    $FreeFieldsTicketDB = substr $FreeFieldsTicketDB, 0, -2;
    $TicketCondition    = substr $TicketCondition,    0, -3;

    # create new db connection
    my $DBConnectionObject = Kernel::System::DB->new( %{ $CommonObject->{DBObject} } );

    # get dynamic field ids and names
    my %DynamicFieldIDs;
    my $SuccessFields = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM dynamic_field ' .
            'WHERE name in (' . $FreeFieldsTicketDB . ')',

        #        Bind => [\$FreeFieldsTicket],
    );
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $DynamicFieldIDs{ $Row[1] } = $Row[0];
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
        my $SuccessDynamicField = $DBConnectionObject->Prepare(
            SQL => 'SELECT id, field_id, object_type, object_id, ' .
                'value_text, value_int, value_date ' .
                'FROM dynamic_field_value ' .
                'WHERE object_id=? and object_type= ? ' .
                'ORDER BY id',
            Bind => [ \$Row[0], \$ObjectType ],
        );

        my %DynamicFieldValue;
        while ( my @Row = $DBConnectionObject->FetchrowArray() ) {
            my $TextValue = $Row[4] || '';
            my $IntValue  = $Row[5] || '';
            my $DateValue = $Row[6] || '';
            $DynamicFieldValue{ $Row[1] . $Row[2] . $Row[3] } = $TextValue . $IntValue . $DateValue;
        }

        my $FieldCounter  = 0;
        my $SuccessTicket = 1;
        my $TicketCounter = 1;
        for my $FreeField ( sort keys %TicketFreeFields ) {

            for my $Index ( 1 .. $TicketFreeFields{$FreeField} ) {
                $FieldCounter++;
                if ( defined $Row[$FieldCounter] ) {

                    my $FieldID    = $DynamicFieldIDs{ 'ticket' . $FreeField . $Index };
                    my $FieldType  = ( $FreeField eq 'ticketfreetime' ? 'DateTime' : 'Text' );
                    my $FieldValue = $Row[$FieldCounter];
                    my $ValueType  = ( $FreeField eq 'ticketfreetime' ? 'date' : 'text' );
                    my $ObjectID   = $Row[0];
                    if (
                        $DynamicFieldValue{ $FieldID . $ObjectType . $ObjectID } ne
                        $Row[$FieldCounter]
                        )
                    {
                        print "A field was not correctly migrated: ";
                        return 0;
                    }
                }
            }
        }
    }

    return 1;
}

=item _VerificationArticleData($CommonObject)

Checks if the DynamicField tables exist, and if they don't they will be created.

    _VerificationArticleData($CommonObject);

=cut

sub _VerificationArticleData {
    my $CommonObject = shift;

    my $MigratedArticleCounter = 0;
    my %ArticleFreeFields      = (
        freekey  => 3,
        freetext => 3,
    );

    # create fields string and condition
    my $FreeFieldsArticle   = "";
    my $FreeFieldsArticleDB = "";
    my $ArticleCondition    = "";
    for my $FreeField ( sort keys %ArticleFreeFields ) {

        for my $Index ( 1 .. $ArticleFreeFields{$FreeField} ) {
            $FreeFieldsArticle   .= 'a_' . $FreeField . $Index . ", ";
            $FreeFieldsArticleDB .= "'article" . $FreeField . $Index . "', ";
            $ArticleCondition    .= 'a_' . $FreeField . $Index . " IS NOT NULL OR ";
        }
    }

    # remove unnecessary part
    $FreeFieldsArticle   = substr $FreeFieldsArticle,   0, -2;
    $FreeFieldsArticleDB = substr $FreeFieldsArticleDB, 0, -2;
    $ArticleCondition    = substr $ArticleCondition,    0, -3;

    # create new db connection
    my $DBConnectionObject = Kernel::System::DB->new( %{ $CommonObject->{DBObject} } );

    # get dynamic field ids and names
    my %DynamicFieldIDs;
    my $SuccessFields = $CommonObject->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM dynamic_field ' .
            'WHERE name in (' . $FreeFieldsArticleDB . ')',

        #        Bind => [\$FreeFieldsArticle],
    );
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $DynamicFieldIDs{ $Row[1] } = $Row[0];
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
        my $SuccessDynamicField = $DBConnectionObject->Prepare(
            SQL => 'SELECT id, field_id, object_type, object_id, ' .
                'value_text, value_int, value_date ' .
                'FROM dynamic_field_value ' .
                'WHERE object_id=? and object_type= ? ' .
                'ORDER BY id',
            Bind => [ \$Row[0], \$ObjectType ],
        );

        my %DynamicFieldValue;
        while ( my @Row = $DBConnectionObject->FetchrowArray() ) {
            my $TextValue = $Row[4] || '';
            my $IntValue  = $Row[5] || '';
            my $DateValue = $Row[6] || '';
            $DynamicFieldValue{ $Row[1] . $Row[2] . $Row[3] } = $TextValue . $IntValue . $DateValue;
        }

        my $FieldCounter   = 0;
        my $SuccessArticle = 1;
        my $ArticleCounter = 1;
        for my $FreeField ( sort keys %ArticleFreeFields ) {

            for my $Index ( 1 .. $ArticleFreeFields{$FreeField} ) {
                $FieldCounter++;
                if ( defined $Row[$FieldCounter] ) {

                    my $FieldID    = $DynamicFieldIDs{ 'article' . $FreeField . $Index };
                    my $FieldType  = ( $FreeField eq 'articlefreetime' ? 'DateTime' : 'Text' );
                    my $FieldValue = $Row[$FieldCounter] || '';
                    my $ValueType  = ( $FreeField eq 'articlefreetime' ? 'date' : 'text' );
                    my $ObjectID   = $Row[0];
                    if ( $DynamicFieldValue{ $FieldID . $ObjectType . $ObjectID } ne $FieldValue ) {
                        print "A field was not correctly migrated: "
                            . $FieldID
                            . $ObjectType
                            . $ObjectID;
                        return 0;
                    }
                }
            }
        }
    }

    return 1;
}

1;
