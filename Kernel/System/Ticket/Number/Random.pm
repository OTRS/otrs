# --
# Ticket/Number/Random.pm - a ticket number random generator
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
# Note:
# available objects are: ConfigObject, LogObject and DBObject
#
# Generates random ticket numbers like ss.... (e. g. 100057866352, 103745394596, ...)
# --

package Kernel::System::Ticket::Number::Random;

use strict;
use warnings;

sub TicketCreateNumber {
    my $Self = shift;

    # get needed config options
    my $SystemID = $Self->{ConfigObject}->Get('SystemID');

    # random counter
    my $Count = int( rand(9999999999) );

    $Count = sprintf "%.*u", 10, $Count;

    # create new ticket number
    my $Tn = $SystemID . $Count;

    # Check ticket number. If exists generate new one!
    if ( $Self->TicketCheckNumber( Tn => $Tn ) ) {
        $Self->{LoopProtectionCounter}++;
        if ( $Self->{LoopProtectionCounter} >= 16000 ) {

            # loop protection
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "CounterLoopProtection is now $Self->{LoopProtectionCounter}!"
                    . " Stopped TicketCreateNumber()!",
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

    # check default setting
    if ( $String =~ /\Q$TicketHook\E:\s{0,2}($SystemID\d{2,20})/i ) {
        return $1;
    }

    return;
}

1;
