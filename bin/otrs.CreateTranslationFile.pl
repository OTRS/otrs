#!/usr/bin/perl
# --
# bin/otrs.CreateTranslationFile.pl - create new translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std ();
use Locale::PO  ();
use File::Copy  ();

use Kernel::System::ObjectManager;

sub PrintUsage {
    print <<"EOF";

otrs.CreateTranslationFile.pl - update translation files
Copyright (C) 2001-2010 OTRS AG, http://otrs.org/

Translating OTRS
================

Make sure that you have a clean system with a current configuration. No modules
may be installed or linked into the system!

    otrs.CreateTranslationFile.pl -l <Language>
    otrs.CreateTranslationFile.pl -l all

Since OTRS 4 public translations are managed in transifex. Use the -p switch to
update the .pot files and the -P switch to update both .pot and .po files (usually not needed).

    otrs.CreateTranslationFile.pl -l <Language> -p
    otrs.CreateTranslationFile.pl -l <Language> -P

Translating Extension Modules
=============================

  Make sure that you have a clean system with a current configuration. The module
  that needs to be translated has to be installed or linked into the system, but
  only this one!

    otrs.CreateTranslationFile.pl -l <Language> -m <module_directory>
    otrs.CreateTranslationFile.pl -l all -m <module_directory>

Optional Parameters
=============================

  To output debug information, use -v.

EOF
}

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.CreateTranslationFile.pl',
    },
);

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $BreakLineAfterChars = 60;

{
    my @Languages;
    my %Opts;

    # get opts
    Getopt::Std::getopt( 'lmpv', \%Opts );

    # check params
    if ( $Opts{l} && $Opts{l} eq 'all' ) {
        my %DefaultUsedLanguages = %{ $Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages') };
        @Languages = sort keys %DefaultUsedLanguages;

        # ignore en*.pm files
        @Languages = grep { $_ ne 'en' } @Languages;
    }
    elsif ( $Opts{l} ) {
        push @Languages, $Opts{l};
        if ( !-f "$Home/Kernel/Language/$Languages[0].pm" ) {
            print "ERROR: No core translation file: $Languages[0]!\n";
            exit 1;
        }
    }
    else {
        PrintUsage();
        exit 0;
    }

    print "Starting...\n\n";

    # Gather some statistics
    my %Stats;

    for my $Language (@Languages) {
        HandleLanguage(
            Language => $Language,
            Module   => $Opts{m},
            WritePOT => ( exists $Opts{p} || exists $Opts{P} ) ? 1 : 0,
            WritePO => exists $Opts{P} ? 1 : 0,
            Stats   => \%Stats,
            Verbose => exists $Opts{v} ? 1 : 0,
        );
    }

    my %Summary;
    for my $Language ( sort keys %Stats ) {
        $Summary{$Language}->{Translated} = scalar grep {$_} values %{ $Stats{$Language} };
        $Summary{$Language}->{Total} = scalar values %{ $Stats{$Language} };
    }

    print "\n\nTranslation statistics:\n";
    for my $Language (
        sort { $Summary{$b}->{Translated} <=> $Summary{$a}->{Translated} }
        keys %Stats
        )
    {
        my $Strings      = $Summary{$Language}->{Total};
        my $Translations = $Summary{$Language}->{Translated};
        print "\t" . sprintf( "%7s", $Language ) . ": ";
        print sprintf( "%02d", int( ( $Translations / $Strings ) * 100 ) );
        print sprintf( "%% (%4d/%4d)\n", $Translations, $Strings );

    }

    print "\n\nFinished.\n";
}

# Only write POT file once
my $POTFileWritten;

sub HandleLanguage {
    my (%Param) = @_;

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
        print STDERR "Ignoring nonexisting file $TargetFile!\n";
        return;
    }

    if ($IsSubTranslation) {
        print
            "Processing language $Language template files from $Module, writing output to $TargetFile\n";
    }
    else {
        print "Processing language $Language template files, writing output to $TargetFile\n";
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

    my %POTranslations;

    if ( $Param{WritePOT} || $Param{WritePO} ) {
        %POTranslations = LoadPOFile(
            TargetPOFile => $TargetPOFile,
        );
    }

    # open .tt files and write new translation file
    my %UsedWords;
    my $Directory = $IsSubTranslation
        ? "$ModuleDirectory/Kernel/Output/HTML/$DefaultTheme"
        : "$Home/Kernel/Output/HTML/$DefaultTheme";

    my @List = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.tt',
    );

    if ( $Param{Verbose} ) {
        print "\nReading template files:\n";
    }

    my @TranslationStrings;

    for my $File (@List) {

        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $File,
            Mode     => 'utf8',
        );

        if ( !ref $ContentRef ) {
            die "Can't open $File: $!";
        }

        my $Content = ${$ContentRef};

        $File =~ s!^.*/(.+?)\.tt!$1!;
        if ( $Param{Verbose} ) {
            print "$File ";
        }

        # do translation
        $Content =~ s{
            Translate\(
                \s*
                (["'])(.*?)(?<!\\)\1
                \s*
                (?:,[^\)]+)?
            \)
            (?:\s|[|])
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

                        # lookup for existing translation in module language object
                        $UsedWords{$Word} = $POTranslations{$Word} || $LanguageObject->{Translation}->{$Word};
                        my $Translation = $UsedWords{$Word} || '';
                        push @TranslationStrings, {
                            Location => "Template: $File",
                            Source => $Word,
                            Translation => $Translation,
                        };
                        $Param{Stats}->{$Param{Language}}->{$Word} = $Translation;
                    }
                }
                else {
                    # lookup for existing translation in core language object
                    $UsedWords{$Word} = $POTranslations{$Word} || $LanguageCoreObject->{Translation}->{$Word};
                    my $Translation = $UsedWords{$Word} || '';
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

    # add translatable strings from SysConfig
    if ( $Param{Verbose} ) {
        print "SysConfig\n";
    }
    my @Strings = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemTranslatableStrings();

    STRING:
    for my $String ( sort @Strings ) {

        next STRING if !$String || exists $UsedWords{$String};

        # skip if we translate a module and the word already exists in the core translation
        next STRING if $IsSubTranslation && exists $LanguageCoreObject->{Translation}->{$String};

        # lookup for existing translation
        $UsedWords{$String} = $POTranslations{$String}
            || ( $IsSubTranslation ? $LanguageObject : $LanguageCoreObject )->{Translation}
            ->{$String};

        my $Translation = $UsedWords{$String} || '';
        push @TranslationStrings, {
            Location    => 'SysConfig',
            Source      => $String,
            Translation => $Translation,
        };
        $Param{Stats}->{ $Param{Language} }->{$String} = $Translation;
    }

    if ( $Param{WritePOT} && !$POTFileWritten++ ) {
        WritePOTFile(
            TranslationStrings => \@TranslationStrings,
            TargetPOTFile      => $TargetPOTFile,
            Module             => $Module,
        );
    }
    if ( $Param{WritePO} ) {
        WritePOFile(
            TranslationStrings => \@TranslationStrings,
            TargetPOTFile      => $TargetPOTFile,
            TargetPOFile       => $TargetPOFile,
            Module             => $Module,
        );
    }

    WritePerlLanguageFile(
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
    my (%Param) = @_;

    return if !-e $Param{TargetPOFile};

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
    my (%Param) = @_;

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
    my (%Param) = @_;

    my @POTEntries;

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
    my (%Param) = @_;

    my $LanguageCoreObject = $Param{LanguageCoreObject};

    my $Indent = ' ' x 8;    # 8 spaces for core files
    if ( $Param{IsSubTranslation} ) {
        $Indent = ' ' x 4;    # 4 spaces for module files
    }

    my $Data;

    my $PreviousLocation = '';
    for my $String ( @{ $Param{TranslationStrings} } ) {
        if ( $PreviousLocation ne $String->{Location} ) {
            $Data .= "\n";
            $Data .= $Indent . "# $String->{Location}\n";
            $PreviousLocation = $String->{Location};
        }

        # Escape ' signs in strings
        my $Key = $String->{Source};
        $Key =~ s/'/\\'/g;
        my $Translation = $String->{Translation};
        $Translation =~ s/'/\\'/g;

        if ( $Param{IsSubTranslation} ) {
            if ( length($Key) < $BreakLineAfterChars ) {
                $Data .= $Indent . "\$Self->{Translation}->{'$Key'} = '$Translation';\n";
            }
            else {
                $Data .= $Indent . "\$Self->{Translation}->{'$Key'} =\n";
                $Data .= $Indent . '    ' . "'$Translation';\n";
            }
        }
        else {
            if ( length($Key) < $BreakLineAfterChars ) {
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
# Kernel/Language/$Param{Language}_$Param{Module}.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
                $NewOut .= <<"EOF";
    # date formats (\%A=WeekDay;\%B=LongMonth;\%T=Time;\%D=Day;\%M=Month;\%Y=Year;)
    \$Self->{DateFormat}          = '$LanguageCoreObject->{DateFormat}';
    \$Self->{DateFormatLong}      = '$LanguageCoreObject->{DateFormatLong}';
    \$Self->{DateFormatShort}     = '$LanguageCoreObject->{DateFormatShort}';
    \$Self->{DateInputFormat}     = '$LanguageCoreObject->{DateInputFormat}';
    \$Self->{DateInputFormatLong} = '$LanguageCoreObject->{DateInputFormatLong}';

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
        if ( $Param{Verbose} ) {
            print "Moving $TargetFile to $TargetFile.old\n";
        }
        rename( $TargetFile, "$TargetFile.old" ) || die $!;
    }

    if ( $Param{Verbose} ) {
        print "Writing $TargetFile\n";
    }

    $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $TargetFile,
        Content  => \$NewOut,
        Mode     => 'utf8',        # binmode|utf8
    );
}

## use critic
