# --
# Kernel/Output/HTML/NotificationAgentTicketEscalation.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: NotificationAgentTicketEscalation.pm,v 1.21 2008-05-16 09:49:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketEscalation;

use strict;
use warnings;

use Kernel::System::Lock;
use Kernel::System::State;
use Kernel::System::Cache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.21 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject TicketObject GroupObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{LockObject}  = Kernel::System::Lock->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{CacheObject} = Kernel::System::Cache->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    return '' if $Self->{LayoutObject}->{Action} !~ /^AgentTicket(Queue|Mailbox|Status)/;

    # check result cache
    my $CacheTime = $Param{Config}->{CacheTime} || 180;
    if ($CacheTime) {
        my $Output = $Self->{CacheObject}->Get(
            Type => 'TicketEscalation',
            Key  => "EscalationResult::$Self->{UserID}",
        );
        if ( defined $Output ) {
            return $Output;
        }
    }

    # get all overtime tickets
    my $ShownMax            = $Param{Config}->{ShownMax} || 30;
    my $EscalationInMinutes = $Param{Config}->{EscalationInMinutes} || 120;
    my @TicketIDs           = $Self->{TicketObject}->TicketSearch(
        Result                      => 'ARRAY',
        Limit                       => $ShownMax,
        TicketEscalatationInMinutes => $EscalationInMinutes,
        UserID                      => $Param{UserID},
    );

    # get escalations
    my $ResponseTime = '';
    my $UpdateTime   = '';
    my $SolutionTime = '';
    my $Comment      = '';
    my $Count        = 0;
    for my $TicketID (@TicketIDs) {
        my %Ticket   = $Self->{TicketObject}->TicketGet( TicketID => $TicketID );

        for (
            qw(FirstResponseTimeDestinationDate UpdateTimeDestinationDate SolutionTimeDestinationDate)
            )
        {
            if ( $Ticket{$_} ) {
                $Ticket{$_} = $Self->{LayoutObject}->{LanguageObject}->FormatTimeString(
                    $Ticket{$_}, undef, 'NoSeconds'
                );
            }
        }

        # check response time
        if ( defined( $Ticket{FirstResponseTime} ) ) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Ticket{FirstResponseTime},
                Space => ' ',
            );
            if ( $Ticket{FirstResponseTimeEscalation} ) {
                $ResponseTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Link     => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID=' . $TicketID,
                    Data     => '$Text{"Ticket %s: first response time is over (%s)!", "'
                        . $Ticket{TicketNumber}
                        . "\", \"$TimeHuman / $Ticket{'FirstResponseTimeDestinationDate'}\"}",
                );
                $Count++;
            }
            elsif ( $Ticket{FirstResponseTimeNotification} ) {
                $ResponseTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Link     => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID=' . $TicketID,
                    Data     => '$Text{"Ticket %s: first response time will be over in %s!", "'
                        . $Ticket{TicketNumber}
                        . "\", \"$TimeHuman / $Ticket{'FirstResponseTimeDestinationDate'}\"}",
                );
                $Count++;
            }
        }

        # check update time
        if ( defined( $Ticket{UpdateTime} ) ) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Ticket{UpdateTime},
                Space => ' ',
            );
            if ( $Ticket{UpdateTimeEscalation} ) {
                $UpdateTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Link     => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID=' . $TicketID,
                    Data     => '$Text{"Ticket %s: update time is over (%s)!", "'
                        . $Ticket{TicketNumber}
                        . "\", \"$TimeHuman / $Ticket{'UpdateTimeDestinationDate'}\"}",
                );
                $Count++;
            }
            elsif ( $Ticket{UpdateTimeNotification} ) {
                $UpdateTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Link     => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID=' . $TicketID,
                    Data     => '$Text{"Ticket %s: update time will be over in %s!", "'
                        . $Ticket{TicketNumber}
                        . "\", \"$TimeHuman / $Ticket{'UpdateTimeDestinationDate'}\"}",
                );
                $Count++;
            }
        }

        # check solution
        if ( defined( $Ticket{SolutionTime} ) ) {
            my $TimeHuman = $Self->{LayoutObject}->CustomerAgeInHours(
                Age   => $Ticket{SolutionTime},
                Space => ' ',
            );
            if ( $Ticket{SolutionTimeEscalation} ) {
                $SolutionTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Link     => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID=' . $TicketID,
                    Data     => '$Text{"Ticket %s: solution time is over (%s)!", "'
                        . $Ticket{TicketNumber}
                        . "\", \"$TimeHuman / $Ticket{'SolutionTimeDestinationDate'}\"}",
                );
                $Count++;
            }
            elsif ( $Ticket{SolutionTimeNotification} ) {
                $SolutionTime .= $Self->{LayoutObject}->Notify(
                    Priority => 'Notice',
                    Link     => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID=' . $TicketID,
                    Data     => '$Text{"Ticket %s: solution time will be over in %s!", "'
                        . $Ticket{TicketNumber}
                        . "\", \"$TimeHuman / $Ticket{'SolutionTimeDestinationDate'}\"}",
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
            Key   => "EscalationResult::$Self->{UserID}",
            Value => $Output,
            TTL   => $CacheTime,
        );
    }

    return $Output;
}

1;
