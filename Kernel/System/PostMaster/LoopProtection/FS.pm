# --
# Kernel/System/PostMaster/LoopProtection/FS.pm - backend module of LoopProtection
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: FS.pm,v 1.9 2007-09-29 10:54:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::LoopProtection::FS;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed  objects
    for (qw(DBObject LogObject ConfigObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # get config options
    $Self->{LoopProtectionLog} = $Self->{ConfigObject}->Get('LoopProtectionLog')
        || die 'No Config option "LoopProtectionLog"!';

    $Self->{PostmasterMaxEmails} = $Self->{ConfigObject}->Get('PostmasterMaxEmails') || 40;

    # create logfile name
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = localtime(time);
    $Year = $Year + 1900;
    $Month++;
    $Self->{LoopProtectionLog} .= '-' . $Year . '-' . $Month . '-' . $Day . '.log';

    return $Self;
}

sub SendEmail {
    my $Self  = shift;
    my %Param = @_;
    my $To    = $Param{To} || return;

    # write log
    if ( open( my $Out, '>>', $Self->{LoopProtectionLog} ) ) {
        print $Out "$To;" . localtime() . ";\n";
        close($Out);
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "LoopProtection! Can't write '$Self->{LoopProtectionLog}': $!!",
        );
    }

    return 1;
}

sub Check {
    my $Self  = shift;
    my %Param = @_;
    my $To    = $Param{To} || return;
    my $Count = 0;

    # check existing logfile
    if ( !open( my $In, '<', $Self->{LoopProtectionLog} ) ) {

        # create new log file
        if ( !open( my $Out, '>', $Self->{LoopProtectionLog} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "LoopProtection! Can't write '$Self->{LoopProtectionLog}': $!!",
            );
        }
        else {
            close($Out);
        }
    }
    else {

        # open old log file
        while (<$In>) {
            my @Data = split( /;/, $_ );
            if ( $Data[0] eq $To ) {
                $Count++;
            }
        }
        close($In);
    }

    # check possible loop
    if ( $Count >= $Self->{PostmasterMaxEmails} ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "LoopProtection!!! Send no more emails to '$To'! Max. count of $Self->{PostmasterMaxEmails} has been reached!",
        );
        return;
    }
    else {
        return 1;
    }
}

1;
