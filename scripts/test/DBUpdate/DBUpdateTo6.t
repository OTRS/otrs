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
);

my $Success = $Helper->ProvideTestDatabase(
    DatabaseXMLFiles => \@DatabaseXMLFiles,
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
    'ProvideTestDatabase - Load and execute XML files',
);

my $DBUpdateTo6Object = $Kernel::OM->Get('scripts::DBUpdateTo6');

# Run DB update script consecutively.
for my $Count ( 1 .. 2 ) {

    # TODO: Remove complete cleanup block below when upgrade checks are implemented.
    # Clean test database on second run and fill it with OTRS 5 data again, for now. Otherwise, UpgradeDatabaseStructure
    #   step will fail since tables are duplicated at this point.
    if ( $Count == 2 ) {
        $Helper->TestDatabaseCleanup();

        my $Index     = 0;
        my $Count     = scalar @DatabaseXMLFiles;
        my $XMLString = '';

        XMLFILE:
        for my $XMLFile (@DatabaseXMLFiles) {

            # Load XML contents.
            my $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $XMLFile,
            );

            # Concatenate the file contents, but make sure to remove duplicated XML tags first.
            #   - First file should get only end tag removed.
            #   - Last file should get only start tags removed.
            #   - Any other file should get both start and end tags removed.
            $XML = ${$XML};
            if ( $Index != 0 ) {
                $XML =~ s/<\?xml .*? \?>//xm;
                $XML =~ s/<database .*? >//xm;
            }
            if ( $Index != $Count - 1 ) {
                $XML =~ s/<\/database .*? >//xm;
            }
            $XMLString .= $XML;

            $Index++;
        }

        my $Success = $Helper->DatabaseXMLExecute(
            XML => $XMLString,
        );
        $Self->True(
            $Success,
            'Executed XML files again',
        );
    }

    $Success = $DBUpdateTo6Object->Run(
        CommandlineOptions => {
            NonInteractive => 1,
        },
    );

    $Self->Is(
        $Success,
        1,
        "DBUpdateTo6 ran without problems (Run $Count)",
    );
}

# Cleanup is done by TmpDatabaseCleanup().

1;
