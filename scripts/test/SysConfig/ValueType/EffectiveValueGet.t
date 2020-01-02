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
        Name  => 'Correct String',
        Param => {
            Value => [
                {
                    ValueRegex => '',
                    Content    => '123',
                    ValueType  => 'String',
                },
            ],
        },
        ExpectedValue => '123',
    },
    {
        Name  => 'Correct File',
        Param => {
            Value => [
                {
                    Content   => '/usr/bin/gpg',
                    ValueType => 'File',
                },
            ],
        },
        ExpectedValue => '/usr/bin/gpg',
    },
    {
        Name  => 'Correct Directory',
        Param => {
            Value => [
                {
                    Content   => '/etc',
                    ValueType => 'Directory',
                },
            ],
        },
        ExpectedValue => '/etc',
    },
    {
        Name  => 'Correct Textarea',
        Param => {
            Value => [
                {
                    Content   => "123\n456",
                    ValueType => 'Textarea',
                },
            ],
        },
        ExpectedValue => "123\n456",
    },

    {
        Name  => 'Correct Checkbox',
        Param => {
            Value => [
                {
                    Content   => '1',
                    ValueType => 'Checkbox',
                },
            ],
        },
        ExpectedValue => '1',
    },

    {
        Name  => 'Correct Select',
        Param => {
            Value => [
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
                    ValueType => 'Select',
                },
            ],
        },
        ExpectedValue => '2',
    },

    {
        Name  => 'Correct Entity',
        Param => {
            Value => [
                {
                    ValueType       => 'Entity',
                    ValueEntityType => 'Priority',
                    ValueRegex      => '',
                    Content         => '3 normal'
                },
            ],
        },
        ExpectedValue => '3 normal',
    },

    {
        Name  => 'Correct PerlModule',
        Param => {
            Value => [
                {
                    ValueFilter => 'Kernel/System/Email/*.pm',
                    ValueType   => 'PerlModule',
                    Content     => 'Kernel::System::Email::Sendmail'
                },
            ],
        },
        ExpectedValue => 'Kernel::System::Email::Sendmail',
    },

    {
        Name  => 'Correct Date',
        Param => {
            Value => [
                {
                    Content   => '2000-01-01',
                    ValueType => 'Date',
                },
            ],
        },
        ExpectedValue => '2000-01-01',
    },

    {
        Name  => 'Correct DateTime',
        Param => {
            Value => [
                {
                    Content   => '2000-01-01 01:01:01',
                    ValueType => 'DateTime',
                },
            ],
        },
        ExpectedValue => '2000-01-01 01:01:01',
    },

    {
        Name  => 'Correct TimeZone',
        Param => {
            Value => [
                {
                    Content   => 'Europe/Berlin',
                    ValueType => 'TimeZone',
                },
            ],
        },
        ExpectedValue => 'Europe/Berlin',
    },

    {
        Name  => 'Correct VacationDays',
        Param => {
            Value => [
                {
                    Item => [
                        {
                            ValueMonth   => '1',
                            Translatable => '1',
                            Content      => 'New Year\'s Day',
                            ValueDay     => '1',
                        },
                        {
                            ValueDay     => '1',
                            Content      => 'International Workers\' Day',
                            Translatable => '1',
                            ValueMonth   => '5',
                        },
                        {
                            ValueMonth   => '12',
                            Translatable => '1',
                            Content      => 'Christmas Eve',
                            ValueDay     => '24',
                        },
                        {
                            Translatable => '1',
                            ValueMonth   => '12',
                            ValueDay     => '25',
                            Content      => 'First Christmas Day',
                        },
                        {
                            Translatable => '1',
                            ValueMonth   => '12',
                            ValueDay     => '26',
                            Content      => 'Second Christmas Day',
                        },
                        {
                            ValueDay     => '31',
                            Content      => 'New Year\'s Eve',
                            ValueMonth   => '12',
                            Translatable => '1',
                        },
                    ],
                    ValueType => 'VacationDays',
                },
            ],
        },
        ExpectedValue => {
            '1' => {
                '1' => 'New Year\'s Day',
            },
            '12' => {
                '24' => 'Christmas Eve',
                '25' => 'First Christmas Day',
                '26' => 'Second Christmas Day',
                '31' => 'New Year\'s Eve',
            },
            '5' => {
                '1' => 'International Workers\' Day',
            },
        },
    },

    {
        Name  => 'Correct VacationDaysOneTime',
        Param => {
            Value => [
                {
                    ValueType => 'VacationDaysOneTime',
                    Item      => [
                        {
                            ValueMonth => '1',
                            ValueYear  => '2004',
                            Content    => 'test',
                            ValueDay   => '1'
                        },
                        {
                            ValueMonth => '1',
                            ValueYear  => '2005',
                            Content    => 'test',
                            ValueDay   => '1'
                        },
                        {
                            ValueMonth => '1',
                            ValueYear  => '2005',
                            Content    => 'test2',
                            ValueDay   => '2'
                        },
                        {
                            ValueMonth => '2',
                            ValueYear  => '2005',
                            Content    => 'test3',
                            ValueDay   => '3'
                        },

                    ],
                },
            ],
        },
        ExpectedValue => {
            '2004' => {
                '1' => {
                    '1' => 'test',
                },
            },
            '2005' => {
                '1' => {
                    '1' => 'test',
                    '2' => 'test2',
                },
                '2' => {
                    '3' => 'test3',
                },
            },
        },
    },
    {
        Name  => 'Correct WorkingHours',
        Param => {
            Value => [
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
        ExpectedValue => {
            Mon => [
                '8',
                '9',
                '10',
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
            Fri => [
                '20',
                '21',
                '22',
            ],
            Sat => [],
            Sun => [],
        },
    },
);

TEST:
for my $Test (@Tests) {

    my $ValueType = $Test->{Param}->{Value}->[0]->{ValueType};

    my $EffectiveValue = $Kernel::OM->Get("Kernel::System::SysConfig::ValueType::$ValueType")
        ->EffectiveValueGet( %{ $Test->{Param} } );

    $Self->IsDeeply(
        $EffectiveValue,
        $Test->{ExpectedValue},
        "$Test->{Name} EffectiveValueGet() -",
    );
}

1;
