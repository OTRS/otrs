# --
# Kernel/System/Log/SysLog.pm - a wrapper for xyz::Syslog 
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SysLog.pm,v 1.3 2002-10-31 22:01:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Log::SysLog;

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
    my ($Package1, $Filename1, $Line1, $Subroutine1) = caller($Caller+1);
    my ($Package2, $Filename2, $Line2, $Subroutine2) = caller($Caller+2);
    my ($Package3, $Filename3, $Line3, $Subroutine3) = caller($Caller+3);
    if (!$Subroutine3) {
      $Subroutine3 = $0;
    }
    if (!$Subroutine2) {
      $Subroutine2 = $0;
    }
    # --
    # start syslog connect
    # --
    setlogsock('unix');
    openlog($Self->{LogPrefix}, 'cons,pid', 'user');

    if ($Priority =~ /debug/i) {
        syslog('debug', "[Debug][$Subroutine2][$Line1] $MSG");
    }
    elsif ($Priority =~ /info/i) {
        syslog('info', "[Info][$Subroutine2] $MSG");
    }
    elsif ($Priority =~ /notice/i) {
        syslog('notice', "[Notice][$Subroutine2] $MSG");
    }
    elsif ($Priority =~ /error/i) {
        # --
        # print error messages also to STDERR
        # --
        my $PID = $$;
        print STDERR "[".localtime()."]\n";
        print STDERR "[$Self->{LogPrefix}-$PID][Error][1:$Subroutine3][Line:$Line2]\n";
        print STDERR "[$Self->{LogPrefix}-$PID][Error][0:$Subroutine2][Line:$Line1] $MSG\n";
        # --
        # and of course to syslog
        # --
        syslog('err', "[Error][$Subroutine2][Line:$Line1]: $MSG");
        # --
        # store data (for the frontend)
        # --
        $Self->{Error}->{Message} = $MSG;
        $Self->{Error}->{Subroutine} = $Subroutine2;
        $Self->{Error}->{Line} = $Line1;
        $Self->{Error}->{Version} = eval("\$$Package1". '::VERSION');
    }
    else {
        # print error messages to STDERR
        print STDERR "[Error][$Subroutine2] Priority: '$Param{Priority}' not defined! MSG: $MSG\n";
        # and of course to syslog
        syslog('err', "[Error][$Subroutine2] Priority: '$Param{Priority}' not defined! MSG: $MSG");
    }
    # --
    # close syslog request
    # --
    closelog();
    return;
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

