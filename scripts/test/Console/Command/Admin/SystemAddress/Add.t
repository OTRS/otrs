# --
# Admin/SystemAddress/Add.t - command tests
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::SystemAddress::Add');

my ( $Result, $ExitCode );

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName   = $HelperObject->GetRandomID();

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# missing options
$ExitCode = $CommandObject->Execute( '--name', $RandomName );
$Self->Is(
    $ExitCode,
    1,
    "Missing options",
);

# invalid queue
$ExitCode
    = $CommandObject->Execute( '--name', $RandomName, '--email-address', $RandomName, '--queue-name', $RandomName );
$Self->Is(
    $ExitCode,
    1,
    "Invalid queue",
);

# valid options
$ExitCode = $CommandObject->Execute( '--name', $RandomName, '--email-address', $RandomName, '--queue-name', 'Junk' );
$Self->Is(
    $ExitCode,
    0,
    "Valid options",
);

# valid options (same again, should already exist)
$ExitCode = $CommandObject->Execute( '--name', $RandomName, '--email-address', $RandomName, '--queue-name', 'Junk' );
$Self->Is(
    $ExitCode,
    1,
    "Valid options (but already exists)",
);

# delete services
my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => "DELETE FROM system_address WHERE value1 = '$RandomName'",
);
$Self->True(
    $Success,
    "SystemAddressDelete - $RandomName",
);

# Make sure the cache is correct.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'SystemAddress',
);

1;
