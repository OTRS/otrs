# --
# Syslog.pm - a wrapper for xyz::Syslog 
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Log.pm,v 1.3 2002-06-15 10:40:35 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Log;

use strict;
use Sys::Syslog qw(:DEFAULT setlogsock);

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $ ';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);
 
    $Self->{LogPrefix} = $Param{LogPrefix} || '?LogPrefix?';

    return $Self;
}
# --
sub Log { 
    my $Self = shift;
    my %Param = @_;
    my $Program = $Param{Program};
    my $Priority = $Param{Priority} || 'debug';
    my $MSG = $Param{MSG} || $Param{Message} || '???';

    setlogsock('unix');
    openlog($Self->{LogPrefix}, 'cons,pid', 'user');

    if ($Priority =~ /debug/i) {
        my ($Package, $Filename, $Line, $Subroutine, $Hasargs) = caller(1);
        syslog('debug', "[Debug][$Subroutine][$Line] $MSG");
    }
    elsif ($Priority =~ /info/i) {
        my ($Package, $Filename, $Line, $Subroutine, $Hasargs) = caller(1);
        syslog('info', "[Info][$Subroutine] $MSG");
    }
    elsif ($Priority =~ /notice/i) {
        my ($Package, $Filename, $Line, $Subroutine, $Hasargs) = caller(1);
        syslog('notice', "[Notice][$Subroutine] $MSG");
    }
    elsif ($Priority =~ /error/i) {
        my ($Package, $Filename, $Line, $Subroutine, $Hasargs) = caller(1);
        # print error messages to STDERR
        print STDERR "[$Self->{LogPrefix}][Error][$Subroutine][Line:$Line][MSG:$MSG]\n";
        # and of coure to syslog
        syslog('err', "[Error][$Subroutine][Line:$Line]: $MSG");
    }
    else {
        my ($Package, $Filename, $Line, $Subroutine, $Hasargs) = caller(1);
        syslog('err', "[Error][$Subroutine] Priority: '$Param{Priority}' not defined! MSG: $MSG");
    }
    closelog();
    return;
}
# --
sub DESTROY {
    my $Self = shift;
#    closelog();
}
# --
1;

