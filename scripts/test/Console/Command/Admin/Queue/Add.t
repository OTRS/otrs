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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Queue::Add');

my ( $Result, $ExitCode );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $QueueName = "queue" . $Helper->GetRandomID();

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options
$ExitCode = $CommandObject->Execute( '--name', $QueueName, '--group', 'admin' );
$Self->Is(
    $ExitCode,
    0,
    "Minimum options",
);

# provide name which already exists
$ExitCode = $CommandObject->Execute( '--name', $QueueName, '--group', 'admin' );
$Self->Is(
    $ExitCode,
    1,
    "Queue with the name $QueueName already exists",
);

# provide illegal system-address-name
my $SystemAddressName = "address" . $Helper->GetRandomID();
$ExitCode = $CommandObject->Execute(
    '--name', "$QueueName-second", '--group', 'admin', '--system-address-name',
    $SystemAddressName
);
$Self->Is(
    $ExitCode,
    1,
    "Illegal system address name",
);

# cleanup is done by RestoreDatabase

1;
