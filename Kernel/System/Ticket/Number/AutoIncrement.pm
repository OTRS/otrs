# --
# Ticket/Number/AutoIncrement.pm - a ticket number auto increment generator
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AutoIncrement.pm,v 1.2 2002-07-02 20:41:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
# Note: 
# available objects are: ConfigObject, LogObject and DBObject
# 
# Generates auto increment ticket numbers like ss.... (e. g. 1010138, 1010139, ...)
# --
 
package Kernel::System::Ticket::Number::AutoIncrement;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

sub CreateTicketNr {
    my $Self = shift;
    my $JumpCounter = shift || 0;

    # --
    # get needed config options 
    # --
    my $CounterLog = $Self->{ConfigObject}->Get('CounterLog');
    my $SystemID = $Self->{ConfigObject}->Get('SystemID');

    # --
    # read count
    # --
    open (COUNTER, "< $CounterLog") || die "Can't open $CounterLog: $!";
    my $Line = <COUNTER>;
    my ($Count) = split(/;/, $Line);
    close (COUNTER);
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'debug',
          MSG => "Read counter: $Count",
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
    if (open (COUNTER, "> $CounterLog")) {
        flock (COUNTER, 2) || warn "Can't set file lock ($CounterLog): $!";
        print COUNTER $Count . "\n";
        close (COUNTER);
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
              Priority => 'debug',
              MSG => "Write counter: $Count",
            );
        }
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            MSG => "Can't open $CounterLog: $!",
        );
        die;
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
    my $Tn = $SystemID . $Count;

    # --
    # Check ticket number. If exists generate new one! 
    # --
    if ($Self->CheckTicketNr(Tn=>$Tn)) {
        $Self->{LoopProtectionCounter}++;
        if ($Self->{LoopProtectionCounter} >= 1000) {
          # loop protection
          $Self->{LogObject}->Log(
            Priority => 'error',
            MSG => "CounterLoopProtection is now $Self->{LoopProtectionCounter}!".
                   " Stoped CreateTicketNr()!",
          );
          return;
        }
        # --
        # create new ticket number again
        # --
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "Tn ($Tn) exists! Creating new one.",
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
    my $SystemID = $Self->{ConfigObject}->Get('SystemID');
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');

    # --
    # check ticket number
    # --
    if ($String =~ /$TicketHook:+.{0,1}($SystemID\d{2,10})/i) {
        return $1;
    }
    else {
        return;
    }
}
# --
