# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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

    # check needed stuff
    if ( !$Param{Config} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Config!',
        );
        return;
    }

    # do nothing if Ticket Service feature is not enabled
    return if !$Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service');

    # viewable locks
    my @ViewableLockIDs = $Kernel::OM->Get('Kernel::System::Lock')->LockViewableLock( Type => 'ID' );

    # viewable states
    my @ViewableStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
        Type   => 'Viewable',
        Result => 'ID',
    );

    # get all queues the agent is allowed to see
    my %ViewableQueues = $Kernel::OM->Get('Kernel::System::Queue')->GetAllQueues(
        UserID => $Self->{UserID},
        Type   => 'ro',
    );
    my @ViewableQueueIDs = sort keys %ViewableQueues;

    # get the custom services
    # set the service ids to an array of non existing service ids (0)
    my @MyServiceIDs = $Kernel::OM->Get('Kernel::System::Service')->GetAllCustomServices( UserID => $Self->{UserID} );
    if ( !defined $MyServiceIDs[0] ) {
        @MyServiceIDs = (0);
    }

    # get number of tickets in MyServices (which are not locked)
    my $Count = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
        Result     => 'COUNT',
        QueueIDs   => \@ViewableQueueIDs,
        ServiceIDs => \@MyServiceIDs,
        StateIDs   => \@ViewableStateIDs,
        LockIDs    => \@ViewableLockIDs,
        UserID     => $Self->{UserID},
        Permission => 'ro',
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
