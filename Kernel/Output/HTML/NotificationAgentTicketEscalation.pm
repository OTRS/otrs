# --
# Kernel/Output/HTML/NotificationAgentTicketEscalation.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NotificationAgentTicketEscalation.pm,v 1.1 2007-03-16 10:06:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketEscalation;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
    my $Output = '';
    if ($Self->{LayoutObject}->{Action} !~ /^AgentTicket(Queue|Mailbox|Status)/) {
        return '';
    }
    # get all open rw ticket
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        Result => 'ARRAY',
        StateType => 'Open',
        UserID => $Self->{UserID},
    );
    # check sla preferences
    foreach my $TicketID (@TicketIDs) {
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $TicketID);
        # check response time
        if (defined($Ticket{'FirstResponseTime'})) {
                my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age => $Ticket{'FirstResponseTimeWorkingTime'},
                    Space => ' ',
                );
                if (0 > $Ticket{'FirstResponseTimeWorkingTime'}) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Error',
                        Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
                        Data => '$Text{"Ticket %s response time is over!", "'.$Ticket{TicketNumber}.'"}'." vor ($TimeHuman/$Ticket{'FirstResponseTimeDestinationDate'})",
                    );
                }
                elsif (60*60*2 > $Ticket{'FirstResponseTimeWorkingTime'}) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Notice',
                        Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
                        Data => '$Text{"Ticket %s response time will be over!", "'.$Ticket{TicketNumber}.'"}'." in ($TimeHuman/$Ticket{'FirstResponseTimeDestinationDate'})",
                    );
                }
        }
        # check update time
        if (defined($Ticket{'UpdateTime'})) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age => $Ticket{'UpdateTimeWorkingTime'},
                    Space => ' ',
            );
            if (0 >= $Ticket{'UpdateTimeWorkingTime'}) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Error',
                        Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
                        Data => '$Text{"Ticket %s update time is over!", "'.$Ticket{TicketNumber}.'"}'." vor ($TimeHuman/$Ticket{'UpdateTimeDestinationDate'})",
                    );
            }
            elsif (60*60*2.2 > $Ticket{'UpdateTimeWorkingTime'}) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Notice',
                        Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
                        Data => '$Text{"Ticket %s update time will be over!", "'.$Ticket{TicketNumber}.'"}'." in ($TimeHuman/$Ticket{'UpdateTimeDestinationDate'})",
                    );
            }
        }
        # check solution
        if (defined($Ticket{'SolutionTime'})) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age => $Ticket{'SolutionTimeWorkingTime'},
                    Space => ' ',
            );
            if (0 >= $Ticket{'SolutionTimeWorkingTime'}) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Error',
                        Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
                        Data => '$Text{"Ticket %s solution tim is over!", "'.$Ticket{TicketNumber}.'"}'." vor ($TimeHuman/$Ticket{'SolutionTimeDestinationDate'})",
                    );
            }
            elsif (60*60*2.2 > $Ticket{'SolutionTimeWorkingTime'}) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Notice',
                        Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
                        Data => '$Text{"Ticket %s solution time will be over!", "'.$Ticket{TicketNumber}.'"}'." in ($TimeHuman/$Ticket{'SolutionTimeDestinationDate'})",
                    );
            }
        }
    }
    return $Output;
}

1;
