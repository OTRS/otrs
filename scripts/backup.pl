#!/usr/bin/perl -w
# --
# scripts/backup.pl - the backup script
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: backup.pl,v 1.5 2006-08-29 17:51:09 martin Exp $
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
use Date::Pcalc qw(Today Today_and_Now Add_Delta_Days);

# --
# get options
# --
my %Opts = ();
my $Compress = '';
my $CompressCMD = '';
my $FullBackup = 0;
my $DB = '';
my $DBDump = '';
getopt('hcrtd', \%Opts);
if ($Opts{'h'}) {
    print "backup.pl <Revision $VERSION> - backup script\n";
    print "Copyright (c) 2001-2006 OTRS GmbH, http//otrs.org/\n";
    print "usage: backup.pl -d /data_backup_dir/ [-c gzip|bzip2] [-r 30] [-t fullbackup|nofullbackup]\n";
    exit 1;
}
# check backup dir
if (!$Opts{'d'}) {
    print STDERR "ERROR: Need -d for backup directory\n";
    exit (1);
}
elsif (! -d $Opts{'d'}) {
    print STDERR "ERROR: No such directory: $Opts{'d'}\n";
    exit (1);
}
# check compress mode
if ($Opts{'c'} && $Opts{'c'} =~ /bzip2/i) {
    $Compress = 'j';
    $CompressCMD = 'bzip';
}
else {
    $Compress = 'z';
    $CompressCMD = 'gzip';
}
# check backup type
if ($Opts{'t'} && $Opts{'t'} =~ /no/i) {
    $FullBackup = 0;
}
else {
    $FullBackup = 1;
}
# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-Backup',
    %CommonObject,
);
$CommonObject{TimeObject} = Kernel::System::Time->new(
    %CommonObject,
);
my $DatabaseHost = $CommonObject{ConfigObject}->Get('DatabaseHost');
my $Database = $CommonObject{ConfigObject}->Get('Database');
my $DatabaseUser = $CommonObject{ConfigObject}->Get('DatabaseUser');
my $DatabasePw = $CommonObject{ConfigObject}->Get('DatabasePw');
my $DatabaseDSN = $CommonObject{ConfigObject}->Get('DatabaseDSN');
my $ArticleDir = $CommonObject{ConfigObject}->Get('ArticleDir');
# check db backup support
if ($DatabaseDSN =~ /:mysql/i) {
    $DB = 'MySQL';
    $DBDump = 'mysqldump';
}
elsif ($DatabaseDSN =~ /:pg/i) {
    $DB = 'PostgreSQL';
    $DBDump = 'pg_dump';
}
else {
    print STDERR "ERROR: Can't backup, no database dump support!\n";
    exit (1);
}
# check needed programs
foreach my $CMD ('cp', 'tar', $DBDump, $CompressCMD) {
    my $Installed = 0;
    open (IN, "which $CMD | ");
    while (<IN>) {
        $Installed = 1;
    }
    close (IN);
    if (!$Installed) {
        print STDERR "ERROR: Can't locate $CMD!\n";
        exit (1);
    }
}
# remove old backups
if ($Opts{'r'}) {
    my %LeaveBackups = ();
    my($Year, $Month, $Day) = Today_and_Now();
    foreach (0..$Opts{'r'}) {
        my($DYear,$DMonth,$DDay) = Add_Delta_Days($Year, $Month, $Day, -$_);
        $LeaveBackups{sprintf("%04d-%01d-%01d", $DYear, $DMonth, $DDay)} = 1;
        $LeaveBackups{sprintf("%04d-%02d-%01d", $DYear, $DMonth, $DDay)} = 1;
        $LeaveBackups{sprintf("%04d-%01d-%02d", $DYear, $DMonth, $DDay)} = 1;
        $LeaveBackups{sprintf("%04d-%02d-%02d", $DYear, $DMonth, $DDay)} = 1;
    }
    my @Direcroties = glob($Opts{'d'}."/*");
    foreach my $Directory (@Direcroties) {
        my $Leave = 0;
        foreach my $Data (keys %LeaveBackups) {
            if ($Directory =~ /$Data/) {
                $Leave = 1;
            }
        }
        if (!$Leave) {
            # remove files and directory
            print "deleting old backup in $Directory ... ";
            my @Files = glob($Directory.'/*');
            foreach my $File (@Files) {
                if (-e $File) {
#                    print "Notice: remove $File\n";
                    unlink $File;
                }
            }
            if (rmdir($Directory)) {
                print "done\n";
            }
            else {
                print "failed\n";
            }
        }
    }
}

# create new backup directory
my $Home = $CommonObject{ConfigObject}->Get('Home');
my ($s,$m,$h, $D,$M,$Y) = $CommonObject{TimeObject}->SystemTime2Date(
    SystemTime => $CommonObject{TimeObject}->SystemTime(),
);
my $Directory = "$Opts{'d'}/$Y-$M-$D"."_"."$h-$m";
if (!mkdir($Directory)) {
    print STDERR "ERROR: Can't create directory: $Directory: $!\n";
    exit (1);
}

# backup Kernel/Config.pm
print "Backup $Directory/Config.tar.gz ... ";
if (!system("cd $Home && tar -czf $Directory/Config.tar.gz Kernel/Config.pm Kernel/Config/Files/ZZZA*.pm Kernel/Config/GenericAgen*.pm")) {
    print "done\n";
}
else {
    print "failed\n";
}

# backup application
if ($FullBackup) {
    print "Backup $Directory/Application.tar.gz ... ";
    if (!system("cd $Home && tar -czf $Directory/Application.tar.gz .")) {
        print "done\n";
    }
    else {
        print "failed\n";
    }
}
# backup vardir
else {
    print "Backup $Directory/VarDir.tar.gz ... ";
    if (!system("cd $Home && tar -czf $Directory/VarDir.tar.gz var/")) {
        print "done\n";
    }
    else {
        print "failed\n";
    }
}
# backup datadir
if ($ArticleDir !~ /\Q$Home\E/) {
    print "Backup $Directory/DataDir.tar.gz ... ";
    if (!system("cd $ArticleDir && tar -czf $Directory/DataDir.tar.gz .")) {
        print "done\n";
    }
    else {
        print "failed\n";
    }
}

# backup database
if ($DB =~ /mysql/i) {
    print "Dump $DB rdbms ... ";
    if ($DatabasePw) {
        $DatabasePw = "-p$DatabasePw";
    }
    if (!system("$DBDump -u $DatabaseUser $DatabasePw -h $DatabaseHost $Database > $Directory/DatabaseBackup.sql")) {
        print "done\n";
    }
    else {
        print "failed\n";
    }
}
else {
    print "Dump $DB rdbms ... ";
    if (!system("$DBDump -f $Directory/DatabaseBackup.sql -h $DatabaseHost -U $DatabaseUser $Database")) {
        print "done\n";
    }
    else {
        print "failed\n";
    }
}
# compressing database
print "Compress SQL-file... ";
if (!system("$CompressCMD $Directory/DatabaseBackup.sql")) {
    print "done\n";
}
else {
    print "failed\n";
}

