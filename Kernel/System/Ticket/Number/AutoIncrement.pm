# --
# Ticket/Number/AutoIncrement.pm - a ticket number auto increment generator
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AutoIncrement.pm,v 1.18.2.3 2008-04-23 20:29:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --
# Note:
# available objects are: ConfigObject, LogObject and DBObject
#
# Generates auto increment ticket numbers like ss.... (e. g. 1010138, 1010139, ...)
# --

package Kernel::System::Ticket::Number::AutoIncrement;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.18.2.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub TicketCreateNumber {
    my $Self = shift;
    my $JumpCounter = shift || 0;
    # get needed config options
    my $CounterLog = $Self->{ConfigObject}->Get('Ticket::CounterLog');
    my $SystemID = $Self->{ConfigObject}->Get('SystemID');
    my $MinSize = $Self->{ConfigObject}->Get('Ticket::NumberGenerator::AutoIncrement::MinCounterSize')
        || $Self->{ConfigObject}->Get('Ticket::NumberGenerator::MinCounterSize')
        || 5;
    # read count
    my $Count = 0;
    if (-f $CounterLog) {
        open (DATA, "< $CounterLog") || die "Can't open $CounterLog: $!";
        my $Line = <DATA>;
        if ( $Line ) {
            ($Count) = split(/;/, $Line);
        }
        close (DATA);
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "Read counter from $CounterLog: $Count",
            );
        }
    }
    # count auto increment ($Count++)
    $Count++;
    $Count = $Count + $JumpCounter;
    # write new count
    if (open (DATA, "> $CounterLog")) {
        flock (DATA, 2) || warn "Can't set file lock ($CounterLog): $!";
        print DATA $Count . "\n";
        close (DATA);
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "Write counter: $Count",
            );
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't write $CounterLog: $!",
        );
        die "Can't write $CounterLog: $!";
    }
    # pad ticket number with leading '0' to length $MinSize (config option)
    while (length($Count) < $MinSize) {
        $Count = "0".$Count;
    }
    # create new ticket number
    my $Tn = $SystemID . $Count;
    # Check ticket number. If exists generate new one!
    if ($Self->TicketCheckNumber(Tn=>$Tn)) {
        $Self->{LoopProtectionCounter}++;
        if ($Self->{LoopProtectionCounter} >= 16000) {
            # loop protection
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "CounterLoopProtection is now $Self->{LoopProtectionCounter}!".
                    " Stoped TicketCreateNumber()!",
            );
            return;
        }
        # create new ticket number again
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Tn ($Tn) exists! Creating a new one.",
        );
        $Tn = $Self->TicketCreateNumber($Self->{LoopProtectionCounter});
    }
    return $Tn;
}

sub GetTNByString {
    my $Self = shift;
    my $String = shift || return;
    # get needed config options
    my $CheckSystemID = $Self->{ConfigObject}->Get('Ticket::NumberGenerator::CheckSystemID');
    my $SystemID = '';
    if ($CheckSystemID) {
        $SystemID = $Self->{ConfigObject}->Get('SystemID');
    }
    my $TicketHook = $Self->{ConfigObject}->Get('Ticket::Hook');
    my $TicketHookDivider = $Self->{ConfigObject}->Get('Ticket::HookDivider');
    my $MinSize = $Self->{ConfigObject}->Get('Ticket::NumberGenerator::AutoIncrement::MinCounterSize')
        || $Self->{ConfigObject}->Get('Ticket::NumberGenerator::MinCounterSize')
        || 5;
    my $MaxSize = $MinSize + 5;
    # check ticket number
    if ($String =~ /\Q$TicketHook$TicketHookDivider\E($SystemID\d{$MinSize,$MaxSize})/i) {
        return $1;
    }
    else {
        if ($String =~ /\Q$TicketHook\E:\s{0,2}($SystemID\d{$MinSize,$MaxSize})/i) {
            return $1;
        }
        else {
            return;
        }
    }
}

1;
