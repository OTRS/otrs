# --
# Kernel/System/GenericAgent/NotifyAgentGroupOfCustomQueue.pm - generic agent notifications
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NotifyAgentGroupOfCustomQueue.pm,v 1.1 2004-02-08 22:20:34 martin Exp $
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
$VERSION = '$Revision: 1.1 $';
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
    my %Ticket = $Self->{TicketObject}->GetTicket(%Param);
    # get agentss who are sucscribed the ticket queue to the custom queues
    my @UserIDs = $Self->{QueueObject}->GetAllUserIDsByQueueID(
        QueueID => $Ticket{QueueID},
    );
    # send each agent the escalation notification 
    foreach (@UserIDs) {
        my %User = $Self->{UserObject}->GetUserData(UserID => $_);
        # send agent notification
        $Self->{TicketObject}->SendNotification(
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
