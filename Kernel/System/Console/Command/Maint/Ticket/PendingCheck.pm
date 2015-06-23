# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::PendingCheck;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::State',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
    'Kernel::System::User',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Process pending tickets that are past their pending time and send pending reminders.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Process pending tickets...</yellow>\n");

    my $StateObject = $Kernel::OM->Get('Kernel::System::State');

    my @PendingAutoStateIDs = $StateObject->StateGetStatesByType(
        Type   => 'PendingAuto',
        Result => 'ID',
    );

    if ( !@PendingAutoStateIDs ) {
        $Self->Print(" No pending auto StateIDs found - skipping script!\n");
        return $Self->ExitCodeOk();
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # do ticket auto jobs
    my @TicketIDs = $TicketObject->TicketSearch(
        Result   => 'ARRAY',
        StateIDs => [@PendingAutoStateIDs],
        UserID   => 1,
    );

    my %States = %{ $Kernel::OM->Get('Kernel::Config')->Get('Ticket::StateAfterPending') };

    TICKETID:
    for my $TicketID (@TicketIDs) {

        # get ticket data
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            UserID        => 1,
            DynamicFields => 0,
        );

        #next TICKETID if $Ticket{UntilTime} >= 1;

        # error handling
        if ( !$States{ $Ticket{State} } ) {
            $Self->PrintError("No Ticket::StateAfterPending found for '$Ticket{State}' in Kernel/Config.pm!");
            next TICKETID;
        }

        $Self->Print(
            " Update ticket state for ticket $Ticket{TicketNumber} ($TicketID) to '$States{$Ticket{State}}'..."
        );

        # set new state
        my $Success = $TicketObject->StateSet(
            TicketID => $TicketID,
            State    => $States{ $Ticket{State} },
            UserID   => 1,
        );

        # error handling
        if ( !$Success ) {
            $Self->Print(" failed.\n");
            next TICKETID;
        }

        # get state type for new state
        my %State = $StateObject->StateGet(
            Name => $States{ $Ticket{State} },
        );
        if ( $State{TypeName} eq 'closed' ) {

            # set new ticket lock
            $TicketObject->LockSet(
                TicketID     => $TicketID,
                Lock         => 'unlock',
                UserID       => 1,
                Notification => 0,
            );
        }
        $Self->Print(" done.\n");
    }

    # do ticket reminder notification jobs
    @TicketIDs = $TicketObject->TicketSearch(
        Result    => 'ARRAY',
        StateType => 'pending reminder',
        UserID    => 1,
    );

    TICKETID:
    for my $TicketID (@TicketIDs) {

        # get ticket data
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            UserID        => 1,
            DynamicFields => 0,
        );

        next TICKETID if $Ticket{UntilTime} >= 1;

        # get used calendar
        my $Calendar = $TicketObject->TicketCalendarGet(
            %Ticket,
        );

        # check if it is during business hours, then send reminder
        my $CountedTime = $Kernel::OM->Get('Kernel::System::Time')->WorkingTime(
            StartTime => $Kernel::OM->Get('Kernel::System::Time')->SystemTime() - ( 10 * 60 ),
            StopTime  => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
            Calendar  => $Calendar,
        );

        # error handling
        if ( !$CountedTime ) {
            next TICKETID;
        }

        # trigger notification event
        $Self->EventHandler(
            Event => 'NotificationPendingReminder',
            Data  => {
                TicketID              => $Ticket{TicketID},
                CustomerMessageParams => {
                    TicketNumber => $Ticket{TicketNumber},
                },
            },
            UserID => 1,
        );
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
