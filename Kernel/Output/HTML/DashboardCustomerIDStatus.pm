# --
# Kernel/Output/HTML/DashboardCustomerIDStatus.pm
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardCustomerIDStatus;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed parameters
    for my $Needed (qw(Config Name UserID)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{CacheKey} = $Self->{Name};

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} },

        # caching not needed
        CacheKey => undef,
        CacheTTL => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    return if !$Param{CustomerID};

    my $CustomerIDRaw = $Param{CustomerID};

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # escalated tickets
    my $Count = $TicketObject->TicketSearch(
        TicketEscalationTimeOlderMinutes => 1,
        CustomerIDRaw                    => $CustomerIDRaw,
        Result                           => 'COUNT',
        Permission                       => $Self->{Config}->{Permission},
        UserID                           => $Self->{UserID},
        CacheTTL                         => $Self->{Config}->{CacheTTLLocal} * 60,
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'ContentSmallCustomerIDStatusEscalatedTickets',
        Data => {
            %Param,
            Count => $Count
        },
    );

    # open tickets
    $Count = $TicketObject->TicketSearch(
        StateType     => 'Open',
        CustomerIDRaw => $CustomerIDRaw,
        Result        => 'COUNT',
        Permission    => $Self->{Config}->{Permission},
        UserID        => $Self->{UserID},
        CacheTTL      => $Self->{Config}->{CacheTTLLocal} * 60,
    );

    $LayoutObject->Block(
        Name => 'ContentSmallCustomerIDStatusOpenTickets',
        Data => {
            %Param,
            Count => $Count
        },
    );

    # closed tickets
    $Count = $TicketObject->TicketSearch(
        StateType     => 'Closed',
        CustomerIDRaw => $CustomerIDRaw,
        Result        => 'COUNT',
        Permission    => $Self->{Config}->{Permission},
        UserID        => $Self->{UserID},
        CacheTTL      => $Self->{Config}->{CacheTTLLocal} * 60,
    );

    $LayoutObject->Block(
        Name => 'ContentSmallCustomerIDStatusClosedTickets',
        Data => {
            %Param,
            Count => $Count
        },
    );

    # all tickets
    $Count = $TicketObject->TicketSearch(
        CustomerIDRaw => $CustomerIDRaw,
        Result        => 'COUNT',
        Permission    => $Self->{Config}->{Permission},
        UserID        => $Self->{UserID},
        CacheTTL      => $Self->{Config}->{CacheTTLLocal} * 60,
    );

    $LayoutObject->Block(
        Name => 'ContentSmallCustomerIDStatusAllTickets',
        Data => {
            %Param,
            Count => $Count
        },
    );

    # archived tickets
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ArchiveSystem') ) {
        $Count = $TicketObject->TicketSearch(
            CustomerIDRaw => $CustomerIDRaw,
            ArchiveFlags  => ['y'],
            Result        => 'COUNT',
            Permission    => $Self->{Config}->{Permission},
            UserID        => $Self->{UserID},
            CacheTTL      => $Self->{Config}->{CacheTTLLocal} * 60,
        );

        $LayoutObject->Block(
            Name => 'ContentSmallCustomerIDStatusArchivedTickets',
            Data => {
                %Param,
                Count => $Count
            },
        );
    }

    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardCustomerIDStatus',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
        },
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

1;
