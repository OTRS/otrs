# --
# Admin/Queue/Add.t - command tests
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Queue::Add');

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

# provide minimum options
$ExitCode = $CommandObject->Execute( '--name', $RandomName, '--group', 'admin' );
$Self->Is(
    $ExitCode,
    0,
    "Minimum options",
);

# provide illegal system-address-name
my $RandomName2 = $HelperObject->GetRandomID();
$ExitCode
    = $CommandObject->Execute( '--name', $RandomName2, '--group', 'admin', '--system-address-name', $RandomName2 );
$Self->Is(
    $ExitCode,
    1,
    "Illegal system address name",
);

# Since there are no tickets that rely on our test queues, we can remove them again
# from the DB.
my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => "DELETE FROM queue WHERE name = '$RandomName'",
);
$Self->True(
    $Success,
    "QueueDelete - $RandomName",
);

# Make sure the cache is correct.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'Queue',
);

1;
