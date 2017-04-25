# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my @DatabaseXMLFiles = (
    "$Home/scripts/test/sample/DBUpdate/otrs5-schema.xml",
    "$Home/scripts/test/sample/DBUpdate/otrs5-initial_insert.xml",
    "$Home/scripts/database/update/otrs-upgrade-to-6.xml",
);

my $Success = $Helper->ProvideTestDatabase(
    DatabaseXMLFiles => \@DatabaseXMLFiles,
);
if ( !$Success ) {
    $Self->False(
        0,
        'Test database could not be provided, skipping test'
    );
    return 1;
}
$Self->True(
    $Success,
    'ProvideTestDatabase - Load and execute XML files'
);

my $DBUpdateTo6Object = $Kernel::OM->Get('scripts::DBUpdateTo6');
$Success = $DBUpdateTo6Object->Run(
    CommandlineOptions => {
        NonInteractive => 1,
    },

    # Prevent discarding all objects including config object, when config is rebuilt from DB update module. Otherwise,
    #   overridden test database settings will be lost and changes might be executed on system database instead.
    UnitTestMode => 1,
);

$Self->Is(
    $Success,
    1,
    'DBUpdateTo6 ran without problems'
);

# Cleanup is done by TmpDatabaseCleanup().

1;
