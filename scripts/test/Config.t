# --
# Config.t - ConfigObject tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

my $Value = 'Testvalue';
$ConfigObject->Set(
    Key   => 'ConfigTestkey',
    Value => $Value,
);
my $Get = $ConfigObject->Get('ConfigTestkey');

$Self->Is(
    $Get,
    $Value,
    'Set() and Get()',
);

my $Home = $ConfigObject->Get('Home');
$Self->True(
    $Home,
    'check for configuration setting "Home"',
);

my $ConfigChecksum  = $ConfigObject->ConfigChecksum();
my $ConfigChecksum2 = $ConfigObject->ConfigChecksum();
$Self->True(
    $ConfigChecksum,
    'ConfigChecksum()',
);
$Self->Is(
    $ConfigChecksum,
    $ConfigChecksum2,
    'ConfigChecksum()',
);

# loads the defaults values
$ConfigObject->LoadDefaults();

# obtains the default home path
my $DefaultHome = $ConfigObject->Get('Home');

# changes the home path
my $DummyPath = '/some/dummy/path/that/has/nothing/to/do/with/this';
$ConfigObject->Set(
    Key   => 'Home',
    Value => $DummyPath,
);

# obtains the current home path
my $NewHome = $ConfigObject->Get('Home');

# makes sure that the current home path is the one we set
$Self->Is(
    $NewHome,
    $DummyPath,
    'Test Set() with "Home" - both paths are equivalent.',
);

# makes sure that the default home path and the current are different
$Self->IsNot(
    $NewHome,
    $DefaultHome,
    'Test Set() with "Home" - new path differs from the default.',
);

# loads the defaults values
$ConfigObject->LoadDefaults();

# obtains the default home path
$NewHome = $ConfigObject->Get('Home');

# checks that the default value obtained before is equivalent to the current
$Self->Is(
    $NewHome,
    $DefaultHome,
    'Test LoadDefaults() - both paths are equivalent.',
);

# makes sure that the current path is different from the one we set before loading the defaults
$Self->IsNot(
    $NewHome,
    $DummyPath,
    'Test LoadDefaults() with "Home" - new path differs from the dummy.',
);

$DefaultHome = $NewHome;

# loads the config values
$ConfigObject->Load();

# obtains the current home path
$NewHome = $ConfigObject->Get('Home');

# checks that the config value obtained before is equivalent to the current
$Self->Is(
    $NewHome,
    $Home,
    'Test Load() - both paths are equivalent.',
);

1;
