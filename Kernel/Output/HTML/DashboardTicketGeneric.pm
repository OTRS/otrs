# --
# Kernel/Output/HTML/DashboardTicketGeneric.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardTicketGeneric.pm,v 1.5 2009-07-07 15:45:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardTicketGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

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

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get all attributes
    my %TicketSearch = ();
    my @Params = split /;/, $Self->{Config}->{Attributes};
    for my $String (@Params) {
        next if !$String;
        my ( $Key, $Value ) = split /=/, $String;

        if ( $Key eq 'StateType' ) {
            push @{ $TicketSearch{$Key} }, $Value;
        }
        elsif ( !defined $TicketSearch{$Key} ) {
            $TicketSearch{$Key} = $Value;
        }
        elsif ( !ref $TicketSearch{$Key} ) {
            my $ValueTmp = $TicketSearch{$Key};
            $TicketSearch{$Key} = [$ValueTmp];
        }
        else {
            push @{ $TicketSearch{$Key} }, $Value;
        }
    }

    my @TicketIDs = $Self->{TicketObject}->TicketSearch(

        # result (required)
        %TicketSearch,
        Result     => 'ARRAY',
        Permission => $Self->{Config}->{Permission} || 'ro',
        UserID     => $Self->{UserID},
        Limit      => 1_000,
    );

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

    if ( !@TicketIDs ) {
        $Content = '$Text{"none"}';
    }

    $Self->{LayoutObject}->Block(
        Name => 'ContentLarge',
        Data => {
            %{ $Self->{Config} },
            Name    => $Self->{Name},
            Content => $Content,
        },
    );

    if ( $Self->{Config}->{Link} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeMore',
            Data => {
                %{ $Self->{Config} },
                Name => $Self->{Name},
            },
        );
    }

    return 1;
}

1;
