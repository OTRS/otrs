# --
# Kernel/System/GenericAgent/NotifyAgentGroupOfCustomQueue.pm - generic agent notifications
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NotifyAgentGroupOfCustomQueue.pm,v 1.5 2004-12-10 09:17:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::GenericAgent::NotifyAgentGroupOfCustomQueue;

use strict;
use Kernel::System::User;
use Kernel::System::Email;
use Kernel::System::Queue;
use Kernel::System::Notification;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject TicketObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{UserObject} = Kernel::System::User->new(%Param);
    $Self->{EmailObject} = Kernel::System::Email->new(%Param);
    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(%Param);
    # get agentss who are sucscribed the ticket queue to the custom queues
    my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(
        QueueID => $Ticket{QueueID},
    );
    # send each agent the escalation notification 
    foreach (@UserIDs) {
        my %User = $Self->{UserObject}->GetUserData(UserID => $_, Valid => 1);
        # send agent notification
        $Self->{TicketObject}->SendAgentNotification(
            Type => 'Escalation',
            UserData => \%User,
            CustomerMessageParams => \%Param,
            TicketID => $Param{TicketID},
            UserID => 1,
        );
    }
    return 1;
}
# --
1;
