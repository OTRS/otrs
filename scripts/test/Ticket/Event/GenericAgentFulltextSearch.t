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

# Create first test RandomID identifier.
my $FirstRandomID = $Helper->GetRandomID();

# Define structure for first Ticket create.
my %FirstTicketValues = (
    Create => {
        Title      => 'Original first test created Ticket.',
        StateID    => 1,
        PriorityID => 2,
        OwnerID    => 1,
        CustomerID => '123',
        LockID     => 1,
        QueueID    => 2,
    },
    ArticleCreateJob => {
        Title      => 'ArticleCreate event GenericAgent job modified.',
        StateID    => 3,
        PriorityID => 4,
        OwnerID    => 1,
        CustomerID => '456',
        LockID     => 2,
        QueueID    => 3,
    },
);

# Add the new GenericAgent Job with ArticleCreate as trigger event.
my $FirstJobName       = "ArticleCreate Event UnitTest_$FirstRandomID";
my %FirstArticleValues = (
    From    => "Agent Some Agent <agent$FirstRandomID\@example.com>",
    To      => "Customer_ A <customera$FirstRandomID\@example.com>",
    Cc      => "Customer_ B <customerb$FirstRandomID\@example.com>",
    Subject => "Subject_$FirstRandomID Test",
    Body    => "Body_$FirstRandomID Test",
);
my %ArticleCreateJob = (
    Name => $FirstJobName,
    Data => {

        Valid => 1,

        EventValues => ['ArticleCreate'],

        MIMEBase_From    => "*$FirstRandomID*",
        MIMEBase_To      => "*$FirstRandomID*",
        MIMEBase_Cc      => "*$FirstRandomID*",
        MIMEBase_Body    => "*$FirstRandomID*",
        MIMEBase_Subject => "*$FirstRandomID*",
    },
);

for my $Item ( sort keys %{ $FirstTicketValues{ArticleCreateJob} } ) {
    $ArticleCreateJob{Data}->{ 'New' . $Item } = $FirstTicketValues{ArticleCreateJob}->{$Item};
}

my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');
my $FirstJobAdd        = $GenericAgentObject->JobAdd(
    %ArticleCreateJob,
    UserID => 1,
);
$Self->True(
    $FirstJobAdd || '',
    'JobAdd() - ArticleCreate event.',
);

# Create a Ticket to test JobRun on an event ArticleCreate trigger.
my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
my $FirstTicketID = $TicketObject->TicketCreate(
    %{ $FirstTicketValues{Create} },
    UserID => 1,
);
$Self->True(
    $FirstTicketID,
    "TicketCreate() - uses for GA - $FirstTicketID.",
);

# Get Ticket data, and confirm that it have the right values without changes.
my %Ticket = $TicketObject->TicketGet(
    TicketID => $FirstTicketID,
);
for my $Item ( sort keys %{ $FirstTicketValues{Create} } ) {
    $Self->Is(
        $Ticket{$Item},
        $FirstTicketValues{Create}->{$Item},
        "TicketGet() - Original First Ticket - $Item.",
    );
}

# Create Article which will trigger first GenericAgent job for ArticleCreate event.
my $ArticleBackendObject
    = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel( ChannelName => 'Email' );
my $FirstArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $FirstTicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,
    %FirstArticleValues,
);

# Create second test RandomID identifier.
my $SecondRandomID = $Helper->GetRandomID();

# Define structure for second Ticket create.
my %SecondTicketValues = (
    Create => {
        Title      => 'Original second test created Ticket.',
        StateID    => 1,
        PriorityID => 2,
        OwnerID    => 1,
        CustomerID => '123',
        LockID     => 1,
        QueueID    => 2,
    },
    ArticleUpdateJob => {
        Title      => 'ArticleUpdate event GenericAgent job modified.',
        StateID    => 2,
        PriorityID => 5,
        OwnerID    => 1,
        CustomerID => '789',
        LockID     => 1,
        QueueID    => 1,
    },
);

# Add the new GenericAgent Job with ArticleUpdate as trigger event.
my $SecondJobName       = "ArticleUpdate Event UnitTest_$SecondRandomID";
my %SecondArticleValues = (
    From    => "Agent Some Agent <agent$SecondRandomID\@example.com>",
    To      => "Customer_ A <customera$SecondRandomID\@example.com>",
    Cc      => "Customer_ B <customerb$SecondRandomID\@example.com>",
    Subject => "Subject_$SecondRandomID Test",
    Body    => "Body_$SecondRandomID Test",
);

my $UpdateRandomID   = $Helper->GetRandomID();
my %ArticleUpdateJob = (
    Name => $SecondJobName,
    Data => {

        Valid => 1,

        EventValues => ['ArticleUpdate'],

        MIMEBase_Body => "*$UpdateRandomID*",
    },
);

for my $Item ( sort keys %{ $SecondTicketValues{ArticleUpdateJob} } ) {
    $ArticleUpdateJob{Data}->{ 'New' . $Item } = $SecondTicketValues{ArticleUpdateJob}->{$Item};
}

my $SecondJobAdd = $GenericAgentObject->JobAdd(
    %ArticleUpdateJob,
    UserID => 1,
);
$Self->True(
    $SecondJobAdd || '',
    'JobAdd() - ArticleUpdate event.',
);

# Create second Ticket to test JobRun on an event ArticleUpdate trigger.
my $SecondTicketID = $TicketObject->TicketCreate(
    %{ $SecondTicketValues{Create} },
    UserID => 1,
);
$Self->True(
    $SecondTicketID,
    "TicketCreate() - uses for GA - $SecondTicketID.",
);

# Get Ticket data, and confirm that it have the right values without changes.
my %SecondTicket = $TicketObject->TicketGet(
    TicketID => $SecondTicketID,
);
for my $Item ( sort keys %{ $SecondTicketValues{Create} } ) {
    $Self->Is(
        $SecondTicket{$Item},
        $SecondTicketValues{Create}->{$Item},
        "TicketGet() - Original Second Ticket - $Item.",
    );
}

# Create Article for test Ticket.
my $SecondArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $SecondTicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,
    %SecondArticleValues,
);

# Update Article Body field will trigger second GenericAgent job for ArticleUpdate event.
my $Success = $ArticleBackendObject->ArticleUpdate(
    TicketID  => $SecondTicketID,
    ArticleID => $SecondArticleID,
    Key       => 'Body',
    Value     => "Body_$UpdateRandomID Test",
    UserID    => 1,
);
$Self->True(
    $Success,
    "ArticleUpdate() - Body"
);

# Destroy the Tickets object for triggering the transactional events.
$Kernel::OM->ObjectsDiscard(
    Objects => [
        'Kernel::System::Ticket',
    ],
);

# Get updated first Ticket data and verify it.
my %FirstTicketUpdate = $TicketObject->TicketGet(
    TicketID => $FirstTicketID,
);

for my $Item ( sort keys %{ $FirstTicketValues{ArticleCreateJob} } ) {
    $Self->Is(
        $FirstTicketUpdate{$Item},
        $FirstTicketValues{ArticleCreateJob}->{$Item},
        "TicketGet() - ArticleCreate event GA job - $Item.",
    );
}

# Get updated second Ticket data and verify it.
my %SecondTicketUpdate = $TicketObject->TicketGet(
    TicketID => $SecondTicketID,
);

for my $Item ( sort keys %{ $SecondTicketValues{ArticleUpdateJob} } ) {
    $Self->Is(
        $SecondTicketUpdate{$Item},
        $SecondTicketValues{ArticleUpdateJob}->{$Item},
        "TicketGet() - ArticleUpdate event GA job - $Item.",
    );
}

# Cleanup is done by RestoreDatabase.

1;
