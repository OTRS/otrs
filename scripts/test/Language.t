# --
# scripts/test/Language.t - Language module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use utf8;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::Language;

# declare externally defined variables to avoid errors under 'use strict'
use vars qw( $Self %Param );

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = $Kernel::OM->Get('ConfigObject');
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'Language.t',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);

# create language object which contains all translations
my $LanguageObject = Kernel::Language->new(
    %CommonObject,
    UserLanguage => 'de',
);

# test cases
my %Test = (
    'OTRSLanguageUnitTest::Test1' => {
        TranslationString => 'Test1',
        TranslationResult => 'Test1',
        Parameters        => ['Hallo'],    # test with not needed parameter
    },
    'OTRSLanguageUnitTest::Test2' => {
        TranslationString => 'Test2 [%s]',
        TranslationResult => 'Test2 [Hallo]',
        Parameters        => ['Hallo'],
    },
    'OTRSLanguageUnitTest::Test3' => {
        TranslationString => 'Test3 [%s] (A=%s)',
        TranslationResult => 'Test3 [Hallo] (A=A)',
        Parameters        => [ 'Hallo', 'A' ],
    },
    'OTRSLanguageUnitTest::Test4' => {
        TranslationString => 'Test4 [%s] (A=%s;B=%s)',
        TranslationResult => 'Test4 [Hallo] (A=A;B=B)',
        Parameters        => [ 'Hallo', 'A', 'B' ],
    },
    'OTRSLanguageUnitTest::Test5' => {
        TranslationString => 'Test5 [%s] (A=%s;B=%s;C=%s)',
        TranslationResult => 'Test5 [Hallo] (A=A;B=B;C=C)',
        Parameters        => [ 'Hallo', 'A', 'B', 'C' ],
    },
    'OTRSLanguageUnitTest::Test6' => {
        TranslationString => 'Test6 [%s] (A=%s;B=%s;C=%s;D=%s)',
        TranslationResult => 'Test6 [Hallo] (A=A;B=B;C=C;D=D)',
        Parameters        => [ 'Hallo', 'A', 'B', 'C', 'D' ],
    },
    'OTRSLanguageUnitTest::Test7 [% test %] {" special characters %s"}' => {
        TranslationString => 'Test7 [% test %] {" special characters %s"}',
        TranslationResult => 'Test7 [% test %] {" special characters test"}',
        Parameters        => ['test'],
    },
);

for my $OriginalString ( sort keys %Test ) {

    # build the parameter string, it looks strange but is correct:
    # History::NewTicket", "2011031110000023", "Postmaster", "3 normal", "open", "9
    my @Parameters = @{ $Test{$OriginalString}->{Parameters} };

    # add translation string to language object
    $LanguageObject->{Translation}->{$OriginalString} = $Test{$OriginalString}->{TranslationString};

    # get the translation
    my $TranslatedString = $LanguageObject->Translate(
        $OriginalString,
        @Parameters,
    );

    # compare with expected translation
    $Self->Is(
        $TranslatedString || '',
        $Test{$OriginalString}->{TranslationResult},
        'Translation of ' . $OriginalString,
    );
}

1;
