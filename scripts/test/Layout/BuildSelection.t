# --
# scripts/test/Layout/BuildSelection.t - layout BuildSelection() testscript
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

# get needed objects
my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
my $JSONObject  = $Kernel::OM->Get('Kernel::System::JSON');

my $LayoutObject = Kernel::Output::HTML::Layout->new(
    Lang => 'de',
);

# set JSON values
my $JSONTrue  = $JSONObject->True();
my $JSONFalse = $JSONObject->False();

# zero test for SelectedID attribute
my $HTMLCode = $LayoutObject->BuildSelection(
    Data => {
        0 => 'zero',
        1 => 'one',
        2 => 'two',
    },
    SelectedID  => 0,
    Name        => 'test',
    Translation => 0,
    Max         => 37,
);
my $SelectedTest = 0;

if ( $HTMLCode =~ m{ value="0" \s selected}smx ) {
    $SelectedTest = 1;
}

$Self->True(
    $SelectedTest,
    "Layout.t - zero test for SelectedID attribute in BuildSelection().",
);

# Ajax and OnChange exclude each other
$HTMLCode = $LayoutObject->BuildSelection(
    Data => {
        0 => 'zero',
        1 => 'one',
        2 => 'two',
    },
    Name     => 'test',
    OnChange => q{alert('just testing')},
    Ajax     => {},
);

$Self->False(
    $HTMLCode,
    q{Layout.t - 'Ajax' and 'OnChange' exclude each other in BuildSelection().},
);

# set tests
my @Tests = (
    {
        Name       => 'Missing Data',
        Definition => {
            Data           => undef,
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response     => undef,
        Success      => 0,
        ExecuteJSON  => 0,
        JSONResponse => undef,
    },
    {
        Name       => 'Missing Name',
        Definition => {
            Data => {
                1  => 'Object1',
                2  => 'Object1::AttributeA',
                3  => 'Object1::AttributeA::Value1',
                4  => 'Object1::AttributeA::Value2',
                5  => 'Object1::AttributeB',
                6  => 'Object1::AttributeB::Value1',
                7  => 'Object1::AttributeB::Value2',
                8  => 'Object2',
                9  => 'Object2::AttributeA',
                10 => 'Object2::AttributeA::Value1',
                11 => 'Object2::AttributeA::Value2',
                12 => 'Object2::AttributeB',
                13 => 'Object2::AttributeB::Value1',
                14 => 'Object2::AttributeB::Value2',
            },
            Name           => undef,
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response     => undef,
        Success      => 0,
        ExecuteJSON  => 0,
        JSONResponse => undef,
    },
    {
        Name       => 'AJAX (undocumented option)',
        Definition => {
            Data => {
                1 => 'Object1',
            },
            Name     => 'Select1',
            ID       => 'Select1ID',
            Sort     => 'TreeView',
            Multiple => 0,
            Ajax     => {
                Subaction => 'test',
                Depend    => 'other',
                Update    => [ 1, 2 ],
            },
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            q{<select id="Select1ID" name="Select1" onchange="Core.AJAX.FormUpdate($('#Select1ID'), 'test', 'Select1', ['1', '2']);">
  <option value="1">Object1</option>
</select> <a href="#" title="Baumauswahl anzeigen" class="ShowTreeSelection"><span>Baumauswahl anzeigen</span><i class="fa fa-sitemap"></i></a>},
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Normal Tree (Hash)',
        Definition => {
            Data => {
                1  => 'Object1',
                2  => 'Object1::AttributeA',
                3  => 'Object1::AttributeA::Value1',
                4  => 'Object1::AttributeA::Value2',
                5  => 'Object1::AttributeB',
                6  => 'Object1::AttributeB::Value1',
                7  => 'Object1::AttributeB::Value2',
                8  => 'Object2',
                9  => 'Object2::AttributeA',
                10 => 'Object2::AttributeA::Value1',
                11 => 'Object2::AttributeA::Value2',
                12 => 'Object2::AttributeB',
                13 => 'Object2::AttributeB::Value1',
                14 => 'Object2::AttributeB::Value2',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="1">Object1</option>
  <option value="2" selected="selected">&nbsp;&nbsp;AttributeA</option>
  <option value="3">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="4">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="5">&nbsp;&nbsp;AttributeB</option>
  <option value="6">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="7">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="8">Object2</option>
  <option value="9">&nbsp;&nbsp;AttributeA</option>
  <option value="10">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="11">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="12">&nbsp;&nbsp;AttributeB</option>
  <option value="13">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="14">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select> <a href="#" title="Baumauswahl anzeigen" class="ShowTreeSelection"><span>Baumauswahl anzeigen</span><i class="fa fa-sitemap"></i></a>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '2', '&nbsp;&nbsp;AttributeA',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    '3', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '4', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '5', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '6', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '7', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse,
                    $JSONFalse,
                ],
                [
                    '8', 'Object2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '9', '&nbsp;&nbsp;AttributeA',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '10', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '11', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '12', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '13', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '14', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Normal Tree (Hash), no TreeView',
        Definition => {
            Data => {
                1 => 'Object1',
                2 => 'Object1::AttributeA',
                3 => 'Object1::AttributeA::Value1',
                4 => 'Object1::AttributeA::Value2',
                5 => 'Object1::AttributeB',
                6 => 'Object1::AttributeB::Value1',
                7 => 'Object1::AttributeB::Value2',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'Numeric',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 0,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="1">Object1</option>
  <option value="2" selected="selected">Object1::AttributeA</option>
  <option value="3">Object1::AttributeA::Value1</option>
  <option value="4">Object1::AttributeA::Value2</option>
  <option value="5">Object1::AttributeB</option>
  <option value="6">Object1::AttributeB::Value1</option>
  <option value="7">Object1::AttributeB::Value2</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '2', 'Object1::AttributeA',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    '3', 'Object1::AttributeA::Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '4', 'Object1::AttributeA::Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '5', 'Object1::AttributeB',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '6', 'Object1::AttributeB::Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '7', 'Object1::AttributeB::Value2',
                    $JSONFalse, $JSONFalse,
                    $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Normal Tree (Hash), no TreeView, Selection w/HTMLQuote',
        Definition => {
            Data => {
                'a & b' => 'a & b',
                'c & d' => 'c & d',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'Numeric',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 'c & d',
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 0,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 1,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response => '<select id="Select1ID" name="Select1">
  <option value="a &amp; b">a &amp; b</option>
  <option value="c &amp; d" selected="selected">c &amp; d</option>
</select>',
        Success     => 1,
        ExecuteJSON => 1,
        JSONResponse =>
            {
            'Select1' => [
                [
                    'a & b', 'a & b',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'c & d', 'c & d',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
            ],
            },
    },
    {
        Name       => 'Missing Emements Tree 1 (Hash)',
        Definition => {
            Data => {
                1  => 'Object1',
                3  => 'Object1::AttributeA::Value1',
                4  => 'Object1::AttributeA::Value2',
                6  => 'Object1::AttributeB::Value1',
                7  => 'Object1::AttributeB::Value2',
                10 => 'Object2::AttributeA::Value1',
                11 => 'Object2::AttributeA::Value2',
                13 => 'Object2::AttributeB::Value1',
                14 => 'Object2::AttributeB::Value2',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="1">Object1</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeA</option>
  <option value="3">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="4">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="6">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="7">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">Object2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeA</option>
  <option value="10">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="11">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="13">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="14">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select> <a href="#" title="Baumauswahl anzeigen" class="ShowTreeSelection"><span>Baumauswahl anzeigen</span><i class="fa fa-sitemap"></i></a>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeA',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    '3', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '4', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    '6', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '7', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', 'Object2', $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeA',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    '10', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '11', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    '13', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '14', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Missing Emements Tree 2 (Hash)',
        Definition => {
            Data => {
                1  => 'Object1',
                2  => 'Object1::AttributeA',
                3  => 'Object1::AttributeA::Value1',
                4  => 'Object1::AttributeA::Value2',
                5  => 'Object1::AttributeB',
                6  => 'Object1::AttributeB::Value1',
                7  => 'Object1::AttributeB::Value2',
                8  => 'Object2',
                14 => 'Object2::AttributeB::Value2',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="1">Object1</option>
  <option value="2" selected="selected">&nbsp;&nbsp;AttributeA</option>
  <option value="3">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="4">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="5">&nbsp;&nbsp;AttributeB</option>
  <option value="6">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="7">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="8">Object2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="14">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select> <a href="#" title="Baumauswahl anzeigen" class="ShowTreeSelection"><span>Baumauswahl anzeigen</span><i class="fa fa-sitemap"></i></a>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '2', '&nbsp;&nbsp;AttributeA',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    '3', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '4', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '5', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '6', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '7', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '8', 'Object2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    '14', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
            ],
        },
    },

    # arrayref tests
    {
        Name       => 'Normal Tree (Array)',
        Definition => {
            Data => [
                'Object1',
                'Object1::AttributeA',
                'Object1::AttributeA::Value1',
                'Object1::AttributeA::Value2',
                'Object1::AttributeB',
                'Object1::AttributeB::Value1',
                'Object1::AttributeB::Value2',
                'Object2',
                'Object2::AttributeA',
                'Object2::AttributeA::Value1',
                'Object2::AttributeA::Value2',
                'Object2::AttributeB',
                'Object2::AttributeB::Value1',
                'Object2::AttributeB::Value2',
            ],
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => undef,
            SelectedValue  => 'Object1::AttributeA',
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="Object1">Object1</option>
  <option value="Object1::AttributeA" selected="selected">&nbsp;&nbsp;AttributeA</option>
  <option value="Object1::AttributeA::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeA::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="Object1::AttributeB">&nbsp;&nbsp;AttributeB</option>
  <option value="Object1::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="Object2">Object2</option>
  <option value="Object2::AttributeA">&nbsp;&nbsp;AttributeA</option>
  <option value="Object2::AttributeA::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object2::AttributeA::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="Object2::AttributeB">&nbsp;&nbsp;AttributeB</option>
  <option value="Object2::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object2::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select> <a href="#" title="Baumauswahl anzeigen" class="ShowTreeSelection"><span>Baumauswahl anzeigen</span><i class="fa fa-sitemap"></i></a>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    'Object1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeA', '&nbsp;&nbsp;AttributeA',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    'Object1::AttributeA::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeA::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeB', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2', 'Object2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2::AttributeA', '&nbsp;&nbsp;AttributeA',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2::AttributeA::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2::AttributeA::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2::AttributeB', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Missing Emements Tree 1 (Array)',
        Definition => {
            Data => [
                'Object1',
                'Object1::AttributeA::Value1',
                'Object1::AttributeA::Value2',
                'Object1::AttributeB::Value1',
                'Object1::AttributeB::Value2',
                'Object2::AttributeA::Value1',
                'Object2::AttributeA::Value2',
                'Object2::AttributeB::Value1',
                'Object2::AttributeB::Value2',
            ],
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => undef,
            SelectedValue  => 'Object1::AttributeA',
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="Object1">Object1</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeA</option>
  <option value="Object1::AttributeA::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeA::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="Object1::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">Object2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeA</option>
  <option value="Object2::AttributeA::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object2::AttributeA::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="Object2::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object2::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select> <a href="#" title="Baumauswahl anzeigen" class="ShowTreeSelection"><span>Baumauswahl anzeigen</span><i class="fa fa-sitemap"></i></a>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    'Object1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeA',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    'Object1::AttributeA::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeA::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    'Object1::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', 'Object2', $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeA',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    'Object2::AttributeA::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2::AttributeA::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    'Object2::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Missing Emements Tree 2 (Array)',
        Definition => {
            Data => [
                'Object1',
                'Object1::AttributeA',
                'Object1::AttributeA::Value1',
                'Object1::AttributeA::Value2',
                'Object1::AttributeB',
                'Object1::AttributeB::Value1',
                'Object1::AttributeB::Value2',
                'Object2',
                'Object2::AttributeB::Value1',
                'Object2::AttributeB::Value2',
            ],
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            AutoComplete   => 'off',
            OnChange       => 'onchangeJS',
            OnClick        => 'onclickJS',
            SelectedID     => undef,
            SelectedValue  => 'Object1::AttributeA',
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => 'Title"\'<>',
            OptionTitle    => 0,
        },
        Response =>
            '<select autocomplete="off" id="Select1ID" name="Select1" onchange="onchangeJS" onclick="onclickJS" title="Title&quot;\'&lt;&gt;">
  <option value="Object1">Object1</option>
  <option value="Object1::AttributeA" selected="selected">&nbsp;&nbsp;AttributeA</option>
  <option value="Object1::AttributeA::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeA::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="Object1::AttributeB">&nbsp;&nbsp;AttributeB</option>
  <option value="Object1::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="Object2">Object2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="Object2::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object2::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select> <a href="#" title="Baumauswahl anzeigen" class="ShowTreeSelection"><span>Baumauswahl anzeigen</span><i class="fa fa-sitemap"></i></a>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    'Object1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeA', '&nbsp;&nbsp;AttributeA',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    'Object1::AttributeA::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeA::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeB', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2', 'Object2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    'Object2::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object2::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Max with HashRef',
        Definition => {
            Data => {
                1 => 'Object1',
                2 => 'Object1::AttributeA',
                3 => 'Object1::AttributeA::Value1',
                4 => 'Object1::AttributeA::Value2',
                5 => 'Object1::AttributeB',
                6 => 'Object1::AttributeB::Value1',
                7 => 'Object1::AttributeB::Value2',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'Numeric',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 0,
            DisabledBranch => undef,
            Max            => 10,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="1">Object1</option>
  <option value="2" selected="selected">Objec[...]</option>
  <option value="3">Objec[...]</option>
  <option value="4">Objec[...]</option>
  <option value="5">Objec[...]</option>
  <option value="6">Objec[...]</option>
  <option value="7">Objec[...]</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '2', 'Objec[...]',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    '3', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '4', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '5', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '6', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '7', 'Objec[...]',
                    $JSONFalse, $JSONFalse,
                    $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Max with ArrayRef',
        Definition => {
            Data => [
                'Object1',
                'Object1::AttributeA',
                'Object1::AttributeA::Value1',
                'Object1::AttributeA::Value2',
                'Object1::AttributeB',
                'Object1::AttributeB::Value1',
                'Object1::AttributeB::Value2',
            ],
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'Numeric',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => undef,
            SelectedValue  => 'Object1::AttributeA',
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 0,
            DisabledBranch => undef,
            Max            => 10,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="Object1">Object1</option>
  <option value="Object1::AttributeA" selected="selected">Objec[...]</option>
  <option value="Object1::AttributeA::Value1">Objec[...]</option>
  <option value="Object1::AttributeA::Value2">Objec[...]</option>
  <option value="Object1::AttributeB">Objec[...]</option>
  <option value="Object1::AttributeB::Value1">Objec[...]</option>
  <option value="Object1::AttributeB::Value2">Objec[...]</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    'Object1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeA', 'Objec[...]',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    'Object1::AttributeA::Value1', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeA::Value2', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeB', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeB::Value1', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    'Object1::AttributeB::Value2', 'Objec[...]',
                    $JSONFalse, $JSONFalse,
                    $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Max with ArrayHashRef',
        Definition => {
            Data => [
                {
                    Key      => '1',
                    Value    => 'Object1',
                    Selected => 0,
                },
                {
                    Key      => '2',
                    Value    => 'Object1::AttributeA',
                    Selected => 1,
                },
                {
                    Key      => '3',
                    Value    => 'Object1::AttributeA::Value1',
                    Selected => 0,
                },
                {
                    Key      => '4',
                    Value    => 'Object1::AttributeA::Value2',
                    Selected => 0,
                },
                {
                    Key      => '5',
                    Value    => 'Object1::AttributeB',
                    Selected => 0,
                },
                {
                    Key      => '6',
                    Value    => 'Object1::AttributeB::Value1',
                    Selected => 0,
                },
                {
                    Key      => '7',
                    Value    => 'Object1::AttributeB::Value2',
                    Selected => 0,
                },
            ],
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'Numeric',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => undef,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 0,
            DisabledBranch => undef,
            Max            => 10,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="1">Object1</option>
  <option value="2" selected="selected">Objec[...]</option>
  <option value="3">Objec[...]</option>
  <option value="4">Objec[...]</option>
  <option value="5">Objec[...]</option>
  <option value="6">Objec[...]</option>
  <option value="7">Objec[...]</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '2', 'Objec[...]',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    '3', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '4', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '5', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '6', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '7', 'Objec[...]',
                    $JSONFalse, $JSONFalse,
                    $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Max with HashRef and TreeView',
        Definition => {
            Data => {
                1 => 'Object1',
                2 => 'Object1::AttributeA',
                3 => 'Object1::AttributeA::Value1',
                4 => 'Object1::AttributeA::Value2',
                5 => 'Object1::AttributeB',
                6 => 'Object1::AttributeB::Value1',
                7 => 'Object1::AttributeB::Value2',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => 9,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="1">Object1</option>
  <option value="2" selected="selected">&nbsp;&nbsp;Attr[...]</option>
  <option value="3">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="4">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="5">&nbsp;&nbsp;Attr[...]</option>
  <option value="6">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="7">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select> <a href="#" title="Baumauswahl anzeigen" class="ShowTreeSelection"><span>Baumauswahl anzeigen</span><i class="fa fa-sitemap"></i></a>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '2', '&nbsp;&nbsp;Attr[...]',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    '3', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '4', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '5', '&nbsp;&nbsp;Attr[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '6', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '7', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONFalse, $JSONFalse,
                    $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'Max with HashRef and TreeView and HTMLQuote',
        Definition => {
            Data => {
                1 => 'Object1<test1>',
                2 => 'Object1<test1>::AttributeA<test2>',
                3 => 'Object1<test1>::AttributeA<test2>::Value1<test3>',
                4 => 'Object1<test1>::AttributeA<test2>::Value2<test3>',
                5 => 'Object1<test1>::AttributeB<test2>',
                6 => 'Object1<test1>::AttributeB<test2>::Value1<test3>',
                7 => 'Object1<test1>::AttributeB<test2>::Value2<test3>',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'Number',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => 15,
            HTMLQuote      => 1,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="1">Object1&lt;test1&gt;</option>
  <option value="2" selected="selected">&nbsp;&nbsp;AttributeA[...]</option>
  <option value="3">&nbsp;&nbsp;&nbsp;&nbsp;Value1&lt;test3&gt;</option>
  <option value="4">&nbsp;&nbsp;&nbsp;&nbsp;Value2&lt;test3&gt;</option>
  <option value="5">&nbsp;&nbsp;AttributeB[...]</option>
  <option value="6">&nbsp;&nbsp;&nbsp;&nbsp;Value1&lt;test3&gt;</option>
  <option value="7">&nbsp;&nbsp;&nbsp;&nbsp;Value2&lt;test3&gt;</option>
</select> <a href="#" title="Baumauswahl anzeigen" class="ShowTreeSelection"><span>Baumauswahl anzeigen</span><i class="fa fa-sitemap"></i></a>',
        Success     => 1,
        ExecuteJSON => 1,

        # BuilsSelectionAJAX sets HTMLQuoting to 0
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1<test1>',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '2', '&nbsp;&nbsp;AttributeA[...]',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    '3', '&nbsp;&nbsp;&nbsp;&nbsp;Value1<test3>',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '4', '&nbsp;&nbsp;&nbsp;&nbsp;Value2<test3>',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '5', '&nbsp;&nbsp;AttributeB[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '6', '&nbsp;&nbsp;&nbsp;&nbsp;Value1<test3>',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '7', '&nbsp;&nbsp;&nbsp;&nbsp;Value2<test3>',
                    $JSONFalse, $JSONFalse,
                    $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'ArrayHashRef with delete filter and disabled possible none',
        Definition => {
            Data => [
                {
                    Key   => 'DeleteFilter',
                    Value => 'DELETE',
                },
                {
                    Key      => '-',
                    Value    => '-',
                    Disabled => 1,
                },
                {
                    Key      => '1',
                    Value    => 'Object1',
                    Selected => 0,
                },
                {
                    Key      => '2',
                    Value    => 'Object1::AttributeA',
                    Selected => 1,
                },
                {
                    Key      => '3',
                    Value    => 'Object1::AttributeA::Value1',
                    Selected => 0,
                },
                {
                    Key      => '4',
                    Value    => 'Object1::AttributeA::Value2',
                    Selected => 0,
                },
                {
                    Key      => '5',
                    Value    => 'Object1::AttributeB',
                    Selected => 0,
                },
                {
                    Key      => '6',
                    Value    => 'Object1::AttributeB::Value1',
                    Selected => 0,
                },
                {
                    Key      => '7',
                    Value    => 'Object1::AttributeB::Value2',
                    Selected => 0,
                },
            ],
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'Numeric',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => undef,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 0,
            DisabledBranch => undef,
            Max            => 10,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="DeleteFilter">DELETE</option>
  <option value="-" disabled="disabled">-</option>
  <option value="1">Object1</option>
  <option value="2" selected="selected">Objec[...]</option>
  <option value="3">Objec[...]</option>
  <option value="4">Objec[...]</option>
  <option value="5">Objec[...]</option>
  <option value="6">Objec[...]</option>
  <option value="7">Objec[...]</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    'DeleteFilter', 'DELETE',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', '-',
                    $JSONFalse, $JSONFalse, $JSONTrue,
                ],
                [
                    '1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '2', 'Objec[...]',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    '3', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '4', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '5', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '6', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '7', 'Objec[...]',
                    $JSONFalse, $JSONFalse,
                    $JSONFalse,
                ],
            ],
        },
    },
    {
        Name       => 'ArrayHashRef with delete filter and active possible none',
        Definition => {
            Data => [
                {
                    Key   => 'DeleteFilter',
                    Value => 'DELETE',
                },
                {
                    Key      => '-',
                    Value    => '-',
                    Disabled => 0,
                },
                {
                    Key      => '1',
                    Value    => 'Object1',
                    Selected => 0,
                },
                {
                    Key      => '2',
                    Value    => 'Object1::AttributeA',
                    Selected => 1,
                },
                {
                    Key      => '3',
                    Value    => 'Object1::AttributeA::Value1',
                    Selected => 0,
                },
                {
                    Key      => '4',
                    Value    => 'Object1::AttributeA::Value2',
                    Selected => 0,
                },
                {
                    Key      => '5',
                    Value    => 'Object1::AttributeB',
                    Selected => 0,
                },
                {
                    Key      => '6',
                    Value    => 'Object1::AttributeB::Value1',
                    Selected => 0,
                },
                {
                    Key      => '7',
                    Value    => 'Object1::AttributeB::Value2',
                    Selected => 0,
                },
            ],
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'Numeric',
            Multiple       => 0,
            AutoComplete   => undef,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => undef,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 0,
            DisabledBranch => undef,
            Max            => 10,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select id="Select1ID" name="Select1">
  <option value="DeleteFilter">DELETE</option>
  <option value="-">-</option>
  <option value="1">Object1</option>
  <option value="2" selected="selected">Objec[...]</option>
  <option value="3">Objec[...]</option>
  <option value="4">Objec[...]</option>
  <option value="5">Objec[...]</option>
  <option value="6">Objec[...]</option>
  <option value="7">Objec[...]</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    'DeleteFilter', 'DELETE',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '-', '-',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '1', 'Object1',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '2', 'Objec[...]',
                    $JSONTrue, $JSONTrue, $JSONFalse,
                ],
                [
                    '3', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '4', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '5', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '6', 'Objec[...]',
                    $JSONFalse, $JSONFalse, $JSONFalse,
                ],
                [
                    '7', 'Objec[...]',
                    $JSONFalse, $JSONFalse,
                    $JSONFalse,
                ],
            ],
        },
    },
);

for my $Test (@Tests) {

    # made a copy of the original data since it might be changed by LayoutObject during the test
    my %OriginalData;
    my @OriginalData;
    if ( ref $Test->{Definition}->{Data} eq 'HASH' ) {
        %OriginalData = %{ $Test->{Definition}->{Data} };
    }
    elsif ( ref $Test->{Definition}->{Data} eq 'ARRAY' ) {
        @OriginalData = @{ $Test->{Definition}->{Data} };
    }

    # call BuildSelection
    my $HTML = $LayoutObject->BuildSelection( %{ $Test->{Definition} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            $HTML,
            $Test->{Response},
            "BuildSelection() for test - $Test->{Name}: result on success match expected value",
        );
    }
    else {
        $Self->Is(
            $HTML,
            undef,
            "BuildSelection() for test - $Test->{Name}: result on failure should be undef",
        );
    }

    # restore original data
    if ( ref $Test->{Definition}->{Data} eq 'HASH' ) {
        $Test->{Definition}->{Data} = {%OriginalData};
    }
    elsif ( ref $Test->{Definition}->{Data} eq 'ARRAY' ) {
        $Test->{Definition}->{Data} = [@OriginalData];
    }

    if ( $Test->{ExecuteJSON} ) {

        # call BuildSelectionJSON
        my $JSON = $LayoutObject->BuildSelectionJSON(
            [
                $Test->{Definition},
            ],
        );

        # JSON ecode the expected data for easy compare
        my $JSONResponse = $JSONObject->Encode(
            Data => $Test->{JSONResponse},
        );

        if ( $Test->{Success} ) {
            $Self->Is(
                $JSON,
                $JSONResponse,
                "BuildSelectionJSON() for test - $Test->{Name}: result on success match expected value",
            );
        }
        else {
            $Self->Is(
                $JSON,
                undef,
                "BuildSelectionJSON() for test - $Test->{Name}: result on failure should be undef",
            );
        }

        # restore original data
        if ( ref $Test->{Definition}->{Data} eq 'HASH' ) {
            $Test->{Definition}->{Data} = {%OriginalData};
        }
        elsif ( ref $Test->{Definition}->{Data} eq 'ARRAY' ) {
            $Test->{Definition}->{Data} = [@OriginalData];
        }
    }
}

1;
