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

use Kernel::System::VariableCheck qw( IsHashRefWithData );

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');

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

my $ArchiveRestoreEffectiveValue = $ConfigObject->Get(
    'Ticket::EventModulePost'
)->{'2300-ArchiveRestore'};

$Self->True(
    $ArchiveRestoreEffectiveValue,
    'Setting Ticket::EventModulePost###2300-ArchiveRestore is active and has value set.',
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
    {
        Name   => 'Setting Ticket::EventModulePost###2300-ArchiveRestore is not changed yet',
        Params => {
            SettingName    => 'Ticket::EventModulePost###2300-ArchiveRestore',
            EffectiveValue => $ArchiveRestoreEffectiveValue,
            UserID         => 1,
        },

        # ExpectedResultRegex => $ExpectedResultRegex,
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

# Simulates delete statement.
$HelperObject->ConfigSettingChange(
    Valid => 0,
    Key   => 'Ticket::EventModulePost###2300-ArchiveRestore',
);

my $ArchiveRestoreEffectiveValue2 = $ConfigObject->Get(
    'Ticket::EventModulePost'
)->{'2300-ArchiveRestore'};

$Self->False(
    $ArchiveRestoreEffectiveValue2,
    'Setting Ticket::EventModulePost###2300-ArchiveRestore is not active.',
);

@Tests = (
    {
        Name   => 'Setting Ticket::EventModulePost###2300-ArchiveRestore is changed',
        Params => {
            SettingName    => 'Ticket::EventModulePost###2300-ArchiveRestore',
            EffectiveValue => $ArchiveRestoreEffectiveValue,
            UserID         => 1,
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
