#!/usr/bin/perl
# --
# scripts/backup.pl - the backup script
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use vars qw($VERSION);

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Date::Pcalc qw(Today Today_and_Now Add_Delta_Days);

# get options
my %Opts;
my $Compress    = '';
my $CompressCMD = '';
my $FullBackup  = 0;
my $DB          = '';
my $DBDump      = '';
getopt( 'hcrtd', \%Opts );
if ( exists $Opts{h} ) {
    print "backup.pl <Revision $VERSION> - backup script\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print
        "usage: backup.pl -d /data_backup_dir/ [-c gzip|bzip2] [-r 30] [-t fullbackup|nofullbackup]\n";
    exit 1;
}

# check backup dir
if ( !$Opts{d} ) {
    print STDERR "ERROR: Need -d for backup directory\n";
    exit 1;
}
elsif ( !-d $Opts{d} ) {
    print STDERR "ERROR: No such directory: $Opts{d}\n";
    exit 1;
}

# check compress mode
if ( $Opts{c} && $Opts{c} =~ m/bzip2/i ) {
    $Compress    = 'j';
    $CompressCMD = 'bzip2';
}
else {
    $Compress    = 'z';
    $CompressCMD = 'gzip';
}

# check backup type
if ( $Opts{t} && $Opts{t} =~ m/no/i ) {
    $FullBackup = 0;
}
else {
    $FullBackup = 1;
}

# create common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-Backup',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new( %CommonObject, AutoConnectNo => 1 );
my $DatabaseHost = $CommonObject{ConfigObject}->Get('DatabaseHost');
my $Database     = $CommonObject{ConfigObject}->Get('Database');
my $DatabaseUser = $CommonObject{ConfigObject}->Get('DatabaseUser');
my $DatabasePw   = $CommonObject{ConfigObject}->Get('DatabasePw');
my $DatabaseDSN  = $CommonObject{ConfigObject}->Get('DatabaseDSN');
my $ArticleDir   = $CommonObject{ConfigObject}->Get('ArticleDir');

# decrypt pw (if needed)
if ( $DatabasePw =~ m/^\{(.*)\}$/ ) {
    $DatabasePw = $CommonObject{DBObject}->_Decrypt($1);
}

# check db backup support
if ( $DatabaseDSN =~ m/:mysql/i ) {
    $DB     = 'MySQL';
    $DBDump = 'mysqldump';
}
elsif ( $DatabaseDSN =~ m/:pg/i ) {
    $DB     = 'PostgreSQL';
    $DBDump = 'pg_dump';
}
else {
    print STDERR "ERROR: Can't backup, no database dump support!\n";
    exit(1);
}

# check needed programs
for my $CMD ( 'cp', 'tar', $DBDump, $CompressCMD ) {
    my $Installed = 0;
    open my $In, '-|', "which $CMD";    ## no critic
    while (<$In>) {
        $Installed = 1;
    }
    close $In;
    if ( !$Installed ) {
        print STDERR "ERROR: Can't locate $CMD!\n";
        exit 1;
    }
}

# remove old backups
if ( $Opts{r} ) {
    my %LeaveBackups;
    my ( $Year, $Month, $Day ) = Today_and_Now();
    for ( 0 .. $Opts{r} ) {
        my ( $DYear, $DMonth, $DDay ) = Add_Delta_Days( $Year, $Month, $Day, -$_ );
        $LeaveBackups{ sprintf( "%04d-%01d-%01d", $DYear, $DMonth, $DDay ) } = 1;
        $LeaveBackups{ sprintf( "%04d-%02d-%01d", $DYear, $DMonth, $DDay ) } = 1;
        $LeaveBackups{ sprintf( "%04d-%01d-%02d", $DYear, $DMonth, $DDay ) } = 1;
        $LeaveBackups{ sprintf( "%04d-%02d-%02d", $DYear, $DMonth, $DDay ) } = 1;
    }
    my @Directories = $CommonObject{MainObject}->DirectoryRead(
        Directory => $Opts{d},
        Filter    => '*',
    );

    for my $Directory (@Directories) {
        my $Leave = 0;
        for my $Data ( sort keys %LeaveBackups ) {
            if ( $Directory =~ m/$Data/ ) {
                $Leave = 1;
            }
        }
        if ( !$Leave ) {

            # remove files and directory
            print "deleting old backup in $Directory ... ";
            my @Files = $CommonObject{MainObject}->DirectoryRead(
                Directory => $Directory,
                Filter    => '*',
            );
            for my $File (@Files) {
                if ( -e $File ) {

                    #                    print "Notice: remove $File\n";
                    unlink $File;
                }
            }
            if ( rmdir($Directory) ) {
                print "done\n";
            }
            else {
                die "failed\n";
            }
        }
    }
}

# create new backup directory
my $Home = $CommonObject{ConfigObject}->Get('Home');
chdir($Home);
my ( $s, $m, $h, $D, $M, $Y ) = $CommonObject{TimeObject}->SystemTime2Date(
    SystemTime => $CommonObject{TimeObject}->SystemTime(),
);
my $Directory = "$Opts{d}/$Y-$M-$D" . "_" . "$h-$m";
if ( !mkdir($Directory) ) {
    die "ERROR: Can't create directory: $Directory: $!\n";
}

# backup Kernel/Config.pm
print "Backup $Directory/Config.tar.gz ... ";
if (
    !system(
        "tar -czf $Directory/Config.tar.gz Kernel/Config.pm Kernel/Config/Files/ZZZ*.pm Kernel/Config/GenericAgen*.pm"
    )
    )
{
    print "done\n";
}
else {
    die "failed\n";
}

# backup application
if ($FullBackup) {
    print "Backup $Directory/Application.tar.gz ... ";
    my $Excludes = "--exclude=var/tmp --exclude=js-cache --exclude=css-cache ";
    if ( !system("tar $Excludes -czf $Directory/Application.tar.gz .") ) {
        print "done\n";
    }
    else {
        die "failed\n";
    }
}

# backup vardir
else {
    print "Backup $Directory/VarDir.tar.gz ... ";
    if ( !system("tar -czf $Directory/VarDir.tar.gz var/") ) {
        print "done\n";
    }
    else {
        die "failed\n";
    }
}

# backup datadir
if ( $ArticleDir !~ m/\Q$Home\E/ ) {
    print "Backup $Directory/DataDir.tar.gz ... ";
    if ( !system("tar -czf $Directory/DataDir.tar.gz $ArticleDir") ) {
        print "done\n";
    }
    else {
        die "failed\n";
    }
}

# backup database
if ( $DB =~ m/mysql/i ) {
    print "Dump $DB rdbms ... ";
    if ($DatabasePw) {
        $DatabasePw = "-p'$DatabasePw'";
    }
    if (
        !system(
            "$DBDump -u $DatabaseUser $DatabasePw -h $DatabaseHost $Database > $Directory/DatabaseBackup.sql"
        )
        )
    {
        print "done\n";
    }
    else {
        die "failed\n";
    }
}
else {
    print "Dump $DB rdbms ... ";
    if (
        !system(
            "$DBDump -f $Directory/DatabaseBackup.sql -h $DatabaseHost -U $DatabaseUser $Database"
        )
        )
    {
        die "done\n";
    }
    else {
        die "failed\n";
    }
}

# compressing database
print "Compress SQL-file... ";
if ( !system("$CompressCMD $Directory/DatabaseBackup.sql") ) {
    print "done\n";
}
else {
    die "failed\n";
}
