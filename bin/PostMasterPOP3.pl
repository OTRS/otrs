#!/usr/bin/perl -w
# --
# PostMasterPOP3.pl - the global eMail handle for email2db
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PostMasterPOP3.pl,v 1.11 2003-06-27 08:07:30 martin Exp $
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
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin)."/Kernel/cpan-lib";

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use strict;
use Net::POP3;
use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::PostMaster;
use Kernel::System::POP3Account;

# --
# get options
# --
my %Opts = ();
getopt('upshd', \%Opts);
if ($Opts{'h'}) {
    print "PostMasterPOP3.pl <Revision $VERSION> - POP3 to OTRS\n";
    print "Copyright (c) 2001-2003 Martin Edenhofer <martin\@otrs.org>\n";
    print "usage: PostMasterPOP3.pl -s <POP3-SERVER> -u <USER> -p <PASSWORD> [-d 1-2]\n";
    exit 1;
}
if (!$Opts{'t'}) {
    $Opts{'t'} = 60;
}
if (!$Opts{'d'}) {
    $Opts{'d'} = 0;
}
if (!$Opts{'popd'}) {
    $Opts{'popd'} = 0;
}
# --
# create common objects 
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-PM3',
    %CommonObject,
);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{POP3Account} = Kernel::System::POP3Account->new(%CommonObject);
# MaxEmailSize 
my $MaxEmailSize = $CommonObject{ConfigObject}->Get('PostMasterPOP3MaxEmailSize') || 1024 * 6;
# debug info
if ($Opts{'d'} > 1) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug',
        Message => 'Global OTRS email handle (PostMasterPOP3.pl) started...',
    );
}
my %List = ();
if ($Opts{'s'} || $Opts{'u'} || $Opts{'p'}) {
    if (!$Opts{'s'}) {
        print STDERR "ERROR: Need -s <POP3-SERVER>\n";
        exit 1;
    }
    if (!$Opts{'u'}) {
        print STDERR "ERROR: Need -u <USER>\n";
        exit 1;
    }
    if (!$Opts{'p'}) {
        print STDERR "ERROR: Need -p <PASSWORD>\n";
        exit 1;
    }
    FetchMail(
       Login => $Opts{'u'},
       Password => $Opts{'p'},
       Host => $Opts{'s'},
    );
}
else {
    %List = $CommonObject{POP3Account}->POP3AccountList(Valid => 1);
    foreach (keys %List) {
        my %Data = $CommonObject{POP3Account}->POP3AccountGet(ID => $_);
        FetchMail(%Data);
    }
}
# debug info
if ($Opts{'d'} > 1) {
    $CommonObject{LogObject}->Log(
        Priority => 'debug',
        Message => 'Global OTRS email handle (PostMasterPOP3.pl) stoped.',
    );
}
# --
exit (0);

# --
sub FetchMail {
    my %Param = @_;
    my $User = $Param{Login};
    my $Password = $Param{Password};
    my $Host = $Param{Host};
    my $QueueID = $Param{QueueID} || 0;
    my $Trusted = $Param{Trusted} || 0;
    # connect to host
    my $PopObject = Net::POP3->new($Host, Timeout => $Opts{'t'}, Debug => $Opts{'popd'});
    if (!$PopObject) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message => "Can't connect to $Host",
        );
        return;
    }
    # authentcation
    my $NOM = $PopObject->login($User, $Password);
    if (!defined($NOM)) {
        $PopObject->quit();
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message => "Auth for user $User\@$Host failed!",
        );
        return;
    }
    # fetch messages
    my $FetchCounter = 0;
    if ($NOM > 0) {
        foreach my $Messageno ( sort { $a <=> $b } keys %{$PopObject->list()}) {
            print "Message $Messageno/$NOM ($User\@$Host)\n";
            # check message size
            my $MessageSize = int($PopObject->list($Messageno) / 1024);
            if ($MessageSize > $MaxEmailSize) {
                $CommonObject{LogObject}->Log(
                    Priority => 'error',
                    Message => "Can't fetch email $NOM from $User\@$Host. Email to ".
                      "big ($MessageSize KB - max $MaxEmailSize KB)!",
                );
            }
            else {
                # get message (header and body)	
                my $Lines = $PopObject->get($Messageno);
                $CommonObject{PostMaster} = Kernel::System::PostMaster->new(
                    %CommonObject, 
                    Email => $Lines,
                    Trusted => $Trusted,
                    Debug => $Opts{'d'},
                );
                $CommonObject{PostMaster}->Run(
                    QueueID => $QueueID,
                );
                $PopObject->delete($Messageno);
                $FetchCounter++;
            }
            print "\n";
       }
    }
    else {
         print "No messages ($User\@$Host)\n";
    }
    # log status
    if ($Opts{'d'} > 0 || $FetchCounter) {
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message => "Fetched $FetchCounter email(s) from $User\@$Host.",
        );
    }
    $PopObject->quit();
    print "Connection to $Host closed.\n\n";
}
# --
