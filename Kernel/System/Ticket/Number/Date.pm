# --
# Ticket/Number/Date.pm - a date ticket number generator
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Date.pm,v 1.19 2007-01-29 16:18:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
# Note:
# available objects are: ConfigObject, LogObject and DBObject
#
# Generates ticket numbers like yyyymmddss.... (e. g. 200206231010138)
# --

package Kernel::System::Ticket::Number::Date;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.19 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub TicketCreateNumber {
    my $Self = shift;
    my $JumpCounter = shift || 0;
    # get needed config options
    my $CounterLog = $Self->{ConfigObject}->Get('Ticket::CounterLog');
    my $SystemID = $Self->{ConfigObject}->Get('SystemID');
    # get current time
    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    # read count
    my $Count = 0;
    if (-f $CounterLog) {
        open (DATA, "< $CounterLog") || die "Can't open $CounterLog: $!";
        my $Line = <DATA>;
        ($Count) = split(/;/, $Line);
        close (DATA);
        # just debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "Read counter from $CounterLog: $Count",
            );
        }
    }
    # count auto increment ($Count++)
    $Count++;
    $Count = $Count+$JumpCounter;
    # write new count
    if (open (DATA, "> $CounterLog")) {
        flock (DATA, 2) || warn "Can't set file lock ($CounterLog): $!";
        print DATA $Count."\n";
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
    # create new ticket number
    my $Tn = $Year.$Month.$Day.$SystemID.$Count;
    # Check ticket number. If exists generate new one!
    if ($Self->TicketCheckNumber(Tn=>$Tn)) {
        $Self->{LoopProtectionCounter}++;
        if ($Self->{LoopProtectionCounter} >= 6000) {
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
    # check current setting
    if ($String =~ /\Q$TicketHook$TicketHookDivider\E(\d{4,10}$SystemID\d{4,40})/i) {
        return $1;
    }
    else {
        # check default setting
        if ($String =~ /\Q$TicketHook\E:+.{0,2}(\d{4,10}$SystemID\d{4,40})/i) {
            return $1;
        }
        else {
            return;
        }
    }
}

1;
