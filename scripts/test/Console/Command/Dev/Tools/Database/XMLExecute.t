# --
# Dev/Tools/Database/XMLExecute.t - command tests
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

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Tools::Database::XMLExecute');

my ( $Result, $ExitCode );

my $Home           = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $TableCreateXML = "$Home/scripts/test/Console/Command/Dev/Tools/Database/XMLExecute/TableCreate.xml";
my $TableDropXML   = "$Home/scripts/test/Console/Command/Dev/Tools/Database/XMLExecute/TableDrop.xml";

# try to execute command without any options
$ExitCode = $CommandObject->Execute();
$Self->Is(
    $ExitCode,
    1,
    "No options",
);

$ExitCode = $CommandObject->Execute($TableCreateXML);
$Self->Is(
    $ExitCode,
    0,
    "Table created",
);

my $Success = $Kernel::OM->Get('Kernel::System::DB')->Prepare(
    SQL => "SELECT * FROM test_xml_execute",
);
$Self->True(
    $Success,
    "SELECT after table create",
);
while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) { }

$ExitCode = $CommandObject->Execute($TableDropXML);
$Self->Is(
    $ExitCode,
    0,
    "Table dropped",
);

$Success = $Kernel::OM->Get('Kernel::System::DB')->Prepare(
    SQL => "SELECT * FROM test_xml_execute",
);
$Self->False(
    $Success,
    "SELECT after table drop",
);

1;
