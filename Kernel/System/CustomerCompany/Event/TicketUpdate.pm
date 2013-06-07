# --
# Kernel/System/CustomerCompany/Event/TicketUpdate.pm - update tickets if company changes
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerCompany::Event::TicketUpdate;

use strict;
use warnings;

use Kernel::System::Time;
use Kernel::System::Ticket;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw( ConfigObject EncodeObject LogObject MainObject DBObject )
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw( Data Event Config UserID )) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for (qw( CustomerID OldCustomerID )) {
        if ( !$Param{Data}->{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_ in Data!" );
            return;
        }
    }

    # only update if CustomerID has really changed
    return 1 if $Param{Data}->{CustomerID} eq $Param{Data}->{OldCustomerID};

    # create ticket object and perform search
    $Self->{TimeObject}   = Kernel::System::Time->new( %{$Self} );
    $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );
    my @Tickets = $Self->{TicketObject}->TicketSearch(
        Result       => 'ARRAY',
        Limit        => 100_000,
        CustomerID   => $Param{Data}->{OldCustomerID},
        ArchiveFlags => [ 'y', 'n' ],
        UserID       => 1,
    );

    # update the customer ID of tickets
    for my $TicketID (@Tickets) {
        $Self->{TicketObject}->TicketCustomerSet(
            No       => $Param{Data}->{CustomerID},
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
    }

    return 1;
}

1;
