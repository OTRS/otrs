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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Queue::List');

my ( $Result, $ExitCode );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $QueueName = "queue" . $Helper->GetRandomID();

my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => $QueueName,
    Group           => 'admin',
    ValidID         => 2,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

{

    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $CommandObject->Execute();
}

$Self->Is(
    $ExitCode,
    0,
    "exit code without options",
);

$Self->True(
    scalar $Result !~ m{\s$QueueName\s},
    "queue not found without options",
);

$Result = '';

{

    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $CommandObject->Execute('--all');
}

$Self->Is(
    $ExitCode,
    0,
    "exit code with --all",
);

$Self->True(
    scalar $Result =~ m{\s$QueueName\s},
    "queue found with --all",
);

$Result = '';

{

    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic
    $ExitCode = $CommandObject->Execute( '--all', '--verbose' );
}

$Self->Is(
    $ExitCode,
    0,
    "exit code with --all --verbose",
);

$Self->True(
    scalar $Result =~ m{\s$QueueID.*$QueueName.*invalid},
    "queue found with --all --verbose",
);

# cleanup is done by RestoreDatabase

1;
