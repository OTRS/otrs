#! /usr/bin/perl -w
# --
# index.pl - global handle file for OpenTRS
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# 
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
#
# --
# $Id: index.pl,v 1.1 2001-12-02 14:37:13 martin Exp $
# --

use lib '/opt/OpenTRS/';
use strict;

#use Apache ();
#use Apache::DBI ();
#Apache::DBI->connect_on_init('DBI:mysql:OpenTRS', 'root');

# --
# all OpenTRS modules
# --
use Kernel::Config;
use Kernel::System::Syslog;
use Kernel::System::WebRequest;

# --
# create common objects 
# --
my $LogObject = Kernel::System::Syslog->new();
# debug info
$LogObject->Log(Priority=>'debug', MSG=>'Gloable OpenTRS handle started...');

my $ConfigObject = Kernel::Config->new(LogObject=>$LogObject);
my $WebObject = Kernel::System::WebRequest->new();




