# --
# scripts/test/Language/Translate.t - Language module testscript
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Language;

# create language object which contains all translations
my $LanguageObject = Kernel::Language->new(
    UserLanguage => 'de',
);

# test cases
my @Tests = (
    {
        OriginalString    => '0',    # test with zero
        TranslationString => '',     # test without a translation string
        TranslationResult => '0',
    },
    {
        OriginalString    => 'OTRSLanguageUnitTest::Test1',
        TranslationString => 'Test1',
        TranslationResult => 'Test1',
        Parameters        => ['Hallo'],                       # test with not needed parameter
    },
    {
        OriginalString    => 'OTRSLanguageUnitTest::Test2',
        TranslationString => 'Test2 [%s]',
        TranslationResult => 'Test2 [Hallo]',
        Parameters        => ['Hallo'],
    },
    {
        OriginalString    => 'OTRSLanguageUnitTest::Test3',
        TranslationString => 'Test3 [%s] (A=%s)',
        TranslationResult => 'Test3 [Hallo] (A=A)',
        Parameters        => [ 'Hallo', 'A' ],
    },
    {
        OriginalString    => 'OTRSLanguageUnitTest::Test4',
        TranslationString => 'Test4 [%s] (A=%s;B=%s)',
        TranslationResult => 'Test4 [Hallo] (A=A;B=B)',
        Parameters        => [ 'Hallo', 'A', 'B' ],
    },
    {
        OriginalString    => 'OTRSLanguageUnitTest::Test5',
        TranslationString => 'Test5 [%s] (A=%s;B=%s;C=%s)',
        TranslationResult => 'Test5 [Hallo] (A=A;B=B;C=C)',
        Parameters        => [ 'Hallo', 'A', 'B', 'C' ],
    },
    {
        OriginalString    => 'OTRSLanguageUnitTest::Test6',
        TranslationString => 'Test6 [%s] (A=%s;B=%s;C=%s;D=%s)',
        TranslationResult => 'Test6 [Hallo] (A=A;B=B;C=C;D=D)',
        Parameters        => [ 'Hallo', 'A', 'B', 'C', 'D' ],
    },
    {
        OriginalString    => 'OTRSLanguageUnitTest::Test7 [% test %] {" special characters %s"}',
        TranslationString => 'Test7 [% test %] {" special characters %s"}',
        TranslationResult => 'Test7 [% test %] {" special characters test"}',
        Parameters        => ['test'],
    },
);

for my $Test (@Tests) {

    # add translation string to language object
    $LanguageObject->{Translation}->{ $Test->{OriginalString} } = $Test->{TranslationString};

    # get the translation
    my $TranslatedString;

    # test cases with parameters
    if ( $Test->{Parameters} ) {

        $TranslatedString = $LanguageObject->Translate(
            $Test->{OriginalString},
            @{ $Test->{Parameters} },
        );
    }

    # test cases without a parameter
    else {
        $TranslatedString = $LanguageObject->Translate(
            $Test->{OriginalString},
        );
    }

    # compare with expected translation
    $Self->Is(
        $TranslatedString // '',
        $Test->{TranslationResult},
        'Translation of ' . $Test->{OriginalString},
    );
}

1;
