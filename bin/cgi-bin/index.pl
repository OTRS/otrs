#! /usr/bin/perl -w
# --
# index.pl - the global CGI handle file for OpenTRS
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: index.pl,v 1.4 2001-12-10 14:22:55 martin Exp $
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

# OpenTRS root directory
use lib '/opt/OpenTRS/';
# only for testing
use lib '/home/martin/src/otrs/';
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
use Kernel::System::DB;
use Kernel::System::Auth;
use Kernel::System::AuthSession;
use Kernel::Modules::Test;
use Kernel::Output::HTML::Generic;

# --
# create common objects 
# --
my %CommonObject = ();
$CommonObject{LogObject} = Kernel::System::Syslog->new();
# debug info
$CommonObject{LogObject}->Log(
    Priority => 'debug', 
    MSG => 'Global OpenTRS handle started...',
);
# ... common objects ...
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{ParamObject} = Kernel::System::WebRequest->new();
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{SessionObject} = Kernel::System::AuthSession->new(%CommonObject);
$CommonObject{LayoutObject} = Kernel::Output::HTML::Generic->new(%CommonObject);

### for later
$CommonObject{AuthObject} = Kernel::System::Auth->new(%CommonObject);

# --
# get common parameters
# --
my %Param = ();
$Param{SessionID} = $CommonObject{ParamObject}->GetParam(Param => 'SessionID') || 'empty';
$Param{Action} = $CommonObject{ParamObject}->GetParam(Param => 'Action') || 'Test';


# --
# prove of concept - create $GenericObject
# --
my $GenericObject = ('Kernel::Modules::' . $Param{Action})->new (%CommonObject, %Param);
# debug info
$CommonObject{LogObject}->Log(
    Priority => 'debug', 
    MSG => 'Kernel::Modules::' . $Param{Action} .'->new',
);

# --
# ->Run $Action with $GenericObject
# --
print $GenericObject->Run();
$CommonObject{LogObject}->Log(
    Priority => 'debug', 
    MSG => ''. 'Kernel::Modules::' . $Param{Action} .'->run',
);



# debug info
$CommonObject{LogObject}->Log(
    Priority => 'debug', 
    MSG => 'Global OpenTRS handle stopped.',
);

