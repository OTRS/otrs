#! /usr/bin/perl -w
# --
# pic.pl - the global pic handle for OTRS
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: pic.pl,v 1.7 2002-10-15 09:15:41 martin Exp $
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

use vars qw($VERSION $Debug);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
# all OTRS modules
# --
use Kernel::Config;
use Kernel::System::Log;
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
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-Pic',
    %CommonObject,
);
# --
# debug info
# --
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug', 
        MSG => 'Global OTRS-PIC handle started...',
    );
}
# ... common objects ...
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
# get session id
my $SessionID = $CommonObject{ConfigObject}->Get('SessionName') || 'SessionID';
$Param{SessionID} = $CommonObject{ParamObject}->GetParam(Param => $SessionID) || '';
$Param{Action} = $CommonObject{ParamObject}->GetParam(Param => 'Action') || '';
$Param{Pic} = $CommonObject{ParamObject}->GetParam(Param => 'Pic') || '';
# --
# Check if the brwoser sends the SessionID cookie and set the SessionID-cookie 
# as SessionID! GET or POST SessionID have the lowest priority.
# --
if ($CommonObject{ConfigObject}->Get('SessionUseCookie')) {
  $Param{SessionIDCookie} = $CommonObject{ParamObject}->GetCookie(Key => $SessionID);
  if ($Param{SessionIDCookie}) {
    $Param{SessionID} = $Param{SessionIDCookie};
  }
}
# --
# check session id
# --
if ( !$Param{SessionID} || 
     !$CommonObject{SessionObject}->CheckSessionID(SessionID => $Param{SessionID}) ) {
  $CommonObject{LogObject}->Log(
    Message => 'Wrong SessionID!',
    Priority => 'info',
  );

  my $Pic = GetImage('help.gif', '', \%CommonObject);
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

    my $Pic = GetImage('help.gif', '', \%CommonObject);
    print <<EOF
Content-Type: image/gif

$Pic

EOF
  }
  else {
    my $Pic = '';
    if ($Param{Action} eq 'SystemStats') {
      $Pic = GetImage($Param{Pic}, 'SystemStats', \%CommonObject) 
       || GetImage('help.gif', '', \%CommonObject);
    }
    else {
      $Pic = GetImage($Param{Pic}, '', \%CommonObject) 
       || GetImage('help.gif', '', \%CommonObject);
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
        MSG => 'Global OTRS-PIC handle stopped.',
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
    my $CommonObjectTmp = shift || return;
    my %CommonObject = %{$CommonObjectTmp};
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

