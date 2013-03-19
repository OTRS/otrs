# --
# Kernel/Output/HTML/DashboardRSS.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardRSS;

use strict;
use warnings;

use XML::FeedPP;

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

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} },
        CacheKey => 'RSS' . $Self->{Config}->{URL} . '-' . $Self->{LayoutObject}->{UserLanguage},
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Default URL
    my $FeedURL = $Self->{Config}->{URL};

    my $Language = $Self->{LayoutObject}->{UserLanguage};

    # Check if URL for UserLanguage is available
    if ( $Self->{Config}->{"URL_$Language"} ) {
        $FeedURL = $Self->{Config}->{"URL_$Language"};
    }
    else {

        # Check for main language for languages like es_MX (es in this case)
        ($Language) = split /_/, $Language;
        if ( $Self->{Config}->{"URL_$Language"} ) {
            $FeedURL = $Self->{Config}->{"URL_$Language"};
        }
    }

    # set proxy settings can't use Kernel::System::WebAgent because of used
    # XML::FeedPP to get RSS files
    my $Proxy = $Self->{ConfigObject}->Get('WebUserAgent::Proxy');
    if ($Proxy) {
        $ENV{CGI_HTTP_PROXY} = $Proxy;
    }

    # get content
    my $Feed = eval {
        XML::FeedPP->new(
            $FeedURL,
            'xml_deref' => 1,
            'utf8_flag' => 1,
        );
    };

    if ( !$Feed ) {
        my $Content = "Can't connect to $FeedURL";
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
            },
        );
        if ($Ago) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentSmallRSSTimeStamp',
                Data => {
                    Ago   => $Ago,
                    Title => $Item->title(),
                    Link  => $Item->link(),
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ContentSmallRSS',
                Data => {
                    Ago   => $Ago,
                    Title => $Item->title(),
                    Link  => $Item->link(),
                },
            );
        }
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
