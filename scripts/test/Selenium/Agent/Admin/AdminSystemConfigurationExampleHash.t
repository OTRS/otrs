# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

my @Tests = (
    {
        Name     => 'ExampleHash',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(2) .RemoveButton',
            },

            # Check if remove button is hidden(min items)
            {
                ElementMissing => '.RemoveButton:visible',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'DynamicField_Address',    # check if keys with "_" works
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => '0',                       # check if value can be 0
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                ElementValue => '0',
            },
        ],
        ExpectedResult => {
            'First name'           => 'John',
            'DynamicField_Address' => '0',
        },
    },
    {
        Name     => 'ExampleHashCheckbox1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                # Normal click, it's not jQuery object.
                Click => '.HashItem:nth-of-type(1) label',
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'label',
            }
        ],
        ExpectedResult => {
            'Name'     => 'John',
            'Checkbox' => '0',
        },
    },
    {
        Name     => 'ExampleHashCheckbox2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'John',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                # Normal click, it's not jQuery object.
                Click => '.HashItem:nth-of-type(2) label',
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'label',
            },
        ],
        ExpectedResult => {
            'String' => 'John',
            'AnyKey' => '0',
        },
    },
    {
        Name     => 'ExampleHashDate1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                # select day (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDate1\"] "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDate1\"] "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDate1\"] "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First name' => 'John',
            'Date'       => '2016-05-05',
        },
    },
    {
        Name     => 'ExampleHashDate2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'John',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                # Wait to initialize DatePicker
                Select => '.HashItem:nth-of-type(2) select:nth-of-type(2)',
            },
            {
                # select day (25) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDate2\"] "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(2)').val(\"25\")",
            },
            {
                # select month (11) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDate2\"] "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(1)').val(\"11\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDate2\"] "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'select',
            }
        ],
        ExpectedResult => {
            'String' => 'John',
            'AnyKey' => '2016-11-25',
        },
    },
    {
        Name     => 'ExampleHashDateTime1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                # Wait to initialize DatePicker
                Select => '.HashItem:nth-of-type(1) select:nth-of-type(2)',
            },
            {
                # select day (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDateTime1\"] "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDateTime1\"] "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDateTime1\"] "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                # select hour (2) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDateTime1\"] "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(4)').val(\"2\")",
            },
            {
                # select minute (2) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDateTime1\"] "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(5)').val(\"2\")",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => {
            'First name' => 'John',
            'DateTime'   => '2016-05-05 02:02:00',
        },
    },
    {
        Name     => 'ExampleHashDateTime2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'John',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                # Wait to initialize DatePicker
                Select => '.HashItem:nth-of-type(2) select:nth-of-type(2)',
            },
            {
                # select day (25) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDateTime2\"] "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(2)').val(\"25\")",
            },
            {
                # select month (11) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDateTime2\"] "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(1)').val(\"11\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDateTime2\"] "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                # select hour (2) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDateTime2\"] "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(4)').val(\"2\")",
            },
            {
                # select minute (2) for first item
                JS => "\$('.WidgetSimple[data-name=\"ExampleHashDateTime2\"] "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(5)').val(\"2\")",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => {
            'String' => 'John',
            'AnyKey' => '2016-11-25 02:02:00',
        },
    },
    {
        Name     => 'ExampleHashDirectory1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => '/usr'
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'Name' => 'John',
            'File' => '/usr',
        },
    },
    {
        Name     => 'ExampleHashDirectory1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Write => '/usr3#',
            },
            {
                Hover => '.Setting',
            },
            {
                ExpectAlert => 'Setting value is not valid!',
            },
            {
                JqueryClick => '.Update',
            },
            {
                JqueryClick => '.Cancel',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'Name' => 'John',
            'File' => '/usr',
        },
    },
    {
        Name     => 'ExampleHashDirectory2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Clear => 1,
            },
            {
                Write => '/usr',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Doe'
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'String' => 'Doe',
            'Name'   => '/usr',
        },
    },
    {
        Name     => 'ExampleHashEntity1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                # Select 2 low
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleHashEntity1\"] select',
                    Value   => '2 low',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleHashEntity1\"] "
                    . "select').val() === '2 low'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First name' => 'John',
            'Entity'     => '2 low',
        },
    },
    {
        Name     => 'ExampleHashEntity2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'John',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select 2 low
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleHashEntity2\"] select',
                    Value   => '2 low',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleHashEntity2\"] "
                    . "select').val() === '2 low'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'String' => 'John',
            'AnyKey' => '2 low',
        },
    },
    {
        Name     => 'ExampleHashFile1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => '/etc/localtime'
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'Name' => 'John',
            'File' => '/etc/localtime',
        },
    },
    {
        Name     => 'ExampleHashFile1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Write => '/usr3#',
            },
            {
                Hover => '.Setting',
            },
            {
                ExpectAlert => 'Setting value is not valid!',
            },
            {
                JqueryClick => '.Update',
            },
            {
                JqueryClick => '.Cancel',
            },
        ],
        ExpectedResult => {
            'Name' => 'John',
            'File' => '/etc/localtime',
        },
    },
    {
        Name     => 'ExampleHashFile2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Clear => 1,
            },
            {
                Write => '/etc/localtime',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Doe'
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'String' => 'Doe',
            'Name'   => '/etc/localtime',
        },
    },
    {
        Name     => 'ExampleHashPassword1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Password 1',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First name' => 'John',
            'Password'   => 'Password 1',
        },
    },
    {
        Name     => 'ExampleHashPassword2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'John',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Password 1'
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'String' => 'John',
            'AnyKey' => 'Password 1',
        },
    },
    {
        Name     => 'ExampleHashPerlModule1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select Kernel::System::Log::File
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleHashPerlModule1\"] select',
                    Value   => 'Kernel::System::Log::File',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleHashPerlModule1\"] "
                    . "select').val() === 'Kernel::System::Log::File'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First name' => 'John',
            'PerlModule' => 'Kernel::System::Log::File',
        },
    },
    {
        Name     => 'ExampleHashPerlModule2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'John',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select 2 low
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleHashPerlModule2\"] select',
                    Value   => 'Kernel::System::Log::File',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleHashPerlModule2\"] "
                    . "select').val() === 'Kernel::System::Log::File'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'String' => 'John',
            'AnyKey' => 'Kernel::System::Log::File',
        },
    },
    {
        Name     => 'ExampleHashSelect1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select female.
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleHashSelect1\"] select',
                    Value   => 'female',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleHashSelect1\"] "
                    . "select').val() === 'female'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'select',
            },
            {
                ElementValue => 'female',
            },
        ],
        ExpectedResult => {
            'First name' => 'John',
            'Select'     => 'female',
        },
    },
    {
        Name     => 'ExampleHashSelect2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                # Normal click, it's not jQuery object.
                Click => '.Hash label',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => 'select',
            },
            {
                # Select male.
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleHashSelect2\"] select',
                    Value   => 'male',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleHashSelect2\"] "
                    . "select').val() === 'male'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'select',
            },
            {
                ElementValue => 'male',
            },
        ],
        ExpectedResult => {
            'AnyKey'    => 'male',
            'Available' => '0',
        },
    },
    {
        Name     => 'ExampleHashTextarea1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                Select => 'textarea',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Item 1',
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First name' => 'John',
            'Textarea'   => 'Item 1',
        },
    },
    {
        Name     => 'ExampleHashTextarea2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Item',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => 'textarea',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Value 1'
            },
            {
                Select => '.Setting .SettingContent input:nth-of-type(1)',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Value 2'
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'Item'   => 'Value 1',
            'String' => 'Value 2',
        },
    },
    {
        Name     => 'ExampleHashTimeZone1',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'Jane',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select UTC
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleHashTimeZone1\"] select',
                    Value   => 'UTC',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleHashTimeZone1\"] "
                    . "select').val() === 'UTC'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First name' => 'Jane',
            'TimeZone'   => 'UTC',
        },
    },
    {
        Name     => 'ExampleHashTimeZone2',
        Commands => [
            {
                Hover => '.Content',
            },
            {
                JqueryClick => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                JqueryClick => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                # make sure that item is deleted
                ElementMissing => '.HashItem:nth-of-type(2)',
            },
            {
                Select => '.HashItem:nth-of-type(1) .Content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'John',
            },
            {
                JqueryClick => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                JqueryClick => '.AddKey',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select Europe/Berlin
                InputFieldValueSet => {
                    Element => '.WidgetSimple[data-name=\"ExampleHashTimeZone2\"] select',
                    Value   => 'Europe/Berlin',
                },
            },
            {
                # Wait until option is selected.
                WaitForJS => "return typeof(\$) === 'function' "
                    . "&& \$('.WidgetSimple[data-name=\"ExampleHashTimeZone2\"] "
                    . "select').val() === 'Europe/Berlin'",
            },
            {
                Hover => '.Setting',
            },
            {
                JqueryClick => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'String' => 'John',
            'AnyKey' => 'Europe/Berlin',
        },
    },
);

$Selenium->RunTest(
    sub {

        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # Rebuild system configuration.
        my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
        my $ExitCode      = $CommandObject->Execute('--cleanup');

        # Create test user and login.
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
            "Example XML loaded.",
        );

        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments    => "AdminSystemConfigurationHash.t deployment",
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

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfiguration");

        my $OTRSBusinessIsInstalled = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled();
        my $OBTeaserFound           = index( $Selenium->get_page_source(), 'supports versioning, rollback and' ) > -1;
        if ( !$OTRSBusinessIsInstalled ) {
            $Self->True(
                $OBTeaserFound,
                "OTRSBusiness teaser found on page",
            );
        }
        else {
            $Self->False(
                $OBTeaserFound,
                "OTRSBusiness teaser not found on page",
            );
        }

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Sample;");

        my $SelectedItem;
        my $AlertText;

        for my $Test (@Tests) {

            my $Prefix = ".WidgetSimple[data-name='$Test->{Name}']";

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$(\"$Prefix\").length;"
            );

            $Selenium->execute_script(
                "\$(\"$Prefix\")[0].scrollIntoView(true);",
            );

            for my $Command ( @{ $Test->{Commands} } ) {
                my $CommandType = ( keys %{$Command} )[0];
                my $Value       = $Command->{$CommandType};

                if ( $CommandType eq 'Click' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length;',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0;',
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
                            JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0;',
                        );
                    }
                }
                elsif ( $CommandType eq 'JqueryClick' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length;',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0;',
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
                            JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0;',
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
                        Time       => 120,
                        JavaScript => 'return typeof($) === "function" && $("'
                            . "$Prefix $Value"
                            . ':visible").length;',
                    );
                    $Selenium->WaitFor(
                        Time       => 120,
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay") == 0;',
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
                        Time       => 120,
                        JavaScript => 'return typeof($) === "function" && $("' . "$Prefix $Value" . '").length == 0;',
                    );
                }
                elsif ( $CommandType eq 'Select' ) {

                    $Selenium->WaitFor(
                        Time       => 120,
                        JavaScript => 'return typeof($) === "function" && $("' . $Prefix
                            . '").hasClass("HasOverlay") == 0;',
                    );

                    # JS needs more escapes.
                    my $JSValue = $Value;
                    $JSValue =~ s{\\}{\\\\}g;

                    $Selenium->WaitFor(
                        Time       => 120,
                        JavaScript => 'return typeof($) === "function" && $("' . "$Prefix $JSValue" . '").length;',
                    );

                    $SelectedItem = $Selenium->find_element( "$Prefix $Value", "css" );
                }
                elsif ( $CommandType eq 'JS' ) {

                    # Wait for any tasks to complete.
                    $Selenium->WaitFor(
                        Time       => 120,
                        JavaScript => 'return typeof($) === "function" && $("' . $Prefix
                            . '").hasClass("HasOverlay") == 0;',
                    );

                    $Selenium->execute_script(
                        $Command->{JS},
                    );
                }
                elsif ( $CommandType eq 'InputFieldValueSet' ) {

                    # Wait for any tasks to complete.
                    $Selenium->WaitFor(
                        JavaScript => 'return typeof($) === "function" && $("' . $Prefix
                            . '").hasClass("HasOverlay") == 0;',
                    );

                    $Selenium->InputFieldValueSet(
                        Element => $Value->{Element},
                        Value   => $Value->{Value},
                    );
                }
                elsif ( $CommandType eq 'WaitForJS' ) {
                    $Selenium->WaitFor(
                        Time       => 120,
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

        # Reload page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Sample;");

        # Check if there is notification.
        $Self->True(
            index( $Selenium->get_page_source(), 'You have undeployed settings, would you like to deploy them?' ) > -1,
            "Notification shown for undeployed settings."
        );

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#CloudService > i:visible").length;',
        );

        $Selenium->execute_script("\$('#CloudService > i').trigger('click');");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#ConfigTree ul > li:first > ul > li:first:visible").length;',
        );

        # Check navigation for disabled nodes.
        my $NodeDisabled = $Selenium->execute_script(
            'return $("#ConfigTree ul > li:first > ul > li:first a").hasClass("jstree-disabled");',
        );

        $Self->True(
            $NodeDisabled,
            'Check if CloudService::Admin node is disabled.',
        );

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
