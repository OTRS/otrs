# --
# Kernel/System/Log.pm - a wrapper for xyz::Syslog 
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Log.pm,v 1.6 2002-07-15 22:18:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Log;

use strict;
use Sys::Syslog qw(:DEFAULT setlogsock);

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $ ';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/g;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # set log prefix 
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
    my $Caller = $Param{Caller} || 0;

    # --
    # returns the context of the current subroutine and sub-subroutine!
    # --
    my ($Package, $Filename, $Line, $Subroutine) = caller($Caller);
    my ($Package1, $Filename1, $Line1, $Subroutine1) = caller($Caller+1);
    my ($Package2, $Filename2, $Line2, $Subroutine2) = caller($Caller+2);
    if (!$Subroutine1) {
      $Subroutine1 = $0;
    }
    # --
    # start syslog connect
    # --
    setlogsock('unix');
    openlog($Self->{LogPrefix}, 'cons,pid', 'user');

    if ($Priority =~ /debug/i) {
        syslog('debug', "[Debug][$Subroutine1][$Line] $MSG");
    }
    elsif ($Priority =~ /info/i) {
        syslog('info', "[Info][$Subroutine1] $MSG");
    }
    elsif ($Priority =~ /notice/i) {
        syslog('notice', "[Notice][$Subroutine1] $MSG");
    }
    elsif ($Priority =~ /error/i) {
        # --
        # print error messages also to STDERR
        # --
        my $PID = $$;
        print STDERR "[$Self->{LogPrefix}-$PID][Error][1:$Subroutine2][Line:$Line1]\n";
        print STDERR "[$Self->{LogPrefix}-$PID][Error][0:$Subroutine1][Line:$Line] $MSG\n";
        # --
        # and of course to syslog
        # --
        syslog('err', "[Error][$Subroutine1][Line:$Line]: $MSG");
        # --
        # store data (or the frontend)
        # --
        $Self->{Error}->{Message} = $MSG;
        $Self->{Error}->{Subroutine} = $Subroutine1;
        $Self->{Error}->{Line} = $Line;
        $Self->{Error}->{Version} = eval("\$$Package". '::VERSION');
    }
    else {
        # print error messages to STDERR
        print STDERR "[Error][$Subroutine1] Priority: '$Param{Priority}' not defined! MSG: $MSG\n";
        # and of course to syslog
        syslog('err', "[Error][$Subroutine1] Priority: '$Param{Priority}' not defined! MSG: $MSG");
    }
    # --
    # close syslog request
    # --
    closelog();
    return;
}
# --
sub Error {
    my $Self = shift;
    my $What = shift;
    return $Self->{Error}->{$What} || ''; 
}
# --
sub DESTROY {
    my $Self = shift;
    # delete data
    foreach (qw(Message Subroutine Line Version)) {
      $Self->{Error}->{$_} = undef;
    }
}
# --
1;

