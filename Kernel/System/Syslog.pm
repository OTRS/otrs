# --
# Syslog.pm - a wrapper for xyz::Syslog 
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Syslog.pm,v 1.1 2001-12-02 14:36:43 martin Exp $
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
$VERSION = '$Revision: 1.1 $ ';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    openlog("OpenTRS", LOG_PID, LOG_USER);

    return $Self;
}
# --
sub Log { 
    my $Self = shift;
    my %Param = @_;
    my $Program = $Param{Program};
    my $Priority = $Param{Priority} || 'debug';
    my $MSG = $Param{MSG} || '???';

    if ($Priority =~ /debug/i) {
        syslog(LOG_DEBUG, $MSG);
    }
    elsif ($Priority =~ /info/i) {
        syslog(LOG_INFO, $MSG);
    }
    elsif ($Priority =~ /notice/i) {
        syslog(LOG_NOTICE, $MSG);
    }
    elsif ($Priority =~ /error/i) {
        syslog(LOG_ERR, $MSG);
    }
    else {
        syslog(LOG_ERR, "Priority: '$Param{Priority}' not defined! MSG: $MSG");
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

