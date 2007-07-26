# --
# Kernel/Output/HTML/NotificationAgentTicketEscalation.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NotificationAgentTicketEscalation.pm,v 1.7 2007-07-26 13:45:53 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketEscalation;

use strict;
use Kernel::System::Lock;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject TicketObject GroupObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{LockObject} = Kernel::System::Lock->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    if ($Self->{LayoutObject}->{Action} !~ /^AgentTicket(Queue|Mailbox|Status)/) {
        return '';
    }
    # get all open rw ticket
    my @TicketIDs = ();
    my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
        Type => 'Viewable',
        Result => 'ID',
    );
    my @ViewableLockIDs = $Self->{LockObject}->LockViewableLock(Type => 'ID');
    my $SQL = "SELECT st.id, st.tn, st.escalation_start_time, st.escalation_response_time, st.escalation_solution_time, ".
        "st.ticket_state_id, st.service_id, st.sla_id, st.create_time, st.queue_id, st.ticket_lock_id ".
        " FROM ".
        " queue q, ticket st ".
        " WHERE ".
        " st.ticket_state_id IN ( ${\(join ', ', @ViewableStateIDs)} ) " .
        " AND " .
        " q.id = st.queue_id ".
        " AND ";
    my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
        UserID => $Self->{UserID},
        Type => 'rw',
        Result => 'ID',
        Cached => 1,
    );
    $SQL .= " q.group_id IN ( ${\(join ', ', @GroupIDs)} ) AND ";
    # check if user is in min. one group! if not, return here
    if (!@GroupIDs) {
        return;
    }
    $SQL .= " st.ticket_lock_id IN ( ${\(join ', ', @ViewableLockIDs)} ) ";
    $SQL .= " ORDER BY st.escalation_start_time ASC";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 5000);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my $TicketData = {
            TicketID => $Row[0],
            TicketNumber => $Row[1],
            EscalationStartTime => $Row[2],
            EscalationResponseTime => $Row[3],
            EscalationSolutionTime => $Row[4],
            StateID => $Row[5],
            ServiceID => $Row[6],
            SLAID => $Row[7],
            Created => $Row[8],
            QueueID => $Row[9],
            LockID => $Row[10],
        };
        push (@TicketIDs, $TicketData);
    }
    # get state infos
    foreach my $TicketData (@TicketIDs) {
        # get state info
        my %StateData = $Self->{StateObject}->StateGet(ID => $TicketData->{StateID}, Cache => 1);
        $TicketData->{StateType} = $StateData{TypeName};
        $TicketData->{State} = $StateData{Name};
        $TicketData->{Lock} = $Self->{LockObject}->LockLookup(LockID => $TicketData->{LockID});
    }
    # get escalations
    my $ResponseTime = '';
    my $UpdateTime = '';
    my $SolutionTime = '';
    my $Comment = '';
    my $Count = 0;
    foreach my $TicketData (@TicketIDs) {
        my %Ticket = %{$TicketData};
        my $TicketID = $Ticket{TicketID};
        # just use the oldest 30 ticktes
        if ($Count > 30) {
            $Count = 100;
            last;
        }
        %Ticket = (%Ticket, $Self->{TicketObject}->TicketEscalationState(
            TicketID => $TicketID,
            Ticket => $TicketData,
            UserID => $Self->{UserID},
        ));
        foreach (qw(FirstResponseTimeDestinationDate UpdateTimeDestinationDate SolutionTimeDestinationDate)) {
            if ($Ticket{$_}) {
                $Ticket{$_} = $Self->{LayoutObject}->{LanguageObject}->FormatTimeString($Ticket{$_}, undef, 'NoSeconds')
            }
        }
        # check response time
        if (defined($Ticket{'FirstResponseTime'})) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                Age => $Ticket{'FirstResponseTime'},
                Space => ' ',
            );
            if ($Ticket{'FirstResponseTimeEscalation'}) {
                $ResponseTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: first response time is over (%s)!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'FirstResponseTimeDestinationDate'}\"}",
                );
                $Count++;
            }
            elsif ($Ticket{'FirstResponseTimeNotification'}) {
                $ResponseTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: first response time will be over in %s!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'FirstResponseTimeDestinationDate'}\"}",
                );
                $Count++;
            }
        }
        # check update time
        if (defined($Ticket{'UpdateTime'})) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                Age => $Ticket{'UpdateTime'},
                Space => ' ',
            );
            if ($Ticket{'UpdateTimeEscalation'}) {
                $UpdateTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: update time is over (%s)!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'UpdateTimeDestinationDate'}\"}",
                );
                $Count++;
            }
            elsif ($Ticket{'UpdateTimeNotification'}) {
                $UpdateTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: update time will be over in %s!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'UpdateTimeDestinationDate'}\"}",
                );
                $Count++;
            }
        }
        # check solution
        if (defined($Ticket{'SolutionTime'})) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                Age => $Ticket{'SolutionTime'},
                Space => ' ',
            );
            if ($Ticket{'SolutionTimeEscalation'}) {
                $SolutionTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: solution time is over (%s)!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'SolutionTimeDestinationDate'}\"}",
                );
                $Count++;
            }
            elsif ($Ticket{'SolutionTimeNotification'}) {
                $SolutionTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: solution time will be over in %s!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'SolutionTimeDestinationDate'}\"}",
                );
                $Count++;
            }
        }
    }
    if ($Count == 100) {
        $Comment .= $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info => "There are more escalated tickets!",
        );
    }
    return $ResponseTime.$UpdateTime.$SolutionTime.$Comment;
}

1;
