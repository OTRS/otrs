#! /usr/bin/perl -w
# --
# index.pl - the global CGI handle file (incl. auth) for OpenTRS
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: index.pl,v 1.29 2002-06-08 20:41:49 martin Exp $
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
use lib '../..';

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.29 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
# 0=off;1=on;
# --
my $Debug = 0;

# --
# all framework needed  modules 
# (if you use mod_perl with startup.pl, drop this "use Kernel::.." and add
# this to your startup.pl) 
# --
use Kernel::Config;
use Kernel::Config::Modules;
use Kernel::System::Log;
use Kernel::System::WebRequest;
use Kernel::System::DB;
use Kernel::System::Auth;
use Kernel::System::AuthSession;
use Kernel::System::User;
use Kernel::System::Permission;
use Kernel::Output::HTML::Generic;

# --
# create common framework objects 1/3
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => $CommonObject{ConfigObject}->Get('CGILogPrefix'),
);
# --
# debug info
# --
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug', 
        MSG => 'Global handle started...',
    );
}
# --
# create common framework objects 2/3
# --
$CommonObject{ParamObject} = Kernel::System::WebRequest->new();
$CommonObject{LayoutObject} = Kernel::Output::HTML::Generic->new(%CommonObject);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
# --
# check common db objects
# --
if (!$CommonObject{DBObject}) {
    print $CommonObject{LayoutObject}->Header(Title => 'Logout');
    print $CommonObject{LayoutObject}->Error(
        Message => $DBI::errstr,
        Comment => 'Please contact your admin'
    );
    print $CommonObject{LayoutObject}->Footer();
    exit (1);
}
# --
# create common framework objects 3/3
# --
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);
$CommonObject{PermissionObject} = Kernel::System::Permission->new(%CommonObject);
$CommonObject{SessionObject} = Kernel::System::AuthSession->new(%CommonObject);
# --
# application and add on application common objects
# --
foreach ('$Kernel::Config::Modules::CommonObject', '$Kernel::Config::ModulesCustom::CommonObject') {
  my $ModuleCommonObject = eval $_;
  foreach my $Key (keys %{$ModuleCommonObject}) {
    # create
    $CommonObject{$Key} = $ModuleCommonObject->{$Key}->new(%CommonObject);
  }
}


# --
# get common framework params
# --
my %Param = ();
my $FramworkPrams = {
    SessionID => '',
    Action => '',
    Subaction => '',
    NextScreen => '',
    RequestedURL => $ENV{"QUERY_STRING"},
};
foreach my $Key (keys %{$FramworkPrams}) {
    $Param{$Key} = $CommonObject{ParamObject}->GetParam(Param => $Key) 
      || $FramworkPrams->{$Key};
}
# --
# get common application and add on application params
# --
foreach ('$Kernel::Config::Modules::Param', '$Kernel::Config::ModulesCustom::Param') {
  my $Param = eval $_;
  foreach my $Key (keys %{$Param}) {
    $Param{$Key} = $CommonObject{ParamObject}->GetParam(Param => $Key) 
      || $Param->{$Key};
  }
}


# --
# check request type
# --
if ($Param{Action} eq "Login") {
    # get params
    my $User = $CommonObject{ParamObject}->GetParam(Param => 'User') || '';
    my $Pw = $CommonObject{ParamObject}->GetParam(Param => 'Password') || '';
    # create AuthObject
    my $AuthObject = Kernel::System::Auth->new(%CommonObject);

    # --
    # check submited data
    # --
    if ( $AuthObject->Auth(User => $User, Pw => $Pw) ) {
        # get user data
        my %Data = $CommonObject{UserObject}->GetUserData(User => $User);
        # check needed data
        if (!$Data{UserID} || !$Data{UserLogin}) {
            print $CommonObject{LayoutObject}->Login(
                Message => 'Panic! No UserData!!!',
                %Param,
            );
            exit (0);
        }
        # create new session id
        my $NewSessionID = $CommonObject{SessionObject}->CreateSessionID(%Data);
        my $LayoutObject = Kernel::Output::HTML::Generic->new(
          SessionID => $NewSessionID, 
          %CommonObject,
        );

        # --
        # redirect with new session id and old params
        # --
        # prepare old redirect URL -- do not redirect to Login or Logout (loop)!
        if ($Param{RequestedURL} =~ /Action=(Logout|Login)/) {
            $Param{RequestedURL} = '';
        }
        elsif ($Param{RequestedURL} =~ /SessionID=/) {
            # drop old session id
            $Param{RequestedURL} =~ s/SessionID(=&|=.+?&|=.+?$)/&/g; 
        }
        else {
            # no session id
            $Param{RequestedURL} = '&'.$Param{RequestedURL};
        }
        # redirect with new session id
        print $LayoutObject->Redirect(OP => $Param{RequestedURL});
    }
    # --
    # login is vailid
    # --
    else {
        print $CommonObject{LayoutObject}->Login(
          Title => 'Login',          
          Message => 'Login failed! Your username or password was entered incorrectly.',
          User => $User,
          %Param,
        );
    }
}
# --
# Logout
# --
elsif ($Param{Action} eq "Logout"){
    if ( $CommonObject{SessionObject}->CheckSessionID(SessionID => $Param{SessionID}) ) {
        if ( $CommonObject{SessionObject}->RemoveSessionID(SessionID => $Param{SessionID}) ) {
            print $CommonObject{LayoutObject}->Login(
                Title => 'Logout',
                Message => 'Logout successful. Thank you for using OpenTRS!',
                %Param,
            );
        }  
        else {
            print $CommonObject{LayoutObject}->Header(Title => 'Logout');
            print $CommonObject{LayoutObject}->Error(
                Message => 'Can`t remove SessionID',
                Comment => 'Please contact your admin!'
            );
            $CommonObject{LogObject}->Log(
                Message => 'Can`t remove SessionID',
                Priority => 'error',
            );
            print $CommonObject{LayoutObject}->Footer();
        }
    }
    else {
        print $CommonObject{LayoutObject}->Login(
            Title => 'Logout',
            Message => 'Invalid SessionID!',
            %Param,
        );
    }
}
# --
# show login site
# --
elsif (!$Param{SessionID}) {
    print $CommonObject{LayoutObject}->Login(
        Title => 'Login',
        %Param,
    );
}
# --
# run modules if exists a version value
# --
elsif (eval '$Kernel::Modules::'. $Param{Action} .'::VERSION'){
    # check session id
    if ( !$CommonObject{SessionObject}->CheckSessionID(SessionID => $Param{SessionID}) ) {
        print $CommonObject{LayoutObject}->Login(
          Title => 'Login',
          Message => $Kernel::System::AuthSession::CheckSessionID,
          %Param,
       );
    }
    # --
    # run module
    # --
    else { 
        # --
        # get session data
        # --
        my %Data = $CommonObject{SessionObject}->GetSessionIDData(
          SessionID => $Param{SessionID},
        );
        # --
        # create new LayoutObject with new '%Param' and '%Data'
        # --
        $CommonObject{LayoutObject} = Kernel::Output::HTML::Generic->new(
          %CommonObject, 
          %Param, 
          %Data,
        );

        # debug info
        if ($Debug) {
            $CommonObject{LogObject}->Log(
                Priority => 'debug',
                MSG => 'Kernel::Modules::' . $Param{Action} .'->new',
            );
        }
        # --
        # prove of concept! - create $GenericObject
        # --
        my $GenericObject = ('Kernel::Modules::'.$Param{Action})->new(
            %CommonObject,
            %Param,
            %Data,
        );

        # debug info
        if ($Debug) {
            $CommonObject{LogObject}->Log(
                Priority => 'debug',
                MSG => ''. 'Kernel::Modules::' . $Param{Action} .'->run',
            );
        }
        # --
        # ->Run $Action with $GenericObject
        # --
        print $GenericObject->Run();

    }
}
# --
# else print an error screen
# --
else { 
    # create new LayoutObject with '%Param'
    my %Data = $CommonObject{SessionObject}->GetSessionIDData(
        SessionID => $Param{SessionID},
    );
    $CommonObject{LayoutObject} = Kernel::Output::HTML::Generic->new(
      %CommonObject, 
      %Param, 
      %Data,
    );
    print $CommonObject{LayoutObject}->Header(Title => 'Error');
    print $CommonObject{LayoutObject}->Error(
        Message => "Action '$Param{Action}' not found!",
        Comment => "Perhaps the admin forgot to load \"Kernel::Modules::$Param{Action}\"!",
       );
    print $CommonObject{LayoutObject}->Footer();
}

# --
# debug info
# --
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug',
        MSG => 'Global handle stopped.',
    );
}

# --

