# --
# Kernel/Output/HTML/NotificationAgentTicketEscalation.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketEscalation;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Group',
    'Kernel::System::Lock',
    'Kernel::System::Log',
    'Kernel::System::State',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw( LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # get needed objects
    $Self->{ConfigObject} //= $Kernel::OM->Get('Kernel::Config');
    $Self->{CacheObject}  //= $Kernel::OM->Get('Kernel::System::Cache');
    $Self->{DBObject}     //= $Kernel::OM->Get('Kernel::System::DB');
    $Self->{LogObject}    //= $Kernel::OM->Get('Kernel::System::Log');
    $Self->{GroupObject}   //= $Kernel::OM->Get('Kernel::System::Group');
    $Self->{LockObject}   //= $Kernel::OM->Get('Kernel::System::Lock');
    $Self->{StateObject} //= $Kernel::OM->Get('Kernel::System::State');
    $Self->{TicketObject} //= $Kernel::OM->Get('Kernel::System::Ticket');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # only show the escalations on ticket overviews
    return ''
        if $Self->{LayoutObject}->{Action}
        !~ /^AgentTicket(Queue|(Status|Locked|Watch|Responsible)View)/;

    # check result cache
    my $CacheTime = $Param{Config}->{CacheTime} || 40;
    if ($CacheTime) {
        my $Output = $Self->{CacheObject}->Get(
            Type => 'TicketEscalation',
            Key  => 'EscalationResult::' . $Self->{UserID},
        );
        return $Output if defined $Output;
    }

    # get all overtime tickets
    my $ShownMax            = $Param{Config}->{ShownMax}            || 25;
    my $EscalationInMinutes = $Param{Config}->{EscalationInMinutes} || 120;
    my @TicketIDs           = $Self->{TicketObject}->TicketSearch(
        Result                           => 'ARRAY',
        Limit                            => $ShownMax,
        TicketEscalationTimeOlderMinutes => -$EscalationInMinutes,
        Permission                       => 'rw',
        UserID                           => $Self->{UserID},
    );

    # get escalations
    my $ResponseTime = '';
    my $UpdateTime   = '';
    my $SolutionTime = '';
    my $Comment      = '';
    my $Count        = 0;
    for my $TicketID (@TicketIDs) {
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        # check response time
        if ( defined $Ticket{FirstResponseTime} ) {
            $Ticket{FirstResponseTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Ticket{FirstResponseTime},
                Space => ' ',
            );
            if ( $Ticket{FirstResponseTimeEscalation} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketEscalationFirstResponseTimeOver',
                    Data => \%Ticket,
                );
                my $Data = $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $ResponseTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Data     => $Data,
                );
                $Count++;
            }
            elsif ( $Ticket{FirstResponseTimeNotification} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketEscalationFirstResponseTimeWillBeOver',
                    Data => \%Ticket,
                );
                my $Data = $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $ResponseTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Data     => $Data,
                );
                $Count++;
            }
        }

        # check update time
        if ( defined $Ticket{UpdateTime} ) {
            $Ticket{UpdateTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Ticket{UpdateTime},
                Space => ' ',
            );
            if ( $Ticket{UpdateTimeEscalation} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketEscalationUpdateTimeOver',
                    Data => \%Ticket,
                );
                my $Data = $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $UpdateTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Data     => $Data,
                );
                $Count++;
            }
            elsif ( $Ticket{UpdateTimeNotification} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketEscalationUpdateTimeWillBeOver',
                    Data => \%Ticket,
                );
                my $Data = $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $UpdateTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Data     => $Data,
                );
                $Count++;
            }
        }

        # check solution
        if ( defined $Ticket{SolutionTime} ) {
            $Ticket{SolutionTimeHuman} = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Ticket{SolutionTime},
                Space => ' ',
            );
            if ( $Ticket{SolutionTimeEscalation} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketEscalationSolutionTimeOver',
                    Data => \%Ticket,
                );
                my $Data = $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $SolutionTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Data     => $Data,
                );
                $Count++;
            }
            elsif ( $Ticket{SolutionTimeNotification} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketEscalationSolutionTimeOver',
                    Data => \%Ticket,
                );
                my $Data = $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketEscalation',
                    Data         => \%Param,
                );
                $SolutionTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Data     => $Data,
                );
                $Count++;
            }
        }
    }
    if ( $Count == $ShownMax ) {
        $Comment .= $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => 'There are more escalated tickets!',
        );
    }
    my $Output = $ResponseTime . $UpdateTime . $SolutionTime . $Comment;

    # cache result
    if ($CacheTime) {
        $Self->{CacheObject}->Set(
            Type  => 'TicketEscalation',
            Key   => 'EscalationResult::' . $Self->{UserID},
            Value => $Output,
            TTL   => $CacheTime,
        );
    }

    return $Output;
}

1;
