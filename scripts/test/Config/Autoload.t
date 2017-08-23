# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

$Self->False(
    $ValidObject->can('AutoLoadTest'),
    'Valid object has no method AutoLoadTest by default.',
);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'AutoloadPerlPackages###1000-Test',
    Value => 'Kernel::Autoload::Test',
);

# Recreate config object, which calls the autoload.
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Config'] );
$Kernel::OM->Get('Kernel::Config');

$Self->Is(
    $Kernel::OM->Get('Kernel::System::Valid')->AutoloadTest(),
    1,
    "Autoload correctly added a new function to Kernel::System::Valid",
);

1;
