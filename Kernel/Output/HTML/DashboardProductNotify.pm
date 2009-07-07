# --
# Kernel/Output/HTML/DashboardProductNotify.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardProductNotify.pm,v 1.6 2009-07-07 15:45:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardProductNotify;

use strict;
use warnings;

use Kernel::System::WebUserAgent;
use Kernel::System::Cache;
use Kernel::System::XML;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

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

    $Self->{WebUserAgentObject} = Kernel::System::WebUserAgent->new(%Param);
    $Self->{CacheObject}        = Kernel::System::Cache->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check cache
    my $CacheKey = $Self->{Config}->{URL} . '-' . $Self->{LayoutObject}->{UserLanguage};
    my $Content  = $Self->{CacheObject}->Get(
        Type => 'DashboardProductNotify',
        Key  => $CacheKey,
    );

    # get content
    if ( !$Content ) {
        my $Product  = $Self->{ConfigObject}->Get('Product');
        my $Version  = $Self->{ConfigObject}->Get('Version');
        my %Response = $Self->{WebUserAgentObject}->Request(
            URL => $Self->{Config}->{URL} . '?Product=' . $Product . '-' . $Version,
        );

        if ( $Response{Status} !~ /200/ ) {
            $Content = "Can't connect to: " . $Self->{Config}->{URL} . " ($Response{Status})";
        }
        else {
            my $XMLObject = Kernel::System::XML->new( %{$Self} );
            my @Data = $XMLObject->XMLParse2XMLHash( String => ${ $Response{Content} } );

            if ( !@Data ) {
                $Content = "Can't parse xml of: " . $Self->{Config}->{URL};
            }

            for my $Item ( keys %{ $Data[1]->{otrs_product}->[1] } ) {
                next if $Item ne 'Message';
                $Self->{LayoutObject}->Block(
                    Name => 'ContentProductMessage',
                    Data => {
                        Message => $Data[1]->{otrs_product}->[1]->{$Item}->[1]->{Content},
                    },
                );
            }
            for my $Item ( keys %{ $Data[1]->{otrs_product}->[1] } ) {
                next if $Item ne 'Release';
                for my $Record ( @{ $Data[1]->{otrs_product}->[1]->{$Item} } ) {
                    next if !$Record;
                    next if !$Self->_CheckVersion(
                        Version1 => $Version,
                        Version2 => $Record->{Version}->[1]->{Content},
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'ContentProductRelease',
                        Data => {
                            Name     => $Record->{Name}->[1]->{Content},
                            Version  => $Record->{Version}->[1]->{Content},
                            Link     => $Record->{Link}->[1]->{Content},
                            Severity => $Record->{Severity}->[1]->{Content},
                        },
                    );
                }
            }
            $Content = $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentDashboardProductNotify',
                Data         => {
                    %{ $Self->{Config} },
                },
            );

            # check if we need to set CacheTTL based on product.xml
            my $CacheTTL = $Data[1]->{otrs_product}->[1]->{CacheTTL};
            if ( $CacheTTL && $CacheTTL->[1]->{Content} ) {
                $Self->{Config}->{CacheTTL} = $CacheTTL->[1]->{Content};
            }
        }

        # cache
        $Self->{CacheObject}->Set(
            Type  => 'DashboardProductNotify',
            Key   => $CacheKey,
            Value => $Content,
            TTL   => $Self->{Config}->{CacheTTL} * 60,
        );
    }

    $Self->{LayoutObject}->Block(
        Name => 'ContentLarge',
        Data => {
            %{ $Self->{Config} },
            Name    => $Self->{Name},
            Content => $Content,
        },
    );

    return 1;
}

sub _CheckVersion {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Version1 Version2)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    for my $Type (qw(Version1 Version2)) {
        $Param{$Type} =~ s/\s/\./g;
        $Param{$Type} =~ s/[A-z]//g;
        my @Parts = split /\./, $Param{$Type};
        $Param{$Type} = 0;
        for ( 0 .. 4 ) {
            $Param{$Type} .= sprintf( "%04d", $Parts[$_] || 0 );
        }
        $Param{$Type} = int( $Param{$Type} );
    }

    if ( $Param{Version2} > $Param{Version1} ) {
        return 1;
    }
    return;
}

1;
