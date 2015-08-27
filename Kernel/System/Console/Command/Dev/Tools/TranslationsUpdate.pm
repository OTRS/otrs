# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::TranslationsUpdate;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

use File::Basename;
use Lingua::Translit;
use Pod::Strip;

use Kernel::Language;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Main',
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
        Name        => 'generate-pot',
        Description => "Generate POT (translation template) file.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'generate-po',
        Description => "Generate PO (translation content) files.",
        Required    => 0,
        HasValue    => 0,
    );

    my $Name = $Self->Name();

    $Self->AdditionalHelp(<<"EOF");

<yellow>Translating OTRS</yellow>

Make sure that you have a clean system with a current configuration. No modules may be installed or linked into the system!

    <green>otrs.Console.pl $Name --language ...</green>

Since OTRS 4 public translations are managed in transifex. Use the <yellow>--generate-pot</yellow> switch to update the .pot files and the <yellow>--generate-po</yellow> switch to update both .pot and .po files (usually not needed).

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
            WritePOT => $Self->GetOption('generate-po') || $Self->GetOption('generate-pot'),
            WritePO  => $Self->GetOption('generate-po'),
            Stats    => \%Stats,
        );
    }

    my %Summary;
    for my $Language ( sort keys %Stats ) {
        $Summary{$Language}->{Translated} = scalar grep {$_} values %{ $Stats{$Language} };
        $Summary{$Language}->{Total} = scalar values %{ $Stats{$Language} };
    }

    $Self->Print("\n<yellow>Translation statistics:</yellow>\n");
    for my $Language (
        sort { $Summary{$b}->{Translated} <=> $Summary{$a}->{Translated} }
        keys %Stats
        )
    {
        my $Strings      = $Summary{$Language}->{Total};
        my $Translations = $Summary{$Language}->{Translated};
        $Self->Print( "\t" . sprintf( "%7s", $Language ) . ": " );
        $Self->Print( sprintf( "%02d", int( ( $Translations / $Strings ) * 100 ) ) );
        $Self->Print( sprintf( "%% (%4d/%4d)\n", $Translations, $Strings ) );

    }

    $Self->Print("\n<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

sub HandleLanguage {
    my ( $Self, %Param ) = @_;

    my $Language = $Param{Language};
    my $Module   = $Param{Module};

    my $ModuleDirectory = $Module;
    my $LanguageFile;
    my $TargetFile;
    my $TargetPOTFile;
    my $TargetPOFile;
    my $IsSubTranslation;

    my $DefaultTheme = $Kernel::OM->Get('Kernel::Config')->Get('DefaultTheme');

    # We need to map internal codes to the official ones used by Transifex
    my %TransifexLanguagesMap = (
        sr_Cyrl => 'sr',
        sr_Latn => 'sr@latin',
    );

    my $TransifexLanguage = $TransifexLanguagesMap{$Language} // $Language;
    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    if ( !$Module ) {
        $LanguageFile  = "$Home/Kernel/Language/$Language.pm";
        $TargetFile    = "$Home/Kernel/Language/$Language.pm";
        $TargetPOTFile = "$Home/i18n/otrs/otrs.pot";
        $TargetPOFile  = "$Home/i18n/otrs/otrs.$TransifexLanguage.po";
    }
    else {
        $IsSubTranslation = 1;

        # extract module name from module path
        $Module = basename $Module;

        # remove underscores and/or version numbers and following from module name
        # i.e. FAQ_2_0 or FAQ20
        $Module =~ s{ [_0-9]+ .+ \z }{}xms;

        # save module directory in target file
        $TargetFile = "$ModuleDirectory/Kernel/Language/${Language}_$Module.pm";

        $TargetPOTFile = "$ModuleDirectory/i18n/$Module/$Module.pot";
        $TargetPOFile  = "$ModuleDirectory/i18n/$Module/$Module.$TransifexLanguage.po";
    }

    if ( !-w $TargetFile ) {
        $Self->PrintError("Ignoring nonexisting file $TargetFile!");
        return;
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
        $TranslitObject             = new Lingua::Translit( $TranslitLanguagesMap{$Language}->{TranslitTable} );
        $TranslitLanguageCoreObject = Kernel::Language->new(
            UserLanguage    => $TranslitLanguagesMap{$Language}->{SourceLanguage},
            TranslationFile => 1,
        );
        $TranslitLanguageObject = Kernel::Language->new(
            UserLanguage => $TranslitLanguagesMap{$Language}->{SourceLanguage},
        );
    }

    my %POTranslations;

    if ( $Param{WritePOT} || $Param{WritePO} ) {
        %POTranslations = $Self->LoadPOFile(
            TargetPOFile => $TargetPOFile,
        );
    }

    # open .tt files and write new translation file
    my %UsedWords;
    my $Directory = $IsSubTranslation
        ? "$ModuleDirectory/Kernel/Output/HTML/Templates/$DefaultTheme"
        : "$Home/Kernel/Output/HTML/Templates/$DefaultTheme";

    my @TemplateList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.tt',
    );

    my @TranslationStrings;

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

            if ($Word && !exists $UsedWords{$Word}) {

                # if we translate a module, we must handle also that possibly
                # there is already a translation in the core files
                if ($IsSubTranslation) {

                    if (!exists $LanguageCoreObject->{Translation}->{$Word} ) {
                        my $Translation;

                        # transliterate word from existing translation if language supports it
                        if ( $TranslitLanguagesMap{$Language} ) {
                            $UsedWords{$Word} = $TranslitLanguageObject->{Translation}->{$Word};
                            $Translation = $TranslitObject->translit($UsedWords{$Word}) || '';
                        }

                        # lookup for existing translation in module language object
                        else {
                            $UsedWords{$Word} = $POTranslations{$Word} || $LanguageObject->{Translation}->{$Word};
                            $Translation = $UsedWords{$Word} || '';
                        }

                        push @TranslationStrings, {
                            Location => "Template: $File",
                            Source => $Word,
                            Translation => $Translation,
                        };
                        $Param{Stats}->{$Param{Language}}->{$Word} = $Translation;
                    }
                }
                else {
                    my $Translation;

                    # transliterate word from existing translation if language supports it
                    if ( $TranslitLanguagesMap{$Language} ) {
                        $UsedWords{$Word} = $TranslitLanguageCoreObject->{Translation}->{$Word};
                        $Translation = $TranslitObject->translit($UsedWords{$Word}) || '';
                    }

                    # lookup for existing translation in core language object
                    else {
                        $UsedWords{$Word} = $POTranslations{$Word} || $LanguageCoreObject->{Translation}->{$Word};
                        $Translation = $UsedWords{$Word} || '';
                    }

                    push @TranslationStrings, {
                        Location => "Template: $File",
                        Source => $Word,
                        Translation => $Translation,
                    };
                    $Param{Stats}->{$Param{Language}}->{$Word} = $Translation;
                }
            }
            '';
        }egx;
    }

    # add translatable strings from Perl code
    my @PerlModuleList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $IsSubTranslation ? "$ModuleDirectory/Kernel" : "$Home/Kernel",
        Filter    => '*.pm',
        Recursive => 1,
    );

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

            if ($Word && !exists $UsedWords{$Word} && !$SkipWord) {

                # if we translate a module, we must handle also that possibly
                # there is already a translation in the core files
                if ($IsSubTranslation) {
                    if (!exists $LanguageCoreObject->{Translation}->{$Word} ) {
                        my $Translation;

                        # transliterate word from existing translation if language supports it
                        if ( $TranslitLanguagesMap{$Language} ) {
                            $UsedWords{$Word} = $TranslitLanguageObject->{Translation}->{$Word};
                            $Translation = $TranslitObject->translit($UsedWords{$Word}) || '';
                        }

                        # lookup for existing translation in module language object
                        else {
                            $UsedWords{$Word} = $POTranslations{$Word} || $LanguageObject->{Translation}->{$Word};
                            $Translation = $UsedWords{$Word} || '';
                        }

                        push @TranslationStrings, {
                            Location => "Perl Module: $File",
                            Source => $Word,
                            Translation => $Translation,
                        };
                        $Param{Stats}->{$Param{Language}}->{$Word} = $Translation;
                    }
                }
                else {
                    my $Translation;

                    # transliterate word from existing translation if language supports it
                    if ( $TranslitLanguagesMap{$Language} ) {
                        $UsedWords{$Word} = $TranslitLanguageCoreObject->{Translation}->{$Word};
                        $Translation = $TranslitObject->translit($UsedWords{$Word}) || '';
                    }

                    # lookup for existing translation in core language object
                    else {
                        $UsedWords{$Word} = $POTranslations{$Word} || $LanguageCoreObject->{Translation}->{$Word};
                        $Translation = $UsedWords{$Word} || '';
                    }

                    push @TranslationStrings, {
                        Location => "Perl Module: $File",
                        Source => $Word,
                        Translation => $Translation,
                    };
                    $Param{Stats}->{$Param{Language}}->{$Word} = $Translation;
                }
            }
            '';
        }egx;
    }

    # add translatable strings from XB XML
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

            if ($Word && !exists $UsedWords{$Word}) {

                # if we translate a module, we must handle also that possibly
                # there is already a translation in the core files
                if ($IsSubTranslation) {
                    if (!exists $LanguageCoreObject->{Translation}->{$Word} ) {
                        my $Translation;

                        # transliterate word from existing translation if language supports it
                        if ( $TranslitLanguagesMap{$Language} ) {
                            $UsedWords{$Word} = $TranslitLanguageObject->{Translation}->{$Word};
                            $Translation = $TranslitObject->translit($UsedWords{$Word}) || '';
                        }

                        # lookup for existing translation in module language object
                        else {
                            $UsedWords{$Word} = $POTranslations{$Word} || $LanguageObject->{Translation}->{$Word};
                            $Translation = $UsedWords{$Word} || '';
                        }

                        push @TranslationStrings, {
                            Location => "Database XML Definition: $File",
                            Source => $Word,
                            Translation => $Translation,
                        };
                        $Param{Stats}->{$Param{Language}}->{$Word} = $Translation;
                    }
                }
                else {
                    my $Translation;

                    # transliterate word from existing translation if language supports it
                    if ( $TranslitLanguagesMap{$Language} ) {
                        $UsedWords{$Word} = $TranslitLanguageCoreObject->{Translation}->{$Word};
                        $Translation = $TranslitObject->translit($UsedWords{$Word}) || '';
                    }

                    # lookup for existing translation in core language object
                    else {
                        $UsedWords{$Word} = $POTranslations{$Word} || $LanguageCoreObject->{Translation}->{$Word};
                        $Translation = $UsedWords{$Word} || '';
                    }

                    push @TranslationStrings, {
                        Location => "Database XML Definition: $File",
                        Source => $Word,
                        Translation => $Translation,
                    };
                    $Param{Stats}->{$Param{Language}}->{$Word} = $Translation;
                }
            }
            '';
        }egx;
    }

    # add translatable strings from SysConfig
    my @Strings = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemTranslatableStrings();

    STRING:
    for my $String ( sort @Strings ) {

        next STRING if !$String || exists $UsedWords{$String};

        # skip if we translate a module and the word already exists in the core translation
        next STRING if $IsSubTranslation && exists $LanguageCoreObject->{Translation}->{$String};

        my $Translation;

        # transliterate word from existing translation if language supports it
        if ( $TranslitLanguagesMap{$Language} ) {
            $UsedWords{$String}
                = ( $IsSubTranslation ? $TranslitLanguageObject : $TranslitLanguageCoreObject )->{Translation}
                ->{$String};
            $Translation = $TranslitObject->translit( $UsedWords{$String} ) || '';
        }

        # lookup for existing translation
        else {
            $UsedWords{$String} = $POTranslations{$String}
                || ( $IsSubTranslation ? $LanguageObject : $LanguageCoreObject )->{Translation}
                ->{$String};
            $Translation = $UsedWords{$String} || '';
        }

        push @TranslationStrings, {
            Location    => 'SysConfig',
            Source      => $String,
            Translation => $Translation,
        };
        $Param{Stats}->{ $Param{Language} }->{$String} = $Translation;
    }

    if ( $Param{WritePOT} && !$Self->{POTFileWritten}++ ) {
        $Self->WritePOTFile(
            TranslationStrings => \@TranslationStrings,
            TargetPOTFile      => $TargetPOTFile,
            Module             => $Module,
        );
    }
    if ( $Param{WritePO} ) {
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
    );
}

sub LoadPOFile {
    my ( $Self, %Param ) = @_;

    return if !-e $Param{TargetPOFile};

    $Kernel::OM->Get('Kernel::System::Main')->Require('Locale::PO') || die "Could not load Locale::PO";
    my $POEntries = Locale::PO->load_file_asarray( $Param{TargetPOFile} );

    my %POTranslations;

    ENTRY:
    for my $Entry ( @{$POEntries} ) {
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
    #   are handled by transifex, this will not be needed as Transifex will handle that for us.

    Locale::PO->save_file_fromarray( $Param{TargetPOFile}, $POEntries )
        || die "Could not save file $Param{TargetPOFile}: $!";
}

sub WritePOTFile {
    my ( $Self, %Param ) = @_;

    my @POTEntries;

    $Kernel::OM->Get('Kernel::System::Main')->Require('Locale::PO') || die "Could not load Locale::PO";

    my $Package = $Param{Module} // 'OTRS';

    push @POTEntries, Locale::PO->new(
        -msgid => '',
        -msgstr =>
            "Project-Id-Version: $Package\n" .
            "POT-Creation-Date: 2014-08-08 19:10+0200\n" .
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

    my $Data;

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
            if ( index( $Key, "\n" > -1 ) || length($Key) < $BreakLineAfterChars ) {
                $Data .= $Indent . "\$Self->{Translation}->{'$Key'} = '$Translation';\n";
            }
            else {
                $Data .= $Indent . "\$Self->{Translation}->{'$Key'} =\n";
                $Data .= $Indent . '    ' . "'$Translation';\n";
            }
        }
        else {
            if ( index( $Key, "\n" > -1 ) || length($Key) < $BreakLineAfterChars ) {
                $Data .= $Indent . "'$Key' => '$Translation',\n";
            }
            else {
                $Data .= $Indent . "'$Key' =>\n";
                $Data .= $Indent . '    ' . "'$Translation',\n";
            }
        }
    }

    my %MetaData;
    my $NewOut = '';

    # translating a module
    if ( $Param{IsSubTranslation} ) {

        # needed for cvs check-in filter
        my $Separator = "# --";

        $NewOut = <<"EOF";
$Separator
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
$Separator
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
$Separator

package Kernel::Language::$Param{Language}_$Param{Module};

use strict;
use warnings;
use utf8;

sub Data {
    my \$Self = shift;
$Data
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
    \$Self->{Separator} = '$LanguageCoreObject->{Separator}';

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
EOF
            }
            if ( $_ =~ /\$\$STOP\$\$/ ) {
                $NewOut .= "    };\n";
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
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
