# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Service::Add');

my ( $Result, $ExitCode );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ParentServiceName = "ParentService" . $Helper->GetRandomID();
my $ChildServiceName  = "ChildService" . $Helper->GetRandomID();

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide minimum options
$ExitCode = $CommandObject->Execute( '--name', $ParentServiceName );
$Self->Is(
    $ExitCode,
    0,
    "Minimum options ( the service is added - $ParentServiceName )",
);

# same again (should fail because already exists)
$ExitCode = $CommandObject->Execute( '--name', $ParentServiceName );
$Self->Is(
    $ExitCode,
    1,
    "Minimum options ( service $ParentServiceName already exists )",
);

# invalid parent
$ExitCode = $CommandObject->Execute( '--name', $ChildServiceName, '--parent-name', $ChildServiceName );
$Self->Is(
    $ExitCode,
    1,
    "Parent service $ChildServiceName does not exist",
);

# valid parent
$ExitCode = $CommandObject->Execute( '--name', $ChildServiceName, '--parent-name', $ParentServiceName );
$Self->Is(
    $ExitCode,
    0,
    "Existing parent ( service is added - $ChildServiceName )",
);

# Same again (should fail because already exists).
$ExitCode = $CommandObject->Execute( '--name', $ChildServiceName, '--parent-name', $ParentServiceName );
$Self->Is(
    $ExitCode,
    1,
    "Existing parent ( service ${ParentServiceName}::$ChildServiceName already exists )",
);

# Parent and child service same name.
$ExitCode = $CommandObject->Execute( '--name', $ParentServiceName, '--parent-name', $ParentServiceName );
my $ServiceName = $ParentServiceName . '::' . $ParentServiceName;
$Self->Is(
    $ExitCode,
    0,
    "Parent and child service same name - $ServiceName - is created",
);

# Parent (two levels) and child same name.
$ExitCode = $CommandObject->Execute( '--name', $ParentServiceName, '--parent-name', $ServiceName );
$ServiceName = $ServiceName . '::' . $ParentServiceName;
$Self->Is(
    $ExitCode,
    0,
    "Parent (two levels) and child service same name - $ServiceName - is created",
);

# cleanup is done by RestoreDatabase

1;
