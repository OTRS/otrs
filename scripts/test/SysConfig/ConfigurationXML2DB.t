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
use Kernel::System::VariableCheck qw(:all);

use Kernel::Config;

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');

# Delete sysconfig_modified_version
my $SQLDeleteModifiedSettingsVersion = 'DELETE FROM sysconfig_modified_version';
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => $SQLDeleteModifiedSettingsVersion,
);

# Delete sysconfig_modified
my $SQLDeleteModifiedSettings = 'DELETE FROM sysconfig_modified';
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => $SQLDeleteModifiedSettings,
);

# Delete sysconfig_default_version
my $SQLDeleteDefaultSettingsVersion = 'DELETE FROM sysconfig_default_version';
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => $SQLDeleteDefaultSettingsVersion,
);

# Delete sysconfig_default
my $SQLDeleteDefaultSettings = 'DELETE FROM sysconfig_default';
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => $SQLDeleteDefaultSettings,
);

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'SysConfigDefault',
);

my @Tests = (
    {
        Description    => 'Without UserID',
        Config         => {},
        ExpectedResult => undef,
    },
    {
        Description => 'Load ugly XML',
        Config      => {
            UserID    => 1,
            Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XMLUgly/",
        },
        ExpectedResult => [
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description'              => 'The identifier for a ticket.',
                'EffectiveValue'           => 'Ticket#',
                'UserModificationActive'   => '0',
                'ExclusiveLockGUID'        => '0',
                'ExclusiveLockUserID'      => undef,
                'HasConfigLevel'           => '100',
                'IsDirty'                  => '1',
                'IsInvisible'              => '0',
                'IsReadonly'               => '0',
                'IsRequired'               => '1',
                'IsValid'                  => '1',
                'Name'                     => 'Ticket::Hook',
                'Navigation'               => 'Core::Ticket',
                'XMLFilename'              => 'Sample.xml',
                'XMLContentParsed'         => {
                    'Description' => [
                        {
                            'Content'      => 'The identifier for a ticket.',
                            'Translatable' => '1',
                        },
                    ],
                    'Name'       => 'Ticket::Hook',
                    'Navigation' => [
                        {
                            'Content' => 'Core::Ticket',
                        },
                    ],
                    'Required' => '1',
                    'Valid'    => '1',
                    'Value'    => [
                        {
                            'Item' => [
                                {
                                    'Content'    => 'Ticket#',
                                    'ValueRegex' => '',
                                    'ValueType'  => 'String',
                                },
                            ],
                        },
                    ],
                },
                'XMLContentRaw' => '<Setting Name="Ticket::Hook" Required="1" Valid="1">
        <Description Translatable="1">The identifier for a ticket.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex="">Ticket#</Item>
        </Value>
    </Setting>'
            },
        ],
    },
    {
        Description => 'Load sample XML file',
        Config      => {
            UserID    => 1,
            Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/",
        },
        ExpectedResult => [
            {
                'CreateBy'                 => '1',
                'ChangeBy'                 => '1',
                'UserModificationPossible' => '0',
                'Description'              => 'The format of the subject.',
                'EffectiveValue'           => 'Left',
                'UserModificationActive'   => '0',
                'UserPreferencesGroup'     => 'Test',
                'ExclusiveLockGUID'        => '0',
                'ExclusiveLockUserID'      => undef,
                'HasConfigLevel'           => '100',
                'IsDirty'                  => '1',
                'IsInvisible'              => '0',
                'IsReadonly'               => '0',
                'IsRequired'               => '1',
                'IsValid'                  => '1',
                'Name'                     => 'Ticket::SubjectFormat',
                'Navigation'               => 'Core::Ticket',
                'XMLFilename'              => 'Sample.xml',
                'XMLContentParsed'         => {
                    'Description' => [
                        {
                            'Content'      => 'The format of the subject.',
                            'Translatable' => '1'
                        }
                    ],
                    'Name'       => 'Ticket::SubjectFormat',
                    'Navigation' => [
                        {
                            'Content' => 'Core::Ticket'
                        }
                    ],
                    'Required'             => '1',
                    'Valid'                => '1',
                    'UserPreferencesGroup' => 'Test',
                    'Value'                => [
                        {
                            'Item' => [
                                {
                                    'Item' => [
                                        {
                                            'Content'      => 'Left',
                                            'Translatable' => '1',
                                            'Value'        => 'Left',
                                            'ValueType'    => 'Option'
                                        },
                                        {
                                            'Content'      => 'Right',
                                            'Translatable' => '1',
                                            'Value'        => 'Right',
                                            'ValueType'    => 'Option'
                                        }
                                    ],
                                    'SelectedID' => 'Left',
                                    'ValueType'  => 'Select'
                                }
                            ],
                        }
                    ],
                },
                'XMLContentRaw' =>
                    '<Setting Name="Ticket::SubjectFormat" Required="1" Valid="1" UserPreferencesGroup="Test">
        <Description Translatable="1">The format of the subject.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="Select" SelectedID="Left">
                <Item ValueType="Option" Value="Left" Translatable="1">Left</Item>
                <Item ValueType="Option" Value="Right" Translatable="1">Right</Item>
            </Item>
        </Value>
    </Setting>'
            },
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description' =>
                    "Parameters with UTF8 \x{2202}\x{e7}\x{2248}\x{df}\x{10d}\x{107}\x{111}\x{161}\x{17e}\x{e5}",
                'EffectiveValue' => {
                    Module         => 'Kernel::Output::HTML::Dashboard::TicketGeneric',
                    Title          => 'Reminder Tickets',
                    Description    => 'All tickets with reminder',
                    DefaultColumns => {
                        Created             => '1',
                        CustomerCompanyName => '1',
                    },
                },
                'UserModificationActive' => '0',
                'ExclusiveLockGUID'      => '0',
                'ExclusiveLockUserID'    => undef,
                'HasConfigLevel'         => '100',
                'IsDirty'                => '1',
                'IsInvisible'            => '0',
                'IsReadonly'             => '0',
                'IsRequired'             => '0',
                'IsValid'                => '1',
                'Name'                   => 'DashboardBackend###0100-TicketPendingReminder',
                'Navigation'             => 'Frontend::Agent::Dashboard',
                'XMLFilename'            => 'Sample.xml',
                'XMLContentParsed'       => {
                    'Description' => [
                        {
                            'Content' =>
                                "Parameters with UTF8 \x{2202}\x{e7}\x{2248}\x{df}\x{10d}\x{107}\x{111}\x{161}\x{17e}\x{e5}",
                            'Translatable' => '1',
                        }
                    ],
                    'Name'       => 'DashboardBackend###0100-TicketPendingReminder',
                    'Navigation' => [
                        {
                            'Content' => 'Frontend::Agent::Dashboard',
                        },
                    ],
                    'Required' => '0',
                    'Valid'    => '1',
                    'Value'    => [
                        {
                            'Hash' => [
                                {
                                    'Item' => [
                                        {
                                            'Content' => 'Kernel::Output::HTML::Dashboard::TicketGeneric',
                                            'Key'     => 'Module',
                                        },
                                        {
                                            'Content'      => 'Reminder Tickets',
                                            'Key'          => 'Title',
                                            'Translatable' => '1',
                                        },
                                        {
                                            'Content'      => 'All tickets with reminder',
                                            'Key'          => 'Description',
                                            'Translatable' => '1',
                                        },
                                        {
                                            'Hash' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Content' => '1',
                                                            'Key'     => 'Created'
                                                        },
                                                        {
                                                            'Content' => '1',
                                                            'Key'     => 'CustomerCompanyName',
                                                        },
                                                    ],
                                                }
                                            ],
                                            'Key' => 'DefaultColumns',
                                        }
                                    ],
                                },
                            ],
                        },
                    ]
                },
                'XMLContentRaw' =>
                    "<Setting Name=\"DashboardBackend###0100-TicketPendingReminder\" Required=\"0\" Valid=\"1\">
        <Description Translatable=\"1\">Parameters with UTF8 \x{2202}\x{e7}\x{2248}\x{df}\x{10d}\x{107}\x{111}\x{161}\x{17e}\x{e5}</Description>
        <Navigation>Frontend::Agent::Dashboard</Navigation>
        <Value>
            <Hash>
                <Item Key=\"Module\">Kernel::Output::HTML::Dashboard::TicketGeneric</Item>
                <Item Key=\"Title\" Translatable=\"1\">Reminder Tickets</Item>
                <Item Key=\"Description\" Translatable=\"1\">All tickets with reminder</Item>
                <Item Key=\"DefaultColumns\">
                    <Hash>
                        <Item Key=\"Created\">1</Item>
                        <Item Key=\"CustomerCompanyName\">1</Item>
                    </Hash>
                </Item>
            </Hash>
        </Value>
    </Setting>",
            },
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description'              => 'Loader module registration for the agent interface.',
                'EffectiveValue'           => {
                    CSS => [
                        'Core.AgentTicketService.css',
                        'Core.AllocationList.css',
                    ],
                    'JavaScript' => [
                        'Core.UI.AllocationList.js',
                        'Core.Agent.TableFilters.js',
                    ],
                },
                'UserModificationActive' => '0',
                'ExclusiveLockGUID'      => '0',
                'ExclusiveLockUserID'    => undef,
                'HasConfigLevel'         => '100',
                'IsDirty'                => '1',
                'IsInvisible'            => '0',
                'IsReadonly'             => '0',
                'IsRequired'             => '0',
                'IsValid'                => '1',
                'Name'                   => 'Loader::Module::AgentTicketService###002-Ticket',
                'Navigation'             => 'Frontend::Agent::ModuleRegistration',
                'XMLFilename'            => 'Sample.xml',
                'XMLContentParsed'       => {
                    'Description' => [
                        {
                            'Content'      => 'Loader module registration for the agent interface.',
                            'Translatable' => '1',
                        },
                    ],
                    'Name'       => 'Loader::Module::AgentTicketService###002-Ticket',
                    'Navigation' => [
                        {
                            'Content' => 'Frontend::Agent::ModuleRegistration',
                        },
                    ],
                    'Required' => '0',
                    'Valid'    => '1',
                    'Value'    => [
                        {
                            'Hash' => [
                                {
                                    'Item' => [
                                        {
                                            'Array' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Content' => 'Core.AgentTicketService.css',
                                                        },
                                                        {
                                                            'Content' => 'Core.AllocationList.css',
                                                        }
                                                    ],
                                                },
                                            ],
                                            'Key' => 'CSS',
                                        },
                                        {
                                            'Array' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Content' => 'Core.UI.AllocationList.js',
                                                        },
                                                        {
                                                            'Content' => 'Core.Agent.TableFilters.js',
                                                        },
                                                    ],
                                                },
                                            ],
                                            'Key' => 'JavaScript',
                                        }
                                    ],
                                },
                            ],
                        },
                    ],
                },
                'XMLContentRaw' =>
                    '<Setting Name="Loader::Module::AgentTicketService###002-Ticket" Required="0" Valid="1">
        <Description Translatable="1">Loader module registration for the agent interface.</Description>
        <Navigation>Frontend::Agent::ModuleRegistration</Navigation>
        <Value>
            <Hash>
                <Item Key="CSS">
                    <Array>
                        <Item>Core.AgentTicketService.css</Item>
                        <Item>Core.AllocationList.css</Item>
                    </Array>
                </Item>
                <Item Key="JavaScript">
                    <Array>
                        <Item>Core.UI.AllocationList.js</Item>
                        <Item>Core.Agent.TableFilters.js</Item>
                    </Array>
                </Item>
            </Hash>
        </Value>
    </Setting>',
            },
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description'              => 'Check UTF-8.',
                'EffectiveValue'           => {
                    CSS => [
                        'Core.AgentTicketService.css',
                        'Core.AllocationList.css',
                    ],
                    'JavaScript' => [
                        'Core.UI.AllocationList.js',
                        'Core.Agent.TableFilters.js',
                    ],
                },
                'UserModificationActive' => '0',
                'ExclusiveLockGUID'      => '0',
                'ExclusiveLockUserID'    => undef,
                'HasConfigLevel'         => '100',
                'IsDirty'                => '1',
                'IsInvisible'            => '0',
                'IsReadonly'             => '0',
                'IsRequired'             => '0',
                'IsValid'                => '1',
                'Name'                   => 'SettingUTF',
                'Navigation'             => 'Frontend::Agentß∂čćžšđ::ModuleRegistration',
                'XMLFilename'            => 'Sample.xml',
                'XMLContentParsed'       => {
                    'Description' => [
                        {
                            'Content'      => 'Check UTF-8.',
                            'Translatable' => '1',
                        },
                    ],
                    'Name'       => 'SettingUTF',
                    'Navigation' => [
                        {
                            'Content' => 'Frontend::Agentß∂čćžšđ::ModuleRegistration',
                        },
                    ],
                    'Required' => '0',
                    'Valid'    => '1',
                    'Value'    => [
                        {
                            'Hash' => [
                                {
                                    'Item' => [
                                        {
                                            'Array' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Content' => 'Core.AgentTicketService.css',
                                                        },
                                                        {
                                                            'Content' => 'Core.AllocationList.css',
                                                        },
                                                    ],
                                                },
                                            ],
                                            'Key' => 'CSS'
                                        },
                                        {
                                            'Array' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Content' => 'Core.UI.AllocationList.js',
                                                        },
                                                        {
                                                            'Content' => 'Core.Agent.TableFilters.js',
                                                        },
                                                    ],
                                                },
                                            ],
                                            'Key' => 'JavaScript',
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
                'XMLContentRaw' =>
                    '<Setting Name="SettingUTF" Required="0" Valid="1">
        <Description Translatable="1">Check UTF-8.</Description>
        <Navigation>Frontend::Agentß∂čćžšđ::ModuleRegistration</Navigation>
        <Value>
            <Hash>
                <Item Key="CSS">
                    <Array>
                        <Item>Core.AgentTicketService.css</Item>
                        <Item>Core.AllocationList.css</Item>
                    </Array>
                </Item>
                <Item Key="JavaScript">
                    <Array>
                        <Item>Core.UI.AllocationList.js</Item>
                        <Item>Core.Agent.TableFilters.js</Item>
                    </Array>
                </Item>
            </Hash>
        </Value>
    </Setting>',
            },
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description'              => 'Defines the next state of a ticket.',
                'EffectiveValue'           => [
                    'open',
                    'pending reminder',
                ],
                'UserModificationActive' => '0',
                'ExclusiveLockGUID'      => '0',
                'ExclusiveLockUserID'    => undef,
                'HasConfigLevel'         => '100',
                'IsDirty'                => '1',
                'IsInvisible'            => '0',
                'IsReadonly'             => '0',
                'IsRequired'             => '1',
                'IsValid'                => '1',
                'Name'                   => 'Ticket::Frontend::AgentTicketResponsible###StateType',
                'Navigation'             => 'Frontend::Agent::Ticket::ViewResponsible',
                'XMLFilename'            => 'Sample.xml',
                'XMLContentParsed'       => {
                    'Description' => [
                        {
                            'Content'      => 'Defines the next state of a ticket.',
                            'Translatable' => '1',
                        },
                    ],
                    'Name'       => 'Ticket::Frontend::AgentTicketResponsible###StateType',
                    'Navigation' => [
                        {
                            'Content' => 'Frontend::Agent::Ticket::ViewResponsible',
                        },
                    ],
                    'Required' => '1',
                    'Valid'    => '1',
                    'Value'    => [
                        {
                            'Array' => [
                                {
                                    'Item' => [
                                        {
                                            'Content' => 'open',
                                        },
                                        {
                                            'Content' => 'pending reminder',
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
                'XMLContentRaw' =>
                    '<Setting Name="Ticket::Frontend::AgentTicketResponsible###StateType" Required="1" Valid="1">
        <Description Translatable="1">Defines the next state of a ticket.</Description>
        <Navigation>Frontend::Agent::Ticket::ViewResponsible</Navigation>
        <Value>
            <Array>
                <Item>open</Item>
                <Item>pending reminder</Item>
            </Array>
        </Value>
    </Setting>',
            },
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description'              => 'Restores a ticket from the archive.',
                'EffectiveValue'           => {
                    Module => 'Kernel::System::Ticket::Event::ArchiveRestore',
                    Event  => 'TicketStateUpdate',
                },
                'UserModificationActive' => '0',
                'ExclusiveLockGUID'      => '0',
                'ExclusiveLockUserID'    => undef,
                'HasConfigLevel'         => '100',
                'IsDirty'                => '1',
                'IsInvisible'            => '0',
                'IsReadonly'             => '0',
                'IsRequired'             => '0',
                'IsValid'                => '1',
                'Name'                   => 'Ticket::EventModulePost###100-ArchiveRestore',
                'Navigation'             => 'Core::Ticket',
                'XMLFilename'            => 'Sample.xml',
                'XMLContentParsed'       => {
                    'Description' => [
                        {
                            'Content'      => 'Restores a ticket from the archive.',
                            'Translatable' => '1',
                        },
                    ],
                    'Name'       => 'Ticket::EventModulePost###100-ArchiveRestore',
                    'Navigation' => [
                        {
                            'Content' => 'Core::Ticket',
                        },
                    ],
                    'Required' => '0',
                    'Valid'    => '1',
                    'Value'    => [
                        {
                            'Hash' => [
                                {
                                    'Item' => [
                                        {
                                            'Content' => 'Kernel::System::Ticket::Event::ArchiveRestore',
                                            'Key'     => 'Module',
                                        },
                                        {
                                            'Content' => 'TicketStateUpdate',
                                            'Key'     => 'Event',
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
                'XMLContentRaw' =>
                    '<Setting Name="Ticket::EventModulePost###100-ArchiveRestore" Required="0" Valid="1">
        <Description Translatable="1">Restores a ticket from the archive.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Hash>
                <Item Key="Module">Kernel::System::Ticket::Event::ArchiveRestore</Item>
                <Item Key="Event">TicketStateUpdate</Item>
            </Hash>
        </Value>
    </Setting>',
            },
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description'              => 'Specifies the available note types.',
                'EffectiveValue'           => {
                    'note-internal' => '1',
                    'note-external' => '0',
                    'note-report'   => '0',
                },
                'UserModificationActive' => '0',
                'ExclusiveLockGUID'      => '0',
                'ExclusiveLockUserID'    => undef,
                'HasConfigLevel'         => '100',
                'IsDirty'                => '1',
                'IsInvisible'            => '0',
                'IsReadonly'             => '0',
                'IsRequired'             => '0',
                'IsValid'                => '1',
                'Name'                   => 'Ticket::Frontend::AgentTicketPriority###ArticleTypes',
                'Navigation'             => 'Frontend::Agent::Ticket::ViewPriority',
                'XMLFilename'            => 'Sample.xml',
                'XMLContentParsed'       => {
                    'Description' => [
                        {
                            'Content'      => 'Specifies the available note types.',
                            'Translatable' => '1',
                        }
                    ],
                    'Name'       => 'Ticket::Frontend::AgentTicketPriority###ArticleTypes',
                    'Navigation' => [
                        {
                            'Content' => 'Frontend::Agent::Ticket::ViewPriority',
                        },
                    ],
                    'Required' => '0',
                    'Valid'    => '1',
                    'Value'    => [
                        {
                            'Hash' => [
                                {
                                    'Item' => [
                                        {
                                            'Content' => '1',
                                            'Key'     => 'note-internal',
                                        },
                                        {
                                            'Content' => '0',
                                            'Key'     => 'note-external',
                                        },
                                        {
                                            'Content' => '0',
                                            'Key'     => 'note-report',
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
                'XMLContentRaw' =>
                    '<Setting Name="Ticket::Frontend::AgentTicketPriority###ArticleTypes" Required="0" Valid="1">
        <Description Translatable="1">Specifies the available note types.</Description>
        <Navigation>Frontend::Agent::Ticket::ViewPriority</Navigation>
        <Value>
            <Hash>
                <Item Key="note-internal">1</Item>
                <Item Key="note-external">0</Item>
                <Item Key="note-report">0</Item>
            </Hash>
        </Value>
    </Setting>',
            },
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description'              => 'Shows a list of all the involved agents.',
                'EffectiveValue'           => '0',
                'UserModificationActive'   => '0',
                'ExclusiveLockGUID'        => '0',
                'ExclusiveLockUserID'      => undef,
                'HasConfigLevel'           => '100',
                'IsDirty'                  => '1',
                'IsInvisible'              => '0',
                'IsReadonly'               => '0',
                'IsRequired'               => '1',
                'IsValid'                  => '1',
                'Name'                     => 'Ticket::Frontend::AgentTicketPriority###InvolvedAgent',
                'Navigation'               => 'Frontend::Agent::Ticket::ViewPriority',
                'XMLFilename'              => 'Sample.xml',
                'XMLContentParsed'         => {
                    'Description' => [
                        {
                            'Content'      => 'Shows a list of all the involved agents.',
                            'Translatable' => '1',
                        },
                    ],
                    'Name'       => 'Ticket::Frontend::AgentTicketPriority###InvolvedAgent',
                    'Navigation' => [
                        {
                            'Content' => 'Frontend::Agent::Ticket::ViewPriority'
                        },
                    ],
                    'Required' => '1',
                    'Valid'    => '1',
                    'Value'    => [
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
                'XMLContentRaw' =>
                    '<Setting Name="Ticket::Frontend::AgentTicketPriority###InvolvedAgent" Required="1" Valid="1">
        <Description Translatable="1">Shows a list of all the involved agents.</Description>
        <Navigation>Frontend::Agent::Ticket::ViewPriority</Navigation>
        <Value>
            <Item ValueType="Checkbox">0</Item>
        </Value>
    </Setting>',
            },
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description'              => 'The identifier for a ticket.',
                'EffectiveValue'           => 'Ticket#',
                'UserModificationActive'   => '0',
                'ExclusiveLockGUID'        => '0',
                'ExclusiveLockUserID'      => undef,
                'HasConfigLevel'           => '100',
                'IsDirty'                  => '1',
                'IsInvisible'              => '0',
                'IsReadonly'               => '0',
                'IsRequired'               => '1',
                'IsValid'                  => '1',
                'Name'                     => 'Ticket::Hook',
                'Navigation'               => 'Core::Ticket',
                'XMLFilename'              => 'Sample.xml',
                'XMLContentParsed'         => {
                    'Description' => [
                        {
                            'Content'      => 'The identifier for a ticket.',
                            'Translatable' => '1',
                        },
                    ],
                    'Name'       => 'Ticket::Hook',
                    'Navigation' => [
                        {
                            'Content' => 'Core::Ticket',
                        },
                    ],
                    'Required' => '1',
                    'Valid'    => '1',
                    'Value'    => [
                        {
                            'Item' => [
                                {
                                    'Content'    => 'Ticket#',
                                    'ValueRegex' => '',
                                    'ValueType'  => 'String',
                                },
                            ],
                        },
                    ],
                },
                'XMLContentRaw' => '<Setting Name="Ticket::Hook" Required="1" Valid="1">
        <Description Translatable="1">The identifier for a ticket.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex="">Ticket#</Item>
        </Value>
    </Setting>'
            },
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description'              => 'Frontend module registration.',
                'EffectiveValue'           => {
                    Description => 'Overview of all open Tickets.',
                    Title       => 'ServiceView',
                    NavBarName  => 'Ticket',
                    NavBar      => [
                        {
                            Description => 'Overview of all open Tickets.',
                            Name        => 'Service view',
                            Link        => 'Action=AgentTicketService',
                            NavBar      => 'Ticket',
                            Prio        => '105',
                        },
                    ],
                },
                'UserModificationActive' => '0',
                'ExclusiveLockGUID'      => '0',
                'ExclusiveLockUserID'    => undef,
                'HasConfigLevel'         => '100',
                'IsDirty'                => '1',
                'IsInvisible'            => '0',
                'IsReadonly'             => '0',
                'IsRequired'             => '0',
                'IsValid'                => '1',
                'Name'                   => 'Frontend::Module###AgentTicketService',
                'Navigation'             => 'Frontend::Agent::ModuleRegistration',
                'XMLFilename'            => 'Sample.xml',
                'XMLContentParsed'       => {
                    'Description' => [
                        {
                            'Content'      => 'Frontend module registration.',
                            'Translatable' => '1',
                        },
                    ],
                    'Name'       => 'Frontend::Module###AgentTicketService',
                    'Navigation' => [
                        {
                            'Content' => 'Frontend::Agent::ModuleRegistration',
                        },
                    ],
                    'Required' => '0',
                    'Valid'    => '1',
                    'Value'    => [
                        {
                            'Hash' => [
                                {
                                    'Item' => [
                                        {
                                            'Content'      => 'Overview of all open Tickets.',
                                            'Key'          => 'Description',
                                            'Translatable' => '1',
                                        },
                                        {
                                            'Content'      => 'ServiceView',
                                            'Key'          => 'Title',
                                            'Translatable' => '1',
                                        },
                                        {
                                            'Content' => 'Ticket',
                                            'Key'     => 'NavBarName',
                                        },
                                        {
                                            'Array' => [
                                                {
                                                    'Item' => [
                                                        {
                                                            'Hash' => [
                                                                {
                                                                    'Item' => [
                                                                        {
                                                                            'Content' =>
                                                                                'Overview of all open Tickets.',
                                                                            'Key'          => 'Description',
                                                                            'Translatable' => '1',
                                                                        },
                                                                        {
                                                                            'Content'      => 'Service view',
                                                                            'Key'          => 'Name',
                                                                            'Translatable' => '1',
                                                                        },
                                                                        {
                                                                            'Content' => 'Action=AgentTicketService',
                                                                            'Key'     => 'Link',
                                                                        },
                                                                        {
                                                                            'Content' => 'Ticket',
                                                                            'Key'     => 'NavBar',
                                                                        },
                                                                        {
                                                                            'Content' => '105',
                                                                            'Key'     => 'Prio',
                                                                        },
                                                                    ],
                                                                },
                                                            ],
                                                        },
                                                    ],
                                                },
                                            ],
                                            'Key' => 'NavBar',
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
                'XMLContentRaw' => '<Setting Name="Frontend::Module###AgentTicketService" Required="0" Valid="1">
        <Description Translatable="1">Frontend module registration.</Description>
        <Navigation>Frontend::Agent::ModuleRegistration</Navigation>
        <Value>
            <Hash>
                <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                <Item Key="Title" Translatable="1">ServiceView</Item>
                <Item Key="NavBarName">Ticket</Item>
                <Item Key="NavBar">
                    <Array>
                        <Item>
                            <Hash>
                                <Item Key="Description" Translatable="1">Overview of all open Tickets.</Item>
                                <Item Key="Name" Translatable="1">Service view</Item>
                                <Item Key="Link">Action=AgentTicketService</Item>
                                <Item Key="NavBar">Ticket</Item>
                                <Item Key="Prio">105</Item>
                            </Hash>
                        </Item>
                    </Array>
                </Item>
            </Hash>
        </Value>
    </Setting>',
            },
            {
                'CreateBy'                 => 1,
                'ChangeBy'                 => 1,
                'UserModificationPossible' => '0',
                'UserPreferencesGroup'     => '',
                'Description'              => 'Sets the default body text for notes.',
                'EffectiveValue'           => '',
                'UserModificationActive'   => '0',
                'ExclusiveLockGUID'        => '0',
                'ExclusiveLockUserID'      => undef,
                'HasConfigLevel'           => '100',
                'IsDirty'                  => '1',
                'IsInvisible'              => '0',
                'IsReadonly'               => '0',
                'IsRequired'               => '0',
                'IsValid'                  => '1',
                'Name'                     => 'Ticket::Frontend::AgentTicketPriority###Body',
                'Navigation'               => 'Frontend::Agent::Ticket::ViewPriority',
                'XMLFilename'              => 'Sample.xml',
                'XMLContentParsed'         => {
                    'Description' => [
                        {
                            'Content'      => 'Sets the default body text for notes.',
                            'Translatable' => '1',
                        },
                    ],
                    'Name'       => 'Ticket::Frontend::AgentTicketPriority###Body',
                    'Navigation' => [
                        {
                            'Content' => 'Frontend::Agent::Ticket::ViewPriority',
                        },
                    ],
                    'Required' => '0',
                    'Valid'    => '1',
                    'Value'    => [
                        {
                            'Item' => [
                                {
                                    'ValueType' => 'Textarea',
                                },
                            ],
                        },
                    ],
                },
                'XMLContentRaw' =>
                    '<Setting Name="Ticket::Frontend::AgentTicketPriority###Body" Required="0" Valid="1">
        <Description Translatable="1">Sets the default body text for notes.</Description>
        <Navigation>Frontend::Agent::Ticket::ViewPriority</Navigation>
        <Value>
            <Item ValueType="Textarea"></Item>
        </Value>
    </Setting>'
            },
            {
                CreateBy                 => 1,
                ChangeBy                 => 1,
                UserModificationPossible => 0,
                UserPreferencesGroup     => '',
                Description              => 'Event module that updates customer user object name for dynamic fields.',
                EffectiveValue           => {
                    Event       => 'CustomerUserUpdate',
                    Module      => 'Kernel::System::CustomerUser::Event::DynamicFieldObjectNameUpdate',
                    Transaction => '0',
                },
                UserModificationActive => '0',
                ExclusiveLockGUID      => '0',
                ExclusiveLockUserID    => undef,
                HasConfigLevel         => 100,
                IsDirty                => 1,
                IsInvisible            => 0,
                IsReadonly             => 0,
                IsRequired             => 0,
                IsValid                => 1,
                Name                   => 'CustomerUser::EventModulePost###100-UpdateDynamicFieldObjectNameTest',
                Navigation             => 'Core::CustomerUser',
                XMLFilename            => 'Sample.xml',
                XMLContentParsed       => {
                    Description => [
                        {
                            'Content'      => 'Event module that updates customer user object name for dynamic fields.',
                            'Translatable' => '1',
                        },
                    ],
                    Name       => 'CustomerUser::EventModulePost###100-UpdateDynamicFieldObjectNameTest',
                    Navigation => [
                        {
                            Content => 'Core::CustomerUser',
                        }
                    ],
                    Required => '0',
                    Valid    => '1',
                    Value    => [
                        {
                            Hash => [
                                {
                                    Item => [
                                        {
                                            Content =>
                                                'Kernel::System::CustomerUser::Event::DynamicFieldObjectNameUpdate',
                                            Key => 'Module',
                                        },
                                        {
                                            Content => 'CustomerUserUpdate',
                                            Key     => 'Event',
                                        },
                                        {
                                            Content => '0',
                                            Key     => 'Transaction',
                                        },
                                    ],
                                },
                            ],
                        },
                    ],
                },
                XMLContentRaw =>
                    '<Setting Name="CustomerUser::EventModulePost###100-UpdateDynamicFieldObjectNameTest" Required="0" Valid="1">
        <Description Translatable="1">Event module that updates customer user object name for dynamic fields.</Description>
        <Navigation>Core::CustomerUser</Navigation>
        <Value>
            <Hash>
                <Item Key="Module">Kernel::System::CustomerUser::Event::DynamicFieldObjectNameUpdate</Item>
                <Item Key="Event">CustomerUserUpdate</Item>
                <Item Key="Transaction">0</Item>
            </Hash>
        </Value>
    </Setting>',
            },
            {
                CreateBy                 => 1,
                ChangeBy                 => 1,
                Name                     => 'TestWithLineBreaks',
                Description              => 'Test.',
                IsValid                  => 1,
                IsRequired               => 0,
                IsInvisible              => 0,
                IsReadonly               => 0,
                HasConfigLevel           => 100,
                UserModificationPossible => 0,
                UserPreferencesGroup     => '',
                Navigation               => 'Core::CustomerUser',
                IsDirty                  => 1,
                UserModificationActive   => '0',
                ExclusiveLockGUID        => '0',
                ExclusiveLockUserID      => undef,
                XMLFilename              => 'Sample.xml',
                XMLContentRaw =>
                    '<Setting Name="TestWithLineBreaks" Required="0" Valid="1">
        <Description>Test.</Description>
        <Navigation>Core::CustomerUser</Navigation>
        <Value>
            <Hash>
                <Item Key="Column">Other Settings</Item>
                <Item Key="Data">
                    <Hash>
                        <Item Key="0">
                            off
                        </Item>
                        <Item Key="2"> 2 minutes</Item>
                        <Item Key="ItemSeparator">, </Item>
                    </Hash>
                </Item>
            </Hash>
        </Value>
    </Setting>',
                XMLContentParsed => {
                    Description => [
                        {
                            'Content' => 'Test.',
                        },
                    ],
                    Name       => 'TestWithLineBreaks',
                    Navigation => [
                        {
                            Content => 'Core::CustomerUser',
                        }
                    ],
                    Required => '0',
                    Valid    => '1',
                    Value    => [
                        {
                            Hash => [
                                {
                                    Item => [
                                        {
                                            Key => 'Column',
                                            Content =>
                                                'Other Settings',
                                        },
                                        {
                                            Key  => 'Data',
                                            Hash => [
                                                {
                                                    Item => [
                                                        {
                                                            Key => '0',
                                                            Content =>
                                                                "\n                            off\n                        ",
                                                        },
                                                        {
                                                            Key     => '2',
                                                            Content => ' 2 minutes',
                                                        },
                                                        {
                                                            Key     => 'ItemSeparator',
                                                            Content => ', ',
                                                        },

                                                    ],
                                                },
                                            ],
                                        }
                                    ],
                                },
                            ],
                        },
                    ],
                },
                EffectiveValue => {
                    Column => 'Other Settings',
                    Data   => {
                        '0'             => 'off',
                        '2'             => ' 2 minutes',
                        'ItemSeparator' => ', ',
                    },
                },
            },
            {
                CreateBy                 => 1,
                ChangeBy                 => 1,
                Name                     => 'EmptyHash',
                Description              => 'Test.',
                IsValid                  => 1,
                IsRequired               => 0,
                IsInvisible              => 0,
                IsReadonly               => 0,
                HasConfigLevel           => 100,
                UserModificationPossible => 0,
                UserPreferencesGroup     => '',
                Navigation               => 'Core::CustomerUser',
                IsDirty                  => 1,
                UserModificationActive   => '0',
                ExclusiveLockGUID        => '0',
                ExclusiveLockUserID      => undef,
                XMLFilename              => 'Sample.xml',
                XMLContentRaw =>
                    '<Setting Name="EmptyHash" Required="0" Valid="1">
        <Description>Test.</Description>
        <Navigation>Core::CustomerUser</Navigation>
        <Value>
            <Hash>
            </Hash>
        </Value>
    </Setting>',
                XMLContentParsed => {
                    Description => [
                        {
                            'Content' => 'Test.',
                        },
                    ],
                    Name       => 'EmptyHash',
                    Navigation => [
                        {
                            Content => 'Core::CustomerUser',
                        }
                    ],
                    Required => '0',
                    Valid    => '1',
                    Value    => [
                        {
                            Hash => [
                                {
                                    'Content' => "\n            "
                                },
                            ],
                        },
                    ],
                },
                EffectiveValue => {},
            },
            {
                CreateBy                 => 1,
                ChangeBy                 => 1,
                Name                     => 'EmptyArray',
                Description              => 'Test.',
                IsValid                  => 1,
                IsRequired               => 0,
                IsInvisible              => 0,
                IsReadonly               => 0,
                HasConfigLevel           => 100,
                UserModificationPossible => 0,
                UserPreferencesGroup     => '',
                Navigation               => 'Core::CustomerUser',
                IsDirty                  => 1,
                UserModificationActive   => '0',
                ExclusiveLockGUID        => '0',
                ExclusiveLockUserID      => undef,
                XMLFilename              => 'Sample.xml',
                XMLContentRaw =>
                    '<Setting Name="EmptyArray" Required="0" Valid="1">
        <Description>Test.</Description>
        <Navigation>Core::CustomerUser</Navigation>
        <Value>
            <Array>
            </Array>
        </Value>
    </Setting>',
                XMLContentParsed => {
                    Description => [
                        {
                            'Content' => 'Test.',
                        },
                    ],
                    Name       => 'EmptyArray',
                    Navigation => [
                        {
                            Content => 'Core::CustomerUser',
                        }
                    ],
                    Required => '0',
                    Valid    => '1',
                    Value    => [
                        {
                            Array => [
                                {
                                    'Content' => "\n            "
                                },
                            ],
                        },
                    ],
                },
                EffectiveValue => [],
            },
        ],
    },
    {
        # It contains same setting "Ticket::Hook" but the XML filename is different.
        #     Make sure that it's recognized with a new filename.
        Description => 'Load another sample XML file.',
        Config      => {
            UserID    => 1,
            Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XMLFilename/",
            CleanUp   => 1,
        },
        ExpectedResult => [
            {
                "ChangeBy"                 => 1,
                "CreateBy"                 => 1,
                "Description"              => "The identifier for a ticket.",
                "EffectiveValue"           => "Ticket#",
                "ExclusiveLockGUID"        => 0,
                "ExclusiveLockUserID"      => undef,
                "HasConfigLevel"           => 100,
                "IsDirty"                  => 1,
                "IsInvisible"              => 0,
                "IsReadonly"               => 0,
                "IsRequired"               => 1,
                "IsValid"                  => 1,
                "Name"                     => "Ticket::Hook",
                "Navigation"               => "Core::Ticket",
                "UserModificationActive"   => 0,
                "UserModificationPossible" => 0,
                "UserPreferencesGroup"     => "",
                "XMLContentParsed"         => {
                    "Description" => [
                        {
                            "Content"      => "The identifier for a ticket.",
                            "Translatable" => 1,
                        },
                    ],
                    "Name"       => "Ticket::Hook",
                    "Navigation" => [
                        {
                            "Content" => "Core::Ticket"
                        },
                    ],
                    "Required" => 1,
                    "Valid"    => 1,
                    "Value"    => [
                        {
                            "Item" => [
                                {
                                    "Content"    => "Ticket#",
                                    "ValueRegex" => "",
                                    "ValueType"  => "String",
                                },
                            ],
                        },
                    ],
                },
                "XMLContentRaw" =>
                    "<Setting Name=\"Ticket::Hook\" Required=\"1\" Valid=\"1\">\n        <Description Translatable=\"1\">The identifier for a ticket.</Description>\n        <Navigation>Core::Ticket</Navigation>\n        <Value>\n            <Item ValueType=\"String\" ValueRegex=\"\">Ticket#</Item>\n        </Value>\n    </Setting>",
                "XMLFilename" => "SampleFilename.xml",
            },
        ],
    },
);

for my $Test (@Tests) {
    my $Result = $SysConfigObject->ConfigurationXML2DB( %{ $Test->{Config} } );

    if ($Result) {
        my @DefaultSettingList = $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DefaultSettingListGet();

        # Delete setting attributes that are always different
        for my $Setting (@DefaultSettingList) {
            delete $Setting->{CreateTime};
            delete $Setting->{ChangeTime};
            delete $Setting->{DefaultID};
            delete $Setting->{ExclusiveLockExpiryTime};
            delete $Setting->{SettingUID};
        }

        $Self->Is(
            scalar @DefaultSettingList,
            scalar @{ $Test->{ExpectedResult} },
            "Check result length.",
        );

        for my $Item ( @{ $Test->{ExpectedResult} } ) {

            my @Found = grep { $DefaultSettingList[$_]->{Name} eq $Item->{Name} } 0 .. $#DefaultSettingList;

            $Self->True(
                scalar @Found,
                "Check if Config item ($Item->{Name}) is there.",
            );

            if ( scalar @Found ) {

                # Compare
                $Self->IsDeeply(
                    $DefaultSettingList[ $Found[0] ],
                    $Item,
                    "Check Config Item ($Item->{Name}) deeply.",
                );
            }
        }
    }
    else {
        $Self->Is(
            $Result,
            $Test->{ExpectedResult},
            "Compare result",
        );
    }
}

# cleanup cache
my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
$CacheObject->CleanUp(
    Type => 'SysConfigDefault',
);
$CacheObject->CleanUp(
    Type => 'SysConfigDefaultListGet',
);
$CacheObject->CleanUp(
    Type => 'SysConfigDefaultList',
);

1;
