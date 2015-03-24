# --
# Admin/TicketType/Add.t - command tests
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::TicketType::Add');

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
$ExitCode = $CommandObject->Execute('--name', $RandomName);
$Self->Is(
    $ExitCode,
    0,
    "Minimum options",
);

# same again (should fail because already exists)
$ExitCode = $CommandObject->Execute('--name', $RandomName);
$Self->Is(
    $ExitCode,
    1,
    "Minimum options (already exists)",
);

# delete ticket type
my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => "DELETE FROM ticket_type WHERE name = '$RandomName'",
);
$Self->True(
    $Success,
    "TicketTypeDelete - $RandomName",
);

# Make sure the cache is correct.
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
    Type => 'TicketType',
);

1;
