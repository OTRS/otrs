# --
# Ticket/Number/Date.pm - a date ticket number generator
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Date.pm,v 1.7.2.1 2003-06-01 18:05:47 martin Exp $
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
$VERSION = '$Revision: 1.7.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub CreateTicketNr {
    my $Self = shift;
    my $JumpCounter = shift || 0;
    # get needed config options 
    my $CounterLog = $Self->{ConfigObject}->Get('CounterLog');
    my $SystemID = $Self->{ConfigObject}->Get('SystemID');
    # get current time
    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = localtime(time);
    $Year = $Year+1900;
    $Month = $Month+1;
    $Month  = "0$Month" if ($Month <10);
    $Day = "0$Day" if ($Day <10);
    # read count
    my $Count = 0; 
    if (-f $CounterLog) {
        open (COUNTER, "< $CounterLog") || die "Can't open $CounterLog: $!";
        my $Line = <COUNTER>; 
        ($Count) = split(/;/, $Line);
        close (COUNTER);
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
    if (open (COUNTER, "> $CounterLog")) {
        flock (COUNTER, 2) || warn "Can't set file lock ($CounterLog): $!";
        print COUNTER $Count."\n";
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
            Message => "Can't write $CounterLog: $!",
        );
        die "Can't write $CounterLog: $!";
    }
    # create new ticket number
    my $Tn = $Year.$Month.$Day.$SystemID.$Count;
    # Check ticket number. If exists generate new one! 
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
        # create new ticket number again
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
    # get needed config options 
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    # check ticket number
    if ($String =~ /$TicketHook:+.{0,1}(\d{8,40})\-FW/i) {
        return $1;
    }
    else {
        if ($String =~ /$TicketHook:+.{0,1}(\d{8,40})/i) {
            return $1;
        }
        else {
            return;
        }
    }
}
# --
1;
