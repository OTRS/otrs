#!/usr/bin/perl -w
# --
# SetPermissions.pl - to set the otrs permissions
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: SetPermissions.pl,v 1.7 2009-07-10 22:03:19 martin Exp $
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

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

print "bin/SetPermissions.pl <$VERSION> - set OTRS file permissions\n";
print "Copyright (C) 2001-2009 OTRS AG, http://otrs.org/\n";

use File::Find;
use Getopt::Long;

my $Secure             = 0;
my $Version            = 0;
my $Help               = 0;
my $NotRoot            = 0;
my $AdminGroupWritable = 0;
my $OtrsUser           = 'otrs';
my $WebUser            = 'otrs';
my $AdminUser          = 'root';
my $OtrsGroup          = 'nogroup';
my $WebGroup           = 'nogroup';
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
Usage: SetPermissions.pl
    [--otrs-user=<OTRS_USER>]
    [--web-user=<WEBSERVER_USER>]
    [--otrs-group=<OTRS_GROUP>]
    [--web-group=<WEB_GROUP>]
    [--admin-user=<ADMIN_USER>]
    [--admin-group=<ADMIN_GROUP>]
    [--admin-group-writable]
    [--secure]
    [--not-root]
    <OTRS_HOME>

Try: SetPermissions.pl /opt/otrs
EOF

    if ( $#ARGV < 0 ) {
        exit 1;
    }
    else {
        exit 0;
    }
}
my $DestDir = $ARGV[0];

# Check that the users exist
my ( $WebUserId, $OtrsUserId, $AdminUserId );
if ( !$NotRoot ) {
    ( $WebUserId, $OtrsUserId, $AdminUserId ) = getUserIDs( $WebUser, $OtrsUser, $AdminUser );
}

# Check that the groups exist
my ( $WebGroupId, $OtrsGroupId, $AdminGroupId );
if ( !$NotRoot ) {
    ( $WebGroupId, $OtrsGroupId, $AdminGroupId )
        = getGroupIDs( $WebGroup, $OtrsGroup, $AdminGroup );
}

# set permissions
print "Setting permissions on $DestDir\n";
if ($Secure) {

    # In secure mode, make files read-only by default
    find( \&makeReadOnly, $DestDir );
}
else {

    # set all files writeabel for webserver user (needed for package manager)
    find( \&makeWritable, $DestDir );

    # set the $HOME to the OTRS user
    if ( !$NotRoot ) {
        safeChown( $OtrsUserId, $OtrsGroupId, $DestDir );
    }
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
    "$DestDir/var/sessions"
);
for my $Dir (@Dirs) {
    if ( !-e $Dir ) {
        mkdir $Dir;
    }
}
find( \&makeWritableSetGid, @Dirs );

# add empty files
my @EmptyFiles = (
    "$DestDir/var/log/TicketCounter.log",
);
for my $File (@EmptyFiles) {
    open( my $Fh, '>>', $File );
    print $Fh '';
    close $Fh;
}

# set all bin/* as executable
print "Setting permissions on $DestDir/bin/*\n";
find( \&makeExecutable, "$DestDir/bin" );

# set all bin/* as executable
print "Setting permissions on $DestDir/scripts/*.pl\n";
my @FileList = glob( "$DestDir/scripts/*.pl" );
for (@FileList) {
    makeExecutable();
}

# set write permission for web installer
if ( !$Secure ) {
    print "Setting permissions on Kernel/Config.pm\n";
    $_ = "$DestDir/Kernel/Config.pm";
    makeWritable();
}

# set owner rw and group ro
@Dirs = (
    "$DestDir/",
    "$DestDir/.procmailrc",
    "$DestDir/.fetchmailrc",
);
for my $Dir (@Dirs) {
    print "Setting owner rw and group ro permissions on $Dir\n";
    $_ = $Dir;
    makeReadOnly();
}

exit(0);

sub makeReadOnly {
    my $File = $_;
    if ( !$NotRoot ) {
        safeChown( $AdminUserId, $AdminGroupId, $File );
    }
    my $Mode;
    if ( -d $File ) {
        $Mode = 0755;
    }
    else {
        $Mode = 0644;
    }
    safeChmod( $Mode, $File );
}

sub makeWritable {
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
        safeChmod( $Mode, $File );
    }
    else {
        safeChown( $OtrsUserId, $WebGroupId, $File );
        safeChmod( $Mode, $File );
    }
}

sub makeWritableSetGid {
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
        safeChmod( $Mode, $File );
    }
    else {
        safeChown( $OtrsUserId, $WebGroupId, $File );
        safeChmod( $Mode, $File );
    }
}

sub makeExecutable {
    my $File = $_;
    my $Mode = ( lstat($File) )[2];
    if ( defined $Mode ) {
        $Mode |= 0111;
        safeChmod( $Mode, $File );
    }
}

sub getUserIDs {
    my @Ids;
    my @args = @_;
    for my $User (@args) {
        my $Id = getpwnam $User;
        if ( !defined $Id ) {
            print "User \"$User\" does not exist!\n";
            exit(1);
        }
        push @Ids, $Id;
    }
    return @Ids;
}

sub getGroupIDs {
    my @Ids;
    for my $Group (@_) {
        my $Id = getgrnam $Group;
        if ( !defined $Id ) {
            print "Group \"$Group\" does not exist!\n";
            exit(1);
        }
        push @Ids, $Id;
    }
    return @Ids;
}

sub safeChown {
    my ( $User, $Group, $File ) = @_;
    if ( !chown( $User, $Group, $File ) ) {
        die("Error in chown $User $Group $File: $!\n");
    }
}

sub safeChmod {
    my ( $Mode, $File ) = @_;
    if ( !chmod( $Mode, $File ) ) {
        die("Error in chmod $Mode $File: $!\n");
    }
}
