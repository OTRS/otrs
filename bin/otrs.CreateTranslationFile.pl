#!/usr/bin/perl -w
# --
# bin/otrs.CreateTranslationFile.pl - create new translation file
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: otrs.CreateTranslationFile.pl,v 1.15 2010-11-19 08:51:26 mn Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

use Getopt::Std qw();
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::Language;
use Kernel::System::SysConfig;

# print head
print <<"EOF";
otrs.CreateTranslationFile <Revision $VERSION> - update translation files
Copyright (C) 2001-2010 OTRS AG, http://otrs.org/

Usage: otrs.CreateTranslationFile -l <Language> -m <module_directory>

EOF

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.CreateTranslationFile.pl',
    %CommonObject,
);
$CommonObject{MainObject}      = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}      = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}        = Kernel::System::DB->new(%CommonObject);
$CommonObject{SysConfigObject} = Kernel::System::SysConfig->new(%CommonObject);

my $Home = $CommonObject{ConfigObject}->Get('Home');

{
    my @Languages;
    my %Opts;

    # get opts
    Getopt::Std::getopt( 'lm', \%Opts );

    # check params
    if ( !$Opts{l} ) {
        my %DefaultUsedLanguages = %{ $CommonObject{ConfigObject}->Get('DefaultUsedLanguages') };
        @Languages = sort keys %DefaultUsedLanguages;

        # ignore en*.pm files
        @Languages = grep { $_ !~ / \A en.* /smx } @Languages;
    }
    else {
        push @Languages, $Opts{l};
        if ( !-f "$Home/Kernel/Language/$Languages[0].pm" ) {
            print "ERROR: No core translation file: $Languages[0]!\n";
            exit 1;
        }
    }

    print "Starting...\n\n";

    for my $Language (@Languages) {
        HandleLanguage(
            Language => $Language,
            Module   => $Opts{m},
        );
    }

    print "\n\nFinished.\n";
}

sub HandleLanguage {
    my %Params = @_;

    my $Language = $Params{Language};
    my $Module   = $Params{Module};

    my $ModuleDirectory = $Module;
    my $LanguageFile;
    my $TargetFile;
    my $IsSubTranslation;
    my $DefaultTheme = $CommonObject{ConfigObject}->Get('DefaultTheme');

    if ( !$Module ) {
        $LanguageFile = "$Home/Kernel/Language/$Language.pm";
        $TargetFile   = "$Home/Kernel/Language/$Language.pm";
    }
    else {
        $IsSubTranslation = 1;

        # extract module name from module path
        $Module =~ s/^.*\/(.+)\/?$/$1/;

        # save module directory in target file
        $TargetFile = "$ModuleDirectory/Kernel/Language/${Language}_$Module.pm";
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
        %CommonObject,
        UserLanguage    => $Language,
        TranslationFile => 1,
    );

    # Language file, which contains all translations
    my $LanguageObject = Kernel::Language->new(
        %CommonObject,
        UserLanguage => $Language,
    );

    # open .dtl files and write new translation file
    my $Data = '';
    my %UsedWords;
    my %UsedWordsMisc;
    my $Directory
        = $IsSubTranslation
        ? "$ModuleDirectory/Kernel/Output/HTML/$DefaultTheme"
        : "$Home/Kernel/Output/HTML/$DefaultTheme";

    my @List = $CommonObject{MainObject}->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.dtl'
    );

    print "\nReading template files: ";

    for my $File (@List) {
        if ( open my $In, '<', $File ) {
            my $Content = '';
            while ( my $Line = <$In> ) {
                if ( $Line !~ /^#/ ) {
                    $Content .= $Line;
                }
            }
            close $In;
            $File =~ s!^.*/(.+?)\.dtl!$1!;
            print "$File ";
            $Data .= "\n        # Template: $File\n";

            # replace data tags so that stuff like
            #   $Text{"$Data{"ernie"}"} will not be translated
            $Content =~ s{
            \$(Env|Data|QData)({"(.+?)"}|{""}|{"(.+?)","(.+?)"})
        }
        {}gx;

            # replace $Config so that stuff like
            #   $Text{"$Config{"Ticket::Frontend::TimeUnits"}"} will be translated
            $Content =~ s{
            \$Config\{"([^\}]+?)?"\}
        }
        {
            if ( defined $1 ) {
                $CommonObject{ConfigObject}->Get($1) || '';
            }
            else {
                '';
            }
        }egx;

            # do translation
            $Content =~ s{
            \$(?:JS)?Text\{"([^\}]+?)?"(?:,[^\}]+)?\}
        }
        {
            my $Word = '';
            if ( defined $1 ) {
                $Word = $1;
            }

            # if we translate a module, we must handle also that possibly
            # there is already a translation in the core files
            if ($IsSubTranslation) {
                # ignore word if already used
                if ( $Word && !exists $UsedWords{$Word} && !exists $LanguageCoreObject->{Translation}->{$Word} ) {

                    # remove it from misc list
                    $UsedWordsMisc{$Word} = 1;

                    # lookup for existing translation
                    $UsedWords{$Word} = $LanguageObject->{Translation}->{$Word};
                    my $Translation = $UsedWords{$Word} || '';
                    $Translation =~ s/'/\\'/g;
                    my $Key = $Word;
                    $Key =~ s/'/\\'/g;
                    if ($Key !~ /(a href|\$(Text|Quote)\{")/i) {
                        $Data .= "        '$Key' => '$Translation',\n";
                    }
                }
            }
            else {
                # ignore word if already used
                if ( $Word && !exists $UsedWords{$Word} ) {

                    # remove it from misc list
                    $UsedWordsMisc{$Word} = 1;

                    # lookup for existing translation
                    $UsedWords{$Word} = $LanguageCoreObject->{Translation}->{$Word};
                    my $Translation = $UsedWords{$Word} || '';
                    $Translation =~ s/'/\\'/g;
                    my $Key = $Word;
                    $Key =~ s/'/\\'/g;
                    if ($Key !~ /(a href|\$(Text|Quote)\{")/i) {
                        $Data .= "        '$Key' => '$Translation',\n";
                    }
                }
            }
            '';
        }egx;
        }
        else {
            die "Can't open $File: $!";
        }
    }

    # add translatable strings from SysConfig
    print "SysConfig ";
    $Data .= "\n        # SysConfig\n";
    my @Strings = $CommonObject{SysConfigObject}->ConfigItemTranslatableStrings();

    for my $String ( sort @Strings ) {
        next if !$String;

        # skip if we translate a module and the word already exists in the core translation
        next if $IsSubTranslation && exists $LanguageCoreObject->{Translation}->{$String};

        # ignore word if already used
        next if exists $UsedWords{$String};

        # remove it from misc list
        $UsedWordsMisc{$String} = 1;

        # lookup for existing translation
        $UsedWords{$String}
            = ( $IsSubTranslation ? $LanguageObject : $LanguageCoreObject )->{Translation}
            ->{$String};

        my $Translation = $UsedWords{$String} || '';
        $Translation =~ s/'/\\'/g;
        my $Key = $String;
        $Key =~ s/'/\\'/g;
        $Data .= "        '$Key' => '$Translation',\n";
    }

    # add misc words
    print "Obsolete Entries\n\n";
    $Data .= "\n";
    $Data .= "        #\n";
    $Data .= "        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!\n";
    $Data .= "        #\n";
    for my $Key ( sort keys %{ $LanguageObject->{Translation} } ) {

        # ignore words from the core if we are translating a module
        next if $IsSubTranslation && exists $LanguageCoreObject->{Translation}->{$Key};

        # ignore word if already used
        next if $UsedWordsMisc{$Key};

        my $Translation = $LanguageObject->{Translation}->{$Key};
        $Translation =~ s/'/\\'/g;
        $Key         =~ s/'/\\'/g;

        # if a string was previously in a DTL, but has not yet been translated,
        # there's no need to preserve it in the translation file.
        next if ( !$Translation );

        # TODO: clarify if regular expression check is still needed
        #   in the past it was used to guard against wrong matches
        if ( $Key !~ /(a href|\$(Text|Quote)\{")/i ) {
            $Data .= "        '$Key' => '$Translation',\n";
        }
    }

    # open old translation file
    my %MetaData;
    my $NewOut = '';

    # translating a module
    if ($IsSubTranslation) {
        $NewOut = '';
        $NewOut .= "\n";
        $NewOut .= "package Kernel::Language::${Language}_$Module;\n";
        $NewOut .= "\n";
        $NewOut .= "use strict;\n";
        $NewOut .= "\n";
        $NewOut .= "\n";
        $NewOut .= "sub Data {\n";
        $NewOut .= "    my \$Self = shift;\n";
        $NewOut .= "\n";
        $NewOut .= "    \$Self->{Translation} = { %{\$Self->{Translation}},\n";
        $NewOut .= $Data;
        $NewOut .= "\n";
        $NewOut .= "    };\n";
        $NewOut .= "}\n";
        $NewOut .= "1;\n";
    }

    # translating the core
    else {
        open( my $In, '<', $LanguageFile ) || die "Can't open: $LanguageFile\n";
        while (<$In>) {
            if ( !$MetaData{DataPrinted} ) {
                $NewOut .= $_;
            }
            if ( $_ =~ /\$\$START\$\$/ && !$MetaData{DataPrinted} ) {
                $MetaData{DataPrinted} = 1;

                my ( $Sec, $Min, $Hour, $Day, $Month, $Year )
                    = $CommonObject{TimeObject}->SystemTime2Date(
                    SystemTime => $CommonObject{TimeObject}->SystemTime(),
                    );

                $NewOut
                    .= "    # Last translation file sync: $Year-$Month-$Day $Hour:$Min:$Sec\n\n";
                $NewOut .= "    # possible charsets\n" . "    \$Self->{Charset} = [";
                for ( $LanguageCoreObject->GetPossibleCharsets() ) {
                    $NewOut .= "'$_', ";
                }
                $NewOut
                    .= "];\n"
                    . "    # date formats (\%A=WeekDay;\%B=LongMonth;\%T=Time;\%D=Day;\%M=Month;\%Y=Year;)\n"
                    . "    \$Self->{DateFormat}          = '$LanguageCoreObject->{DateFormat}';\n"
                    . "    \$Self->{DateFormatLong}      = '$LanguageCoreObject->{DateFormatLong}';\n"
                    . "    \$Self->{DateFormatShort}     = '$LanguageCoreObject->{DateFormatShort}';\n"
                    . "    \$Self->{DateInputFormat}     = '$LanguageCoreObject->{DateInputFormat}';\n"
                    . "    \$Self->{DateInputFormatLong} = '$LanguageCoreObject->{DateInputFormatLong}';\n\n"
                    . "    # csv separator\n"
                    . "    \$Self->{Separator} = '$LanguageCoreObject->{Separator}';\n\n";

                if ( $LanguageCoreObject->{TextDirection} ) {
                    $NewOut .= "    # TextDirection rtl or ltr\n";
                    $NewOut
                        .= "    \$Self->{TextDirection} = '$LanguageCoreObject->{TextDirection}';\n\n";

                }
                $NewOut .= "    \$Self->{Translation} = {";
                $NewOut .= $Data;
            }
            if ( $_ =~ /\$\$STOP\$\$/ ) {
                $NewOut .= "    };\n" . $_;
                $MetaData{DataPrinted} = 0;
            }
        }
        close $In;
    }

    if ( -e $TargetFile ) {
        print "Moving $TargetFile to $TargetFile.old\n";
        rename( $TargetFile, "$TargetFile.old" ) || die $!;
    }

    print "Writing $TargetFile\n";
    open( my $Out, '>', $TargetFile ) || die $!;
    print $Out $NewOut;
    close $Out;
}
