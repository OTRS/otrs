# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Layout::Loader;

use strict;
use warnings;

use Kernel::System::Loader;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::Loader - CSS/JavaScript

=head1 SYNOPSIS

All valid functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item LoaderCreateAgentCSSCalls()

Generate the minified CSS files and the tags referencing them,
taking a list from the Loader::Agent::CommonCSS config item.

    $LayoutObject->LoaderCreateAgentCSSCalls(
        Skin => 'MySkin', # optional, if not provided skin is the configured by default
    );

=cut

sub LoaderCreateAgentCSSCalls {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get host based default skin configuration
    my $SkinSelectedHostBased;
    my $DefaultSkinHostBased = $ConfigObject->Get('Loader::Agent::DefaultSelectedSkin::HostBased');
    if ( $DefaultSkinHostBased && $ENV{HTTP_HOST} ) {
        REGEXP:
        for my $RegExp ( sort keys %{$DefaultSkinHostBased} ) {

            # do not use empty regexp or skin directories
            next REGEXP if !$RegExp;
            next REGEXP if !$DefaultSkinHostBased->{$RegExp};

            # check if regexp is matching
            if ( $ENV{HTTP_HOST} =~ /$RegExp/i ) {
                $SkinSelectedHostBased = $DefaultSkinHostBased->{$RegExp};
            }
        }
    }

    # determine skin
    # 1. use UserSkin setting from Agent preferences, if available
    # 2. use HostBased skin setting, if available
    # 3. use default skin from configuration

    my $SkinSelected = $Self->{'UserSkin'}
        || $SkinSelectedHostBased
        || $ConfigObject->Get('Loader::Agent::DefaultSelectedSkin')
        || 'default';

    # save selected skin
    $Self->{SkinSelected} = $SkinSelected;

    my $SkinHome = $ConfigObject->Get('Home') . '/var/httpd/htdocs/skins';
    my $DoMinify = $ConfigObject->Get('Loader::Enabled::CSS');

    my $ToolbarModuleSettings    = $ConfigObject->Get('Frontend::ToolBarModule');
    my $CustomerUserItemSettings = $ConfigObject->Get('Frontend::CustomerUser::Item');

    {
        my @FileList;

        # get global css
        my $CommonCSSList = $ConfigObject->Get('Loader::Agent::CommonCSS');
        for my $Key ( sort keys %{$CommonCSSList} ) {
            push @FileList, @{ $CommonCSSList->{$Key} };
        }

        # get toolbar module css
        for my $Key ( sort keys %{$ToolbarModuleSettings} ) {
            if ( $ToolbarModuleSettings->{$Key}->{CSS} ) {
                push @FileList, $ToolbarModuleSettings->{$Key}->{CSS};
            }
        }

        # get customer user item css
        for my $Key ( sort keys %{$CustomerUserItemSettings} ) {
            if ( $CustomerUserItemSettings->{$Key}->{CSS} ) {
                push @FileList, $CustomerUserItemSettings->{$Key}->{CSS};
            }
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
            Skin      => $SkinSelected,
        );
    }

    # now handle module specific CSS
    my $LoaderAction = $Self->{Action} || 'Login';
    $LoaderAction = 'Login' if ( $LoaderAction eq 'Logout' );

    my $FrontendModuleRegistration = $ConfigObject->Get('Frontend::Module')->{$LoaderAction}
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
            Skin      => $SkinSelected,
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

    #use Time::HiRes;
    #my $t0 = Time::HiRes::gettimeofday();

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $JSHome   = $ConfigObject->Get('Home') . '/var/httpd/htdocs/js';
    my $DoMinify = $ConfigObject->Get('Loader::Enabled::JS');

    {
        my @FileList;

        # get global js
        my $CommonJSList = $ConfigObject->Get('Loader::Agent::CommonJS');
        for my $Key ( sort keys %{$CommonJSList} ) {
            push @FileList, @{ $CommonJSList->{$Key} };
        }

        # get toolbar module js
        my $ToolbarModuleSettings = $ConfigObject->Get('Frontend::ToolBarModule');
        for my $Key ( sort keys %{$ToolbarModuleSettings} ) {
            if ( $ToolbarModuleSettings->{$Key}->{JavaScript} ) {
                push @FileList, $ToolbarModuleSettings->{$Key}->{JavaScript};
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

        my $AppJSList = $ConfigObject->Get('Frontend::Module')->{$LoaderAction}->{Loader}
            ->{JavaScript} || [];

        my @FileList = @{$AppJSList};

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleJS',
            JSHome    => $JSHome,
        );

    }

    return 1;
}

=item LoaderCreateCustomerCSSCalls()

Generate the minified CSS files and the tags referencing them,
taking a list from the Loader::Customer::CommonCSS config item.

    $LayoutObject->LoaderCreateCustomerCSSCalls();

=cut

sub LoaderCreateCustomerCSSCalls {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SkinSelected = $ConfigObject->Get('Loader::Customer::SelectedSkin')
        || 'default';

    # force a skin based on host name
    my $DefaultSkinHostBased = $ConfigObject->Get('Loader::Customer::SelectedSkin::HostBased');
    if ( $DefaultSkinHostBased && $ENV{HTTP_HOST} ) {
        REGEXP:
        for my $RegExp ( sort keys %{$DefaultSkinHostBased} ) {

            # do not use empty regexp or skin directories
            next REGEXP if !$RegExp;
            next REGEXP if !$DefaultSkinHostBased->{$RegExp};

            # check if regexp is matching
            if ( $ENV{HTTP_HOST} =~ /$RegExp/i ) {
                $SkinSelected = $DefaultSkinHostBased->{$RegExp};
            }
        }
    }

    my $SkinHome = $ConfigObject->Get('Home') . '/var/httpd/htdocs/skins';
    my $DoMinify = $ConfigObject->Get('Loader::Enabled::CSS');

    {
        my $CommonCSSList = $ConfigObject->Get('Loader::Customer::CommonCSS');

        my @FileList;

        for my $Key ( sort keys %{$CommonCSSList} ) {
            push @FileList, @{ $CommonCSSList->{$Key} };
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'CommonCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
            Skin      => $SkinSelected,
        );
    }

    # now handle module specific CSS
    my $LoaderAction = $Self->{Action} || 'Login';
    $LoaderAction = 'Login' if ( $LoaderAction eq 'Logout' );

    my $FrontendModuleRegistration = $ConfigObject->Get('CustomerFrontend::Module')->{$LoaderAction}
        || $ConfigObject->Get('PublicFrontend::Module')->{$LoaderAction}
        || {};

    {
        my $AppCSSList = $FrontendModuleRegistration->{Loader}->{CSS} || [];

        my @FileList = @{$AppCSSList};

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
            Skin      => $SkinSelected,
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

    #use Time::HiRes;
    #my $t0 = Time::HiRes::gettimeofday();

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $JSHome   = $ConfigObject->Get('Home') . '/var/httpd/htdocs/js';
    my $DoMinify = $ConfigObject->Get('Loader::Enabled::JS');

    {
        my $CommonJSList = $ConfigObject->Get('Loader::Customer::CommonJS');

        my @FileList;

        for my $Key ( sort keys %{$CommonJSList} ) {
            push @FileList, @{ $CommonJSList->{$Key} };
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
        my $LoaderAction = $Self->{Action} || 'CustomerLogin';
        $LoaderAction = 'CustomerLogin' if ( $LoaderAction eq 'Logout' );

        my $AppJSList = $ConfigObject->Get('CustomerFrontend::Module')->{$LoaderAction}->{Loader}
            ->{JavaScript}
            || $ConfigObject->Get('PublicFrontend::Module')->{$LoaderAction}->{Loader}
            ->{JavaScript}
            || [];

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

    my @Skins = ('default');

    # validating selected custom skin, if any
    if ( $Param{Skin} && $Param{Skin} ne 'default' && $Self->SkinValidate(%Param) ) {
        push @Skins, $Param{Skin};
    }

    #load default css files
    for my $Skin (@Skins) {
        my @FileList;

        CSSFILE:
        for my $CSSFile ( @{ $Param{List} } ) {
            my $SkinFile = "$Param{SkinHome}/$Param{SkinType}/$Skin/css/$CSSFile";

            next CSSFILE if ( !-e $SkinFile );

            if ( $Param{DoMinify} ) {
                push @FileList, $SkinFile;
            }
            else {
                $Self->Block(
                    Name => $Param{BlockName},
                    Data => {
                        Skin         => $Skin,
                        CSSDirectory => 'css',
                        Filename     => $CSSFile,
                    },
                );
            }
        }

        if ( $Param{DoMinify} && @FileList ) {
            my $MinifiedFile = $Kernel::OM->Get('Kernel::System::Loader')->MinifyFiles(
                List                 => \@FileList,
                Type                 => 'CSS',
                TargetDirectory      => "$Param{SkinHome}/$Param{SkinType}/$Skin/css-cache/",
                TargetFilenamePrefix => $Param{BlockName},
            );

            $Self->Block(
                Name => $Param{BlockName},
                Data => {
                    Skin         => $Skin,
                    CSSDirectory => 'css-cache',
                    Filename     => $MinifiedFile,
                },
            );
        }
    }

    return 1;
}

sub _HandleJSList {
    my ( $Self, %Param ) = @_;

    my @FileList;

    for my $JSFile ( @{ $Param{List} } ) {
        if ( $Param{DoMinify} ) {
            push @FileList, "$Param{JSHome}/$JSFile";
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

=item SkinValidate()

Returns 1 if skin is available for Agent or Customer frontends and 0 if not.

    my $SkinIsValid = $LayoutObject->SkinValidate(
        UserType => 'Agent'     #  Agent or Customer,
        Skin => 'ExampleSkin',
    );

=cut

sub SkinValidate {
    my ( $Self, %Param ) = @_;

    for my $Needed ( 'SkinType', 'Skin' ) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "Needed param: $Needed!",
                Priority => 'error',
            );
            return;
        }
    }

    if ( exists $Self->{SkinValidateCache}->{ $Param{SkinType} . '::' . $Param{Skin} } ) {
        return $Self->{SkinValidateCache}->{ $Param{SkinType} . '::' . $Param{Skin} };
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SkinType      = $Param{SkinType};
    my $PossibleSkins = $ConfigObject->Get("Loader::${SkinType}::Skin") || {};
    my $Home          = $ConfigObject->Get('Home');
    my %ActiveSkins;

    # prepare the list of active skins
    for my $PossibleSkin ( values %{$PossibleSkins} ) {
        if ( $PossibleSkin->{InternalName} eq $Param{Skin} ) {
            my $SkinDir = $Home . "/var/httpd/htdocs/skins/$SkinType/" . $PossibleSkin->{InternalName};
            if ( -d $SkinDir ) {
                $Self->{SkinValidateCache}->{ $Param{SkinType} . '::' . $Param{Skin} } = 1;
                return 1;
            }
        }
    }

    $Self->{SkinValidateCache}->{ $Param{SkinType} . '::' . $Param{Skin} } = undef;
    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
