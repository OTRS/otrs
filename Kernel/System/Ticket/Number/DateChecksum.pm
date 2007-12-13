# --
# Ticket/Number/DateChecksum.pm - a date ticket number generator
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# Copyright (C) 2002 Stefan Schmidt <jsj@jsj.dyndns.org>
# --
# $Id: DateChecksum.pm,v 1.21.2.1 2007-12-13 01:57:53 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

# Note:
# available objects are: ConfigObject, LogObject and DBObject
#
# The algorithm to calculate the checksum is derived from the one
# Deutsche Bundesbahn (german railway company) uses for calculation
# of the check digit of their vehikel numbering.
# The checksum is calculated by alternately multiplying the digits
# with 1 and 2 and adding the resulsts from left to right of the
# vehikel number. The modulus to 10 of this sum is substracted from
# 10. See: http://www.pruefziffernberechnung.de/F/Fahrzeugnummer.shtml
# (german)
#
# Generates ticket numbers like yyyymmddssID#####C (e. g. 2002062310100011)

package Kernel::System::Ticket::Number::DateChecksum;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.21.2.1 $';
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
    my $LastModify = '';
    if (-f $CounterLog) {
        open (DATA, "< $CounterLog") || die "Can't open $CounterLog: $!";
        my $Line = <DATA>;
        ($Count, $LastModify) = split(/;/, $Line);
        close (DATA);
        # just debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "Read counter from $CounterLog: $Count",
            );
        }
    }
    # check if we need to reset the counter
    if (!$LastModify || $LastModify ne "$Year-$Month-$Day") {
        $Count = 0;
    }
    # count auto increment ($Count++)
    $Count++;
    $Count = $Count + $JumpCounter;
    # write new count
    if (open (DATA, "> $CounterLog")) {
        flock (DATA, 2) || warn "Can't set file lock ($CounterLog): $!";
        print DATA $Count.";$Year-$Month-$Day;\n";
        close (DATA);
        # just debug
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "Write counter: $Count",
            );
        }
    }
    else {
        # just debug
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't write $CounterLog: $!",
        );
        die "Can't write $CounterLog: $!";
    }
    # pad ticket number with leading '0' to length 5
    while ( length( $Count ) < 5 ) {
        $Count = "0" . $Count;
    }
    # create new ticket number
    my $Tn = $Year.$Month.$Day.$SystemID.$Count;
    # calculate a checksum
    my $ChkSum = 0;
    my $Mult = 1;
    for ( my $i = 0; $i<length($Tn); ++$i ) {
        my $Digit = substr( $Tn, $i, 1 );
        $ChkSum = $ChkSum + ( $Mult * $Digit );
        $Mult += 1;
        if ( $Mult == 3 ) {
            $Mult = 1;
        }
    }
    $ChkSum %= 10;
    $ChkSum = 10 - $ChkSum;
    if ($ChkSum == 10) {
        $ChkSum = 1;
    }
    # add checksum to ticket number
    $Tn = $Tn.$ChkSum;
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
        if ($String =~ /\Q$TicketHook\E:\s{0,2}(\d{4,10}$SystemID\d{4,40})/i) {
            return $1;
        }
        else {
            return;
        }
    }
}

1;
