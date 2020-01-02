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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Hook',
    Value => 'Ticket###',
);

$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::AgentTicketWatchView###SortBy::Default',
    Value => 'Queue',
);

my @Tests = (
    {
        Title          => 'Missing SettingName',
        Params         => {},
        ExpectedResult => undef,
    },
    {
        Title  => 'Setting with default EffectiveValue (defined in XML).',
        Params => {
            SettingName => 'ConfigLevel',
        },
        ExpectedResult => 100,
    },
    {
        Title  => 'Setting with EffectiveValue modified in the pm file.',
        Params => {
            SettingName => 'Ticket::Hook',
        },
        ExpectedResult => 'Ticket###',
    },
);

for my $Test (@Tests) {

    my $EffectiveValue = $SysConfigObject->GlobalEffectiveValueGet(
        %{ $Test->{Params} },
    );

    if ( defined $Test->{ExpectedResult} ) {
        $Self->IsDeeply(
            $EffectiveValue,
            $Test->{ExpectedResult},
            "$Test->{Title} - check expected result.",
        );
    }
    else {
        $Self->Is(
            $EffectiveValue,
            undef,
            "$Test->{Title} - check expected result.",
        );
    }
}

1;
