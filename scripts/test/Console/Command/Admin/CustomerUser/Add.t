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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::CustomerUser::Add');

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName   = $HelperObject->GetRandomID();

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# try to execute command without any options
my $ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options
$ExitCode = $CommandObject->Execute(
    '--user-name', $RandomName, '--first-name', 'Test',
    '--last-name', 'Test', '--email-address', $RandomName . '@test.test',
    '--customer-id', 'Test'
);
$Self->Is(
    $ExitCode,
    0,
    "Minimum options",
);

# provide minimum options
$ExitCode = $CommandObject->Execute(
    '--user-name', $RandomName, '--first-name', 'Test',
    '--last-name', 'Test', '--email-address', $RandomName . '@test.test',
    '--customer-id', 'Test'
);
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (user already exists)",
);

# delete customer user
my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => "DELETE FROM customer_user WHERE login = '$RandomName'",
);
$Self->True(
    $Success,
    "CustomerUserDelete - $RandomName",
);

# Make sure the cache is correct.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'CustomerUser',
);

1;
