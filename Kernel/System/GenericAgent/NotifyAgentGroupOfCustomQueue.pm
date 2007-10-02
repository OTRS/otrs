# --
# Kernel/System/GenericAgent/NotifyAgentGroupOfCustomQueue.pm - generic agent notifications
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NotifyAgentGroupOfCustomQueue.pm,v 1.14 2007-10-02 10:36:47 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::GenericAgent::NotifyAgentGroupOfCustomQueue;

use strict;
use warnings;

use Kernel::System::User;
use Kernel::System::Email;
use Kernel::System::Queue;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TicketObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{UserObject}  = Kernel::System::User->new(%Param);
    $Self->{EmailObject} = Kernel::System::Email->new(%Param);
    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(%Param);

    # check if bussines hours is, then send escalation info
    my $CountedTime = $Self->{TimeObject}->WorkingTime(
        StartTime => $Self->{TimeObject}->SystemTime() - ( 30 * 60 ),
        StopTime => $Self->{TimeObject}->SystemTime(),
    );
    if ( !$CountedTime ) {
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message =>
                    "Send not escalation for Ticket $Ticket{TicketNumber}/$Ticket{TicketID} because currently no working hours!",
            );
        }
        return 1;
    }

    # get agentss who are sucscribed the ticket queue to the custom queues
    my @UserIDs
        = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID( QueueID => $Ticket{QueueID}, );

    # send each agent the escalation notification
    for my $UserID (@UserIDs) {
        my %User = $Self->{UserObject}->GetUserData( UserID => $UserID, Valid => 1 );
        if (%User) {

            # check if today a reminder is already sent
            my ( $Sec, $Min, $Hour, $Day, $Month, $Year )
                = $Self->{TimeObject}
                ->SystemTime2Date( SystemTime => $Self->{TimeObject}->SystemTime(), );
            my @Lines = $Self->{TicketObject}->HistoryGet(
                TicketID => $Ticket{TicketID},
                UserID   => 1,
            );
            my $Sent = 0;
            for my $Line (@Lines) {
                if (   $Line->{Name} =~ /Escalation/
                    && $Line->{Name}       =~ /\Q$User{UserEmail}\E/i
                    && $Line->{CreateTime} =~ /$Year-$Month-$Day/ )
                {
                    $Sent = 1;
                }
            }
            if ($Sent) {
                next;
            }

            # send agent notification
            $Self->{TicketObject}->SendAgentNotification(
                Type                  => 'Escalation',
                UserData              => \%User,
                CustomerMessageParams => \%Param,
                TicketID              => $Param{TicketID},
                UserID                => 1,
            );
        }
    }
    return 1;
}

1;
