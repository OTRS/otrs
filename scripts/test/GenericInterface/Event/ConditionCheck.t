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

# Prevent used once warning
use Kernel::System::ObjectManager;
use vars (qw($Self));

my @Tests = (
    {
        Name   => 'Empty Data',
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {
                        Queue                => ['Raw'],
                        DynamicField_Make    => ['2'],
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data    => '',
                Success => 0,
            }
        ],
    },
    {
        Name   => 'Missing Condition',
        Config => {
            Condition => {},
        },
        Dataset => [
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => ['2'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => 'Unknown ConditionLinking',
        Config => {
            ConditionLinking => 'unknown123',
            Condition        => {
                Cond1 => {
                    Fields => {
                        Queue                => ['Raw'],
                        DynamicField_Make    => ['2'],
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => ['2'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => 'Missing Condition Fields',
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {},
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => ['2'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => 'Unknown Condition Type',
        Config => {
            Condition => {
                Cond1 => {
                    Type   => 'unknown',
                    Fields => {
                        Queue                => ['Raw'],
                        DynamicField_Make    => ['2'],
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => ['2'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => 'String Type Field with Array Match',
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {
                        Queue => {
                            Type  => 'String',
                            Match => ['Raw'],
                        },
                        DynamicField_Make    => ['2'],
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => 'Raw',
                    DynamicField_Make    => ['2'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },

    {
        Name   => 'String Type Field with Array Value',
        Config => {
            Condition => {
                Cond1 => {
                    Type   => 'and',
                    Fields => {
                        DynamicField_Make => {
                            Type  => 'String',
                            Match => 'Test2',
                        },
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    DynamicField_Make => [ 'Test1', 'Test2', 'Test3' ],
                },
                Success => 1,
            },
            {
                Data => {
                    DynamicField_Make => [ 'Test1', 'Test3', 'Test4' ],
                },
                Success => 0,
            },
        ],
    },

    {
        Name   => 'String Type Field with Array Value Flatten',
        Config => {
            Condition => {
                Cond1 => {
                    Type   => 'and',
                    Fields => {
                        DynamicField_Make => {
                            Type  => 'String',
                            Match => 'Test2',
                        },
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    DynamicField_Make_1 => 'Test1',
                    DynamicField_Make_2 => 'Test2',
                    DynamicField_Make_3 => 'Test3',
                },
                Success => 1,
            },
            {
                Data => {
                    DynamicField_Make_1 => 'Test1',
                    DynamicField_Make_2 => 'Test3',
                    DynamicField_Make_3 => 'Test4',
                },
                Success => 0,
            },
        ],
    },

    {
        Name   => 'Regexp Type Field with Array Value',
        Config => {
            Condition => {
                Cond1 => {
                    Type   => 'and',
                    Fields => {
                        DynamicField_Make => {
                            Type  => 'Regexp',
                            Match => qr/t2$/,
                        },
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    DynamicField_Make => [ 'Test1', 'Test2', 'Test3' ],
                },
                Success => 1,
            },
            {
                Data => {
                    DynamicField_Make => [ 'Test1', 'Test3', 'Test4' ],
                },
                Success => 0,
            },
        ],
    },

    {
        Name   => 'Regexp Type Field with Array Value Flatten',
        Config => {
            Condition => {
                Cond1 => {
                    Type   => 'and',
                    Fields => {
                        DynamicField_Make => {
                            Type  => 'Regexp',
                            Match => qr/t2$/,
                        },
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    DynamicField_Make_1 => 'Test1',
                    DynamicField_Make_2 => 'Test2',
                    DynamicField_Make_3 => 'Test3',
                },
                Success => 1,
            },
            {
                Data => {
                    DynamicField_Make_1 => 'Test1',
                    DynamicField_Make_2 => 'Test3',
                    DynamicField_Make_3 => 'Test4',
                },
                Success => 0,
            },

        ],
    },
    {
        Name   => "Condition Type 'and'",
        Config => {
            Condition => {
                Cond1 => {
                    Type   => 'and',
                    Fields => {
                        Queue             => ['Raw'],
                        DynamicField_Make => {
                            Type  => 'Hash',
                            Match => {
                                1 => 7,
                                2 => 8,
                                3 => 11,
                            },
                        },
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue             => ['Raw'],
                    DynamicField_Make => {
                        1 => 7,
                        2 => 8,
                        3 => 11,
                    },
                    DynamicField_VWModel => ['2'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue             => ['Raw'],
                    DynamicField_Make => {
                        1 => 8,
                        2 => 8,
                        3 => 11,
                    },
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },

    {
        Name   => "Condition Type 'and' using Regexp",
        Config => {
            Condition => {
                Cond1 => {
                    Type   => 'and',
                    Fields => {
                        Queue => {
                            Type  => 'String',
                            Match => 'Raw',
                        },
                        DynamicField_VWModel => {
                            Type  => 'Regexp',
                            Match => '\d+',
                        },
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => 'Raw',
                    DynamicField_VWModel => '2',
                },
                Success => 1,
            },
            {
                Data => {
                    Queue                => 'Raw',
                    DynamicField_VWModel => 'a',
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "Condition Type 'or'",
        Config => {
            Condition => {
                Cond1 => {
                    Type   => 'or',
                    Fields => {
                        Queue             => ['Raw'],
                        DynamicField_Make => {
                            Type  => 'Hash',
                            Match => {
                                1 => 2,
                                2 => 3,
                                3 => 4,
                            },
                        },
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue             => ['Raw'],
                    DynamicField_Make => {
                        1 => 7,
                        2 => 8,
                        3 => 11,
                    },
                    DynamicField_VWModel => ['2'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue             => ['Raw2'],
                    DynamicField_Make => {
                        1 => 7,
                        2 => 8,
                        3 => 11,
                    },
                    DynamicField_VWModel => ['3'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "Condition Type 'xor' Success",
        Config => {
            Condition => {
                Cond1 => {
                    Type   => 'xor',
                    Fields => {
                        Queue             => ['Raw'],
                        DynamicField_Make => {
                            Type  => 'Hash',
                            Match => {
                                1 => 2,
                                2 => 3,
                                3 => 4,
                            },
                        },
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue             => ['Raw'],
                    DynamicField_Make => {
                        1 => 7,
                        2 => 8,
                        3 => 11,
                    },
                    DynamicField_VWModel => ['1'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue             => ['Raw'],
                    DynamicField_Make => {
                        1 => 7,
                        2 => 8,
                        3 => 11,
                    },
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "ConditionLinking 'and'",
        Config => {
            Condition => {
                ConditionLinking => 'and',
                Cond1            => {
                    Fields => {
                        Queue => ['Raw'],
                    },
                },
                Cond2 => {
                    Fields => {
                        DynamicField_Make => {
                            Type  => 'Hash',
                            Match => {
                                1 => 2,
                                2 => 3,
                                3 => 4,
                            },
                        },
                    },
                },
                Cond3 => {
                    Fields => {
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue             => ['Raw'],
                    DynamicField_Make => {
                        1 => 2,
                        2 => 3,
                        3 => 4,
                    },
                    DynamicField_VWModel => ['2'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue             => ['Raw'],
                    DynamicField_Make => {
                        1 => 2,
                        2 => 19,
                        3 => 4,
                    },
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "ConditionLinking 'or'",
        Config => {
            ConditionLinking => 'or',
            Condition        => {
                Cond1 => {
                    Fields => {
                        Queue => ['Raw'],
                    },
                },
                Cond2 => {
                    Fields => {
                        DynamicField_Make => ['VW'],
                    },
                },
                Cond3 => {
                    Fields => {
                        DynamicField_VWModel => ['3'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => ['PostMaster'],
                    DynamicField_Make    => ['VW'],
                    DynamicField_VWModel => ['3'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue                => ['PostMaster'],
                    DynamicField_Make    => ['Seat'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "ConditionLinking 'xor'",
        Config => {
            ConditionLinking => 'xor',
            Condition        => {
                Cond1 => {
                    Fields => {
                        Queue => ['Raw'],
                    },
                },
                Cond2 => {
                    Fields => {
                        DynamicField_Make => ['VW'],
                    },
                },
                Cond3 => {
                    Fields => {
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => ['PostMaster'],
                    DynamicField_Make    => ['VW'],
                    DynamicField_VWModel => ['3'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue                => ['PostMaster'],
                    DynamicField_Make    => ['VW'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "Hash Field",
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {
                        Queue             => ['Raw'],
                        DynamicField_Make => {
                            Type  => 'Hash',
                            Match => {
                                1 => 2,
                                2 => 3,
                                3 => 4,
                            },
                        },
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue             => ['Raw'],
                    DynamicField_Make => {
                        1 => 2,
                        2 => 3,
                        3 => 4,
                    },
                    DynamicField_VWModel => ['2'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue             => ['Raw'],
                    DynamicField_Make => {
                        1 => 1,
                        2 => 3,
                        3 => 4,
                    },
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "Array Field",
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {
                        Queue                => ['Raw'],
                        DynamicField_Make    => ['2'],
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => ['2'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => ['1'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "String Field",
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {
                        Queue => {
                            Type  => 'String',
                            Match => 'Raw',
                        },
                        DynamicField_Make    => ['2'],
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => 'Raw',
                    DynamicField_Make    => ['2'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue                => 'Postmaster',
                    DynamicField_Make    => ['2'],
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "Regexp Field",
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {
                        Queue => ['Raw'],
                    },
                },
                Cond2 => {
                    Fields => {
                        DynamicField_Make => {
                            Type  => 'Regexp',
                            Match => qr/^VW$/,
                        },
                    },
                },
                Cond3 => {
                    Fields => {
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => 'VW',
                    DynamicField_VWModel => ['2'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => 'oVW',
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "PlainTextRegexp Field",
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {
                        Queue => ['Raw'],
                    },
                },
                Cond2 => {
                    Fields => {
                        DynamicField_Make => {
                            Type  => 'Regexp',
                            Match => '^VW$',
                        },
                    },
                },
                Cond3 => {
                    Fields => {
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => 'VW',
                    DynamicField_VWModel => ['2'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => 'oVW',
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "PlainText Invalid Regexp Field",
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {
                        Queue => ['Raw'],
                    },
                },
                Cond2 => {
                    Fields => {
                        DynamicField_Make => {
                            Type  => 'Regexp',
                            Match => '^(#)?([\w-\*]+))',
                        },
                    },
                },
                Cond3 => {
                    Fields => {
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => ['Raw'],
                    DynamicField_Make    => 'oVoWo',
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "Module Field",
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {
                        Queue => {
                            Type => 'Module',
                            Match =>
                                'Kernel::GenericInterface::Event::Validation::ValidateDemo',
                        },
                    },
                },
                Cond2 => {
                    Fields => {
                        DynamicField_Make => {
                            Type  => 'Regexp',
                            Match => qr/^VW$/,
                        },
                    },
                },
                Cond3 => {
                    Fields => {
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => 'Postmaster',
                    DynamicField_Make    => 'VW',
                    DynamicField_VWModel => ['2'],
                },
                Success => 1,
            },
            {
                Data => {
                    Queue                => 'Raw',
                    DynamicField_Make    => 'VW',
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
    {
        Name   => "Module Invalid Field Fail",
        Config => {
            Condition => {
                Cond1 => {
                    Fields => {
                        Queue => {
                            Type => 'Module',
                            Match =>
                                'Kernel::GenericInterface::Event::Validation::UnkownModule',
                        },
                    },
                },
                Cond2 => {
                    Fields => {
                        DynamicField_Make => {
                            Type  => 'Regexp',
                            Match => qr/^VW$/,
                        },
                    },
                },
                Cond3 => {
                    Fields => {
                        DynamicField_VWModel => ['2'],
                    },
                },
            },
        },
        Dataset => [
            {
                Data => {
                    Queue                => 'Raw',
                    DynamicField_Make    => 'VW',
                    DynamicField_VWModel => ['2'],
                },
                Success => 0,
            },
        ],
    },
);

my $EventHandlerObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::Handler');

TEST:
for my $Test (@Tests) {

    for my $TestCase ( @{ $Test->{Dataset} } ) {

        my $ConditionCheck = $EventHandlerObject->_ConditionCheck(
            %{ $Test->{Config} },
            Data => $TestCase->{Data},
        );

        my $TestName = $Test->{Name} . ' ' . ( $TestCase->{Success} ? '(Success)' : '(Fail)' );

        $Self->Is(
            $ConditionCheck // 0,
            $TestCase->{Success},
            "$TestName - _ConditionCheck()"
        );
    }
}

1;
