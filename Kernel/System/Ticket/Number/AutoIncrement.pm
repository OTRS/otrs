# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

#
# Generates auto increment ticket numbers like ss.... (e. g. 1010138, 1010139, ...)
# --

package Kernel::System::Ticket::Number::AutoIncrement;

use strict;
use warnings;

use parent qw(Kernel::System::Ticket::NumberBase);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Ticket',
);

sub IsDateBased {
    return 0;
}

sub TicketNumberBuild {
    my ( $Self, $Offset ) = @_;

    $Offset ||= 0;

    my $BaseCounter = 1;
    if ( $Self->TicketNumberCounterIsEmpty() ) {
        $BaseCounter = $Self->InitialCounterOffsetCalculate();
    }

    my $Counter = $Self->TicketNumberCounterAdd(
        Offset => $BaseCounter + $Offset,
    );

    return if !$Counter;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SystemID = $ConfigObject->Get('SystemID');
    my $MinSize  = $ConfigObject->Get('Ticket::NumberGenerator::AutoIncrement::MinCounterSize')
        || $ConfigObject->Get('Ticket::NumberGenerator::MinCounterSize')
        || 5;

    # Pad ticket number with leading '0' to length $MinSize (config option).
    $Counter = sprintf "%.*u", $MinSize, $Counter;

    my $TicketNumber = $SystemID . $Counter;

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
    my $MinSize           = $ConfigObject->Get('Ticket::NumberGenerator::AutoIncrement::MinCounterSize')
        || $ConfigObject->Get('Ticket::NumberGenerator::MinCounterSize')
        || 5;
    my $MaxSize = $MinSize + 5;

    # Check ticket number.
    if ( $String =~ /\Q$TicketHook$TicketHookDivider\E($SystemID\d{$MinSize,$MaxSize})/i ) {
        return $1;
    }

    if ( $String =~ /\Q$TicketHook\E:\s{0,2}($SystemID\d{$MinSize,$MaxSize})/i ) {
        return $1;
    }

    return;
}

#
# Calculate initial counter value on (migrated) systems that already have tickets,
#   but no counter entries yet.
#
sub InitialCounterOffsetCalculate {
    my ( $Self, %Param ) = @_;

    my $LastTicketNumber = $Self->_GetLastTicketNumber();
    return 1 if !$LastTicketNumber;

    # If the ticket number was created by a date based generator, ticket counter needs to start from 1
    return 1 if $Self->_LooksLikeDateBasedTicketNumber($LastTicketNumber);

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $CheckSystemID = $ConfigObject->Get('Ticket::NumberGenerator::CheckSystemID');
    my $SystemID      = '';

    if ($CheckSystemID) {
        $SystemID = $ConfigObject->Get('SystemID');
    }

    # Remove SystemID and leading zeros
    $LastTicketNumber =~ s{\A $SystemID 0* }{}msx;

    return 1 if !$LastTicketNumber;

    return $LastTicketNumber + 1;
}

sub _GetLastTicketNumber {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT MAX(id) FROM ticket',
    );

    my $TicketID;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $TicketID = $Data[0];
    }

    return if $TicketID && $TicketID == 1;

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => 1,
        Silent        => 1,
    );

    return if !%Ticket;
    return if !$Ticket{TicketNumber};

    return $Ticket{TicketNumber};
}

sub _LooksLikeDateBasedTicketNumber {
    my ( $Self, $TicketNumber ) = @_;

    return if !$TicketNumber;

    my $PossibleDate = substr $TicketNumber, 0, 8;
    return if length $PossibleDate != 8;

    # Format possible date as a date string
    $PossibleDate =~ s{\A (\d{4}) (\d{2}) (\d{2}) \z}{$1-$2-$3 00:00:00}gsmx;

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my $Result = $DateTimeObject->Set( String => $PossibleDate );

    return if !$Result;

    return 1;
}

1;
