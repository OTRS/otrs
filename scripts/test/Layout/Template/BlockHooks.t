# --
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

use File::Basename qw();

my @Tests = (
    {
        Name       => 'Simple test, no hooks',
        HookConfig => {},
        Blocks     => [qw(Block1 Block11 Block1 Block2)],
        Result     => <<EOF,
Content1
Content11
Content1

Content2
EOF
    },
    {
        Name       => 'Simple test with hooks',
        HookConfig => {
            '100-test' => {
                BlockHooks => ['Block1'],
            },
            '200-test' => {
                BlockHooks => ['Block2'],
            },
        },
        Blocks => [qw(Block1 Block11 Block1 Block2)],
        Result => <<EOF,
<!--HookStartBlock1-->
Content1
Content11
<!--HookEndBlock1-->
<!--HookStartBlock1-->
Content1
<!--HookEndBlock1-->

<!--HookStartBlock2-->
Content2
<!--HookEndBlock2-->
EOF
    },
    {
        Name       => 'Simple test with hooks in nested blocks',
        HookConfig => {
            '100-test' => {
                BlockHooks => [ 'Block1', 'Block11' ],
            },
            '200-test' => {
                BlockHooks => ['Block2'],
            },
        },
        Blocks => [qw(Block1 Block11 Block1 Block2)],
        Result => <<EOF,
<!--HookStartBlock1-->
Content1
<!--HookStartBlock11-->
Content11
<!--HookEndBlock11-->
<!--HookEndBlock1-->
<!--HookStartBlock1-->
Content1
<!--HookEndBlock1-->

<!--HookStartBlock2-->
Content2
<!--HookEndBlock2-->
EOF
    },
);

for my $Test (@Tests) {

    $Kernel::OM->ObjectsDiscard();

    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'Frontend::Template::GenerateBlockHooks',
        Value => $Test->{HookConfig},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # call Output() once so that the TT objects are created.
    $LayoutObject->Output( Template => '' );

    # now add this directory as include path to be able to use the test templates
    my $IncludePaths = $LayoutObject->{TemplateProviderObject}->include_path();
    unshift @{$IncludePaths}, $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/scripts/test/Layout/Template';
    $LayoutObject->{TemplateProviderObject}->include_path($IncludePaths);

    for my $Block ( @{ $Test->{Blocks} } ) {
        $LayoutObject->Block(
            Name => $Block,
        );
    }

    my $Result = $LayoutObject->Output(
        TemplateFile => 'BlockHooks',
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name},
    );
}

1;
