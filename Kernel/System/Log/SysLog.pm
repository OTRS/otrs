# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Log::SysLog;

use strict;
use warnings;

use Sys::Syslog qw();

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set syslog facility
    $Self->{SysLogFacility} = $Kernel::OM->Get('Kernel::Config')->Get('LogModule::SysLog::Facility') || 'user';

    return $Self;
}

sub Log {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # prepare data for byte output
    if ( $ConfigObject->Get('LogModule::SysLog::Charset') =~ m/^utf-?8$/ ) {
        $EncodeObject->EncodeOutput( \$Param{Message} );
    }
    else {
        $Param{Message} = $EncodeObject->Convert(
            Text  => $Param{Message},
            From  => 'utf8',
            To    => $ConfigObject->Get('LogModule::SysLog::Charset') || 'iso-8859-15',
            Force => 1,
        );
    }

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
