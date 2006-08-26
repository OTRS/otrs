#!/usr/bin/perl -w
# --
# xml2sql.pl - a xml 2 sql processor
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: xml2sql.pl,v 1.6 2006-08-26 17:22:05 martin Exp $
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

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::XML;

my $VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

my %Opts = ();
getopt('hton', \%Opts);
if ($Opts{'h'}) {
    print "xml2sql.pl <Revision $VERSION> - xml2sql\n";
    print "Copyright (c) 2001-2006 OTRS GmbH, http://otrs.org/\n";
    print "usage: xml2sql.pl -t <DATABASE_TYPE> [-o <OUTPUTDIR> -n <NAME>]\n";
    exit 1;
}

# name
if (!$Opts{n} && $Opts{o}) {
    die "ERROR: Need -n <NAME>";
}
# output dir
if ($Opts{o} && ! -e $Opts{o}) {
    die "ERROR: <OUTPUTDIR> $Opts{o} doesn' exist!";
}
# database type
if (!$Opts{t}) {
    die "ERROR: Need -t <DATABASE_TYPE>";
}

# --
# create common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{ConfigObject}->Set(Key => 'Database::Type', Value => $Opts{t});
$CommonObject{ConfigObject}->Set(Key => 'Database::ShellOutput', Value => 1);
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-xml2sql',
    %CommonObject,
);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{XMLObject} = Kernel::System::XML->new(%CommonObject);

my @Table = ();
my @File = <STDIN>;
my $FileString = '';
foreach (@File) {
    $FileString .= $_;
}

# parse xml package
my @XMLARRAY = $CommonObject{XMLObject}->XMLParse(String => $FileString);

# remember header
my $Head = $CommonObject{DBObject}->{"DB::Comment"}."----------------------------------------------------------\n";
$Head .= $CommonObject{DBObject}->{"DB::Comment"}." database: $Opts{t}, generated: ".scalar(localtime())."\n";
$Head .= $CommonObject{DBObject}->{"DB::Comment"}."----------------------------------------------------------\n";

# get database sql from parsed xml
my @SQL = $CommonObject{DBObject}->SQLProcessor(Database => \@XMLARRAY);
# write create script
if ($Opts{o}) {
    open (OUT, "> $Opts{o}/$Opts{n}-schema.$Opts{t}.sql") || die "Can't write: $!";
    print "writing: $Opts{o}/$Opts{n}-schema.$Opts{t}.sql\n";
}
else {
    *OUT = *STDOUT;
}
print OUT $Head;
foreach (@SQL) {
    print OUT "$_".$CommonObject{DBObject}->{"DB::ShellCommit"}."\n";
}
if ($Opts{o}) {
    close (OUT);
}

# get database sql from parsed xml
my @SQLPost = $CommonObject{DBObject}->SQLProcessorPost();
# write post script
if ($Opts{o}) {
    open (OUT, "> $Opts{o}/$Opts{n}-schema-post.$Opts{t}.sql") || die "Can't write: $!";
    print "writing: $Opts{o}/$Opts{n}-schema-post.$Opts{t}.sql\n";
}
else {
    *OUT = *STDOUT;
}
print OUT $Head;
foreach (@SQLPost) {
    print OUT "$_".$CommonObject{DBObject}->{"DB::ShellCommit"}."\n";
}
if ($Opts{o}) {
    close (OUT);
}

