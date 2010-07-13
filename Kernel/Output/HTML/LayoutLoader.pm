# --
# Kernel/Output/HTML/LayoutLoader.pm - provides generic HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutLoader.pm,v 1.23 2010-07-13 09:47:15 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutLoader;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.23 $) [1];

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

    my $ToolbarModuleSettings = $Self->{ConfigObject}->Get('Frontend::ToolBarModule');

    {
        my @FileList;

        # get global css
        my $CommonCSSList = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS');
        for my $Key ( sort keys %{$CommonCSSList} ) {
            push( @FileList, @{ $CommonCSSList->{$Key} } );
        }

        # get toolbar module css
        for my $Key ( sort keys %{$ToolbarModuleSettings} ) {
            if ( $ToolbarModuleSettings->{$Key}->{CSS} ) {
                push( @FileList, $ToolbarModuleSettings->{$Key}->{CSS} );
            }
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
        my @FileList;

        # get global css for ie7
        my $CommonCSSIE7List = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS::IE7');
        for my $Key ( sort keys %{$CommonCSSIE7List} ) {
            push( @FileList, @{ $CommonCSSIE7List->{$Key} } );
        }

        # get toolbar module css for ie7
        for my $Key ( sort keys %{$ToolbarModuleSettings} ) {
            if ( $ToolbarModuleSettings->{$Key}->{CSS_IE7} ) {
                push( @FileList, $ToolbarModuleSettings->{$Key}->{CSS_IE7} );
            }
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
        my @FileList;

        # get global css for IE8
        my $CommonCSSIE8List = $Self->{ConfigObject}->Get('Loader::Agent::CommonCSS::IE8');
        for my $Key ( sort keys %{$CommonCSSIE8List} ) {
            push( @FileList, @{ $CommonCSSIE8List->{$Key} } );
        }

        # get toolbar module css for ie8
        for my $Key ( sort keys %{$ToolbarModuleSettings} ) {
            if ( $ToolbarModuleSettings->{$Key}->{CSS_IE8} ) {
                push( @FileList, $ToolbarModuleSettings->{$Key}->{CSS_IE8} );
            }
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
    my $LoaderAction = $Self->{Action} || 'Login';
    $LoaderAction = 'Login' if ( $LoaderAction eq 'Logout' );

    my $FrontendModuleRegistration = $Self->{ConfigObject}->Get('Frontend::Module')->{$LoaderAction}
        || {};

    {

        my $AppCSSList = $FrontendModuleRegistration->{Loader}->{CSS} || [];

        my @FileList = @{$AppCSSList};

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
        );
    }

    {
        my $AppCSSList = $FrontendModuleRegistration->{Loader}->{CSS_IE7} || [];

        my @FileList = @{$AppCSSList};

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS_IE7',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
        );
    }

    {
        my $AppCSSList = $FrontendModuleRegistration->{Loader}->{CSS_IE8} || [];

        my @FileList = @{$AppCSSList};

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS_IE8',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
        );
    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

    return 1;
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

    my $JSHome   = $Self->{ConfigObject}->Get('Home') . '/var/httpd/htdocs/js';
    my $DoMinify = $Self->{ConfigObject}->Get('Loader::Enabled');

    {
        my @FileList;

        # get global js
        my $CommonJSList = $Self->{ConfigObject}->Get('Loader::Agent::CommonJS');
        for my $Key ( sort keys %{$CommonJSList} ) {
            push( @FileList, @{ $CommonJSList->{$Key} } );
        }

        # get toolbar module js
        my $ToolbarModuleSettings = $Self->{ConfigObject}->Get('Frontend::ToolBarModule');
        for my $Key ( sort keys %{$ToolbarModuleSettings} ) {
            if ( $ToolbarModuleSettings->{$Key}->{JavaScript} ) {
                push( @FileList, $ToolbarModuleSettings->{$Key}->{JavaScript} );
            }
        }

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonJS',
            JSHome    => $JSHome,
        );

    }

    # now handle module specific JS
    {
        my $LoaderAction = $Self->{Action} || 'Login';
        $LoaderAction = 'Login' if ( $LoaderAction eq 'Logout' );

        my $AppJSList = $Self->{ConfigObject}->Get('Frontend::Module')
            ->{$LoaderAction}->{Loader}->{JavaScript} || [];

        my @FileList = @{$AppJSList};

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleJS',
            JSHome    => $JSHome,
        );

    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

    return 1;
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
        my $CommonCSSIE6List = $Self->{ConfigObject}->Get('Loader::Customer::CommonCSS::IE6');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSIE6List} ) {
            push( @FileList, @{ $CommonCSSIE6List->{$Key} } );
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonCSS_IE6',
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

    {
        my $CommonCSSIE7List = $Self->{ConfigObject}->Get('Loader::Customer::CommonCSS::IE8');

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

    # now handle module specific CSS
    my $LoaderAction = $Self->{Action} || 'Login';
    $LoaderAction = 'Login' if ( $LoaderAction eq 'Logout' );

    my $FrontendModuleRegistration
        = $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{$LoaderAction} || {};

    {
        my $AppCSSList = $FrontendModuleRegistration->{Loader}->{CSS} || [];

        my @FileList = @{$AppCSSList};

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
        );
    }

    {
        my $AppCSSList = $FrontendModuleRegistration->{Loader}->{CSS_IE6} || [];

        my @FileList = @{$AppCSSList};

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS_IE6',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
        );
    }

    {
        my $AppCSSList = $FrontendModuleRegistration->{Loader}->{CSS_IE7} || [];

        my @FileList = @{$AppCSSList};

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS_IE7',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
        );
    }

    {
        my $AppCSSList = $FrontendModuleRegistration->{Loader}->{CSS_IE8} || [];

        my @FileList = @{$AppCSSList};

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS_IE8',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
        );
    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

    return 1;
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

    my $JSHome   = $Self->{ConfigObject}->Get('Home') . '/var/httpd/htdocs/js';
    my $DoMinify = $Self->{ConfigObject}->Get('Loader::Enabled');

    {
        my $CommonJSList = $Self->{ConfigObject}->Get('Loader::Customer::CommonJS');

        my @FileList;

        for my $Key ( sort keys %{$CommonJSList} ) {
            push( @FileList, @{ $CommonJSList->{$Key} } );
        }

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonJS',
            JSHome    => $JSHome,
        );

    }

    # now handle module specific JS
    {
        my $LoaderAction = $Self->{Action} || 'Login';
        $LoaderAction = 'Login' if ( $LoaderAction eq 'Logout' );

        my $AppJSList = $Self->{ConfigObject}->Get('CustomerFrontend::Module')
            ->{$LoaderAction}->{Loader}->{JavaScript} || [];

        my @FileList = @{$AppJSList};

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleJS',
            JSHome    => $JSHome,
        );

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
    return 1;
}

sub _HandleJSList {
    my ( $Self, %Param ) = @_;

    my @FileList;

    for my $JSFile ( @{ $Param{List} } ) {
        if ( $Param{DoMinify} ) {
            push( @FileList, "$Param{JSHome}/$JSFile" );
        }
        else {
            $Self->Block(
                Name => $Param{BlockName},
                Data => {
                    JSDirectory => '',
                    Filename    => $JSFile,
                },
            );
        }
    }

    if ( $Param{DoMinify} && @FileList ) {
        my $MinifiedFile = $Self->{LoaderObject}->MinifyFiles(
            List                 => \@FileList,
            Type                 => 'JavaScript',
            TargetDirectory      => "$Param{JSHome}/js-cache/",
            TargetFilenamePrefix => $Param{BlockName},
        );

        $Self->Block(
            Name => $Param{BlockName},
            Data => {
                JSDirectory => 'js-cache/',
                Filename    => $MinifiedFile,
            },
        );
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.23 $ $Date: 2010-07-13 09:47:15 $

=cut
