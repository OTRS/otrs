# --
# Kernel/System/Queue/Event/TicketAcceleratorUpdate.pm - update ticket accelerator index
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::System::Queue::Event::TicketAcceleratorUpdate;
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
    for (qw( Data Event Config UserID )) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message => "Need $_!"
            );
            return;
        }
    }

    # only run for StaticDB
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    return 1 if (!$TicketObject->isa('Kernel::System::Ticket::IndexAccelerator::StaticDB'));

    # only update if Queue has really changed
    return 1 if $Param{Data}->{Queue}->{Name} eq $Param{Data}->{OldQueue}->{Name};

    # update ticket_index
    return $TicketObject->TicketAcceleratorUpdateOnQueueUpdate(
        NewQueueName => $Param{Data}->{Queue}->{Name},
        OldQueueName => $Param{Data}->{OldQueue}->{Name},
    );
}

1;
