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

use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        RestoreDatabase => 1,
    },
);

my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# Ticket::SubjectFwd
# Ticket::SubjectRe

my @Tests = (
    {
        Title  => 'SettingsSet() without UserID',
        Params => {
            Settings => [
                {
                    Name           => 'Ticket::SubjectFwd',
                    EffectiveValue => 'FORWARD###',
                },
                {
                    Name           => 'Ticket::SubjectRe',
                    EffectiveValue => 'RE###',
                },
            ],
        },
        ExpectedResult => undef,
    },
    {
        Title  => 'SettingsSet() without Settings',
        Params => {
            UserID => 1,
        },
        ExpectedResult => undef,
    },
    {
        Title  => 'SettingsSet() pass',
        Params => {
            UserID   => 1,
            Settings => [
                {
                    Name           => 'Ticket::SubjectFwd',
                    EffectiveValue => 'FORWARD###',
                },
                {
                    Name           => 'Ticket::SubjectRe',
                    EffectiveValue => 'RE###',
                },
            ],
        },
        ExpectedResult => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $SysConfigObject->SettingsSet(
        %{ $Test->{Params} },
    );

    $Self->Is(
        $Success,
        $Test->{ExpectedResult},
        $Test->{Title},
    );
}

# Check values
my %SettingForward = $SysConfigObject->SettingGet(
    Name     => 'Ticket::SubjectFwd',
    Deployed => 1,
);

$Self->Is(
    $SettingForward{EffectiveValue},
    'FORWARD###',
    'Check deployed EffectiveValue for Ticket::SubjectFwd.',
);
my %SettingRe = $SysConfigObject->SettingGet(
    Name     => 'Ticket::SubjectRe',
    Deployed => 1,
);

$Self->Is(
    $SettingRe{EffectiveValue},
    'RE###',
    'Check deployed EffectiveValue for Ticket::SubjectRe.',
);

1;
