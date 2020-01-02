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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @Tests = (
    {
        Name  => 'Missing DefaultSetting',
        Param => {
            ModifiedSetting => {
                EffectiveValue => 'Scalar value updated'
            },
        },
        ExpectedValue => undef,
    },
    {
        Name  => 'Missing ModifiedSetting',
        Param => {
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Content' => "Scalar value",
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => undef,
    },
    {
        Name  => 'Scalar',
        Param => {
            ModifiedSetting => {
                EffectiveValue => 'Scalar value updated'
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Content' => "Scalar value",
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'Content' => "Scalar value updated",
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Scalar with additional parameters',
        Param => {
            ModifiedSetting => {
                EffectiveValue => 'Scalar value updated'
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Content'     => "Scalar value",
                                    'CustomParam' => 'Test',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'Content'     => "Scalar value updated",
                        'CustomParam' => 'Test',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Simple hash',
        Param => {
            ModifiedSetting => {
                EffectiveValue => {
                    Possible    => 'Updated 1',
                    PossibleNot => 'Update 2',
                },
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Hash' => [
                                {
                                    'Item' => [
                                        {
                                            'Content' => 'PossibleContent',
                                            'Key'     => 'Possible'
                                        },
                                        {
                                            'Content' => 'PossibleAddContent',
                                            'Key'     => 'PossibleAdd'
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Hash' => [
                    {
                        'Item' => [
                            {
                                'Content' => 'Updated 1',
                                'Key'     => 'Possible'
                            },
                            {
                                'Content' => 'Update 2',
                                'Key'     => 'PossibleNot'
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Simple array',
        Param => {
            ModifiedSetting => {
                EffectiveValue => [
                    'Item 1',
                    'Item 3',
                    'Item 5',
                ],
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Array' => [
                                {
                                    'Item' => [
                                        {
                                            'Content' => 'Item 1',
                                        },
                                        {
                                            'Content' => 'Item 2',
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Array' => [
                    {
                        'Item' => [
                            {
                                'Content' => 'Item 1',
                            },
                            {
                                'Content' => 'Item 3',
                            },
                            {
                                'Content' => 'Item 5',
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Array of hashes',
        Param => {
            ModifiedSetting => {
                EffectiveValue => [
                    {
                        FirstName => 'John',
                        LastName  => 'Doe',
                        City      => 'New York',
                    },
                    {
                        FirstName => 'Richard',
                        LastName  => 'Roe',
                        City      => 'London',
                        Age       => '25',
                    },
                ],
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Array' => [
                                {
                                    'DefaultItem' => [
                                        {
                                            'Hash' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            Key     => 'FirstName',
                                                            Content => 'Jane'
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                    'Item' => [
                                        {
                                            'Hash' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            Key     => 'FirstName',
                                                            Content => 'Jane'
                                                        },
                                                        {
                                                            Key     => 'LastName',
                                                            Content => 'Doe'
                                                        },
                                                        {
                                                            Key     => 'Age',
                                                            Content => '22'
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Array' => [
                    {
                        'Item' => [
                            {
                                'Hash' => [
                                    {
                                        'Item' => [
                                            {
                                                Key     => 'City',
                                                Content => 'New York'
                                            },
                                            {
                                                Key     => 'FirstName',
                                                Content => 'John'
                                            },
                                            {
                                                Key     => 'LastName',
                                                Content => 'Doe'
                                            },
                                        ],
                                    },
                                ],
                            },
                            {
                                'Hash' => [
                                    {
                                        'Item' => [
                                            {
                                                Key     => 'Age',
                                                Content => '25'
                                            },
                                            {
                                                Key     => 'City',
                                                Content => 'London'
                                            },
                                            {
                                                Key     => 'FirstName',
                                                Content => 'Richard'
                                            },
                                            {
                                                Key     => 'LastName',
                                                Content => 'Roe'
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Hash of arrays with DefaultItem',
        Param => {
            ModifiedSetting => {
                EffectiveValue => {
                    Colors => [
                        'Red',
                        'Green',
                        'Blue',
                    ],
                    Priorities => [
                        'Low',
                        'Medium',
                        'High'
                    ],
                },
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Hash' => [
                                {
                                    'DefaultItem' => [
                                        {
                                            'Key'   => 'Colors',
                                            'Array' => [
                                                {
                                                    'Item' => [
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                    'Item' => [
                                        {
                                            'Key'   => 'Colors',
                                            'Array' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Content' => 'Red',
                                                        },
                                                        {
                                                            'Content' => 'Yellow',
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Hash' => [
                    {
                        'Item' => [
                            {
                                'Key'   => 'Colors',
                                'Array' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content' => 'Red',
                                            },
                                            {
                                                'Content' => 'Green',
                                            },
                                            {
                                                'Content' => 'Blue',
                                            },
                                        ],
                                    },
                                ],
                            },
                            {
                                'Key'   => 'Priorities',
                                'Array' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content' => 'Low',
                                            },
                                            {
                                                'Content' => 'Medium',
                                            },
                                            {
                                                'Content' => 'High',
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Hash of hashes',
        Param => {
            ModifiedSetting => {
                EffectiveValue => {
                    Colors => {
                        Red   => 1,
                        Green => 2,
                    },
                    Priorities => {
                        Low  => 1,
                        High => 2,
                    },
                },
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Hash' => [
                                {
                                    'DefaultItem' => [
                                        {
                                            # 'Key'  => 'Colors',
                                            'Hash' => [
                                                {
                                                    'Item' => [
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                    'Item' => [
                                        {
                                            'Key'  => 'Colors',
                                            'Hash' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Key'     => 'Red',
                                                            'Content' => '1',
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                        {
                                            'Key'  => 'Queues',
                                            'Hash' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Key'     => 'Raw',
                                                            'Content' => '1',
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Hash' => [
                    {
                        'Item' => [
                            {
                                'Key'  => 'Colors',
                                'Hash' => [
                                    {
                                        'Item' => [
                                            {
                                                'Key'     => 'Green',
                                                'Content' => '2',
                                            },
                                            {
                                                'Key'     => 'Red',
                                                'Content' => '1',
                                            },
                                        ],
                                    }
                                ]
                            },
                            {
                                'Key'  => 'Priorities',
                                'Hash' => [
                                    {
                                        'Item' => [
                                            {
                                                'Key'     => 'High',
                                                'Content' => '2',
                                            },
                                            {
                                                'Key'     => 'Low',
                                                'Content' => '1',
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Array of arrays',
        Param => {
            ModifiedSetting => {
                EffectiveValue => [
                    [
                        'Raw',
                        'Postmaster'
                    ],
                    [
                        'Open',
                        'Closed',
                        'Pending',
                    ],
                ],
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Array' => [
                                {
                                    'DefaultItem' => [
                                        {
                                            'Array' => [
                                                {
                                                    'Item' => [
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                    'Item' => [
                                        {
                                            'Array' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Content' => 'Raw',
                                                        },
                                                        {
                                                            'Content' => 'Junk',
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                        {
                                            'Array' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Content' => 'Open',
                                                        },
                                                        {
                                                            'Content' => 'New',
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Array' => [
                    {
                        'Item' => [
                            {
                                'Array' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content' => 'Raw',
                                            },
                                            {
                                                'Content' => 'Postmaster',
                                            },
                                        ],
                                    },
                                ],
                            },
                            {
                                'Array' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content' => 'Open',
                                            },
                                            {
                                                'Content' => 'Closed',
                                            },
                                            {
                                                'Content' => 'Pending',
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Checkbox',
        Param => {
            ModifiedSetting => {
                EffectiveValue => '1',
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Content'   => '0',
                                    'ValueType' => 'Checkbox',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'ValueType' => 'Checkbox',
                        'Content'   => '1',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Date',
        Param => {
            ModifiedSetting => {
                EffectiveValue => '2017-12-12',
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Content'   => '2016-01-01',
                                    'ValueType' => 'Date',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'Content'   => '2017-12-12',
                        'ValueType' => 'Date',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'DateTime',
        Param => {
            ModifiedSetting => {
                EffectiveValue => '2017-12-12 19:02:01',
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Content'   => '2016-01-01 00:03:20',
                                    'ValueType' => 'DateTime',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'Content'   => '2017-12-12 19:02:01',
                        'ValueType' => 'DateTime',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Entity',
        Param => {
            ModifiedSetting => {
                EffectiveValue => '1 low',
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Content'         => '3 normal',
                                    'ValueEntityType' => 'Priority',
                                    'ValueType'       => 'Entity',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'Content'         => '1 low',
                        'ValueEntityType' => 'Priority',
                        'ValueType'       => 'Entity',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'File',
        Param => {
            ModifiedSetting => {
                EffectiveValue => '/usr/bin/tmp',
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Content'    => '/usr/bin/openssl',
                                    'ValueRegex' => '',
                                    'ValueType'  => 'File',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'Content'    => '/usr/bin/tmp',
                        'ValueRegex' => '',
                        'ValueType'  => 'File',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'PerlModule',
        Param => {
            ModifiedSetting => {
                EffectiveValue => 'Kernel::System::Email::SendmailUpdated',
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Content'     => 'Kernel::System::Email::Sendmail',
                                    'ValueFilter' => 'Kernel/System/Email/*.pm',
                                    'ValueType'   => 'PerlModule',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'Content'     => 'Kernel::System::Email::SendmailUpdated',
                        'ValueFilter' => 'Kernel/System/Email/*.pm',
                        'ValueType'   => 'PerlModule',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Select',
        Param => {
            ModifiedSetting => {
                EffectiveValue => 'inline',
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Item' => [
                                        {
                                            'Content'      => 'inline',
                                            'Translatable' => '1',
                                            'Value'        => 'inline',
                                            'ValueType'    => 'Option'
                                        },
                                        {
                                            'Content'      => 'attachment',
                                            'Translatable' => '1',
                                            'Value'        => 'attachment',
                                            'ValueType'    => 'Option'
                                        }
                                    ],
                                    'SelectedID' => 'attachment',
                                    'ValueType'  => 'Select'
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'Item' => [
                            {
                                'Content'      => 'inline',
                                'Translatable' => '1',
                                'Value'        => 'inline',
                                'ValueType'    => 'Option',
                            },
                            {
                                'Content'      => 'attachment',
                                'Translatable' => '1',
                                'Value'        => 'attachment',
                                'ValueType'    => 'Option',
                            },
                        ],
                        'SelectedID' => 'inline',
                        'ValueType'  => 'Select',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'String',
        Param => {
            ModifiedSetting => {
                EffectiveValue => '345',
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'ValueType' => 'String',
                                    'Content'   => '123',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'ValueType' => 'String',
                        'Content'   => '345',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Textarea',
        Param => {
            ModifiedSetting => {
                EffectiveValue => '345',
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'ValueType' => 'Textarea',
                                    'Content'   => '123',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'ValueType' => 'Textarea',
                        'Content'   => '345',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'TimeZone',
        Param => {
            ModifiedSetting => {
                EffectiveValue => 'Europe/London',
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'ValueType' => 'TimeZone',
                                    'Content'   => 'UTC',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'ValueType' => 'TimeZone',
                        'Content'   => 'Europe/London',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'VacationDays',
        Param => {
            ModifiedSetting => {
                EffectiveValue => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                    '4' => {
                        '1' => 'Fool\'s day',
                    },
                    '12' => {
                        '24' => 'Christmas Eve',
                        '25' => 'First Christmas Day',
                        '31' => 'New Year\'s Eve',
                    },
                    '5' => {
                        '1' => 'International Workers\' Day',
                    },
                },
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Item' => [
                                        {
                                            'Content'      => 'New Year\'s Day',
                                            'Translatable' => '1',
                                            'ValueDay'     => '1',
                                            'ValueMonth'   => '1',
                                        },
                                        {
                                            'Content'      => 'International Workers\' Day',
                                            'Translatable' => '1',
                                            'ValueDay'     => '1',
                                            'ValueMonth'   => '5'
                                        },
                                        {
                                            'Content'      => 'Christmas Eve',
                                            'Translatable' => '1',
                                            'ValueDay'     => '24',
                                            'ValueMonth'   => '12',
                                        },
                                        {
                                            'Content'      => 'First Christmas Day',
                                            'Translatable' => '1',
                                            'ValueDay'     => '25',
                                            'ValueMonth'   => '12',
                                        },
                                        {
                                            'Content'      => 'Second Christmas Day',
                                            'Translatable' => '1',
                                            'ValueDay'     => '26',
                                            'ValueMonth'   => '12',
                                        },
                                        {
                                            'Content'      => 'New Year\'s Eve',
                                            'Translatable' => '1',
                                            'ValueDay'     => '31',
                                            'ValueMonth'   => '12',
                                        }
                                    ],
                                    'ValueType' => 'VacationDays'
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'Item' => [
                            {
                                'Content'      => 'New Year\'s Day',
                                'Translatable' => '1',
                                'ValueDay'     => '1',
                                'ValueMonth'   => '1',
                            },
                            {
                                'Content'      => 'Fool\'s day',
                                'Translatable' => '1',
                                'ValueDay'     => '1',
                                'ValueMonth'   => '4'
                            },
                            {
                                'Content'      => 'International Workers\' Day',
                                'Translatable' => '1',
                                'ValueDay'     => '1',
                                'ValueMonth'   => '5'
                            },
                            {
                                'Content'      => 'Christmas Eve',
                                'Translatable' => '1',
                                'ValueDay'     => '24',
                                'ValueMonth'   => '12',
                            },
                            {
                                'Content'      => 'First Christmas Day',
                                'Translatable' => '1',
                                'ValueDay'     => '25',
                                'ValueMonth'   => '12',
                            },
                            {
                                'Content'      => 'New Year\'s Eve',
                                'Translatable' => '1',
                                'ValueDay'     => '31',
                                'ValueMonth'   => '12',
                            }
                        ],
                        'ValueType' => 'VacationDays'
                    },
                ],
            },
        ],
    },
    {
        Name  => 'VacationDaysOneTime',
        Param => {
            ModifiedSetting => {
                EffectiveValue => {
                    '2012' => {
                        '3' => {
                            '1' => 'Test4',
                        },
                    },
                    '2004' => {
                        '12' => {
                            '20' => 'Test3',
                        },
                        '1' => {
                            '1'  => 'Test1',
                            '22' => 'Test2',
                        },
                    },
                },
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Item' => [
                                {
                                    'Item' => [
                                        {
                                            ValueMonth => '1',
                                            ValueYear  => '2004',
                                            Content    => 'test',
                                            ValueDay   => '1',
                                        },
                                    ],
                                    'ValueType' => 'VacationDaysOneTime',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Item' => [
                    {
                        'Item' => [
                            {
                                ValueMonth => '1',
                                ValueYear  => '2004',
                                Content    => 'Test1',
                                ValueDay   => '1',
                            },
                            {
                                ValueMonth => '1',
                                ValueYear  => '2004',
                                Content    => 'Test2',
                                ValueDay   => '22',
                            },
                            {
                                ValueMonth => '12',
                                ValueYear  => '2004',
                                Content    => 'Test3',
                                ValueDay   => '20',
                            },
                            {
                                ValueMonth => '3',
                                ValueYear  => '2012',
                                Content    => 'Test4',
                                ValueDay   => '1',
                            },
                        ],
                        'ValueType' => 'VacationDaysOneTime',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'WorkingHours',
        Param => {
            ModifiedSetting => {
                EffectiveValue => {
                    Mon => [
                        '8',
                        '9',
                        '10',
                        '12',
                    ],
                    Tue => [
                        '11',
                        '12',
                        '13',
                    ],
                    Wed => [
                        '14',
                        '15',
                        '16',
                    ],
                    Thu => [
                        '17',
                        '18',
                        '19',
                    ],
                    Fri => [],
                    Sat => [
                        '1',
                    ],
                    Sun => [],
                },
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            Item => [
                                {
                                    Item => [
                                        {
                                            ValueType => 'Day',
                                            ValueName => 'Mon',
                                            Item      => [
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '8',
                                                },
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '9',
                                                },
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '10',
                                                },
                                            ],
                                        },
                                        {
                                            ValueType => 'Day',
                                            ValueName => 'Tue',
                                            Item      => [
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '11',
                                                },
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '12',
                                                },
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '13',
                                                },
                                            ],
                                        },
                                        {
                                            ValueType => 'Day',
                                            ValueName => 'Wed',
                                            Item      => [
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '14',
                                                },
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '15',
                                                },
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '16',
                                                },
                                            ],
                                        },
                                        {
                                            ValueType => 'Day',
                                            ValueName => 'Thu',
                                            Item      => [
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '17',
                                                },
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '18',
                                                },
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '19',
                                                },
                                            ],
                                        },
                                        {
                                            ValueType => 'Day',
                                            ValueName => 'Fri',
                                            Item      => [
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '20',
                                                },
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '21',
                                                },
                                                {
                                                    ValueType => 'Hour',
                                                    Content   => '22',
                                                },
                                            ],
                                        },
                                        {
                                            ValueName => 'Sat',
                                            Content   => '',
                                            ValueType => 'Day',
                                        },
                                        {
                                            ValueType => 'Day',
                                            Content   => '',
                                            ValueName => 'Sun',
                                        },
                                    ],
                                    ValueType => 'WorkingHours',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                Item => [
                    {
                        Item => [
                            {
                                ValueType => 'Day',
                                ValueName => 'Mon',
                                Item      => [
                                    {
                                        ValueType => 'Hour',
                                        Content   => '8',
                                    },
                                    {
                                        ValueType => 'Hour',
                                        Content   => '9',
                                    },
                                    {
                                        ValueType => 'Hour',
                                        Content   => '10',
                                    },
                                    {
                                        ValueType => 'Hour',
                                        Content   => '12',
                                    },
                                ],
                            },
                            {
                                ValueType => 'Day',
                                ValueName => 'Tue',
                                Item      => [
                                    {
                                        ValueType => 'Hour',
                                        Content   => '11',
                                    },
                                    {
                                        ValueType => 'Hour',
                                        Content   => '12',
                                    },
                                    {
                                        ValueType => 'Hour',
                                        Content   => '13',
                                    },
                                ],
                            },
                            {
                                ValueType => 'Day',
                                ValueName => 'Wed',
                                Item      => [
                                    {
                                        ValueType => 'Hour',
                                        Content   => '14',
                                    },
                                    {
                                        ValueType => 'Hour',
                                        Content   => '15',
                                    },
                                    {
                                        ValueType => 'Hour',
                                        Content   => '16',
                                    },
                                ],
                            },
                            {
                                ValueType => 'Day',
                                ValueName => 'Thu',
                                Item      => [
                                    {
                                        ValueType => 'Hour',
                                        Content   => '17',
                                    },
                                    {
                                        ValueType => 'Hour',
                                        Content   => '18',
                                    },
                                    {
                                        ValueType => 'Hour',
                                        Content   => '19',
                                    },
                                ],
                            },
                            {
                                ValueType => 'Day',
                                ValueName => 'Fri',
                                Content   => '',

                            },
                            {
                                ValueName => 'Sat',
                                ValueType => 'Day',
                                Item      => [
                                    {
                                        ValueType => 'Hour',
                                        Content   => '1',
                                    },
                                ],
                            },
                            {
                                ValueType => 'Day',
                                Content   => '',
                                ValueName => 'Sun',
                            },
                        ],
                        ValueType => 'WorkingHours',
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Additional parameters defined in Hash',
        Param => {
            ModifiedSetting => {
                EffectiveValue => {
                    Text1 => 'Lorem ipsum',
                    Text2 => 'Lorem ipsum2',
                },
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Hash' => [
                                {
                                    'DefaultItem' => [
                                        {
                                            'Content'         => '123',
                                            'CustomParameter' => 'Test',
                                        },
                                    ],
                                    'Item' => [
                                        {
                                            'Key'     => 'Text',
                                            'Content' => '123',
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Hash' => [
                    {
                        'Item' => [
                            {
                                'Key'             => 'Text1',
                                'Content'         => 'Lorem ipsum',
                                'CustomParameter' => 'Test',
                            },
                            {
                                'Key'             => 'Text2',
                                'Content'         => 'Lorem ipsum2',
                                'CustomParameter' => 'Test',
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Additional parameters defined in Array',
        Param => {
            ModifiedSetting => {
                EffectiveValue => [
                    'Lorem ipsum',
                    'Lorem ipsum2',
                ],
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Array' => [
                                {
                                    'Item' => [
                                        {
                                            'Content' => 'Text',
                                        },
                                    ],
                                    'CustomParameter' => 'Test',
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Array' => [
                    {
                        'Item' => [
                            {
                                'Content' => 'Lorem ipsum',
                            },
                            {
                                'Content' => 'Lorem ipsum2',
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Array - Additional parameters defined in the DefaultItem',
        Param => {
            ModifiedSetting => {
                EffectiveValue => [
                    'Lorem ipsum',
                    'Lorem ipsum2',
                ],
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Array' => [
                                {
                                    'DefaultItem' => [
                                        {
                                            'Content'         => 'Text',
                                            'CustomParameter' => 'Test',
                                        },
                                    ],
                                    'Item' => [
                                        {
                                            'Content' => 'Text',
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Array' => [
                    {
                        'Item' => [
                            {
                                'Content'         => 'Lorem ipsum',
                                'CustomParameter' => 'Test',
                            },
                            {
                                'Content'         => 'Lorem ipsum2',
                                'CustomParameter' => 'Test',
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Hash of Items with defined ValueType in the DefaultItem.',
        Param => {
            ModifiedSetting => {
                EffectiveValue => {
                    StringItem  => 'Text string',
                    StringItem2 => 'Down',
                    AnotherItem => 'Another item value',
                },
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Hash' => [
                                {
                                    'DefaultItem' => [
                                        {
                                            'Item' => [
                                                {
                                                    'Content' => 'Text',
                                                },
                                            ],
                                            'ValueType'       => 'String',
                                            'CustomParameter' => 'Test',
                                        },
                                    ],
                                    'Item' => [
                                        {
                                            'Key'  => 'StringItem',
                                            'Item' => [
                                                {
                                                    'Content' => 'Text',
                                                },
                                            ],
                                            'ValueType' => 'String',
                                        },
                                        {
                                            'Key'  => 'StringItem2',
                                            'Item' => [
                                                {
                                                    'Content' => 'Text2',
                                                },
                                            ],
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Hash' => [
                    {
                        'Item' => [
                            {
                                'Key'             => 'AnotherItem',
                                'ValueType'       => 'String',
                                'CustomParameter' => 'Test',
                                'Item'            => [
                                    {
                                        'Content' => 'Another item value',
                                    },
                                ],
                            },
                            {
                                'Key'  => 'StringItem',
                                'Item' => [
                                    {
                                        'Content' => 'Text string',
                                    },
                                ],
                                'ValueType' => 'String',
                            },
                            {
                                'Key'  => 'StringItem2',
                                'Item' => [
                                    {
                                        'Content' => 'Down',
                                    },
                                ],
                                'ValueType'       => 'String',
                                'CustomParameter' => 'Test',
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Hash of Items with defined ValueType only for certain key.',
        Param => {
            ModifiedSetting => {
                EffectiveValue => {
                    StringItem  => 'Text string',
                    Gender      => 'female',
                    AnotherItem => 'Another item value',
                },
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Hash' => [
                                {
                                    'Item' => [
                                        {
                                            'Key'  => 'StringItem',
                                            'Item' => [
                                                {
                                                    'Content' => 'Text',
                                                },
                                            ],
                                            'ValueType' => 'String',
                                        },
                                        {
                                            'Key'  => 'StringItem2',
                                            'Item' => [
                                                {
                                                    'Content' => 'Text2',
                                                },
                                            ],
                                        },
                                        {
                                            'Key'  => 'Gender',
                                            'Item' => [
                                                {
                                                    'ValueType'  => 'Select',
                                                    'SelectedID' => 'male',
                                                    'Item'       => [
                                                        {
                                                            Value     => 'male',
                                                            Content   => 'Male',
                                                            ValueType => 'Option',
                                                        },
                                                        {
                                                            Value     => 'female',
                                                            Content   => 'Female',
                                                            ValueType => 'Option',
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Hash' => [
                    {
                        'Item' => [
                            {
                                'Key'     => 'AnotherItem',
                                'Content' => 'Another item value',
                            },
                            {
                                'Key'  => 'Gender',
                                'Item' => [
                                    {
                                        'ValueType'  => 'Select',
                                        'SelectedID' => 'female',
                                        'Item'       => [
                                            {
                                                Value     => 'male',
                                                Content   => 'Male',
                                                ValueType => 'Option',
                                            },
                                            {
                                                Value     => 'female',
                                                Content   => 'Female',
                                                ValueType => 'Option',
                                            },
                                        ],
                                    },
                                ],
                            },
                            {
                                'Key'  => 'StringItem',
                                'Item' => [
                                    {
                                        'Content' => 'Text string',
                                    },
                                ],
                                'ValueType' => 'String',
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Array of Items with defined ValueType in the DefaultItem',
        Param => {
            ModifiedSetting => {
                EffectiveValue => [
                    'Text string',
                    'Down',
                    'Another item value',
                ],
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Array' => [
                                {
                                    'DefaultItem' => [
                                        {
                                            'Content'   => 'Text',
                                            'ValueType' => 'String',
                                        },
                                    ],
                                    'Item' => [
                                        {
                                            'Item' => [
                                                {
                                                    'Content' => 'Text',
                                                },
                                            ],
                                        },
                                        {
                                            'Item' => [
                                                {
                                                    'Content' => 'Text2',
                                                },
                                            ],
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Array' => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        'Content'   => 'Text string',
                                        'ValueType' => 'String',
                                    },
                                ],
                            },
                            {
                                'Item' => [
                                    {
                                        'Content'   => 'Down',
                                        'ValueType' => 'String',
                                    },
                                ],
                            },
                            {
                                'Item' => [
                                    {
                                        'Content'   => 'Another item value',
                                        'ValueType' => 'String',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Array of Items with ValueType Select in the DefaultItem',
        Param => {
            ModifiedSetting => {
                EffectiveValue => [
                    '1',
                    '2',
                    '3',
                ],
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Array' => [
                                {
                                    'DefaultItem' => [
                                        {
                                            CustomParam => 'My Value',
                                            ValueType   => 'Select',
                                            SelectedID  => '2',
                                            Item        => [
                                                {
                                                    Value     => '0',
                                                    Content   => '0',
                                                    ValueType => 'Option',
                                                },
                                                {
                                                    ValueType => 'Option',
                                                    Value     => '1',
                                                    Content   => '1',
                                                },
                                                {
                                                    ValueType => 'Option',
                                                    Value     => '2',
                                                    Content   => '2',
                                                },
                                                {
                                                    ValueType => 'Option',
                                                    Value     => '3',
                                                    Content   => '3',
                                                }
                                            ],
                                        },
                                    ],
                                    'Item' => [
                                        {
                                            'Item' => [
                                                {
                                                    SelectedID => '2',
                                                    Item       => [
                                                        {
                                                            Value     => '0',
                                                            Content   => '0',
                                                            ValueType => 'Option',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '1',
                                                            Content   => '1',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '2',
                                                            Content   => '2',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '3',
                                                            Content   => '3',
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                        {
                                            'Item' => [
                                                {
                                                    SelectedID => '1',
                                                    Item       => [
                                                        {
                                                            Value     => '0',
                                                            Content   => '0',
                                                            ValueType => 'Option',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '1',
                                                            Content   => '1',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '2',
                                                            Content   => '2',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '3',
                                                            Content   => '3',
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Array' => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        CustomParam => 'My Value',
                                        ValueType   => 'Select',
                                        SelectedID  => '1',
                                        Item        => [
                                            {
                                                Value     => '0',
                                                Content   => '0',
                                                ValueType => 'Option',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '1',
                                                Content   => '1',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '2',
                                                Content   => '2',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '3',
                                                Content   => '3',
                                            }
                                        ],
                                    },
                                ],
                            },
                            {
                                'Item' => [
                                    {
                                        CustomParam => 'My Value',
                                        ValueType   => 'Select',
                                        SelectedID  => '2',
                                        Item        => [
                                            {
                                                Value     => '0',
                                                Content   => '0',
                                                ValueType => 'Option',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '1',
                                                Content   => '1',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '2',
                                                Content   => '2',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '3',
                                                Content   => '3',
                                            }
                                        ],
                                    },
                                ],
                            },
                            {
                                'Item' => [
                                    {
                                        CustomParam => 'My Value',
                                        ValueType   => 'Select',
                                        SelectedID  => '3',
                                        Item        => [
                                            {
                                                Value     => '0',
                                                Content   => '0',
                                                ValueType => 'Option',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '1',
                                                Content   => '1',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '2',
                                                Content   => '2',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '3',
                                                Content   => '3',
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Hash of Items with ValueType Select in DefaultItem.',
        Param => {
            ModifiedSetting => {
                EffectiveValue => {
                    Numeric     => '1',
                    Text        => 'Down',
                    StringValue => 'Updated text',
                    NewKey      => '2',
                },
            },
            DefaultSetting => {
                XMLContentParsed => {
                    Value => [
                        {
                            'Hash' => [
                                {
                                    'DefaultItem' => [
                                        {
                                            'ValueType'       => 'Select',
                                            'CustomParameter' => 'Test',
                                            'Item'            => [
                                                {
                                                    Item => [
                                                        {
                                                            Value     => '0',
                                                            Content   => '0',
                                                            ValueType => 'Option',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '1',
                                                            Content   => '1',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '2',
                                                            Content   => '2',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '3',
                                                            Content   => '3',
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                    'Item' => [
                                        {
                                            'ValueType' => 'Select',
                                            'Item'      => [
                                                {
                                                    SelectedID => '2',
                                                    Item       => [
                                                        {
                                                            Value     => '0',
                                                            Content   => '0',
                                                            ValueType => 'Option',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '1',
                                                            Content   => '1',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '2',
                                                            Content   => '2',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => '3',
                                                            Content   => '3',
                                                        }
                                                    ],
                                                },
                                            ],
                                            'Key' => 'Numeric',
                                        },
                                        {
                                            'ValueType' => 'Select',
                                            'Item'      => [
                                                {
                                                    SelectedID => 'Up',
                                                    Item       => [
                                                        {
                                                            Value     => 'Down',
                                                            Content   => 'Down',
                                                            ValueType => 'Option',
                                                        },
                                                        {
                                                            ValueType => 'Option',
                                                            Value     => 'Up',
                                                            Content   => 'Up',
                                                        },
                                                    ],
                                                },
                                            ],
                                            'Key' => 'Text',
                                        },
                                        {
                                            'Content'   => 'Lorem ipsum',
                                            'Key'       => 'StringValue',
                                            'ValueType' => 'String',
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Hash' => [
                    {
                        'Item' => [
                            {
                                'ValueType' => 'Select',
                                'Item'      => [
                                    {
                                        SelectedID => '2',
                                        Item       => [
                                            {
                                                Value     => '0',
                                                Content   => '0',
                                                ValueType => 'Option',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '1',
                                                Content   => '1',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '2',
                                                Content   => '2',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '3',
                                                Content   => '3',
                                            }
                                        ],
                                    },
                                ],
                                'Key'             => 'NewKey',
                                'CustomParameter' => 'Test',
                            },
                            {
                                'ValueType' => 'Select',
                                'Item'      => [
                                    {
                                        SelectedID => '1',
                                        Item       => [
                                            {
                                                Value     => '0',
                                                Content   => '0',
                                                ValueType => 'Option',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '1',
                                                Content   => '1',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '2',
                                                Content   => '2',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => '3',
                                                Content   => '3',
                                            }
                                        ],
                                    },
                                ],
                                'Key' => 'Numeric',
                            },
                            {
                                'Content'   => 'Updated text',
                                'Key'       => 'StringValue',
                                'ValueType' => 'String',
                            },
                            {
                                'ValueType' => 'Select',
                                'Item'      => [
                                    {
                                        SelectedID => 'Down',
                                        Item       => [
                                            {
                                                Value     => 'Down',
                                                Content   => 'Down',
                                                ValueType => 'Option',
                                            },
                                            {
                                                ValueType => 'Option',
                                                Value     => 'Up',
                                                Content   => 'Up',
                                            },
                                        ],
                                    },
                                ],
                                'Key' => 'Text',
                            },
                        ],
                    },
                ],
            },
        ],
    },
    {
        Name  => 'Test AoHoA',
        Param => {
            ModifiedSetting => {
                EffectiveValue => [
                    {
                        'One' => [
                            '1',
                            '2',
                        ],
                    },
                    {},
                    {
                        'Test' => [
                            '1',
                        ],
                        '2' => [
                            '3',
                            '4',
                        ],
                    },
                ],
            },
            DefaultSetting => {
                XMLContentParsed => {
                    'Value' => [
                        {
                            'Array' => [
                                {
                                    'Item' => [
                                        {
                                            'Hash' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Key'   => 'One',
                                                            'Array' => [
                                                                {
                                                                    'Item' => [
                                                                        {
                                                                            'Content' => '1',
                                                                        },
                                                                        {
                                                                            'Content' => '2',
                                                                        },
                                                                    ],
                                                                },
                                                            ],
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                        {
                                            'Hash' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Array' => [
                                                                {
                                                                    'Item' => [
                                                                        {
                                                                            'Content' => '3',
                                                                        },
                                                                        {
                                                                            'Content' => '4',
                                                                        },
                                                                    ],
                                                                },
                                                            ],
                                                            'Key' => 'Two',
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                    'DefaultItem' => [
                                        {
                                            'Hash' => [
                                                {
                                                    'DefaultItem' => [
                                                        {
                                                            'Array' => [
                                                                {
                                                                    'Item' => [
                                                                        {}
                                                                    ],
                                                                },
                                                            ],
                                                        },
                                                    ],
                                                },
                                            ],
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            },
        },
        ExpectedValue => [
            {
                'Array' => [
                    {
                        'Item' => [
                            {
                                'Hash' => [
                                    {
                                        'Item' => [
                                            {
                                                'Key'   => 'One',
                                                'Array' => [
                                                    {
                                                        'Item' => [
                                                            {
                                                                'Content' => '1',
                                                            },
                                                            {
                                                                'Content' => '2',
                                                            },
                                                        ],
                                                    },
                                                ],
                                            },
                                        ],
                                    },
                                ],
                            },
                            {
                                'Hash' => [
                                    {
                                        'Item' => [],
                                    },
                                ],
                            },
                            {
                                'Hash' => [
                                    {
                                        'Item' => [
                                            {
                                                'Key'   => '2',
                                                'Array' => [
                                                    {
                                                        'Item' => [
                                                            {
                                                                'Content' => '3',
                                                            },
                                                            {
                                                                'Content' => '4',
                                                            },
                                                        ],
                                                    },
                                                ],
                                            },
                                            {
                                                'Key'   => 'Test',
                                                'Array' => [
                                                    {
                                                        'Item' => [
                                                            {
                                                                'Content' => '1',
                                                            },
                                                        ],
                                                    },
                                                ],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
        ],
    },

    # Custom
    {
        Name  => 'Test bug#13560',
        Param => {
            ModifiedSetting => {
                "EffectiveValue" => {
                    "DefaultColumns" => {
                        "Age"      => 1,
                        "Changed"  => 1,
                        "Priority" => 1,
                    },
                    "Module" => "Kernel::Output::HTML::Dashboard::TicketGeneric",
                    "Title"  => "Escalated Tickets",
                },
            },
            DefaultSetting => {
                "XMLContentParsed" => {
                    "Value" => [
                        {
                            "Hash" => [
                                {
                                    "Item" => [
                                        {
                                            "Content" => "Kernel::Output::HTML::Dashboard::TicketGeneric",
                                            "Key"     => "Module",
                                        },
                                        {
                                            "Hash" => [
                                                {
                                                    "DefaultItem" => [
                                                        {
                                                            "Item" => [
                                                                {
                                                                    "Content"      => "0 - Disabled",
                                                                    "Translatable" => 1,
                                                                    "Value"        => 0,
                                                                    "ValueType"    => "Option",
                                                                },
                                                                {
                                                                    "Content"      => "1 - Available",
                                                                    "Translatable" => 1,
                                                                    "Value"        => 1,
                                                                    "ValueType"    => "Option",
                                                                },
                                                                {
                                                                    "Content"      => "2 - Enabled by default",
                                                                    "Translatable" => 1,
                                                                    "Value"        => 2,
                                                                    "ValueType"    => "Option",
                                                                },
                                                            ],
                                                            "ValueType" => "Select",
                                                        },
                                                    ],
                                                    "Item" => [
                                                        {
                                                            "Key"        => "Age",
                                                            "SelectedID" => 2,
                                                        },
                                                        {
                                                            "Key"        => "Changed",
                                                            "SelectedID" => 1,
                                                        },
                                                        {
                                                            "Key"        => "Created",
                                                            "SelectedID" => 1,
                                                        },
                                                    ],
                                                },
                                            ],
                                            "Key" => "DefaultColumns",
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
            }
        },
        ExpectedValue => [
            {
                "Hash" => [
                    {
                        "Item" => [
                            {
                                "Hash" => [
                                    {
                                        "DefaultItem" => [
                                            {
                                                "Item" => [
                                                    {
                                                        "Content"      => "0 - Disabled",
                                                        "Translatable" => 1,
                                                        "Value"        => 0,
                                                        "ValueType"    => "Option",
                                                    },
                                                    {
                                                        "Content"      => "1 - Available",
                                                        "Translatable" => 1,
                                                        "Value"        => 1,
                                                        "ValueType"    => "Option",
                                                    },
                                                    {
                                                        "Content"      => "2 - Enabled by default",
                                                        "Translatable" => 1,
                                                        "Value"        => 2,
                                                        "ValueType"    => "Option",
                                                    },
                                                ],
                                                "Key"        => "Changed",
                                                "SelectedID" => 1,
                                                "ValueType"  => "Select",
                                            },
                                        ],
                                        "Item" => [
                                            {
                                                "Item" => [
                                                    {
                                                        "Content"      => "0 - Disabled",
                                                        "Translatable" => 1,
                                                        "Value"        => 0,
                                                        "ValueType"    => "Option",
                                                    },
                                                    {
                                                        "Content"      => "1 - Available",
                                                        "Translatable" => 1,
                                                        "Value"        => 1,
                                                        "ValueType"    => "Option",
                                                    },
                                                    {
                                                        "Content"      => "2 - Enabled by default",
                                                        "Translatable" => 1,
                                                        "Value"        => 2,
                                                        "ValueType"    => "Option",
                                                    },
                                                ],
                                                "Key"        => "Age",
                                                "SelectedID" => 1,          # This is updated.
                                                "ValueType"  => "Select",
                                            },
                                            {
                                                "Item" => [
                                                    {
                                                        "Content"      => "0 - Disabled",
                                                        "Translatable" => 1,
                                                        "Value"        => 0,
                                                        "ValueType"    => "Option",
                                                    },
                                                    {
                                                        "Content"      => "1 - Available",
                                                        "Translatable" => 1,
                                                        "Value"        => 1,
                                                        "ValueType"    => "Option",
                                                    },
                                                    {
                                                        "Content"      => "2 - Enabled by default",
                                                        "Translatable" => 1,
                                                        "Value"        => 2,
                                                        "ValueType"    => "Option",
                                                    },
                                                ],
                                                "Key"        => "Changed",
                                                "SelectedID" => 1,
                                                "ValueType"  => "Select",
                                            },
                                            {
                                                "Item" => [
                                                    {
                                                        "Content"      => "0 - Disabled",
                                                        "Translatable" => 1,
                                                        "Value"        => 0,
                                                        "ValueType"    => "Option",
                                                    },
                                                    {
                                                        "Content"      => "1 - Available",
                                                        "Translatable" => 1,
                                                        "Value"        => 1,
                                                        "ValueType"    => "Option",
                                                    },
                                                    {
                                                        "Content"      => "2 - Enabled by default",
                                                        "Translatable" => 1,
                                                        "Value"        => 2,
                                                        "ValueType"    => "Option",
                                                    },
                                                ],
                                                "Key"        => "Priority",
                                                "SelectedID" => 1,
                                                "ValueType"  => "Select",
                                            },
                                        ],
                                    },
                                ],
                                "Key" => "DefaultColumns",
                            },
                            {
                                "Content" => "Kernel::Output::HTML::Dashboard::TicketGeneric",
                                "Key"     => "Module",
                            },
                            {
                                "Content" => "Escalated Tickets",
                                "Key"     => "Title",
                            },
                        ],
                    },
                ],
            },
        ],
    },
);

for my $Test (@Tests) {

    my $Value = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingModifiedXMLContentParsedGet(
        %{ $Test->{Param} }
    );
    if ($Value) {
        $Self->IsDeeply(
            $Value,
            $Test->{ExpectedValue},
            "$Test->{Name} ModifiedValueGet()",
        );
    }
    else {
        $Self->False(
            $Test->{ExpectedValue},
            "$Test->{Name} ModifiedValueGet()",
        );
    }
}

1;
