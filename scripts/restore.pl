#!/usr/bin/perl -w
# --
# scripts/restore.pl - the restore script
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: restore.pl,v 1.10 2009-02-26 11:10:53 tr Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

use Getopt::Std;

# get options
my %Opts   = ();
my $DB     = '';
my $DBDump = '';
getopt( 'hbd', \%Opts );
if ( $Opts{h} ) {
    print "restore.pl <Revision $VERSION> - restore script\n";
    print "Copyright (c) 2001-2009 OTRS AG, http://otrs.org/\n";
    print "usage: restore.pl -b /data_backup/<TIME>/ -d /opt/otrs/\n";
    exit 1;
}
if ( !$Opts{b} ) {
    print STDERR "ERROR: Need -b for backup directory\n";
    exit 1;
}
elsif ( !-d $Opts{b} ) {
    print STDERR "ERROR: No such directory: $Opts{b}\n";
    exit 1;
}
if ( !$Opts{d} ) {
    print STDERR "ERROR: Need -d for destination directory\n";
    exit 1;
}
elsif ( !-d $Opts{d} ) {
    print STDERR "ERROR: No such directory: $Opts{d}\n";
    exit 1;
}

# restore config
print "Restore $Opts{'b'}/Config.tar.gz ...\n";
chdir( $Opts{d} );
if ( -e "$Opts{b}/Config.tar.gz" ) {
    system("tar -xzf $Opts{b}/Config.tar.gz");
}

require Kernel::Config;
require Kernel::System::Time;
require Kernel::System::Log;
require Kernel::System::Main;
require Kernel::System::DB;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-Restore',
    %CommonObject,
);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
my $DatabaseHost = $CommonObject{ConfigObject}->Get('DatabaseHost');
my $Database     = $CommonObject{ConfigObject}->Get('Database');
my $DatabaseUser = $CommonObject{ConfigObject}->Get('DatabaseUser');
my $DatabasePw   = $CommonObject{ConfigObject}->Get('DatabasePw');
my $DatabaseDSN  = $CommonObject{ConfigObject}->Get('DatabaseDSN');
my $ArticleDir   = $CommonObject{ConfigObject}->Get('ArticleDir');

# check db backup support
if ( $DatabaseDSN =~ /:mysql/i ) {
    $DB     = 'MySQL';
    $DBDump = 'mysql';
}
elsif ( $DatabaseDSN =~ /:pg/i ) {
    $DB     = 'PostgreSQL';
    $DBDump = 'psql';
}
else {
    print STDERR "ERROR: Can't backup, no database dump support!\n";
    exit 1;
}

# check needed programs
for my $CMD ( 'cp', 'tar', $DBDump ) {
    my $Installed = 0;
    open( IN, "which $CMD | " );
    while (<IN>) {
        $Installed = 1;
    }
    close IN;
    if ( !$Installed ) {
        print STDERR "ERROR: Can't locate $CMD!\n";
        exit 1;
    }
}

# check database env
if ( $CommonObject{DBObject} ) {
    if ( $DB =~ /mysql/i ) {
        $CommonObject{DBObject}->Prepare( SQL => "SHOW TABLES" );
        my $Check = 0;
        while ( my @RowTmp = $CommonObject{DBObject}->FetchrowArray() ) {
            $Check++;
        }
        if ($Check) {
            print STDERR
                "ERROR: Already existing tables in this database. A empty database is required for restore!\n";
            exit 1;
        }
    }
    else {
        $CommonObject{DBObject}->Prepare(
            SQL =>
                "SELECT table_name FROM information_schema.tables WHERE table_catalog = 'otrs' AND table_schema = 'public'",
        );
        my $Check = 0;
        while ( my @RowTmp = $CommonObject{DBObject}->FetchrowArray() ) {
            $Check++;
        }
        if ($Check) {
            print STDERR
                "ERROR: Already existing tables in this database. A empty database is required for restore!\n";
            exit 1;
        }
    }
}

# restore
my $Home = $CommonObject{ConfigObject}->Get('Home');
chdir($Home);

# backup application
if ( -e "$Opts{b}/Application.tar.gz" ) {
    print "Restore $Opts{b}/Application.tar.gz ...\n";
    system("tar -xzf $Opts{b}/Application.tar.gz");
}

# backup vardir
if ( -e "$Opts{b}/VarDir.tar.gz" ) {
    print "Restore $Opts{b}/VarDir.tar.gz ...\n";
    system("tar -xzf $Opts{b}/VarDir.tar.gz");
}

# backup datadir
if ( -e "$Opts{b}/DataDir.tar.gz" ) {
    print "Restore $Opts{b}/DataDir.tar.gz ...\n";
    system("tar -xzf $Opts{b}/DataDir.tar.gz");
}

# backup database
if ( $DB =~ /mysql/i ) {
    print "create $DB\n";
    if ($DatabasePw) {
        $DatabasePw = "-p$DatabasePw";
    }
    if ( -e "$Opts{b}/DatabaseBackup.sql.gz" ) {
        print "decompresses SQL-file ...\n";
        system("gunzip $Opts{'b'}/DatabaseBackup.sql.gz");
        print "cat SQL-file into $DB database\n";
        system(
            "mysql -f -u$DatabaseUser $DatabasePw -h$DatabaseHost $Database < $Opts{b}/DatabaseBackup.sql"
        );
        print "compress SQL-file...\n";
        system("gzip $Opts{b}/DatabaseBackup.sql");
    }
    elsif ( -e "$Opts{b}/DatabaseBackup.sql.bz2" ) {
        print "decompresses SQL-file ...\n";
        system("bunzip $Opts{b}/DatabaseBackup.sql.bz2");
        print "cat SQL-file into $DB database\n";
        system(
            "mysql -f -u$DatabaseUser $DatabasePw -h$DatabaseHost $Database < $Opts{b}/DatabaseBackup.sql"
        );
        print "compress SQL-file...\n";
        system("bzip $Opts{b}/DatabaseBackup.sql");
    }
}
else {
    if ( -e "$Opts{b}/DatabaseBackup.sql.gz" ) {
        print "decompresses SQL-file ...\n";
        system("gunzip $Opts{b}/DatabaseBackup.sql.gz");
        print "cat SQL-file into $DB database\n";
        system(
            "cat $Opts{b}/DatabaseBackup.sql | psql -U$DatabaseUser -W$DatabasePw -h$DatabaseHost $Database"
        );
        print "compress SQL-file...\n";
        system("gzip $Opts{b}/DatabaseBackup.sql");
    }
    elsif ( -e "$Opts{b}/DatabaseBackup.sql.bz2" ) {
        print "decompresses SQL-file ...\n";
        system("bunzip $Opts{b}/DatabaseBackup.sql.bz2");
        print "cat SQL-file into $DB database\n";
        system(
            "cat $Opts{b}/DatabaseBackup.sql | psql -U$DatabaseUser -W$DatabasePw -h$DatabaseHost $Database"
        );
        print "compress SQL-file...\n";
        system("bzip $Opts{b}/DatabaseBackup.sql");
    }
}
