# --
# Kernel/Output/HTML/NotificationAgentTicketSLA.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NotificationAgentTicketSLA.pm,v 1.1 2007-03-15 08:26:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketSLA;

use strict;
use Kernel::System::SLA;

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
    foreach (qw(ConfigObject LogObject DBObject LayoutObject TicketObject TimeObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{SLAObject} = Kernel::System::SLA->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
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
        if ($Ticket{'ResponseTimeTime'}) {
                my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age => $Ticket{'ResponseTimeWorkingTime'},
                    Space => ' ',
                );
                if (0 > $Ticket{'ResponseTimeWorkingTime'}) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Error',
                        Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
                        Data => '$Text{"Ticket %s response time is over!", "'.$Ticket{TicketNumber}.'"}'." vor ($TimeHuman/$Ticket{'ResponseTimeDestinationDate'})",
                    );
                }
                elsif (60*60*2 > $Ticket{'ResponseTimeWorkingTime'}) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Notice',
                        Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
                        Data => '$Text{"Ticket %s response time will be over!", "'.$Ticket{TicketNumber}.'"}'." in ($TimeHuman/$Ticket{'ResponseTimeDestinationDate'})",
                    );
                }
        }
        # check max time to repair
        if ($Ticket{'MaxTimeToRepairTime'}) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                    Age => $Ticket{'MaxTimeToRepairWorkingTime'},
                    Space => ' ',
            );
            if (0 >= $Ticket{'MaxTimeToRepairWorkingTime'}) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Error',
                        Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
                        Data => '$Text{"Ticket %s is over max time to repair!", "'.$Ticket{TicketNumber}.'"}'." vor ($TimeHuman/$Ticket{'MaxTimeToRepairDestinationDate'})",
                    );
            }
            elsif (60*60*2.2 > $Ticket{'MaxTimeToRepairWorkingTime'}) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Notice',
                        Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
                        Data => '$Text{"Ticket %s will be over max time to repair!", "'.$Ticket{TicketNumber}.'"}'." in ($TimeHuman/$Ticket{'MaxTimeToRepairDestinationDate'})",
                    );
            }
        }
    }
    return $Output;
}

1;
