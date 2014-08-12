# --
# Kernel/Output/HTML/DashboardProductNotify.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardProductNotify;

use strict;
use warnings;

use Kernel::System::CloudService;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject CacheObject UserID)
        )
    {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    $Self->{CloudServiceObject} = Kernel::System::CloudService->new(%Param);

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
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get current
    my $Product = $Self->{ConfigObject}->Get('Product');
    my $Version = $Self->{ConfigObject}->Get('Version');

    my $CloudService = 'PublicFeeds';
    my $Operation    = 'ProductFeed';

    # check cache
    my $CacheKey = "CloudService::" . $CloudService . "::Operation::" . $Operation . "::Language::"
        . $Self->{LayoutObject}->{UserLanguage} . "::Product::" . $Product . "::Version::$Version";
    my $CacheContent = $Self->{CacheObject}->Get(
        Type => 'DashboardProductNotify',
        Key  => $CacheKey,
    );

    return $CacheContent if defined $CacheContent;

    # prepare cloud service request
    my %RequestParams = (
        RequestData => {
            $CloudService => [
                {
                    Operation => $Operation,
                    Data      => {
                        Product => $Product,
                        Version => $Version,
                    },
                },
            ],
        },
    );

    # dispatch the cloud service request
    my $RequestResult = $Self->{CloudServiceObject}->Request(%RequestParams);

    # as this is the only operation an unsuccessful request means that the operation was also
    # unsuccessful
    if ( !IsHashRefWithData($RequestResult) ) {
        return "Can't connect to Product News server!";
    }

    my $OperationResult = $Self->{CloudServiceObject}->OperationResultGet(
        RequestResult => $RequestResult,
        CloudService  => $CloudService,
        Operation     => $Operation,
    );

    if ( !IsHashRefWithData($OperationResult) ) {
        return "Can't get Product News from server";
    }
    elsif ( !$OperationResult->{Success} ) {
        return $OperationResult->{ErrorMessage} || "Can't get Product News from server";
    }

    my $ProductFeed = $OperationResult->{Data};

    # remember if content got shown
    my $ContentFound = 0;

    # show messages
    if ( IsArrayRefWithData( $ProductFeed->{Message} ) ) {

        MESSAGE:
        for my $Message ( @{ $ProductFeed->{Message} } ) {

            next MESSAGE if !$Message;

            # remember if content got shown
            $ContentFound = 1;
            $Self->{LayoutObject}->Block(
                Name => 'ContentProductMessage',
                Data => {
                    Message => $Message,
                },
            );
        }
    }

    # show release updates
    if ( IsArrayRefWithData( $ProductFeed->{Release} ) ) {

        RELEASE:
        for my $Release ( @{ $ProductFeed->{Release} } ) {

            next RELEASE if !$Release;

            # check if release is newer then the installed one
            next RELEASE if !$Self->_CheckVersion(
                Version1 => $Version,
                Version2 => $Release->{Version},
            );

            # remember if content got shown
            $ContentFound = 1;
            $Self->{LayoutObject}->Block(
                Name => 'ContentProductRelease',
                Data => {
                    Name     => $Release->{Name},
                    Version  => $Release->{Version},
                    Link     => $Release->{Link},
                    Severity => $Release->{Severity},
                },
            );
        }
    }

    # check if content got shown, if true, render block
    my $Content;
    if ($ContentFound) {
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentDashboardProductNotify',
            Data         => {
                %{ $Self->{Config} },
            },
        );
    }

    # check if we need to set CacheTTL based on feed
    if ( $ProductFeed->{CacheTTL} ) {
        $Self->{Config}->{CacheTTLLocal} = $ProductFeed->{CacheTTL};
    }

    # cache result
    if ( $Self->{Config}->{CacheTTLLocal} ) {
        $Self->{CacheObject}->Set(
            Type  => 'DashboardProductNotify',
            Key   => $CacheKey,
            Value => $Content || '',
            TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
        );
    }

    # return content
    return $Content;
}

sub _CheckVersion {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Version1 Version2)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Needed not defined!",
            );

            return;
        }
    }
    for my $Type (qw(Version1 Version2)) {
        $Param{$Type} =~ s/\s/\./g;
        $Param{$Type} =~ s/[A-z]/0/g;

        my @Parts = split /\./, $Param{$Type};
        $Param{$Type} = 0;
        for ( 0 .. 4 ) {
            if ( IsNumber( $Parts[$_] ) ) {
                $Param{$Type} .= sprintf( "%04d", $Parts[$_] );
            }
            else {
                $Param{$Type} .= '0000';
            }
        }
        $Param{$Type} = int( $Param{$Type} );
    }

    return 1 if ( $Param{Version2} > $Param{Version1} );

    return;
}

1;
