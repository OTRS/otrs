# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw( IsHashRefWithData );

use vars (qw($Self));

use Kernel::Config;

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
    Value => 'abc',
);
$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::AgentTicketQueue###QueueSort',
    Value => {
        '7' => 2,
        '3' => 1,
    },
);

my $ExpectedResultRegex = '^Kernel/Config/Files/ZZZZUnitTest\d+\.pm$';

my @Tests = (
    {
        Name   => 'Missing name',
        Params => {
            EffectiveValue => 'Test',
            UserID         => 1,
        },
        ExpectedResultRegex => undef,
    },
    {
        Name   => 'Missing UserID',
        Params => {
            SettingName    => 'Ticket::Hook',
            EffectiveValue => 'Ticket#',
        },
        ExpectedResultRegex => undef,
    },
    {
        Name   => 'Updated Ticket::Hook',
        Params => {
            SettingName    => 'Ticket::Hook',
            EffectiveValue => 'Ticket#',        # it should be default value from XML
            UserID         => 1,
        },
        ExpectedResultRegex => $ExpectedResultRegex,
    },
    {
        Name   => 'Updated Ticket::Frontend::AgentTicketQueue###QueueSort',
        Params => {
            SettingName    => 'Ticket::Frontend::AgentTicketQueue###QueueSort',
            EffectiveValue => {                                                   # it should be default value from XML
                '7' => 1,
                '3' => 0,
            },
            UserID => 1,
        },
        ExpectedResultRegex => $ExpectedResultRegex,
    },
);

for my $Test (@Tests) {
    my $Result = $SysConfigObject->OverriddenFileNameGet(
        %{ $Test->{Params} },
    );

    if ( $Test->{ExpectedResultRegex} ) {

        # We can't compare real file name, since HelperObject uses random numbers to generate it.
        $Self->True(
            $Result =~ m{$Test->{ExpectedResultRegex}} // '',
            "OverriddenFileNameGet() - $Test->{Name} - Check expected result($Test->{ExpectedResultRegex})."
        );
    }
    else {
        $Self->False(
            $Result // '',
            "OverriddenFileNameGet() - $Test->{Name} - not found."
        );
    }
}

1;
