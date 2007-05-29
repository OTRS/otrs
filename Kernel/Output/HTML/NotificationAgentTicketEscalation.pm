# --
# Kernel/Output/HTML/NotificationAgentTicketEscalation.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NotificationAgentTicketEscalation.pm,v 1.5 2007-05-29 12:30:04 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketEscalation;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
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
    my $Comment = '';
    my $Count = 0;
    foreach my $TicketID (@TicketIDs) {
        # just use the oldest 30 ticktes
        if ($Count > 30) {
            $Count = 100;
            last;
        }
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
