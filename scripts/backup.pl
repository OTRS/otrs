#!/usr/bin/perl
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use Getopt::Std;

use Kernel::System::ObjectManager;

# get options
my %Opts;
my $Compress    = '';
my $CompressCMD = '';
my $CompressEXT = '';
my $DB          = '';
my $DBDump      = '';
getopt( 'hcrtd', \%Opts );

if ( exists $Opts{h} ) {
    print <<EOF;

Backup an OTRS system.

Usage:
 backup.pl -d /data_backup_dir [-c gzip|bzip2] [-r DAYS] [-t fullbackup|nofullbackup|dbonly]

Options:
 -d                     - Directory where the backup files should place to.
 [-c]                   - Select the compression method (gzip|bzip2). Default: gzip.
 [-r DAYS]              - Remove backups which are more than DAYS days old.
 [-t]                   - Specify which data will be saved (fullbackup|nofullbackup|dbonly). Default: fullbackup.
 [-h]                   - Display help for this command.

Help:
Using -t fullbackup saves the database and the whole OTRS home directory (except /var/tmp and cache directories).
Using -t nofullbackup saves only the database, /Kernel/Config* and /var directories.
With -t dbonly only the database will be saved.

Output:
 Config.tar.gz          - Backup of /Kernel/Config* configuration files.
 Application.tar.gz     - Backup of application file system (in case of full backup).
 VarDir.tar.gz          - Backup of /var directory (in case of no full backup).
 DataDir.tar.gz         - Backup of article files.
 DatabaseBackup.sql.gz  - Database dump.

EOF
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
    $CompressEXT = 'bz2';
}
else {
    $Compress    = 'z';
    $CompressCMD = 'gzip';
    $CompressEXT = 'gz';
}

# check backup type
my $DBOnlyBackup = 0;
my $FullBackup   = 0;

if ( $Opts{t} && $Opts{t} eq 'dbonly' ) {
    $DBOnlyBackup = 1;
}
elsif ( $Opts{t} && $Opts{t} eq 'nofullbackup' ) {
    $FullBackup = 0;
}
else {
    $FullBackup = 1;
}

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-backup.pl',
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
    $DBDump = 'mysqldump';
}
elsif ( $DatabaseDSN =~ m/:pg/i ) {
    $DB     = 'PostgreSQL';
    $DBDump = 'pg_dump';
    if ( $DatabaseDSN !~ m/host=/i ) {
        $DatabaseHost = '';
    }
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

# create new backup directory
my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# append trailing slash to home directory, if it's missing
if ( $Home !~ m{\/\z} ) {
    $Home .= '/';
}

chdir($Home);

# create directory name - this looks like 2013-09-09_22-19'
my $SystemDTObject = $Kernel::OM->Create('Kernel::System::DateTime');
my $Directory      = $SystemDTObject->Format(
    Format => $Opts{d} . '/%Y-%m-%d_%H-%M',
);

if ( !mkdir($Directory) ) {
    die "ERROR: Can't create directory: $Directory: $!\n";
}

# backup application
if ($DBOnlyBackup) {
    print "Backup of filesystem data disabled by parameter dbonly ... \n";
}
else {
    # backup Kernel/Config.pm
    print "Backup $Directory/Config.tar.$CompressEXT ... ";
    if ( !system("tar -c -$Compress -f $Directory/Config.tar.$CompressEXT Kernel/Config*") ) {
        print "done\n";
    }
    else {
        print "failed\n";
        RemoveIncompleteBackup($Directory);
        die "Backup failed\n";
    }

    if ($FullBackup) {
        print "Backup $Directory/Application.tar.$CompressEXT ... ";
        my $Excludes = "--exclude=var/tmp --exclude=js-cache --exclude=css-cache --exclude=.git";
        if ( !system("tar $Excludes -c -$Compress -f $Directory/Application.tar.$CompressEXT .") ) {
            print "done\n";
        }
        else {
            print "failed\n";
            RemoveIncompleteBackup($Directory);
            die "Backup failed\n";
        }
    }

    # backup vardir
    else {
        print "Backup $Directory/VarDir.tar.$CompressEXT ... ";
        if ( !system("tar -c -$Compress -f $Directory/VarDir.tar.$CompressEXT var/") ) {
            print "done\n";
        }
        else {
            print "failed\n";
            RemoveIncompleteBackup($Directory);
            die "Backup failed\n";
        }
    }

    # backup datadir
    if ( $ArticleDir !~ m/\A\Q$Home\E/ ) {
        print "Backup $Directory/DataDir.tar.$CompressEXT ... ";
        if ( !system("tar -c -$Compress -f $Directory/DataDir.tar.$CompressEXT $ArticleDir") ) {
            print "done\n";
        }
        else {
            print "failed\n";
            RemoveIncompleteBackup($Directory);
            die "Backup failed\n";
        }
    }
}

# backup database
my $ErrorIndicationFileName =
    $Kernel::OM->Get('Kernel::Config')->Get('Home')
    . '/var/tmp/'
    . $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString();
if ( $DB =~ m/mysql/i ) {
    print "Dump $DB data to $Directory/DatabaseBackup.sql.$CompressEXT ... ";
    if ($DatabasePw) {
        $DatabasePw = "-p'$DatabasePw'";
    }
    if (
        !system(
            "( $DBDump -u $DatabaseUser $DatabasePw -h $DatabaseHost $Database || touch $ErrorIndicationFileName ) | $CompressCMD > $Directory/DatabaseBackup.sql.$CompressEXT"
        )
        && !-f $ErrorIndicationFileName
        )
    {
        print "done\n";
    }
    else {
        print "failed\n";
        if ( -f $ErrorIndicationFileName ) {
            unlink $ErrorIndicationFileName;
        }
        RemoveIncompleteBackup($Directory);
        die "Backup failed\n";
    }
}
else {
    print "Dump $DB data to $Directory/DatabaseBackup.sql ... ";

    # set password via environment variable if there is one
    if ($DatabasePw) {
        $ENV{'PGPASSWORD'} = $DatabasePw;    ## no critic
    }

    if ($DatabaseHost) {
        $DatabaseHost = "-h $DatabaseHost";
    }

    if (
        !system(
            "( $DBDump $DatabaseHost -U $DatabaseUser $Database || touch $ErrorIndicationFileName ) | $CompressCMD > $Directory/DatabaseBackup.sql.$CompressEXT"
        )
        && !-f $ErrorIndicationFileName
        )
    {
        print "done\n";
    }
    else {
        print "failed\n";
        if ( -f $ErrorIndicationFileName ) {
            unlink $ErrorIndicationFileName;
        }
        RemoveIncompleteBackup($Directory);
        die "Backup failed\n";
    }
}

# remove old backups only after everything worked well
if ( defined $Opts{r} ) {
    my %LeaveBackups;

    # we'll be substracting days to the current time
    # we don't want DST changes to affect our dates
    # if it is < 2:00 AM, add two hours so we're sure DST will not change our timestamp
    # to another day
    if ( $SystemDTObject->Get()->{Hour} < 2 ) {
        $SystemDTObject->Add( Hours => 2 );
    }

    for ( 0 .. $Opts{r} ) {

        # legacy, old directories could be in the format 2013-4-8
        my @LegacyDirFormats = (
            '%04d-%01d-%01d',
            '%04d-%02d-%01d',
            '%04d-%01d-%02d',
            '%04d-%02d-%02d',
        );

        my $SystemDTDetails = $SystemDTObject->Get();
        for my $LegacyFirFormat (@LegacyDirFormats) {
            my $Dir = sprintf(
                $LegacyFirFormat,
                $SystemDTDetails->{Year},
                $SystemDTDetails->{Month},
                $SystemDTDetails->{Day},
            );
            $LeaveBackups{$Dir} = 1;
        }

        # substract one day
        $SystemDTObject->Subtract( Days => 1 );
    }

    my @Directories = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Opts{d},
        Filter    => '*',
    );

    DIRECTORY:
    for my $Directory (@Directories) {
        next DIRECTORY if !-d $Directory;
        my $Leave = 0;
        for my $Data ( sort keys %LeaveBackups ) {
            if ( $Directory =~ m/$Data/ ) {
                $Leave = 1;
            }
        }
        if ( !$Leave ) {

            # remove files and directory
            print "deleting old backup in $Directory ... ";
            my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
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

# If error occurs this functions remove incomlete backup folder to avoid the impression
#   that the backup was ok (see http://bugs.otrs.org/show_bug.cgi?id=10665).
sub RemoveIncompleteBackup {

    # get parameters
    my $Directory = shift;

    # remove files and directory
    print STDERR "Deleting incomplete backup $Directory ... ";
    my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Directory,
        Filter    => '*',
    );
    for my $File (@Files) {
        if ( -e $File ) {
            unlink $File;
        }
    }
    if ( rmdir($Directory) ) {
        print STDERR "done\n";
    }
    else {
        print STDERR "failed\n";
    }

    return;
}
