#! /usr/bin/perl -w
# --
# index.pl - the global CGI handle file (incl. auth) for OpenTRS
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: index.pl,v 1.28 2002-05-18 09:57:16 martin Exp $
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
use lib '../..';
#use lib '/opt/OpenTRS/';

use strict;

use vars qw($VERSION $Debug);
$VERSION = '$Revision: 1.28 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

$Debug = 0;

# --
# all OpenTRS modules
# --
use Kernel::Config;
use Kernel::System::Syslog;
use Kernel::System::WebRequest;
use Kernel::System::DB;
use Kernel::System::Auth;
use Kernel::System::AuthSession;
use Kernel::System::User;
use Kernel::System::Queue;
use Kernel::System::Ticket;
use Kernel::System::Article;
use Kernel::System::Permission;
use Kernel::Modules::Test;
use Kernel::Modules::AgentQueueView;
use Kernel::Modules::AgentMove;
use Kernel::Modules::AgentZoom;
use Kernel::Modules::AgentAttachment;
use Kernel::Modules::AgentPlain;
use Kernel::Modules::AgentNote;
use Kernel::Modules::AgentLock;
use Kernel::Modules::AgentPriority;
use Kernel::Modules::AgentClose;
use Kernel::Modules::AgentUtilities;
use Kernel::Modules::AgentCompose;
use Kernel::Modules::AgentForward;
use Kernel::Modules::AgentPreferences;
use Kernel::Modules::AgentMailbox;
use Kernel::Modules::AgentOwner;
use Kernel::Modules::AgentHistory;
use Kernel::Modules::AgentPhone;
use Kernel::Modules::Admin;
use Kernel::Modules::AdminSession;
use Kernel::Modules::AdminSelectBox;
use Kernel::Modules::AdminResponse;
use Kernel::Modules::AdminQueueResponses;
use Kernel::Modules::AdminQueue;
use Kernel::Modules::AdminAutoResponse;
use Kernel::Modules::AdminQueueAutoResponse;
use Kernel::Modules::AdminSalutation;
use Kernel::Modules::AdminSignature;
use Kernel::Modules::AdminUser;
use Kernel::Modules::AdminGroup;
use Kernel::Modules::AdminUserGroup;
use Kernel::Modules::AdminSystemAddress;
use Kernel::Modules::AdminCharset;
use Kernel::Modules::AdminLanguage;
use Kernel::Modules::SystemStats;
use Kernel::Modules::AdminState;
use Kernel::Output::HTML::Generic;

# --
# create common objects 
# --
my %CommonObject = ();
$CommonObject{LogObject} = Kernel::System::Syslog->new();
# --
# debug info
# --
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug', 
        MSG => 'Global OpenTRS handle started...',
    );
}
# --
# ... common objects ...
# --
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{ParamObject} = Kernel::System::WebRequest->new();
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{LayoutObject} = Kernel::Output::HTML::Generic->new(%CommonObject);
# --
# check common db objects
# --
if (!$CommonObject{DBObject}) {
    print $CommonObject{LayoutObject}->Header(Title => 'Logout');
    print $CommonObject{LayoutObject}->Error(
        Message => "Can't connect to database!",
        Comment => 'Please contact your admin'
    );
    $CommonObject{LogObject}->Log(
        Message => "Can't connect to database!",
        Priority => 'error',
    );
    print $CommonObject{LayoutObject}->Footer();
    exit (1);
}
# --
# ... common objects ...
# --
$CommonObject{SessionObject} = Kernel::System::AuthSession->new(%CommonObject);
$CommonObject{QueueObject} = Kernel::System::Queue->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);
$CommonObject{ArticleObject} = Kernel::System::Article->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);
$CommonObject{PermissionObject} = Kernel::System::Permission->new(%CommonObject);

# --
# get common parameters
# --
my %Param = ();
$Param{SessionID} = $CommonObject{ParamObject}->GetParam(Param => 'SessionID') || '';
$Param{Action} = $CommonObject{ParamObject}->GetParam(Param => 'Action') || 'AgentQueueView';
$Param{Subaction} = $CommonObject{ParamObject}->GetParam(Param => 'Subaction') || '';
$Param{QueueID} = $CommonObject{ParamObject}->GetParam(Param => 'QueueID') || 0;
$Param{TicketID} = $CommonObject{ParamObject}->GetParam(Param => 'TicketID') || '';
$Param{NextScreen} = $CommonObject{ParamObject}->GetParam(Param => 'NextScreen') || '';
$Param{RequestedURL} = $CommonObject{ParamObject}->GetParam(Param => 'RequestedURL') || $ENV{"QUERY_STRING"};

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
                Comment => 'Please contact your admin'
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
        my $GenericObject = ('Kernel::Modules::'.$Param{Action})->new(%CommonObject,%Param,%Data);

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
        Comment => "Contact your admin!",
       );
    print $CommonObject{LayoutObject}->Footer();
}

# --
# debug info
# --
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug',
        MSG => 'Global OpenTRS handle stopped.',
    );
}

# --

