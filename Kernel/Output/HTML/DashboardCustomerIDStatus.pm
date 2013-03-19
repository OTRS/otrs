# --
# Kernel/Output/HTML/DashboardCustomerIDStatus.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardCustomerIDStatus;

use strict;
use warnings;

#use Kernel::System::CustomerCompany;
#use Kernel::System::Valid;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    #    $Self->{CustomerCompanyObject} = Kernel::System::CustomerCompany->new( %{$Self} );
    #    $Self->{ValidObject}           = Kernel::System::Valid->new( %{$Self} );

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

    my $CustomerIDSQL = $Self->{DBObject}->QueryStringEscape( QueryString => $Param{CustomerID} );

    # escalated tickets
    my $Count = $Self->{TicketObject}->TicketSearch(
        TicketEscalationTimeOlderMinutes => 1,
        CustomerID                       => $CustomerIDSQL,
        Result                           => 'COUNT',
        Permission                       => $Self->{Config}->{Permission},
        UserID                           => $Self->{UserID},
        CacheTTL                         => $Self->{Config}->{CacheTTLLocal} * 60,
    );

    $Self->{LayoutObject}->Block(
        Name => 'ContentSmallCustomerIDStatusEscalatedTickets',
        Data => {
            %Param,
            Count => $Count
        },
    );

    # open tickets
    $Count = $Self->{TicketObject}->TicketSearch(
        StateType  => 'Open',
        CustomerID => $CustomerIDSQL,
        Result     => 'COUNT',
        Permission => $Self->{Config}->{Permission},
        UserID     => $Self->{UserID},
        CacheTTL   => $Self->{Config}->{CacheTTLLocal} * 60,
    );

    $Self->{LayoutObject}->Block(
        Name => 'ContentSmallCustomerIDStatusOpenTickets',
        Data => {
            %Param,
            Count => $Count
        },
    );

    # closed tickets
    $Count = $Self->{TicketObject}->TicketSearch(
        StateType  => 'Closed',
        CustomerID => $CustomerIDSQL,
        Result     => 'COUNT',
        Permission => $Self->{Config}->{Permission},
        UserID     => $Self->{UserID},
        CacheTTL   => $Self->{Config}->{CacheTTLLocal} * 60,
    );

    $Self->{LayoutObject}->Block(
        Name => 'ContentSmallCustomerIDStatusClosedTickets',
        Data => {
            %Param,
            Count => $Count
        },
    );

    # all tickets
    $Count = $Self->{TicketObject}->TicketSearch(
        CustomerID => $CustomerIDSQL,
        Result     => 'COUNT',
        Permission => $Self->{Config}->{Permission},
        UserID     => $Self->{UserID},
        CacheTTL   => $Self->{Config}->{CacheTTLLocal} * 60,
    );

    $Self->{LayoutObject}->Block(
        Name => 'ContentSmallCustomerIDStatusAllTickets',
        Data => {
            %Param,
            Count => $Count
        },
    );

    # archived tickets
    if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {
        $Count = $Self->{TicketObject}->TicketSearch(
            CustomerID   => $CustomerIDSQL,
            ArchiveFlags => ['y'],
            Result       => 'COUNT',
            Permission   => $Self->{Config}->{Permission},
            UserID       => $Self->{UserID},
            CacheTTL     => $Self->{Config}->{CacheTTLLocal} * 60,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ContentSmallCustomerIDStatusArchivedTickets',
            Data => {
                %Param,
                Count => $Count
            },
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
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
