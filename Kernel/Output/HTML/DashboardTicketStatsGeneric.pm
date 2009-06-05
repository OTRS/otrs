# --
# Kernel/Output/HTML/DashboardTicketStatsGeneric.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardTicketStatsGeneric.pm,v 1.2 2009-06-05 22:12:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardTicketStatsGeneric;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Axis = (
        '7Day' => {
            0 => { Day => 'Sun', Created => 0, Closed => 0, },
            1 => { Day => 'Mon', Created => 0, Closed => 0, },
            2 => { Day => 'Tue', Created => 0, Closed => 0, },
            3 => { Day => 'Wed', Created => 0, Closed => 0, },
            4 => { Day => 'Thu', Created => 0, Closed => 0, },
            5 => { Day => 'Fri', Created => 0, Closed => 0, },
            6 => { Day => 'Sat', Created => 0, Closed => 0, },
        },
    );

    my $TimeNow = $Self->{TimeObject}->SystemTime();
    my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $TimeNow,
    );

    my @Data;
    my $Max = 1;
    for my $Key ( 0..6 ) {

        my $TimeNow = $Self->{TimeObject}->SystemTime();
        if ($Key) {
            $TimeNow = $TimeNow - ( 60 * 60 * 24 * $Key);
        }
        my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $TimeNow,
        );

        $Data[$Key]->{Day} = $Axis{'7Day'}->{$WeekDay}->{Day};

        my $CountCreated = $Self->{TicketObject}->TicketSearch(

            # tickets with create time after ... (ticket newer than this date) (optional)
            TicketCreateTimeNewerDate => "$Year-$Month-$Day 00:00:00",

            # tickets with created time before ... (ticket older than this date) (optional)
            TicketCreateTimeOlderDate => "$Year-$Month-$Day 23:59:59",

            CustomerID => $Param{Data}->{UserCustomerID},
            Result     => 'COUNT',
            Permission => $Self->{Config}->{Permission} || 'ro',
            UserID     => $Self->{UserID},
        );
        $Data[$Key]->{Created} = $CountCreated;
        if ( $CountCreated > $Max ) {
            $Max = $CountCreated;
        }

        my $CountClosed = $Self->{TicketObject}->TicketSearch(

            # tickets with create time after ... (ticket newer than this date) (optional)
            TicketCloseTimeNewerDate => "$Year-$Month-$Day 00:00:00",

            # tickets with created time before ... (ticket older than this date) (optional)
            TicketCloseTimeOlderDate => "$Year-$Month-$Day 23:59:59",

            CustomerID => $Param{Data}->{UserCustomerID},
            Result     => 'COUNT',
            Permission => 'ro',
            UserID     => $Self->{UserID},
        );
        $Data[$Key]->{Closed} = $CountClosed;
        if ( $CountClosed > $Max ) {
            $Max = $CountClosed;
        }
}

    @Data = reverse @Data;
    my $Source = $Self->{LayoutObject}->JSON(
        Data => \@Data,
    );

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardTicketStats',
        Data         => {
            %{ $Self->{Config} },
            Key    => rand 99999,
            Max    => $Max,
            Source => $Source,
        },
    );

    $Self->{LayoutObject}->Block(
        Name => 'ContentSmall',
        Data => {
            %{ $Self->{Config} },
            Name    => $Self->{Name},
            Content => $Content,
        },
    );

    return 1;
}

1;
