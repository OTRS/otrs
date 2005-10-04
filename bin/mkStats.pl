#!/usr/bin/perl -w
# --
# SendStats.pl - send stats output via email
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: mkStats.pl,v 1.29 2005-10-04 19:25:18 martin Exp $
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
$VERSION = '$Revision: 1.29 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Time;
use Kernel::System::Main;
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
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-SendStats',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
# create needed objects
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{CheckItemObject} = Kernel::System::CheckItem->new(%CommonObject);
$CommonObject{EmailObject} = Kernel::System::Email->new(%CommonObject);
$CommonObject{LayoutObject} = Kernel::Output::HTML::Generic->new(%CommonObject);

# --
# get options
# --
my %Opts = ();
getopt('mrsbhop', \%Opts);
if ($Opts{'h'}) {
    print "mkStats.pl <Revision $VERSION> - OTRS cmd stats\n";
    print "Copyright (c) 2001-2005 Martin Edenhofer <martin\@otrs.org>\n";
    print "usage: mkStats.pl -m <REPORT_MODULE> [-p <PARAM_STRING> e. g. 'Year=1977&Month=10'] [-o /output/dir/] [-r <RECIPIENT> -s <SENDER>] [-b <MESSAGE>]\n";
    exit 1;
}

# required output param check
if (!$Opts{'o'} && !$Opts{'r'}) {
    print STDERR "ERROR: Need -o /tmp/ OR -r email\@example.com [-b 'some message']\n";
    exit 1;
}
# stats module check
if (!$Opts{'m'}) {
    print STDERR "ERROR: Need -m StateAction\n";
    exit 1;
}
# fill up body
if (!$Opts{'b'} && $Opts{'p'}) {
    $Opts{'b'} .= "Stats with following options:\n\n";
    $Opts{'b'} .= "Module: $Opts{'m'}\n";
    my @P = split(/&/, $Opts{'p'}||'');
    foreach (@P) {
        my ($Key, $Value) = split(/=/, $_, 2);
        $Opts{'b'} .= "$Key: $Value\n";
    }
}
if (!$Opts{'b'}) {
    print STDERR "ERROR: Need -b 'some message'\n";
    exit 1;
}
# recipient check
if ($Opts{'r'}) {
    if (!$CommonObject{CheckItemObject}->CheckEmail(Address => $Opts{'r'})) {
        print STDERR "ERROR: ".$CommonObject{CheckItemObject}->CheckError()."\n";
        exit 1;
    }
}
# sender, if given
if (!$Opts{'s'}) {
    $Opts{'s'} = '';
}
# directory check
if ($Opts{'o'} && !-e $Opts{'o'}) {
    print STDERR "ERROR: No such directory: $Opts{'o'}\n";
    exit 1;
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
    # set std params
    my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = localtime(time());
    $Y = $Y+1900;
    $M++;
    $GetParam{Year} = $Y;
    $GetParam{Month} = $M;
    $GetParam{Day} = $D;
    # get params from -p
    my @Params = $StatsModule->Param();
    foreach my $ParamItem (@Params) {
        if (!$ParamItem->{Multiple}) {
            $GetParam{$ParamItem->{Name}} = GetParam(
                Param => $ParamItem->{Name},
            );
#            print STDERR "$ParamItem->{Name}: $GetParam{$ParamItem->{Name}}\n";
       }
       else {
            $GetParam{$ParamItem->{Name}} = [GetArray(
                Param => $ParamItem->{Name},
            )];
#            print STDERR "$ParamItem->{Name}: $GetParam{$ParamItem->{Name}}\n";
       }
    }
    my $Time = sprintf("%02d:%02d:%02d", $h,$m,$s);
    # get data
    my @Data = $StatsModule->Run(%GetParam);

    my $TitleArrayRef = shift (@Data);
    my $Title = $TitleArrayRef->[0];
    my $HeadArrayRef = shift (@Data);
    # add sum y
    if ($ConfigItem{SumRow}) {
        push (@{$HeadArrayRef}, 'Sum');
        foreach my $Col (@Data) {
            my $Sum = 0;
            foreach (@{$Col}) {
                if ($_ =~ /[0-9]/ && $_ !~ /[A-z]/i) {
                    $Sum = $Sum + $_;
                }
            }
            push (@{$Col}, $Sum);
        }
    }
    # add sum x
    if ($ConfigItem{SumCol}) {
        my @R1 = ();
        foreach my $Col (@Data) {
            my $Count = -1;
            foreach my $Dig (@{$Col}) {
                $Count++;
                if ($Dig =~ /[0-9]/ && $Dig !~ /[A-z]/i) {
                    if ($R1[$Count]) {
                        $R1[$Count] = $R1[$Count] + $Dig;
                    }
                    else {
                        $R1[$Count] = $Dig;
                    }
                }
            }
        }
        # add sum
        if (!defined($R1[0])) {
            $R1[0] = 'Sum';
        }
        push (@Data, \@R1);
    }

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
            ContentType => "text/csv",
            Content => $Output,
            Encoding => "base64",
            Disposition => "attachment",
        );
    }
    # write output
    if ($Opts{'o'}) {
        if (open(OUT, "> $Opts{'o'}/$Attachment{Filename}")) {
            print OUT $Attachment{Content};
            close (OUT);
            print "NOTICE: Writing file $Opts{'o'}/$Attachment{Filename}.\n";
            exit;
        }
        else {
            print STDERR "ERROR: Can't write $Opts{'o'}/$Attachment{Filename}: $!\n";
            exit 1;
        }
    }
    # send email
    elsif ($CommonObject{EmailObject}->Send(
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

sub GetParam {
    my %Param = @_;
    if (!$Param{Param}) {
        print STDERR "ERROR: Need Param Arg in GetParam()\n";
    }
    my @P = split(/&/, $Opts{'p'}||'');
    foreach (@P) {
        my ($Key, $Value) = split(/=/, $_, 2);
#print STDERR "$Key, $Value, $Param{Param} ---\n";
        if ($Key eq $Param{Param}) {
#print STDERR "$Key, $Value ---\n";
            return $Value;
        }
    }
    return;
}
sub GetArray {
    my %Param = @_;
    if (!$Param{Param}) {
        print STDERR "ERROR: Need Param Arg in GetArray()\n";
    }
    my @P = split(/&/, $Opts{'p'}||'');
    my @Array = ();
    foreach (@P) {
        my ($Key, $Value) = split(/=/, $_, 1);
        if ($Key eq $Param{Param}) {
            push (@Array, $Value);
        }
    }
    return @Array;
}
