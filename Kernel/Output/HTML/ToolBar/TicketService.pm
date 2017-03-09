# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBar::TicketService;

use Kernel::Language qw(Translatable);
use base 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Config',
    'Kernel::System::Lock',
    'Kernel::System::State',
    'Kernel::System::Queue',
    'Kernel::System::Service',
    'Kernel::System::Ticket',
    'Kernel::Output::HTML::Layout',
);

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Config} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Config!',
        );
        return;
    }

    # Do nothing if ticket service feature is not enabled.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    return if !$ConfigObject->Get('Ticket::Service');

    # Get viewable locks.
    my @ViewableLockIDs = $Kernel::OM->Get('Kernel::System::Lock')->LockViewableLock( Type => 'ID' );

    # Get viewable states.
    my @ViewableStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
        Type   => 'Viewable',
        Result => 'ID',
    );

    # Get all queues the agent is allowed to see.
    my %ViewableQueues = $Kernel::OM->Get('Kernel::System::Queue')->GetAllQueues(
        UserID => $Self->{UserID},
        Type   => 'ro',
    );
    my @ViewableQueueIDs = sort keys %ViewableQueues;

    # Get custom services.
    #   Set the service IDs to an array of non existing service ids (0).
    my @MyServiceIDs = $Kernel::OM->Get('Kernel::System::Service')->GetAllCustomServices( UserID => $Self->{UserID} );
    if ( !defined $MyServiceIDs[0] ) {
        @MyServiceIDs = (0);
    }

    # Get config setting 'ViewAllPossibleTickets' for AgentTicketService and set permissions
    #   accordingly.
    my $Config     = $ConfigObject->Get('Ticket::Frontend::AgentTicketService');
    my $Permission = 'rw';
    if ( $Config->{ViewAllPossibleTickets} ) {
        $Permission = 'ro';
    }

    # Get number of tickets in MyServices (which are not locked).
    my $Count = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
        Result     => 'COUNT',
        QueueIDs   => \@ViewableQueueIDs,
        ServiceIDs => \@MyServiceIDs,
        StateIDs   => \@ViewableStateIDs,
        LockIDs    => \@ViewableLockIDs,
        UserID     => $Self->{UserID},
        Permission => $Permission,
    ) || 0;

    my $Class = $Param{Config}->{CssClass};
    my $Icon  = $Param{Config}->{Icon};

    my $URL = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{Baselink};
    my %Return;
    my $Priority = $Param{Config}->{Priority};
    if ($Count) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => Translatable('Tickets in My Services'),
            Count       => $Count,
            Class       => $Class,
            Icon        => $Icon,
            Link        => $URL . 'Action=AgentTicketService',
            AccessKey   => '',
        };
    }
    return %Return;
}

1;
