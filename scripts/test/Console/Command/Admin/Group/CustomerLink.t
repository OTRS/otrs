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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Group::CustomerLink');

my ( $Result, $ExitCode );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName = $Helper->GetRandomID();

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options (invalid customer)
$ExitCode = $CommandObject->Execute(
    '--customer-user-login', $RandomName, '--group-name', $RandomName, '--permission',
    'ro'
);
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but customer user doesn't exist)",
);

my $CustomerUserLogin = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => $RandomName,
    UserLastname   => $RandomName,
    UserCustomerID => $RandomName,
    UserLogin      => $RandomName,
    UserEmail      => $RandomName . '@example.com',
    ValidID        => 1,
    UserID         => 1,
);

$Self->True(
    $CustomerUserLogin,
    "Test customer is created - $CustomerUserLogin",
);

# provide minimum options (invalid group)
$ExitCode = $CommandObject->Execute(
    '--customer-user-login', $CustomerUserLogin, '--group-name', $RandomName,
    '--permission', 'ro'
);
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but group doesn't exist)",
);

# provide minimum options (invalid permission)
$ExitCode = $CommandObject->Execute(
    '--customer-user-login', $CustomerUserLogin, '--group-name', 'users', '--permission',
    'xx'
);
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (but invalid permission parameter)",
);

# provide minimum options (okay)
$ExitCode = $CommandObject->Execute(
    '--customer-user-login', $CustomerUserLogin, '--group-name', 'users', '--permission',
    'ro'
);
$Self->Is(
    $ExitCode,
    0,
    "Minimum options (parameters okay)",
);

# cleanup is done by RestoreDatabase

1;
