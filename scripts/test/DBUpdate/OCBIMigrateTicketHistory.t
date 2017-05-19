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

my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

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

# create new DB object after test database has been created
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# list of history types that will be mapped to new history type ArticleCreate
my @MappedTicketHistoryTypes = (
    qw(
        EmailAgent
        EmailCustomer
        PhoneCallAgent
        PhoneCallCustomer
        WebRequestCustomer
        SendAnswer
        FollowUp
        AddNote
        SendAutoReject
        SendAutoReply
        SendAutoFollowUp
        Forward
        Bounce
        SystemRequest
        )
);

my $HistoryTypeInString = join ', ', map {"'$_'"} @MappedTicketHistoryTypes;

# get the history type id of needed history types
$DBObject->Prepare(
    SQL => "
        SELECT id, name
        FROM ticket_history_type
        WHERE name in ($HistoryTypeInString)
    ",
);

my @TicketHistoryTypeIDs;
while ( my @Row = $DBObject->FetchrowArray() ) {
    push @TicketHistoryTypeIDs, $Row[0];
}

# build history type id In-String
my $HistoryTypeIDInString = join ', ', sort { $a <=> $b } @TicketHistoryTypeIDs;

# load the upgrade XML file
my $XMLString = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Location => "$Home/scripts/database/update/otrs-upgrade-to-6.xml",
);

# execute the the upgrade XML file
my $Result = $Helper->DatabaseXMLExecute(
    XML => ${$XMLString},
);

$Self->True(
    $Result,
    "Successfully executed otrs-upgrade-to-6.xml.",
);

# get column names from ticket_history table
$DBObject->Prepare(
    SQL   => "SELECT * FROM ticket_history",
    Limit => 1,
);
my %ColumnNameLookup = map { lc $_ => 1 } $DBObject->GetColumnNames();

# check if the newly added columns exist
for my $ColumnName (
    qw(
    a_communication_channel_id
    a_sender_type_id
    a_is_visible_for_customer
    )
    )
{
    $Self->True(
        $ColumnNameLookup{$ColumnName},
        "Found new column '$ColumnName' in table 'ticket_history'",
    );
}

# check if history type ArticleCreate exists
$DBObject->Prepare(
    SQL => "SELECT id
        FROM ticket_history_type
        WHERE name = 'ArticleCreate'
    ",
);

my $ArticleCreateHistoryTypeID;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $ArticleCreateHistoryTypeID = $Row[0];
}

$Self->True(
    $ArticleCreateHistoryTypeID,
    "Found new ticket history type 'ArticleCreate' in table 'ticket_history_type'",
);

# TODO: Adde some test data in article table, to have some values for the 3 new columns:
# a_communication_channel_id, a_sender_type_id, a_is_visible_for_customer
# also add some data into the ticket_history table whcoh reference to the to be mapped ticket_history_types

# initiate the migration of the ticket history real test.
my $DBUpdateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::OCBIMigrateTicketHistory');
$Self->True(
    $DBUpdateObject,
    'Database update object successfully created!',
);

# run the ticket_history migration
my $RunSuccess = $DBUpdateObject->Run();

$Self->True(
    $RunSuccess,
    'DBUpdateObject ran without problems.',
);

# check that there are no longer needed history types in the table ticket_history_type
$DBObject->Prepare(
    SQL => "
        SELECT COUNT(*)
        FROM ticket_history_type
        WHERE name IN ($HistoryTypeInString)
    ",
);

my $Count;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $Count = $Row[0];
}

$Self->False(
    $Count,
    'Mapped history types have been deleted from table ticket_history_type.',
);

# check that there are no longer needed history types in the ticket history table
$DBObject->Prepare(
    SQL => "
        SELECT COUNT(*)
        FROM ticket_history
        WHERE history_type_id IN ($HistoryTypeIDInString)
    ",
);

while ( my @Row = $DBObject->FetchrowArray() ) {
    $Count = $Row[0];
}

$Self->False(
    $Count,
    'Mapped history types are no longer used in table ticket_history.',
);

# Cleanup is done by TmpDatabaseCleanup().

1;
