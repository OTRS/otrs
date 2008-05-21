#!/usr/bin/perl -w
# --
# bin/xml2sql.pl - a xml 2 sql processor
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: xml2sql.pl,v 1.19 2008-05-21 08:26:10 mh Exp $
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
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::XML;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.19 $) [1];

my %Opts = ();
getopt( 'hton', \%Opts );
if ( $Opts{'h'} ) {
    print "xml2sql.pl <Revision $VERSION> - xml2sql\n";
    print "Copyright (c) 2001-2008 OTRS AG, http://otrs.org/\n";
    print "usage: xml2sql.pl -t <DATABASE_TYPE> (or 'all') ";
    print "[-o <OUTPUTDIR> -n <NAME> -s <SPLIT_FILES>]\n";
    exit 1;
}

# name
if ( !$Opts{n} && $Opts{o} ) {
    die 'ERROR: Need -n <NAME>';
}

# output dir
if ( $Opts{o} && !-e $Opts{o} ) {
    die "ERROR: <OUTPUTDIR> $Opts{o} doesn' exist!";
}
if ( !$Opts{o} ) {
    $Opts{o} = '';
}

# database type
if ( !$Opts{t} ) {
    die 'ERROR: Need -t <DATABASE_TYPE>';
}
my @DatabaseType;
if ( $Opts{t} eq 'all' ) {
    my $ConfigObject = Kernel::Config->new();
    my @List         = glob( $ConfigObject->Get('Home') . '/Kernel/System/DB/*.pm' );
    for my $File (@List) {
        $File =~ s/^.*\/(.+?).pm$/$1/;
        push @DatabaseType, $File;
    }
}
else {
    push @DatabaseType, $Opts{t};
}

# read xml file
my @File       = <STDIN>;
my $FileString = '';
for my $Line (@File) {
    $FileString .= $Line;
}

for my $DatabaseType (@DatabaseType) {

    # create common objects
    my %CommonObject = ();
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{ConfigObject}->Set(
        Key   => 'Database::Type',
        Value => $DatabaseType,
    );
    $CommonObject{ConfigObject}->Set(
        Key   => 'Database::ShellOutput',
        Value => 1,
    );
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
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $CommonObject{TimeObject}->SystemTime2Date(
        SystemTime => $CommonObject{TimeObject}->SystemTime(),
    );

    my $Head = $CommonObject{DBObject}->{Backend}->{'DB::Comment'}
        . "----------------------------------------------------------\n";
    $Head .= $CommonObject{DBObject}->{Backend}->{'DB::Comment'}
        . " driver: $DatabaseType, generated: $Year-$Month-$Day $Hour:$Min:$Sec\n";
    $Head .= $CommonObject{DBObject}->{Backend}->{'DB::Comment'}
        . "----------------------------------------------------------\n";

    # get sql from parsed xml
    my @SQL;
    if ( $CommonObject{DBObject}->{Backend}->{'DB::ShellConnect'} ) {
        push @SQL, $CommonObject{DBObject}->{Backend}->{'DB::ShellConnect'};
    }
    push @SQL, $CommonObject{DBObject}->SQLProcessor( Database => \@XMLARRAY );

    # get port sql from parsed xml
    my @SQLPost;
    if ( $CommonObject{DBObject}->{Backend}->{'DB::ShellConnect'} ) {
        push @SQLPost, $CommonObject{DBObject}->{Backend}->{'DB::ShellConnect'};
    }
    push @SQLPost, $CommonObject{DBObject}->SQLProcessorPost();

    if ( $Opts{s} ) {

        # write create script
        Dump(
            $Opts{o} . '/' . $Opts{n} . '.' . $DatabaseType . '.sql',
            \@SQL,
            $Head,
            $CommonObject{DBObject}->{Backend}->{'DB::ShellCommit'},
            $Opts{o},
        );

        # write post script
        Dump(
            $Opts{o} . '/' . $Opts{n} . '-post.' . $DatabaseType . '.sql',
            \@SQLPost,
            $Head,
            $CommonObject{DBObject}->{Backend}->{'DB::ShellCommit'},
            $Opts{o},
        );
    }
    else {
        Dump(
            $Opts{o} . '/' . $Opts{n} . '.' . $DatabaseType . '.sql',
            [ @SQL, @SQLPost ],
            $Head,
            $CommonObject{DBObject}->{Backend}->{'DB::ShellCommit'},
            $Opts{o},
        );
    }
}

sub Dump {
    my ( $Filename, $SQL, $Head, $Commit, $StdOut ) = @_;

    if ($StdOut) {
        open my $OutHandle, '>', $Filename or die "Can't write: $!";
        print "writing: $Filename\n";
        print $OutHandle $Head;
        for my $Item ( @{$SQL} ) {
            print $OutHandle $Item . $Commit . "\n";
        }
        close $OutHandle;
    }
    else {
        print $Head;
        for my $Item ( @{$SQL} ) {
            print $Item . $Commit . "\n";
        }
    }

    return 1;
}
