# --
# Kernel/System/Log/SysLog.pm - a wrapper for xyz::Syslog 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SysLog.pm,v 1.6 2003-02-08 15:09:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Log::SysLog;

use strict;
use Sys::Syslog qw(:DEFAULT setlogsock);

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    return $Self;
}
# --
sub Log { 
    my $Self = shift;
    my %Param = @_;
    # --
    # start syslog connect
    # --
    setlogsock('unix');
    openlog($Param{LogPrefix}, 'cons,pid', 'user');

    if ($Param{Priority} =~ /debug/i) {
        syslog('debug', "[Debug][$Param{Module}][$Param{Line}] $Param{Message}");
    }
    elsif ($Param{Priority} =~ /info/i) {
        syslog('info', "[Info][$Param{Module}] $Param{Message}");
    }
    elsif ($Param{Priority} =~ /notice/i) {
        syslog('notice', "[Notice][$Param{Module}] $Param{Message}");
    }
    elsif ($Param{Priority} =~ /error/i) {
        syslog('err', "[Error][$Param{Module}][Line:$Param{Line}]: $Param{Message}");
    }
    else {
        # print error messages to STDERR
        print STDERR "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}\n";
        # and of course to syslog
        syslog('err', "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}");
    }
    # --
    # close syslog request
    # --
    closelog();
    return;
}
# --
sub GetLog { 
    my $Self = shift;
    my %Param = @_;
    return 'Not supported by Kernel::System::Log::SysLog!';
}
# --
1;
