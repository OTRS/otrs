# --
# Kernel/System/Log/SysLog.pm - a wrapper for Sys::Syslog or xyz::Syslog
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: SysLog.pm,v 1.18 2009-03-18 18:49:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Log::SysLog;

use strict;
use warnings;

use Sys::Syslog qw(:DEFAULT setlogsock);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject EncodeObject)) {
        if ( $Param{$_} ) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }

    # set syslog facility
    $Self->{SysLogFacility} = $Param{ConfigObject}->Get('LogModule::SysLog::Facility') || 'user';

    return $Self;
}

sub Log {
    my ( $Self, %Param ) = @_;

    # convert Message because syslog can't work with utf-8
    if ( $Self->{ConfigObject}->Get('DefaultCharset') =~ /^utf(-8|8)$/i ) {
        $Param{Message} = $Self->{EncodeObject}->Convert(
            Text  => $Param{Message},
            From  => 'utf8',
            To    => $Self->{ConfigObject}->Get('LogModule::SysLog::Charset') || 'iso-8859-15',
            Force => 1,
        );
    }

    # start syslog connect
    my $LogSock = $Self->{ConfigObject}->Get('LogModule::SysLog::LogSock') || 'unix';
    setlogsock($LogSock);
    openlog( $Param{LogPrefix}, 'cons,pid', $Self->{SysLogFacility} );

    if ( $Param{Priority} =~ /debug/i ) {
        syslog( 'debug', "[Debug][$Param{Module}][$Param{Line}] $Param{Message}" );
    }
    elsif ( $Param{Priority} =~ /info/i ) {
        syslog( 'info', "[Info][$Param{Module}] $Param{Message}" );
    }
    elsif ( $Param{Priority} =~ /notice/i ) {
        syslog( 'notice', "[Notice][$Param{Module}] $Param{Message}" );
    }
    elsif ( $Param{Priority} =~ /error/i ) {
        syslog( 'err', "[Error][$Param{Module}][Line:$Param{Line}]: $Param{Message}" );
    }
    else {

        # print error messages to STDERR
        print STDERR
            "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}\n";

        # and of course to syslog
        syslog(
            'err',
            "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}"
        );
    }

    # close syslog request
    closelog();
    return;
}

1;
