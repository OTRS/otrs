# --
# Kernel/System/Ticket/Event/ForceState.pm - set state
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::ForceState;

use strict;
use warnings;

our @ObjectDependencies = (
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

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );

    # should I unlock a ticket after move?
    return 1 if lc $Ticket{Lock} ne 'lock';

    # set now state
    OLDSTATE:
    for my $OldState ( sort keys %{ $Param{Config} } ) {

        next OLDSTATE if !$OldState;
        next OLDSTATE if $OldState ne $Ticket{State};

        $TicketObject->TicketStateSet(
            TicketID           => $Param{Data}->{TicketID},
            State              => $Param{Config}->{$OldState},
            SendNoNotification => 1,
            UserID             => 1,
        );
    }

    return 1;
}

1;
