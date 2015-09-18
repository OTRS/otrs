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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::CustomerCompany::Add');

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName   = $HelperObject->GetRandomID();

# try to execute command without any options
my $ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options
$ExitCode = $CommandObject->Execute(
    '--customer-id', $RandomName, '--name', 'Test',
);
$Self->Is(
    $ExitCode,
    0,
    "Minimum options",
);

# provide minimum options
$ExitCode = $CommandObject->Execute(
    '--customer-id', $RandomName, '--name', 'Test',
);
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (company already exists)",
);

# delete customer user
my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => "DELETE FROM customer_company WHERE customer_id = '$RandomName'",
);
$Self->True(
    $Success,
    "CustomerCompanyDelete - $RandomName",
);

# Make sure the cache is correct.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'CustomerCompany',
);

1;
