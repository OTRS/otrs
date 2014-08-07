#!/usr/bin/perl
# --
# bin/otrs.xml2sql.pl - a xml to sql processor
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std;

use Kernel::System::ObjectManager;

my %Opts;
getopt( 'htonf', \%Opts );
if ( $Opts{'h'} || !%Opts ) {
    print <<"EOF";
$0 - tool to generate database specific SQL from the XML database definition files used by OTRS

Copyright (C) 2001-2010 OTRS AG, http://otrs.org/

Usage: $0 -t <DATABASE_TYPE> (or 'all') [-o <OUTPUTDIR> -n <NAME> -s <SPLIT_FILES>] [-f source file]
EOF
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

# database type
if ( !$Opts{t} ) {
    die 'ERROR: Need -t <DATABASE_TYPE>';
}

$Opts{o} ||= '';

my @DatabaseType;
if ( $Opts{t} eq 'all' ) {

    # create instance of the config object
    my $ConfigObject = Kernel::Config->new();

    # get otrs home
    my $Home = $ConfigObject->Get('Home');

    # get list of all database drivers
    my @List = glob $Home . '/Kernel/System/DB/*.pm';

    # extract database types
    for my $File (@List) {
        $File =~ s/^.*\/(.+?).pm$/$1/;
        push @DatabaseType, $File;
    }
}
else {
    push @DatabaseType, $Opts{t};
}

my $FileString;

if ( !$Opts{f} ) {

    # read xml data from STDIN
    $FileString = do { local $/; <STDIN> };
}
elsif ( !-f $Opts{f} ) {
    die "ERROR: File $Opts{f} not exists!";
}

for my $DatabaseType (@DatabaseType) {

    # create common objects
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        LogObject => {
            LogPrefix => 'OTRS-otrs.xml2sql.pl',
        },
        DBObject => {
            AutoConnectNo => 1,    # don't try with foreign drivers
        },
    );
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'Database::Type',
        Value => $DatabaseType,
    );
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'Database::ShellOutput',
        Value => 1,
    );

    if ( $Opts{f} ) {

        # read the source file
        my $FileStringRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location        => $Opts{f},
            Mode            => 'utf8',
            Type            => 'Local',
            Result          => 'SCALAR',
            DisableWarnings => 1,
        );

        $FileString = ${$FileStringRef};
    }

    # parse xml package
    my @XMLARRAY = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $FileString );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $Head = $DBObject->{Backend}->{'DB::Comment'}
        . "----------------------------------------------------------\n";
    $Head .= $DBObject->{Backend}->{'DB::Comment'}
        . " driver: $DatabaseType\n";
    $Head .= $DBObject->{Backend}->{'DB::Comment'}
        . "----------------------------------------------------------\n";

    # get sql from parsed xml
    my @SQL;
    if ( $DBObject->{Backend}->{'DB::ShellConnect'} ) {
        push @SQL, $DBObject->{Backend}->{'DB::ShellConnect'};
    }
    push @SQL, $DBObject->SQLProcessor( Database => \@XMLARRAY );

    # get port sql from parsed xml
    my @SQLPost;
    if ( $DBObject->{Backend}->{'DB::ShellConnect'} ) {
        push @SQLPost, $DBObject->{Backend}->{'DB::ShellConnect'};
    }
    push @SQLPost, $DBObject->SQLProcessorPost();

    if ( $Opts{s} ) {

        # write create script
        Dump(
            $Kernel::OM->Get('Kernel::System::Main'),
            $Opts{o} . '/' . $Opts{n} . '.' . $DatabaseType . '.sql',
            \@SQL,
            $Head,
            $DBObject->{Backend}->{'DB::ShellCommit'},
            $Opts{o},
        );

        # write post script
        Dump(
            $Kernel::OM->Get('Kernel::System::Main'),
            $Opts{o} . '/' . $Opts{n} . '-post.' . $DatabaseType . '.sql',
            \@SQLPost,
            $Head,
            $DBObject->{Backend}->{'DB::ShellCommit'},
            $Opts{o},
        );
    }
    else {
        Dump(
            $Kernel::OM->Get('Kernel::System::Main'),
            $Opts{o} . '/' . $Opts{n} . '.' . $DatabaseType . '.sql',
            [ @SQL, @SQLPost ],
            $Head,
            $DBObject->{Backend}->{'DB::ShellCommit'},
            $Opts{o},
        );
    }
}

sub Dump {
    my ( $MainObject, $Filename, $SQL, $Head, $Commit, $StdOut ) = @_;

    if ($StdOut) {

        my $Content = $Head;
        for my $Item ( @{$SQL} ) {
            $Content .= $Item . $Commit . "\n";
        }

        print STDOUT "writing: $Filename\n";

        $MainObject->FileWrite(
            Location => $Filename,
            Content  => \$Content,
            Mode     => 'utf8',
            Type     => 'Local',
        );
    }
    else {
        print $Head;
        for my $Item ( @{$SQL} ) {
            print $Item . $Commit . "\n";
        }
    }

    return 1;
}
