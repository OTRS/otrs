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
my $Home   = $Kernel::OM->Get('Kernel::Config')->Get('Home');

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
        'Test database could not be provided, skipping test'
    );
    return 1;
}

{
    # Column 'permission_value' of table 'group_user' should exist before update
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $Result   = $DBObject->Prepare(
        SQL   => 'SELECT * FROM group_user',
        Limit => 1
    );
    my %GroupUserColumns = map { ( lc $_ => 1 ) } $DBObject->GetColumnNames();

    $Self->True(
        $GroupUserColumns{'permission_value'},
        'Column "permission_value" still exists in table group_user before update'
    );
}

# load the upgrade XML file
my $XMLString = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Location => "$Home/scripts/database/update/otrs-upgrade-to-6.xml",
);

# execute the the upgrade XML file
$Helper->DatabaseXMLExecute(
    XML => ${$XMLString},
);

my $CleanGroupUserPermissionValueObject = $Kernel::OM->Get('scripts::DBUpdateTo6::CleanGroupUserPermissionValue');
$Self->True(
    $CleanGroupUserPermissionValueObject,
    'CleanGroupUserPermissionValue object successfully created!',
);

# Run DB update script consecutively.
for my $Count ( 1 .. 2 ) {
    $Success = $CleanGroupUserPermissionValueObject->Run(
        CommandlineOptions => {
            NonInteractive => 1,
        },
    );

    $Self->Is(
        $Success,
        1,
        "CleanGroupUserPermissionValue ran without problems (Run $Count)",
    );
}

{
    # Column 'permission_value' of table 'group_user' should have being dropped
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $Result   = $DBObject->Prepare(
        SQL   => 'SELECT * FROM group_user',
        Limit => 1
    );
    my %GroupUserColumns = map { ( lc $_ => 1 ) } $DBObject->GetColumnNames();

    $Self->False(
        $GroupUserColumns{'permission_value'},
        'Column "permission_value" doesn\'t exists in table group_user'
    );
}

# Cleanup is done by TmpDatabaseCleanup().

1;
