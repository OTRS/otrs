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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get command object
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

# cleanup cache is done by RestoreDatabase

1;
