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

# Delete sysconfig_modified_version
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_modified_version',
);

# Delete sysconfig_modified
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_modified',
);

# Delete sysconfig_default_version
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_default_version',
);

# Delete sysconfig_default
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_default',
);

# Load setting from sample XML file
my $LoadSuccess = $SysConfigObject->ConfigurationXML2DB(
    UserID    => 1,
    Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/Entities",
);
$Self->True(
    $LoadSuccess,
    "Load settings from SampleEntities.xml."
);

my @Tests1 = (
    {
        Description => '#1',
        Config      => {
        },
        ExpectedResult => {
            'AnotherEntity' => {
                'open' => [
                    'Ticket::Frontend::AgentTicketPriority###AnotherOpenEntity'
                ],
            },
            'AnotherType' => {
                '123' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
                'AnotherDefaultValue' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
            },
            'State' => {
                'new' => [
                    'Ticket::Frontend::AgentTicketPriority###StateNext'
                ],
                'open' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2',
                    'Ticket::Frontend::AgentTicketPriority###StateDefault',
                ],
                'New' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity'
                ],
                'Open' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity'
                ],
            },
            'StateßČĆ£øπ∂' => {
                'openßČĆ£øπ∂' => [
                    'Ticket::Frontend::AgentTicketPriority###EntityUnicode'
                ],
            },
            'Type' => {
                '123' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
                'DefaultValue' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
            },
            'YetAnotherType' => {
                'YetAnotherDefaultValue1' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
                'YetAnotherDefaultValue2' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
            },
        },
    }
);

my @Tests2 = (
    {
        Description => '#2',
        Config      => {
        },
        ExpectedResult => {
            'AnotherEntity' => {
                'open' => [
                    'Ticket::Frontend::AgentTicketPriority###AnotherOpenEntity'
                ],
            },
            'AnotherType' => {
                '123' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
                'AnotherDefaultValue' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
            },
            'State' => {
                'new' => [
                    'Ticket::Frontend::AgentTicketPriority###StateNext'
                ],
                'open' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2',
                ],
                'New' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity'
                ],
                'Open' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity'
                ],
                'closed' => [
                    'Ticket::Frontend::AgentTicketPriority###StateDefault',
                ]
            },
            'StateßČĆ£øπ∂' => {
                'openßČĆ£øπ∂' => [
                    'Ticket::Frontend::AgentTicketPriority###EntityUnicode'
                ],
            },
            'Type' => {
                '123' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
                'DefaultValue' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
            },
            'YetAnotherType' => {
                'YetAnotherDefaultValue1' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
                'YetAnotherDefaultValue2' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
            },
        },
    },
);

my @Tests3 = (
    {
        Description => '#3',
        Config      => {
        },
        ExpectedResult => {
            'AnotherEntity' => {
                'open' => [
                    'Ticket::Frontend::AgentTicketPriority###AnotherOpenEntity'
                ],
            },
            'AnotherType' => {
                '123' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
                'AnotherDefaultValue' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
            },
            'State' => {
                'new' => [
                    'Ticket::Frontend::AgentTicketPriority###StateNext'
                ],
                'open' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2',
                ],
                'New' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity'
                ],
                'Open' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity'
                ],
                'reopened' => [
                    'Ticket::Frontend::AgentTicketPriority###StateDefault',
                ]
            },
            'Type' => {
                '123' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
                'DefaultValue' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
            },
            'YetAnotherType' => {
                'YetAnotherDefaultValue1' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
                'YetAnotherDefaultValue2' => [
                    'Ticket::Frontend::AgentTicketPriority###ComplexEntity2'
                ],
            },
        },
    },
);

for my $Test (@Tests1) {
    my %Result = $SysConfigObject->ConfigurationEntitiesGet( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': ConfigurationEntitiesGet(): Result must match expected one.',
    );
}

my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    Name => 'Ticket::Frontend::AgentTicketPriority###EntityUnicode',
);

# Update setting navigation
$DefaultSetting{Navigation} = 'AnyOtherValue';

# Lock
my $GuID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultSetting{DefaultID},
);

$Self->True(
    $GuID,
    "Check if locked before update."
);

# Update item
my $DefaultSettingUpdateSuccess = $SysConfigDBObject->DefaultSettingUpdate(
    %DefaultSetting,
    ExclusiveLockGUID => $GuID,
    UserID            => 1,
);
$Self->True(
    $DefaultSettingUpdateSuccess,
    "Update success.",
);

my %DefaultSetting2 = $SysConfigDBObject->DefaultSettingGet(
    Name => 'Ticket::Frontend::AgentTicketPriority###StateDefault',
);

# Lock
my $GuID2 = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultSetting2{DefaultID},
);

$Self->True(
    $GuID2,
    "Check if locked before update #2."
);

my $ModifiedID2 = $SysConfigDBObject->ModifiedSettingAdd(
    %DefaultSetting2,
    EffectiveValue    => 'closed',
    ExclusiveLockGUID => $GuID2,
    UserID            => 1,
);
$Self->True(
    $ModifiedID2,
    "Check if setting was modified."
);

# Check result
for my $Test (@Tests2) {
    my %Result = $SysConfigObject->ConfigurationEntitiesGet( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': ConfigurationEntityCheck(): Result must match expected one.',
    );
}

# Lock
my $GuID3 = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultSetting2{DefaultID},
);

$Self->True(
    $GuID3,
    "Check if locked before update #2."
);

my $ModifiedUpdated = $SysConfigDBObject->ModifiedSettingUpdate(
    %DefaultSetting2,
    ModifiedID        => $ModifiedID2,
    EffectiveValue    => 'reopened',
    ExclusiveLockGUID => $GuID3,
    UserID            => 1,
);
$Self->True(
    $ModifiedUpdated,
    "Check if setting was modified #2."
);

# Delete item
my $DefaultSettingDeleteSuccess = $SysConfigDBObject->DefaultSettingDelete(
    DefaultID => $DefaultSetting{DefaultID},
);
$Self->True(
    $DefaultSettingDeleteSuccess,
    "Delete setting.",
);

# Check result
for my $Test (@Tests3) {
    my %Result = $SysConfigObject->ConfigurationEntitiesGet( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': ConfigurationEntityCheck(): Result must match expected one.',
    );
}

# Check private method _ConfigurationEntitiesGet
my @Tests4 = (
    {
        Description => '_ConfigurationEntitiesGet() - Missing Name',
        Config      => {
            'Result' => {},
            'Value'  => [
                {
                    'Item' => [
                        {
                            'Content'         => '3 medium',
                            'ValueEntityType' => 'Priority',
                            'ValueRegex'      => '',
                            'ValueType'       => 'Entity',
                        },
                    ],
                },
            ],
        },
        ExpectedResult => undef,
    },
    {
        Description => '_ConfigurationEntitiesGet() - Missing Result',
        Config      => {
            'Name'  => 'Ticket::Frontend::AgentTicketPriority###Entity',
            'Value' => [
                {
                    'Item' => [
                        {
                            'Content'         => '3 medium',
                            'ValueEntityType' => 'Priority',
                            'ValueRegex'      => '',
                            'ValueType'       => 'Entity',
                        },
                    ],
                },
            ],
        },
        ExpectedResult => undef,
    },
    {
        Description => '_ConfigurationEntitiesGet() - Missing Value',
        Config      => {
            'Name'   => 'Ticket::Frontend::AgentTicketPriority###Entity',
            'Result' => {},
        },
        ExpectedResult => undef,
    },
    {
        Description => '_ConfigurationEntitiesGet() - pass #1',
        Config      => {
            'Name'   => 'Ticket::Frontend::AgentTicketPriority###Entity',
            'Result' => {},
            'Value'  => [
                {
                    'Item' => [
                        {
                            'Content'         => '3 medium',
                            'ValueEntityType' => 'Priority',
                            'ValueRegex'      => '',
                            'ValueType'       => 'Entity',
                        },
                    ],
                },
            ],
        },
        ExpectedResult => {
            'Priority' => {
                '3 medium' => [
                    'Ticket::Frontend::AgentTicketPriority###Entity',
                ],
            },
        },
    },
    {
        Description => '_ConfigurationEntitiesGet() - pass #2',
        Config      => {
            'Name'   => 'Ticket::Frontend::AgentTicketPriority###Entity',
            'Result' => {
                'Priority' => {
                    '3 medium' => [
                        'Ticket::Frontend::AgentTicketPriority###Entity2',
                    ],
                },
            },
            'Value' => [
                {
                    'Item' => [
                        {
                            'Content'         => '3 medium',
                            'ValueEntityType' => 'Priority',
                            'ValueRegex'      => '',
                            'ValueType'       => 'Entity',
                        },
                    ],
                },
            ],
        },
        ExpectedResult => {
            'Priority' => {
                '3 medium' => [
                    'Ticket::Frontend::AgentTicketPriority###Entity2',
                    'Ticket::Frontend::AgentTicketPriority###Entity',
                ],
            },
        },
    },
    {
        Description => '_ConfigurationEntitiesGet() - pass #3',
        Config      => {
            'Name'   => 'Ticket::Frontend::AgentTicketPriority###Entity',
            'Result' => {
                'Priority' => {
                    '2 low' => [
                        'Ticket::Frontend::AgentTicketPriority###Entity2',
                    ],
                },
            },
            'Value' => [
                {
                    'Item' => [
                        {
                            'Content'         => '3 medium',
                            'ValueEntityType' => 'Priority',
                            'ValueRegex'      => '',
                            'ValueType'       => 'Entity',
                        },
                    ],
                },
            ],
        },
        ExpectedResult => {
            'Priority' => {
                '3 medium' => [
                    'Ticket::Frontend::AgentTicketPriority###Entity',
                ],
                '2 low' => [
                    'Ticket::Frontend::AgentTicketPriority###Entity2',
                ],
            },
        },
    },
    {
        Description => '_ConfigurationEntitiesGet() - pass #4',
        Config      => {
            'Name'   => 'TTicket::Frontend::AgentTicketPriority###Entity2',
            'Result' => {
                'Queue' => {
                    'Junk' => [
                        'Ticket::Frontend::Queue###Entity',
                    ],
                },
            },
            'Value' => [
                {
                    'Item' => [
                        {
                            'Content'         => '3 medium',
                            'ValueEntityType' => 'Priority',
                            'ValueRegex'      => '',
                            'ValueType'       => 'Entity',
                        },
                    ],
                },
            ],
        },
        ExpectedResult => {
            'Priority' => {
                '3 medium' => [
                    'TTicket::Frontend::AgentTicketPriority###Entity2',
                ],
            },
            'Queue' => {
                'Junk' => [
                    'Ticket::Frontend::Queue###Entity',
                ],
            },
        },
    },
);

# Check result
for my $Test (@Tests4) {
    my %Result = $SysConfigObject->_ConfigurationEntitiesGet( %{ $Test->{Config} } );

    if ( !$Test->{ExpectedResult} ) {
        $Self->True(
            !%Result,
            $Test->{Description} . ': _ConfigurationEntityCheck(): Result must be undef.',
        );
    }
    else {
        $Self->IsDeeply(
            \%Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': _ConfigurationEntityCheck(): Result must match expected one.',
        );
    }
}

1;
