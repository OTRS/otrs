# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::System::Queue::Event::TicketAcceleratorUpdate;
use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket::IndexAccelerator::StaticDB',
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
    for my $Needed (qw( Data Event Config UserID )) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    # Only run for StaticDB IndexModule.
    my $IndexModule = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::IndexModule');
    return 1 if $IndexModule ne 'Kernel::System::Ticket::IndexAccelerator::StaticDB';

    # only run if we have the correct data
    for my $Needed (qw(Queue OldQueue)) {
        if ( !IsHashRefWithData( $Param{Data}->{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed in Data is missing or invalid!"
            );

            return;
        }
    }

    # only update if Queue has really changed
    return 1 if $Param{Data}->{Queue}->{Name} eq $Param{Data}->{OldQueue}->{Name};

    # update ticket_index
    return $Kernel::OM->Get('Kernel::System::Ticket::IndexAccelerator::StaticDB')->TicketAcceleratorUpdateOnQueueUpdate(
        NewQueueName => $Param{Data}->{Queue}->{Name},
        OldQueueName => $Param{Data}->{OldQueue}->{Name},
    );
}

1;
