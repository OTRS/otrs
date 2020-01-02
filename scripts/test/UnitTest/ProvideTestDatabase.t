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

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Success = $Helper->ProvideTestDatabase();
if ( !$Success ) {
    $Self->False(
        0,
        'Test database could not be provided, skipping test',
    );
    return 1;
}
$Self->True(
    $Success,
    'ProvideTestDatabase - Database cleared',
);

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
my @Tables   = $DBObject->ListTables();

$Self->Is(
    scalar @Tables,
    0,
    'No tables found',
);

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my @DatabaseXMLFiles = (
    "$Home/scripts/database/otrs-schema.xml",
    "$Home/scripts/database/otrs-initial_insert.xml",
);

$Success = $Helper->ProvideTestDatabase(
    DatabaseXMLFiles => \@DatabaseXMLFiles,
);

$Self->True(
    $Success,
    'ProvideTestDatabase - Load and execute XML files',
);

@Tables = $DBObject->ListTables();

# Count number of table elements in OTRS schema for comparison.
my $XMLString = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Location => $DatabaseXMLFiles[0],
);
my $TableCount = () = ( ${$XMLString} =~ /<Table/g );

$Self->Is(
    scalar @Tables,
    $TableCount,
    'OTRS tables found',
);

# Cleanup is done by TmpDatabaseCleanup().

1;
