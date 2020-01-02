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

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Mapping;

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

my @MappingTests = (
    {
        Name   => 'Test invalid xml',
        Config => {
            Template => 'this is no xml',
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test no xslt',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<valid-xml-but-no-xslt/>',
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test invalid xslt',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
</xsl:template>
</xsl:stylesheet>',
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test empty data',
        Config => {
            Template => '',
        },
        Data          => undef,
        ResultData    => {},
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test empty config',
        Config => {},
        Data   => {
            Key => 'Value',
        },
        ResultData => {
            Key => 'Value',
        },
        ResultSuccess => 1,
        ConfigSuccess => 0,
    },
    {
        Name   => 'Test invalid hash key name',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewKey>NewValue</NewKey>
</xsl:template>
</xsl:stylesheet>',
        },
        Data => {
            '<Key>' => 'Value',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test invalid replacement',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<Wrapper><Level1><Level2><Level3>Value</Level1></Level2></Level3></Wrapper>
</xsl:template>
</xsl:stylesheet>',
        },
        Data => {
            Key => 'Value',
        },
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test array as data',
        Config => {
            Template => qq{<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:otrs="http://otrs.org"
 extension-element-prefixes="otrs">
<xsl:import href="$Home/Kernel/GenericInterface/Mapping/OTRSFunctions.xsl" />
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement>
    <xsl:for-each select="/RootElement/Array1">
    <FirstLevelArray>
        <xsl:text>Amended</xsl:text>
        <xsl:value-of select="." />
    </FirstLevelArray>
    </xsl:for-each>
</NewRootElement>
</xsl:template>
</xsl:stylesheet>},
        },
        Data => (
            'ArrayPart1',
            'ArrayPart2',
            'ArrayPart3',
        ),
        ResultData    => undef,
        ResultSuccess => 0,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test simple overwrite',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement><NewKey>NewValue</NewKey></NewRootElement>
</xsl:template>
</xsl:stylesheet>',
        },
        Data => {
            Key => 'Value',
        },
        ResultData => {
            NewKey => 'NewValue',
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },

    {
        Name   => 'Test simple overwrite (whitespaces trimmed)',
        Config => {
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement><NewKey>
        NewValue
</NewKey></NewRootElement>
</xsl:template>
</xsl:stylesheet>',
        },
        Data => {
            Key => 'Value',
        },
        ResultData => {
            NewKey => 'NewValue',
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },

    {
        Name   => 'Test replacement with custom functions',
        Config => {
            Template => qq{<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:otrs="http://otrs.org"
 extension-element-prefixes="otrs">
<xsl:import href="$Home/Kernel/GenericInterface/Mapping/OTRSFunctions.xsl" />
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement>
    <xsl:for-each select="/RootElement/Structure1/Array1">
    <FirstLevelArray>
        <xsl:text>Amended</xsl:text>
        <xsl:value-of select="." />
    </FirstLevelArray>
    </xsl:for-each>
    <NewStructure>
        <DateFromISO>
            <xsl:variable name="dateiso" select="/RootElement/DateISO" />
            <xsl:value-of select="otrs:date-iso-to-xsd(\$dateiso)" />
        </DateFromISO>
        <DateToISO>
            <xsl:variable name="datexsd" select="/RootElement/DateXSD" />
            <xsl:value-of select="otrs:date-xsd-to-iso(\$datexsd)" />
        </DateToISO>
        <NewKey1>
            <xsl:value-of select="/RootElement/Key1" />
        </NewKey1>
        <NewKey2>
            <xsl:value-of select="/RootElement/Structure1/Key2" />
        </NewKey2>
    </NewStructure>
</NewRootElement>
</xsl:template>
</xsl:stylesheet>},
        },
        Data => {
            DateISO    => '2010-12-31 23:58:59',
            DateXSD    => '2011-11-30T22:57:58Z',
            Key1       => 'Value1',
            Structure1 => {
                Array1 => [
                    'ArrayPart1',
                    'ArrayPart2',
                    'ArrayPart3',
                ],
                Key2 => 'Value2',
            },
        },
        ResultData => {
            FirstLevelArray => [
                'AmendedArrayPart1',
                'AmendedArrayPart2',
                'AmendedArrayPart3',
            ],
            NewStructure => {
                DateFromISO => '2010-12-31T23:58:59Z',
                DateToISO   => '2011-11-30 22:57:58',
                NewKey1     => 'Value1',
                NewKey2     => 'Value2',
            },
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test DataInclude functionality',
        Config => {
            DataInclude => [
                'RequesterRequestInput',
                'RequesterResponseMapOutput',
            ],
            Template => qq{<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:otrs="http://otrs.org"
 extension-element-prefixes="otrs">
<xsl:import href="$Home/Kernel/GenericInterface/Mapping/OTRSFunctions.xsl" />
<xsl:output method="xml" encoding="utf-8" indent="yes"/>
<xsl:template match="/RootElement">
<NewRootElement>
    <DataInclude><xsl:value-of select="/RootElement/DataInclude/RequesterResponseMapOutput/Value" /></DataInclude>
    <DataInclude><xsl:value-of select="/RootElement/DataInclude/RequesterRequestInput/Value" /></DataInclude>
</NewRootElement>
</xsl:template>
</xsl:stylesheet>},
        },
        Data => {
            Key => 'Value',
        },
        DataInclude => {
            RequesterRequestInput         => { Value => 1 },
            RequesterRequestPrepareOutput => { Value => 2 },
            RequesterResponseMapOutput    => { Value => 3 }
        },
        ResultData => {
            DataInclude => [
                3,
                1,
            ],
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
);

TEST:
for my $Test (@MappingTests) {

    # create a mapping instance
    my $MappingObject = Kernel::GenericInterface::Mapping->new(
        DebuggerObject => $DebuggerObject,
        MappingConfig  => {
            Type   => 'XSLT',
            Config => $Test->{Config},
        },
    );
    if ( $Test->{ConfigSuccess} ) {
        $Self->Is(
            ref $MappingObject,
            'Kernel::GenericInterface::Mapping',
            $Test->{Name} . ' MappingObject was correctly instantiated',
        );
        next TEST if ref $MappingObject ne 'Kernel::GenericInterface::Mapping';
    }
    else {
        $Self->IsNot(
            ref $MappingObject,
            'Kernel::GenericInterface::Mapping',
            $Test->{Name} . ' MappingObject was not correctly instantiated',
        );
        next TEST;
    }

    my $MappingResult = $MappingObject->Map(
        Data        => $Test->{Data},
        DataInclude => $Test->{DataInclude},
    );

    # check if function return correct status
    $Self->Is(
        $MappingResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' (Success).',
    );

    # check if function return correct data
    $Self->IsDeeply(
        $MappingResult->{Data},
        $Test->{ResultData},
        $Test->{Name} . ' (Data Structure).',
    );

    if ( !$Test->{ResultSuccess} ) {
        $Self->True(
            $MappingResult->{ErrorMessage},
            $Test->{Name} . ' error message found',
        );
    }

    # instantiate another object
    my $SecondMappingObject = Kernel::GenericInterface::Mapping->new(
        DebuggerObject => $DebuggerObject,
        MappingConfig  => {
            Type   => 'XSLT',
            Config => $Test->{Config},
        },
    );

    $Self->Is(
        ref $SecondMappingObject,
        'Kernel::GenericInterface::Mapping',
        $Test->{Name} . ' SecondMappingObject was correctly instantiated',
    );
}

1;
