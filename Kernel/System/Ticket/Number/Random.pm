# --
# Ticket/Number/Random.pm - a ticket number random generator
# Copyright (C) 2001-2008 OTRS GmbH, http://otrs.org/
# --
# $Id: Random.pm,v 1.19 2008-01-02 11:22:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
# Note:
# available objects are: ConfigObject, LogObject and DBObject
#
# Generates random ticket numbers like ss.... (e. g. 100057866352, 103745394596, ...)
# --

package Kernel::System::Ticket::Number::Random;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.19 $) [1];

sub TicketCreateNumber {
    my ($Self) = @_;

    # get needed config options
    my $SystemID = $Self->{ConfigObject}->Get('SystemID');

    # random counter
    my $Count  = int( rand(9999999999) );
    my $Length = length($Count);
    $Length = 10 - $Length;

    # fill up
    for ( 1 .. $Length ) {
        $Count = "0$Count";
    }

    # create new ticket number
    my $Tn = $SystemID . $Count;

    # Check ticket number. If exists generate new one!
    if ( $Self->TicketCheckNumber( Tn => $Tn ) ) {
        $Self->{LoopProtectionCounter}++;
        if ( $Self->{LoopProtectionCounter} >= 12000 ) {

            # loop protection
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "CounterLoopProtection is now $Self->{LoopProtectionCounter}!"
                    . " Stoped TicketCreateNumber()!",
            );
            return;
        }

        # create new ticket number again
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Tn ($Tn) exists! Creating a new one.",
        );
        $Tn = $Self->TicketCreateNumber();
    }
    return $Tn;
}

sub GetTNByString {
    my ( $Self, $String ) = @_;
    if ( !$String ) {
        return;
    }

    # get needed config options
    my $CheckSystemID = $Self->{ConfigObject}->Get('Ticket::NumberGenerator::CheckSystemID');
    my $SystemID      = '';
    if ($CheckSystemID) {
        $SystemID = $Self->{ConfigObject}->Get('SystemID');
    }
    my $TicketHook        = $Self->{ConfigObject}->Get('Ticket::Hook');
    my $TicketHookDivider = $Self->{ConfigObject}->Get('Ticket::HookDivider');

    # check current setting
    if ( $String =~ /\Q$TicketHook$TicketHookDivider\E($SystemID\d{2,20})/i ) {
        return $1;
    }
    else {

        # check default setting
        if ( $String =~ /\Q$TicketHook\E:\s{0,2}($SystemID\d{2,20})/i ) {
            return $1;
        }
        else {
            return;
        }
    }
}

1;
