# --
# Kernel/System/Ticket/Event/GenericAgent.pm - event handler module for the event based ticket actions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::GenericAgent;

use strict;
use warnings;

use Kernel::System::GenericAgent;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Item (
        qw(ConfigObject LogObject DBObject MainObject EncodeObject TimeObject QueueObject TicketObject)
        )
    {
        $Self->{$Item} = $Param{$Item} || die "Got no $Item!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data Event Config)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check for TicketID
    if ( !$Param{Data}->{TicketID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need TicketID! in Data",
        );
        return;
    }

    # Loop protection: only execute this handler once for each ticket and event.
    my $CacheKey = '';
    if (
        $Self->{TicketObject}->{'_GenericAgent::AlreadyProcessed'}->{ $Param{Data}->{TicketID} }
        ->{ $Param{Event} }++
        )
    {
        return;
    }

    $Self->{GenericAgentObject} = Kernel::System::GenericAgent->new(%$Self);
    my %JobEventList = $Self->{GenericAgentObject}->JobEventList();

    # no configured jobs is OK
    return 1 if !IsHashRefWithData( \%JobEventList );

    # loop over jobs
    JOB:
    for my $JobName ( sort keys %JobEventList ) {

        next JOB if !IsArrayRefWithData( $JobEventList{$JobName} );

        # check if the job is connected to this event
        my @Events = @{ $JobEventList{$JobName} };
        next JOB if !grep { $_ eq $Param{Event} } @Events;

        # execute the job
        my $Result = $Self->{GenericAgentObject}->JobRun(
            Job          => $JobName,
            OnlyTicketID => $Param{Data}->{TicketID},
            UserID       => 1,                          # run the job as system user
        );
    }

    return 1;
}

1;
