#!/usr/bin/perl -w
# --
# bin/PostMaster.pl - the global eMail handle for email2db
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: PostMaster.pl,v 1.26 2007-09-03 10:24:48 martin Exp $
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
use lib dirname($RealBin);
use lib dirname($RealBin)."/Kernel/cpan-lib";

use strict;

# to get it readable for the webserver user and writable for otrs
# group (just in case)

umask 002;

use vars qw($VERSION);
$VERSION = '$Revision: 1.26 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::PostMaster;

# get options
my %Opts = ();
getopt('hqtd', \%Opts);
if ($Opts{'h'}) {
    print "PostMaster.pl <Revision $VERSION> - OTRS cmd postmaster\n";
    print "Copyright (c) 2001-2006 OTRS GmbH, http://otrs.org/\n";
    print "usage: PostMaster.pl -q <QUEUE> -t <TRUSTED> (default is trusted, use '-t 0' to disable trusted mode)\n";
    exit 1;
}
if (!$Opts{'d'}) {
    $Opts{'d'} = 0;
}
if (! defined($Opts{'t'})) {
    $Opts{'t'} = 1;
}
if (!$Opts{'q'}) {
    $Opts{'q'} = '';
}

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-PM',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(
    %CommonObject,
);
# Wrap the majority of the script in an "eval" block so that any
# unexpected (but probably transient) fatal errors (such as the
# database being unavailable) can be trapped without causing a
# bounce
eval {
    # create needed objects
    $CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
    # debug info
    if ($Opts{'d'}) {
        $CommonObject{LogObject}->Log(
            Priority => 'debug',
            Message => 'Global OTRS email handle (PostMaster.pl) started...',
        );
    }
    # get email from SDTIN
    my @Email = <STDIN>;
    if (!@Email) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message => 'Got not email on STDIN!',
        );
        exit (1);
    }
    # common objects
    $CommonObject{PostMaster} = Kernel::System::PostMaster->new(
        %CommonObject,
        Email => \@Email,
        Trusted => $Opts{'t'},
        Debug => $Opts{'d'},
    );
    my @Return = $CommonObject{PostMaster}->Run(Queue => $Opts{'q'});
    if (!$Return[0]) {
        die "Can't process mail, see log sub system!";
    }

    # debug info
    if ($Opts{'d'}) {
        $CommonObject{LogObject}->Log(
            Priority => 'debug',
            Message => 'Global OTRS email handle (PostMaster.pl) stoped.',
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
        Message => $@,
    );
    exit 75;
}

exit (0);
