# --
# Kernel/System/Console/Command/Maint/Ticket/PendingCheck.pm - console command
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

        # send the reminder to the ticket owner, if ticket is locked
        my @UserID;
        if (
            $Kernel::OM->Get('Kernel::Config')->Get('Ticket::PendingNotificationOnlyToOwner')
            || $Ticket{Lock} eq 'lock'
            )
        {
            @UserID = ( $Ticket{OwnerID} );
        }

        # send the reminder to all queue subscribers and owner, if ticket is unlocked
        else {
            @UserID = $TicketObject->GetSubscribedUserIDsByQueueID(
                QueueID => $Ticket{QueueID},
            );
            push @UserID, $Ticket{OwnerID};
        }

        # add the responsible agent to the notification list
        if (
            !$Kernel::OM->Get('Kernel::Config')->Get('Ticket::PendingNotificationNotToResponsible')
            && $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Responsible')
            && $Ticket{ResponsibleID} ne 1
            )
        {
            push @UserID, $Ticket{ResponsibleID};
        }

        # send the reminder notification
        $Self->Print(" Send reminder notification (TicketID=$TicketID)\n");

        my %AlreadySent;
        USERID:
        for my $UserID (@UserID) {

            # remember if reminder got already sent
            next USERID if $AlreadySent{$UserID};
            $AlreadySent{$UserID} = 1;

            # get user data
            my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID => $UserID,
            );

            # check if a reminder has already been sent today
            my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Kernel::OM->Get('Kernel::System::Time')->SystemTime2Date(
                SystemTime => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
            );

            # get ticket history
            my @Lines = $TicketObject->HistoryGet(
                TicketID => $Ticket{TicketID},
                UserID   => 1,
            );

            my $Sent = 0;
            for my $Line (@Lines) {
                if (
                    $Line->{Name} =~ /PendingReminder/
                    && $Line->{Name} =~ /\Q$Preferences{UserEmail}\E/i
                    && $Line->{CreateTime} =~ /$Year-$Month-$Day/
                    )
                {
                    $Sent = 1;
                }
            }

            next USERID if $Sent;

            # send agent notification
            $TicketObject->SendAgentNotification(
                TicketID              => $Ticket{TicketID},
                Type                  => 'PendingReminder',
                RecipientID           => $UserID,
                CustomerMessageParams => {
                    TicketNumber => $Ticket{TicketNumber},
                },
                UserID => 1,
            );
        }
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
