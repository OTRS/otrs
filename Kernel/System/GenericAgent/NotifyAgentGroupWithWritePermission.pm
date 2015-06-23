# --
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

    # trigger notification event
    $Self->EventHandler(
        Event => 'Notification' . $EscalationType,
        Data  => {
            TicketID              => $Param{TicketID},
            CustomerMessageParams => \%Param,
        },
        UserID => 1,
    );

    return 1;
}

1;
