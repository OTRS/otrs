#!/usr/bin/perl -w
# --
# PostMaster.pl - the global eMail handle for email2db
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PostMaster.pl,v 1.11 2003-01-23 22:50:08 martin Exp $
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

# --
# to get it readable for the webserver user and writable for otrs 
# group (just in case)
# --
umask 002;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

my $Debug = 1;

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::PostMaster;

# --
# create common objects 
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-PM',
    %CommonObject,
);
# debug info
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug',
        Message => 'Global OTRS email handle (PostMaster.pl) started...',
    );
}
# ... common objects ...
my @Email = <STDIN>;
$CommonObject{PostMaster} = Kernel::System::PostMaster->new(%CommonObject, Email => \@Email);
$CommonObject{PostMaster}->Run();

# debug info
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug',
        Message => 'Global OTRS email handle (PostMaster.pl) stoped.',
    );
}
# --
exit (0);
