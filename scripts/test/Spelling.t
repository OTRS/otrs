# --
# Spelling.t - Authentication tests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: Spelling.t,v 1.2 2012-07-18 04:22:34 cg Exp $
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
        Text          => "This is a textu with errors",
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
