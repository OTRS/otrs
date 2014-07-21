# --
# Kernel/Output/HTML/ToolBarTicketService.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarTicketService;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::Lock;
use Kernel::System::Queue;
use Kernel::System::Service;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (
        qw(ConfigObject LogObject DBObject UserObject TicketObject LayoutObject UserID)
        )
    {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    # create needed objects
    $Self->{StateObject}   = Kernel::System::State->new(%Param);
    $Self->{LockObject}    = Kernel::System::Lock->new(%Param);
    $Self->{QueueObject}   = Kernel::System::Queue->new(%Param);
    $Self->{ServiceObject} = Kernel::System::Service->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Config} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Config!',
        );
        return;
    }

    # do nothing if Ticket Service feature is not enabled
    return if !$Self->{ConfigObject}->Get('Ticket::Service');

    # viewable locks
    my @ViewableLockIDs = $Self->{LockObject}->LockViewableLock( Type => 'ID' );

    # viewable states
    my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
        Type   => 'Viewable',
        Result => 'ID',
    );

    # get all queues the agent is allowed to see
    my %ViewableQueues = $Self->{QueueObject}->GetAllQueues(
        UserID => $Self->{UserID},
        Type   => 'ro',
    );
    my @ViewableQueueIDs = sort keys %ViewableQueues;

    # get the custom services
    # set the service ids to an array of non existing service ids (0)
    my @MyServiceIDs = $Self->{ServiceObject}->GetAllCustomServices( UserID => $Self->{UserID} );
    if ( !defined $MyServiceIDs[0] ) {
        @MyServiceIDs = (0);
    }

    # get number of tickets in MyServices (which are not locked)
    my $Count = $Self->{TicketObject}->TicketSearch(
        Result     => 'COUNT',
        QueueIDs   => \@ViewableQueueIDs,
        ServiceIDs => \@MyServiceIDs,
        StateIDs   => \@ViewableStateIDs,
        LockIDs    => \@ViewableLockIDs,
        UserID     => $Self->{UserID},
        Permission => 'ro',
    );

    my $Class = $Param{Config}->{CssClass};
    my $Icon  = $Param{Config}->{Icon};

    my $URL = $Self->{LayoutObject}->{Baselink};
    my %Return;
    my $Priority = $Param{Config}->{Priority};
    if ($Count) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => 'Tickets in MyServices',
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
