# --
# Syslog.pm - a wrapper for xyz::Syslog 
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Log.pm,v 1.1 2002-06-08 17:42:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Log;

use strict;
use Unix::Syslog qw(:macros);  # Syslog macros
use Unix::Syslog qw(:subs);  # Syslog functions

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $ ';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);
 
    $Self->{LogPrefix} = $Param{LogPrefix} || '?LogPrefix?';

    openlog($Self->{LogPrefix}, LOG_PID, LOG_USER);

    return $Self;
}
# --
sub Log { 
    my $Self = shift;
    my %Param = @_;
    my $Program = $Param{Program};
    my $Priority = $Param{Priority} || 'debug';
    my $MSG = $Param{MSG} || $Param{Message} || '???';

    if ($Priority =~ /debug/i) {
        my ($Package, $Filename, $Line, $Subroutine, $Hasargs) = caller(0);
        syslog(LOG_DEBUG, "[Debug][$Subroutine][$Line] $MSG");
    }
    elsif ($Priority =~ /info/i) {
        my ($Package, $Filename, $Line, $Subroutine, $Hasargs) = caller(1);
        syslog(LOG_INFO, "[Info][$Subroutine] $MSG");
    }
    elsif ($Priority =~ /notice/i) {
        my ($Package, $Filename, $Line, $Subroutine, $Hasargs) = caller(0);
        syslog(LOG_NOTICE, "[Notice][$Subroutine] $MSG");
    }
    elsif ($Priority =~ /error/i) {
        my ($Package, $Filename, $Line, $Subroutine, $Hasargs) = caller(1);
        # print error messages to STDERR
        print STDERR "[$Self->{LogPrefix}][Error][$Subroutine][Line:$Line][MSG:$MSG]\n";
        # and of coure to syslog
        syslog(LOG_ERR, "[Error][$Subroutine][Line:$Line]: $MSG");
    }
    else {
        my ($Package, $Filename, $Line, $Subroutine, $Hasargs) = caller(1);
        syslog(LOG_ERR, "[Error][$Subroutine] Priority: '$Param{Priority}' not defined! MSG: $MSG");
    }

    return;
}
# --
sub DESTROY {
    my $Self = shift;
    closelog();
}
# --
1;

