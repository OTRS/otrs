# --
# Kernel/Output/HTML/LayoutLoader.pm - provides generic HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutLoader.pm,v 1.11 2010-05-31 13:47:24 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutLoader;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

use Kernel::System::Loader;

=head1 NAME

Kernel::Output::HTML::LayoutLoader - CSS/JavaScript

=head1 SYNOPSIS

All valid functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item CreateAgentCSSLoaderCalls()

Generate the minified CSS files and the tags referencing them,
taking a list from the Loader::Agent::CommonCSS config item.

    $LayoutObject->CreateAgentCSSLoaderCalls();

=cut

sub CreateAgentCSSLoaderCalls {
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

    # now handle module specific CSS
    {
        my $AppCSSList = $Self->{ConfigObject}->Get('Frontend::Module')
            ->{ $Self->{Action} }->{Loader}->{CSS} || [];

        my @FileList;

        for my $CSSFile ( @{$AppCSSList} ) {
            if ($DoMinify) {
                push(
                    @FileList,
                    $SkinHome . '/Agent/default/css/' . $CSSFile
                );
            }
            else {
                $Self->Block(
                    Name => 'ModuleCSS',
                    Data => {
                        Skin         => 'default',
                        CSSDirectory => 'css',
                        Filename     => $CSSFile,
                    },
                );
            }
        }

        if ( $DoMinify && @FileList ) {
            my $MinifiedFile = $Self->{LoaderObject}->MinifyFiles(
                List                 => \@FileList,
                Type                 => 'CSS',
                TargetDirectory      => $SkinHome . '/Agent/default/css-cache/',
                TargetFilenamePrefix => 'ModuleCSS',
            );

            $Self->Block(
                Name => 'ModuleCSS',
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

=item CreateAgentJSLoaderCalls()

Generate the minified JS files and the tags referencing them,
taking a list from the Loader::Agent::CommonJS config item.

    $LayoutObject->CreateAgentJSLoaderCalls();

=cut

sub CreateAgentJSLoaderCalls {
    my ( $Self, %Param ) = @_;

    $Self->{LoaderObject} ||= Kernel::System::Loader->new( %{$Self} );

    #use Time::HiRes;
    #my $t0 = Time::HiRes::gettimeofday();

    my $JSHome   = $Self->{ConfigObject}->Get('Home') . '/var/httpd/htdocs/js_new';
    my $DoMinify = $Self->{ConfigObject}->Get('Loader::Enabled');

    {
        my $CommonJSList = $Self->{ConfigObject}->Get('Loader::Agent::CommonJS');

        my @FileList;

        for my $Key ( sort keys %{$CommonJSList} ) {
            for my $JSFile ( @{ $CommonJSList->{$Key} } ) {
                if ($DoMinify) {
                    push(
                        @FileList,
                        $JSHome . '/' . $JSFile
                    );

                }
                else {
                    $Self->Block(
                        Name => 'CommonJS',
                        Data => {
                            JSDirectory => 'js_new',
                            Filename    => $JSFile,
                        },
                    );
                }
            }
        }

        if ( $DoMinify && @FileList ) {
            my $MinifiedFile = $Self->{LoaderObject}->MinifyFiles(
                List                 => \@FileList,
                Type                 => 'JavaScript',
                TargetDirectory      => $JSHome . '/js-cache/',
                TargetFilenamePrefix => 'CommonJS',
            );

            $Self->Block(
                Name => 'CommonJS',
                Data => {
                    JSDirectory => 'js_new/js-cache',
                    Filename    => $MinifiedFile,
                },
            );
        }

    }

    # now handle module specific JS
    {
        my $AppJSList = $Self->{ConfigObject}->Get('Frontend::Module')
            ->{ $Self->{Action} }->{Loader}->{JavaScript} || [];

        my @FileList;

        for my $JSFile ( @{$AppJSList} ) {
            if ($DoMinify) {
                push(
                    @FileList,
                    $JSHome . '/' . $JSFile
                );
            }
            else {
                $Self->Block(
                    Name => 'ModuleJS',
                    Data => {
                        JSDirectory => 'js_new',
                        Filename    => $JSFile,
                    },
                );
            }
        }

        if ( $DoMinify && @FileList ) {
            my $MinifiedFile = $Self->{LoaderObject}->MinifyFiles(
                List                 => \@FileList,
                Type                 => 'JavaScript',
                TargetDirectory      => $JSHome . '/js-cache/',
                TargetFilenamePrefix => 'ModuleJS',
            );

            $Self->Block(
                Name => 'ModuleJS',
                Data => {
                    JSDirectory => 'js_new/js-cache',
                    Filename    => $MinifiedFile,
                },
            );
        }

    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

}

=item CreateCustomerCSSLoaderCalls()

Generate the minified CSS files and the tags referencing them,
taking a list from the Loader::Customer::CommonCSS config item.

    $LayoutObject->CreateCustomerCSSLoaderCalls();

=cut

sub CreateCustomerCSSLoaderCalls {
    my ( $Self, %Param ) = @_;

    $Self->{LoaderObject} ||= Kernel::System::Loader->new( %{$Self} );

    #use Time::HiRes;
    #my $t0 = Time::HiRes::gettimeofday();

    my $SkinHome = $Self->{ConfigObject}->Get('Home') . '/var/httpd/htdocs/skins';
    my $DoMinify = $Self->{ConfigObject}->Get('Loader::Enabled');

    {
        my $CommonCSSList = $Self->{ConfigObject}->Get('Loader::Customer::CommonCSS');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSList} ) {
            for my $CSSFile ( @{ $CommonCSSList->{$Key} } ) {
                if ($DoMinify) {
                    push(
                        @FileList,
                        $SkinHome . '/Customer/default/css/' . $CSSFile
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
                TargetDirectory      => $SkinHome . '/Customer/default/css-cache/',
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
        my $CommonCSSIE7List = $Self->{ConfigObject}->Get('Loader::Customer::CommonCSS::IE7');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSIE7List} ) {
            for my $CSSFile ( @{ $CommonCSSIE7List->{$Key} } ) {

                if ($DoMinify) {
                    push(
                        @FileList,
                        $SkinHome . '/Customer/default/css/' . $CSSFile
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
                TargetDirectory      => $SkinHome . '/Customer/default/css-cache/',
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

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

}

=item CreateCustomerJSLoaderCalls()

Generate the minified JS files and the tags referencing them,
taking a list from the Loader::Customer::CommonJS config item.

    $LayoutObject->CreateCustomerJSLoaderCalls();

=cut

sub CreateCustomerJSLoaderCalls {
    my ( $Self, %Param ) = @_;

    $Self->{LoaderObject} ||= Kernel::System::Loader->new( %{$Self} );

    #use Time::HiRes;
    #my $t0 = Time::HiRes::gettimeofday();

    my $JSHome   = $Self->{ConfigObject}->Get('Home') . '/var/httpd/htdocs/js_new';
    my $DoMinify = $Self->{ConfigObject}->Get('Loader::Enabled');

    {
        my $CommonJSList = $Self->{ConfigObject}->Get('Loader::Customer::CommonJS');

        my @FileList;

        for my $Key ( sort keys %{$CommonJSList} ) {
            for my $JSFile ( @{ $CommonJSList->{$Key} } ) {
                if ($DoMinify) {
                    push(
                        @FileList,
                        $JSHome . '/' . $JSFile
                    );
                }
                else {
                    $Self->Block(
                        Name => 'CommonJS',
                        Data => {
                            Filename => $JSFile,
                        },
                    );
                }
            }
        }

        if ( $DoMinify && @FileList ) {
            my $MinifiedFile = $Self->{LoaderObject}->MinifyFiles(
                List                 => \@FileList,
                Type                 => 'JavaScript',
                TargetDirectory      => $JSHome . '/js-cache/',
                TargetFilenamePrefix => 'CommonJS',
            );

            $Self->Block(
                Name => 'CommonJS',
                Data => {
                    JSDirectory => 'js-cache',
                    Filename    => $MinifiedFile,
                },
            );
        }

    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.11 $ $Date: 2010-05-31 13:47:24 $

=cut
