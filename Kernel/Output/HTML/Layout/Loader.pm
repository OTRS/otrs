# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Layout::Loader;

use strict;
use warnings;

use File::stat;
use Digest::MD5;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::Loader - CSS/JavaScript

=head1 DESCRIPTION

All valid functions.

=head1 PUBLIC INTERFACE

=head2 LoaderCreateAgentCSSCalls()

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

    my $SkinSelected = $Self->{'UserSkin'};

    # check if the skin is valid
    my $SkinValid = 0;
    if ($SkinSelected) {
        $SkinValid = $Self->SkinValidate(
            SkinType => 'Agent',
            Skin     => $SkinSelected,
        );
    }

    if ( !$SkinValid ) {
        $SkinSelected = $SkinSelectedHostBased
            || $ConfigObject->Get('Loader::Agent::DefaultSelectedSkin')
            || 'default';
    }

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

    {
        my $Setting = $ConfigObject->Get("Loader::Module::$LoaderAction") || {};

        my @FileList;

        MODULE:
        for my $Module ( sort keys %{$Setting} ) {
            next MODULE if ref $Setting->{$Module}->{CSS} ne 'ARRAY';
            @FileList = ( @FileList, @{ $Setting->{$Module}->{CSS} || [] } );
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
            Skin      => $SkinSelected,
        );
    }

    # handle the responsive CSS
    {
        my @FileList;
        my $ResponsiveCSSList = $ConfigObject->Get('Loader::Agent::ResponsiveCSS');

        for my $Key ( sort keys %{$ResponsiveCSSList} ) {
            push @FileList, @{ $ResponsiveCSSList->{$Key} };
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ResponsiveCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Agent',
            Skin      => $SkinSelected,
        );
    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

    return 1;
}

=head2 LoaderCreateAgentJSCalls()

Generate the minified JavaScript files and the tags referencing them,
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

        KEY:
        for my $Key ( sort keys %{$CommonJSList} ) {
            next KEY if $Key eq '100-CKEditor' && !$ConfigObject->Get('Frontend::RichText');
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

    # now handle module specific JavaScript
    {
        my $LoaderAction = $Self->{Action} || 'Login';
        $LoaderAction = 'Login' if ( $LoaderAction eq 'Logout' );

        my $Setting = $ConfigObject->Get("Loader::Module::$LoaderAction") || {};

        my @FileList;

        MODULE:
        for my $Module ( sort keys %{$Setting} ) {
            next MODULE if ref $Setting->{$Module}->{JavaScript} ne 'ARRAY';
            @FileList = ( @FileList, @{ $Setting->{$Module}->{JavaScript} || [] } );
        }

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleJS',
            JSHome    => $JSHome,
        );

    }

    return 1;
}

=head2 LoaderCreateJavaScriptTemplateData()

Generate a minified file for the template data that
needs to be present on the client side for JavaScript based templates.

    $LayoutObject->LoaderCreateJavaScriptTemplateData();

=cut

sub LoaderCreateJavaScriptTemplateData {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # load theme
    my $Theme = $Self->{UserTheme} || $ConfigObject->Get('DefaultTheme') || Translatable('Standard');

    # force a theme based on host name
    my $DefaultThemeHostBased = $ConfigObject->Get('DefaultTheme::HostBased');
    if ( $DefaultThemeHostBased && $ENV{HTTP_HOST} ) {

        THEME:
        for my $RegExp ( sort keys %{$DefaultThemeHostBased} ) {

            # do not use empty regexp or theme directories
            next THEME if !$RegExp;
            next THEME if $RegExp eq '';
            next THEME if !$DefaultThemeHostBased->{$RegExp};

            # check if regexp is matching
            if ( $ENV{HTTP_HOST} =~ /$RegExp/i ) {
                $Theme = $DefaultThemeHostBased->{$RegExp};
            }
        }
    }

    # locate template files
    my $JSStandardTemplateDir = $ConfigObject->Get('TemplateDir') . '/JavaScript/Templates/' . 'Standard';
    my $JSTemplateDir         = $ConfigObject->Get('TemplateDir') . '/JavaScript/Templates/' . $Theme;

    # Check if 'Standard' fallback exists
    if ( !-e $JSStandardTemplateDir ) {
        $Self->FatalDie(
            Message =>
                "No existing template directory found ('$JSTemplateDir')! Check your Home in Kernel/Config.pm."
        );
    }

    if ( !-e $JSTemplateDir ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "No existing template directory found ('$JSTemplateDir')!.
                Default theme used instead.",
        );

        # Set TemplateDir to 'Standard' as a fallback.
        $Theme         = 'Standard';
        $JSTemplateDir = $JSStandardTemplateDir;
    }

    my $JSCustomStandardTemplateDir = $ConfigObject->Get('CustomTemplateDir') . '/JavaScript/Templates/' . 'Standard';
    my $JSCustomTemplateDir         = $ConfigObject->Get('CustomTemplateDir') . '/JavaScript/Templates/' . $Theme;

    my @TemplateFolders = (
        "$JSCustomTemplateDir",
        "$JSCustomStandardTemplateDir",
        "$JSTemplateDir",
        "$JSStandardTemplateDir",
    );

    my $JSHome               = $ConfigObject->Get('Home') . '/var/httpd/htdocs/js';
    my $TargetFilenamePrefix = "TemplateJS";

    my $TemplateChecksum;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $CacheType   = 'Loader';
    my $CacheKey    = "LoaderCreateJavaScriptTemplateData:${Theme}:" . $ConfigObject->ConfigChecksum();

    # Even getting the list of files recursively from the directories is expensive,
    #   so cache the checksum to avoid that.
    $TemplateChecksum = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    if ( !$TemplateChecksum ) {

        my %ChecksumData;

        TEMPLATEFOLDER:
        for my $TemplateFolder (@TemplateFolders) {

            next TEMPLATEFOLDER if !-e $TemplateFolder;

            # get main object
            my @Templates = $MainObject->DirectoryRead(
                Directory => $TemplateFolder,
                Filter    => '*.tmpl',
                Recursive => 1,
            );

            TEMPLATE:
            for my $Template ( sort @Templates ) {

                next TEMPLATE if !-e $Template;

                my $Key = $Template;
                $Key =~ s/^$TemplateFolder\///xmsg;
                $Key =~ s/\.(\w+)\.tmpl$//xmsg;

                # check if a template with this name does already exist
                next TEMPLATE if $ChecksumData{$Key};

                # get file metadata
                my $Stat = stat($Template);
                if ( !$Stat ) {
                    print STDERR "Error: cannot stat file '$Template': $!";
                    next TEMPLATE;
                }

                $ChecksumData{$Key} = $Template . $Stat->mtime();
            }
        }

        # generate a checksum only of the actual used files
        for my $Checksum ( sort keys %ChecksumData ) {
            $TemplateChecksum .= $ChecksumData{$Checksum};
        }
        $TemplateChecksum = Digest::MD5::md5_hex($TemplateChecksum);

        $CacheObject->Set(
            Type  => $CacheType,
            Key   => $CacheKey,
            TTL   => 60 * 60 * 24,
            Value => $TemplateChecksum,
        );
    }

    # Check if cache already exists.
    if ( -e "$JSHome/js-cache/${TargetFilenamePrefix}_$TemplateChecksum.js" ) {
        $Self->Block(
            Name => 'CommonJS',
            Data => {
                JSDirectory => 'js-cache/',
                Filename    => "${TargetFilenamePrefix}_$TemplateChecksum.js",
            },
        );

        return 1;
    }

    # if it doesnt exist, go through the folders and get the template content
    my %TemplateData;

    TEMPLATEFOLDER:
    for my $TemplateFolder (@TemplateFolders) {

        next TEMPLATEFOLDER if !-e $TemplateFolder;

        # get main object
        my @Templates = $MainObject->DirectoryRead(
            Directory => $TemplateFolder,
            Filter    => '*.tmpl',
            Recursive => 1,
        );

        TEMPLATE:
        for my $Template ( sort @Templates ) {

            next TEMPLATE if !-e $Template;

            my $Key = $Template;
            $Key =~ s/^$TemplateFolder\///xmsg;
            $Key =~ s/\.(\w+)\.tmpl$//xmsg;

            # check if a template with this name does already exist
            next TEMPLATE if $TemplateData{$Key};

            my $TemplateContent = ${
                $MainObject->FileRead(
                    Location => $Template,
                    Result   => 'SCALAR',
                )
            };

            # Remove DTL-style comments (lines starting with #)
            $TemplateContent =~ s/^#.*\n//gm;
            $TemplateData{$Key} = $TemplateContent;
        }
    }

    my $TemplateDataJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data   => \%TemplateData,
        Pretty => 0,
    );

    my $Content = <<"EOF";
// The content of this file is automatically generated, do not edit.
Core.Template.Load($TemplateDataJSON);
EOF
    my $MinifiedFile = $Kernel::OM->Get('Kernel::System::Loader')->MinifyFiles(
        Checksum             => $TemplateChecksum,
        Content              => $Content,
        Type                 => 'JavaScript',
        TargetDirectory      => "$JSHome/js-cache/",
        TargetFilenamePrefix => $TargetFilenamePrefix,
    );

    $Self->Block(
        Name => 'CommonJS',
        Data => {
            JSDirectory => 'js-cache/',
            Filename    => $MinifiedFile,
        },
    );

    return 1;
}

=head2 LoaderCreateJavaScriptTranslationData()

Generate a minified file for the translation data that
needs to be present on the client side for JavaScript based translations.

    $LayoutObject->LoaderCreateJavaScriptTranslationData();

=cut

sub LoaderCreateJavaScriptTranslationData {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $JSHome       = $ConfigObject->Get('Home') . '/var/httpd/htdocs/js';

    my $UserLanguage     = $Self->{UserLanguage};
    my $LanguageObject   = $Self->{LanguageObject};
    my $LanguageChecksum = $LanguageObject->LanguageChecksum();

    my $TargetFilenamePrefix = "TranslationJS_$UserLanguage";

    # Check if cache already exists.
    if ( -e "$JSHome/js-cache/${TargetFilenamePrefix}_$LanguageChecksum.js" ) {
        $Self->Block(
            Name => 'CommonJS',
            Data => {
                JSDirectory => 'js-cache/',
                Filename    => "${TargetFilenamePrefix}_$LanguageChecksum.js",
            },
        );
        return 1;
    }

    # Now create translation data for JavaScript.
    my %TranslationData;
    STRING:
    for my $String ( @{ $LanguageObject->{JavaScriptStrings} // [] } ) {
        next STRING if $TranslationData{$String};
        $TranslationData{$String} = $LanguageObject->{Translation}->{$String};
    }

    my %LanguageMetaData = (
        LanguageCode        => $UserLanguage,
        DateFormat          => $LanguageObject->{DateFormat},
        DateFormatLong      => $LanguageObject->{DateFormatLong},
        DateFormatShort     => $LanguageObject->{DateFormatShort},
        DateInputFormat     => $LanguageObject->{DateInputFormat},
        DateInputFormatLong => $LanguageObject->{DateInputFormatLong},
        Completeness        => $LanguageObject->{Completeness},
        Separator           => $LanguageObject->{Separator},
        DecimalSeparator    => $LanguageObject->{DecimalSeparator},
    );

    my $LanguageMetaDataJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data     => \%LanguageMetaData,
        SortKeys => 1,
        Pretty   => 0,
    );

    my $TranslationDataJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data     => \%TranslationData,
        SortKeys => 1,
        Pretty   => 0,
    );

    my $Content = <<"EOF";
// The content of this file is automatically generated, do not edit.
Core.Language.Load($LanguageMetaDataJSON, $TranslationDataJSON);
EOF
    my $MinifiedFile = $Kernel::OM->Get('Kernel::System::Loader')->MinifyFiles(
        Checksum             => $LanguageChecksum,
        Content              => $Content,
        Type                 => 'JavaScript',
        TargetDirectory      => "$JSHome/js-cache/",
        TargetFilenamePrefix => $TargetFilenamePrefix,
    );

    $Self->Block(
        Name => 'CommonJS',
        Data => {
            JSDirectory => 'js-cache/',
            Filename    => $MinifiedFile,
        },
    );

    return 1;
}

=head2 LoaderCreateCustomerCSSCalls()

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

    {
        my $Setting = $ConfigObject->Get("Loader::Module::$LoaderAction") || {};

        my @FileList;

        MODULE:
        for my $Module ( sort keys %{$Setting} ) {
            next MODULE if ref $Setting->{$Module}->{CSS} ne 'ARRAY';
            @FileList = ( @FileList, @{ $Setting->{$Module}->{CSS} || [] } );
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
            Skin      => $SkinSelected,
        );
    }

    # handle the responsive CSS
    {
        my @FileList;
        my $ResponsiveCSSList = $ConfigObject->Get('Loader::Customer::ResponsiveCSS');

        for my $Key ( sort keys %{$ResponsiveCSSList} ) {
            push @FileList, @{ $ResponsiveCSSList->{$Key} };
        }

        $Self->_HandleCSSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ResponsiveCSS',
            SkinHome  => $SkinHome,
            SkinType  => 'Customer',
            Skin      => $SkinSelected,
        );
    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);

    return 1;
}

=head2 LoaderCreateCustomerJSCalls()

Generate the minified JavaScript files and the tags referencing them,
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

        KEY:
        for my $Key ( sort keys %{$CommonJSList} ) {
            next KEY if $Key eq '100-CKEditor' && !$ConfigObject->Get('Frontend::RichText');
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

        my $Setting = $ConfigObject->Get("Loader::Module::$LoaderAction") || {};

        my @FileList;

        MODULE:
        for my $Module ( sort keys %{$Setting} ) {
            next MODULE if ref $Setting->{$Module}->{JavaScript} ne 'ARRAY';
            @FileList = ( @FileList, @{ $Setting->{$Module}->{JavaScript} || [] } );
        }

        $Self->_HandleJSList(
            List      => \@FileList,
            DoMinify  => $DoMinify,
            BlockName => 'ModuleJS',
            JSHome    => $JSHome,
        );

    }

    #print STDERR "Time: " . Time::HiRes::tv_interval([$t0]);
    return;
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

    my $Content = $Param{Content};
    return if !$Param{List} && !$Content;

    my %UsedFiles;

    my @FileList;
    JSFILE:
    for my $JSFile ( @{ $Param{List} // [] } ) {
        next JSFILE if $UsedFiles{$JSFile};

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

        # Save it for checking duplicates.
        $UsedFiles{$JSFile} = 1;
    }

    return 1 if $Param{List} && !@FileList;

    if ( $Param{DoMinify} ) {
        my $MinifiedFile;

        if (@FileList) {
            $MinifiedFile = $Kernel::OM->Get('Kernel::System::Loader')->MinifyFiles(
                List                 => \@FileList,
                Type                 => 'JavaScript',
                TargetDirectory      => "$Param{JSHome}/js-cache/",
                TargetFilenamePrefix => $Param{FilenamePrefix} // $Param{BlockName},
            );
        }
        else {
            $MinifiedFile = $Kernel::OM->Get('Kernel::System::Loader')->MinifyFiles(
                Content              => $Content,
                Type                 => 'JavaScript',
                TargetDirectory      => "$Param{JSHome}/js-cache/",
                TargetFilenamePrefix => $Param{FilenamePrefix} // $Param{BlockName},
            );
        }

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

=head2 SkinValidate()

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

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
