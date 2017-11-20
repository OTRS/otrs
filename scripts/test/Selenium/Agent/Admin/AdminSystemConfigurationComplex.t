# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

my @Tests = (
    {
        Name     => 'ExampleAoA',
        Index    => 1,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) input',
            },
            {
                Write => 'One',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) input',
            },
            {
                Write => 'Two',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            [
                '1',
                '2',
            ],
            [
                'One',
                'Two',
            ],
        ],
    },
    {
        Name     => 'ExampleAoADate',
        Index    => 2,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) select',
            },
            {
                # select day (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(2) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(2) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(2) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(3)').val(\"2016\")",
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) select',
            },
            {
                # select day (15)
                JS => "\$('.SettingsList li:nth-of-type(2) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12)
                JS => "\$('.SettingsList li:nth-of-type(2) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2017)
                JS => "\$('.SettingsList li:nth-of-type(2) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(3)').val(\"2017\")",
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            [
                '2017-01-02',
                '2017-01-03',
            ],
            [
                '2016-05-05',
                '2017-12-15',
            ],
        ],
    },
    {
        Name     => 'ExampleAoADirectory',
        Index    => 3,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) input',
            },
            {
                Clear => 1,
            },
            {
                Write => '/etc',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) input',
            },
            {
                Clear => 1,
            },
            {
                Write => '/var',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            [
                '/usr',
                '/home',
            ],
            [
                '/etc',
                '/var',
            ],
        ],
    },

    # TODO: Temporary disabled, check what's wrong
    {
        Name     => 'ExampleAoASelect',
        Index    => 4,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                # wait until select is initialized
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) select',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) "
                    . " select').val('option-1')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                # wait until select is initialized, it already has default value
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) select',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            [
                'option-1',
                'option-2',
            ],
            [
                'option-1',
                'option-2',
            ],
        ],
    },
    {
        Name     => 'ExampleAoH',
        Index    => 5,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) input',
            },
            {
                # Key
                Write => '3th',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) .SettingContent input',
            },
            {
                # Value
                Write => '3',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddHashKey',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '4th',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                # Value
                Write => '4',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            {
                'One' => '1',
                'Two' => '2',
            },
            {
                '3th' => '3',
                '4th' => '4',
            },
        ],
    },

    {
        Name     => 'ExampleAoHDate',
        Index    => 6,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) input',
            },
            {
                # Key
                Write => '3th',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) select',
            },
            {
                # select day (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(6) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) "
                    . "select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(6) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) "
                    . "select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(6) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) "
                    . "select:nth-of-type(3)').val(\"2016\")",
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddHashKey',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '4th',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) select',
            },
            {
                # select day (15)
                JS => "\$('.SettingsList li:nth-of-type(6) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) "
                    . "select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12)
                JS => "\$('.SettingsList li:nth-of-type(6) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) "
                    . "select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2017)
                JS => "\$('.SettingsList li:nth-of-type(6) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) "
                    . "select:nth-of-type(3)').val(\"2017\")",
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            {
                'One' => '2017-01-01',
                'Two' => '2017-01-02',
            },
            {
                '3th' => '2016-05-05',
                '4th' => '2017-12-15',
            },
        ],
    },
    {
        Name     => 'ExampleAoHDirectory',
        Index    => 7,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) input',
            },
            {
                # Key
                Write => '3th',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) .SettingContent input',
            },
            {
                # Value
                Clear => 1,
            },
            {
                # Value
                Write => '/var',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddHashKey',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '4th',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            {
                'One' => '/etc',
                'Two' => '/usr',
            },
            {
                '3th' => '/var',
                '4th' => '/etc',
            },
        ],
    },
    {
        Name     => 'ExampleAoHSelect',
        Index    => 8,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Click => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) input',
            },
            {
                # Key
                Write => '3th',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                # wait until select is initialized
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) select',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(8) .WidgetSimple "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) "
                    . " select').val('option-1')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddHashKey',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '4th',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                Click => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            {
                'One' => 'option-1',
                'Two' => 'option-2',
            },
            {
                '3th' => 'option-1',
                '4th' => 'option-2',
            },
        ],
    },
    {
        Name     => 'ExampleHoA',
        Index    => 9,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key
                Write => 'One',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) input',
            },
            {
                Write => '1st',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) input',
            },
            {
                Write => '2nd',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First' => [
                '1',
                '2',
            ],
            'One' => [
                '1st',
                '2nd',
            ],
        },
    },
    {
        Name     => 'ExampleHoADate',
        Index    => 10,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key
                Write => 'One',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) select',
            },
            {
                # select day (05)
                JS => "\$('.SettingsList li:nth-of-type(10) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05)
                JS => "\$('.SettingsList li:nth-of-type(10) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016)
                JS => "\$('.SettingsList li:nth-of-type(10) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(3)').val(\"2016\")",
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) select',
            },
            {
                # select day (15)
                JS => "\$('.SettingsList li:nth-of-type(10) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12)
                JS => "\$('.SettingsList li:nth-of-type(10) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2017)
                JS => "\$('.SettingsList li:nth-of-type(10) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(3)').val(\"2017\")",
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First' => [
                '2017-01-01',
                '2017-01-02',
            ],
            'One' => [
                '2016-05-05',
                '2017-12-15',
            ],
        },
    },
    {
        Name     => 'ExampleHoADirectory',
        Index    => 11,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key
                Write => 'One',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) input',
            },
            {
                Clear => 1,
            },
            {
                Write => '/var',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) input',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First' => [
                '/etc',
                '/usr',
            ],
            'One' => [
                '/var',
                '/etc',
            ],
        },
    },
    {
        Name     => 'ExampleHoASelect',
        Index    => 12,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key
                Write => 'One',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                # wait until select is initialized
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) select',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(12) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) "
                    . " select').val('option-1')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) input',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First' => [
                'option-1',
                'option-2',
            ],
            'One' => [
                'option-1',
                'option-2',
            ],
        },
    },
    {
        Name     => 'ExampleHoH',
        Index    => 13,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key #1
                Write => 'One',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) input',
            },
            {
                # Key #2
                Write => '1st',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent input',
            },
            {
                # Value
                Write => '1',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '2nd',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                # Value
                Write => '2',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First' => {
                'One' => '1',
                'Two' => '2',
            },
            'One' => {
                '1st' => '1',
                '2nd' => '2',
            },
        },
    },
    {
        Name     => 'ExampleHoHDate',
        Index    => 14,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key #1
                Write => 'One',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) input',
            },
            {
                # Key #2
                Write => '1st',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent select',
            },
            {
                # select day (05)
                JS => "\$('.SettingsList li:nth-of-type(14) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent "
                    . "select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05)
                JS => "\$('.SettingsList li:nth-of-type(14) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent "
                    . "select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016)
                JS => "\$('.SettingsList li:nth-of-type(14) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent "
                    . "select:nth-of-type(3)').val(\"2016\")",
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '2nd',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent select',
            },
            {
                # select day (15)
                JS => "\$('.SettingsList li:nth-of-type(14) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent "
                    . "select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12)
                JS => "\$('.SettingsList li:nth-of-type(14) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent "
                    . "select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2017)
                JS => "\$('.SettingsList li:nth-of-type(14) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent "
                    . "select:nth-of-type(3)').val(\"2017\")",
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First' => {
                'One' => '2017-01-01',
                'Two' => '2017-01-02',
            },
            'One' => {
                '1st' => '2016-05-05',
                '2nd' => '2017-12-15',
            },
        },
    },
    {
        Name     => 'ExampleHoHDirectory',
        Index    => 15,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key #1
                Write => 'One',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) input',
            },
            {
                # Key #2
                Write => '1st',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent input',
            },
            {
                Clear => 1,
            },
            {
                # Value
                Write => '/var',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '2nd',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First' => {
                'One' => '/etc',
                'Two' => '/usr',
            },
            'One' => {
                '1st' => '/var',
                '2nd' => '/etc',
            },
        },
    },
    {
        Name     => 'ExampleHoHSelect',
        Index    => 16,
        Commands => [
            {
                Scroll => 1,
            },
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key #1
                Write => 'One',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) input',
            },
            {
                # Key #2
                Write => '1st',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                # wait until select is initialized
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent select',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(16) .WidgetSimple "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent "
                    . " select').val('option-1')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '2nd',
            },
            {
                Click => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First' => {
                'One' => 'option-1',
                'Two' => 'option-2',
            },
            'One' => {
                '1st' => 'option-1',
                '2nd' => 'option-2',
            },
        },
    },
);

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # Load sample XML file.
        my $Directory = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . '/scripts/test/sample/SysConfig/XML/AdminSystemConfiguration';

        my $XMLLoaded = $SysConfigObject->ConfigurationXML2DB(
            UserID    => 1,
            Directory => $Directory,
            Force     => 1,
            CleanUp   => 0,
        );

        $Self->True(
            $XMLLoaded,
            "ExampleComplex XML loaded.",
        );

        my $DeploymentSuccess = $SysConfigObject->ConfigurationDeploy(
            Comments    => "test deployment",
            UserID      => 1,
            Force       => 1,
            AllSettings => 1,
        );

        $Self->True(
            $DeploymentSuccess,
            "Deployment successful.",
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminSystemConfiguration screen
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=SampleComplex;"
        );

        my $SelectedItem;
        my $AlertText;

        for my $Test (@Tests) {

            for my $Command ( @{ $Test->{Commands} } ) {
                my $CommandType = ( keys %{$Command} )[0];
                my $Value       = $Command->{$CommandType};

                my $Prefix = ".SettingsList li:nth-of-type($Test->{Index}) .WidgetSimple";

                if ( $CommandType eq 'Click' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->find_element( "$Prefix $Value", "css" )->click();
                    if ($AlertText) {
                        $Selenium->WaitFor(
                            AlertPresent => 1,
                        );

                        # Verify alert message.
                        $Self->Is(
                            $AlertText,
                            $Selenium->get_alert_text(),
                            "$Test->{Name} - Check alert text - $AlertText",
                        );

                        # Accept alert.
                        $Selenium->accept_alert();

                        # Reset alert text.
                        $AlertText = '';
                    }
                    else {
                        $Selenium->WaitFor(
                            JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                        );
                    }
                }
                elsif ( $CommandType eq 'Scroll' ) {
                    $Selenium->execute_script(
                        "\$('$Prefix')[0].scrollIntoView(true);",
                    );
                }
                elsif ( $CommandType eq 'Clear' ) {
                    $SelectedItem->clear();
                }
                elsif ( $CommandType eq 'Hover' ) {
                    my $SelectedItem = $Selenium->find_element( "$Prefix $Value", "css" );
                    $Selenium->mouse_move_to_location( element => $SelectedItem );

                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . ':visible").length',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );
                }
                elsif ( $CommandType eq 'ExpectAlert' ) {
                    $AlertText = $Value;
                }
                elsif ( $CommandType eq 'Write' ) {

                    $SelectedItem->send_keys($Value);
                }
                elsif ( $CommandType eq 'ElementValue' ) {

                    $Self->Is(
                        $SelectedItem->get_value(),
                        $Value,
                        "Check if element value is OK.",
                    );
                }
                elsif ( $CommandType eq 'ElementMissing' ) {

                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length == 0',
                    );
                }
                elsif ( $CommandType eq 'Select' ) {

                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length',
                    );

                    $SelectedItem = $Selenium->find_element( "$Prefix $Value", "css" );
                }
                elsif ( $CommandType eq 'JS' ) {

                    # wait for any tasks to complete

                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->execute_script(
                        $Command->{JS},
                    );
                    sleep 1;
                }
            }

            # Compare result
            my %Setting = $SysConfigObject->SettingGet(
                Name      => $Test->{Name},
                Translate => 0,
            );

            if ( $Test->{ExpectedResult} ) {
                $Self->IsDeeply(
                    $Setting{EffectiveValue},
                    $Test->{ExpectedResult},
                    "Test Effective value deeply for $Test->{Name}",
                );
            }
        }

        # Enable this block if you want to test it multiple times.
        my @TestNames;

        # Reset settings to Default
        for my $Test (@Tests) {
            if ( !grep { $_ eq $Test->{Name} } @TestNames ) {
                my %Setting = $SysConfigObject->SettingGet(
                    Name      => $Test->{Name},
                    Translate => 0,
                );

                my $Guid = $SysConfigObject->SettingLock(
                    UserID    => 1,
                    DefaultID => $Setting{DefaultID},
                    Force     => 1,
                );
                $Self->True(
                    $Guid,
                    "Lock setting before reset($Test->{Name}).",
                );

                my $Success = $SysConfigObject->SettingReset(
                    Name              => $Test->{Name},
                    ExclusiveLockGUID => $Guid,
                    UserID            => 1,
                );
                $Self->True(
                    $Success,
                    "Setting $Test->{Name} reset to the default value.",
                );

                $SysConfigObject->SettingUnlock(
                    DefaultID => $Setting{DefaultID},
                );

                push @TestNames, $Test->{Name};
            }
        }
    }
);

1;
