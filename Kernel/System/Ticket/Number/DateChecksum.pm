# --
# Ticket/Number/DateChecksum.pm - a date ticket number generator
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# Copyright (C) 2002 Stefan Schmidt <jsj@jsj.dyndns.org>
# --
# $Id: DateChecksum.pm,v 1.7 2003-02-08 15:09:41 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
# Note:
# available objects are: ConfigObject, LogObject and DBObject
# --
# The algorithm to calculate the checksum is derived from the one
# Deutsche Bundesbahn (german railway company) uses for calculation
# of the check digit of their vehikel numbering.
# The checksum is calculated by alternately multiplying the digits
# with 1 and 2 and adding the resulsts from left to right of the 
# vehikel number. The modulus to 10 of this sum is substracted from
# 10. See: http://www.pruefziffernberechnung.de/F/Fahrzeugnummer.shtml
# (german)
# --
# Generates ticket numbers like yyyymmddssID#####C (e. g. 2002062310100011)
# --

package Kernel::System::Ticket::Number::DateChecksum;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub CreateTicketNr {
    my $Self = shift;
    my $JumpCounter = shift || 0;

    # --
    # get needed config options 
    # --
    $Self->{CounterLog} = $Self->{ConfigObject}->Get('CounterLog');
    $Self->{SystemID} = $Self->{ConfigObject}->Get('SystemID');

    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = localtime(time);
    $Year = $Year+1900;
    $Month = $Month+1;
    $Month  = "0$Month" if ($Month <10);
    $Day = "0$Day" if ($Day <10);

    # --
    # read count
    # --
    open (COUNTER, "< $Self->{CounterLog}") || die "Can't open $Self->{CounterLog}";
    my $Line = <COUNTER>;
    my ($Count, $LastModify) = split(/;/, $Line);
    close (COUNTER);
    # --
    # check if we need to reset the counter
    # --
    if (!$LastModify || $LastModify ne "$Year-$Month-$Day") {
        $Count = 0;
    }
    # --
    # just debug
    # --
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'debug',
          Message => "Read counter: $Count",
        );
    }

    # --
    # count auto increment ($Count++)
    # --
    $Count++;
    $Count = $Count + $JumpCounter;

    # --
    # write new count
    # --
    if (open (COUNTER, "> $Self->{CounterLog}")) {
        flock (COUNTER, 2) || warn "Can't set file lock ($Self->{CounterLog}): $!";
        print COUNTER $Count . ";$Year-$Month-$Day;\n";
        close (COUNTER);
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
            Message => "Can't write $Self->{CounterLog}: $!",
        );
        die "Can't write $Self->{CounterLog}: $!";
    }

    # --
    # pad ticket number with leading '0' to length 5
    # --
    while ( length( $Count ) < 5 ) {
        $Count = "0" . $Count;
    }

    # --
    # new ticket number
    # --
    my $Tn = $Year.$Month.$Day.$Self->{SystemID} . $Count;

    # --
    # calculate a checksum
    # --
    my $chksum = 0;
    my $mult = 1;
    for ( my $i = 0; $i<length($Tn); ++$i ) {
        my $Digit = substr( $Tn, $i, 1 );
        $chksum = $chksum + ( $mult * $Digit );
        $mult += 1;
        if ( $mult == 3 ) {
          $mult = 1;
        }
    }
    $chksum %= 10;
    $chksum = 10 - $chksum;
    if ($chksum == 10) {
        $chksum = 1;
    }
    # --
    # add checksum to ticket number
    # --
    $Tn = $Tn . $chksum;

    # --
    # Check ticket number. If exists generate new one! 
    # --
    if ($Self->CheckTicketNr(Tn=>$Tn)) {
        $Self->{LoopProtectionCounter}++;
        if ($Self->{LoopProtectionCounter} >= 1000) {
          # loop protection
          $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "CounterLoopProtection is now $Self->{LoopProtectionCounter}!".
                   " Stoped CreateTicketNr()!",
          );
          return;
        }
        # --
        # create new ticket number again
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "Tn ($Tn) exists! Creating new one.",
        );
        $Tn = $Self->CreateTicketNr($Self->{LoopProtectionCounter});
    }
    return $Tn;
}
# --
sub GetTNByString {
    my $Self = shift;
    my $String = shift || return;

    # --
    # get needed config options 
    # --
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');

    # --
    # check ticket number
    # --
    if ($String =~ /$TicketHook:+.{0,1}(\d{8,40})/i) {
        return $1;
    }
    else {
        return;
    }
}
# --
1;
