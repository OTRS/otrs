#!/usr/bin/perl -w
# --
# scripts/tools/convert_db_to_utf8.pl - convert a database into utf-8 strings
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: convert_db_to_utf8.pl,v 1.3 2007-09-29 11:10:33 mh Exp $
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
$VERSION = qw($Revision: 1.3 $) [1];

use Encode;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;

# --
# create common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-DB2utf8',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);

# set select handle to non utf-8 connect
$CommonObject{DBObject1} = Kernel::System::DB->new( %CommonObject, 'Connect' => '', Encode => 0 );

# set select handle to utf-8 connect
$CommonObject{DBObject2} = Kernel::System::DB->new(%CommonObject);

# get all articles and convert to utf8
my $SQL
    = "SELECT id, a_content_type, a_from, a_to, a_cc, a_subject, a_body FROM article ORDER BY id";

$CommonObject{DBObject1}->Prepare( SQL => $SQL );
while ( my @Row = $CommonObject{DBObject1}->FetchrowArray() ) {
    if ( $Row[1] && $Row[1] =~ /.+?charset=(.*)/i ) {
        my $Charset = $1;
        $Charset =~ s/"|'//g;
        $Charset =~ s/(.+?);.*/$1/g;
        $Charset =~ s/(.+?);/$1/g;
        my $Convert = 1;
        print "NOTICE: article_id $Row[0] (Charset: $Charset)\n";
        if ( $Charset !~ /(utf-8|utf8|us-ascii)/i ) {
            for ( 2 .. 6 ) {

                # convert
                Encode::from_to( $Row[$_], $Charset, 'utf-8' );
            }
            $Row[1] =~ s/\Q$Charset\E/utf-8/gi;
            $Convert = 1;
        }
        else {
            for ( 2 .. 6 ) {

                # convert
                Encode::_utf8_on( $Row[$_] );
            }

            # use this if you worked with OTRS 2.1 or lower
            $Convert = 1;

            #            $Convert = 0;
        }
        if ($Convert) {
            print STDERR "NOTICE: convert article_id $Row[0] ($Charset -> utf-8) ...";
            my $SQL
                = "UPDATE article SET "
                . " a_content_type = ?, a_from = ?, a_to = ?, a_cc = ?, a_subject = ?, a_body = ? "
                . " WHERE id = $Row[0]";
            if ($CommonObject{DBObject2}->Do(
                    SQL  => $SQL,
                    Bind => [ \$Row[1], \$Row[2], \$Row[3], \$Row[4], \$Row[5], \$Row[6] ]
                )
                )
            {
                print STDERR " done.\n";
            }
            else {
                print STDERR " failed!\n";
            }
        }
    }
}
