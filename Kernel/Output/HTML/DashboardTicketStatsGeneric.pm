# --
# Kernel/Output/HTML/DashboardTicketStatsGeneric.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardTicketStatsGeneric.pm,v 1.13 2009-12-08 17:34:45 mn Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardTicketStatsGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

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

    my @TicketsCreated = ();
    my @TicketsClosed  = ();
    my @TicketWeekdays = ();
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
            @TicketWeekdays,
            [ 6 - $Key, $Self->{LayoutObject}->{LanguageObject}->Get( $Axis{'7Day'}->{$WeekDay} ) ]
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
        push @TicketsCreated, [ 6 - $Key, $CountCreated ];

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
        push @TicketsClosed, [ 6 - $Key, $CountClosed ];
    }

    my $TicketsClosedJSON = $Self->{LayoutObject}->JSON(
        Data => \@TicketsClosed,
    );

    my $TicketsCreatedJSON = $Self->{LayoutObject}->JSON(
        Data => \@TicketsCreated,
    );

    my $TicketWeekdaysJSON = $Self->{LayoutObject}->JSON(
        Data => \@TicketWeekdays,
    );

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardTicketStats',
        Data         => {
            %{ $Self->{Config} },
            Key            => int rand 99999,
            TicketsClosed  => $TicketsClosedJSON,
            TicketsCreated => $TicketsCreatedJSON,
            TicketWeekdays => $TicketWeekdaysJSON,
        },
    );

    return $Content;
}

1;
