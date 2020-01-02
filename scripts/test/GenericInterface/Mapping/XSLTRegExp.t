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

# Get helper object.
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Get random id.
my $RandomNumber = $Helper->GetRandomNumber();

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
        Name   => 'Test RegExp (Pre RegExp)',
        Config => {
            PreRegExFilter => [
                {
                    Search  => '^(\D*)ID$',
                    Replace => '$1Number',
                },
            ],
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:transform>',
        },
        Data => {
            TicketID => $RandomNumber,
        },
        ResultData => {
            TicketNumber => $RandomNumber,
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test RegExp (Post RegExp)',
        Config => {
            PostRegExFilter => [
                {
                    Search  => '^(\D*)ID$',
                    Replace => '$1Number',
                },
            ],
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:transform>',
        },
        Data => {
            TicketID => $RandomNumber,
        },
        ResultData => {
            TicketNumber => $RandomNumber,
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test RegExp (Pre RegExp + Post RegExp)',
        Config => {
            PreRegExFilter => [
                {
                    Search  => '^(\D*)_(\D*)$',
                    Replace => '$1$2',
                },
            ],
            PostRegExFilter => [
                {
                    Search  => '^(Queue)Name$',
                    Replace => '$1ID',
                },
            ],
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:transform>',
        },
        Data => {
            Ticket_Number => $RandomNumber,
            QueueName     => $RandomNumber,
        },
        ResultData => {
            TicketNumber => $RandomNumber,
            QueueID      => $RandomNumber,
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test RegExp complex (Post RegExp)',
        Config => {
            PostRegExFilter => [
                {
                    Search  => '^(\D*)(\d)$',
                    Replace => '$1_$2',
                },
                {
                    Search  => '^_(\d*).(\d*)$',
                    Replace => '$1x$2',
                },
                {
                    Search  => '^(some)(K\D*)$',
                    Replace => '$2$1',
                },
            ],
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:transform>',
        },
        Data => {
            UnitData => {
                UnitTestKey1 => 'someValue',
                UnitTestKey2 => 'someValue',
                Data         => {
                    '_10x10' => 'someValue',
                    '_20x20' => 'someValue',
                },
            },
            OtherData => {
                OtherData1 => 'someValue',
                OtherData2 => 'someValue',
                IssueData  => [
                    {
                        someKey  => 'someValue',
                        '_20x20' => 'someValue',
                    },
                ],
            },
        },
        ResultData => {
            UnitData => {
                UnitTestKey_1 => 'someValue',
                UnitTestKey_2 => 'someValue',
                Data          => {
                    '10x10' => 'someValue',
                    '20x20' => 'someValue',
                },
            },
            OtherData => {
                OtherData_1 => 'someValue',
                OtherData_2 => 'someValue',
                IssueData   => {
                    Keysome => 'someValue',
                    '20x20' => 'someValue'
                },
            },
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
    {
        Name   => 'Test RegExp complex (Post RegExp + Pre RegExp)',
        Config => {
            PostRegExFilter => [
                {
                    Search  => '^(\D*)(\d)$',
                    Replace => '$1_$2',
                },
                {
                    Search  => '^_(\d*).(\d*)$',
                    Replace => '$1x$2',
                },
                {
                    Search  => '^(some)(K\D*)$',
                    Replace => '$2$1',
                },
            ],
            PreRegExFilter => [
                {
                    Search  => '^(\D*)(ZZ)$',
                    Replace => '$1_$2',
                },
                {
                    Search  => '^[QQQ]+(Key)[QQQ]+$',
                    Replace => 'Q$1Q',
                },
            ],
            Template => '<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:transform>',
        },
        Data => {
            UnitTestKeyZZ => 'someValue',
            PreData       => {
                QQQKeyQQQ => 'someValue',
            },
            UnitData => {
                UnitTestKey1 => 'someValue',
                UnitTestKey2 => 'someValue',
                Data         => {
                    '_10x10' => 'someValue',
                    '_20x20' => 'someValue',
                },
            },
            OtherData => {
                OtherData1 => 'someValue',
                OtherData2 => 'someValue',
                IssueData  => [
                    {
                        someKey  => 'someValue',
                        '_10x10' => 'someValue',
                    },
                    {
                        someKey  => 'someValue',
                        '_20x20' => 'someValue',
                    },
                ],
            },
        },
        ResultData => {
            UnitTestKey_ZZ => 'someValue',
            PreData        => {
                QKeyQ => 'someValue',
            },
            UnitData => {
                UnitTestKey_1 => 'someValue',
                UnitTestKey_2 => 'someValue',
                Data          => {
                    '10x10' => 'someValue',
                    '20x20' => 'someValue',
                },
            },
            OtherData => {
                OtherData_1 => 'someValue',
                OtherData_2 => 'someValue',
                IssueData   => [
                    {
                        Keysome => 'someValue',
                        '10x10' => 'someValue',
                    },
                    {
                        Keysome => 'someValue',
                        '20x20' => 'someValue',
                    },
                ],
            },
        },
        ResultSuccess => 1,
        ConfigSuccess => 1,
    },
);

TEST:
for my $Test (@MappingTests) {

    # Create a mapping instance.
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
        Data => $Test->{Data},
    );

    # Check if function return correct status.
    $Self->Is(
        $MappingResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' (Success).',
    );

    # Check if function return correct data.
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

    # Instantiate another object.
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
