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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Create new DB object after test database has been created.
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Create two test tickets to simulate merge history entry between them.
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my @TicketData;
for my $Count ( 1 .. 2 ) {
    my $TicketNumber = $TicketObject->TicketCreateNumber();
    my $TicketID     = $TicketObject->TicketCreate(
        TN           => $TicketNumber,
        Title        => "Test MigrateTicketMergedHistory ticket $Count",
        Queue        => 'Raw',
        Lock         => 'unlock',
        PriorityID   => 1,
        StateID      => 1,
        CustomerNo   => '123465',
        CustomerUser => 'customerUnitTest@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    push @TicketData, {
        TicketNumber => $TicketNumber,
        TicketID     => $TicketID
    };
}

# Add two history entries simulating ticket merge.
my $MergedHistoryName
    = "Merged Ticket ($TicketData[0]->{TicketNumber}/$TicketData[0]->{TicketID}) to ($TicketData[1]->{TicketNumber}/$TicketData[1]->{TicketID})";
$TicketObject->HistoryAdd(
    TicketID     => $TicketData[0]->{TicketID},
    HistoryType  => 'Merged',
    Name         => $MergedHistoryName,
    CreateUserID => 1,
);

# Get the history type id of the type Merged.
$DBObject->Prepare(
    SQL => "SELECT id
        FROM ticket_history_type
        WHERE name = 'Merged'
    ",
);

my $TicketMergedHistoryTypeID;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $TicketMergedHistoryTypeID = $Row[0];
}

# Verify added history entries.
$DBObject->Prepare(
    SQL => "SELECT name
        FROM ticket_history
        WHERE history_type_id = $TicketMergedHistoryTypeID
        AND ticket_id = $TicketData[0]->{TicketID}
    "
);

my $FetchedMergedHistoryName;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $FetchedMergedHistoryName = $Row[0];
}
$Self->Is(
    $FetchedMergedHistoryName,
    $MergedHistoryName,
    "Rel-5_0 ticket merged history correct"
);

# Initiate the migration of the ticket history real test.
my $DBUpdateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::MigrateTicketMergedHistory');
$Self->True(
    $DBUpdateObject,
    'Database update object successfully created!',
);

# Run the ticket_history migration.
my $RunSuccess = $DBUpdateObject->Run();

$Self->True(
    $RunSuccess,
    'DBUpdateObject ran without problems.',
);

# Verify changed merged history entries after executing DBUpdateTo6 script.
$DBObject->Prepare(
    SQL => "SELECT name
        FROM ticket_history
        WHERE history_type_id = $TicketMergedHistoryTypeID
        AND ticket_id = $TicketData[0]->{TicketID}
    "
);

while ( my @Row = $DBObject->FetchrowArray() ) {
    $FetchedMergedHistoryName = $Row[0];
}
$Self->Is(
    $FetchedMergedHistoryName,
    "%%$TicketData[0]->{TicketNumber}%%$TicketData[0]->{TicketID}%%$TicketData[1]->{TicketNumber}%%$TicketData[1]->{TicketID}",
    "After DBUpdateTo6 ticket merged history correct"
);

# Cleanup is done by TmpDatabaseCleanup().

1;
