#!/usr/bin/perl -w
# --
# faq.pl - the global CGI handle file for OTRS
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: faq.pl,v 1.2 2004-02-05 16:08:46 martin Exp $
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

use vars qw($VERSION @INC);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
# 0=off;1=on;
# --
my $Debug = 0; 

# --
# check @INC for mod_perl (add lib path for "require module"!)
# --
push (@INC, "$Bin/../..", "$Bin/../../Kernel/cpan-lib");

# --
# all framework needed  modules 
# (if you use mod_perl with startup.pl, drop this "use Kernel::.." and add
# this to your startup.pl) 
# --
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::WebRequest;
use Kernel::System::DB;
use Kernel::System::User;
use Kernel::Output::HTML::Generic;
use Kernel::Modules::CustomerFAQ;

# --
# create common framework objects 1/2
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => $CommonObject{ConfigObject}->Get('CGILogPrefix'),
    %CommonObject,
);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{ParamObject} = Kernel::System::WebRequest->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);
# --
# debug info
# --
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug', 
        Message => 'Global handle started...',
    );
}
my %Param = ();
# definde frame work params
my $FramworkPrams = {
    Lang => '',
    Action => '',
    Subaction => '',
};
foreach my $Key (keys %{$FramworkPrams}) {
    $Param{$Key} = $CommonObject{ParamObject}->GetParam(Param => $Key) 
      || $FramworkPrams->{$Key};
}
# --
# create common framework objects 2/2
# --
$CommonObject{LayoutObject} = Kernel::Output::HTML::Generic->new(
    %CommonObject, 
    Lang => $Param{Lang},
);
# --
# check common objects
# --
if (!$CommonObject{DBObject}) {
    print $CommonObject{LayoutObject}->CustomerHeader(Title => 'Error!');
    print $CommonObject{LayoutObject}->CustomerError(
        Message => $DBI::errstr,
        Comment => 'Please contact your admin'
    );
    print $CommonObject{LayoutObject}->CustomerFooter();
    exit (1);
}
if ($CommonObject{ParamObject}->Error()) {
    print $CommonObject{LayoutObject}->CustomerHeader(Title => 'Error!');
    print $CommonObject{LayoutObject}->CustomerError(
        Message => $CommonObject{ParamObject}->Error(),
        Comment => 'Please contact your admin'
    );
    print $CommonObject{LayoutObject}->CustomerFooter();
    exit (1);
}
# --
# prove of concept! - create $GenericObject
# --
my $GenericObject = ('Kernel::Modules::CustomerFAQ')->new(
    UserID => 1,
    %CommonObject,
    %Param,
);
# --
# ->Run $Action with $GenericObject
# --
print $GenericObject->Run(States => ['public (all)']);
# --
# debug info
# --
if ($Debug) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug',
        Message => 'Global handle stopped.',
    );
}
# --
# db disconnect && undef %CommonObject %% undef %
# --
$CommonObject{DBObject}->Disconnect();
undef %Param;
undef %CommonObject;

