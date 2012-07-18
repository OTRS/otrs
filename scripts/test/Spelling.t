# --
# Spelling.t - Authentication tests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Spelling.t,v 1.3 2012-07-18 17:57:17 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::Spelling;
use Kernel::System::VariableCheck qw(:all);

# use local Config object because it will be modified
my $ConfigObject = Kernel::Config->new();

# test for check spelling
my $LongText =
    '
Text
In deeling with students on the hih-school level - that is, the second, third, and
forth year of high school - we must bare in mind that to some degree they are at a
dificult sychological stage, generaly called adolesence. Students at this level are
likely to be confused mentaly, to be subject to involuntery distractions and romantic
dreamines. They are basicaly timid or self-consious, they lack frankness and are usualy
very sensitive but hate to admit it. They are motivated iether by great ambition, probably
out of all proportion to their capabiltys, or by extreme lazines caused by the fear of not
suceeding or ataining their objectives. Fundamentaly they want to be kept busy but they
refuse to admit it. They are frequently the victims of earlier poor training, and this
makes evary effort doubly hard. They are usually wiling to work, but they hate to work
without obtaining the results they think they shoud obtain. Their critical faculties
are begining to develop and they are critical of their instructers and of the materiels
they are given to laern. They are begining to feel the presher of time; and althouh they
seldem say so, they really want to be consulted and given an oportunity to direct their
own afairs, but they need considerable gidance.
(From A Language Teacher\'s Guide by E. A. Méras).
';

my $TestNumber = 1;

my @Tests = (
    {
        Name          => 'Test ' . $TestNumber++,
        SpellChecker  => "/usr/bin/nospellchecker",
        SpellLanguage => "en",
        Text          => "Something for check",
        Replace       => 0,
        Error         => 1,
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SpellChecker  => "/wrong/path/aspell",
        SpellLanguage => "en",
        Text          => "Something for check",
        Replace       => 0,
        Error         => 1,
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SpellChecker  => "/usr/bin/aspell",
        SpellLanguage => "en",
        Text          => "Thes is a textu with errors",
        Replace       => 1,
        Error         => 0,
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SpellChecker  => "/usr/bin/aspell",
        SpellLanguage => "en",
        Text          => "Anoter wronj text",
        Replace       => 1,
        Error         => 0,
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SpellChecker  => "/usr/bin/aspell",
        SpellLanguage => "en",
        Text          => "A small text without errors,\n should be showed as OK",
        Replace       => 0,
        Error         => 0,
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SpellChecker  => "/usr/bin/aspell",
        SpellLanguage => "en",
        Text          => $LongText,
        Replace       => 1,
        Error         => 0,
    },

);

for my $Test (@Tests) {

    # configure spell checker bin
    $ConfigObject->Set(
        Key   => 'SpellCheckerBin',
        Value => $Test->{SpellChecker},
    );

    $Self->Is(
        $ConfigObject->Get('SpellCheckerBin'),
        $Test->{SpellChecker},
        "Setting new value for SpellCheckerBin config item",
    );

    # create spelling object
    my $SpellingObject = Kernel::System::Spelling->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );

    $Self->Is(
        ref $SpellingObject,
        'Kernel::System::Spelling',
        "$Test->{Name} - WebsUserAgent object creation",
    );

    $Self->True(
        1,
        "$Test->{Name} - Performing spelling check",
    );

    my %SpellCheck = $SpellingObject->Check(
        Text          => $Test->{Text},
        SpellLanguage => $Test->{SpellLanguage},
    );

    if ( $Test->{Replace} ) {
        $Self->True(
            IsHashRefWithData( \%SpellCheck ),
            "$Test->{Name} - Spelling - Check result structure",
        );

        for my $Key ( sort keys %SpellCheck ) {
            $Self->True(
                $SpellCheck{$Key}->{Replace},
                "$Test->{Name} - Spelling - Check structure - 'Replace' entry",
            );
            $Self->True(
                IsArrayRefWithData( $SpellCheck{$Key}->{Replace} ),
                "$Test->{Name} - Spelling - Check replace structure",
            );
            $Self->True(
                $SpellCheck{$Key}->{Line},
                "$Test->{Name} - Spelling -Check structure - 'Line' entry",
            );
            $Self->True(
                $SpellCheck{$Key}->{Word},
                "$Test->{Name} - Spelling - Check structure - 'Word' entry",
            );
            $Self->False(
                $SpellingObject->Error(),
                "$Test->{Name} - Spelling Not error",
            );
        }

    }
    elsif ( $Test->{Error} ) {

        $Self->True(
            $SpellingObject->Error(),
            "$Test->{Name} - Spelling - Fail test for Text: $Test->{Text}",
        );
        $Self->False(
            $SpellCheck{Content},
            "$Test->{Name} - Spelling - check content empty",
        );
    }
    else {

        $Self->True(
            1,
            "$Test->{Name} - Spell check ok for: $Test->{Text}",
        );

    }

}

1;
