# --
# Syslog.pm - a wrapper for xyz::Syslog 
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Syslog.pm,v 1.4 2002-05-26 21:30:17 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Syslog;

use strict;
use Unix::Syslog qw(:macros);  # Syslog macros
use Unix::Syslog qw(:subs);  # Syslog functions

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $ ';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);
 
    $Self->{LogSuffix} = 'OpenTRS';

    openlog($Self->{LogSuffix}, LOG_PID, LOG_USER);

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
        print STDERR "[$Self->{LogSuffix}][Error][$Subroutine][Line:$Line][MSG:$MSG]\n";
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

