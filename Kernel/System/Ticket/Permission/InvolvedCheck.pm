# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Permission::InvolvedCheck;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

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
    for (qw(TicketID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket data without dynamic fields
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    return if !%Ticket;

    # get queue config
    my $Queues = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Permission::InvolvedCheck::Queues');

    # check queues
    if ( $Queues && ref $Queues eq 'ARRAY' && @{$Queues} && $Ticket{Queue} ) {

        my $QueueCheck;
        QUEUE:
        for my $Queue ( @{$Queues} ) {

            next QUEUE if !$Queue;
            next QUEUE if $Ticket{Queue} ne $Queue;

            $QueueCheck = 1;

            last QUEUE;
        }

        return if !$QueueCheck;
    }

    # get the history of the ticket
    my @TicketHistory = $TicketObject->HistoryGet(
        TicketID => $Param{TicketID},
        UserID   => 1,
    );

    ROW:
    for my $Row (@TicketHistory) {

        next ROW if !$Row;
        next ROW if ref $Row ne 'HASH';

        next ROW if !$Row->{CreateBy};

        return 1 if $Row->{CreateBy} eq $Param{UserID};
    }

    # return no access
    return;
}

1;
