# --
# Escalations.t - escalation event tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Escalations.t,v 1.7 2011-12-23 04:02:28 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::Queue;
use Kernel::System::Ticket;
use Kernel::System::GenericAgent;

my $ConfigObject = Kernel::Config->new();

# create common objects
my $QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# Make sure that Kernel::System::Ticket::new() does not create it's own QueueObject.
# This will interfere with caching.
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    QueueObject  => $QueueObject,
    ConfigObject => $ConfigObject,
);
my $GenericAgentObject = Kernel::System::GenericAgent->new(
    %{$Self},
    QueueObject  => $QueueObject,
    TicketObject => $TicketObject,
    ConfigObject => $ConfigObject,
);

# An unique indentifier, so that data from different test runs won't be mixed up.
my $UniqueSignature = sprintf
    'UnitTest-OTRSEscalationEvents-%010d-%06d',
    time(),
    int( rand 1_000_000 );
my $StartingSystemTime = $Self->{TimeObject}->SystemTime();
my $StartingTimeStamp
    = $Self->{TimeObject}->SystemTime2TimeStamp( SystemTime => $StartingSystemTime );

# create a test queue with immediate escalation
my ( $QueueID, $QueueName );
{

    # Setting negative escalation times is a hack.
    # In the test script there should be no need to wait.
    # But they shouldn't be 0, as false value turn off escalation.
    $QueueName = "Queue-$UniqueSignature";
    $QueueID   = $QueueObject->QueueAdd(
        Name                => $QueueName,
        ValidID             => 1,
        GroupID             => 1,
        FirstResponseTime   => -10,
        FirstResponseNotify => 80,
        UpdateTime          => -20,
        UpdateNotify        => 80,
        SolutionTime        => -40,
        SolutionNotify      => 80,
        SystemAddressID     => 1,
        SalutationID        => 1,
        SignatureID         => 1,
        UserID              => 1,
        Comment => "Queue for OTRSEscalationEvents.t for test run at $StartingTimeStamp",
    );
    $Self->True( $QueueID, "QueueAdd() $QueueName" );

    # sanity check
    my %Queue = $QueueObject->QueueGet(
        ID     => $QueueID,
        UserID => 1,
    );
    $Self->Is( $Queue{Name},    $QueueName, "QueueGet() $QueueName - Name" );
    $Self->Is( $Queue{QueueID}, $QueueID,   "QueueGet() $QueueName - QueueID" );
}

# add a test ticket
my $TicketID;
{

    # TicketEscalationIndexBuild() is called implicitly
    # by the TicketEscalationIndex event handler.
    my $TicketTitle = "Ticket-$UniqueSignature";
    $TicketID = $TicketObject->TicketCreate(
        Title      => $TicketTitle,
        QueueID    => $QueueID,
        Lock       => 'unlock',
        PriorityID => 1,
        StateID    => 1,
        OwnerID    => 1,
        UserID     => 1,
    );
    $Self->True( $TicketID, "TicketCreate() $TicketTitle" );

    # sleep to have escalations with min 1
    sleep 1;

    my %Ticket = $TicketObject->TicketGet( TicketID => $TicketID );

    # sanity check
    $Self->Is( $Ticket{TicketID}, $TicketID,    "TicketGet() $TicketTitle - ID" );
    $Self->Is( $Ticket{Title},    $TicketTitle, "TicketGet() $TicketTitle - Title" );

    # the ticket should be escalated.
    $Self->True(
        $Ticket{EscalationDestinationTime},
        "TicketGet() $TicketTitle - EscalationDestinationTime is set"
    );
    $Self->True( $Ticket{EscalationTime}, "TicketGet() $TicketTitle - EscalationTime is set" );
    $Self->True(
        $Ticket{EscalationTime} < 0,
        "TicketGet() $TicketTitle - EscalationTime less than 0"
    );

    # first response time escalation
    $Self->True(
        $Ticket{EscalationResponseTime},
        "TicketGet() $TicketTitle - EscalationResponseTime is set"
    );
    $Self->True(
        $Ticket{FirstResponseTimeEscalation},
        "TicketGet() $TicketTitle - FirstResponseTimeEscalation is set"
    );
    $Self->False(
        $Ticket{FirstResponseTimeNotification},
        "TicketGet() $TicketTitle - FirstResponseTimeNotification is not set"
    );
    $Self->True(
        $Ticket{FirstResponseTime},
        "TicketGet() $TicketTitle - FirstResponseTime is set"
    );
    $Self->True(
        $Ticket{FirstResponseTime} < 0,
        "TicketGet() $TicketTitle - FirstResponseTime less than 0"
    );

    # no update escalation, es there was no communication with the customer yet
    $Self->False(
        $Ticket{EscalationUpdateTime},
        "TicketGet() $TicketTitle - EscalationUpdateTime is not set"
    );
    $Self->False(
        $Ticket{UpdateTimeEscalation},
        "TicketGet() $TicketTitle - UpdateTimeEscalation is not set"
    );
    $Self->False(
        $Ticket{UpdateTimeNotification},
        "TicketGet() $TicketTitle - UpdateTimeNotification is not set"
    );

    # solution time escalation
    $Self->True(
        $Ticket{EscalationSolutionTime},
        "TicketGet() $TicketTitle - EscalationSolutionTime is set"
    );
    $Self->True(
        $Ticket{SolutionTimeEscalation},
        "TicketGet() $TicketTitle - SolutionTimeEscalation is set"
    );
    $Self->False(
        $Ticket{SolutionTimeNotification},
        "TicketGet() $TicketTitle - SolutionTimeNotification is not set"
    );
    $Self->True( $Ticket{SolutionTime},     "TicketGet() $TicketTitle - SolutionTime is set" );
    $Self->True( $Ticket{SolutionTime} < 0, "TicketGet() $TicketTitle - SolutionTime less than 0" );
}

my $CheckNumEvents = sub {
    my (%Param) = @_;

    my $JobName = $Param{JobName} || '';

    if ($JobName) {
        my $JobRun = $Param{GenericAgentObject}->JobRun(
            Job    => $JobName,
            Config => {
                Escalation => 1,
                Queue      => $Param{QueueName},
                New        => {
                    Module => 'Kernel::System::GenericAgent::TriggerEscalationStartEvents',
                },
            },
            UserID => 1,
        );
        $Self->True( $JobRun, "JobRun() $JobName Run the GenericAgent job" );
    }

    my @Lines = $Param{TicketObject}->HistoryGet(
        TicketID => $Param{TicketID},
        UserID   => 1,
    );

    my $Comment = $Param{Comment} || "after $JobName";

    while ( my ( $Event, $NumEvents ) = each %{ $Param{NumEvents} } ) {
        my @EventLines = grep { $_->{HistoryType} eq $Event } @Lines;
        $Self->Is( scalar(@EventLines), $NumEvents, "check num of $Event events, $Comment" );

        # keep current number for reference
        $Param{NumEvents}->{$Event} = scalar @EventLines;
    }

    return;
};

# Set up the expected number of emitted events.
my %NumEvents;
{

    # Right after ticket creation, no events should have been emitted.
    # The not yet supported events, should never be emitted.
    %NumEvents = (
        EscalationNotifyBefore             => 0,    # not yet supported
        EscalationResponseTimeNotifyBefore => 0,
        EscalationUpdateTimeNotifyBefore   => 0,
        EscalationSolutionTimeNotifyBefore => 0,
        EscalationStart                    => 0,    # not yet supported
        EscalationResponseTimeStart        => 0,
        EscalationUpdateTimeStart          => 0,
        EscalationSolutionTimeStart        => 0,
        EscalationStop                     => 0,    # not yet supported
        EscalationResponseTimeStop         => 0,    # not yet supported
        EscalationUpdateTimeStop           => 0,    # not yet supported
        EscalationSolutionTimeStop         => 0,    # not yet supported
    );
    $CheckNumEvents->(
        GenericAgentObject => $GenericAgentObject,
        TicketObject       => $TicketObject,
        TicketID           => $TicketID,
        NumEvents          => \%NumEvents,
        QueueName          => $QueueName,
        Comment            => 'after ticket create',
    );
}

# run GenericAgent job for triggering
# EscalationResponseTimeStart and EscalationSolutionTimeStart
{

    # check whether events were triggered: first response escalation, solution time escalation
    $NumEvents{EscalationSolutionTimeStart}++;
    $NumEvents{EscalationResponseTimeStart}++;
    $CheckNumEvents->(
        GenericAgentObject => $GenericAgentObject,
        TicketObject       => $TicketObject,
        TicketID           => $TicketID,
        NumEvents          => \%NumEvents,
        JobName            => "Job1-$UniqueSignature",
        QueueName          => $QueueName,
    );
}

# run GenericAgent job again, with suppressed event generation
{
    $ConfigObject->Set(
        Key   => 'OTRSEscalationEvents::DecayTime',
        Value => 100,
    );

    # check whether events were triggered
    $CheckNumEvents->(
        GenericAgentObject => $GenericAgentObject,
        TicketObject       => $TicketObject,
        TicketID           => $TicketID,
        NumEvents          => \%NumEvents,
        JobName            => "Job2-$UniqueSignature",
        QueueName          => $QueueName,
    );
}

# run GenericAgent job again, without suppressed event generation
{
    $ConfigObject->Set(
        Key   => 'OTRSEscalationEvents::DecayTime',
        Value => 0,
    );

    # check whether events were triggered: first response escalation, solution time escalation
    $NumEvents{EscalationSolutionTimeStart}++;
    $NumEvents{EscalationResponseTimeStart}++;
    $CheckNumEvents->(
        GenericAgentObject => $GenericAgentObject,
        TicketObject       => $TicketObject,
        TicketID           => $TicketID,
        NumEvents          => \%NumEvents,
        JobName            => "Job3-$UniqueSignature",
        QueueName          => $QueueName,
    );
}

# generate an response and see the first response escalation go away
{
    $ConfigObject->Set(
        Key   => 'OTRSEscalationEvents::DecayTime',
        Value => 0,
    );

    # first response
    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID,
        ArticleType    => 'phone',
        SenderType     => 'agent',
        From           => 'Agent Some Agent Some Agent <email@example.com>',
        To             => 'Customer A <customer-a@example.com>',
        Cc             => 'Customer B <customer-b@example.com>',
        ReplyTo        => 'Customer B <customer-b@example.com>',
        Subject        => 'first response',
        Body           => 'irgendwie und sowieso',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'first response',
        UserID         => 1,
        NoAgentNotify => 1,    # if you don't want to send agent notifications
    );

    # check whether events were triggered
    # the first response escalation goes away, update time escalation is triggered
    $NumEvents{EscalationSolutionTimeStart}++;
    $NumEvents{EscalationUpdateTimeStart}++;
    $CheckNumEvents->(
        GenericAgentObject => $GenericAgentObject,
        TicketObject       => $TicketObject,
        TicketID           => $TicketID,
        NumEvents          => \%NumEvents,
        JobName            => "Job4-$UniqueSignature",
        QueueName          => $QueueName,
    );
}

# no new escalations when escalation times are far in the future
{
    $ConfigObject->Set(
        Key   => 'OTRSEscalationEvents::DecayTime',
        Value => 0,
    );

    # set the escalation into the future
    my %Queue = $QueueObject->QueueGet(
        ID     => $QueueID,
        UserID => 1,
    );
    my $QueueUpdate = $QueueObject->QueueUpdate(
        %Queue,
        FirstResponseTime => 100,
        UpdateTime        => 200,
        SolutionTime      => 300,
        Comment           => 'escalations in the future',
        UserID            => 1,
    );
    $Self->True( $QueueUpdate, "QueueUpdate() $QueueName" );

    # we have change the queue, but the ticket does not know that
    # invalidate the cache for the next TicketGet
    delete $TicketObject->{ 'Cache::GetTicket' . $TicketID };

    # trigger an update
    # a note internal does not make the update time escalation go away
    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID,
        ArticleType    => 'note-internal',
        SenderType     => 'agent',
        From           => 'Agent Some Agent Some Agent <email@example.com>',
        To             => 'Customer A <customer-a@example.com>',
        Cc             => 'Customert B <customer-b@example.com>',
        ReplyTo        => 'Customer B <customer-b@example.com>',
        Subject        => 'some short description',
        Body           => 'irgendwie und sowieso',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify => 1,    # if you don't want to send agent notifications
    );

    $CheckNumEvents->(
        GenericAgentObject => $GenericAgentObject,
        TicketObject       => $TicketObject,
        TicketID           => $TicketID,
        NumEvents          => \%NumEvents,
        JobName            => "Job5-$UniqueSignature",
        QueueName          => $QueueName,
    );
}

# no new start escalations when escalation times are in the future
# notify before escalations because immediate notification were turned on
{
    $ConfigObject->Set(
        Key   => 'OTRSEscalationEvents::DecayTime',
        Value => 0,
    );

    # set the escalation into the future, but less than 60 Minutes,
    # 60 minutes is relevant for GetOverTimeTickets().
    # Set up NotifyBefore at 10%, which is less than the expected reached percentage of 50%.
    # reached percentage = ( 'passed time' / 'configured time' ) * 100 = ( 1 / 2 ) * 100
    my %Queue = $QueueObject->QueueGet(
        ID     => $QueueID,
        UserID => 1,
    );
    my $QueueUpdate = $QueueObject->QueueUpdate(
        %Queue,
        FirstResponseTime   => 2,
        FirstResponseNotify => 10,
        UpdateTime          => 2,
        UpdateNotify        => 10,
        SolutionTime        => 2,
        SolutionNotify      => 10,
        Comment             => 'escalations in the future, immediate warnings',
        UserID              => 1,
    );
    $Self->True( $QueueUpdate, "QueueUpdate() $QueueName" );

    # as queue has changed, the escalation times have changed
    # trigger an update of escalation times in the database
    $TicketObject->TicketEscalationIndexBuild(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # make sure that a least a minute is taken off the used up time
    # A timespan of less than 1 minute comes up the 0% reached.
    # However, a NotifyBefore of 0% indicates that no NotifyBefore is emitted.
    $Self->True( 1, 'sleeping for 41 s, percentage reached should not be 0%' );
    sleep 41;

    # explicitly invalidate the cache for the next TicketGet(),
    # as TicketEscalationIndexBuild() of OTRS 2.4.7  does not care
    delete $TicketObject->{ 'Cache::GetTicket' . $TicketID };

    $NumEvents{EscalationSolutionTimeNotifyBefore}++;
    $NumEvents{EscalationUpdateTimeNotifyBefore}++;
    $CheckNumEvents->(
        GenericAgentObject => $GenericAgentObject,
        TicketObject       => $TicketObject,
        TicketID           => $TicketID,
        NumEvents          => \%NumEvents,
        JobName            => "Job6-$UniqueSignature",
        QueueName          => $QueueName,
    );
}

# clean up
{

    # clean up ticket
    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True( $TicketDelete || '', "TicketDelete() $TicketID" );

    # queues can't be deleted

    # no need to clean up generic agent job, as it wasn't entered in the database
}

1;
