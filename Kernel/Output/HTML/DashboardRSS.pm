# --
# Kernel/Output/HTML/DashboardRSS.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardRSS.pm,v 1.9 2009-07-11 00:08:13 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardRSS;

use strict;
use warnings;

use XML::FeedPP;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

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

sub Preferences {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} },
        CacheKey => 'RSS' . $Self->{Config}->{URL} . '-' . $Self->{LayoutObject}->{UserLanguage},
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get content
    my $Feed = eval { XML::FeedPP->new( $Self->{Config}->{URL} ) };

    if ( !$Feed ) {
        my $Content = "Can't connect to " . $Self->{Config}->{URL};
        return $Content;
    }

    my $Count = 0;
    for my $Item ( $Feed->get_item() ) {
        $Count++;
        last if $Count > $Self->{Config}->{Limit};
        my $Time = $Item->pubDate();
        my $Ago;
        if ($Time) {
            my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Time,
            );
            $Ago = $Self->{TimeObject}->SystemTime() - $SystemTime;
            $Ago = $Self->{LayoutObject}->CustomerAge(
                Age   => $Ago,
                Space => ' ',
            );
        }

        $Self->{LayoutObject}->Block(
            Name => 'ContentSmallRSSOverviewRow',
            Data => {
                Title => $Item->title(),
                Link  => $Item->link(),
                Ago   => $Ago,
            },
        );
    }
    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardRSSOverview',
        Data         => {
            %{ $Self->{Config} },
        },
    );

    return $Content;
}

1;
