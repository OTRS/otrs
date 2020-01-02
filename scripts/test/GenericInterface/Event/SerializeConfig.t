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
        Name => 'Simple Values',
        Data => {
            Key1 => 1,
            Key2 => 2,
            Key3 => 3,
        },
        ExpectedResult => {
            Key1 => 1,
            Key2 => 2,
            Key3 => 3,
        },
        Success => 1,
    },
    {
        Name => 'Simple Array',
        Data => {
            Key1 => [ 1, 2, 3 ],
        },
        ExpectedResult => {
            Key1_0 => 1,
            Key1_1 => 2,
            Key1_2 => 3,
        },
        Success => 1,
    },
    {
        Name => 'Simple Hash',
        Data => {
            Key1 => {
                KeyA => 1,
                KeyB => 2,
                KeyC => 3
            },
        },
        ExpectedResult => {
            Key1_KeyA => 1,
            Key1_KeyB => 2,
            Key1_KeyC => 3,
        },
        Success => 1,
    },
    {
        Name => 'Hash of Arrays',
        Data => {
            Key1 => {
                KeyA => [ 1, 2, 3 ],
                KeyB => [ 1, 2, 3 ],
                KeyC => [ 1, 2, 3 ],
            },
        },
        ExpectedResult => {
            Key1_KeyA_0 => 1,
            Key1_KeyA_1 => 2,
            Key1_KeyA_2 => 3,
            Key1_KeyB_0 => 1,
            Key1_KeyB_1 => 2,
            Key1_KeyB_2 => 3,
            Key1_KeyC_0 => 1,
            Key1_KeyC_1 => 2,
            Key1_KeyC_2 => 3,
        },
        Success => 1,
    },

    # TODO: This is not supported
    # {
    #     Name => 'Array of Hashes',
    #     Data => {
    #         Key1 => [
    #             {
    #                 KeyA => 1,
    #                 KeyB => 2,
    #                 KeyC => 3,
    #             },
    #             {
    #                 KeyA => 1,
    #                 KeyB => 2,
    #                 KeyC => 3,
    #             },
    #             {
    #                 KeyA => 1,
    #                 KeyB => 2,
    #                 KeyC => 3,
    #             },
    #         ],
    #     },
    #     ExpectedResult => {
    #         Key1_0_KeyA => 1,
    #         Key1_0_KeyB => 2,
    #         Key1_0_KeyC => 3,
    #         Key1_1_KeyA => 1,
    #         Key1_1_KeyB => 2,
    #         Key1_1_KeyC => 3,
    #         Key1_2_KeyA => 1,
    #         Key1_2_KeyB => 2,
    #         Key1_2_KeyC => 3,
    #     },
    #     Success => 1,
    # },
);

my $EventHandlerObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::Handler');

TEST:
for my $Test (@Tests) {

    my %Result;

    my $ConditionCheck = $EventHandlerObject->_SerializeConfig(
        Data  => $Test->{Data},
        SHash => \%Result,
    );

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        "$Test->{Name} - _SerializeConfig()"
    );
}

1;
