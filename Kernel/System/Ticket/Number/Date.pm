# --
# Ticket/Number/Date.pm - a date ticket number generator
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Date.pm,v 1.5 2003-01-27 11:38:33 martin Exp $
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
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    my ($Count) = split(/;/, $Line);
    close (COUNTER);
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
        print COUNTER $Count . "\n";
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
    # new ticket number
    # --
    my $Tn = $Year.$Month.$Day.$Self->{SystemID} . $Count;

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
