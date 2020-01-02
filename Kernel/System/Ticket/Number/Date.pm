# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

#
# Generates ticket numbers like yyyymmddss.... (e. g. 200206231010138)
# --

package Kernel::System::Ticket::Number::Date;

use strict;
use warnings;

use parent qw(Kernel::System::Ticket::NumberBase);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub IsDateBased {
    return 1;
}

sub TicketNumberBuild {
    my ( $Self, $Offset ) = @_;

    $Offset ||= 0;

    my $Counter = $Self->TicketNumberCounterAdd(
        Offset => 1 + $Offset,
    );

    return if !$Counter;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SystemID = $ConfigObject->Get('SystemID');

    if ( $ConfigObject->Get('Ticket::NumberGenerator::Date::UseFormattedCounter') ) {
        my $MinSize = $ConfigObject->Get('Ticket::NumberGenerator::MinCounterSize')
            || 5;

        # Pad ticket number with leading '0' to length $MinSize (config option).
        $Counter = sprintf "%.*u", $MinSize, $Counter;
    }

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );
    my $DateTimeSettings = $DateTimeObject->Get();

    # Create new ticket number.
    my $TicketNumber = $DateTimeSettings->{Year}
        . sprintf( "%.2u", $DateTimeSettings->{Month} )
        . sprintf( "%.2u", $DateTimeSettings->{Day} )
        . $SystemID . $Counter;

    return $TicketNumber;
}

sub GetTNByString {
    my ( $Self, $String ) = @_;

    if ( !$String ) {
        return;
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $CheckSystemID = $ConfigObject->Get('Ticket::NumberGenerator::CheckSystemID');
    my $SystemID      = '';

    if ($CheckSystemID) {
        $SystemID = $ConfigObject->Get('SystemID');
    }

    my $TicketHook        = $ConfigObject->Get('Ticket::Hook');
    my $TicketHookDivider = $ConfigObject->Get('Ticket::HookDivider');

    # Check ticket number.
    if ( $String =~ /\Q$TicketHook$TicketHookDivider\E(\d{8}$SystemID\d{1,40})/i ) {
        return $1;
    }

    if ( $String =~ /\Q$TicketHook\E:\s{0,2}(\d{8}$SystemID\d{1,40})/i ) {
        return $1;
    }

    return;
}

1;
