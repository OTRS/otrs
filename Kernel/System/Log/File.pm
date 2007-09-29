# --
# Kernel/System/Log/File.pm - file log backend
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: File.pm,v 1.14 2007-09-29 10:54:48 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Log::File;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $ ';

umask "002";

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get logfile location
    $Self->{LogFile} = $Param{ConfigObject}->Get('LogModule::LogFile')
        || die 'Need LogModule::LogFile param in Config.pm';

    # get log file suffix
    if ( $Param{ConfigObject}->Get('LogModule::LogFile::Date') ) {
        my ( $s, $m, $h, $D, $M, $Y, $wd, $yd, $dst ) = localtime( time() );
        $Y = $Y + 1900;
        $M++;
        $Self->{LogFile} .= ".$Y-$M";
    }

    # Fixed bug# 2265 - For IIS we need to create a own error log file.
    # Bind stderr to log file, because iis do print stderr to web page.
    if ( $ENV{SERVER_SOFTWARE} && $ENV{SERVER_SOFTWARE} =~ /^microsoft\-iis/i ) {
        if ( !open( STDERR, ">>", $Self->{LogFile} . ".error" ) ) {
            print STDERR "ERROR: Can't write $Self->{LogFile}.error: $!";
        }
    }

    return $Self;
}

sub Log {
    my $Self  = shift;
    my %Param = @_;
    my $FH;

    # open logfile
    if ( open( $FH, ">>", $Self->{LogFile} ) ) {
        print $FH "[" . localtime() . "]";
        if ( $Param{Priority} =~ /debug/i ) {
            print $FH "[Debug][$Param{Module}][$Param{Line}] $Param{Message}\n";
        }
        elsif ( $Param{Priority} =~ /info/i ) {
            print $FH "[Info][$Param{Module}] $Param{Message}\n";
        }
        elsif ( $Param{Priority} =~ /notice/i ) {
            print $FH "[Notice][$Param{Module}] $Param{Message}\n";
        }
        elsif ( $Param{Priority} =~ /error/i ) {

            # print error messages to $FH
            print $FH "[Error][$Param{Module}][$Param{Line}] $Param{Message}\n";
        }
        else {

            # print error messages to STDERR
            print STDERR
                "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}\n";

            # and of course to logfile
            print $FH
                "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}\n";
        }

        # close file handle
        close($FH);
        return 1;
    }
    else {

        # print error screen
        print STDERR "\n";
        print STDERR " >> Can't write $Self->{LogFile}: $! <<\n";
        print STDERR "\n";
        return;
    }
}

1;
