#!/usr/bin/perl -w
# --
# SendStats.pl - send stats output via email
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SendStats.pl,v 1.5 2004-10-14 14:00:47 martin Exp $
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

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::Email;
use Kernel::System::CheckItem;
use Kernel::Output::HTML::Generic;

# --
# create common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{TimeObject} = Kernel::System::Time->new(
    %CommonObject,
);
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-SendStats',
    %CommonObject,
);
# create needed objects
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{CheckItemObject} = Kernel::System::CheckItem->new(%CommonObject);
$CommonObject{EmailObject} = Kernel::System::Email->new(%CommonObject);
$CommonObject{LayoutObject} = Kernel::Output::HTML::Generic->new(%CommonObject);

# --
# get options
# --
my %Opts = ();
getopt('mrsbh', \%Opts);
if ($Opts{'h'}) {
    print "SendStats.pl <Revision $VERSION> - OTRS cmd stats\n";
    print "Copyright (c) 2001-2004 Martin Edenhofer <martin\@otrs.org>\n";
    print "usage: SendStats.pl -m <REPORT_MODULE> -r <RECIPIENT> -s <SENDER> -b <MESSAGE>\n";
    exit 1;
}

if (!$Opts{'r'}) {
    print STDERR "ERROR: Need -r someone\@example.com\n";
    exit 1;
}
else {
    if (!$CommonObject{CheckItemObject}->CheckEmail(Address => $Opts{'r'})) {
        print STDERR "ERROR: ".$CommonObject{CheckItemObject}->CheckError()."\n";
        exit 1;
    }
}
if (!$Opts{'m'}) {
    print STDERR "ERROR: Need -m StateAction\n";
    exit 1;
}
if (!$Opts{'b'}) {
    print STDERR "ERROR: Need -b 'some message'\n";
    exit 1;
}
if (!$Opts{'s'}) {
    $Opts{'s'} = '';
}
my $Format = 'CSV';
my $Module = "Kernel::System::Stats::$Opts{'m'}";

# get module config
my %Config = %{$CommonObject{ConfigObject}->Get('SystemStatsMap')};
my %ConfigItem = ();
foreach my $Stats (sort keys %Config) {
    if ($Config{$Stats}->{Module} && $Config{$Stats}->{Module} eq $Module) {
        %ConfigItem = %{$Config{$Stats}};
    }
}
if (!%ConfigItem) {
    print STDERR "ERROR: No Config found for '$Module'!\n";
    exit 1;
}

if (eval "require $Module") {
    my %GetParam = ();
    my $StatsModule = $Module->new(%CommonObject);
    my @Params = $StatsModule->Param();
    foreach my $ParamItem (@Params) {
        if (!$ParamItem->{Multiple}) {
#            $GetParam{$ParamItem->{Name}} = $Self->{ParamObject}->GetParam(
#                Param => $ParamItem->{Name},
#            );
        }
        else {
#            $GetParam{$ParamItem->{Name}} = [$Self->{ParamObject}->GetArray(
 #               Param => $ParamItem->{Name},
 #           )];
        }
    }
    my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = localtime(time());
    $Y = $Y+1900;
    $M++;
    $GetParam{Year} = $Y;
    $GetParam{Month} = $M;
    $GetParam{Day} = $D;
    my $Time = sprintf("%02d:%02d:%02d", $h,$m,$s);
    # get data
    my @Data = $StatsModule->Run(%GetParam);

    my $TitleArrayRef = shift (@Data);
    my $Title = $TitleArrayRef->[0];
    my $HeadArrayRef = shift (@Data);

    my $Output = '';
    my %Attachment = ();
    # generate output
    if ($Format eq 'CSV') {
        $ConfigItem{Module} =~ s/^.*::(.+?)$/$1/;
        $Output = "$ConfigItem{Name}: $Title; Created: $Y-$M-$D $Time\n";
        $Output .= $CommonObject{LayoutObject}->OutputCSV(
            Head => $HeadArrayRef,
            Data => \@Data,
        );
        # return csv to download
        my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = localtime(time);
        $Y = $Y+1900;
        $M++;
        $M = sprintf("%02d", $M);
        $D = sprintf("%02d", $D);
        $h = sprintf("%02d", $h);
        $m = sprintf("%02d", $m);
        %Attachment = (
            Filename => "$ConfigItem{Module}"."_"."$Y-$M-$D"."_"."$h-$m.csv",
            Type => "text/csv",
            Data => $Output,
            Encoding => "base64",
            Disposition => "attachment",
        );
    }
    if ($CommonObject{EmailObject}->Send(
        From => $Opts{'s'},
        To => $Opts{'r'},
        Subject => "[Stats] $ConfigItem{Module} $Y-$M-$D $Time",
        Body => $Opts{'b'},
        Attachment => [
            {
               %Attachment,
            },
        ],
    )) {
        print "NOTICE: Email sent to '$Opts{'r'}'.\n";
    }

}
