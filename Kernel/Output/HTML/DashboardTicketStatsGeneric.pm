# --
# Kernel/Output/HTML/DashboardTicketStatsGeneric.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardTicketStatsGeneric.pm,v 1.11 2009-12-02 08:55:48 mn Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardTicketStatsGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

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
        die "Got no $_!" if !$Self->{$_};
    }

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    my $Key = $Self->{LayoutObject}->{UserLanguage} . '-' . $Self->{Name};
    return (
        %{ $Self->{Config} },
        CacheKey => 'TicketStats' . '-' . $Self->{UserID} . '-' . $Key,
    );

}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Axis = (
        '7Day' => {
            0 => 'Sun',
            1 => 'Mon',
            2 => 'Tue',
            3 => 'Wed',
            4 => 'Thu',
            5 => 'Fri',
            6 => 'Sat',
        },
    );

    # define standard look of line chart
    my %Data = (
        'bg_colour' => "#FFFFFF",
        'x_axis'    => {
            'stroke'      => 1,
            'tick_height' => 2,
            'colour'      => "#000000",
            'grid-colour' => "#cccccc",
            'labels'      => {
                'labels' => []
            },
        },
        'y_axis' => {
            'stroke'      => 1,
            'tick_length' => 2,
            'colour'      => "#000000",
            'grid-colour' => "#cccccc",
            'offset'      => 0,
        },
        'elements' => []
    );

    my $Max            = 1;
    my @TicketsCreated = ();
    my @TicketsClosed  = ();
    for my $Key ( 0 .. 6 ) {

        my $TimeNow = $Self->{TimeObject}->SystemTime();
        if ($Key) {
            $TimeNow = $TimeNow - ( 60 * 60 * 24 * $Key );
        }
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay )
            = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $TimeNow,
            );

        unshift(
            @{ $Data{'x_axis'}{'labels'}{'labels'} },
            $Self->{LayoutObject}->{LanguageObject}->Get( $Axis{'7Day'}->{$WeekDay} )
        );

        my $CountCreated = $Self->{TicketObject}->TicketSearch(

            # cache search result 30 min
            CacheTTL => 60 * 30,

            # tickets with create time after ... (ticket newer than this date) (optional)
            TicketCreateTimeNewerDate => "$Year-$Month-$Day 00:00:00",

            # tickets with created time before ... (ticket older than this date) (optional)
            TicketCreateTimeOlderDate => "$Year-$Month-$Day 23:59:59",

            CustomerID => $Param{Data}->{UserCustomerID},
            Result     => 'COUNT',

            # search with user permissions
            Permission => $Self->{Config}->{Permission} || 'ro',
            UserID => $Self->{UserID},
        );
        push @TicketsCreated, $CountCreated;
        if ( $CountCreated > $Max ) {
            $Max = $CountCreated;
        }

        my $CountClosed = $Self->{TicketObject}->TicketSearch(

            # cache search result 30 min
            CacheTTL => 60 * 30,

            # tickets with create time after ... (ticket newer than this date) (optional)
            TicketCloseTimeNewerDate => "$Year-$Month-$Day 00:00:00",

            # tickets with created time before ... (ticket older than this date) (optional)
            TicketCloseTimeOlderDate => "$Year-$Month-$Day 23:59:59",

            CustomerID => $Param{Data}->{UserCustomerID},
            Result     => 'COUNT',

            # search with user permissions
            Permission => $Self->{Config}->{Permission} || 'ro',
            UserID => $Self->{UserID},
        );
        push @TicketsClosed, $CountClosed;
        if ( $CountClosed > $Max ) {
            $Max = $CountClosed;
        }
    }

    # add line elements
    @TicketsClosed  = reverse @TicketsClosed;
    @TicketsCreated = reverse @TicketsCreated;
    push @{ $Data{'elements'} }, {
        'type'      => "line",
        'dot-style' => {
            'type' => "solid-dot",
            'tip'  => $Self->{LayoutObject}->{LanguageObject}->Get('Closed') . " #x_label#: #val#",
        },
        'colour'    => "#736AFF",
        'font-size' => 10,
        'width'     => 2,
        'dot-size'  => 4,
        'values'    => \@TicketsClosed
    };

    push @{ $Data{'elements'} }, {
        'type'      => "line",
        'dot-style' => {
            'type' => "solid-dot",
            'tip'  => $Self->{LayoutObject}->{LanguageObject}->Get('Created') . " #x_label#: #val#",
        },
        'colour'    => "#009F42",
        'font-size' => 10,
        'width'     => 2,
        'dot-size'  => 4,
        'values'    => \@TicketsCreated
    };

    # calculate the maximum height and the tick steps of y axis
    if ( $Max <= 10 ) {
        $Data{'y_axis'}{'max'}   = 10;
        $Data{'y_axis'}{'steps'} = 1;
    }
    elsif ( $Max <= 20 ) {
        $Data{'y_axis'}{'max'}   = 20;
        $Data{'y_axis'}{'steps'} = 5;
    }
    elsif ( $Max <= 100 ) {
        $Data{'y_axis'}{'max'} = ( ( ( $Max - $Max % 10 ) / 10 ) + 1 ) * 10;
        $Data{'y_axis'}{'steps'} = 10;
    }
    elsif ( $Max <= 1000 ) {

        # get the next full hundreds of max
        $Data{'y_axis'}{'max'} = ( ( ( $Max - $Max % 100 ) / 100 ) + 1 ) * 100;
        $Data{'y_axis'}{'steps'} = 100;
    }
    else {

        # get the next full thousands of max
        $Data{'y_axis'}{'max'} = ( ( ( $Max - $Max % 1000 ) / 1000 ) + 1 ) * 1000;
        $Data{'y_axis'}{'steps'} = 1000;
    }

    my $Source = $Self->{LayoutObject}->JSON(
        Data => \%Data,
    );

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardTicketStats',
        Data         => {
            %{ $Self->{Config} },
            Key    => int rand 99999,
            Source => $Source,
        },
    );

    return $Content;
}

1;
