# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Dashboard::RSS;

use strict;
use warnings;

use LWP::UserAgent;
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

    # Configure a local instance of LWP::UserAgent for passing to XML::FeedPP.
    my $UserAgent = LWP::UserAgent->new();

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # In some scenarios like transparent HTTPS proxies, it can be necessary to turn off
    #   SSL certificate validation.
    if ( $ConfigObject->Get('WebUserAgent::DisableSSLVerification') ) {
        $UserAgent->ssl_opts(
            verify_hostname => 0,
        );
    }

    # Set proxy settings if configured, and make sure to allow all supported protocols
    #   (please see bug#12512 for more information).
    my $Proxy = $ConfigObject->Get('WebUserAgent::Proxy');
    if ($Proxy) {
        $UserAgent->proxy( [ 'http', 'https', 'ftp' ], $Proxy );
    }

    # get content
    my $Feed;

    TRY:
    for ( 1 .. 3 ) {
        $Feed = eval {
            XML::FeedPP->new(
                $FeedURL,
                'xml_deref'     => 1,
                'utf8_flag'     => 1,
                'lwp_useragent' => $UserAgent,
            );
        };
        last TRY if $Feed;
    }

    if ( !$Feed ) {
        return $LayoutObject->{LanguageObject}->Translate( 'Can\'t connect to %s!', $FeedURL );
    }

    my $Count = 0;
    ITEM:
    for my $Item ( $Feed->get_item() ) {
        $Count++;
        last ITEM if $Count > $Self->{Config}->{Limit};
        my $Time = $Item->pubDate();
        my $Ago;
        if ($Time) {
            my $SystemDateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Time,
                },
            );

            my $CurSystemDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

            $Ago = $CurSystemDateTimeObject->ToEpoch() - $SystemDateTimeObject->ToEpoch();
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
