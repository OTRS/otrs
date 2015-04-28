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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::StandardTemplate::QueueLink');

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomName   = $HelperObject->GetRandomID();

# try to execute command without any options
my $ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

# provide only one option
$ExitCode = $CommandObject->Execute( '--template-name', $RandomName );
$Self->Is(
    $ExitCode,
    1,
    "Only one options",
);

# provide invalid template name
$ExitCode = $CommandObject->Execute( '--template-name', $RandomName, '--queue-name', 'Junk' );
$Self->Is(
    $ExitCode,
    1,
    "Invalid template name",
);

# provide invalid queue name
$ExitCode = $CommandObject->Execute( '--template-name', 'test answer', '--queue-name', $RandomName );
$Self->Is(
    $ExitCode,
    1,
    "Invalid queue name",
);

# provide valid options
$ExitCode = $CommandObject->Execute( '--template-name', 'test answer', '--queue-name', 'Junk' );
$Self->Is(
    $ExitCode,
    0,
    "Valid options",
);

1;
