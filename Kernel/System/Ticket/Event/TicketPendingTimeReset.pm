# --
# Kernel/System/Ticket/Event/TicketPendingTimeReset.pm - Empty pending time on status change
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::TicketPendingTimeReset;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);
our $ObjectManagerAware = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_ in Data!" );
            return;
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # read pending state types from config
    my $PendingReminderStateType =
        $ConfigObject->Get('Ticket::PendingReminderStateType:') || 'pending reminder';

    my $PendingAutoStateType =
        $ConfigObject->Get('Ticket::PendingAutoStateType:') || 'pending auto';

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        UserID        => 1,
        DynamicFields => 0,
    );
    return if !%Ticket;

    # only set the pending time to 0 if it's actually set
    return 1 if !$Ticket{UntilTime};

    # only set the pending time to 0 if the new state is NOT a pending state
    return 1 if $Ticket{StateType} eq $PendingReminderStateType;
    return 1 if $Ticket{StateType} eq $PendingAutoStateType;

    # reset pending date/time
    return if !$TicketObject->TicketPendingTimeSet(
        TicketID => $Param{Data}->{TicketID},
        UserID   => $Param{UserID},
        String   => '0000-00-00 00:00:00',
    );

    return 1;
}

1;
