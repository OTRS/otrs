# --
# scripts/test/Layout/Template/OutputFilters.t - layout testscript
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

use Kernel::Output::HTML::Layout;

use Kernel::System::VariableCheck qw(:all);

my @Tests = (
    {
        Name   => 'Output filter post, all templates',
        Config => {
            "Frontend::Output::FilterElementPre"  => {},
            "Frontend::Output::FilterElementPost" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        ALL => 1,
                    },
                    Prefix => "OutputFilterPostPrefix1:\n",
                },
            },
        },
        IsCacheable => 1,
        UseCache    => 0,
        Data        => {
            Title => 'B&B 1'
        },
        Result => 'OutputFilterPostPrefix1:
Test: B&B 1
',
    },
    {
        Name   => 'Output filter post, all templates, cache test (cacheable)',
        Config => {
            "Frontend::Output::FilterElementPre"  => {},
            "Frontend::Output::FilterElementPost" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        ALL => 1,
                    },
                    Prefix => "OutputFilterPostPrefix2:\n",
                },
            },
        },
        IsCacheable => 1,
        UseCache    => 1,
        Data        => {
            Title => 'B&B 2'
        },
        Result => 'OutputFilterPostPrefix2:
Test: B&B 2
',
    },
    {
        Name   => 'Output filter post, OutputFilters template',
        Config => {
            "Frontend::Output::FilterElementPre"  => {},
            "Frontend::Output::FilterElementPost" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        OutputFilters => 1,
                    },
                    Prefix => "OutputFilterPostPrefix3:\n",
                },
            },
        },
        IsCacheable => 1,
        UseCache    => 0,
        Data        => {
            Title => 'B&B 3'
        },
        Result => 'OutputFilterPostPrefix3:
Test: B&B 3
',
    },
    {
        Name   => 'Output filter post, OutputFilters template, cache test (cacheable)',
        Config => {
            "Frontend::Output::FilterElementPre"  => {},
            "Frontend::Output::FilterElementPost" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        OutputFilters => 1,
                    },
                    Prefix => "OutputFilterPostPrefix4:\n",
                },
            },
        },
        IsCacheable => 1,
        UseCache    => 1,
        Data        => {
            Title => 'B&B 4'
        },
        Result => 'OutputFilterPostPrefix4:
Test: B&B 4
',
    },
    {
        Name   => 'Output filter pre, all templates',
        Config => {
            "Frontend::Output::FilterElementPre" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        ALL => 1,
                    },
                    Prefix => "OutputFilterPrePrefix5:\n",
                },
            },
            "Frontend::Output::FilterElementPost" => {},
        },
        IsCacheable => 1,
        UseCache    => 0,
        Data        => {
            Title => 'B&B 5'
        },
        Result => 'Test: B&B 5
',
    },
    {
        Name   => 'Output filter pre, all templates, filter ignored',
        Config => {
            "Frontend::Output::FilterElementPre" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        ALL => 1,
                    },
                    Prefix => "OutputFilterPrePrefix6:\n",
                },
            },
            "Frontend::Output::FilterElementPost" => {},
        },
        IsCacheable => 1,
        UseCache    => 1,
        Data        => {
            Title => 'B&B 6'
        },
        Result => 'Test: B&B 6
',
    },
    {
        Name   => 'Output filter pre, OutputFilters template',
        Config => {
            "Frontend::Output::FilterElementPre" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        'OutputFilters' => 1,
                    },
                    Prefix => "OutputFilterPrePrefix7:\n",
                },
            },
            "Frontend::Output::FilterElementPost" => {},
        },
        IsCacheable => 0,
        UseCache    => 0,
        Data        => {
            Title => 'B&B 7'
        },
        Result => 'OutputFilterPrePrefix7:
Test: B&B 7
',
    },
    {
        Name   => 'Output filter pre, OutputFilters template, cache test (uncacheable)',
        Config => {
            "Frontend::Output::FilterElementPre" => {
                "100-TestFilter" => {
                    Module    => 'scripts::test::Layout::Template::OutputFilter',
                    Templates => {
                        'OutputFilters' => 1,
                    },
                    Prefix => "OutputFilterPrePrefix8:\n",
                },
            },
            "Frontend::Output::FilterElementPost" => {},
        },
        IsCacheable => 0,
        UseCache    => 1,
        Data        => {
            Title => 'B&B 8'
        },
        Result => 'OutputFilterPrePrefix8:
Test: B&B 8
',
    },
);

for my $Test (@Tests) {

    # delete cache to keep requests isolated unless caching is tested
    if ( !$Test->{UseCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'TemplateProvider',
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    for my $Key ( sort keys %{ $Test->{Config} || {} } ) {
        $ConfigObject->Set(
            Key   => $Key,
            Value => $Test->{Config}->{$Key}
        );
    }

    my $LayoutObject = Kernel::Output::HTML::Layout->new(
        UserID => 1,
        Lang   => 'de',
    );

    # Call Output() once so that the TT objects are created.
    $LayoutObject->Output( Template => '' );

    # Now add this directory as include path to be able to use the test templates
    my $IncludePaths = $LayoutObject->{TemplateProviderObject}->include_path();
    unshift @{$IncludePaths}, $ConfigObject->Get('Home') . '/scripts/test/Layout/Template';
    $LayoutObject->{TemplateProviderObject}->include_path($IncludePaths);

    for my $Block ( @{ $Test->{BlockData} || [] } ) {
        $LayoutObject->Block( %{$Block} );
    }

    my $Result = $LayoutObject->Output(
        TemplateFile => 'OutputFilters',
        Data         => $Test->{Data} // {},
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name},
    );

    $Self->Is(
        IsHashRefWithData( $LayoutObject->{TemplateProviderObject}->{UncacheableTemplates} )
        ? 0
        : 1,
        $Test->{IsCacheable},
        'Have uncacheable templates',
    );
    my $FileName = $ConfigObject->Get('Home') . '/scripts/test/Layout/Template/OutputFilters.tt';
    $FileName =~ s{/{2,}}{/}g;    # remove duplicated //
    $Self->Is(
        $LayoutObject->{TemplateProviderObject}->{_TemplateCache}->{$FileName} ? 1 : 0,
        $Test->{IsCacheable},
        'Template added to cache',
    );
}

1;
