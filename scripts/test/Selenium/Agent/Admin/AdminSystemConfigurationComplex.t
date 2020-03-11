# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) input',
            },
            {
                Write => 'One',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) input',
            },
            {
                Write => 'Two',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) select',
            },
            {
                # select day (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoADate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoADate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoADate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(3)').val(\"2016\")",
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) select',
            },
            {
                # select day (15)
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoADate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12)
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoADate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2017)
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoADate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(3)').val(\"2017\")",
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
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
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
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
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                # wait until select is initialized
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) select',
            },
            {
                # Select Kernel::System::Log::File
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name="ExampleAoASelect"] .Setting > '
                        . '.Array > .ArrayItem:nth-of-type(4) .ArrayItem:nth-of-type(1) select',
                    Value => 'option-1',
                },
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddArrayItem',
            },
            {
                # wait until select is initialized, it already has default value
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .ArrayItem:nth-of-type(3) select',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) input',
            },
            {
                # Key
                Write => '3th',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) .AddKey',
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
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(4) .AddHashKey',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '4th',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                # Value
                Write => '4',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) > .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
                'Three' => '3',
                'Four'  => '4',
            },
            {
                '3th' => '3',
                '4th' => '4',
            },
        ],
    },
    {
        Name     => 'ExampleAoHDate',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) input',
            },
            {
                # Key
                Write => '3th',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) select',
            },
            {
                # select day (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoHDate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) "
                    . "select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoHDate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) "
                    . "select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoHDate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) "
                    . "select:nth-of-type(3)').val(\"2016\")",
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddHashKey',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '4th',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) select',
            },
            {
                # select day (15)
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoHDate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) "
                    . "select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12)
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoHDate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) "
                    . "select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2017)
                JS => "\$('.WidgetSimple[data-name=\"ExampleAoHDate\"] "
                    . ".Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) "
                    . "select:nth-of-type(3)').val(\"2017\")",
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) input',
            },
            {
                # Key
                Write => '3th',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) .AddKey',
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
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddHashKey',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '4th',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) input',
            },
            {
                # Key
                Write => '3th',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                # wait until select is initialized
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) select',
            },
            {
                # Select option-1.
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name="ExampleAoHSelect"] .Setting > '
                        . '.Array > .ArrayItem:nth-of-type(4) .HashItem:nth-of-type(1) select',
                    Value => 'option-1',
                },
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .AddHashKey',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '4th',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Name     => 'ExampleAoHTextarea',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Array > .AddArrayItem',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(1) input',
            },
            {
                # Write key - all keys except 'Text' should be input.
                Write => 'AnyKey',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent input',
            },
            {
                # Value
                Clear => 1,
            },
            {
                # Value
                Write => 'value',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) .AddHashKey',
            },
            {
                Select => '.Setting > .Array > .ArrayItem:nth-of-type(2) .HashItem:nth-of-type(2) input',
            },
            {
                # Write key - Text key should be textarea.
                Write => 'Text',
            },
            {
                JqueryClick => '.Setting > .Array > .ArrayItem:nth-of-type(2) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select =>
                    '.Setting > .Array > .ArrayItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent textarea',
            },
            {
                # Value
                Clear => 1,
            },
            {
                # Value
                Write => 'value for textarea',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            {
                'ID'    => '1',
                'Text'  => 'Textarea content.',
                'Title' => 'Title'
            },
            {
                'AnyKey' => 'value',
                'Text'   => 'value for textarea',
            },
        ],
    },
    {
        Name     => 'ExampleHoA',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key
                Write => 'One',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) input',
            },
            {
                Write => '1st',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) input',
            },
            {
                Write => '2nd',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Name     => 'ExampleHoA2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEnable',
            },
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                # Delete second item.
                JqueryClick => '.Array .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                # Add new item to the array.
                JqueryClick => '.Array .AddArrayItem',
            },
            {
                Select => '.Array .ArrayItem:nth-of-type(2) input',
            },
            {
                Write => 'Value 3',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'ArrayItems' => [
                'Value 1',
                'Value 3',
            ],
            'String' => 'String value',
        },
    },
    {
        Name     => 'ExampleHoADate',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key
                Write => 'One',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) select',
            },
            {
                # select day (05)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoADate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoADate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoADate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) "
                    . "select:nth-of-type(3)').val(\"2016\")",
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) select',
            },
            {
                # select day (15)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoADate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoADate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2017)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoADate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) "
                    . "select:nth-of-type(3)').val(\"2017\")",
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key
                Write => 'One',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
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
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) input',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key
                Write => 'One',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                # wait until select is initialized
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) select',
            },
            {
                # Select Kernel::System::Log::File
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name="ExampleHoASelect"] .Setting > '
                        . '.Hash > .HashItem:nth-of-type(3) .ArrayItem:nth-of-type(1) select',
                    Value => 'option-1',
                },
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddArrayItem',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(3) input',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key #1
                Write => 'One',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) input',
            },
            {
                # Key #2
                Write => '1st',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent input',
            },
            {
                # Value
                Write => '1',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '2nd',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                # Value
                Write => '2',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key #1
                Write => 'One',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) input',
            },
            {
                # Key #2
                Write => '1st',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent select',
            },
            {
                # select day (05)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoHDate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent "
                    . "select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoHDate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent "
                    . "select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoHDate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent "
                    . "select:nth-of-type(3)').val(\"2016\")",
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '2nd',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                # wait to init Datepicker
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent select',
            },
            {
                # select day (15)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoHDate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent "
                    . "select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoHDate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent "
                    . "select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2017)
                JS => "\$('.WidgetSimple[data-name=\"ExampleHoHDate\"] "
                    . ".Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent "
                    . "select:nth-of-type(3)').val(\"2017\")",
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key #1
                Write => 'One',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) input',
            },
            {
                # Key #2
                Write => '1st',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .AddKey',
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
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '2nd',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                JqueryClick => '.Update',
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
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.Setting > .Hash > .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .Key',
            },
            {
                # Key #1
                Write => 'One',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) input',
            },
            {
                # Key #2
                Write => '1st',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .AddKey',
            },
            {
                # wait until select is initialized
                Select => '.Setting > .Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent select',
            },
            {
                # Select Kernel::System::Log::File
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name="ExampleHoHSelect"] .Setting > '
                        . '.Hash > .HashItem:nth-of-type(3) .HashItem:nth-of-type(1) .SettingContent select',
                    Value => 'option-1',
                },
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) > .RemoveButton',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .AddHashKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) input',
            },
            {
                # Key
                Write => '2nd',
            },
            {
                JqueryClick => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .AddKey',
            },
            {
                Select => '.Setting > .Hash > .HashItem:nth-of-type(2) .HashItem:nth-of-type(2) .SettingContent input',
            },
            {
                JqueryClick => '.Update',
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

        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments    => "AdminSystemConfigurationComplex.t deployment",
            UserID      => 1,
            Force       => 1,
            AllSettings => 1,
        );

        $Self->True(
            $DeploymentResult{Success},
            "Deployment successful.",
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminSystemConfiguration screen
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=SampleComplex;"
        );

        my $SelectedItem;
        my $AlertText;

        for my $Test (@Tests) {

            my $Prefix = ".WidgetSimple[data-name='$Test->{Name}']";

            $Selenium->execute_script(
                "\$(\"$Prefix\")[0].scrollIntoView(true);",
            );

            for my $Command ( @{ $Test->{Commands} } ) {
                my $CommandType = ( keys %{$Command} )[0];
                my $Value       = $Command->{$CommandType};

                if ( $CommandType eq 'Click' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );

                    # Give JS some time to do the stuff.
                    Time::HiRes::sleep(0.2);

                    $Selenium->execute_script(
                        '$("' . "$Prefix $Value" . '").click();'
                    );

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
                            Time       => 120,
                            JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                        );
                    }
                }
                elsif ( $CommandType eq 'JqueryClick' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->WaitForjQueryEventBound(
                        CSSSelector => "$Prefix $Value",
                    );

                    $Selenium->execute_script(
                        '$("' . "$Prefix $Value" . '").click();'
                    );

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
                            Time       => 120,
                            JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0',
                        );
                    }
                }
                elsif ( $CommandType eq 'Clear' ) {
                    $SelectedItem->clear();
                }
                elsif ( $CommandType eq 'Hover' ) {
                    my $SelectedItem = $Selenium->find_element( "$Prefix $Value", "css" );
                    $Selenium->mouse_move_to_location( element => $SelectedItem );

                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . "$Prefix $Value" . ':visible").length',
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
                        "$Test->{Name} - Check if element value is OK.",
                    );
                }
                elsif ( $CommandType eq 'ElementMissing' ) {

                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . "$Prefix $Value" . '").length == 0',
                    );
                }
                elsif ( $CommandType eq 'Select' ) {

                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . $Prefix
                            . '").hasClass("HasOverlay") == 0',
                    );

                    # JS needs more escapes.
                    my $JSValue = $Value;
                    $JSValue =~ s{\\}{\\\\}g;

                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . "$Prefix $JSValue" . '").length',
                    );

                    $SelectedItem = $Selenium->find_element( "$Prefix $Value", "css" );
                }
                elsif ( $CommandType eq 'JS' ) {

                    # Wait for any tasks to complete.
                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . $Prefix
                            . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->execute_script(
                        $Command->{JS},
                    );
                }
                elsif ( $CommandType eq 'InputFieldValueSet' ) {

                    # Wait for any tasks to complete.
                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . $Prefix
                            . '").hasClass("HasOverlay") == 0',
                    );

                    $Selenium->InputFieldValueSet(
                        Element => $Value->{Element},
                        Value   => $Value->{Value},
                    );
                }
                elsif ( $CommandType eq 'WaitForJS' ) {
                    $Selenium->WaitFor(
                        JavaScript => $Value,
                    );
                }
            }

            # Compare results.
            my %Setting = $SysConfigObject->SettingGet(
                Name => $Test->{Name},
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

        # Reset settings to Default.
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
