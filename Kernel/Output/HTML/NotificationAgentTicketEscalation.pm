# --
# Kernel/Output/HTML/NotificationAgentTicketEscalation.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NotificationAgentTicketEscalation.pm,v 1.3 2007-04-24 09:51:17 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketEscalation;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject TicketObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    if ($Self->{LayoutObject}->{Action} !~ /^AgentTicket(Queue|Mailbox|Status)/) {
        return '';
    }
    # get all open rw ticket
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        Result => 'ARRAY',
        StateType => 'Open',
        SortBy => 'Age',
        OrderBy => 'Up',
        UserID => $Self->{UserID},
    );
    # check sla preferences
    my $ResponseTime = '';
    my $UpdateTime = '';
    my $SolutionTime = '';
    foreach my $TicketID (@TicketIDs) {
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $TicketID);
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

            if (0 > $Ticket{'FirstResponseTimeWorkingTime'}) {
                $ResponseTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: first response time is over (%s)!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'FirstResponseTimeDestinationDate'}\"}",
                );
            }
            elsif (60*60*2 > $Ticket{'FirstResponseTimeWorkingTime'}) {
                $ResponseTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: first response time will be over in %s!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'FirstResponseTimeDestinationDate'}\"}",
                );
            }
        }
        # check update time
        if (defined($Ticket{'UpdateTime'})) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                Age => $Ticket{'UpdateTime'},
                Space => ' ',
            );
            if (0 >= $Ticket{'UpdateTimeWorkingTime'}) {
                $UpdateTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: update time is over (%s)!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'UpdateTimeDestinationDate'}\"}",
                );
            }
            elsif (60*60*2.2 > $Ticket{'UpdateTimeWorkingTime'}) {
                $UpdateTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: update time will be over in %s!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'UpdateTimeDestinationDate'}\"}",
                );
            }
        }
        # check solution
        if (defined($Ticket{'SolutionTime'})) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                Age => $Ticket{'SolutionTime'},
                Space => ' ',
            );
            if (0 >= $Ticket{'SolutionTimeWorkingTime'}) {
                $SolutionTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: solution time is over (%s)!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'SolutionTimeDestinationDate'}\"}",
                );
            }
            elsif (60*60*2.2 > $Ticket{'SolutionTimeWorkingTime'}) {
                $SolutionTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='. $TicketID,
                    Data => '$Text{"Ticket %s: solution time will be over in %s!", "'.$Ticket{TicketNumber}."\", \"$TimeHuman / $Ticket{'SolutionTimeDestinationDate'}\"}",
                );
            }
        }
    }
    return $ResponseTime.$SolutionTime.$SolutionTime;
}

1;
