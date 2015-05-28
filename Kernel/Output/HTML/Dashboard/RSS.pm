# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Dashboard::RSS;

use strict;
use warnings;

use XML::FeedPP;

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
        CacheKey => 'RSS'
            . $Self->{Config}->{URL} . '-'
            . $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserLanguage},
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Default URL
    my $FeedURL = $Self->{Config}->{URL};

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Language = $LayoutObject->{UserLanguage};

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
    my $Proxy = $Kernel::OM->Get('Kernel::Config')->Get('WebUserAgent::Proxy');
    if ($Proxy) {
        $ENV{CGI_HTTP_PROXY} = $Proxy;    ## no critic
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

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $Count = 0;
    ITEM:
    for my $Item ( $Feed->get_item() ) {
        $Count++;
        last ITEM if $Count > $Self->{Config}->{Limit};
        my $Time = $Item->pubDate();
        my $Ago;
        if ($Time) {
            my $SystemTime = $TimeObject->TimeStamp2SystemTime(
                String => $Time,
            );
            $Ago = $TimeObject->SystemTime() - $SystemTime;
            $Ago = $LayoutObject->CustomerAge(
                Age   => $Ago,
                Space => ' ',
            );
        }

        $LayoutObject->Block(
            Name => 'ContentSmallRSSOverviewRow',
            Data => {
                Title => $Item->title(),
                Link  => $Item->link(),
            },
        );
        if ($Ago) {
            $LayoutObject->Block(
                Name => 'ContentSmallRSSTimeStamp',
                Data => {
                    Ago   => $Ago,
                    Title => $Item->title(),
                    Link  => $Item->link(),
                },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'ContentSmallRSS',
                Data => {
                    Ago   => $Ago,
                    Title => $Item->title(),
                    Link  => $Item->link(),
                },
            );
        }
    }
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardRSSOverview',
        Data         => {
            %{ $Self->{Config} },
        },
    );

    return $Content;
}

1;
