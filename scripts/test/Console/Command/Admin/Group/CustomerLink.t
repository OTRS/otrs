# --
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Group::CustomerLink');

my ( $Result, $ExitCode );

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName   = $HelperObject->GetRandomID();

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

# remove test role
my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => "DELETE FROM group_customer_user WHERE user_id = '$RandomName'",
);
$Self->True(
    $Success,
    "GroupCustomerDelete - $RandomName",
);

$Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => "DELETE FROM customer_user WHERE login = '$RandomName'",
);
$Self->True(
    $Success,
    "CustomerDelete - $RandomName",
);

# Make sure the cache is correct.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'Group',
);
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'CustomerUser',
);

1;
