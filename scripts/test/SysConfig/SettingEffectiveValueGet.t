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
        Name  => 'ValueType is String (Unicode)',
        Param => {
            Value => [
                {
                    'Item' => [
                        {
                            'Content'    => 'Unicode string ßå∂čćžšđ',
                            'ValueRegex' => '',
                            'ValueType'  => 'String'
                        }
                    ],
                }
            ]
        },
        ExpectedValue => 'Unicode string ßå∂čćžšđ'
    },
    {
        Name  => 'ValueType is String 0',
        Param => {
            Value => [
                {
                    'Item' => [
                        {
                            'Content'    => '0',
                            'ValueRegex' => '',
                            'ValueType'  => 'String'
                        }
                    ],
                }
            ]
        },
        ExpectedValue => '0'
    },
    {
        Name  => 'Missing ValueType (Unicode)',
        Param => {
            Value => [
                {
                    'Item' => [
                        {
                            'Content'    => 'Unicode string ßå∂čćžšđ',
                            'ValueRegex' => '',
                        }
                    ],
                }
            ]
        },
        ExpectedValue => 'Unicode string ßå∂čćžšđ'
    },
    {
        Name  => 'Invalid ValueType',
        Param => {
            Value => [
                {
                    'Item' => [
                        {
                            'Content'    => 'Unicode string ßå∂čćžšđ',
                            'ValueRegex' => '',
                            'ValueType'  => 'InvalidValueType'
                        }
                    ],
                }
            ]
        },
        ExpectedValue => undef,
    },
    {
        Name  => 'Hash',
        Param => {
            Value => [
                {
                    'Hash' => [
                        {
                            'Item' => [
                                {
                                    'Content' => '  PossibleContent  ',
                                    'Key'     => 'Possible'
                                },
                                {
                                    'Content' => 'PossibleAddContent',
                                    'Key'     => 'PossibleAdd'
                                },
                                {
                                    'Content' => '
                                        PossibleContent
                                    ',
                                    'Key' => 'PossibleNew'
                                },

                                {
                                    'Key' => 'NoContent',
                                },
                                {
                                    'Key'     => 'Value0',
                                    'Content' => 0,
                                },
                                {
                                    'Key'     => '0',
                                    'Content' => 0,
                                },

                            ],
                        },
                    ],
                },
            ],
        },
        ExpectedValue => {
            Possible    => '  PossibleContent  ',
            PossibleAdd => 'PossibleAddContent',
            PossibleNew => 'PossibleContent',
            NoContent   => '',
            Value0      => '0',
            '0'         => '0',
        },
    },
    {
        Name  => 'Array',
        Param => {
            Value => [
                {
                    'Array' => [
                        {
                            'Item' => [
                                {
                                    'Content' => '  AgentTicketBounce  '
                                },
                                {
                                    'Content' => 'AgentTicketClose'
                                },
                                {
                                    'Content' => "\nAgentTicketNote\n"
                                },
                                {
                                    'Content' => 0,
                                },
                            ],
                        },
                    ],
                },
            ],
        },
        ExpectedValue => [
            '  AgentTicketBounce  ',
            'AgentTicketClose',
            'AgentTicketNote',
            '0',
        ],
    },
    {
        Name  => 'HoH',
        Param => {
            Value => [
                {
                    'Hash' => [
                        {
                            'Item' => [
                                {
                                    'Content' => 'Kernel::Output::HTML::Dashboard::TicketGeneric',
                                    'Key'     => 'Module'
                                },
                                {
                                    'Content'      => 'Reminder Tickets',
                                    'Key'          => 'Title',
                                    'Translatable' => '1'
                                },
                                {
                                    'Hash' => [
                                        {
                                            'Item' => [
                                                {
                                                    'Content' => '2',
                                                    'Key'     => 'Age'
                                                },
                                            ],
                                        },
                                    ],
                                    'Key' => 'DefaultColumns',
                                },
                            ],
                        },
                    ],
                },
            ],
        },
        ExpectedValue => {
            Module         => 'Kernel::Output::HTML::Dashboard::TicketGeneric',
            Title          => 'Reminder Tickets',
            DefaultColumns => {
                Age => '2',
            },
        },
    },
    {
        Name  => 'HoAoH',
        Param => {
            Value => [
                {
                    'Hash' => [
                        {
                            'Item' => [
                                {
                                    'Content'      => 'Create tickets.',
                                    'Key'          => 'Description',
                                    'Translatable' => '1'
                                },
                                {
                                    'Content' => 'Ticket',
                                    'Key'     => 'NavBarName'
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
                                                                    'Content'      => 'Create new Ticket.',
                                                                    'Key'          => 'Description',
                                                                    'Translatable' => '1'
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
        ExpectedValue => {
            Description => 'Create tickets.',
            NavBarName  => 'Ticket',
            NavBar      => [
                {
                    Description => 'Create new Ticket.',
                }
            ],
        },
    },
    {
        Name  => 'AoA',
        Param => {
            Value => [
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
                                {
                                    'Content' => '3',
                                },
                            ],
                        },
                    ],
                },
            ],
        },
        ExpectedValue => [
            [
                '1',
                '2'
            ],
            '3'
        ],
    },
    {
        Name  => 'Missing Value',
        Param => {
        },
        ExpectedValue => undef,
    },
    {
        Name  => 'Empty Hash',
        Param => {
            Value => [
                {
                    'Hash' => [
                        {

                        },
                    ],
                },
            ],
        },
        ExpectedValue => {},
    },
    {
        Name  => 'Empty Array',
        Param => {
            Value => [
                {
                    'Array' => [
                        {
                        },
                    ],
                },
            ],
        },
        ExpectedValue => [],
    },
    {
        Name  => 'Array of Selects with defined Custom Param in DefaultItem',
        Param => {
            Value => [
                {
                    'Array' => [
                        {
                            'DefaultItem' => [
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
                            'Item' => [
                                {
                                    SelectedID => '3',
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
                    ],
                },
            ],
        },
        ExpectedValue => [
            '3',
            '2',
        ],
    },
    {
        Name  => 'Hash of Selects with defined Custom Param in DefaultItem',
        Param => {
            Value => [
                {
                    'Hash' => [
                        {
                            'DefaultItem' => [
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
                            'Item' => [
                                {
                                    Key        => 'First',
                                    SelectedID => '3',
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
                                {
                                    Key        => 'Second',
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
                    ],
                },
            ],
        },
        ExpectedValue => {
            'First'  => '3',
            'Second' => '2',
        },
    },
);

for my $Test (@Tests) {

    my $EffectiveValue = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingEffectiveValueGet(
        %{ $Test->{Param} }
    );
    if ($EffectiveValue) {
        $Self->IsDeeply(
            $EffectiveValue,
            $Test->{ExpectedValue},
            "$Test->{Name} EffectiveValueGet()",
        );
    }
    else {
        $Self->False(
            $Test->{ExpectedValue},
            "$Test->{Name} EffectiveValueGet()",
        );
    }
}

1;
