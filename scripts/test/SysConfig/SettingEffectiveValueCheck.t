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

use Kernel::Config;

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

$HelperObject->FixedTimeSet();

my @Tests = (
    {
        Description => 'Required String - pass',
        Config      => {
            XMLContentParsed => {
                Required => 1,
                Value    => [
                    {
                        'Item' => [
                            {
                                'Content'    => '3600',
                                'ValueRegex' => '',
                                'ValueType'  => 'String'
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'Test',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => 'Test',
        },
    },
    {
        Description => 'Not required String - pass',
        Config      => {
            XMLContentParsed => {
                Required => 0,
                Value    => [
                    {
                        'Item' => [
                            {
                                'Content'    => '3600',
                                'ValueRegex' => '',
                                'ValueType'  => 'String'
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => '',
        },
    },
    {
        Description => 'String should be scalar - fail',
        Config      => {
            XMLContentParsed => {
                Required => 0,
                Value    => [
                    {
                        'Item' => [
                            {
                                'Content'    => '3600',
                                'ValueRegex' => '',
                                'ValueType'  => 'String'
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                Item => 'OK',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue must be a scalar!',
        },
    },
    {
        Description => 'String with regex - fail',
        Config      => {
            XMLContentParsed => {
                Required => 0,
                Value    => [
                    {
                        'Item' => [
                            {
                                'Content'    => '3600',
                                'ValueRegex' => '\d{4}',
                                'ValueType'  => 'String'
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'OK12',
        },
        ExpectedResult => {
            Success => 0,
            Error   => "EffectiveValue not valid - regex '\\d{4}'!",
        },
    },
    {
        Description => 'Checkbox - pass 1',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '1',
                                'ValueType' => 'Checkbox',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '1',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => '1',
        },
    },
    {
        Description => 'Checkbox - pass 2',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '1',
                                'ValueType' => 'Checkbox',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '0',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => '0',
        },
    },
    {
        Description => 'Checkbox - invalid scalar',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '1',
                                'ValueType' => 'Checkbox',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'value',
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue must be 0 or 1 for Checkbox!',
        },
    },
    {
        Description => 'Checkbox - not scalar',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '1',
                                'ValueType' => 'Checkbox',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                Item => '1',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for Checkbox must be a scalar!',
        },
    },
    {
        Description => 'Date - pass',
        Config      => {
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
            EffectiveValue => '2016-02-02',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => '2016-02-02',
        },
    },
    {
        Description => 'Date - wrong format',
        Config      => {
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
            EffectiveValue => '02-02-2016',
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for Date(02-02-2016) must be in format YYYY-MM-DD!',
        },
    },
    {
        Description => 'Date - invalid date',
        Config      => {
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
            EffectiveValue => '2016-22-50',
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for Date(2016-22-50) must be in format YYYY-MM-DD!',
        },
    },
    {
        Description => 'Date - not scalar',
        Config      => {
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
            EffectiveValue => {
                Item => '2016-22-50',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for Date must be a scalar!',
        },
    },
    {
        Description => 'DateTime - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '2016-01-01 00:00:00',
                                'ValueType' => 'DateTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '2016-02-02 01:12:22',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => '2016-02-02 01:12:22',
        },
    },
    {
        Description => 'DateTime - wrong format',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '2016-01-01 00:00:00',
                                'ValueType' => 'DateTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '02-02-2016 01:01:01',
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for DateTime must be in format YYYY-MM-DD hh:mm:ss!',
        },
    },
    {
        Description => 'DateTime - invalid date',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '2016-01-01 00:00:00',
                                'ValueType' => 'DateTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '2016-01-01 70:02:23',
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for DateTime(2016-01-01 70:02:23) must be in format YYYY-MM-DD hh:mm:ss!',
        },
    },
    {
        Description => 'DateTime - not scalar',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '2016-01-01 00:00:00',
                                'ValueType' => 'DateTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                Item => '2016-22-50 01:00:00',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for DateTime must be a scalar!',
        },
    },
    {
        Description => 'Entity Priority - pass',
        Config      => {
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
            EffectiveValue => '2 low',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => '2 low',
        },
    },
    {
        Description => 'Entity Queue - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'         => 'Junk',
                                'ValueEntityType' => 'Queue',
                                'ValueType'       => 'Entity',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'Raw',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => 'Raw',
        },
    },
    {
        Description => 'Entity State - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'         => 'open',
                                'ValueEntityType' => 'State',
                                'ValueType'       => 'Entity',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'new',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => 'new',
        },
    },
    {
        Description => 'Entity Type - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'         => 'Unclassified',
                                'ValueEntityType' => 'Type',
                                'ValueType'       => 'Entity',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'Unclassified',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => 'Unclassified',
        },
    },
    {
        Description => 'Entity - not scalar',
        Config      => {
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
            EffectiveValue => {
                Item => '2 low',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for Entity must be scalar!',
        },
    },
    {
        Description => 'Entity - missing ValueEntityType',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '3 normal',
                                'ValueType' => 'Entity',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '2 low',
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'ValueEntityType not provided!',
        },
    },
    {
        Description => 'Entity Priority - fail',
        Config      => {
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
            EffectiveValue => 'not existing value',
        },
        ExpectedResult => {
            Success => 0,
            Error   => "Entity value is invalid(not existing value)!",
        },
    },
    {
        Description => 'Entity Queue - fail',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'         => 'Junk',
                                'ValueEntityType' => 'Queue',
                                'ValueType'       => 'Entity',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'not existing value',
        },
        ExpectedResult => {
            Success => 0,
            Error   => "Entity value is invalid(not existing value)!",
        },
    },
    {
        Description => 'Entity State - fail',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'         => 'open',
                                'ValueEntityType' => 'State',
                                'ValueType'       => 'Entity',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'not existing value',
        },
        ExpectedResult => {
            Success => 0,
            Error   => "Entity value is invalid(not existing value)!",
        },
    },
    {
        Description => 'Entity Type - fail',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'         => 'Unclassified',
                                'ValueEntityType' => 'Type',
                                'ValueType'       => 'Entity',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'not existing value',
        },
        ExpectedResult => {
            Success => 0,
            Error   => "Entity value is invalid(not existing value)!",
        },
    },

    {
        Description => 'File - Path pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '/etc/localtime',
                                'ValueType' => 'File',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '/etc/localtime',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => '/etc/localtime',
        },
    },
    {
        Description => 'File - Directory pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '/etc',
                                'ValueType' => 'Directory',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '/etc',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => '/etc',
        },
    },
    {
        Description => 'Directory - not scalar',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '/etc',
                                'ValueType' => 'Directory',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                Item => '/etc',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for Directory must be a scalar!',
        },
    },
    {
        Description => 'File - not scalar',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '/etc',
                                'ValueType' => 'File',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                Item => '/etc',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for File must be a scalar!',
        },
    },
    {
        Description => 'File - provide Directory instead.',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '/etc/localtime',
                                'ValueType' => 'File',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '/etc',
        },
        ExpectedResult => {
            Success => 0,
            Error   => '/etc is directory, but file is expected!',
        },
    },
    {
        Description => 'Directory - provide File instead.',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => '/etc',
                                'ValueType' => 'Directory',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '/etc/localtime',
        },
        ExpectedResult => {
            Success => 0,
            Error   => '/etc/localtime is not directory!',
        },
    },
    {
        Description => 'PerlModule - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'     => 'Kernel::System::Log::SysLog',
                                'ValueFilter' => 'Kernel/System/Log/*.pm',
                                'ValueType'   => 'PerlModule',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'Kernel::System::Log::SysLog',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => 'Kernel::System::Log::SysLog',
        },
    },
    {
        Description => 'PerlModule - not scalar',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'     => 'Kernel::System::Log::SysLog',
                                'ValueFilter' => 'Kernel/System/Log/*.pm',
                                'ValueType'   => 'PerlModule',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                Item => 'Kernel::System::Log::SysLog',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for PerlModule must be a scalar!',
        },
    },
    {
        Description => 'PerlModule - ValueFilter check failed',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'     => 'Kernel::System::Log::SysLog',
                                'ValueFilter' => 'Kernel/System/Log/*.pm',
                                'ValueType'   => 'PerlModule',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'Kernel::System::Ticket::Article',
        },
        ExpectedResult => {
            Success => 0,
            Error   => "Kernel::System::Ticket::Article doesn't satisfy ValueFilter(Kernel/System/Log/*.pm)!",
        },
    },
    {
        Description => 'PerlModule - invalid EffectiveValue',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'     => 'Kernel::System::Log::SysLog',
                                'ValueFilter' => 'Kernel/System/Log/*.pm',
                                'ValueType'   => 'PerlModule',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'Kernel::System::Log::SysLogs',
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Kernel::System::Log::SysLogs doesn\'t satisfy ValueFilter(Kernel/System/Log/*.pm)!',
        },
    },
    {
        Description => 'Select - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        'Content'   => 'Option 1',
                                        'Value'     => 'option-1',
                                        'ValueType' => 'Option',
                                    },
                                    {
                                        'Content'   => 'Option 2',
                                        'Value'     => 'option-2',
                                        'ValueType' => 'Option',
                                    },
                                ],
                                'SelectedID' => 'option-1',
                                'ValueType'  => 'Select',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'option-1',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => 'option-1',
        },
    },
    {
        Description => 'Select - not scalar',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        'Content'   => 'Option 1',
                                        'Value'     => 'option-1',
                                        'ValueType' => 'Option',
                                    },
                                    {
                                        'Content'   => 'Option 2',
                                        'Value'     => 'option-2',
                                        'ValueType' => 'Option',
                                    },
                                ],
                                'SelectedID' => 'option-1',
                                'ValueType'  => 'Select',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                Item => 'option-1',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for Select must be a scalar!',
        },
    },
    {
        Description => 'Select - option not found',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        'Content'   => 'Option 1',
                                        'Value'     => 'option-1',
                                        'ValueType' => 'Option',
                                    },
                                    {
                                        'Content'   => 'Option 2',
                                        'Value'     => 'option-2',
                                        'ValueType' => 'Option',
                                    },
                                ],
                                'SelectedID' => 'option-1',
                                'ValueType'  => 'Select',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'option-3',
        },
        ExpectedResult => {
            Success => 0,
            Error   => '\'option-3\' option not found in Select!',
        },
    },
    {
        Description => 'Textarea - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content' => '
Lorem ipsum...
                    ',
                                'Translatable' => '1',
                                'ValueType'    => 'Textarea',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '
            Another String

            Test
            ',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => '
            Another String

            Test
            ',
        },
    },
    {
        Description => 'Textarea - not scalar',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content' => '
Lorem ipsum...
                    ',
                                'Translatable' => '1',
                                'ValueType'    => 'Textarea',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                Item => '
            Another String

            Test
                ',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue must be a scalar!',
        },
    },
    {
        Description => 'TimeZone - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => 'UTC',
                                'ValueType' => 'TimeZone',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'UTC',
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => 'UTC',
        },
    },
    {
        Description => 'TimeZone - not scalar',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => 'UTC',
                                'ValueType' => 'TimeZone',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                Item => 'UTC',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for TimeZone must be a scalar!',
        },
    },
    {
        Description => 'TimeZone - invalid value',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'   => 'UTC',
                                'ValueType' => 'TimeZone',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'UTCs',
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'UTCs is not valid time zone!',
        },
    },
    {
        Description => 'VacationDays - pass',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '12' => {
                    '24' => 'Christmas Eve',
                },
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '12' => {
                    '24' => 'Christmas Eve',
                },
            },
        },
    },
    {
        Description => 'VacationDays - not hash',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'test'
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for VacationDays must be a hash!',
        },
    },
    {
        Description => 'VacationDays - Month 0',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '0' => {
                    '24' => 'Christmas Eve',
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'0' must be a month number(1..12)!",
        },
    },
    {
        Description => 'VacationDays - Month 13',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '13' => {
                    '24' => 'Christmas Eve',
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'13' must be a month number(1..12)!",
        },
    },
    {
        Description => 'VacationDays - Month March',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                'March' => {
                    '24' => 'Christmas Eve',
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'March' must be a month number(1..12)!",
        },
    },
    {
        Description => 'VacationDays - Month not a hash ref',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '2' => 'Test'
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'2' must be a hash reference!",
        },
    },
    {
        Description => 'VacationDays - Day is 0',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '2' => {
                    '0' => 'Test',
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'0' must be a day number(1..31)!",
        },
    },
    {
        Description => 'VacationDays - Day is 22',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '2' => {
                    '22' => 'Test',
                },
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '2' => {
                    '22' => 'Test',
                },
            },
        },
    },
    {
        Description => 'VacationDays - Day is 32',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '2' => {
                    '32' => 'Test',
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'32' must be a day number(1..31)!",
        },
    },
    {
        Description => 'VacationDays - Day is string',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '2' => {
                    'string' => 'Test',
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'string' must be a day number(1..31)!",
        },
    },
    {
        Description => 'VacationDays - Description is not string',
        Config      => {
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
                                ],
                                'ValueType' => 'VacationDays',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '1' => {
                    '1' => 'New Year\'s Day',
                },
                '2' => {
                    '2' => {
                        Item => 'Test',
                    },
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Vacation description must be a string!',
        },
    },
    {
        Description => 'VacationDaysOneTime - Pass',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => {
                    '2' => {
                        '2' => 'Test',
                    },
                },
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => {
                    '2' => {
                        '2' => 'Test',
                    },
                },
            },
        },
    },
    {
        Description => 'VacationDaysOneTime - not hash',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => "test",
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue for VacationDaysOneTime must be a hash!',
        },
    },
    {
        Description => 'VacationDaysOneTime - Year 999',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '999' => {
                    '2' => {
                        '2' => 'Test',
                    },
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'999' must be a year number(1000-9999)!",
        },
    },
    {
        Description => 'VacationDaysOneTime - Year 999',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '10000' => {
                    '2' => {
                        '2' => 'Test',
                    },
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'10000' must be a year number(1000-9999)!",
        },
    },
    {
        Description => 'VacationDaysOneTime - Year not hash ref',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => 'Test',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'2016' must be a hash reference!",
        },
    },
    {
        Description => 'VacationDaysOneTime - Month is 0',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => {
                    '0' => {
                        '1' => 'Test'
                    }
                }
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'0' must be a month number(1..12)!",
        },
    },
    {
        Description => 'VacationDaysOneTime - Month is 13',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => {
                    '13' => {
                        '1' => 'Test'
                    }
                }
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'13' must be a month number(1..12)!",
        },
    },
    {
        Description => 'VacationDaysOneTime - Month is 5',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => {
                    '5' => {
                        '1' => 'Test',
                    },
                },
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => {
                    '5' => {
                        '1' => 'Test',
                    },
                },
            },
        },
    },
    {
        Description => 'VacationDaysOneTime - Month is not hash ref',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => {
                    '5' => 'Test',
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'5' must be a hash reference!",
        },
    },
    {
        Description => 'VacationDaysOneTime - Day is 0',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => {
                    '5' => {
                        '0' => 'test',
                    },
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'0' must be a day number(1..31)!",
        },
    },
    {
        Description => 'VacationDaysOneTime - Day is 32',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => {
                    '5' => {
                        '32' => 'test',
                    },
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'32' must be a day number(1..31)!",
        },
    },
    {
        Description => 'VacationDaysOneTime - Day is 32',
        Config      => {
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
                                        'ValueYear'    => '2004',
                                    },
                                ],
                                'ValueType' => 'VacationDaysOneTime',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                '2014' => {
                    '1' => {
                        '1' => 'New Year\'s Day',
                    },
                },
                '2016' => {
                    '5' => {
                        '30' => {
                            Item => 'Test',
                        },
                    },
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "Vacation description must be a string!",
        },
    },
    {
        Description => 'WorkingHours - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => '8',
                                                'ValueType' => 'Hour',
                                            },
                                        ],
                                        'ValueName' => 'Tue',
                                        'ValueType' => 'Day',
                                    },
                                ],
                                'ValueType' => 'WorkingHours',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Fri' => [
                    '8',
                    '9',
                ],
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                'Fri' => [
                    '8',
                    '9',
                ],
            },
        },
    },
    {
        Description => 'WorkingHours - not hash',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => '8',
                                                'ValueType' => 'Hour',
                                            },
                                        ],
                                        'ValueName' => 'Tue',
                                        'ValueType' => 'Day',
                                    },
                                ],
                                'ValueType' => 'WorkingHours',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'Test',
        },
        ExpectedResult => {
            Success => 0,
            Error   => "EffectiveValue for WorkingHours must be a hash!",
        },
    },
    {
        Description => 'WorkingHours - month name wrong',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => '8',
                                                'ValueType' => 'Hour',
                                            },
                                        ],
                                        'ValueName' => 'Tue',
                                        'ValueType' => 'Day',
                                    },
                                ],
                                'ValueType' => 'WorkingHours',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Test' => '8',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'Test' must be Mon, Tue, Wed, Thu, Fri, Sat or Sun!",
        },
    },
    {
        Description => 'WorkingHours - day abbr. not ok',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => '8',
                                                'ValueType' => 'Hour',
                                            },
                                        ],
                                        'ValueName' => 'Tue',
                                        'ValueType' => 'Day',
                                    },
                                ],
                                'ValueType' => 'WorkingHours',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Mon' => '8',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'Mon' must be an array reference!",
        },
    },
    {
        Description => 'WorkingHours - Hour is string',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => '8',
                                                'ValueType' => 'Hour',
                                            },
                                        ],
                                        'ValueName' => 'Tue',
                                        'ValueType' => 'Day',
                                    },
                                ],
                                'ValueType' => 'WorkingHours',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Mon' => [
                    'test',
                ],
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'test' must be number(0-23)!",
        },
    },
    {
        Description => 'WorkingHours - Hour is 24',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => '8',
                                                'ValueType' => 'Hour',
                                            },
                                        ],
                                        'ValueName' => 'Tue',
                                        'ValueType' => 'Day',
                                    },
                                ],
                                'ValueType' => 'WorkingHours',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Mon' => [
                    '24',
                ],
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'24' must be number(0-23)!",
        },
    },
    {
        Description => 'Simple Hash - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Possible',
                                        'Key'     => 'Possible',
                                    },
                                    {
                                        'Content' => 'PossibleAdd',
                                        'Key'     => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Item1' => 'Value1',
                'Item2' => 'Value2',
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                'Item1' => 'Value1',
                'Item2' => 'Value2',
            },
        },
    },
    {
        Description => 'Simple Hash - value not hash',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Possible',
                                        'Key'     => 'Possible',
                                    },
                                    {
                                        'Content' => 'PossibleAdd',
                                        'Key'     => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => "test",
        },
        ExpectedResult => {
            Success => 0,
            Error   => "Its not a hash!",
        },
    },
    {
        Description => 'Hash - key should be an array reference #1',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Possible',
                                        'Key'     => 'Possible',
                                    },
                                    {
                                        'Array' => [
                                            {
                                                'Item' => [
                                                    'Content' => 'Value',
                                                ],
                                            },
                                        ],
                                        'Key' => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Item1'       => 'Value1',
                'PossibleAdd' => 'Value2',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "Item with key PossibleAdd must be an array reference!",
        },
    },
    {
        Description => 'Hash - key should be a hash reference #1',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Possible',
                                        'Key'     => 'Possible',
                                    },
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    'Content' => 'Value',
                                                    'Key'     => 'AnotherKey',
                                                ],
                                            },
                                        ],
                                        'Key' => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Item1'       => 'Value1',
                'PossibleAdd' => 'Value2',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "Item with key PossibleAdd must be a hash reference!",
        },
    },
    {
        Description => 'Hash - key should be an array reference #2',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Possible',
                                        'Key'     => 'Possible',
                                    },
                                    {
                                        'Array' => [
                                            {
                                                'Item' => [
                                                    'Content' => 'Value',
                                                ],
                                            },
                                        ],
                                        'Key' => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Item1'       => 'Value1',
                'PossibleAdd' => {
                    'Item' => 'value',
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Item with key PossibleAdd must be an array reference!',
        },
    },
    {
        Description => 'Hash - key should be a hash reference #2',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Possible',
                                        'Key'     => 'Possible',
                                    },
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    'Content' => 'Value',
                                                    'Key'     => 'test',
                                                ],
                                            },
                                        ],
                                        'Key' => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Item1'       => 'Value1',
                'PossibleAdd' => [
                    'test',
                ],
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Item with key PossibleAdd must be a hash reference!',
        },
    },
    {
        Description => 'HoH - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    {
                                                        'Content' => 'PossibleValue',
                                                        'Key'     => 'PossibleKey',
                                                    },
                                                ],
                                            },
                                        ],
                                        'Key' => 'Possible',
                                    },
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    {
                                                        'Content' => 'Value',
                                                        'Key'     => 'test',
                                                    },
                                                ],
                                            },
                                        ],
                                        'Key' => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Possible' => {
                    'PossibleKey' => 'UpdatedValue',
                },
                'PossibleAdd' => {
                    'test' => 'Value',
                },
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                'Possible' => {
                    'PossibleKey' => 'UpdatedValue',
                },
                'PossibleAdd' => {
                    'test' => 'Value',
                },
            },
        },
    },
    {
        Description => 'HoH - expected hash, but array provided',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    {
                                                        'Content' => 'PossibleValue',
                                                        'Key'     => 'PossibleKey',
                                                    },
                                                ],
                                            },
                                        ],
                                        'Key' => 'Possible',
                                    },
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    {
                                                        'Content' => 'Value',
                                                        'Key'     => 'test',
                                                    },
                                                ],
                                            },
                                        ],
                                        'Key' => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Possible' => {
                    'PossibleKey' => 'UpdatedValue',
                },
                'PossibleAdd' => [
                    'Item',
                ],
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Item with key PossibleAdd must be a hash reference!',
        },
    },
    {
        Description => 'Hash, fail 2nd item should be scalar, but hash provided',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    {
                                                        'Content' => 'PossibleValue',
                                                        'Key'     => 'PossibleKey',
                                                    },
                                                ],
                                            },
                                        ],
                                        'Key' => 'Possible',
                                    },
                                    {
                                        'Content' => 'Test',
                                        'Key'     => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Possible' => {
                    'PossibleKey' => 'UpdatedValue',
                },
                'PossibleAdd' => {
                    'PossibleKey' => 'UpdatedValue',
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Item with key PossibleAdd must be a scalar!',
        },
    },
    {
        Description => 'HoH fail - key not defined in hash - default fallback is String.',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    {
                                                        'Content' => 'EPPPossibleValue',
                                                        'Key'     => 'PossibleKey',
                                                    },
                                                ],
                                            },
                                        ],
                                        'Key' => 'Possible',
                                    },
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    {
                                                        'Content' => 'Value',
                                                        'Key'     => 'test',
                                                    },
                                                ],
                                            },
                                        ],
                                        'Key' => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Possible' => {
                    'PossibleKey' => 'UpdatedValue',
                },
                'NewKey' => [
                    'Item',
                ],
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Item with key NewKey must be a scalar!',
        },
    },
    {
        Description => 'HoH pass - key not defined in hash.',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    {
                                                        'Content' => 'PossibleValue',
                                                        'Key'     => 'PossibleKey',
                                                    },
                                                ],
                                            },
                                        ],
                                        'Key' => 'Possible',
                                    },
                                    {
                                        'Hash' => [
                                            {
                                                'Item' => [
                                                    {
                                                        'Content' => 'Value',
                                                        'Key'     => 'test',
                                                    },
                                                ],
                                            },
                                        ],
                                        'Key' => 'PossibleAdd',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'Possible' => {
                    'PossibleKey' => 'UpdatedValue',
                },
                'NewKey' => 'Test',
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                'Possible' => {
                    'PossibleKey' => 'UpdatedValue',
                },
                'NewKey' => 'Test',
            },
        },
    },
    {
        Description => 'Empty Hash pass - new value',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'NewKey1' => 'NewValue1',
                'NewKey2' => 'NewValue2',
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                'NewKey1' => 'NewValue1',
                'NewKey2' => 'NewValue2',
            },
        },
    },
    {
        Description => 'Empty Hash fail - try to set complex structure 1',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'NewKey1' => {
                    'Key' => 'Value',
                },
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Item with key NewKey1 must be a scalar!',
        },
    },
    {
        Description => 'Empty Hash fail - try to set complex structure 2',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'NewKey1' => [
                    'Value',
                ],
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Item with key NewKey1 must be a scalar!',
        },
    },
    {
        Description => 'Simple array - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                'Value',
            ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [
                'Value',
            ],
        },
    },
    {
        Description => 'Simple array - value not array',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'Value',
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Its not an array!',
        },
    },
    {
        Description => 'AoH pass - default item is hash',
        Config      => {
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
                                                        'Key'     => 'Key',
                                                        'Content' => 'Value',
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
                                                        'Key'     => 'Key',
                                                        'Content' => 'Value',
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
                                                        'Key'     => 'Key',
                                                        'Content' => 'Value',
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
            EffectiveValue => [
                {
                    'Key' => 'Value',
                },
                {
                    'Key' => 'Value2',
                },
            ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [
                {
                    'Key' => 'Value',
                },
                {
                    'Key' => 'Value2',
                },
            ],
        },
    },
    {
        Description => 'AoA deep pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'Array' => [
                                            {
                                                'DefaultItem' => [
                                                    {
                                                        'Content' => 'Value',
                                                    },
                                                ],
                                                'Item' => [
                                                    {
                                                        'Content' => 'Value',
                                                    },
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
                                                        'Content' => 'Value',
                                                    },
                                                    {
                                                        'Content' => 'Value 2',
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
            EffectiveValue => [
                [
                    'SubArray',
                    'SubArray2',
                ],
                [
                    'SubArray',
                ],
                [],
            ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [
                [
                    'SubArray',
                    'SubArray2',
                ],
                [
                    'SubArray',
                ],
                [],
            ],
        },
    },
    {
        Description => 'Empty array - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'Item' => [
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                'Value',
            ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [
                'Value',
            ],
        },
    },
    {
        Description => 'Empty array - fail',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'Item' => [
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                {
                    'Key' => 'Value',
                },
            ],
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Item with index 0 must be a scalar!',
        },
    },
    {
        Description => 'Hash of Select items - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'DefaultItem' => [
                                    {
                                        # 'Item' => [
                                        #     {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-1',
                                        'ValueType'  => 'Select',

                                        #     },
                                        # ],
                                    },
                                ],
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-1',
                                        'ValueType'  => 'Select',
                                        'Key'        => 'First',
                                    },
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 3',
                                                'Value'     => 'option-3',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 4',
                                                'Value'     => 'option-4',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-3',
                                        'ValueType'  => 'Select',
                                        'Key'        => 'Second',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'First'  => 'option-1',
                'Second' => 'option-3',
                'Third'  => 'option-2',
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                'First'  => 'option-1',
                'Second' => 'option-3',
                'Third'  => 'option-2',
            },
        },
    },
    {
        Description => 'Hash of Select items - fail #1',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-1',
                                        'ValueType'  => 'Select',
                                        'Key'        => 'First',
                                    },
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 3',
                                                'Value'     => 'option-3',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 4',
                                                'Value'     => 'option-4',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-3',
                                        'ValueType'  => 'Select',
                                        'Key'        => 'Second',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'First'  => 'option-1',
                'Second' => 'option-2',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'option-2' option not found in Select!",
        },
    },
    {
        Description => 'Hash of Select items - fail #2',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'DefaultItem' => [
                                    {
                                        # 'Item' => [
                                        #     {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-1',
                                        'ValueType'  => 'Select',

                                        #     },
                                        # ],
                                        'Key' => 'First',
                                    },
                                ],
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-1',
                                        'ValueType'  => 'Select',
                                        'Key'        => 'First',
                                    },
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 3',
                                                'Value'     => 'option-3',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 4',
                                                'Value'     => 'option-4',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-3',
                                        'ValueType'  => 'Select',
                                        'Key'        => 'Second',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'First'  => 'option-1',
                'Second' => 'option-3',
                'Third'  => 'option-3',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'option-3' option not found in Select!",
        },
    },
    {
        Description => 'Hash of Directory items - fail#1',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'ValueType' => 'Directory',
                                        'Content'   => '/etc',
                                    },
                                ],
                                'Item' => [
                                    {
                                        'ValueType' => 'Directory',
                                        'Content'   => '/etc',
                                        'Key'       => 'First',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'First'  => '/etc',
                'Second' => '/not_existsing_folder',
            },
        },
        ExpectedResult => {
            Success => 0,
            'Error' => '/not_existsing_folder not exists!',
        },
    },
    {
        Description => 'Hash of File items - fail#1',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'ValueType' => 'File',
                                        'Content'   => '/etc/localtime',
                                    },
                                ],
                                'Item' => [
                                    {
                                        'ValueType' => 'File',
                                        'Content'   => '/etc/localtime',
                                        'Key'       => 'First',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'First'  => '/etc/localtime',
                'Second' => '/not_existsing_file.src',
            },
        },
        ExpectedResult => {
            Success => 0,
            'Error' => '/not_existsing_file.src not exists!',
        },
    },
    {
        Description => 'Hash of Directory items - fail#2',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'ValueType' => 'Directory',
                                        'Content'   => '/etc',
                                    },
                                ],
                                'Item' => [
                                    {
                                        'ValueType' => 'Directory',
                                        'Content'   => '/etc',
                                        'Key'       => 'First',
                                    },
                                    {
                                        'ValueType' => 'String',
                                        'Content'   => 'Text',
                                        'Key'       => 'RequiredKey',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'First' => '/etc',
            },
        },
        ExpectedResult => {
            Success => 0,
            'Error' => 'Missing key RequiredKey!',
        },
    },
    {
        Description => 'Hash of File items - fail#2',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'ValueType' => 'File',
                                        'Content'   => '/etc/localtime',
                                    },
                                ],
                                'Item' => [
                                    {
                                        'ValueType' => 'File',
                                        'Content'   => '/etc/localtime',
                                        'Key'       => 'First',
                                    },
                                    {
                                        'ValueType' => 'String',
                                        'Content'   => 'Text',
                                        'Key'       => 'RequiredKey',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'First' => '/etc/localtime',
            },
        },
        ExpectedResult => {
            Success => 0,
            'Error' => 'Missing key RequiredKey!',
        },
    },
    {
        Description => 'Array of Select items - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-1',
                                        'ValueType'  => 'Select',
                                    },
                                ],
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-1',
                                        'ValueType'  => 'Select',
                                    },
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-2',
                                        'ValueType'  => 'Select',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                'option-1',
                'option-2',
                'option-1',
            ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [
                'option-1',
                'option-2',
                'option-1',
            ],
        },
    },
    {
        Description => 'Array of Select items - fail #1',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-1',
                                        'ValueType'  => 'Select',
                                    },
                                ],
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-1',
                                        'ValueType'  => 'Select',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                'option-1',
                'option-2',
                'option-3',
            ],
        },
        ExpectedResult => {
            Success => 0,
            Error   => "'option-3' option not found in Select!",
        },
    },
    {
        Description => 'Hash with defined ValueType - pass #1',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {

                                        'Item' => [
                                            {
                                                'Content'   => 'Option 1',
                                                'Value'     => 'option-1',
                                                'ValueType' => 'Option',
                                            },
                                            {
                                                'Content'   => 'Option 2',
                                                'Value'     => 'option-2',
                                                'ValueType' => 'Option',
                                            },
                                        ],
                                        'SelectedID' => 'option-1',
                                        'ValueType'  => 'Select',
                                        'Key'        => 'SelectItem',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'SelectItem' => 'option-1',
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                'SelectItem' => 'option-1',
            },
        },
    },
    {
        Description => 'Simple array (MinItems) - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                    },
                                    {
                                        'Content' => 'Value',
                                    },
                                ],
                                'MinItems' => 1,
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                'Value1',
            ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [
                'Value1',
            ],
        },
    },
    {
        Description => 'Simple array (MinItems) - fail',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                    },
                                    {
                                        'Content' => 'Value',
                                    },
                                ],
                                'MinItems' => 1,
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [],
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Number of items in array is less than MinItems(1)!',
        },
    },
    {
        Description => 'Simple array (MinItems) - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                    },
                                    {
                                        'Content' => 'Value',
                                    },
                                ],
                                'MinItems' => 1,
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                'Value1',
            ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [
                'Value1',
            ],
        },
    },
    {
        Description => 'Simple array (MaxItems) - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                    },
                                    {
                                        'Content' => 'Value',
                                    },
                                ],
                                'MaxItems' => 3,
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                'Value',
                'Value',
                'Value',
            ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [
                'Value',
                'Value',
                'Value',
            ],
        },
    },
    {
        Description => 'Simple array (MaxItems) - fail',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                    },
                                    {
                                        'Content' => 'Value',
                                    },
                                ],
                                'MaxItems' => 3,
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                'Value',
                'Value',
                'Value',
                'Value',
            ],
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Number of items in array is more than MaxItems(3)!',
        },
    },
    {
        Description => 'Simple hash (MinItems) - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                        'Key'     => 'One',
                                    },
                                    {
                                        'Content' => 'Value',
                                        'Key'     => 'Two',
                                    },
                                ],
                                'MinItems' => 1,
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'One' => 'Value1',
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                'One' => 'Value1',
            },
        },
    },
    {
        Description => 'Simple hash (MinItems) - fail',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                        'Key'     => 'One',
                                    },
                                    {
                                        'Content' => 'Value',
                                        'Key'     => 'Two',
                                    },
                                ],
                                'MinItems' => 1,
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {},
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Number of items in hash is less than MinItems(1)!',
        },
    },
    {
        Description => 'Simple hash (MaxItems) - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                        'Key'     => 'One',
                                    },
                                    {
                                        'Content' => 'Value',
                                        'Key'     => 'Two',
                                    },
                                ],
                                'MaxItems' => 3,
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'One'  => 'Value1',
                'Two'  => 'Value2',
                'Tree' => 'Value3',
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                'One'  => 'Value1',
                'Two'  => 'Value2',
                'Tree' => 'Value3',
            },
        },
    },
    {
        Description => 'Simple hash (MaxItems) - fail',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'Item' => [
                                    {
                                        'Content' => 'Value',
                                        'Key'     => 'One',
                                    },
                                    {
                                        'Content' => 'Value',
                                        'Key'     => 'Two',
                                    },
                                ],
                                'MaxItems' => 3,
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => {
                'One'  => 'Value1',
                'Two'  => 'Value2',
                'Tree' => 'Value3',
                'Four' => 'Value4',
            },
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'Number of items in hash is more than MaxItems(3)!',
        },
    },
    {
        Description => 'Simple array of Strings with Regex - pass',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'Content' => 'Value1',
                                        'Regex'   => '^Value\d+$',
                                    },
                                ],
                                'Item' => [
                                    {
                                        'Content' => 'Value1',
                                        'Regex'   => '^Value\d+$',
                                    },
                                    {
                                        'Content' => 'Value2',
                                        'Regex'   => '^Value\d+$',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                'Value443',
                'Value4',
                'Value0',
            ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [
                'Value443',
                'Value4',
                'Value0',
            ],
        },
    },
    {
        Description => 'Simple array of Strings with Regex - fail',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content' => 'Value1',
                                            },
                                        ],
                                        'ValueRegex' => '^Value\d+$',
                                    },
                                ],
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content' => 'Value1',
                                            },
                                        ],
                                        'ValueRegex' => '^Value\d+$',
                                    },
                                    {
                                        'Item' => [
                                            {
                                                'Content' => 'Value2',
                                            },
                                        ],
                                        'ValueRegex' => '^Value\d+$',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [
                'Value443',
                'Value',
                'Value0',
            ],
        },
        ExpectedResult => {
            Success => 0,
            Error   => 'EffectiveValue not valid - regex \'^Value\\d+$\'!',
        },
    },
    {
        Description => 'Simple array of Strings with Regex - Not fail due NoValidation flag',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Array' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content' => 'Value1',
                                            },
                                        ],
                                        'ValueRegex' => '^Value\d+$',
                                    },
                                ],
                                'Item' => [
                                    {
                                        'Item' => [
                                            {
                                                'Content' => 'Value1',
                                            },
                                        ],
                                        'ValueRegex' => '^Value\d+$',
                                    },
                                    {
                                        'Item' => [
                                            {
                                                'Content' => 'Value2',
                                            },
                                        ],
                                        'ValueRegex' => '^Value\d+$',
                                    },
                                ],
                            },
                        ],
                    },
                ],
            },
            NoValidation   => 1,
            EffectiveValue => [
                'Value443',
                'Value',
                'Value0',
            ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [
                'Value443',
                'Value',
                'Value0',
            ],
        },
    },
    {
        Description => 'HoAoA',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Hash' => [
                            {
                                'DefaultItem' => [
                                    {
                                        'Array' => [
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
                                'Item' => [
                                    {
                                        'Array' => [
                                            {
                                                'Item' => [
                                                    {
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
                                        'Key' => 'First',
                                    },
                                    {
                                        'Key'   => 'Second',
                                        'Array' => [
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
            EffectiveValue => {
                'Second' => [
                    [
                        '3',
                        '5',
                    ],
                ],
                'First' => [
                    [
                        '1',
                        '2',
                    ],
                ],
            },
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => {
                'Second' => [
                    [
                        '3',
                        '5',
                    ],
                ],
                'First' => [
                    [
                        '1',
                        '2',
                    ],
                ],
            },
        },
    },
    {
        Description => 'Wrong type - Validation Enabled',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'      => 'Lorem ipsum...',
                                'Translatable' => '1',
                                'ValueType'    => 'MAL',
                            },
                        ],
                    },
                ],
            },
            EffectiveValue => [ 'AWrong', 'Value' ],
        },
        ExpectedResult => {
            Error   => 'Kernel::System::SysConfig::ValueType::MAL',
            Success => 0,
        },
    },
    {
        Description => 'Wrong type - No validation',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        'Item' => [
                            {
                                'Content'      => 'Lorem ipsum...',
                                'Translatable' => '1',
                                'ValueType'    => 'MAL',
                            },
                        ],
                    },
                ],
            },
            NoValidation   => 1,
            EffectiveValue => [ 'AWrong', 'Value' ],
        },
        ExpectedResult => {
            Success        => 1,
            EffectiveValue => [ 'AWrong', 'Value' ],
        },
    },
);

for my $Test (@Tests) {

    my %Result = $SysConfigObject->SettingEffectiveValueCheck(
        %{ $Test->{Config} },
        UserID => 1,
    );

    delete $Result{ExpireTime};

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': SettingEffectiveValueCheck(): Result must match expected one.',
    );
}

# Another test block
my @SettingList = $SysConfigDBObject->DefaultSettingListGet();

my @SkipTests = (
    'Fetchmail::Bin',
    'PGP::Bin',
    'SMIME::CertPath',
    'SMIME::PrivatePath',
    'SMIME::Bin',
);

SETTING:
for my $Setting (@SettingList) {

    next SETTING if grep { $_ eq $Setting->{Name} } @SkipTests;
    next SETTING if !$Setting->{IsValid};

    my %Result = $SysConfigObject->SettingEffectiveValueCheck(
        SettingUID       => $Setting->{SettingUID},
        XMLContentParsed => $Setting->{XMLContentParsed},
        EffectiveValue   => $Setting->{EffectiveValue},
        StoreCache       => 1,
        UserID           => 1,
    );

    delete $Result{ExpireTime};

    $Self->IsDeeply(
        \%Result,
        {
            Success        => 1,
            EffectiveValue => $Setting->{EffectiveValue},
        },
        "Check EffectiveValue for $Setting->{Name}."
    );
}

$HelperObject->FixedTimeAddSeconds( 60 * 60 * 24 * 35 );    # Add 35 days, it should be enough to make results obsolete.

# Make sure to reset delete cache flag.
$SysConfigObject->{EffectiveValueCheckCacheDeleted} = 0;

# Make sure that expired parts of the cache are deleted.
my ($HookSetting) = grep { $_->{Name} eq 'Ticket::Hook' } @SettingList;

# Check if value is ok - it also clears expired parts.
my %HookCheck = $SysConfigObject->SettingEffectiveValueCheck(
    %{$HookSetting},
    EffectiveValue => 'NewEffectiveValue',
    StoreCache     => 1,
    UserID         => 1,
);

# Get cache value directly.
my $Cached = $Kernel::OM->Get('Kernel::System::Cache')->Get(
    Type => 'SysConfigPersistent',
    Key  => "EffectiveValueCheck::0",
);

# Delete our latest check result.
delete $Cached->{ $HookSetting->{SettingUID} . '::NewEffectiveValue' };

$Self->IsDeeply(
    $Cached,
    {},
    'Make sure that all other parts of cache are deleted (they are expired).'
);

# Cache tests
@Tests = (
    {
        Description => 'Correct string',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        Item => [
                            {
                                Content => 'string',

                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'another string',
            SettingUID     => 'Test007',
            StoreCache     => 1,
            UserID         => 1,
        },
        Success => 1,
    },
    {
        Description => 'Correct priority',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        Item => [
                            {
                                Content         => '3 normal',
                                ValueEntityType => 'Priority',
                                ValueType       => 'Entity',

                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '2 low',
            SettingUID     => 'Test123',
            StoreCache     => 1,
            UserID         => 1,
        },
        EffectiveValueWrong => 'any string',
        Success             => 1,
    },
    {
        Description => 'Wrong SettingUID (but succeed)',    # this will succeed due the cache
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        Item => [
                            {
                                Content         => '3 normal',
                                ValueEntityType => 'Priority',
                                ValueType       => 'Entity',

                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'another string',
            SettingUID     => 'Test007',
            StoreCache     => 1,
            UserID         => 1,
        },
        Success => 1,
    },
    {
        Description => 'Wrong priority Different SettingUID',
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        Item => [
                            {
                                Content         => '3 normal',
                                ValueEntityType => 'Priority',
                                ValueType       => 'Entity',

                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'another string',
            SettingUID     => 'Test456',
            StoreCache     => 1,
            UserID         => 1,
        },
        Success => 0,
    },

    {
        Description => 'Correct priority with wrong SettingUID',    # this works because the values is new
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        Item => [
                            {
                                Content         => '3 normal',
                                ValueEntityType => 'Priority',
                                ValueType       => 'Entity',

                            },
                        ],
                    },
                ],
            },
            EffectiveValue => '2 low',
            SettingUID     => 'Test456',
            StoreCache     => 1,
            UserID         => 1,
        },
        Success => 1,
    },

    {
        Description => 'Correct string',    # This fails due the cache
        Config      => {
            XMLContentParsed => {
                Value => [
                    {
                        Item => [
                            {
                                Content => 'string',

                            },
                        ],
                    },
                ],
            },
            EffectiveValue => 'another string',
            SettingUID     => 'Test456',
            StoreCache     => 1,
            UserID         => 1,
        },
        Success => 0,
    },
);

for my $Test (@Tests) {
    my %Result = $SysConfigObject->SettingEffectiveValueCheck( %{ $Test->{Config} } );
    delete $Result{ExpireTime};

    $Self->Is(
        $Result{Success},
        $Test->{Success},
        "$Test->{Description} SettingEffectiveValueCheck() result"
    );

    my %ResultCached = $SysConfigObject->SettingEffectiveValueCheck( %{ $Test->{Config} } );
    delete $ResultCached{ExpireTime};

    $Self->IsDeeply(
        \%ResultCached,
        \%Result,
        "$Test->{Description} SettingEffectiveValueCheck() result cached"
    );

    if ( $Test->{Success} && $Test->{EffectiveValueWrong} ) {
        my %Result = $SysConfigObject->SettingEffectiveValueCheck(
            %{ $Test->{Config} },
            EffectiveValue => $Test->{EffectiveValueWrong}
        );
        delete $Result{ExpireTime};

        $Self->Is(
            $Result{Success},
            0,
            "$Test->{Description} SettingEffectiveValueCheck() result (with wrong value)",
        );

    }
}

1;
