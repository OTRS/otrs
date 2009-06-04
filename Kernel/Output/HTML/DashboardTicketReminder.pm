# --
# Kernel/Output/HTML/DashboardTicketReminder.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardTicketReminder.pm,v 1.1 2009-06-04 23:28:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardTicketReminder;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(Config ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my @TicketIDs = $Self->{TicketObject}->TicketSearch(

        Result     => 'ARRAY',
        Limit      => 1000,
        StateType  => [ 'pending reminder', 'pending auto' ],
        OwnerIDs   => [ $Self->{UserID} ],
#        OrderBy    => $OrderBy,
#        SortBy     => $SortByS,
        Permission => $Self->{Config}->{Permission} || 'ro',
        UserID     => $Self->{UserID},
        Limit      => 1_000,
    );

    my @ViewableTicketsTmp;
    my %LockedData = $Self->{TicketObject}->GetLockedCount( UserID => $Self->{UserID} );

    # check what reminder tickets
    for my $TicketID (@TicketIDs) {
        next if !$LockedData{ReminderTicketIDs}->{$TicketID};
        push @ViewableTicketsTmp, $TicketID;
    }
    @TicketIDs = @ViewableTicketsTmp;

    my $Count = 0;
    for my $TicketID (@TicketIDs) {
        $Count++;
        last if $Count > $Self->{Config}->{Limit};
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $TicketID,
            UserID   => $Self->{UserID},
        );

        # create human age
        $Ticket{Age} = $Self->{LayoutObject}->CustomerAge(
            Age   => $Ticket{Age},
            Space => ' ',
        );

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketOverviewRow',
            Data => \%Ticket,
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardTicketOverview',
        Data         => {
            %{ $Self->{Config} },
        },
    );

    if (!@TicketIDs) {
        $Content = '$Text{"none"}';
    }

    $Self->{LayoutObject}->Block(
        Name => 'ContentLarge',
        Data => {
            %{ $Self->{Config} },
            Content => $Content,
        },
    );

    return 1;
}

1;
