# --
# Kernel/System/GenericAgent/NotifyAgentGroupWithWritePermission.pm - generic agent notifications
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericAgent::NotifyAgentGroupWithWritePermission;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Queue',
    'Kernel::System::SLA',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
    'Kernel::System::User',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket data
    my %Ticket = $TicketObject->TicketGet(
        %Param,
        DynamicFields => 0,
    );

    # get used calendar
    my $Calendar = $TicketObject->TicketCalendarGet(
        %Ticket,
    );

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # check if it is during business hours, then send escalation info
    my $CountedTime = $TimeObject->WorkingTime(
        StartTime => $TimeObject->SystemTime() - ( 10 * 60 ),
        StopTime  => $TimeObject->SystemTime(),
        Calendar  => $Calendar,
    );
    if ( !$CountedTime ) {
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message =>
                    "Send no escalation for Ticket $Ticket{TicketNumber}/$Ticket{TicketID} because currently no working hours!",
            );
        }
        return 1;
    }

    # check if it's a escalation or escalation notification
    # check escalation times
    my $EscalationType = '';
    TYPE:
    for my $Type (
        qw(FirstResponseTimeEscalation UpdateTimeEscalation SolutionTimeEscalation
        FirstResponseTimeNotification UpdateTimeNotification SolutionTimeNotification)
        )
    {
        if ( defined $Ticket{$Type} ) {
            if ( $Type =~ /TimeEscalation$/ ) {
                $EscalationType = 'Escalation';
                last TYPE;
            }
            elsif ( $Type =~ /TimeNotification$/ ) {
                $EscalationType = 'EscalationNotifyBefore';
                last TYPE;
            }
        }
    }

    # check
    if ( !$EscalationType ) {
        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message =>
                    "Can't send escalation for Ticket $Ticket{TicketNumber}/$Ticket{TicketID} because ticket is not escalated!",
            );
        }
        return;
    }

    # get rw member of group
    my %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet(
        ID    => $Ticket{QueueID},
        Cache => 1,
    );
    my @UserIDs = $Kernel::OM->Get('Kernel::System::Group')->GroupMemberList(
        GroupID => $Queue{GroupID},
        Type    => 'rw',
        Result  => 'ID',
    );

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # send each agent the escalation notification
    USER:
    for my $UserID (@UserIDs) {

        my %User = $UserObject->GetUserData(
            UserID => $UserID,
            Valid  => 1,
        );

        next USER if !%User || $User{OutOfOfficeMessage};

        # check if today a reminder is already sent
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
            SystemTime => $TimeObject->SystemTime(),
        );

        my @Lines = $TicketObject->HistoryGet(
            TicketID => $Ticket{TicketID},
            UserID   => 1,
        );

        my $Sent = 0;
        for my $Line (@Lines) {

            if (
                $Line->{Name} =~ /\%\%$EscalationType\%\%/
                && $Line->{Name} =~ /\Q%%$User{UserEmail}\E$/i
                && $Line->{CreateTime} =~ /$Year-$Month-$Day/
                )
            {
                $Sent = 1;
            }
        }

        next USER if $Sent;

        # send agent notification
        $TicketObject->SendAgentNotification(
            TicketID              => $Param{TicketID},
            CustomerMessageParams => \%Param,
            Type                  => $EscalationType,
            RecipientID           => $UserID,
            UserID                => 1,
        );
    }

    return 1;
}

1;
