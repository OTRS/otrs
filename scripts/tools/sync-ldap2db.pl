#!/usr/bin/perl -w
# --
# scripts/tools/sync-ldap2db.pl - sync a ldap directory to database
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: sync-ldap2db.pl,v 1.7 2008-04-24 17:32:15 tr Exp $
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin) . "/../";
use lib dirname($RealBin) . "/../Kernel/cpan-lib";

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

use Net::LDAP;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Encode;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-sync-ldap2db',
    %CommonObject,
);
$CommonObject{MainObject}   = Kernel::System::Main  ->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB    ->new(%CommonObject);

my $UidLDAP = 'uid';
my $UidDB   = 'login';

my %Map = (

    # db => ldap
    email       => 'mail',
    customer_id => 'mail',
    first_name  => 'sn',
    last_name   => 'givenname',
    pw          => 'test',

    #    comments => 'description',
    comments => 'postaladdress',
);

my $LDAPHost    = 'bay.csuhayward.edu';
my %LDAPParams  = ();
my $LDAPBaseDN  = 'ou=seas,o=csuh';
my $LDAPBindDN  = '';
my $LDAPBindPW  = '';
my $LDAPScope   = 'sub';
my $LDAPCharset = 'utf-8';

#my $LDAPFilter = '';
my $LDAPFilter = '(ObjectClass=*)';

my $DBCharset = 'iso-8859-1';
my $DBTable   = 'customer_user';

# ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
my $LDAP = Net::LDAP->new( $LDAPHost, %LDAPParams ) or die "$@";
if ( !$LDAP->bind( dn => $LDAPBindDN, password => $LDAPBindPW ) ) {
    $CommonObject{LogObject}->Log(
        Priority => 'error',
        Message  => "Bind failed!",
    );
    exit 1;
}

# split request of all accounts
for (qw(0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z)) {
    my $Filter = "($UidLDAP=$_*)";
    if ($LDAPFilter) {
        $Filter = "(&$LDAPFilter$Filter)";
    }

    # perform user search
    my $Result = $LDAP->search(
        base   => $LDAPBaseDN,
        scope  => $LDAPScope,
        filter => $Filter,
    );

    #print "F: ($UidLDAP=$_*)\n";
    for my $entry ( $Result->all_entries ) {
        my $UID = $entry->get_value($UidLDAP);
        if ($UID) {

            # check if uid existsis in db
            my $Insert = 1;
            $CommonObject{DBObject}->Prepare(
                SQL => "SELECT $UidDB FROM $DBTable WHERE $UidDB = '"
                    . $CommonObject{DBObject}->Quote($UID) . "'",
                Limit => 1,
            );
            while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
                $Insert = 0;
            }
            my $SQLPre  = '';
            my $SQLPost = '';
            my $Type    = '';
            if ($Insert) {
                $Type = 'INSERT';
            }
            else {
                $Type = 'UPDATE';
            }
            for ( keys %Map ) {
                my $Value = $CommonObject{DBObject}
                    ->Quote( _ConvertTo( $entry->get_value( $Map{$_} ) ) || '' );
                if ( $Type eq 'UPDATE' ) {
                    if ($SQLPre) {
                        $SQLPre .= ", ";
                    }
                    $SQLPre .= " $_ = '$Value'";
                }
                else {
                    if ($SQLPre) {
                        $SQLPre .= ", ";
                    }
                    $SQLPre .= "$_";
                    if ($SQLPost) {
                        $SQLPost .= ", ";
                    }
                    $SQLPost .= "'$Value'";
                }
            }
            my $SQL = '';
            if ( $Type eq 'UPDATE' ) {
                print "UPDATE: $UID\n";
                $SQL
                    = "UPDATE $DBTable SET $SQLPre, valid_id = 1, change_time = current_timestamp, change_by = 1 ";
                $SQL .= " WHERE $UidDB = '" . $CommonObject{DBObject}->Quote($UID) . "'";
            }
            else {
                print "INSERT: $UID\n";
                $SQL
                    = "INSERT INTO $DBTable ($SQLPre, $UidDB, valid_id, create_time, create_by, change_time, change_by) VALUES ($SQLPost, '"
                    . $CommonObject{DBObject}->Quote($UID)
                    . "', 1, current_timestamp, 1, current_timestamp, 1)";
            }
            $CommonObject{DBObject}->Do( SQL => $SQL );
        }
    }
}

sub _ConvertTo {
    my ($Text) = @_;

    return if !defined $Text;

    return $CommonObject{EncodeObject}->Convert(
        Text => $Text,
        To   => $DBCharset,
        From => $LDAPCharset,
    );
}
