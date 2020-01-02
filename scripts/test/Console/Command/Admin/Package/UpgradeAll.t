# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# Initialize test database based on fresh OTRS 6 schema.
my $Success = $Helper->ProvideTestDatabase(
    DatabaseXMLFiles => [
        "$Home/scripts/database/otrs-schema.xml",
        "$Home/scripts/database/otrs-initial_insert.xml",
    ],
);
if ( !$Success ) {
    $Self->False(
        0,
        'Test database could not be provided, skipping test',
    );
    return 1;
}
$Self->True(
    $Success,
    'ProvideTestDatabase - Load and execute OTRS 6 XML files',
);

my @List = $Kernel::OM->Get('Kernel::System::Package')->RepositoryList(
    Result => 'short',
);

if (@List) {
    $Self->True(
        0,
        'System should not contain any installed package',
    );
}

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::UpgradeAll');

my ( $Result, $ExitCode );
{
    local *STDOUT;
    open STDOUT, '>:encoding(UTF-8)', \$Result;
    $ExitCode = $CommandObject->Execute();
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Result );
}

$Self->False(
    $ExitCode,
    'Admin::Package::UpgradeAll executes without any issue',
);
$Self->IsNot(
    $Result || '',
    '',
    'Admin::Package::UpgradeAll result',
);

1;
