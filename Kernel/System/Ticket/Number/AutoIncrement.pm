# --
# Ticket/Number/AutoIncrement.pm - a ticket number auto increment generator
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AutoIncrement.pm,v 1.28 2009-02-16 11:46:10 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
# Note:
# available objects are: ConfigObject, LogObject and DBObject
#
# Generates auto increment ticket numbers like ss.... (e. g. 1010138, 1010139, ...)
# --

package Kernel::System::Ticket::Number::AutoIncrement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.28 $) [1];

sub TicketCreateNumber {
    my ( $Self, $JumpCounter ) = @_;
    if ( !$JumpCounter ) {
        $JumpCounter = 0;
    }

    # get needed config options
    my $CounterLog = $Self->{ConfigObject}->Get('Ticket::CounterLog');
    my $SystemID   = $Self->{ConfigObject}->Get('SystemID');
    my $MinSize
        = $Self->{ConfigObject}->Get('Ticket::NumberGenerator::AutoIncrement::MinCounterSize')
        || $Self->{ConfigObject}->Get('Ticket::NumberGenerator::MinCounterSize')
        || 5;

    # read count
    my $Count = 0;
    if ( -f $CounterLog ) {
        my $ContentSCALARRef = $Self->{MainObject}->FileRead(
            Location => $CounterLog,
        );
        if ( $ContentSCALARRef && ${$ContentSCALARRef} ) {
            ($Count) = split( /;/, ${$ContentSCALARRef} );
            if ( $Self->{Debug} > 0 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Read counter from $CounterLog: $Count",
                );
            }
        }
    }

    # count auto increment ($Count++)
    $Count++;
    $Count = $Count + $JumpCounter;

    # write new count
    my $Write = $Self->{MainObject}->FileWrite(
        Location => $CounterLog,
        Content  => \$Count,
    );
    if ($Write) {
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Write counter: $Count",
            );
        }
    }

    # pad ticket number with leading '0' to length $MinSize (config option)
    while ( length($Count) < $MinSize ) {
        $Count = '0' . $Count;
    }

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
                    . " Stoped TicketCreateNumber()!",
            );
            return;
        }

        # create new ticket number again
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Tn ($Tn) exists! Creating a new one.",
        );
        $Tn = $Self->TicketCreateNumber( $Self->{LoopProtectionCounter} );
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
    my $MinSize
        = $Self->{ConfigObject}->Get('Ticket::NumberGenerator::AutoIncrement::MinCounterSize')
        || $Self->{ConfigObject}->Get('Ticket::NumberGenerator::MinCounterSize')
        || 5;
    my $MaxSize = $MinSize + 5;

    # check ticket number
    if ( $String =~ /\Q$TicketHook$TicketHookDivider\E($SystemID\d{$MinSize,$MaxSize})/i ) {
        return $1;
    }

    if ( $String =~ /\Q$TicketHook\E:\s{0,2}($SystemID\d{$MinSize,$MaxSize})/i ) {
        return $1;
    }

    return;
}

1;
