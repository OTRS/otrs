#!/usr/bin/perl
# --
# bin/otrs.SetPermissions.pl - to set the otrs permissions
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

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use File::Find;
use Getopt::Long;

print "bin/otrs.SetPermissions.pl - set OTRS file permissions\n";
print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";

my $Secure             = 0;
my $Version            = 0;
my $Help               = 0;
my $NotRoot            = 0;
my $AdminGroupWritable = 0;
my $OtrsUser           = '';
my $WebUser            = '';
my $AdminUser          = 'root';
my $OtrsGroup          = '';
my $WebGroup           = '';
my $AdminGroup         = 'root';

GetOptions(
    'secure'               => \$Secure,
    'not-root'             => \$NotRoot,
    'version'              => \$Version,
    'help'                 => \$Help,
    'admin-group-writable' => \$AdminGroupWritable,
    'otrs-user=s'          => \$OtrsUser,
    'web-user=s'           => \$WebUser,
    'admin-user=s'         => \$AdminUser,
    'otrs-group=s'         => \$OtrsGroup,
    'web-group=s'          => \$WebGroup,
    'admin-group=s'        => \$AdminGroup
);

if ($Version) {
    exit(0);
}
if ( $Help || $#ARGV < 0 ) {
    print <<EOF;
Usage: otrs.SetPermissions.pl
    [--otrs-user=<OTRS_USER>]
    [--web-user=<WEBSERVER_USER>]
    [--otrs-group=<OTRS_GROUP>]
    [--web-group=<WEB_GROUP>]
    [--admin-user=<ADMIN_USER>]
    [--admin-group=<ADMIN_GROUP>]
    [--admin-group-writable]
    [--secure]  (paranoid mode: all files readonly, does not work with PackageManager)
    [--not-root]
    <OTRS_HOME>

Try: otrs.SetPermissions.pl /opt/otrs
EOF

    if ( $#ARGV < 0 ) {
        exit 1;
    }
    else {
        exit 0;
    }
}
my $DestDir = $ARGV[0];

# check params
if ( !$OtrsUser ) {
    print STDERR "ERROR: --otrs-user=<OTRS_USER>\n";
    exit 1;
}
if ( !$WebUser ) {
    print STDERR "ERROR: --web-user=<WEBSERVER_USER>\n";
    exit 1;
}
if ( !$OtrsGroup ) {
    print STDERR "ERROR: --otrs-group=<OTRS_GROUP>\n";
    exit 1;
}
if ( !$WebGroup ) {
    print STDERR "ERROR: --web-group=<WEB_GROUP>\n";
    exit 1;
}

# Check that the users exist
my ( $WebUserID, $OtrsUserID, $AdminUserID );
if ( !$NotRoot ) {
    ( $WebUserID, $OtrsUserID, $AdminUserID ) = GetUserIDs( $WebUser, $OtrsUser, $AdminUser );
}

# Check that the groups exist
my ( $WebGroupID, $OtrsGroupID, $AdminGroupID );
if ( !$NotRoot ) {
    ( $WebGroupID, $OtrsGroupID, $AdminGroupID )
        = GetGroupIDs( $WebGroup, $OtrsGroup, $AdminGroup );
}

# set permissions
print "Setting permissions on $DestDir\n";
if ($Secure) {

    # In secure mode, make files read-only by default
    find( \&MakeReadOnly, $DestDir );
}
else {

    # set all files writeable for webserver user (needed for package manager)
    find( \&MakeWritable, $DestDir );

    # set the $HOME to the OTRS user
    if ( !$NotRoot ) {
        SafeChown( $OtrsUserID, $OtrsGroupID, $DestDir );
    }
}

# add empty files
my @EmptyFiles = (
    "$DestDir/var/log/TicketCounter.log",
);
for my $File (@EmptyFiles) {
    open( my $Fh, '>>', $File );    ## no critic
    print $Fh '';
    close $Fh;
}

# var/*

print "Setting permissions on $DestDir/var\n";

# set the var directory to OTRS and webserver user
my @Dirs = (
    "$DestDir/var/article",
    "$DestDir/var/log",
    "$DestDir/var/tmp",
    "$DestDir/var/spool",
    "$DestDir/var/stats",
    "$DestDir/var/sessions",

    # CSS cache directories
    "$DestDir/var/httpd/htdocs/skins/Agent",
    "$DestDir/var/httpd/htdocs/skins/Customer",
);
for my $Dir (@Dirs) {
    if ( !-e $Dir ) {
        mkdir $Dir;
    }
}
find( \&MakeWritableSetGid, @Dirs );

# set all bin/* as executable
print "Setting permissions on $DestDir/bin/*\n";
find( \&MakeExecutable, "$DestDir/bin" );

# set all scripts/* as executable
print "Setting permissions on $DestDir/scripts/*.pl\n";
my @FileListScripts = glob("$DestDir/scripts/*.pl");
for (@FileListScripts) {
    MakeExecutable();
}

# set all scripts/tools/* as executable
print "Setting permissions on $DestDir/scripts/tools/*.pl\n";
my @FileListTools = glob("$DestDir/scripts/tools/*.pl");
for (@FileListTools) {
    MakeExecutable();
}

# set write permission for web installer
if ( !$Secure ) {
    print "Setting permissions on Kernel/Config.pm\n";
    $_ = "$DestDir/Kernel/Config.pm";
    MakeWritable();
}

# set owner rw and group ro
@Dirs = (
    "$DestDir/",
    "$DestDir/.procmailrc",
    "$DestDir/.fetchmailrc",
);
for my $Dir (@Dirs) {
    if ( -e $Dir ) {
        print "Setting owner rw and group ro permissions on $Dir\n";
        $_ = $Dir;
        MakeReadOnly();
    }
}

exit(0);

## no critic (ProhibitLeadingZeros)

sub MakeReadOnly {
    my $File = $_;
    if ( !$NotRoot ) {
        SafeChown( $AdminUserID, $AdminGroupID, $File );
    }
    my $Mode;
    if ( -d $File ) {
        $Mode = 0755;
    }
    else {
        $Mode = 0644;
    }
    SafeChmod( $Mode, $File );
}

sub MakeWritable {
    my $File = $_;
    my $Mode;

    if ( -d $File ) {
        $Mode = 0775;
    }
    else {
        $Mode = 0664;
    }
    if ($NotRoot) {
        $Mode |= 2;
        SafeChmod( $Mode, $File );
    }
    else {
        SafeChown( $OtrsUserID, $WebGroupID, $File );
        SafeChmod( $Mode, $File );
    }
}

sub MakeWritableSetGid {
    my $File = $_;
    my $Mode;

    if ( -d $File ) {
        $Mode = 02775;
    }
    else {
        $Mode = 0664;
    }
    if ($NotRoot) {
        $Mode |= 2;
        SafeChmod( $Mode, $File );
    }
    else {
        SafeChown( $OtrsUserID, $WebGroupID, $File );
        SafeChmod( $Mode, $File );
    }
}

sub MakeExecutable {
    my $File = $_;
    my $Mode = ( lstat($File) )[2];
    if ( defined $Mode ) {
        $Mode |= 0111;
        SafeChmod( $Mode, $File );
    }
}

sub GetUserIDs {
    my @IDs;
    my @Arguments = @_;
    for my $User (@Arguments) {
        my $ID = getpwnam $User;
        if ( !defined $ID ) {
            print "User \"$User\" does not exist!\n";
            exit(1);
        }
        push @IDs, $ID;
    }
    return @IDs;
}

sub GetGroupIDs {
    my @IDs;
    for my $Group (@_) {
        my $ID = getgrnam $Group;
        if ( !defined $ID ) {
            print "Group \"$Group\" does not exist!\n";
            exit(1);
        }
        push @IDs, $ID;
    }
    return @IDs;
}

sub SafeChown {
    my ( $User, $Group, $File ) = @_;
    if ( !chown( $User, $Group, $File ) ) {
        die("Error in chown $User $Group $File: $!\n");
    }
}

sub SafeChmod {
    my ( $Mode, $File ) = @_;
    if ( !chmod( $Mode, $File ) ) {
        die("Error in chmod $Mode $File: $!\n");
    }
}
