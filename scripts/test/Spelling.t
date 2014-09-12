# --
# Spelling.t - Authentication tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $SpellCheckerBin = $ConfigObject->Get('SpellCheckerBin');

# check if spelling bin is located there
if ( !-e $SpellCheckerBin ) {

    # maybe in another location
    if ( -e '/usr/bin/aspell' ) {
        $ConfigObject->Set(
            Key   => 'SpellCheckerBin',
            Value => '/usr/bin/aspell',
        );
        $SpellCheckerBin = '/usr/bin/aspell';
    }
    else {
        $Self->True(
            1,
            "No such $SpellCheckerBin!",
        );
        return 1;
    }
}

# test for check spelling
my $LongText =
    '
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
(From A Language Teacher\'s Guide by E. A. Meras).
';

my $TestNumber = 1;

my @Tests = (
    {
        Name          => 'Test ' . $TestNumber++,
        SpellChecker  => "/wrong/path/ispell",
        SpellLanguage => "english",
        Text          => "Something for check",
        Replace       => 0,
        Error         => 1,
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SpellChecker  => $SpellCheckerBin,
        SpellLanguage => "english",
        Text          => "Thes is a textu with errors",
        Replace       => 1,
        Error         => 0,
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SpellChecker  => $SpellCheckerBin,
        SpellLanguage => "english",
        Text          => "A small text without errors,\n should be showed as OK",
        Replace       => 0,
        Error         => 0,
    },

    {
        Name          => 'Test ' . $TestNumber++,
        SpellChecker  => $SpellCheckerBin,
        SpellLanguage => "english",
        Text          => $LongText,
        Replace       => 1,
        Error         => 0,
    },

);

TEST:
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

    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Spelling'] );
    my $SpellingObject = $Kernel::OM->Get('Kernel::System::Spelling');

    $Self->Is(
        ref $SpellingObject,
        'Kernel::System::Spelling',
        "$Test->{Name} - Spelling object creation",
    );

    $Self->True(
        1,
        "$Test->{Name} - Performing spelling check",
    );

    my %SpellCheck = $SpellingObject->Check(
        Text          => $Test->{Text},
        SpellLanguage => $Test->{SpellLanguage},
    );

    # not value for spelling result means a possible not installed language issue
    if ( !%SpellCheck && $Test->{Replace} ) {
        $Self->True(
            0,
            "$Test->{Name} - Spelling -Seems like language file was not found," .
                " you must install the English dictionary for the spell checker!",
        );
        next TEST;
    }

    if ( $Test->{Replace} ) {
        $Self->Is(
            1,
            IsHashRefWithData( \%SpellCheck ),
            "$Test->{Name} - Spelling - Check result structure",
        );

        for my $Key ( sort keys %SpellCheck ) {

            if ( defined $SpellCheck{$Key}->{Replace} && $SpellCheck{$Key}->{Replace} ) {
                $Self->True(
                    $SpellCheck{$Key}->{Replace},
                    "$Test->{Name} - Spelling - Check structure - 'Replace' entry",
                );
                $Self->True(
                    IsArrayRefWithData( $SpellCheck{$Key}->{Replace} ),
                    "$Test->{Name} - Spelling - Check replace structure",
                );
            }
            else {
                $Self->True(
                    1,
                    "$Test->{Name} - Spelling -Not replace suggestions for - $SpellCheck{$Key}->{Word}",
                );
            }
            $Self->True(
                $SpellCheck{$Key}->{Line},
                "$Test->{Name} - Spelling -Check structure - 'Line' entry - $SpellCheck{$Key}->{Line}",
            );
            $Self->True(
                $SpellCheck{$Key}->{Word},
                "$Test->{Name} - Spelling - Check structure - 'Word' entry - $SpellCheck{$Key}->{Word}",
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
