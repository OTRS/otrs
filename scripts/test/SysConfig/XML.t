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

# prevent used once warning
use Kernel::System::ObjectManager;

use vars (qw($Self));

my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');
$Self->True(
    $SysConfigXMLObject,
    'Creation of Kernel::System::SysConfig::XML object must succeed.',
);

#
# SettingParse tests
#
my @Tests = (
    {
        Description    => 'No Config',
        Config         => {},
        ExpectedResult => undef,
    },
    {
        Description => 'Wrong XMLInput format',
        Config      => {
            SettingXML => { Test => 'Test' }
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Empty XMLInput',
        Config      => {
            SettingXML => '',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Non XML XMLInput',
        Config      => {
            SettingXML => 'Test',
        },
        ExpectedResult => undef,
    },

    {
        Description => 'Valid Setting XML',
        Config      => {
            SettingXML => '
                <Setting Name="Test" Required="1" Valid="1">
                    <Description Translatable="1">Test.</Description>
                    <Navigation>Core::Ticket</Navigation>
                    <Value>
                        <Item ValueType="String" ValueRegex=".*">123</Item>
                    </Value>
                </Setting>
            ',
        },
        ExpectedResult => {
            Description => [
                {
                    Content      => 'Test.',
                    Translatable => '1',
                },
            ],
            Name     => 'Test',
            Required => '1',
            Value    => [
                {
                    Item => [
                        {
                            ValueRegex => '.*',
                            ValueType  => 'String',
                            Content    => '123',
                        },
                    ],
                },
            ],
            Navigation => [
                {
                    Content => 'Core::Ticket',
                },
            ],
            Valid => '1',
        },
    },
    {
        Description => 'Valid Setting XML UTF8',
        Config      => {
            SettingXML => '
                <Setting Name="äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß" Required="1" Valid="1">
                    <Description Translatable="1">Test.</Description>
                    <Navigation>Core::Ticket</Navigation>
                    <Value>
                        <Item ValueType="String" ValueRegex=".*">äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß</Item>
                    </Value>
                </Setting>
            ',
        },
        ExpectedResult => {
            Description => [
                {
                    Content      => 'Test.',
                    Translatable => '1',
                },
            ],
            Name     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            Required => '1',
            Value    => [
                {
                    Item => [
                        {
                            ValueRegex => '.*',
                            ValueType  => 'String',
                            Content    => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                        },
                    ],
                },
            ],
            Navigation => [
                {
                    Content => 'Core::Ticket',
                },
            ],
            Valid => '1',
        },
    },
    {
        Description => 'Valid Setting XML 0',
        Config      => {
            SettingXML => '
                <Setting Name="0" Required="1" Valid="1">
                    <Description Translatable="1">Test.</Description>
                    <Navigation>Core::Ticket</Navigation>
                    <Value>
                        <Item ValueType="String" ValueRegex=".*">0</Item>
                    </Value>
                </Setting>
            ',
        },
        ExpectedResult => {
            Description => [
                {
                    Content      => 'Test.',
                    Translatable => '1',
                },
            ],
            Name     => '0',
            Required => '1',
            Value    => [
                {
                    Item => [
                        {
                            ValueRegex => '.*',
                            ValueType  => 'String',
                            Content    => '0',
                        },
                    ],
                },
            ],
            Navigation => [
                {
                    Content => 'Core::Ticket',
                },
            ],
            Valid => '1',
        },
    },

    {
        Description => 'Valid Setting XML CustomerCompany::EventModulePost###100-UpdateDynamicFieldObjectName',
        Config      => {
            SettingXML => '
                <Setting Name="CustomerCompany::EventModulePost###100-UpdateDynamicFieldObjectName" Required="0" Valid="1">
                    <Description Translatable="1">Event module that updates customer company object name for dynamic fields.</Description>
                    <Navigation>Core::CustomerCompany</Navigation>
                    <Value>
                        <Hash>
                            <Item Key="Module">Kernel::System::CustomerCompany::Event::DynamicFieldObjectNameUpdate</Item>
                            <Item Key="Event">CustomerCompanyUpdate</Item>
                            <Item Key="Transaction">0</Item>
                        </Hash>
                    </Value>
                </Setting>',
        },
        ExpectedResult => {
            Description => [
                {
                    Content      => 'Event module that updates customer company object name for dynamic fields.',
                    Translatable => '1',
                },
            ],
            Name     => 'CustomerCompany::EventModulePost###100-UpdateDynamicFieldObjectName',
            Required => '0',
            Value    => [
                {
                    Hash => [
                        {
                            Item => [
                                {
                                    Key     => 'Module',
                                    Content => 'Kernel::System::CustomerCompany::Event::DynamicFieldObjectNameUpdate',
                                },
                                {
                                    Key     => 'Event',
                                    Content => 'CustomerCompanyUpdate',
                                },
                                {
                                    Key     => 'Transaction',
                                    Content => '0',
                                },
                            ],
                        }
                    ],
                },
            ],
            Navigation => [
                {
                    Content => 'Core::CustomerCompany',
                },
            ],
            Valid => '1',
        },
    },

    {
        Description => 'Invalid Setting XML: Two Setting elements',
        Config      => {
            SettingXML => '
                <Setting Name="Test" Required="1" Valid="1">
                    <Description Translatable="1">Test.</Description>
                    <Navigation>Core::Ticket</Navigation>
                    <Value>
                        <Item ValueType="String" ValueRegex=".*">123</Item>
                    </Value>
                </Setting>
                <Setting Name="Test2" Required="1" Valid="1">
                    <Description Translatable="1">Test 2.</Description>
                    <Navigation>Core::Ticket</Navigation>
                    <Value>
                        <Item ValueType="String" ValueRegex=".*">123</Item>
                    </Value>
                </Setting>
            ',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Invalid Setting XML: Surrounding element',
        Config      => {
            SettingXML => '
                <otrs_config>
                    <Setting Name="Test" Required="1" Valid="1">
                        <Description Translatable="1">Test.</Description>
                        <Navigation>Core::Ticket</Navigation>
                        <Value>
                            <Item ValueType="String" ValueRegex=".*">123</Item>
                        </Value>
                    </Setting>
                </otrs_config>
            ',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Invalid XML',
        Config      => {
            SettingXML => 'This is no XML',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Invalid Setting XML: Misspelled Setting element',
        Config      => {
            SettingXML => '
                <NoSetting Name="Test" Required="1" Valid="1">
                    <Description Translatable="1">Test.</Description>
                    <Navigation>Core::Ticket</Navigation>
                    <Value>
                        <Item ValueType="String" ValueRegex=".*">123</Item>
                    </Value>
                </NoSetting>
            ',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Invalid Setting XML: No surrounding Setting element',
        Config      => {
            SettingXML => '
                <Description Translatable="1">Test.</Description>
                <Navigation>Core::Ticket</Navigation>
                <Value>
                    <Item ValueType="String" ValueRegex=".*">123</Item>
                </Value>
            ',
        },
        ExpectedResult => undef,
    },
);

for my $Test (@Tests) {
    my $Result = $SysConfigXMLObject->SettingParse( %{ $Test->{Config} } );
    if ( defined $Result && ref $Result ) {
        $Self->IsDeeply(
            $Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': SettingParse(): Resulting Perl structure must match expected one.',
        );
    }
    else {
        $Self->Is(
            $Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': SettingParse(): Result must match expected one.',
        );
    }
}

#
# SettingListGet tests
#
@Tests = (
    {
        Description    => 'No Config',
        Config         => {},
        ExpectedResult => undef,
    },
    {
        Description => 'Wrong XMLInput format',
        Config      => {
            XMLInput => { Test => 'Test' }
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Empty XMLInput',
        Config      => {
            XMLInput => '',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Non XML XMLInput',
        Config      => {
            XMLInput => 'Test',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Valid XML',
        Config      => {
            XMLInput => '<?xml version="1.0" encoding="utf-8"?>
<otrs_config version="2.0" init="Application">
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">123</Item>
        </Value>
    </Setting>
    <Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">/usr/bin/gpg</Item>
        </Value>
    </Setting>
</otrs_config>
            ',
        },
        ExpectedResult => {
            'Test1' => '<Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">123</Item>
        </Value>
    </Setting>',
            'Test2' => '<Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">/usr/bin/gpg</Item>
        </Value>
    </Setting>',
        },
    },
    {
        Description => 'Valid XML UTF8',
        Config      => {
            XMLInput => '<?xml version="1.0" encoding="utf-8"?>
<otrs_config version="2.0" init="Application">
    <Setting Name="äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß</Item>
        </Value>
    </Setting>
    <Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">/usr/bin/gpg</Item>
        </Value>
    </Setting>
</otrs_config>
            ',
        },
        ExpectedResult => {
            'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß' =>
                '<Setting Name="äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß</Item>
        </Value>
    </Setting>',
            'Test2' => '<Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">/usr/bin/gpg</Item>
        </Value>
    </Setting>',
        },
    },
    {
        Description => 'Invalid XML',
        Config      => {
            XMLInput => '<?xml version="1.0" encoding="utf-8"?>
<WRONG_otrs_config version="2.0" init="Application">
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">123</Item>
        </Value>
    </Setting>
    <Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">/usr/bin/gpg</Item>
        </Value>
    </Setting>
</otrs_config>
            ',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Missing surrounding otrs_config element',
        Config      => {
            XMLInput => '<?xml version="1.0" encoding="utf-8"?>
<Setting Name="Test1" Required="1" Valid="1">
    <Description Translatable="1">Test 1.</Description>
    <Navigation>Core::Ticket</Navigation>
    <Value>
        <Item ValueType="String" ValueRegex=".*">123</Item>
    </Value>
</Setting>
<Setting Name="Test2" Required="1" Valid="1">
    <Description Translatable="1">Test 2.</Description>
    <Navigation>Core::Ticket</Navigation>
    <Value>
        <Item ValueType="File">/usr/bin/gpg</Item>
    </Value>
</Setting>
            ',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'No Setting elements',
        Config      => {
            XMLInput => '<?xml version="1.0" encoding="utf-8"?>
<otrs_config version="2.0" init="Application">
    <NoSetting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">123</Item>
        </Value>
    </NoSetting>
    <NoSetting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">/usr/bin/gpg</Item>
        </Value>
    </NoSetting>
</otrs_config>
            ',
        },
        ExpectedResult => undef,
    },
    {
        Description => 'Setting without Name attribute',
        Config      => {
            XMLInput => '<?xml version="1.0" encoding="utf-8"?>
<otrs_config version="2.0" init="Application">
    <Setting Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">123</Item>
        </Value>
    </Setting>
    <Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">/usr/bin/gpg</Item>
        </Value>
    </Setting>
</otrs_config>
            ',
        },
        ExpectedResult => undef,
    },
);

for my $Test (@Tests) {
    my $Result = $SysConfigXMLObject->SettingListGet( %{ $Test->{Config} } );
    if ( defined $Result && ref $Result ) {

        $Self->IsDeeply(
            $Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': SettingListGet(): Result must match expected one.',
        );
    }
    else {
        $Self->Is(
            $Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': SettingListGet(): Result must match expected one.',
        );
    }
}

1;
