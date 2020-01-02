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

use Kernel::System::VariableCheck qw( IsHashRefWithData );

use vars (qw($Self));

#use Kernel::Config;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
my $DBObject          = $Kernel::OM->Get('Kernel::System::DB');
my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');
my $YAMLObject        = $Kernel::OM->Get('Kernel::System::YAML');

my $RandomID = $HelperObject->GetRandomID();

$HelperObject->FixedTimeSet();

# Delete sysconfig_modified_version
my $SQLDeleteModifiedSettingsVersion = 'DELETE FROM sysconfig_modified_version';
return if !$DBObject->Do(
    SQL => $SQLDeleteModifiedSettingsVersion,
);

# Delete sysconfig_modified
my $SQLDeleteModifiedSettings = 'DELETE FROM sysconfig_modified';
return if !$DBObject->Do(
    SQL => $SQLDeleteModifiedSettings,
);

# Delete sysconfig_default_version
my $SQLDeleteDefaultSettingsVersion = 'DELETE FROM sysconfig_default_version';
return if !$DBObject->Do(
    SQL => $SQLDeleteDefaultSettingsVersion,
);

# Delete sysconfig_default
my $SQLDeleteDefaultSettings = 'DELETE FROM sysconfig_default';
return if !$DBObject->Do(
    SQL => $SQLDeleteDefaultSettings,
);

my $LoadSuccess = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/AdminSystemConfiguration/",
    Force     => 1,
    CleanUp   => 1,
);

$Self->True(
    $LoadSuccess,
    "Example XML files loaded successfully.",
);

my @Tests = (
    {
        Description => 'ExampleCheckbox1 valid',
        Config      => {
            Name           => 'ExampleCheckbox1',
            EffectiveValue => '1',
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleCheckbox1 invalid',
        Config      => {
            Name           => 'ExampleCheckbox1',
            EffectiveValue => '2',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleDate valid',
        Config      => {
            Name           => 'ExampleDate',
            EffectiveValue => '2017-01-01',
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleDate invalid',
        Config      => {
            Name           => 'ExampleDate',
            EffectiveValue => '3',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleDateTime valid',
        Config      => {
            Name           => 'ExampleDateTime',
            EffectiveValue => '2017-01-01 00:00:12',
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleDateTime invalid',
        Config      => {
            Name           => 'ExampleDateTime',
            EffectiveValue => '3',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleEntityPriority valid',
        Config      => {
            Name           => 'ExampleEntityPriority',
            EffectiveValue => '4 high',
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleEntityPriority invalid',
        Config      => {
            Name           => 'ExampleEntityPriority',
            EffectiveValue => '3 high',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleEntityQueue valid',
        Config      => {
            Name           => 'ExampleEntityQueue',
            EffectiveValue => 'Raw',
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleEntityQueue invalid',
        Config      => {
            Name           => 'ExampleEntityQueue',
            EffectiveValue => 'not_Existing_queue$',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleDirectory valid',
        Config      => {
            Name           => 'ExampleDirectory',
            EffectiveValue => '/etc',
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleDirectory invalid',
        Config      => {
            Name           => 'ExampleDirectory',
            EffectiveValue => '/not_Existing_directory$',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleFile valid',
        Config      => {
            Name           => 'ExampleFile',
            EffectiveValue => '/etc/hosts',
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleFile invalid',
        Config      => {
            Name           => 'ExampleFile',
            EffectiveValue => '/not_Existing_File$.txt',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExamplePerlModule valid',
        Config      => {
            Name           => 'ExamplePerlModule',
            EffectiveValue => 'Kernel::System::Log::SysLog',
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExamplePerlModule invalid',
        Config      => {
            Name           => 'ExamplePerlModule',
            EffectiveValue => '/not_Existing_PerlModule$.pm',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleSelect valid',
        Config      => {
            Name           => 'ExampleSelect',
            EffectiveValue => 'option-1',
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleSelect invalid',
        Config      => {
            Name           => 'ExampleSelect',
            EffectiveValue => 'option-3',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleTimeZone valid',
        Config      => {
            Name           => 'ExampleTimeZone',
            EffectiveValue => 'UTC',
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleTimeZone invalid',
        Config      => {
            Name           => 'ExampleTimeZone',
            EffectiveValue => 'ZTCX',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleVacationDays valid',
        Config      => {
            Name           => 'ExampleVacationDays',
            EffectiveValue => {
                '1' => {
                    '2' => 'Test',
                },
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleVacationDays invalid 1',
        Config      => {
            Name           => 'ExampleVacationDays',
            EffectiveValue => 'ZTCX',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleVacationDays invalid 2',
        Config      => {
            Name           => 'ExampleVacationDays',
            EffectiveValue => {
                '1' => 'Test',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleVacationDays invalid 3',
        Config      => {
            Name           => 'ExampleVacationDays',
            EffectiveValue => {
                '1' => {
                    '1' => ['Test'],
                },
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleVacationDays invalid 4',
        Config      => {
            Name           => 'ExampleVacationDays',
            EffectiveValue => {
                '1' => {
                    '55' => 'Test',
                },
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleVacationDaysOneTime valid',
        Config      => {
            Name           => 'ExampleVacationDaysOneTime',
            EffectiveValue => {
                '2017' => {
                    '1' => {
                        '2' => 'Test',
                    },
                },
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleVacationDaysOneTime invalid 1',
        Config      => {
            Name           => 'ExampleVacationDaysOneTime',
            EffectiveValue => 'ZTCX',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleVacationDaysOneTime invalid 2',
        Config      => {
            Name           => 'ExampleVacationDaysOneTime',
            EffectiveValue => {
                '2017' => 'Test',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleVacationDaysOneTime invalid 3',
        Config      => {
            Name           => 'ExampleVacationDaysOneTime',
            EffectiveValue => {
                '2017' => {
                    '1' => 'Test',
                },
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleVacationDaysOneTime invalid 4',
        Config      => {
            Name           => 'ExampleVacationDaysOneTime',
            EffectiveValue => {
                '2017' => {
                    '1' => {
                        '1' => ['Test'],
                    },
                },
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleVacationDaysOneTime invalid 5',
        Config      => {
            Name           => 'ExampleVacationDaysOneTime',
            EffectiveValue => {
                '2017' => {
                    '1' => {
                        '55' => 'Test',
                    },
                },
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleWorkingHours valid',
        Config      => {
            Name           => 'ExampleWorkingHours',
            EffectiveValue => {
                'Fri' => [ '8', '9' ],
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleWorkingHours invalid 1',
        Config      => {
            Name           => 'ExampleWorkingHours',
            EffectiveValue => 'ZTCX',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleWorkingHours invalid 2',
        Config      => {
            Name           => 'ExampleWorkingHours',
            EffectiveValue => {
                'Fri' => 'test',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleWorkingHours invalid 3',
        Config      => {
            Name           => 'ExampleWorkingHours',
            EffectiveValue => {
                'Fri' => ['test'],
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArray valid',
        Config      => {
            Name           => 'ExampleArray',
            EffectiveValue => [ '8', '9' ],
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleArray invalid 1',
        Config      => {
            Name           => 'ExampleArray',
            EffectiveValue => 'ZTCX',
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArray invalid 2',
        Config      => {
            Name           => 'ExampleArray',
            EffectiveValue => { 'ZTCX' => 1 },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArraySelect valid',
        Config      => {
            Name           => 'ExampleArraySelect',
            EffectiveValue => [ 'option-1', 'option-2' ],
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleArraySelect invalid 1',
        Config      => {
            Name           => 'ExampleArraySelect',
            EffectiveValue => [ 'option-1', 'option-3' ],
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArrayCheckbox valid',
        Config      => {
            Name           => 'ExampleArrayCheckbox',
            EffectiveValue => [ '0', '1' ],
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleArrayCheckbox invalid 1',
        Config      => {
            Name           => 'ExampleArrayCheckbox',
            EffectiveValue => [ 'option-1', '0' ],
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArrayDate valid',
        Config      => {
            Name           => 'ExampleArrayDate',
            EffectiveValue => [ '2016-02-02', '2016-02-03' ],
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleArrayDate invalid 1',
        Config      => {
            Name           => 'ExampleArrayDate',
            EffectiveValue => [ '2016-02-02', '2016-02-55' ],
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArrayDateTime valid',
        Config      => {
            Name           => 'ExampleArrayDateTime',
            EffectiveValue => [ '2016-02-02 01:45:55', '2016-02-02 01:45:59' ],
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleArrayDateTime invalid 1',
        Config      => {
            Name           => 'ExampleArrayDateTime',
            EffectiveValue => [ '2016-02-02 01:45:55', '2016-02-02 01:45:65' ],
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArrayEntity valid',
        Config      => {
            Name           => 'ExampleArrayEntity',
            EffectiveValue => [ '2 low', '3 normal' ],
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleArrayEntity invalid 1',
        Config      => {
            Name           => 'ExampleArrayEntity',
            EffectiveValue => [ '3 normal', '2 high' ],
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArrayDirectory valid',
        Config      => {
            Name           => 'ExampleArrayDirectory',
            EffectiveValue => [ '/etc', '/usr' ],
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleArrayDirectory invalid 1',
        Config      => {
            Name           => 'ExampleArrayDirectory',
            EffectiveValue => [ '/etc', '/etcfaewgf' ],
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArrayFile valid',
        Config      => {
            Name           => 'ExampleArrayFile',
            EffectiveValue => [ '/etc/hosts', '/etc/passwd' ],
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleArrayFile invalid 1',
        Config      => {
            Name           => 'ExampleArrayFile',
            EffectiveValue => [ '/etc/passwd', '/etc/passwddfafw' ],
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArrayPerlModule valid',
        Config      => {
            Name           => 'ExampleArrayPerlModule',
            EffectiveValue => [ 'Kernel::System::Log::SysLog', 'Kernel::System::Log::File' ],
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleArrayPerlModule invalid 1',
        Config      => {
            Name           => 'ExampleArrayPerlModule',
            EffectiveValue => [ 'Kernel::System::Log::File', 'Kernel::System::Log::Files' ],
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleArrayTimeZone valid',
        Config      => {
            Name           => 'ExampleArrayTimeZone',
            EffectiveValue => [ 'UTC', 'Europe/Berlin' ],
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleArrayTimeZone invalid 1',
        Config      => {
            Name           => 'ExampleArrayTimeZone',
            EffectiveValue => [ 'UTC', 'Europe/Berlins' ],
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashSelect1 valid',
        Config      => {
            Name           => 'ExampleHashSelect1',
            EffectiveValue => {
                'String' => 'Test',
                'Select' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashSelect1 invalid 1',
        Config      => {
            Name           => 'ExampleHashSelect1',
            EffectiveValue => {
                'String' => 'Test',
                'Select' => 'Malasasdfw',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashSelect2 valid',
        Config      => {
            Name           => 'ExampleHashSelect2',
            EffectiveValue => {
                'Available' => '1',
                'Select'    => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashSelect2 invalid 1',
        Config      => {
            Name           => 'ExampleHashSelect2',
            EffectiveValue => {
                'Available' => '0',
                't'         => 'Male',
                's'         => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashCheckbox1 valid',
        Config      => {
            Name           => 'ExampleHashCheckbox1',
            EffectiveValue => {
                'Checkbox' => '1',
                'Text'     => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashCheckbox1 invalid 1',
        Config      => {
            Name           => 'ExampleHashCheckbox1',
            EffectiveValue => {
                'Checkbox' => 'test',
                'Text'     => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashCheckbox2 valid',
        Config      => {
            Name           => 'ExampleHashCheckbox2',
            EffectiveValue => {
                'Checkbox' => '1',
                'String'   => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashCheckbox2 invalid 1',
        Config      => {
            Name           => 'ExampleHashCheckbox2',
            EffectiveValue => {
                'Checkboxa' => 'test77',
                'String'    => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashDate1 valid',
        Config      => {
            Name           => 'ExampleHashDate1',
            EffectiveValue => {
                'Date' => '2017-01-01',
                'Text' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashDate1 invalid 1',
        Config      => {
            Name           => 'ExampleHashDate1',
            EffectiveValue => {
                'Date' => '2017-01-55',
                'Text' => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashDate2 valid',
        Config      => {
            Name           => 'ExampleHashDate2',
            EffectiveValue => {
                'Dates'  => '2017-01-01',
                'String' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashDate2 invalid 1',
        Config      => {
            Name           => 'ExampleHashDate2',
            EffectiveValue => {
                'Dates'  => '2017-01-55',
                'String' => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashDateTime1 valid',
        Config      => {
            Name           => 'ExampleHashDateTime1',
            EffectiveValue => {
                'DateTime' => '2017-01-01 01:01:55',
                'Text'     => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashDateTime1 invalid 1',
        Config      => {
            Name           => 'ExampleHashDateTime1',
            EffectiveValue => {
                'DateTime' => '2017-01-01 01:01:65',
                'Text'     => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashDateTime2 valid',
        Config      => {
            Name           => 'ExampleHashDateTime2',
            EffectiveValue => {
                'Dates'  => '2017-01-01 01:01:55',
                'String' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashDateTime2 invalid 1',
        Config      => {
            Name           => 'ExampleHashDateTime2',
            EffectiveValue => {
                'Dates'  => '2017-01-01 01:01:65',
                'String' => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashEntity1 valid',
        Config      => {
            Name           => 'ExampleHashEntity1',
            EffectiveValue => {
                'Entity' => '3 normal',
                'String' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashEntity1 invalid 1',
        Config      => {
            Name           => 'ExampleHashEntity1',
            EffectiveValue => {
                'Entity' => '2 normal',
                'String' => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashEntity2 valid',
        Config      => {
            Name           => 'ExampleHashEntity2',
            EffectiveValue => {
                'EntityN' => '3 normal',
                'String'  => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashEntity2 invalid 1',
        Config      => {
            Name           => 'ExampleHashEntity2',
            EffectiveValue => {
                'EntityN' => '2 normal',
                'String'  => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashDirectory1 valid',
        Config      => {
            Name           => 'ExampleHashDirectory1',
            EffectiveValue => {
                'File'   => '/etc',
                'String' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashDirectory1 invalid 1',
        Config      => {
            Name           => 'ExampleHashDirectory1',
            EffectiveValue => {
                'File'   => '/etcs_notExisting#',
                'String' => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashDirectory2 valid',
        Config      => {
            Name           => 'ExampleHashDirectory2',
            EffectiveValue => {
                'Folder' => '/etc',
                'String' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashDirectory2 invalid 1',
        Config      => {
            Name           => 'ExampleHashDirectory2',
            EffectiveValue => {
                'Folder' => '/etcs_notExisting#',
                'String' => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashFile1 valid',
        Config      => {
            Name           => 'ExampleHashFile1',
            EffectiveValue => {
                'File'   => '/etc/hosts',
                'String' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashFile1 invalid 1',
        Config      => {
            Name           => 'ExampleHashFile1',
            EffectiveValue => {
                'File'   => '/etc/hosts_SDWEsd#',
                'String' => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashFile2 valid',
        Config      => {
            Name           => 'ExampleHashFile2',
            EffectiveValue => {
                'AnyKey' => '/etc/hosts',
                'String' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashFile2 invalid 1',
        Config      => {
            Name           => 'ExampleHashFile2',
            EffectiveValue => {
                'AnyKey' => '/etc/hosts_SDWEsd#',
                'String' => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashPerlModule1 valid',
        Config      => {
            Name           => 'ExampleHashPerlModule1',
            EffectiveValue => {
                'PerlModule' => 'Kernel::System::Log::SysLog',
                'String'     => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashPerlModule1 invalid 1',
        Config      => {
            Name           => 'ExampleHashPerlModule1',
            EffectiveValue => {
                'PerlModule' => 'Kernel::System::Log::SysLogXYZ',
                'String'     => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashPerlModule2 valid',
        Config      => {
            Name           => 'ExampleHashPerlModule2',
            EffectiveValue => {
                'AnyKey' => 'Kernel::System::Log::SysLog',
                'String' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashPerlModule2 invalid 1',
        Config      => {
            Name           => 'ExampleHashPerlModule2',
            EffectiveValue => {
                'AnyKey' => 'Kernel::System::Log::SysLogXYZ',
                'String' => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashTimeZone1 valid',
        Config      => {
            Name           => 'ExampleHashTimeZone1',
            EffectiveValue => {
                'TimeZone' => 'UTC',
                'String'   => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashTimeZone1 invalid 1',
        Config      => {
            Name           => 'ExampleHashTimeZone1',
            EffectiveValue => {
                'TimeZone' => 'UTCckwo',
                'String'   => 'male',
            },
        },
        ExpectedResult => 1,
    },
    {
        Description => 'ExampleHashTimeZone2 valid',
        Config      => {
            Name           => 'ExampleHashTimeZone2',
            EffectiveValue => {
                'AnyKey' => 'UTC',
                'String' => 'male',
            },
        },
        ExpectedResult => 0,
    },
    {
        Description => 'ExampleHashTimeZone2 invalid 1',
        Config      => {
            Name           => 'ExampleHashTimeZone2',
            EffectiveValue => {
                'AnyKey' => 'UTCckwo',
                'String' => 'male',
            },
        },
        ExpectedResult => 1,
    },
);

TEST:
for my $Test (@Tests) {

    my %Setting = $SysConfigObject->SettingGet(
        Name => $Test->{Config}->{Name},
    );

    my %DefaultSettingVersionGetLast = $SysConfigDBObject->DefaultSettingVersionGetLast(
        DefaultID => $Setting{DefaultID},
    );

    my $SQL = '
        INSERT INTO sysconfig_modified_version
            (sysconfig_default_version_id, name, user_id, is_valid, reset_to_default,
            user_modification_active, effective_value, create_time, create_by,
            change_time, change_by)
        VALUES
            (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ';

    # Serialize data as string.
    my $EffectiveValue = $YAMLObject->Dump(
        Data => $Test->{Config}->{EffectiveValue},
    );

    # update DB
    my $DBSuccess = $DBObject->Do(
        SQL  => $SQL,
        Bind => [
            \$DefaultSettingVersionGetLast{DefaultVersionID},
            \$Test->{Config}->{Name}, \undef, \1, \0, \0,
            \$EffectiveValue,
            \"2017-01-01 00:00:00", \1,
            \"2017-01-01 00:00:00", \1,
        ],
    );

    $Self->True(
        $DBSuccess,
        "$Test->{Description} - Updated $Test->{Config}->{Name} to the invalid value.",
    );

    next TEST if !$DBSuccess;

    # Delete cache to get fresh data.
    $CacheObject->Delete(
        Type => 'SysConfig',
        Key  => 'ConfigurationInvalidList'
    );

    my @InvalidSettings = $SysConfigObject->ConfigurationInvalidList();

    my ($Invalid) = grep { $_ eq $Test->{Config}->{Name} } @InvalidSettings;

    $Self->Is(
        $Invalid ? 1 : 0,
        $Test->{ExpectedResult},
        "$Test->{Description} - Check if setting $Test->{Config}->{Name} is marked as invalid.",
    );

    my $DBCleanUp = $DBObject->Do(
        SQL => $SQLDeleteModifiedSettingsVersion,
    );
    $Self->True(
        $DBCleanUp,
        "Clean sysconfig_modified_version table.",
    );

    # Delete cache to get fresh data.
    $CacheObject->CleanUp(
        Type => 'SysConfigModifiedVersion',
    );
}

1;
