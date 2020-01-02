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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my $TestPackage = 'scripts::test::Main::Test';
my $TestPM      = 'scripts/test/Main/Test.pm';

$Self->False(
    scalar $INC{$TestPM},
    "$TestPackage not in %INC yet",
);

$Self->Is(
    $MainObject->Require($TestPackage),
    1,
    "$TestPackage loaded via Require()",
);

$Self->True(
    scalar $INC{$TestPM},
    "$TestPackage in %INC",
);

$Self->Is(
    scalar scripts::test::Main::Test::Test(),
    1,
    "Function can be called in loaded package",
);

my %OldINC = %INC;

$Self->Is(
    $MainObject->Require($TestPackage),
    1,
    "$TestPackage loaded via Require()",
);

$Self->IsDeeply(
    \%INC,
    \%OldINC,
    '%INC hash unchanged by second load',
);

$Self->Is(
    scalar $MainObject->Require( "${TestPackage}::Invalid", Silent => 1 ),
    scalar undef,
    "${TestPackage}::Invalid cannot be loaded",
);

$Self->IsDeeply(
    \%INC,
    \%OldINC,
    '%INC hash unchanged by invalid load',
);

1;
