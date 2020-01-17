# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::TranslationsUpdate;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

use File::Basename;
use File::Copy;
use Lingua::Translit;
use Pod::Strip;

use Kernel::Language;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::Encode',
    'Kernel::System::Main',
    'Kernel::System::Storable',
    'Kernel::System::SysConfig',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Update the OTRS translation files.');
    $Self->AddOption(
        Name        => 'language',
        Description => "Which language to use, omit to update all languages.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'module-directory',
        Description => "Translate the OTRS module in the given directory.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'generate-po',
        Description =>
            "Generate PO (translation content) files. This is only needed if a module is not yet available in Weblate to force initial creation of the gettext files.",
        Required => 0,
        HasValue => 0,
    );

    my $Name = $Self->Name();

    $Self->AdditionalHelp(<<"EOF");

<yellow>Translating OTRS</yellow>

Make sure that you have a clean system with a current configuration. No modules may be installed or linked into the system!

    <green>otrs.Console.pl $Name --language ...</green>

<yellow>Translating Extension Modules</yellow>

Make sure that you have a clean system with a current configuration. The module that needs to be translated has to be installed or linked into the system, but only this one!

    <green>otrs.Console.pl $Name --language ... --module-directory ...</green>
EOF

    return;
}

my $BreakLineAfterChars = 60;

sub Run {
    my ( $Self, %Param ) = @_;

    my @Languages;
    my $LanguageOption = $Self->GetOption('language');
    my $Home           = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # check params
    if ( !$LanguageOption ) {
        my %DefaultUsedLanguages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };
        @Languages = sort keys %DefaultUsedLanguages;
        @Languages = grep { $_ ne 'en' } @Languages;    # ignore en*.pm files
    }
    else {
        push @Languages, $LanguageOption;
        if ( !-f "$Home/Kernel/Language/$Languages[0].pm" ) {
            $Self->PrintError("No core translation file: $Languages[0]!");
            return $Self->ExitCodeError();
        }
    }

    $Self->Print("<yellow>Starting...</yellow>\n\n");

    # Gather some statistics
    my %Stats;

    for my $Language (@Languages) {
        $Self->HandleLanguage(
            Language => $Language,
            Module   => $Self->GetOption('module-directory'),
            WritePO  => $Self->GetOption('generate-po'),
            Stats    => \%Stats,
        );
    }

    $Self->Print("\n<yellow>Translation statistics:</yellow>\n");
    for my $Language (
        sort { ( $Stats{$b}->{Translated} // 0 ) <=> ( $Stats{$a}->{Translated} // 0 ) }
        keys %Stats
        )
    {
        my $Strings      = $Stats{$Language}->{Total};
        my $Translations = $Stats{$Language}->{Translated} // 0;
        $Self->Print( "\t" . sprintf( "%7s", $Language ) . ": " );
        $Self->Print( sprintf( "%02d", int( ( $Translations / $Strings ) * 100 ) ) );
        $Self->Print( sprintf( "%% (%4d/%4d)\n", $Translations, $Strings ) );

    }

    $Self->Print("\n<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

my @OriginalTranslationStrings;

# Remember which strings came from JavaScript
my %UsedInJS;

sub HandleLanguage {
    my ( $Self, %Param ) = @_;

    my $Language = $Param{Language};
    my $Module   = $Param{Module} || '';

    my $ModuleDirectory = $Module;
    my $LanguageFile;
    my $TargetFile;
    my $TargetPOTFile;
    my $TargetPOFile;
    my $IsSubTranslation;

    my $DefaultTheme = $Kernel::OM->Get('Kernel::Config')->Get('DefaultTheme');

    # We need to map internal codes to the official ones used by Weblate
    my %WeblateLanguagesMap = (
        sr_Cyrl => 'sr',
        sr_Latn => 'sr',
    );

    my $WeblateLanguage = $WeblateLanguagesMap{$Language} // $Language;
    my $Home            = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    if ( !$Module ) {
        $LanguageFile  = "$Home/Kernel/Language/$Language.pm";
        $TargetFile    = "$Home/Kernel/Language/$Language.pm";
        $TargetPOTFile = "$Home/i18n/otrs/otrs.pot";
        $TargetPOFile  = "$Home/i18n/otrs/otrs.$WeblateLanguage.po";
    }
    else {
        $IsSubTranslation = 1;

        # extract module name from module path
        $Module = basename $Module;

        # remove underscores and/or version numbers and following from module name
        # i.e. FAQ_2_0 or FAQ20
        $Module =~ s/((_|\-)?(\d+))+$//gix;

        # save module directory in target file
        $TargetFile = "$ModuleDirectory/Kernel/Language/${Language}_$Module.pm";

        $TargetPOTFile = "$ModuleDirectory/i18n/$Module/$Module.pot";
        $TargetPOFile  = "$ModuleDirectory/i18n/$Module/$Module.$WeblateLanguage.po";
    }

    my $WritePOT = $Param{WritePO} || -e $TargetPOTFile;

    if ( !-w $TargetFile ) {
        if ( -w $TargetPOFile ) {
            $Self->Print(
                "Creating missing file <yellow>$TargetFile</yellow>\n"
            );
        }
        else {
            $Self->PrintError("Ignoring missing file $TargetFile!");
            return;
        }
    }

    if ( !@OriginalTranslationStrings ) {

        $Self->Print(
            "Extracting source strings, this can take a moment...\n"
        );

        # open .tt files and write new translation file
        my %UsedWords;
        my $TemplatesDirectory = $IsSubTranslation
            ? "$ModuleDirectory/Kernel/Output/HTML/Templates/$DefaultTheme"
            : "$Home/Kernel/Output/HTML/Templates/$DefaultTheme";

        my @TemplateList;
        if ( -d $TemplatesDirectory ) {
            @TemplateList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $TemplatesDirectory,
                Filter    => '*.tt',
                Recursive => 1,
            );
        }

        my $CustomTemplatesDir = "$ModuleDirectory/Custom/Kernel/Output/HTML/Templates/$DefaultTheme";
        if ( $IsSubTranslation && -d $CustomTemplatesDir ) {
            my @CustomTemplateList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $CustomTemplatesDir,
                Filter    => '*.tt',
                Recursive => 1,
            );
            push @TemplateList, @CustomTemplateList;
        }

        for my $File (@TemplateList) {

            my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $File,
                Mode     => 'utf8',
            );

            if ( !ref $ContentRef ) {
                die "Can't open $File: $!";
            }

            my $Content = ${$ContentRef};

            $File =~ s{^.*/(.+?)\.tt}{$1}smx;

            # do translation
            $Content =~ s{
                Translate\(
                    \s*
                    (["'])(.*?)(?<!\\)\1
            }
            {
                my $Word = $2 // '';

                # unescape any \" or \' signs
                $Word =~ s{\\"}{"}smxg;
                $Word =~ s{\\'}{'}smxg;

                if ( $Word && !$UsedWords{$Word}++ ) {

                    push @OriginalTranslationStrings, {
                        Location => "Template: $File",
                        Source => $Word,
                    };

                }

                '';
            }egx;
        }

        # Add strings from .html.tmpl files (JavaScript templates).
        my $JSTemplatesDirectory = $IsSubTranslation
            ? "$ModuleDirectory/Kernel/Output/JavaScript/Templates/$DefaultTheme"
            : "$Home/Kernel/Output/JavaScript/Templates/$DefaultTheme";

        my @JSTemplateList;
        if ( -d $JSTemplatesDirectory ) {
            @JSTemplateList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $JSTemplatesDirectory,
                Filter    => '*.html.tmpl',
                Recursive => 1,
            );
        }

        my $CustomJSTemplatesDir = "$ModuleDirectory/Custom/Kernel/Output/JavaScript/Templates/$DefaultTheme";
        if ( $IsSubTranslation && -d $CustomJSTemplatesDir ) {
            my @CustomJSTemplateList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $CustomJSTemplatesDir,
                Filter    => '*.html.tmpl',
                Recursive => 1,
            );
            push @JSTemplateList, @CustomJSTemplateList;
        }

        for my $File (@JSTemplateList) {

            my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $File,
                Mode     => 'utf8',
            );

            if ( !ref $ContentRef ) {
                die "Can't open $File: $!";
            }

            my $Content = ${$ContentRef};

            $File =~ s{^.*/(.+?)\.html\.tmpl}{$1}smx;

            # Find strings marked for translation.
            $Content =~ s{
                \{\{
                \s*
                (["'])(.*?)(?<!\\)\1
                \s*
                \|
                \s*
                Translate
            }
            {
                my $Word = $2 // '';

                # Unescape any \" or \' signs.
                $Word =~ s{\\"}{"}smxg;
                $Word =~ s{\\'}{'}smxg;

                if ( $Word && !$UsedWords{$Word}++ ) {
                    push @OriginalTranslationStrings, {
                        Location => "JS Template: $File",
                        Source   => $Word,
                    };
                }

                # Also save that this string was used in JS (for later use in Loader).
                $UsedInJS{$Word} = 1;

                '';
            }egx;
        }

        # add translatable strings from Perl code
        my $PerlModuleDirectory = $IsSubTranslation
            ? "$ModuleDirectory/Kernel"
            : "$Home/Kernel";

        my @PerlModuleList;
        if ( -d $PerlModuleDirectory ) {
            @PerlModuleList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $PerlModuleDirectory,
                Filter    => '*.pm',
                Recursive => 1,
            );
        }

        # include Custom folder for modules
        my $CustomKernelDir = "$ModuleDirectory/Custom/Kernel";
        if ( $IsSubTranslation && -d $CustomKernelDir ) {
            my @CustomPerlModuleList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $CustomKernelDir,
                Filter    => '*.pm',
                Recursive => 1,
            );
            push @PerlModuleList, @CustomPerlModuleList;
        }

        # include var/packagesetup folder for modules
        my $PackageSetupDir = "$ModuleDirectory/var/packagesetup";
        if ( $IsSubTranslation && -d $PackageSetupDir ) {
            my @PackageSetupModuleList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $PackageSetupDir,
                Filter    => '*.pm',
                Recursive => 1,
            );
            push @PerlModuleList, @PackageSetupModuleList;
        }

        FILE:
        for my $File (@PerlModuleList) {

            next FILE if ( $File =~ m{cpan-lib}xms );
            next FILE if ( $File =~ m{Kernel/Config/Files}xms );

            my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $File,
                Mode     => 'utf8',
            );

            if ( !ref $ContentRef ) {
                die "Can't open $File: $!";
            }

            $File =~ s{^.*/(Kernel/)}{$1}smx;
            $File =~ s{^.*/(var/packagesetup/)}{$1}smx;

            my $Content = ${$ContentRef};

            # Remove POD
            my $PodStrip = Pod::Strip->new();
            $PodStrip->replace_with_comments(1);
            my $Code;
            $PodStrip->output_string( \$Code );
            $PodStrip->parse_string_document($Content);

            # Purge all comments
            $Code =~ s{^ \s* # .*? \n}{\n}xmsg;

            # do translation
            $Code =~ s{
                (?:
                    ->Translate | Translatable
                )
                \(
                    \s*
                    (["'])(.*?)(?<!\\)\1
            }
            {
                my $Word = $2 // '';

                # unescape any \" or \' signs
                $Word =~ s{\\"}{"}smxg;
                $Word =~ s{\\'}{'}smxg;

                # Ignore strings containing variables
                my $SkipWord;
                $SkipWord = 1 if $Word =~ m{\$}xms;

                if ( $Word && !$SkipWord && !$UsedWords{$Word}++ ) {

                    push @OriginalTranslationStrings, {
                        Location => "Perl Module: $File",
                        Source => $Word,
                    };

                }
                '';
            }egx;
        }

        # add translatable strings from DB XML
        my @DBXMLFiles = "$Home/scripts/database/otrs-initial_insert.xml";
        if ($IsSubTranslation) {
            @DBXMLFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => "$ModuleDirectory",
                Filter    => '*.sopm',
            );
        }

        FILE:
        for my $File (@DBXMLFiles) {

            my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $File,
                Mode     => 'utf8',
            );

            if ( !ref $ContentRef ) {
                die "Can't open $File: $!";
            }

            $File =~ s{^.*/(scripts/)}{$1}smx;

            my $Content = ${$ContentRef};

            # do translation
            $Content =~ s{
                <Data[^>]+Translatable="1"[^>]*>(.*?)</Data>
            }
            {
                my $Word = $1 // '';

                if ( $Word && !$UsedWords{$Word}++ ) {

                    if ($IsSubTranslation) {
                        $File =~ s{^.*/(.+\.sopm)}{$1}smx;
                    }

                    push @OriginalTranslationStrings, {
                        Location => "Database XML Definition: $File",
                        Source => $Word,
                    };

                }
                '';
            }egx;
        }

        # add translatable strings from JavaScript code
        my $JSDirectory = $IsSubTranslation
            ? "$ModuleDirectory/var/httpd/htdocs/js"
            : "$Home/var/httpd/htdocs/js";

        my @JSFileList;
        if ( -d $JSDirectory ) {
            @JSFileList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $JSDirectory,
                Filter    => '*.js',
                Recursive => 1,
            );
        }

        FILE:
        for my $File (@JSFileList) {

            my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $File,
                Mode     => 'utf8',
            );

            if ( !ref $ContentRef ) {
                die "Can't open $File: $!";
            }

            # skip js cache files
            next FILE if ( $File =~ m{\/js\/js-cache\/}xmsg );

            my $Content = ${$ContentRef};

            # skip thirdparty files without custom markers
            if ( $File =~ m{\/js\/thirdparty\/}xmsg ) {
                next FILE if ( $Content !~ m{\/\/\s*OTRS}xmsg );
            }

            $File =~ s{^.*/(.+?)\.js}{$1}smx;

            # Purge all comments
            $Content =~ s{^ \s* // .*? \n}{\n}xmsg;

            # do translation
            $Content =~ s{
                (?:
                    Core.Language.Translate
                )
                \(
                    \s*
                    (["'])(.*?)(?<!\\)\1
            }
            {
                my $Word = $2 // '';

                # unescape any \" or \' signs
                $Word =~ s{\\"}{"}smxg;
                $Word =~ s{\\'}{'}smxg;

                if ( $Word && !$UsedWords{$Word}++ ) {

                    push @OriginalTranslationStrings, {
                        Location => "JS File: $File",
                        Source => $Word,
                    };

                }

                # also save that this string was used in JS (for later use in Loader)
                $UsedInJS{$Word} = 1;

                '';
            }egx;
        }

        # add translatable strings from SysConfig
        my @Strings = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationTranslatableStrings();

        STRING:
        for my $String ( sort @Strings ) {

            next STRING if !$String || $UsedWords{$String}++;

            push @OriginalTranslationStrings, {
                Location => 'SysConfig',
                Source   => $String,
            };
        }
    }

    if ($IsSubTranslation) {
        $Self->Print(
            "Processing language <yellow>$Language</yellow> template files from <yellow>$Module</yellow>, writing output to <yellow>$TargetFile</yellow>\n"
        );
    }
    else {
        $Self->Print(
            "Processing language <yellow>$Language</yellow> template files, writing output to <yellow>$TargetFile</yellow>\n"
        );
    }

    # Language file, which only contains the OTRS core translations
    my $LanguageCoreObject = Kernel::Language->new(
        UserLanguage    => $Language,
        TranslationFile => 1,
    );

    # Language file, which contains all translations
    my $LanguageObject = Kernel::Language->new(
        UserLanguage => $Language,
    );

    # Helpers for SR Cyr2Lat Transliteration
    my $TranslitObject;
    my $TranslitLanguageCoreObject;
    my $TranslitLanguageObject;
    my %TranslitLanguagesMap = (
        sr_Latn => {
            SourceLanguage => 'sr_Cyrl',
            TranslitTable  => 'ISO/R 9',
        },
    );
    if ( $TranslitLanguagesMap{$Language} ) {
        $TranslitObject = new Lingua::Translit( $TranslitLanguagesMap{$Language}->{TranslitTable} );    ## no critic
        $TranslitLanguageCoreObject = Kernel::Language->new(
            UserLanguage    => $TranslitLanguagesMap{$Language}->{SourceLanguage},
            TranslationFile => 1,
        );
        $TranslitLanguageObject = Kernel::Language->new(
            UserLanguage => $TranslitLanguagesMap{$Language}->{SourceLanguage},
        );
    }

    my %POTranslations;

    if ( $WritePOT || $Param{WritePO} ) {
        %POTranslations = $Self->LoadPOFile(
            TargetPOFile => $TargetPOFile,
        );
    }

    my @TranslationStrings;

    STRING:
    for my $OriginalTranslationString (@OriginalTranslationStrings) {

        my $String = $OriginalTranslationString->{Source};

        # skip if we translate a module and the word already exists in the core translation
        next STRING if $IsSubTranslation && exists $LanguageCoreObject->{Translation}->{$String};

        my $Translation;

        # transliterate word from existing translation if language supports it
        if ( $TranslitLanguagesMap{$Language} ) {
            $Translation = $POTranslations{$String}
                || ( $IsSubTranslation ? $TranslitLanguageObject : $TranslitLanguageCoreObject )->{Translation}
                ->{$String};
            $Translation = $TranslitObject->translit($Translation) || '';
        }

        # lookup for existing translation
        else {
            $Translation = $POTranslations{$String}
                || ( $IsSubTranslation ? $LanguageObject : $LanguageCoreObject )->{Translation}
                ->{$String};
            $Translation ||= '';
        }

        push @TranslationStrings, {
            Location    => $OriginalTranslationString->{Location},
            Source      => $String,
            Translation => $Translation,
        };

        $Param{Stats}->{ $Param{Language} }->{Total}++;
        $Param{Stats}->{ $Param{Language} }->{Translated}++ if $Translation;
    }

    if ( $WritePOT && !$Self->{POTFileWritten}++ ) {
        $Self->WritePOTFile(
            TranslationStrings => \@TranslationStrings,
            TargetPOTFile      => $TargetPOTFile,
            Module             => $Module,
        );
    }
    if ( $Param{WritePO} && !$TranslitLanguagesMap{$Language} ) {
        $Self->WritePOFile(
            TranslationStrings => \@TranslationStrings,
            TargetPOTFile      => $TargetPOTFile,
            TargetPOFile       => $TargetPOFile,
            Module             => $Module,
        );
    }

    $Self->WritePerlLanguageFile(
        IsSubTranslation   => $IsSubTranslation,
        LanguageCoreObject => $LanguageCoreObject,
        Language           => $Language,
        Module             => $Module,
        LanguageFile       => $LanguageFile,
        TargetFile         => $TargetFile,
        TranslationStrings => \@TranslationStrings,
        UsedInJS           => \%UsedInJS,
    );

    return 1;
}

sub LoadPOFile {
    my ( $Self, %Param ) = @_;

    return if !-e $Param{TargetPOFile};

    $Kernel::OM->Get('Kernel::System::Main')->Require('Locale::PO') || die "Could not load Locale::PO";
    my $POEntries = Locale::PO->load_file_asarray( $Param{TargetPOFile} );

    my %POTranslations;

    ENTRY:
    for my $Entry ( @{$POEntries} ) {

        # Skip entries marked as "fuzzy" for now, as they may be very different than the source string.
        next ENTRY if $Entry->fuzzy();

        if ( $Entry->msgstr() ) {
            my $Source = $Entry->dequote( $Entry->msgid() );
            $Source =~ s/\\{2}/\\/g;
            $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Source );
            my $Translation = $Entry->dequote( $Entry->msgstr() );
            $Translation =~ s/\\{2}/\\/g;
            $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Translation );
            $POTranslations{$Source} = $Translation;
        }
    }

    return %POTranslations;
}

sub WritePOFile {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Main')->Require('Locale::PO') || die "Could not load Locale::PO";

    if ( !-e $Param{TargetPOFile} ) {
        File::Copy::copy( $Param{TargetPOTFile}, $Param{TargetPOFile} )
            || die "Could not copy $Param{TargetPOTFile} to $Param{TargetPOFile}: $!";
    }

    my $POEntries = Locale::PO->load_file_asarray( $Param{TargetPOFile} );
    my %POLookup;

    for my $Entry ( @{$POEntries} ) {
        my $Source = $Entry->dequote( $Entry->msgid() );
        $Source =~ s/\\{2}/\\/g;
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Source );
        $POLookup{$Source} = $Entry;
    }

    for my $String ( @{ $Param{TranslationStrings} } ) {

        my $Source = $String->{Source};
        $Source =~ s/\\/\\\\/g;
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Source );
        my $Translation = $String->{Translation};
        $Translation =~ s/\\/\\\\/g;
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Translation );

        # Is there an entry in the PO already?
        if ( exists $POLookup{ $String->{Source} } ) {

            # Yes, update it
            $POLookup{ $String->{Source} }->msgstr($Translation);
            $POLookup{ $String->{Source} }->automatic( $String->{Location} );
        }
        else {

            # No PO entry yet, create one.
            push @{$POEntries}, Locale::PO->new(
                -msgid     => $Source,
                -msgstr    => $Translation,
                -automatic => $String->{Location},
            );
        }
    }

    # Theoretically we could now also check for removed strings, but since the translations
    #   are handled by Weblate, this will not be needed as Weblate will handle that for us.

    Locale::PO->save_file_fromarray( $Param{TargetPOFile}, $POEntries )
        || die "Could not save file $Param{TargetPOFile}: $!";

    return 1;
}

sub WritePOTFile {
    my ( $Self, %Param ) = @_;

    my @POTEntries;

    $Kernel::OM->Get('Kernel::System::Main')->Require('Locale::PO') || die "Could not load Locale::PO";

    my $Package = $Param{Module} // 'OTRS';

    # build creation date, only YEAR-MO-DA HO:MI is needed without seconds
    my $CreationDate = $Kernel::OM->Create('Kernel::System::DateTime')->Format(
        Format => '%Y-%m-%d %H:%M+0000'
    );

    push @POTEntries, Locale::PO->new(
        -msgid => '',
        -msgstr =>
            "Project-Id-Version: $Package\n" .
            "POT-Creation-Date: $CreationDate\n" .
            "PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n" .
            "Last-Translator: FULL NAME <EMAIL\@ADDRESS>\n" .
            "Language-Team: LANGUAGE <LL\@li.org>\n" .
            "Language: \n" .
            "MIME-Version: 1.0\n" .
            "Content-Type: text/plain; charset=UTF-8\n" .
            "Content-Transfer-Encoding: 8bit\n",
    );

    for my $String ( @{ $Param{TranslationStrings} } ) {
        my $Source = $String->{Source};
        $Source =~ s/\\/\\\\/g;
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Source );

        push @POTEntries, Locale::PO->new(
            -msgid     => $Source,
            -msgstr    => '',
            -automatic => $String->{Location},
        );
    }

    Locale::PO->save_file_fromarray( $Param{TargetPOTFile}, \@POTEntries )
        || die "Could not save file $Param{TargetPOTFile}: $!";

    return;
}

sub WritePerlLanguageFile {
    my ( $Self, %Param ) = @_;

    my $LanguageCoreObject = $Param{LanguageCoreObject};

    my $Indent = ' ' x 8;    # 8 spaces for core files
    if ( $Param{IsSubTranslation} ) {
        $Indent = ' ' x 4;    # 4 spaces for module files
    }

    my $Data = '';

    my ( $StringsTotal, $StringsTranslated );

    my $PreviousLocation = '';
    for my $String ( @{ $Param{TranslationStrings} } ) {
        if ( $PreviousLocation ne $String->{Location} ) {
            $Data .= "\n";
            $Data .= $Indent . "# $String->{Location}\n";
            $PreviousLocation = $String->{Location};
        }

        $StringsTotal++;
        if ( $String->{Translation} ) {
            $StringsTranslated++;
        }

        # Escape ' signs in strings
        my $Key = $String->{Source};
        $Key =~ s/'/\\'/g;
        my $Translation = $String->{Translation};
        $Translation =~ s/'/\\'/g;

        if ( $Param{IsSubTranslation} ) {
            if ( index( $Key, "\n" ) > -1 || length($Key) < $BreakLineAfterChars ) {
                $Data .= $Indent . "\$Self->{Translation}->{'$Key'} = '$Translation';\n";
            }
            else {
                $Data .= $Indent . "\$Self->{Translation}->{'$Key'} =\n";
                $Data .= $Indent . '    ' . "'$Translation';\n";
            }
        }
        else {
            if ( index( $Key, "\n" ) > -1 || length($Key) < $BreakLineAfterChars ) {
                $Data .= $Indent . "'$Key' => '$Translation',\n";
            }
            else {
                $Data .= $Indent . "'$Key' =>\n";
                $Data .= $Indent . '    ' . "'$Translation',\n";
            }
        }
    }

    # add data structure for JS translations
    my $JSData = "    \$Self->{JavaScriptStrings} = [\n";

    if ( $Param{IsSubTranslation} ) {
        $JSData = '    push @{ $Self->{JavaScriptStrings} // [] }, (' . "\n";
    }

    for my $String ( sort keys %{ $Param{UsedInJS} // {} } ) {
        my $Key = $String;
        $Key =~ s/'/\\'/g;
        $JSData .= $Indent . "'" . $Key . "',\n";
    }

    if ( $Param{IsSubTranslation} ) {
        $JSData .= "    );\n";
    }
    else {
        $JSData .= "    ];\n";
    }

    my %MetaData;
    my $NewOut = '';

    # translating a module
    if ( $Param{IsSubTranslation} ) {

        # needed for cvs check-in filter
        my $Separator = "# --";

        $NewOut = <<"EOF";
$Separator
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
$Separator
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
$Separator

package Kernel::Language::$Param{Language}_$Param{Module};

use strict;
use warnings;
use utf8;

sub Data {
    my \$Self = shift;
$Data

$JSData
}

1;
EOF
    }

    # translating the core
    else {
        ## no critic
        open( my $In, '<', $Param{LanguageFile} ) || die "Can't open: $Param{LanguageFile}\n";
        ## use critic
        while (<$In>) {
            my $Line = $_;
            $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Line );
            if ( !$MetaData{DataPrinted} ) {
                $NewOut .= $Line;
            }
            if ( $_ =~ /\$\$START\$\$/ && !$MetaData{DataPrinted} ) {
                $MetaData{DataPrinted} = 1;

                $NewOut .= "    # possible charsets\n";
                $NewOut .= "    \$Self->{Charset} = [";
                for ( $LanguageCoreObject->GetPossibleCharsets() ) {
                    $NewOut .= "'$_', ";
                }
                $NewOut .= "];\n";
                my $Completeness = 0;
                if ($StringsTranslated) {
                    $Completeness = $StringsTranslated / $StringsTotal;
                }
                $NewOut .= <<"EOF";
    # date formats (\%A=WeekDay;\%B=LongMonth;\%T=Time;\%D=Day;\%M=Month;\%Y=Year;)
    \$Self->{DateFormat}          = '$LanguageCoreObject->{DateFormat}';
    \$Self->{DateFormatLong}      = '$LanguageCoreObject->{DateFormatLong}';
    \$Self->{DateFormatShort}     = '$LanguageCoreObject->{DateFormatShort}';
    \$Self->{DateInputFormat}     = '$LanguageCoreObject->{DateInputFormat}';
    \$Self->{DateInputFormatLong} = '$LanguageCoreObject->{DateInputFormatLong}';
    \$Self->{Completeness}        = $Completeness;

    # csv separator
    \$Self->{Separator}         = '$LanguageCoreObject->{Separator}';

    \$Self->{DecimalSeparator}  = '$LanguageCoreObject->{DecimalSeparator}';
    \$Self->{ThousandSeparator} = '$LanguageCoreObject->{ThousandSeparator}';
EOF

                if ( $LanguageCoreObject->{TextDirection} ) {
                    $NewOut .= <<"EOF";
    # TextDirection rtl or ltr
    \$Self->{TextDirection} = '$LanguageCoreObject->{TextDirection}';

EOF
                }
                $NewOut .= <<"EOF";
    \$Self->{Translation} = {
$Data
    };

EOF
                $NewOut .= $JSData . "\n";
            }

            if ( $_ =~ /\$\$STOP\$\$/ ) {
                $NewOut .= $Line;
                $MetaData{DataPrinted} = 0;
            }
        }
        close $In;
    }

    my $TargetFile = $Param{TargetFile};

    if ( -e $TargetFile ) {
        rename( $TargetFile, "$TargetFile.old" ) || die $!;
    }

    $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $TargetFile,
        Content  => \$NewOut,
        Mode     => 'utf8',        # binmode|utf8
    );

    return 1;
}

1;
