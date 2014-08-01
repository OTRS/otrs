# --
# Ticket/Number/AutoIncrement.pm - a ticket number auto increment generator
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

#
# Generates auto increment ticket numbers like ss.... (e. g. 1010138, 1010139, ...)
# --

package Kernel::System::Ticket::Number::AutoIncrement;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
);
our $ObjectManagerAware = 1;

sub TicketCreateNumber {
    my ( $Self, $JumpCounter ) = @_;

    if ( !$JumpCounter ) {
        $JumpCounter = 0;
    }

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

    # get needed config options
    my $CounterLog = $ConfigObject->Get('Ticket::CounterLog');
    my $SystemID   = $ConfigObject->Get('SystemID');
    my $MinSize
        = $ConfigObject->Get('Ticket::NumberGenerator::AutoIncrement::MinCounterSize')
        || $ConfigObject->Get('Ticket::NumberGenerator::MinCounterSize')
        || 5;

    # read count
    my $Count = 0;
    if ( -f $CounterLog ) {

        my $ContentSCALARRef = $MainObject->FileRead(
            Location => $CounterLog,
        );

        if ( $ContentSCALARRef && ${$ContentSCALARRef} ) {

            ($Count) = split /;/, ${$ContentSCALARRef};

            if ( $Self->{Debug} > 0 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
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
    my $Write = $MainObject->FileWrite(
        Location => $CounterLog,
        Content  => \$Count,
    );

    if ($Write) {

        if ( $Self->{Debug} > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Write counter: $Count",
            );
        }
    }

    # pad ticket number with leading '0' to length $MinSize (config option)
    $Count = sprintf "%.*u", $MinSize, $Count;

    # create new ticket number
    my $Tn = $SystemID . $Count;

    # Check ticket number. If exists generate new one!
    if ( $Self->TicketCheckNumber( Tn => $Tn ) ) {

        $Self->{LoopProtectionCounter}++;

        if ( $Self->{LoopProtectionCounter} >= 16000 ) {

            # loop protection
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "CounterLoopProtection is now $Self->{LoopProtectionCounter}!"
                    . " Stopped TicketCreateNumber()!",
            );
            return;
        }

        # create new ticket number again
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get needed config options
    my $CheckSystemID = $ConfigObject->Get('Ticket::NumberGenerator::CheckSystemID');
    my $SystemID      = '';

    if ($CheckSystemID) {
        $SystemID = $ConfigObject->Get('SystemID');
    }

    my $TicketHook        = $ConfigObject->Get('Ticket::Hook');
    my $TicketHookDivider = $ConfigObject->Get('Ticket::HookDivider');
    my $MinSize
        = $ConfigObject->Get('Ticket::NumberGenerator::AutoIncrement::MinCounterSize')
        || $ConfigObject->Get('Ticket::NumberGenerator::MinCounterSize')
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
