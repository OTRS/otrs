#! /usr/bin/perl -w
# --
# index.pl - the global CGI handle file for OpenTRS
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: index.pl,v 1.5 2001-12-16 01:43:43 martin Exp $
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

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

my $Debug = 0;

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
use Kernel::Modules::AgentQueueView;
use Kernel::Output::HTML::Generic;

# --
# create common objects 
# --
my %CommonObject = ();
$CommonObject{LogObject} = Kernel::System::Syslog->new();
# debug info
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug', 
        MSG => 'Global OpenTRS handle started...',
    );
}
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
$Param{SessionID} = $CommonObject{ParamObject}->GetParam(Param => 'SessionID') || '';
$Param{Action} = $CommonObject{ParamObject}->GetParam(Param => 'Action') || 'AgentQueueView';

# --
# check request type
# --
if ($Param{Action} eq "Login") {
    # get params
    my $User = $CommonObject{ParamObject}->GetParam(Param => 'User') || '';
    my $Pw = $CommonObject{ParamObject}->GetParam(Param => 'Password') || '';

    # create AuthObject
    my $AuthObject = Kernel::System::Auth->new(%CommonObject);

    # check submited data
    if ( $AuthObject->Auth(User => $User, Pw => $Pw) ) {
        my %Data = $AuthObject->GetUserData(User => $User);
        my $NewSessionID = $CommonObject{SessionObject}->CreateSessionID(%Data);
        my $LayoutObject = Kernel::Output::HTML::Generic->new(SessionID => $NewSessionID, %CommonObject);
        print $LayoutObject->Redirect();
    }
    # login is vailid
    else {
        print $CommonObject{LayoutObject}->Header();
        print $CommonObject{LayoutObject}->Login(Message => 'Login invalid!!!');
        print $CommonObject{LayoutObject}->Footer();
    }
}
# --
# Logout
# --
elsif ($Param{Action} eq "Logout"){
    print $CommonObject{LayoutObject}->Header();
    if ( $CommonObject{SessionObject}->RemoveSessionID(SessionID => $Param{SessionID}) ) {
        print $CommonObject{LayoutObject}->Login(
            Message => 'Logout successful. Thank you for useing OpenTRS!',
        );
        $CommonObject{LogObject}->Log(MSG => "Removed SessionID $Param{SessionID}.");
    }
    else {
        print $CommonObject{LayoutObject}->Error(
            MSG => 'Can`t remove SessionID',
            Comment => 'Please contact your admin'
        );
        $CommonObject{LogObject}->ErrorLog(
            MSG => 'Can`t remove SessionID',
            Comment => 'Please contact your admin'
        );
    }
    print $CommonObject{LayoutObject}->Footer();
}

# --
# show test site
# --
elsif ($Param{Action} eq "Test"){
    GenericModules(%CommonObject, %Param);
}
# --
# show login site
# --
elsif (!$Param{SessionID}) {
    print $CommonObject{LayoutObject}->Header();
    print $CommonObject{LayoutObject}->Login();
    print $CommonObject{LayoutObject}->Footer();
}
# --
#
# --
elsif ($Param{Action} eq "AgentQueueView"){
    $CommonObject{LayoutObject} = Kernel::Output::HTML::Generic->new(%CommonObject, %Param);
    GenericModules(%CommonObject, %Param);
}
else { 
    print $CommonObject{LayoutObject}->Header();
    print $CommonObject{LayoutObject}->Error(
       Message => "Action '$Param{Action}' not found!",
       Comment => "Contact your admin!",
       );
    print $CommonObject{LayoutObject}->Footer();
}


# debug info
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug',
        MSG => 'Global OpenTRS handle stopped.',
    );
}

# --
# generic funktion
# --
sub GenericModules {
    my %Data = @_;

    # debug info
    if ($Debug) {
        $Data{LogObject}->Log(
            Priority => 'debug',
            MSG => 'Kernel::Modules::' . $Data{Action} .'->new',
        );
    }

    # --
    # prove of concept! - create $GenericObject
    # --
    my $GenericObject = ('Kernel::Modules::' . $Data{Action})->new (%Data);

    # --
    # ->Run $Action with $GenericObject
    # --
    print $GenericObject->Run();

    # debug info
    if ($Debug) {
        $Data{LogObject}->Log(
            Priority => 'debug', 
            MSG => ''. 'Kernel::Modules::' . $Data{Action} .'->run',
        );
    }

}



