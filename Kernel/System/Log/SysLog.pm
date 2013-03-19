# --
# Kernel/System/Log/SysLog.pm - a wrapper for Sys::Syslog or xyz::Syslog
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Log::SysLog;

use strict;
use warnings;

use Sys::Syslog qw();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject EncodeObject)) {
        if ( $Param{$Needed} ) {
            $Self->{$Needed} = $Param{$Needed};
        }
        else {
            die "Got no $Needed!";
        }
    }

    # set syslog facility
    $Self->{SysLogFacility} = $Param{ConfigObject}->Get('LogModule::SysLog::Facility') || 'user';

    return $Self;
}

sub Log {
    my ( $Self, %Param ) = @_;

    # prepare data for byte output
    if ( $Self->{ConfigObject}->Get('LogModule::SysLog::Charset') =~ m/^utf-?8$/ ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Message} );
    }
    else {
        $Param{Message} = $Self->{EncodeObject}->Convert(
            Text  => $Param{Message},
            From  => 'utf8',
            To    => $Self->{ConfigObject}->Get('LogModule::SysLog::Charset') || 'iso-8859-15',
            Force => 1,
        );
    }

    # According to the docs, this is not needed any longer and should not be used any more.
    #   Please see the Sys::Syslog documentation for details.
    #   #TODO: remove this code sometime, and the config setting.
    #my $LogSock = $Self->{ConfigObject}->Get('LogModule::SysLog::LogSock') || 'unix';
    #Sys::Syslog::setlogsock($LogSock);
    Sys::Syslog::openlog( $Param{LogPrefix}, 'cons,pid', $Self->{SysLogFacility} );

    if ( lc $Param{Priority} eq 'debug' ) {
        Sys::Syslog::syslog( 'debug', "[Debug][$Param{Module}][$Param{Line}] $Param{Message}" );
    }
    elsif ( lc $Param{Priority} eq 'info' ) {
        Sys::Syslog::syslog( 'info', "[Info][$Param{Module}] $Param{Message}" );
    }
    elsif ( lc $Param{Priority} eq 'notice' ) {
        Sys::Syslog::syslog( 'notice', "[Notice][$Param{Module}] $Param{Message}" );
    }
    elsif ( lc $Param{Priority} eq 'error' ) {
        Sys::Syslog::syslog( 'err', "[Error][$Param{Module}][Line:$Param{Line}]: $Param{Message}" );
    }
    else {

        # print error messages to STDERR
        print STDERR
            "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}\n";

        # and of course to syslog
        Sys::Syslog::syslog(
            'err',
            "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}"
        );
    }

    Sys::Syslog::closelog();

    return;
}

1;
