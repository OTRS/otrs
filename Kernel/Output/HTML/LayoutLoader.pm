# --
# Kernel/Output/HTML/LayoutLoader.pm - provides generic HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutLoader.pm,v 1.3 2010-05-27 08:21:03 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutLoader;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub CreateCSSLoaderCalls {
    my ( $Self, %Param ) = @_;

    my $ConfigTimestamp = $Self->LoaderCreateClientCacheTimestamp();

    {
        my $CommonCSSList = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS');

        for my $Key ( sort keys %{$CommonCSSList} ) {
            for my $CSSFile ( @{ $CommonCSSList->{$Key} } ) {
                $Self->Block(
                    Name => 'CommonCSS',
                    Data => {
                        Skin     => 'default',
                        Filename => $CSSFile,
                    },
                );
            }
        }
    }

    {
        my $CommonCSSIE7List = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS::IE7');

        for my $Key ( sort keys %{$CommonCSSIE7List} ) {
            for my $CSSFile ( @{ $CommonCSSIE7List->{$Key} } ) {
                $Self->Block(
                    Name => 'CommonCSS_IE7',
                    Data => {
                        Skin     => 'default',
                        Filename => $CSSFile,
                    },
                );
            }
        }
    }

    {
        my $CommonCSSIE8List = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS::IE8');

        for my $Key ( sort keys %{$CommonCSSIE8List} ) {
            for my $CSSFile ( @{ $CommonCSSIE8List->{$Key} } ) {
                $Self->Block(
                    Name => 'CommonCSS_IE8',
                    Data => {
                        Skin     => 'default',
                        Filename => $CSSFile,
                    },
                );
            }
        }
    }

}

sub LoaderCreateClientCacheTimestamp {
    my ($Self) = @_;

    my $Dir = $Self->{ConfigObject}->Get('Home');

    my @Files = glob("$Dir/Kernel/Config/Files/*.pm");

    push( @Files, "$Dir/Kernel/Config.pm" );

    my $StringFile = "";
    for my $File (@Files) {
        my $FileMTime = $Self->{MainObject}->FileGetMTime(
            Location => $File,
        );
        $File =~ s/^.*\/(.+?)/$1/g;
        $StringFile .= $File . $FileMTime;
    }

    my $MD5Sum = $Self->{MainObject}->MD5sum(
        String => \$StringFile,
    );
    return $MD5Sum;
}

1;
