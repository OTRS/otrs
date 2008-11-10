#!/usr/bin/perl -w
# --
# bin/cgi-bin/rpc.pl - soap handle
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: rpc.pl,v 1.8.2.1 2008-11-10 10:33:59 tr Exp $
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

use strict;
use warnings;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";

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
$VERSION = qw($Revision: 1.8.2.1 $) [1];

SOAP::Transport::HTTP::CGI->dispatch_to('Core')->handle;

package Core;

sub new {
    my $Self = shift;

    my $Class = ref($Self) || $Self;
    bless {} => $Class;

    return $Self;
}

sub Dispatch {
    my ( $Self, $User, $Pw, $Object, $Method, %Param ) = @_;

    # common objects
    my %CommonObject = ();
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-RPC',
        %CommonObject,
    );
    $CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
    $CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
    $CommonObject{PIDObject}    = Kernel::System::PID->new(%CommonObject);
    $CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
    $CommonObject{UserObject}   = Kernel::System::User->new(%CommonObject);
    $CommonObject{GroupObject}  = Kernel::System::Group->new(%CommonObject);
    $CommonObject{QueueObject}  = Kernel::System::Queue->new(%CommonObject);
    $CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

    $User ||= '';
    $Pw   ||= '';

    my $RequiredUser     = $CommonObject{ConfigObject}->Get('SOAP::User');
    my $RequiredPassword = $CommonObject{ConfigObject}->Get('SOAP::Password');

    if (
        !defined $RequiredUser
        || !length $RequiredUser
        || !defined $RequiredPassword || !length $RequiredPassword
        )
    {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message  => "SOAP::User or SOAP::Password is empty, SOAP access denied!",
        );
        return;
    }

    if ( $User ne $RequiredUser || $Pw ne $RequiredPassword ) {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message  => "Auth for user $User (pw $Pw) failed!",
        );
        return;
    }

    if ( !$CommonObject{$Object} ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "No such Object $Object!",
        );
        return "No such Object $Object!";
    }

    return $CommonObject{$Object}->$Method(%Param);
}

1;
