#!/usr/bin/perl
# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use File::Spec qw(catfile);
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use Getopt::Std;

use Kernel::System::ObjectManager;

# get options
my %Opts;
my $DB     = '';
my $DBDump = '';
getopt( 'hbd', \%Opts );
if ( exists $Opts{h} ) {
    print "restore.pl - restore script\n";
    print "Copyright (C) 2001-2017 OTRS AG, http://otrs.com/\n";
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
my $ConfigBackupTar = File::Spec->catfile( $Opts{b}, 'Config.tar.gz' );
print "Restore $ConfigBackupTar ...\n";
chdir( $Opts{d} );
if ( -e $ConfigBackupTar ) {
    system("tar -xzf $ConfigBackupTar");
}

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-restore.pl',
    },
);

my $DatabaseHost = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseHost');
my $Database     = $Kernel::OM->Get('Kernel::Config')->Get('Database');
my $DatabaseUser = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseUser');
my $DatabasePw   = $Kernel::OM->Get('Kernel::Config')->Get('DatabasePw');
my $DatabaseDSN  = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN');
my $ArticleDir   = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Article::Backend::MIMEBase::ArticleDataDir');

# decrypt pw (if needed)
if ( $DatabasePw =~ m/^\{(.*)\}$/ ) {
    $DatabasePw = $Kernel::OM->Get('Kernel::System::DB')->_Decrypt($1);
}

# check db backup support
if ( $DatabaseDSN =~ m/:mysql/i ) {
    $DB     = 'MySQL';
    $DBDump = 'mysql';
}
elsif ( $DatabaseDSN =~ m/:pg/i ) {
    $DB     = 'PostgreSQL';
    $DBDump = 'psql';
    if ( $DatabaseDSN !~ m/host=/i ) {
        $DatabaseHost = ''
    }
}
else {
    print STDERR "ERROR: Can't backup, no database dump support!\n";
    exit 1;
}

# check needed programs
for my $CMD ( 'cp', 'tar', $DBDump ) {
    my $Installed = 0;
    open( my $Input, '-|', "which $CMD" );    ## no critic
    while (<$Input>) {
        $Installed = 1;
    }
    close $Input;
    if ( !$Installed ) {
        print STDERR "ERROR: Can't locate $CMD!\n";
        exit 1;
    }
}

# check database env
if ( $DB =~ m/mysql/i ) {
    $Kernel::OM->Get('Kernel::System::DB')->Prepare( SQL => "SHOW TABLES" );
    my $Check = 0;
    while ( my @RowTmp = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        $Check++;
    }
    if ($Check) {
        print STDERR
            "ERROR: Already existing tables in this database. A empty database is required for restore!\n";
        exit 1;
    }
}
else {
    $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL =>
            "SELECT table_name FROM information_schema.tables WHERE table_catalog = 'otrs' AND table_schema = 'public'",
    );
    my $Check = 0;
    while ( my @RowTmp = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        $Check++;
    }
    if ($Check) {
        print STDERR
            "ERROR: Already existing tables in this database. A empty database is required for restore!\n";
        exit 1;
    }
}

# restore
my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');
chdir($Home);

# extract application
my $ApplicationBackupTar = File::Spec->catfile( $Opts{b}, 'Application.tar.gz' );
if ( -e $ApplicationBackupTar ) {
    print "Restore $ApplicationBackupTar ...\n";
    system("tar -xzf $ApplicationBackupTar");
}

# extract vardir
my $VarDirBackupTar = File::Spec->catfile( $Opts{b}, 'VarDir.tar.gz' );
if ( -e $VarDirBackupTar ) {
    print "Restore $VarDirBackupTar ...\n";
    system("tar -xzf $VarDirBackupTar");
}

# extract datadir
my $DataDirBackupTar = File::Spec->catfile( $Opts{b}, 'DataDir.tar.gz' );
if ( -e $DataDirBackupTar ) {
    print "Restore $DataDirBackupTar ...\n";
    system("tar -xzf $DataDirBackupTar");
}

# import database
my $DatabaseBackupGz  = File::Spec->catfile( $Opts{b}, 'DatabaseBackup.sql.gz' );
my $DatabaseBackupBz2 = File::Spec->catfile( $Opts{b}, 'DatabaseBackup.sql.bz2' );
if ( $DB =~ m/mysql/i ) {
    print "create $DB\n";
    if ($DatabasePw) {
        $DatabasePw = "-p'$DatabasePw'";
    }
    if ( -e $DatabaseBackupGz ) {
        print "decompresses SQL-file ...\n";
        system("gunzip $DatabaseBackupGz");
        print "cat SQL-file into $DB database\n";
        system(
            "mysql -f -u$DatabaseUser $DatabasePw -h$DatabaseHost $Database < $Opts{b}/DatabaseBackup.sql"
        );
        print "compress SQL-file...\n";
        system("gzip $Opts{b}/DatabaseBackup.sql");
    }
    elsif ( -e $DatabaseBackupBz2 ) {
        print "decompresses SQL-file ...\n";
        system("bunzip2 $DatabaseBackupBz2");
        print "cat SQL-file into $DB database\n";
        system(
            "mysql -f -u$DatabaseUser $DatabasePw -h$DatabaseHost $Database < $Opts{b}/DatabaseBackup.sql"
        );
        print "compress SQL-file...\n";
        system("bzip2 $Opts{b}/DatabaseBackup.sql");
    }
}
else {
    if ($DatabaseHost) {
        $DatabaseHost = "-h $DatabaseHost"
    }

    if ( -e $DatabaseBackupGz ) {
        print "decompresses SQL-file ...\n";
        system("gunzip $DatabaseBackupGz");

        # set password via environment variable if there is one
        if ($DatabasePw) {
            $ENV{'PGPASSWORD'} = $DatabasePw;    ## no critic
        }
        print "cat SQL-file into $DB database\n";
        system(
            "cat $Opts{b}/DatabaseBackup.sql | psql -U$DatabaseUser $DatabaseHost $Database"
        );
        print "compress SQL-file...\n";
        system("gzip $Opts{b}/DatabaseBackup.sql");
    }
    elsif ( -e $DatabaseBackupBz2 ) {
        print "decompresses SQL-file ...\n";
        system("bunzip2 $DatabaseBackupBz2");

        # set password via environment variable if there is one
        if ($DatabasePw) {
            $ENV{'PGPASSWORD'} = $DatabasePw;    ## no critic
        }
        print "cat SQL-file into $DB database\n";
        system(
            "cat $Opts{b}/DatabaseBackup.sql | psql -U$DatabaseUser $DatabaseHost $Database"
        );
        print "compress SQL-file...\n";
        system("bzip2 $Opts{b}/DatabaseBackup.sql");
    }
}
