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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::SystemAddress::Add');

my ( $Result, $ExitCode );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $SystemAddressName = 'SystemAddress' . $Helper->GetRandomID();
my $SystemAddress     = $SystemAddressName . '@example.com',
    my $QueueName     = 'queue' . $Helper->GetRandomID();

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# missing options
$ExitCode = $CommandObject->Execute( '--name', $SystemAddressName );
$Self->Is(
    $ExitCode,
    1,
    "Missing options",
);

# invalid queue
$ExitCode = $CommandObject->Execute(
    '--name', $SystemAddressName, '--email-address', $SystemAddress, '--queue-name',
    $QueueName
);
$Self->Is(
    $ExitCode,
    1,
    "Invalid queue",
);

my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => $QueueName,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

$Self->True(
    $QueueID,
    "Test queue is created - $QueueID",
);

# valid options
$ExitCode = $CommandObject->Execute(
    '--name', $SystemAddressName, '--email-address', $SystemAddress, '--queue-name',
    $QueueName
);
$Self->Is(
    $ExitCode,
    0,
    "Valid options",
);

# valid options (same again, should already exist)
$ExitCode = $CommandObject->Execute(
    '--name', $SystemAddressName, '--email-address', $SystemAddress, '--queue-name',
    $QueueName
);
$Self->Is(
    $ExitCode,
    1,
    "Valid options (but already exists)",
);

# cleanup is done by RestoreDatabase

1;
