# --
# Kernel/System/Support/Webserver/Apache.pm - all required system information
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Apache.pm,v 1.1 2011-07-01 14:36:04 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Support::Webserver::Apache;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub AdminChecksGet {
    my ( $Self, %Param ) = @_;

    # get names of available checks from sysconfig
    my $Checks = $Self->{ConfigObject}->Get('Support::Webserver::Apache');

    # find out which checks should are enabled in sysconfig
    my @EnabledCheckFunctions;
    if ( $Checks && ref $Checks eq 'HASH' ) {

        # get all enabled check function names
        @EnabledCheckFunctions = sort grep { $Checks->{$_} } keys %{$Checks};
    }

    # to store the result
    my @DataArray;

    FUNCTIONNAME:
    for my $FunctionName (@EnabledCheckFunctions) {

        # prepend an underscore
        $FunctionName = '_' . $FunctionName;

        # run function and get check data
        my $Check = $Self->$FunctionName();

        next FUNCTIONNAME if !$Check;

        # attach check data if valid
        push @DataArray, $Check;
    }

    return \@DataArray;
}

sub _ApacheVersionCheck {
    my ( $Self, %Param ) = @_;

    my $Data    = {};
    my $Check   = '';
    my $Message = '';
    if ( $ENV{SERVER_SOFTWARE} ) {
        $Check   = 'OK';
        $Message = "You are running $ENV{SERVER_SOFTWARE}.";
    }
    else {
        $Check   = 'Failed';
        $Message = 'Could not determine Apache version.';
    }
    $Data = {
        Name        => 'Apache Version',
        Description => 'Display web server version.',
        Comment     => $Message,
        Check       => $Check,
    };
    return $Data;
}

sub _ApacheDBICheck {
    my ( $Self, %Param ) = @_;

    my $Data = {};

    # check if Apache::DBI is loaded
    my $ApacheDBI = 0;
    my $Check     = '';
    my $Message   = '';
    if ( $ENV{MOD_PERL} ) {
        for my $Module ( keys %INC ) {
            $Module =~ s/\//::/g;
            $Module =~ s/\.pm$//g;
            if ( $Module eq 'Apache::DBI' || $Module eq 'Apache2::DBI' ) {
                $ApacheDBI = $Module;
            }
        }
        if ( !$ApacheDBI ) {
            $Check = 'Critical';
            $Message
                = 'Apache::DBI should be used to get a better performance (pre-establish database connections).';
        }
        else {
            $Check   = 'OK';
            $Message = $ApacheDBI;
        }
    }
    else {

        # Just skip this test if we' re not running mod_perl.
        return;
    }
    $Data = {
        Name        => 'Apache::DBI',
        Description => 'Check if the system uses Apache::DBI.',
        Comment     => $Message,
        Check       => $Check,
    };
    return $Data;
}

sub _ApacheReloadCheck {
    my ( $Self, %Param ) = @_;

    my $Data = {};

    # reload check
    my $Check   = 'Failed';
    my $Message = '';
    if ( $ENV{MOD_PERL} ) {
        eval "require mod_perl";
        if ( defined $mod_perl::VERSION ) {
            if ( $mod_perl::VERSION >= 1.99 ) {

                # check if Apache::Reload is loaded
                my $ApacheReload = 0;
                for my $Module ( keys %INC ) {
                    $Module =~ s/\//::/g;
                    $Module =~ s/\.pm$//g;
                    if ( $Module eq 'Apache::Reload' || $Module eq 'Apache2::Reload' ) {
                        $ApacheReload = $Module;
                    }
                }
                if ( !$ApacheReload ) {
                    $Check = 'Info';
                    $Message
                        = 'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.';
                }
                else {
                    $Check   = 'OK';
                    $Message = $ApacheReload;
                }
            }
        }
    }
    else {

        # Just skip this test if we' re not running mod_perl.
        return;
    }
    $Data = {
        Name        => 'Apache::Reload',
        Description => 'Check if the system uses Apache::Reload/Apache2::Reload.',
        Comment     => $Message,
        Check       => $Check,
    };
    return $Data;
}

sub _CGIAcceleratorCheck {
    my ( $Self, %Param ) = @_;

    my $Data = {};

    my $Check   = 'Failed';
    my $Message = '';
    if ( $ENV{MOD_PERL} ) {

        # check mod_perl version
        if ( $ENV{MOD_PERL} =~ /\/1.99/ ) {
            $Check = 'Critical';
            $Message
                = "You use a beta version of mod_perl ($ENV{MOD_PERL}), you should upgrade to a stable version.";
        }
        elsif ( $ENV{MOD_PERL} =~ /\/1/ ) {
            $Check   = 'Critical';
            $Message = "You should update mod_perl to 2.x ($ENV{MOD_PERL}).";
        }
        else {
            $Check   = 'OK';
            $Message = $ENV{MOD_PERL};
        }
    }
    elsif ( $ENV{SERVER_SOFTWARE} =~ /fastcgi/i ) {
        $Check   = 'OK';
        $Message = 'You are using FastCGI.';
    }
    else {
        $Check   = 'Critical';
        $Message = 'You should use FastCGI or mod_perl to increase your performance.';
    }
    $Data = {
        Name        => 'CGI Accelerator',
        Description => 'Check for CGI Accelerator.',
        Comment     => $Message,
        Check       => $Check,
    };
    return $Data;
}

1;
