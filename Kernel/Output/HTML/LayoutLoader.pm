# --
# Kernel/Output/HTML/LayoutLoader.pm - provides generic HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutLoader.pm,v 1.9 2010-05-27 12:51:30 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutLoader;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

use Kernel::System::Loader;

sub CreateAgentLoaderCalls {
    my ( $Self, %Param ) = @_;

    $Self->{LoaderObject} ||= Kernel::System::Loader->new( %{$Self} );

    #use Time::HiRes;
    #my $t0 = Time::HiRes::gettimeofday();

    my $SkinHome = $Self->{ConfigObject}->Get('Home') . '/var/httpd/htdocs/skins';
    my $DoMinify = $Self->{ConfigObject}->Get('Loader::Enabled');

    {
        my $CommonCSSList = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSList} ) {
            for my $CSSFile ( @{ $CommonCSSList->{$Key} } ) {
                if ($DoMinify) {
                    push(
                        @FileList,
                        $SkinHome . '/Agent/default/css/' . $CSSFile
                    );
                }
                else {
                    $Self->Block(
                        Name => 'CommonCSS',
                        Data => {
                            Skin         => 'default',
                            CSSDirectory => 'css',
                            Filename     => $CSSFile,
                        },
                    );
                }
            }
        }

        if ( $DoMinify && @FileList ) {
            my $MinifiedFile = $Self->{LoaderObject}->MinifyFiles(
                List                 => \@FileList,
                Type                 => 'CSS',
                TargetDirectory      => $SkinHome . '/Agent/default/css-cache/',
                TargetFilenamePrefix => 'CommonCSS',
            );

            $Self->Block(
                Name => 'CommonCSS',
                Data => {
                    Skin         => 'default',
                    CSSDirectory => 'css-cache',
                    Filename     => $MinifiedFile,
                },
            );
        }

    }

    {
        my $CommonCSSIE7List = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS::IE7');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSIE7List} ) {
            for my $CSSFile ( @{ $CommonCSSIE7List->{$Key} } ) {

                if ($DoMinify) {
                    push(
                        @FileList,
                        $SkinHome . '/Agent/default/css/' . $CSSFile
                    );
                }
                else {
                    $Self->Block(
                        Name => 'CommonCSS_IE7',
                        Data => {
                            Skin         => 'default',
                            CSSDirectory => 'css',
                            Filename     => $CSSFile,
                        },
                    );
                }
            }
        }

        if ( $DoMinify && @FileList ) {
            my $MinifiedFile = $Self->{LoaderObject}->MinifyFiles(
                List                 => \@FileList,
                Type                 => 'CSS',
                TargetDirectory      => $SkinHome . '/Agent/default/css-cache/',
                TargetFilenamePrefix => 'CommonCSS_IE7',
            );

            $Self->Block(
                Name => 'CommonCSS_IE7',
                Data => {
                    Skin         => 'default',
                    CSSDirectory => 'css-cache',
                    Filename     => $MinifiedFile,
                },
            );
        }
    }

    {
        my $CommonCSSIE8List = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS::IE8');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSIE8List} ) {
            for my $CSSFile ( @{ $CommonCSSIE8List->{$Key} } ) {
                if ($DoMinify) {
                    push(
                        @FileList,
                        $SkinHome . '/Agent/default/css/' . $CSSFile
                    );
                }
                else {
                    $Self->Block(
                        Name => 'CommonCSS_IE8',
                        Data => {
                            Skin         => 'default',
                            CSSDirectory => 'css',
                            Filename     => $CSSFile,
                        },
                    );
                }
            }
        }

        if ( $DoMinify && @FileList ) {
            my $MinifiedFile = $Self->{LoaderObject}->MinifyFiles(
                List                 => \@FileList,
                Type                 => 'CSS',
                TargetDirectory      => $SkinHome . '/Agent/default/css-cache/',
                TargetFilenamePrefix => 'CommonCSS_IE8',
            );

            $Self->Block(
                Name => 'CommonCSS_IE8',
                Data => {
                    Skin         => 'default',
                    CSSDirectory => 'css-cache',
                    Filename     => $MinifiedFile,
                },
            );
        }
    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

}

1;
