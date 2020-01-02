# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::Valid;
use Kernel::System::ObjectManager;

$Self->Is(
    $Kernel::OM->Get('Kernel::System::UnitTest::Driver'),
    $Self,
    "Global OM returns $Self as 'Kernel::System::UnitTest::Driver'",
);

local $Kernel::OM = Kernel::System::ObjectManager->new();

$Self->True( $Kernel::OM, 'Could build object manager' );

$Self->False(
    exists $Kernel::OM->{Objects}->{'Kernel::System::Valid'},
    'Kernel::System::Valid was not loaded yet',
);

my $ValidObject = Kernel::System::Valid->new();

$Self->True(
    $Kernel::OM->ObjectInstanceRegister(
        Package      => 'Kernel::System::Valid',
        Object       => $ValidObject,
        Dependencies => [],
    ),
    'Registered ValidObject',
);

$Self->Is(
    $Kernel::OM->Get('Kernel::System::Valid'),
    $ValidObject,
    "OM returns the original ValidObject",
);

$Kernel::OM->ObjectsDiscard();

$Self->True(
    $ValidObject,
    "ValidObject is still alive after ObjectsDiscard()",
);

$Self->IsNot(
    $Kernel::OM->Get('Kernel::System::Valid'),
    $ValidObject,
    "OM returns its own ValidObject",
);

1;
