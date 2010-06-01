# --
# Kernel/Output/HTML/LayoutLoader.pm - provides generic HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutLoader.pm,v 1.13 2010-06-01 13:14:45 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutLoader;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

use Kernel::System::Loader;

=head1 NAME

Kernel::Output::HTML::LayoutLoader - CSS/JavaScript

=head1 SYNOPSIS

All valid functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item LoaderCreateAgentCSSCalls()

Generate the minified CSS files and the tags referencing them,
taking a list from the Loader::Agent::CommonCSS config item.

    $LayoutObject->LoaderCreateAgentCSSCalls();

=cut

sub LoaderCreateAgentCSSCalls {
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
            push( @FileList, @{ $CommonCSSList->{$Key} } );
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
        );
    }

    {
        my $CommonCSSIE7List = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS::IE7');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSIE7List} ) {
            push( @FileList, @{ $CommonCSSIE7List->{$Key} } );
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonCSS_IE7',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
        );
    }

    {
        my $CommonCSSIE8List = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS::IE8');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSIE8List} ) {
            push( @FileList, @{ $CommonCSSIE8List->{$Key} } );
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonCSS_IE8',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
        );
    }

    # now handle module specific CSS
    {
        my $AppCSSList = $Self->{ConfigObject}->Get('Frontend::Module')
            ->{ $Self->{Action} }->{Loader}->{CSS} || [];

        my @FileList = @{$AppCSSList};

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
        );
    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

}

=item LoaderCreateAgentJSCalls()

Generate the minified JS files and the tags referencing them,
taking a list from the Loader::Agent::CommonJS config item.

    $LayoutObject->LoaderCreateAgentJSCalls();

=cut

sub LoaderCreateAgentJSCalls {
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

=item LoaderCreateCustomerCSSCalls()

Generate the minified CSS files and the tags referencing them,
taking a list from the Loader::Customer::CommonCSS config item.

    $LayoutObject->LoaderCreateCustomerCSSCalls();

=cut

sub LoaderCreateCustomerCSSCalls {
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
            push( @FileList, @{ $CommonCSSList->{$Key} } );
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
        );
    }

    {
        my $CommonCSSIE7List = $Self->{ConfigObject}->Get('Loader::Customer::CommonCSS::IE7');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSIE7List} ) {
            push( @FileList, @{ $CommonCSSIE7List->{$Key} } );
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonCSS_IE7',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
        );
    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

}

=item LoaderCreateCustomerJSCalls()

Generate the minified JS files and the tags referencing them,
taking a list from the Loader::Customer::CommonJS config item.

    $LayoutObject->LoaderCreateCustomerJSCalls();

=cut

sub LoaderCreateCustomerJSCalls {
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

sub _HandleCSSList {
    my ( $Self, %Param ) = @_;

    my @FileList;

    for my $CSSFile ( @{ $Param{List} } ) {
        if ( $Param{DoMinify} ) {
            push(
                @FileList,
                "$Param{SkinHome}/$Param{SkinType}/default/css/$CSSFile"
            );
        }
        else {
            $Self->Block(
                Name => $Param{BlockName},
                Data => {
                    Skin         => 'default',
                    CSSDirectory => 'css',
                    Filename     => $CSSFile,
                },
            );
        }
    }

    if ( $Param{DoMinify} && @FileList ) {
        my $MinifiedFile = $Self->{LoaderObject}->MinifyFiles(
            List                 => \@FileList,
            Type                 => 'CSS',
            TargetDirectory      => "$Param{SkinHome}/$Param{SkinType}/default/css-cache/",
            TargetFilenamePrefix => $Param{BlockName},
        );

        $Self->Block(
            Name => $Param{BlockName},
            Data => {
                Skin         => 'default',
                CSSDirectory => 'css-cache',
                Filename     => $MinifiedFile,
            },
        );
    }
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

$Revision: 1.13 $ $Date: 2010-06-01 13:14:45 $

=cut
