#!/usr/bin/perl -w
# --
# bin/otrs.XMLMaster.pl - the global xml handle for xml2db
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: otrs.XMLMaster.pl,v 1.3 2010-08-06 17:49:20 cr Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::XMLMaster;

# get options
my %Opts = ();
getopt( 'hqtd', \%Opts );
if ( $Opts{'h'} ) {
    print "XMLMaster.pl <Revision $VERSION> - OTRS xml master\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print "usage: XMLMaster.pl [-d 1] \n";
    exit 1;
}
if ( !$Opts{d} ) {
    $Opts{d} = 0;
}

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.XMLMaster.pl',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);

# Wrap the majority of the script in an "eval" block so that any
# unexpected (but probably transient) fatal errors (such as the
# database being unavailable) can be trapped without causing a
# bounce
eval {

    # create needed objects
    $CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);

    # debug info
    if ( $Opts{d} ) {
        $CommonObject{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Global OTRS xml handle (XMLMaster.pl) started...',
        );
    }

    # get email from SDTIN
    my @XML    = <STDIN>;
    my $String = '';
    for (@XML) {
        $String .= $_;
    }
    if ( !@XML ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got not xml on STDIN!',
        );
        exit 1;
    }

    # common objects
    $CommonObject{XMLMaster} = Kernel::System::XMLMaster->new(
        %CommonObject,
        Debug => $Opts{d},
    );
    $CommonObject{XMLMaster}->Run( XML => \$String, );

    # debug info
    if ( $Opts{d} ) {
        $CommonObject{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Global OTRS xml handle (XMLMaster.pl) stopped.',
        );
    }
};

if ($@) {

    # An unexpected problem occurred (for example, the database was
    # unavailable). Return an EX_TEMPFAIL error to cause the mail
    # program to requeue the message instead of immediately bouncing
    # it; see sysexits.h. Most mail programs will retry an
    # EX_TEMPFAIL delivery for about four days, then bounce the
    # message.)
    $CommonObject{LogObject}->Log(
        Priority => 'error',
        Message  => $@,
    );
    exit 75;
}

exit 0;
