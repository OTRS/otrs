#! /usr/bin/perl -w
# --
# pic.pl - the global pic handle for OpenTRS
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: pic.pl,v 1.2 2002-05-05 15:56:42 martin Exp $
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

use strict;

use vars qw($VERSION $Debug);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
# all OpenTRS modules
# --
use Kernel::Config;
use Kernel::System::Syslog;
use Kernel::System::WebRequest;
use Kernel::System::DB;
use Kernel::System::AuthSession;
use Kernel::System::User;
use Kernel::System::Queue;
use Kernel::System::Ticket;
use Kernel::System::Permission;

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
        MSG => 'Global OpenTRS-PIC handle started...',
    );
}
# ... common objects ...
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{ParamObject} = Kernel::System::WebRequest->new();
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{SessionObject} = Kernel::System::AuthSession->new(%CommonObject);
$CommonObject{QueueObject} = Kernel::System::Queue->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);
$CommonObject{PermissionObject} = Kernel::System::Permission->new(%CommonObject);

# --
# get common parameters
# --
my %Param = ();
$Param{SessionID} = $CommonObject{ParamObject}->GetParam(Param => 'SessionID') || '';
$Param{Action} = $CommonObject{ParamObject}->GetParam(Param => 'Action') || '';
$Param{Pic} = $CommonObject{ParamObject}->GetParam(Param => 'Pic') || '';

# --
# check session id
# --
if ( !$Param{SessionID} || 
     !$CommonObject{SessionObject}->CheckSessionID(SessionID => $Param{SessionID}) ) {
  $CommonObject{LogObject}->Log(
    Message => 'Wrong SessionID!',
    Priority => 'info',
  );

  my $Pic = GetImage('help.gif');
  print <<EOF
Content-Type: image/gif

$Pic

EOF
}
# --
# run 
# --
else { 
  # get session data
  my %Data = $CommonObject{SessionObject}->GetSessionIDData(
    SessionID => $Param{SessionID}
  );

  # permission check
  if ($Param{Action} eq 'SystemStats' && 
      !$CommonObject{PermissionObject}->Section(UserID => $Data{UserID}, Section => 'Stats')) {

    $CommonObject{LogObject}->Log(
      Message => 'No permission!',
      Priority => 'info',
    );

    my $Pic = GetImage('help.gif');
    print <<EOF
Content-Type: image/gif

$Pic

EOF
  }
  else {
    my $Pic = '';
    if ($Param{Action} eq 'SystemStats') {
      $Pic = GetImage($Param{Pic}, 'SystemStats') || GetImage('help.gif');
    }
    else {
      $Pic = GetImage($Param{Pic}) || GetImage('help.gif');
    }
    print <<EOF
Content-Type: image

$Pic

EOF
  }
}
# --
# debug info
# --
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug',
        MSG => 'Global OpenTRS-PIC handle stopped.',
    );
}

# --
# get image 
# --
sub GetImage {
    my $File = shift || 'help.gif';
    my $Type = shift || '';
    $File =~ s/(\.\.\/||^\/)//g;
    my $Data = '';
    my $HtdocsPath = '';
    if ($Type eq 'SystemStats') {
      $HtdocsPath = $CommonObject{ConfigObject}->Get('StatsPicDir') 
       || '../../var/pics/stats';
    }
    else {
      $HtdocsPath = $CommonObject{ConfigObject}->Get('HtdocsPath') 
       || '../../var/pics/images/';
    }

    if ($Debug) {
      $CommonObject{LogObject}->Log(
        Priority => 'debug',
        MSG => "Open image $HtdocsPath/$File.",
      );
    }

    open (DATA, "< $HtdocsPath/$File") or print STDERR "$! \n";
    while (<DATA>) {
        $Data .= $_;
    }
    close (DATA);
    return $Data;
}
# --

