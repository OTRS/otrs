#!/usr/bin/perl -w
# --
# bin/xml2sql.pl - a xml 2 sql processor
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: xml2sql.pl,v 1.14 2008-02-01 12:49:20 tr Exp $
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::XML;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

my %Opts = ();
getopt( 'htosi', \%Opts );
if ( $Opts{'h'} ) {
    print "xml2sql.pl <Revision $VERSION> - xml2sql\n";
    print "Copyright (c) 2001-2007 OTRS GmbH, http://otrs.org/\n";
    print
        "usage: xml2sql.pl -t <DATABASE_TYPE> (or 'all') [-o <OUTPUTDIR> -s <SCHEMA> -i <INITIAL_INSERT>]\n";
    exit 1;
}

# name
if ( ( !$Opts{s} && !$Opts{i} ) && $Opts{o} ) {
    die "ERROR: Need -s <SCHEMA> or -i <INITIAL_INSERT>";
}

# output dir
if ( $Opts{o} && !-e $Opts{o} ) {
    die "ERROR: <OUTPUTDIR> $Opts{o} doesn' exist!";
}

# database type
if ( !$Opts{t} ) {
    die "ERROR: Need -t <DATABASE_TYPE>";
}
my @DatabaseType = ();
if ( $Opts{t} eq 'all' ) {
    my $ConfigObject = Kernel::Config->new();
    my @List         = glob( $ConfigObject->Get('Home') . "/Kernel/System/DB/*.pm" );
    for my $File (@List) {
        $File =~ s/^.*\/(.+?).pm$/$1/;
        push( @DatabaseType, $File );
    }
}
else {
    push( @DatabaseType, $Opts{t} );
}

# read xml file
my @File       = <STDIN>;
my $FileString = '';
for (@File) {
    $FileString .= $_;
}

for my $DatabaseType (@DatabaseType) {

    # create common objects
    my %CommonObject = ();
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{ConfigObject}->Set( Key => 'Database::Type',        Value => $DatabaseType );
    $CommonObject{ConfigObject}->Set( Key => 'Database::ShellOutput', Value => 1 );
    $CommonObject{LogObject} = Kernel::System::Log->new(
        LogPrefix => 'OTRS-xml2sql',
        %CommonObject,
    );
    $CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
    $CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
    $CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
    $CommonObject{XMLObject}  = Kernel::System::XML->new(%CommonObject);

    # parse xml package
    my @XMLARRAY = $CommonObject{XMLObject}->XMLParse( String => $FileString );

    # remember header
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year )
        = $CommonObject{TimeObject}
        ->SystemTime2Date( SystemTime => $CommonObject{TimeObject}->SystemTime(), );
    my $Head = $CommonObject{DBObject}->{Backend}->{"DB::Comment"}
        . "----------------------------------------------------------\n";
    $Head .= $CommonObject{DBObject}->{Backend}->{"DB::Comment"}
        . " driver: $DatabaseType, generated: $Year-$Month-$Day $Hour:$Min:$Sec\n";
    $Head .= $CommonObject{DBObject}->{Backend}->{"DB::Comment"}
        . "----------------------------------------------------------\n";

    if ( $Opts{i} ) {

        # get database sql from parsed xml
        my @SQL = ();
        if ( $CommonObject{DBObject}->{Backend}->{"DB::ShellConnect"} ) {
            push( @SQL, $CommonObject{DBObject}->{Backend}->{"DB::ShellConnect"} );
        }
        push( @SQL, $CommonObject{DBObject}->SQLProcessor( Database => \@XMLARRAY ) );

        # write create script
        if ( $Opts{o} ) {
            open( OUT, "> $Opts{o}/$Opts{i}-initial_insert.$DatabaseType.sql" )
                || die "Can't write: $!";
            print "writing: $Opts{o}/$Opts{i}-initial_insert.$DatabaseType.sql\n";
        }
        else {
            *OUT = *STDOUT;
        }
        print OUT $Head;
        for (@SQL) {
            print OUT "$_" . $CommonObject{DBObject}->{Backend}->{"DB::ShellCommit"} . "\n";
        }
        if ( $Opts{o} ) {
            close(OUT);
        }
    }
    else {

        # get database sql from parsed xml
        my @SQL = ();
        if ( $CommonObject{DBObject}->{Backend}->{"DB::ShellConnect"} ) {
            push( @SQL, $CommonObject{DBObject}->{Backend}->{"DB::ShellConnect"} );
        }
        push( @SQL, $CommonObject{DBObject}->SQLProcessor( Database => \@XMLARRAY ) );

        # write create script
        if ( $Opts{o} ) {
            open( OUT, "> $Opts{o}/$Opts{s}-schema.$DatabaseType.sql" ) || die "Can't write: $!";
            print "writing: $Opts{o}/$Opts{s}-schema.$DatabaseType.sql\n";
        }
        else {
            *OUT = *STDOUT;
        }
        print OUT $Head;
        for (@SQL) {
            print OUT "$_" . $CommonObject{DBObject}->{Backend}->{"DB::ShellCommit"} . "\n";
        }
        if ( $Opts{o} ) {
            close(OUT);
        }

        # get database sql from parsed xml
        my @SQLPost = ();
        if ( $CommonObject{DBObject}->{Backend}->{"DB::ShellConnect"} ) {
            push( @SQLPost, $CommonObject{DBObject}->{Backend}->{"DB::ShellConnect"} );
        }
        push( @SQLPost, $CommonObject{DBObject}->SQLProcessorPost() );

        # write post script
        if ( $Opts{o} ) {
            open( OUT, "> $Opts{o}/$Opts{s}-schema-post.$DatabaseType.sql" )
                || die "Can't write: $!";
            print "writing: $Opts{o}/$Opts{s}-schema-post.$DatabaseType.sql\n";
        }
        else {
            *OUT = *STDOUT;
        }
        print OUT $Head;
        for (@SQLPost) {
            print OUT "$_" . $CommonObject{DBObject}->{Backend}->{"DB::ShellCommit"} . "\n";
        }
        if ( $Opts{o} ) {
            close(OUT);
        }
    }
}
