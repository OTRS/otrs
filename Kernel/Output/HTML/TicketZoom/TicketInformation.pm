# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketZoom::TicketInformation;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = \%Param;
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Ticket    = %{ $Param{Ticket} };
    my %AclAction = %{ $Param{AclAction} };

    if ( $Ticket{ArchiveFlag} eq 'y' ) {
        $LayoutObject->Block(
            Name => 'ArchiveFlag',
            Data => { %Ticket, %AclAction },
        );
    }

    # ticket type
    if ( $ConfigObject->Get('Ticket::Type') ) {

        my %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeGet(
            ID => $Ticket{TypeID},
        );

        $LayoutObject->Block(
            Name => 'Type',
            Data => {
                Valid => $Type{ValidID},
                %Ticket,
                %AclAction
            },
        );
    }

    # ticket service
    if ( $ConfigObject->Get('Ticket::Service') && $Ticket{Service} ) {
        $LayoutObject->Block(
            Name => 'Service',
            Data => { %Ticket, %AclAction },
        );
        if ( $Ticket{SLA} ) {
            $LayoutObject->Block(
                Name => 'SLA',
                Data => { %Ticket, %AclAction },
            );
        }
    }

    # show first response time if needed
    if ( defined $Ticket{FirstResponseTime} ) {
        $Ticket{FirstResponseTimeHuman} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{FirstResponseTime},
            Space => ' ',
        );
        $Ticket{FirstResponseTimeWorkingTime} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{FirstResponseTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Ticket{FirstResponseTime} ) {
            $Ticket{FirstResponseTimeClass} = 'Warning';
        }
        $LayoutObject->Block(
            Name => 'FirstResponseTime',
            Data => { %Ticket, %AclAction },
        );
    }

    # show update time if needed
    if ( defined $Ticket{UpdateTime} ) {
        $Ticket{UpdateTimeHuman} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{UpdateTime},
            Space => ' ',
        );
        $Ticket{UpdateTimeWorkingTime} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{UpdateTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Ticket{UpdateTime} ) {
            $Ticket{UpdateTimeClass} = 'Warning';
        }
        $LayoutObject->Block(
            Name => 'UpdateTime',
            Data => { %Ticket, %AclAction },
        );
    }

    # show solution time if needed
    if ( defined $Ticket{SolutionTime} ) {
        $Ticket{SolutionTimeHuman} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{SolutionTime},
            Space => ' ',
        );
        $Ticket{SolutionTimeWorkingTime} = $LayoutObject->CustomerAgeInHours(
            Age   => $Ticket{SolutionTimeWorkingTime},
            Space => ' ',
        );
        if ( 60 * 60 * 1 > $Ticket{SolutionTime} ) {
            $Ticket{SolutionTimeClass} = 'Warning';
        }
        $LayoutObject->Block(
            Name => 'SolutionTime',
            Data => { %Ticket, %AclAction },
        );
    }

    # show total accounted time if feature is active:
    if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
        $Ticket{TicketTimeUnits} = $Kernel::OM->Get('Kernel::System::Ticket')->TicketAccountedTimeGet(%Ticket);
        $LayoutObject->Block(
            Name => 'TotalAccountedTime',
            Data => \%Ticket,
        );
    }

    # show pending until, if set:
    if ( $Ticket{UntilTime} ) {
        if ( $Ticket{UntilTime} < -1 ) {
            $Ticket{PendingUntilClass} = 'Warning';
        }

        # get time object
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

        $Ticket{UntilTimeHuman} = $TimeObject->SystemTime2TimeStamp(
            SystemTime => ( $Ticket{UntilTime} + $TimeObject->SystemTime() ),
        );
        $Ticket{PendingUntil} .= $LayoutObject->CustomerAge(
            Age   => $Ticket{UntilTime},
            Space => ' '
        );
        $LayoutObject->Block(
            Name => 'PendingUntil',
            Data => \%Ticket,
        );
    }

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # owner info
    my %OwnerInfo = $UserObject->GetUserData(
        UserID => $Ticket{OwnerID},
    );
    $LayoutObject->Block(
        Name => 'Owner',
        Data => { %Ticket, %OwnerInfo, %AclAction },
    );

    if ( $ConfigObject->Get('Ticket::Responsible') ) {

        # show responsible
        my %ResponsibleInfo = $UserObject->GetUserData(
            UserID => $Ticket{ResponsibleID} || 1,
        );

        $LayoutObject->Block(
            Name => 'Responsible',
            Data => { %Ticket, %ResponsibleInfo, %AclAction },
        );
    }

    # set display options
    $Param{WidgetTitle} = Translatable('Ticket Information');
    $Param{Hook} = $ConfigObject->Get('Ticket::Hook') || 'Ticket#';

    # check if ticket is normal or process ticket
    my $IsProcessTicket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCheckForProcessType(
        'TicketID' => $Self->{TicketID}
    );

    # overwrite display options for process ticket
    if ($IsProcessTicket) {
        $Param{WidgetTitle} = $Self->{DisplaySettings}->{ProcessDisplay}->{WidgetTitle};
    }

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom/TicketInformation',
        Data         => { %Param, %Ticket, %AclAction },
    );

    return {
        Output => $Output,
    };
}

1;
