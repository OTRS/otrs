# --
# scripts/test/Language.t - Language module testscript
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Language.t,v 1.2 2011-04-14 12:22:10 ub Exp $
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
$CommonObject{ConfigObject} = Kernel::Config->new();
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

# the translations for the test cases must be defined in Kernel/Language/de_OTRSLanguageUnitTest.pm
my %Test = (
    'OTRSLanguageUnitTest::Test1' => {
        Parameters => ['Hallo'],    # test with not needed parameter
        Translated => 'Test1',
    },
    'OTRSLanguageUnitTest::Test2' => {
        Parameters => ['Hallo'],
        Translated => 'Test2 [Hallo]',
    },
    'OTRSLanguageUnitTest::Test3' => {
        Parameters => [ 'Hallo', 'A' ],
        Translated => 'Test3 [Hallo] (A=A)',
    },
    'OTRSLanguageUnitTest::Test4' => {
        Parameters => [ 'Hallo', 'A', 'B' ],
        Translated => 'Test4 [Hallo] (A=A;B=B)',
    },
    'OTRSLanguageUnitTest::Test5' => {
        Parameters => [ 'Hallo', 'A', 'B', 'C' ],
        Translated => 'Test5 [Hallo] (A=A;B=B;C=C)',
    },
    'OTRSLanguageUnitTest::Test6' => {
        Parameters => [ 'Hallo', 'A', 'B', 'C', 'D' ],
        Translated => 'Test6 [Hallo] (A=A;B=B;C=C;D=D)',
    },
);

for my $OriginalString ( sort keys %Test ) {

    # build the parameter string, it looks strange but is correct:
    # History::NewTicket", "2011031110000023", "Postmaster", "3 normal", "open", "9
    my @Parameters      = @{ $Test{$OriginalString}->{Parameters} };
    my $ParameterString = '';
    for my $Parameter (@Parameters) {
        $ParameterString .= '", "' . $Parameter;
    }

    # get the translation
    my $TranslatedString = $LanguageObject->Get( $OriginalString . $ParameterString );

    # compare with expected translation
    $Self->Is(
        $TranslatedString || '',
        $Test{$OriginalString}->{Translated},
        'Translation of ' . $OriginalString,
    );
}

1;
