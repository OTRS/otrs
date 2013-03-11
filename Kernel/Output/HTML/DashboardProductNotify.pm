# --
# Kernel/Output/HTML/DashboardProductNotify.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardProductNotify;

use strict;
use warnings;

use Kernel::System::WebUserAgent;
use Kernel::System::XML;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject CacheObject UserID)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    $Self->{WebUserAgentObject} = Kernel::System::WebUserAgent->new(%Param);

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

    # check cache
    my $CacheKey = $Self->{Config}->{URL} . '-' . $Self->{LayoutObject}->{UserLanguage};
    $CacheKey = $CacheKey . '-' . $Product . '-' . $Version;
    my $Content = $Self->{CacheObject}->Get(
        Type => 'DashboardProductNotify',
        Key  => $CacheKey,
    );
    return $Content if defined $Content;

    # get content
    my %Response = $Self->{WebUserAgentObject}->Request(
        URL => $Self->{Config}->{URL} . '?Product=' . $Product . '-' . $Version,
    );

    # set error message as content if xml file get not downloaded
    if ( $Response{Status} !~ /200/ ) {
        $Content = "Can't connect to: " . $Self->{Config}->{URL} . " ($Response{Status})";
    }
    else {

        # generate content based on xml file
        my $XMLObject = Kernel::System::XML->new( %{$Self} );
        my @Data = $XMLObject->XMLParse2XMLHash( String => ${ $Response{Content} } );

        # set error message if unable to parse xml file
        if ( !@Data ) {
            $Content = "Can't parse xml of: " . $Self->{Config}->{URL};
        }
        else {

            # remember if content got shown
            my $ContentFound = 0;

            # show messages
            for my $Item ( sort keys %{ $Data[1]->{otrs_product}->[1] } ) {
                next if $Item ne 'Message';

                # remember if content got shown
                $ContentFound = 1;
                $Self->{LayoutObject}->Block(
                    Name => 'ContentProductMessage',
                    Data => {
                        Message => $Data[1]->{otrs_product}->[1]->{$Item}->[1]->{Content},
                    },
                );
            }

            # show release updates
            for my $Item ( sort keys %{ $Data[1]->{otrs_product}->[1] } ) {
                next if $Item ne 'Release';
                for my $Record ( @{ $Data[1]->{otrs_product}->[1]->{$Item} } ) {
                    next if !$Record;

                    # check if release is newer then the installed one
                    next if !$Self->_CheckVersion(
                        Version1 => $Version,
                        Version2 => $Record->{Version}->[1]->{Content},
                    );

                    # remember if content got shown
                    $ContentFound = 1;
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

            # check if content got shown, if true, render block
            if ($ContentFound) {
                $Content = $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentDashboardProductNotify',
                    Data         => {
                        %{ $Self->{Config} },
                    },
                );
            }

            # check if we need to set CacheTTL based on xml file
            my $CacheTTL = $Data[1]->{otrs_product}->[1]->{CacheTTL};
            if ( $CacheTTL && $CacheTTL->[1]->{Content} ) {
                $Self->{Config}->{CacheTTLLocal} = $CacheTTL->[1]->{Content};
            }
        }
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
    for (qw(Version1 Version2)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "$_ not defined!" );
            return;
        }
    }
    for my $Type (qw(Version1 Version2)) {
        $Param{$Type} =~ s/\s/\./g;
        $Param{$Type} =~ s/[A-z]/0/g;
        my @Parts = split /\./, $Param{$Type};
        $Param{$Type} = 0;
        for ( 0 .. 4 ) {
            if ( defined $Parts[$_] ) {
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
