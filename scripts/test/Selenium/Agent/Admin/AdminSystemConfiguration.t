# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

my @Tests = (
    {
        Name     => 'ExampleArray',
        Index    => 1,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },

            # check if remove buttons are hidden
            {
                ElementMissing => '.RemoveButton:visible',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                ElementValue => 'Default value',
            },
            {
                Clear => 1,
            },
            {
                Write => 'New item',
            },
            {
                Click => '.AddArrayItem',
            },

            # check if add button is hidden
            {
                ElementMissing => '.AddArrayItem:visible',
            },
            {
                Click => '.ArrayItem:nth-of-type(3) .RemoveButton',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            'Item 1',
            'New item',
        ],
    },
    {
        Name     => 'ExampleArrayCheckbox',
        Index    => 2,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(1) input:nth-child(2)',
            },
            {
                ElementValue => 1,
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) label',    # make sure that label is working as well
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            '1',
            '0',
        ],
    },
    {
        Name     => 'ExampleArrayDate',
        Index    => 3,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },

            # check default day
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(2)',
            },
            {
                ElementValue => '1',
            },

            # check default month
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(1)',
            },
            {
                ElementValue => '1',
            },

            # check default year
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(3)',
            },
            {
                ElementValue => '2017',
            },
            {
                # select day (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-child(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-child(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-child(3)').val(\"2016\")",
            },
            {
                Click => '.AddArrayItem',
            },
            {
                # Wait to load item
                Select => '.ArrayItem:nth-of-type(2) select:nth-child(1)',
            },
            {
                # select day (15) for second item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-child(2)').val(\"15\")",
            },
            {
                # select month (12) for second item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-child(1)').val(\"12\")",
            },
            {
                # select year (2016) for second item
                JS => "\$('.SettingsList li:nth-of-type(3) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-child(3)').val(\"2016\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            '2016-05-05',
            '2016-12-15',
        ],
    },
    {
        Name     => 'ExampleArrayDateTime',
        Index    => 4,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },

            # check default day
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(2)'
            },
            {
                ElementValue => '1',
            },

            # check default month
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(1)',
            },
            {
                ElementValue => '1',
            },

            # check default year
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-child(3)',
            },
            {
                ElementValue => '2017',
            },

            # check default hour
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-of-type(4)',
            },
            {
                ElementValue => '1',
            },

            # check default year
            {
                Select => '.ArrayItem:nth-of-type(1) select:nth-of-type(5)',
            },
            {
                ElementValue => '45',
            },
            {
                # select day (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                # select hour (2) for first item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(4)').val(\"2\")",
            },
            {
                # select minute (2) for first item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(1) select:nth-of-type(5)').val(\"2\")",
            },
            {
                Click => '.AddArrayItem',
            },
            {
                # wait to init DatePicker
                Select => '.ArrayItem:nth-of-type(2) select:nth-of-type(2)',
            },
            {
                # select day (15) for second item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(2)').val(\"15\")",
            },
            {
                # select month (12) for second item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(1)').val(\"12\")",
            },
            {
                # select year (2016) for second item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(3)').val(\"2016\")",
            },
            {

                # select hour (16) for second item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(4)').val(\"16\")",
            },
            {
                # select minute (45) second item
                JS => "\$('.SettingsList li:nth-of-type(4) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select:nth-of-type(5)').val(\"45\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            '2016-05-05 02:02:00',
            '2016-12-15 16:45:00',
        ],
    },
    {
        Name     => 'ExampleArrayDirectory',
        Index    => 5,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                ElementValue => '/etc',
            },
            {
                Clear => 1,
            },
            {
                Write => '/usr',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            '/etc',
            '/usr',
        ],
    },
    {
        Name     => 'ExampleArrayEntity',
        Index    => 6,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => '3 normal',
            },
            {
                # Select Option-2
                JS => "\$('.SettingsList li:nth-of-type(6) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val(\"1 very low\")"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            '3 normal',
            '1 very low',
        ],
    },
    {
        Name     => 'ExampleArrayFile',
        Index    => 7,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                ElementValue => '/etc/hosts',
            },
            {
                Clear => 1,
            },
            {
                Write => '/etc/localtime',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            '/etc/hosts',
            '/etc/localtime',
        ],
    },

    # {
    #     Name     => 'ExampleArrayFile',
    #     Index    => 7,
    #     Commands => [
    #         {
    #             Hover => '.Content',
    #         },
    #         {
    #             Click => '.SettingEdit',
    #         },
    #         {
    #             Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
    #         },
    #         {
    #             Click => '.AddArrayItem',
    #         },
    #         {
    #             Select => '.ArrayItem:nth-of-type(2) input',
    #         },
    #         {
    #             Write => '/usrfake#',
    #         },
    #         {
    #             Hover => '.Setting',
    #         },
    #         {
    #             Click => '.Update',
    #         },
    #         {
    #             Alert => 'Setting value is not valid!',
    #         },
    #         {
    #             Click => '.Cancel',
    #         },
    #     ],
    #     ExpectedResult => [    # Error occured, nothing was changed
    #         '/etc/hosts',
    #         '/etc/localtime',
    #     ],
    # },
    {
        Name     => 'ExampleArrayPassword',
        Index    => 8,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(1) input',
            },
            {
                ElementValue => 'Secret',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Password 1',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Password 2',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => [
            'Password 1',
            'Password 2',
        ],
    },
    {
        Name     => 'ExampleArrayPerlModule',
        Index    => 9,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'Kernel::System::Log::SysLog',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(9) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val(\"Kernel::System::Log::File\")"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            'Kernel::System::Log::SysLog',
            'Kernel::System::Log::File',
        ],
    },
    {
        Name     => 'ExampleArraySelect',
        Index    => 10,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'option-2',
            },
            {
                JS => "\$('.SettingsList li:nth-of-type(10) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val(\"option-2\")"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            'option-1',
            'option-2',
        ],
    },
    {
        Name     => 'ExampleArrayTextarea',
        Index    => 11,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) textarea',
            },
            {
                ElementValue => 'Textarea content',
            },
            {
                Clear => 1,
            },
            {
                Write => 'test content',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'textarea',
            },
        ],
        ExpectedResult => [
            'Content 1',
            'test content',
        ],
    },
    {
        Name     => 'ExampleArrayTimeZone',
        Index    => 12,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.ArrayItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                Select => '.ArrayItem:nth-of-type(2) select',
            },
            {
                ElementValue => 'UTC',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(12) .WidgetSimple "
                    . ".ArrayItem:nth-of-type(2) select').val('Europe/Berlin')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => [
            'UTC',
            'Europe/Berlin',
        ],
    },
    {
        Name     => 'ExampleCheckbox1',
        Index    => 13,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => 'label',    # make sure that label is working as well
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'label',
            },
        ],
        ExpectedResult => 1,
    },
    {
        Name     => 'ExampleCheckbox2',
        Index    => 14,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => 'label',    # make sure that label is working as well
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'label',
            },
        ],
        ExpectedResult => 0,
    },
    {
        Name     => 'ExampleDate',
        Index    => 15,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until DatePicker is initialized
                Select => '.DatepickerIcon',
            },
            {
                # select day (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(15) .WidgetSimple "
                    . "select:nth-child(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(15) .WidgetSimple "
                    . "select:nth-child(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(15) .WidgetSimple "
                    . "select:nth-child(3)').val(\"2016\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => '2016-05-05',
    },
    {
        Name     => 'ExampleDateTime',
        Index    => 16,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until DatePicker is initialized
                Select => '.DatepickerIcon',
            },
            {
                # select day (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(16) .WidgetSimple "
                    . "select:nth-child(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(16) .WidgetSimple "
                    . "select:nth-child(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(16) .WidgetSimple "
                    . "select:nth-child(3)').val(\"2016\")",
            },
            {
                # select hour (2) for first item
                JS => "\$('.SettingsList li:nth-of-type(16) .WidgetSimple "
                    . "select:nth-of-type(4)').val(\"2\")",
            },
            {
                # select minute (2) for first item
                JS => "\$('.SettingsList li:nth-of-type(16) .WidgetSimple "
                    . "select:nth-of-type(5)').val(\"2\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => '2016-05-05 02:02:00',
    },
    {
        Name     => 'ExampleDirectory',
        Index    => 17,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                Clear => 1,
            },
            {
                Write => '/usr',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => '/usr',
    },

    # {
    #     Name     => 'ExampleDirectory',
    #     Index    => 17,
    #     Commands => [
    #         {
    #             Hover => '.Content',
    #         },
    #         {
    #             Click => '.SettingEdit',
    #         },
    #         {
    #             Select => '.Setting input',
    #         },
    #         {
    #             Clear => 1,
    #         },
    #         {
    #             Write => '/usr123#',
    #         },
    #         {
    #             Hover => '.Setting',
    #         },
    #         {
    #             Click => '.Update',
    #         },
    #         {
    #             Alert => 'Setting value is not valid!',
    #         },
    #         {
    #             Click => '.Cancel',
    #         },
    #     ],
    #     ExpectedResult => '/usr',
    # },
    {
        Name     => 'ExampleEntityPriority',
        Index    => 18,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(18) .WidgetSimple "
                    . " select').val('1 very low')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => '1 very low',
    },
    {
        Name     => 'ExampleEntityQueue',
        Index    => 19,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(19) .WidgetSimple "
                    . " select').val('Raw')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => 'Raw',
    },
    {
        Name     => 'ExampleFile',
        Index    => 20,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                Clear => 1,
            },
            {
                Write => '/etc/localtime',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => '/etc/localtime',
    },

    # {
    #     Name     => 'ExampleFile',
    #     Index    => 20,
    #     Commands => [
    #         {
    #             Hover => '.Content',
    #         },
    #         {
    #             Click => '.SettingEdit',
    #         },
    #         {
    #             Select => '.Setting input',
    #         },
    #         {
    #             Clear => 1,
    #         },
    #         {
    #             Write => '/usr123#',
    #         },
    #         {
    #             Hover => '.Setting',
    #         },
    #         {
    #             Click => '.Update',
    #         },
    #         {
    #             Alert => 'Setting value is not valid!',
    #         },
    #         {
    #             Click => '.Cancel',
    #         },
    #     ],
    #     ExpectedResult => '/etc/localtime',
    # },
    {
        Name     => 'ExampleHash',
        Index    => 21,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(2) .RemoveButton',
            },

            # Check if remove button is hidden(min items)
            {
                ElementMissing => '.RemoveButton:visible',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'DynamicField_Address',    # check if keys with "_" works
            },
            {
                Click => '.AddKey',
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
                Click => '.Update',
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
        Index    => 22,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Name',
            },
            {
                Click => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                Click => '.HashItem:nth-of-type(1) label',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 23,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
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
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                Click => '.AddKey',
            },
            {
                Click => '.HashItem:nth-of-type(2) label',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 24,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                Click => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                # select day (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(24) .WidgetSimple "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(24) .WidgetSimple "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(24) .WidgetSimple "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 25,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
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
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                Click => '.AddKey',
            },
            {
                # Wait to initialize DatePicker
                Select => '.HashItem:nth-of-type(2) select:nth-of-type(2)',
            },
            {
                # select day (25) for first item
                JS => "\$('.SettingsList li:nth-of-type(25) .WidgetSimple "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(2)').val(\"25\")",
            },
            {
                # select month (11) for first item
                JS => "\$('.SettingsList li:nth-of-type(25) .WidgetSimple "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(1)').val(\"11\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(25) .WidgetSimple "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 26,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                Click => '.AddKey',
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
                JS => "\$('.SettingsList li:nth-of-type(26) .WidgetSimple "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(2)').val(\"5\")",
            },
            {
                # select month (05) for first item
                JS => "\$('.SettingsList li:nth-of-type(26) .WidgetSimple "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(1)').val(\"5\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(26) .WidgetSimple "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                # select hour (2) for first item
                JS => "\$('.SettingsList li:nth-of-type(26) .WidgetSimple "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(4)').val(\"2\")",
            },
            {
                # select minute (2) for first item
                JS => "\$('.SettingsList li:nth-of-type(26) .WidgetSimple "
                    . ".HashItem:nth-of-type(1) select:nth-of-type(5)').val(\"2\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 27,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
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
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                Click => '.AddKey',
            },
            {
                # Wait to initialize DatePicker
                Select => '.HashItem:nth-of-type(2) select:nth-of-type(2)',
            },
            {
                # select day (25) for first item
                JS => "\$('.SettingsList li:nth-of-type(27) .WidgetSimple "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(2)').val(\"25\")",
            },
            {
                # select month (11) for first item
                JS => "\$('.SettingsList li:nth-of-type(27) .WidgetSimple "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(1)').val(\"11\")",
            },
            {
                # select year (2016) for first item
                JS => "\$('.SettingsList li:nth-of-type(27) .WidgetSimple "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(3)').val(\"2016\")",
            },
            {
                # select hour (2) for first item
                JS => "\$('.SettingsList li:nth-of-type(27) .WidgetSimple "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(4)').val(\"2\")",
            },
            {
                # select minute (2) for first item
                JS => "\$('.SettingsList li:nth-of-type(27) .WidgetSimple "
                    . ".HashItem:nth-of-type(2) select:nth-of-type(5)').val(\"2\")",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 28,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Name',
            },
            {
                Click => '.AddKey',
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
                Click => '.Update',
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

    # {
    #     Name     => 'ExampleHashDirectory1',
    #     Index    => 28,
    #     Commands => [
    #         {
    #             Hover => '.Content',
    #         },
    #         {
    #             Click => '.SettingEdit',
    #         },
    #         {
    #             Select => '.HashItem:nth-of-type(1) .Content',
    #         },
    #         {
    #             Write => '/usr3#',
    #         },
    #         {
    #             Hover => '.Setting',
    #         },
    #         {
    #             Click => '.Update',
    #         },
    #         {
    #             Alert => 'Setting value is not valid!',
    #         },
    #         {
    #             Click => '.Cancel',
    #         },
    #         {
    #             Select => 'input',
    #         },
    #     ],
    #     ExpectedResult => {
    #         'Name' => 'John',
    #         'File' => '/usr',
    #     },
    # },
    {
        Name     => 'ExampleHashDirectory2',
        Index    => 29,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Name',
            },
            {
                Click => '.AddKey',
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
                Click => '.Update',
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
        Index    => 30,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                Click => '.AddKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) .Entry',
            },
            {
                Write => 'John',
            },
            {
                # Select 2 low
                JS => "\$('.SettingsList li:nth-of-type(30) .WidgetSimple "
                    . " select').val('2 low')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 31,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
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
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                Click => '.AddKey',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select 2 low
                JS => "\$('.SettingsList li:nth-of-type(31) .WidgetSimple "
                    . " select').val('2 low')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 32,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Name',
            },
            {
                Click => '.AddKey',
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
                Click => '.Update',
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

    # {
    #     Name     => 'ExampleHashFile1',
    #     Index    => 32,
    #     Commands => [
    #         {
    #             Hover => '.Content',
    #         },
    #         {
    #             Click => '.SettingEdit',
    #         },
    #         {
    #             Select => '.HashItem:nth-of-type(1) .Content',
    #         },
    #         {
    #             Write => '/usr3#',
    #         },
    #         {
    #             Hover => '.Setting',
    #         },
    #         {
    #             Click => '.Update',
    #         },
    #         {
    #             Alert => 'Setting value is not valid!',
    #         },
    #         {
    #             Click => '.Cancel',
    #         },
    #     ],
    #     ExpectedResult => {
    #         'Name' => 'John',
    #         'File' => '/etc/localtime',
    #     },
    # },
    {
        Name     => 'ExampleHashFile2',
        Index    => 33,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Name',
            },
            {
                Click => '.AddKey',
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
                Click => '.Update',
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
        Index    => 34,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
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
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                Click => '.AddKey',
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
                Click => '.Update',
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
        Index    => 35,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
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
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                Click => '.AddKey',
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
                Click => '.Update',
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
        Index    => 36,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                Click => '.AddKey',
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
                JS => "\$('.SettingsList li:nth-of-type(36) .WidgetSimple "
                    . " select').val('Kernel::System::Log::File')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 37,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
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
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                Click => '.AddKey',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select 2 low
                JS => "\$('.SettingsList li:nth-of-type(37) .WidgetSimple "
                    . " select').val('Kernel::System::Log::File')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 38,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                Click => '.AddKey',
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
                JS => "\$('.SettingsList li:nth-of-type(38) .WidgetSimple "
                    . " select').val('female')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'First name' => 'John',
            'Select'     => 'female',
        },
    },
    {
        Name     => 'ExampleHashSelect2',
        Index    => 39,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.Hash label',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                Click => '.AddKey',
            },
            {
                Select => 'select',
            },
            {
                # Select 2 low
                JS => "\$('.SettingsList li:nth-of-type(39) .WidgetSimple "
                    . " select').val('male')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => {
            'AnyKey'    => 'male',
            'Available' => '0',
        },
    },
    {
        Name     => 'ExampleHashTextarea1',
        Index    => 40,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                Click => '.AddKey',
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
                Click => '.Update',
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
        Index    => 41,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.HashItem:nth-of-type(2) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'Item',
            },
            {
                Click => '.AddKey',
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
                Click => '.Update',
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
        Index    => 42,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Click => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'First name',
            },
            {
                Click => '.AddKey',
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
                JS => "\$('.SettingsList li:nth-of-type(42) .WidgetSimple "
                    . " select').val('UTC')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
        Index    => 43,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                ElementMissing => '.HashItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.HashItem:nth-of-type(2) .RemoveButton',
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
                Click => '.AddHashKey',
            },
            {
                Select => '.HashItem:nth-of-type(2) input',
            },
            {
                Write => 'AnyKey',
            },
            {
                Click => '.AddKey',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select Europe/Berlin
                JS => "\$('.SettingsList li:nth-of-type(43) .WidgetSimple "
                    . " select').val('Europe/Berlin')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
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
    {
        Name     => 'ExamplePassword',
        Index    => 44,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Password 1',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'input',
            },
        ],
        ExpectedResult => 'Password 1',
    },
    {
        Name     => 'ExamplePerlModule',
        Index    => 45,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(45) .WidgetSimple "
                    . " select').val('Kernel::System::Log::File')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => 'Kernel::System::Log::File',
    },
    {
        Name     => 'ExampleSelect',
        Index    => 46,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select Kernel::System::Log::File
                JS => "\$('.SettingsList li:nth-of-type(46) .WidgetSimple "
                    . " select').val('option-2')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => 'option-2',
    },
    {
        Name     => 'ExampleString',
        Index    => 47,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Ticket#45',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => '.Setting input',
            },
            {
                ElementValue => 'Ticket#45',
            },
        ],
        ExpectedResult => 'Ticket#45',
    },
    {
        Name     => 'ExampleString',
        Index    => 47,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => '.Setting input',
            },
            {
                Clear => 1,
            },
            {
                Write => '',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => '.Setting input',
            },
            {
                ElementValue => '',
            },
        ],
        ExpectedResult => '',
    },
    {
        Name     => 'ExampleTextarea',
        Index    => 48,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => 'textarea',
            },
            {
                Clear => 1,
            },
            {
                Write => 'Area text',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'textarea',
            },
            {
                ElementValue => 'Area text',
            },
        ],
        ExpectedResult => 'Area text',
    },
    {
        Name     => 'ExampleTextarea',
        Index    => 48,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                Select => 'textarea',
            },
            {
                Clear => 1,
            },
            {
                Write => '',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'textarea',
            },
            {
                ElementValue => '',
            },
        ],
        ExpectedResult => '',
    },
    {
        Name     => 'ExampleTimeZone',
        Index    => 49,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                # Select Europe/Berlin
                JS => "\$('.SettingsList li:nth-of-type(49) .WidgetSimple "
                    . " select').val('Europe/Berlin')"
                    . ".trigger('redraw.InputField').trigger('change');",
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                Select => 'select',
            },
        ],
        ExpectedResult => 'Europe/Berlin',
    },
    {
        Name     => 'ExampleVacationDays',
        Index    => 50,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.AddArrayItem',
            },
        ],
        ExpectedResult => {},
    },
    {
        Name     => 'ExampleVacationDays',
        Index    => 50,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until Add item button is shown
                Select => '.AddArrayItem',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                # Select month 04
                JS => "\$('.SettingsList li:nth-of-type(50) .WidgetSimple "
                    . " .ArrayItem:nth-of-type(1) select:nth-of-type(1)').val('04')",
            },
            {
                # Select day 05
                JS => "\$('.SettingsList li:nth-of-type(50) .WidgetSimple "
                    . " .ArrayItem:nth-of-type(1) select:nth-of-type(2)').val('05')",
            },
            {
                Select => '.ArrayItem:nth-of-type(1) input',
            },
            {
                Write => 'Vacation day 1',
            },
            {
                Click => '.AddArrayItem',
            },
            {
                # Select month 11
                JS => "\$('.SettingsList li:nth-of-type(50) .WidgetSimple "
                    . " .ArrayItem:nth-of-type(2) select:nth-of-type(1)').val('11')",
            },
            {
                # Select day 22
                JS => "\$('.SettingsList li:nth-of-type(50) .WidgetSimple "
                    . " .ArrayItem:nth-of-type(2) select:nth-of-type(2)').val('22')",
            },
            {
                Select => '.ArrayItem:nth-of-type(2) input',
            },
            {
                Write => 'Vacation day 2',
            },

            {
                Click => '.AddArrayItem',
            },
            {
                # Select month 02
                JS => "\$('.SettingsList li:nth-of-type(50) .WidgetSimple "
                    . " .ArrayItem:nth-of-type(3) select:nth-of-type(1)').val('02')",
            },
            {
                # Select day 10
                JS => "\$('.SettingsList li:nth-of-type(50) .WidgetSimple "
                    . " .ArrayItem:nth-of-type(3) select:nth-of-type(2)').val('10')",
            },
            {
                Select => '.ArrayItem:nth-of-type(3) input',
            },
            {
                Write => 'Vacation day 3',
            },

            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.AddArrayItem',
            },
        ],
        ExpectedResult => {
            '4' => {
                '5' => 'Vacation day 1'
            },
            '11' => {
                '22' => 'Vacation day 2'
            },
            '2' => {
                '10' => 'Vacation day 3'
            },
        },
    },
    {
        Name     => 'ExampleVacationDaysOneTime',
        Index    => 51,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => 'select',
            },
            {
                Click => '.ArrayItem:nth-of-type(1) .RemoveButton',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.AddArrayItem',
            },
        ],
        ExpectedResult => {},
    },
    {
        Name     => 'ExampleVacationDaysOneTime',
        Index    => 51,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until Add item button is shown
                Select => '.AddArrayItem',
            },
            {
                Click => '.AddArrayItem',
            },

            #MDY
            {
                # Select month 04
                JS => "\$('.SettingsList li:nth-of-type(51) .WidgetSimple "
                    . " .ArrayItem:nth-of-type(1) select:nth-of-type(1)').val('4')",
            },
            {
                # Select day 05
                JS => "\$('.SettingsList li:nth-of-type(51) .WidgetSimple "
                    . " .ArrayItem:nth-of-type(1) select:nth-of-type(2)').val('5')",
            },
            {
                # Select year 2017
                JS => "\$('.SettingsList li:nth-of-type(51) .WidgetSimple "
                    . " .ArrayItem:nth-of-type(1) select:nth-of-type(3)').val('2017')",
            },
            {
                Select => '.ArrayItem:nth-of-type(1) input.VacationDaysOneTime',
            },
            {
                Write => 'Vacation day 1',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.AddArrayItem',
            },
        ],
        ExpectedResult => {
            '2017' => {
                '4' => {
                    '5' => 'Vacation day 1',
                },
            },
        },
    },
    {
        Name     => 'ExampleWorkingHours',
        Index    => 52,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => '.Update',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(9)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(10)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(34)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(35)',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.Update',
            },
        ],
        ExpectedResult => {},
    },
    {
        Name     => 'ExampleWorkingHours',
        Index    => 52,
        Commands => [
            {
                Hover => '.Content',
            },
            {
                Click => '.SettingEdit',
            },
            {
                # wait until select is initialized
                Select => '.Update',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(9)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(10)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(34)',
            },
            {
                Click => ' .WorkingHoursItem:nth-of-type(35)',
            },
            {
                Hover => '.Setting',
            },
            {
                Click => '.Update',
            },
            {
                ElementMissing => '.Update',
            },
        ],
        ExpectedResult => {
            'Mon' => [
                '8',
                '9',
            ],
            'Tue' => [
                '8',
                '9',
            ],
        },
    },
);

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # Rebuild system configuration.
        my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
        my $ExitCode      = $CommandObject->Execute('--cleanup');

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
            "Example XML loaded.",
        );

        my $DeploymentSuccess = $SysConfigObject->ConfigurationDeploy(
            Comments    => "AdminSystemConfiguration.t deployment",
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

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfiguration");

        my $OTRSBusinessIsInstalled = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled();
        my $OBTeaserFound = index( $Selenium->get_page_source(), 'supports versioning, rollback and' ) > -1;
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

        my $SettingsLoaded = $Selenium->WaitFor(
            JavaScript => 'return $(".SettingsList li:nth-of-type(1) .WidgetSimple").length',
        );

        $Self->True(
            $SettingsLoaded,
            'Settings are present on the page.'
        );

        for my $Test (@Tests) {

            my $Prefix = ".SettingsList li:nth-of-type($Test->{Index}) .WidgetSimple";

            $Selenium->execute_script(
                "\$('$Prefix')[0].scrollIntoView(true);",
            );

            for my $Command ( @{ $Test->{Commands} } ) {
                my $CommandType = ( keys %{$Command} )[0];
                my $Value       = $Command->{$CommandType};

                if ( $CommandType eq 'Click' ) {
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length',
                    );
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay")==0',
                    );

                    $Selenium->find_element( "$Prefix $Value", "css" )->VerifiedClick();

                    # TODO: Review - VerifiedClick doesn't work with overlay loader
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
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay")==0',
                    );
                }
                elsif ( $CommandType eq 'Alert' ) {
                    $Selenium->WaitFor(
                        AlertPresent => 1,
                    );

                    # verify alert message
                    $Self->Is(
                        $Value,
                        $Selenium->get_alert_text(),
                        "Check alert text - $Value",
                    );

                    # accept alert
                    $Selenium->accept_alert();
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
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay")==0',
                    );

                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . "$Prefix $Value" . '").length',
                    );

                    $SelectedItem = $Selenium->find_element( "$Prefix $Value", "css" );
                }
                elsif ( $CommandType eq 'JS' ) {

                    # Wait for any tasks to complete.
                    $Selenium->WaitFor(
                        JavaScript => 'return $("' . $Prefix . '").hasClass("HasOverlay")==0',
                    );

                    $Selenium->execute_script(
                        $Command->{JS},
                    );
                }
            }

            # compare results
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

        # reload page
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Sample;");

        # check if there is notification
        $Self->True(
            index( $Selenium->get_page_source(), 'You have undeployed settings, would you like to deploy them?' ) > -1,
            "Notification shown for undeployed settings."
        );

        $Selenium->WaitFor(
            JavaScript => 'return $("#CloudService:visible").length',
        );

        $Selenium->find_element( 'li#CloudService i', 'css' )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript => 'return $("#ConfigTree ul > li:first > ul > li:first:visible").length',
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
