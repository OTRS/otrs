# --
# CheckItem.t - check item tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CheckItem.t,v 1.1 2007-12-21 13:04:35 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::CheckItem;

$Self->{CheckItemObject} = Kernel::System::CheckItem->new(%{$Self});

# string clean tests
my $StringCleanTests = [
    {
        String => ' ',
        Params => {},
        Result => '',
    },
    {
        String => undef,
        Params => {},
        Result => undef,
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {},
        Result => "Test\n\r\t test\n\r\t Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 1,
            TrimRight => 0,
        },
        Result => "Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 0,
            TrimRight => 1,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 0,
            TrimRight => 0,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 1,
            TrimRight => 1,
            RemoveAllNewlines => 1,
            RemoveAllTabs => 0,
            RemoveAllSpaces => 0,
        },
        Result => "Test\t test\t Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 1,
            TrimRight => 1,
            RemoveAllNewlines => 0,
            RemoveAllTabs => 1,
            RemoveAllSpaces => 0,
        },
        Result => "Test\n\r test\n\r Test",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 1,
            TrimRight => 1,
            RemoveAllNewlines => 0,
            RemoveAllTabs => 0,
            RemoveAllSpaces => 1,
        },
        Result => "Test\n\r\ttest\n\r\tTest",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 0,
            TrimRight => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs => 0,
            RemoveAllSpaces => 0,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 0,
            TrimRight => 0,
            RemoveAllNewlines => 1,
            RemoveAllTabs => 0,
            RemoveAllSpaces => 0,
        },
        Result => "\t Test\t test\t Test\t ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 0,
            TrimRight => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs => 1,
            RemoveAllSpaces => 0,
        },
        Result => "\n\r Test\n\r test\n\r Test\n\r ",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 0,
            TrimRight => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs => 0,
            RemoveAllSpaces => 1,
        },
        Result => "\n\r\tTest\n\r\ttest\n\r\tTest\n\r\t",
    },
    {
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft => 0,
            TrimRight => 0,
            RemoveAllNewlines => 1,
            RemoveAllTabs => 1,
            RemoveAllSpaces => 1,
        },
        Result => "TesttestTest",
    },
];

for my $Test ( @{$StringCleanTests} ) {

    # copy string to leave the original untouched
    my $String = $Test->{String};

    # start sting preparation
    $Self->{CheckItemObject}->StringClean(
        StringRef => \$String,
        %{$Test->{Params}},
    );

    # check result
    $Self->Is(
        $String,
        $Test->{Result},
        'TrimTest',
    );
}

1;