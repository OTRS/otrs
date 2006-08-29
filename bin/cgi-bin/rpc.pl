#!/usr/bin/perl -w
# --
# bin/cgi-bin/rpc.pl - soap handle
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: rpc.pl,v 1.1 2006-08-29 13:42:35 martin Exp $
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

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";

use strict;
use SOAP::Transport::HTTP;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::PID;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::Queue;
use Kernel::System::Ticket;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-RPC',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{PIDObject} = Kernel::System::PID->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);
$CommonObject{GroupObject} = Kernel::System::Group->new(%CommonObject);
$CommonObject{QueueObject} = Kernel::System::Queue->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

SOAP::Transport::HTTP::CGI
    -> dispatch_to('Core')
    -> handle;

package Core;

sub new {
    my $Self = shift;
    my $Class = ref($Self) || $Self;
    bless {} => $Class;
    return $Self;
}

sub Dispatch {
    my $Self = shift;
    my $User = shift || '';
    my $Pw = shift || '';
    my $Object = shift;
    my $Method = shift;
    my %Param = @_;
    if ($User ne $CommonObject{ConfigObject}->Get('SOAP::User') || $Pw ne $CommonObject{ConfigObject}->Get('SOAP::Password')) {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message => "Auth for user $User faild!",
        );
        return;
    }
    if (!$CommonObject{$Object}) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message => "No such Object $Object!",
        );
        return "No such Object $Object!";
    }
    else {
        return $CommonObject{$Object}->$Method(%Param);
    }
}

1;
