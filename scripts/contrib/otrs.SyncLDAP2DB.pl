#!/usr/bin/perl
# --
# bin/otrs.SyncLDAP2DB.pl - sync a ldap directory to database
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

use File::Basename;
use FindBin qw($RealBin);
use lib "$RealBin/../..";
use lib "$RealBin/../../Kernel/cpan-lib";
use lib "$RealBin/../../Custom";

use Net::LDAP;
use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.SyncLDAP2DB',
    },
);

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

my $DBCharset = 'utf-8';
my $DBTable   = 'customer_user';

# ldap connect and bind (maybe with SearchUserDN and SearchUserPw)
my $LDAP = Net::LDAP->new( $LDAPHost, %LDAPParams ) || die "$@";
if (
    !$LDAP->bind(
        dn       => $LDAPBindDN,
        password => $LDAPBindPW
    )
    )
{
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "Bind failed!",
    );
    exit 1;
}

# split request of all accounts
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
for my $Prefix ( "0" .. "9", "a" .. "z" ) {
    my $Filter = "($UidLDAP=$Prefix*)";
    if ($LDAPFilter) {
        $Filter = "(&$LDAPFilter$Filter)";
    }

    # perform user search
    my $Result = $LDAP->search(
        base   => $LDAPBaseDN,
        scope  => $LDAPScope,
        filter => $Filter,
    );

    #print "F: ($UidLDAP=$Prefix*)\n";
    for my $Entry ( $Result->all_entries() ) {
        my $UID = $Entry->get_value($UidLDAP);
        if ($UID) {

            # check if uid exists in db
            my $Insert = 1;
            $DBObject->Prepare(
                SQL   => "SELECT $UidDB FROM $DBTable WHERE $UidDB = ?",
                Bind  => [ \$UID ],
                Limit => 1,
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
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
            for ( sort keys %Map ) {
                my $Value = $DBObject->Quote(
                    _ConvertTo( $Entry->get_value( $Map{$Prefix} ) )
                );
                if ( $Type eq 'UPDATE' ) {
                    if ($SQLPre) {
                        $SQLPre .= ", ";
                    }
                    $SQLPre .= " $Prefix = '$Value'";
                }
                else {
                    if ($SQLPre) {
                        $SQLPre .= ", ";
                    }
                    $SQLPre .= "$Prefix";
                    if ($SQLPost) {
                        $SQLPost .= ", ";
                    }
                    $SQLPost .= "'$Value'";
                }
            }
            my $SQL = '';
            if ( $Type eq 'UPDATE' ) {
                print "UPDATE: $UID\n";
                $SQL =
                    "UPDATE $DBTable"
                    . " SET $SQLPre, valid_id = 1, change_time = current_timestamp, change_by = 1"
                    . " WHERE $UidDB = ?";
            }
            else {
                print "INSERT: $UID\n";
                $SQL =
                    "INSERT INTO $DBTable ($SQLPre, $UidDB, valid_id, create_time, create_by, change_time, change_by)"
                    . " VALUES ($SQLPost, ?, 1, current_timestamp, 1, current_timestamp, 1)";
            }
            $DBObject->Do(
                SQL  => $SQL,
                Bind => [ \$UID ],
            );
        }
    }
}

sub _ConvertTo {
    my $Text = shift;

    return '' if !$Text;

    return $Text if $DBCharset eq $LDAPCharset;

    return $Kernel::OM->Get('Kernel::System::Encode')->Convert(
        Text => $Text,
        To   => $DBCharset,
        From => $LDAPCharset,
    );
}
