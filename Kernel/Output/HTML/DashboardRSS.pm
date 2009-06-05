# --
# Kernel/Output/HTML/DashboardRSS.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardRSS.pm,v 1.3 2009-06-05 22:12:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardRSS;

use strict;
use warnings;

use XML::FeedPP;
use Kernel::System::Cache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    $Self->{CacheObject} = Kernel::System::Cache->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check cache
    my $Content = $Self->{CacheObject}->Get(
        Type => 'DashboardRSS',
        Key  => $Self->{Config}->{URL} . '::' . $Self->{UserID},
    );

    # get content
    if ( !$Content ) {
        my $Feed = XML::FeedPP->new( $Self->{Config}->{URL} );

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

        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentDashboardRSSOverview',
            Data         => {
                %{ $Self->{Config} },
            },
        );

        # cache
        $Self->{CacheObject}->Set(
            Type  => 'DashboardRSS',
            Key   => $Self->{Config}->{URL} . '::' . $Self->{UserID},
            Value => $Content,
            TTL   => $Self->{Config}->{CacheTTL} * 60,
        );

    }

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
