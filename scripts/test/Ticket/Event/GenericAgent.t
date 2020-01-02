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

use Kernel::System::Ticket;
use Kernel::System::GenericAgent;

# get dynamic field object
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# define structure for create and update values
my %TicketValues = (
    Create => {
        Title      => 'Test ticket for UnitTest of the event ticket actions.',
        StateID    => 1,
        PriorityID => 2,
        OwnerID    => 1,
        CustomerID => '123',
        LockID     => 1,
        QueueID    => 2,
    },
    Update => {
        Title      => 'This should be the result for the test.',
        StateID    => 3,
        PriorityID => 4,
        OwnerID    => 1,
        CustomerID => '456',
        LockID     => 2,
        QueueID    => 3,
    },
);

# add the new Job
my $JobName = 'UnitTest_' . $RandomID;
my %NewJob  = (

    Name => $JobName,

    Data => {
        TicketNumber                => '',
        MIMEBase_From               => '',
        MIMEBase_Body               => '',
        MIMEBase_To                 => '',
        MIMEBase_Cc                 => '',
        MIMEBase_Subject            => '',
        CustomerID                  => '',
        TimeSearchType              => 'TimePoint',
        TicketCreateTimePoint       => 1,
        TicketCreateTimePointStart  => 'Last',
        TicketCreateTimePointFormat => 'year',

        # this is the main setting for this test
        EventValues => ['ArticleCreate'],

        TicketCreateTimeStartMonth => 8,
        TicketCreateTimeStopMonth  => 9,
        TicketCreateTimeStartDay   => 7,
        TicketCreateTimeStopYear   => 2013,
        TicketCreateTimeStartYear  => 2006,
        TicketCreateTimeStopDay    => 6,

        NewNoteBody           => '',
        NewCustomerUserLogin  => '',
        NewModule             => '',
        NewSendNoNotification => 0,
        NewDelete             => 0,
        NewNoteSubject        => '',
        NewQueueID            => 3,
        NewNoteFrom           => '',
        NewCMD                => '',
        NewParamKey1          => '',
        NewParamValue1        => '',
        NewParamKey2          => '',
        NewParamValue2        => '',
        NewParamKey3          => '',
        NewParamValue3        => '',
        NewParamKey4          => '',
        NewParamValue4        => '',
        NewParamKey5          => '',
        NewParamValue5        => '',
        NewParamKey6          => '',
        NewParamValue6        => '',
        Valid                 => 1,
    },
);

for my $Item ( sort keys %{ $TicketValues{Update} } ) {
    $NewJob{Data}->{ 'New' . $Item } = $TicketValues{Update}->{$Item};
}

# add dynamic fields
my %AddDynamicFields = (
    NewDynamicField          => 'A new value',
    InterestingDynamicField  => 'The most beautiful song in the world.',
    NothingToSayDynamicField => 'Null',
    TooLongDynamicField      => $RandomID,
);

for my $FieldName ( sort keys %AddDynamicFields ) {

    # create a dynamic field
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $FieldName . $RandomID,
        Label      => $FieldName . "_test",
        FieldOrder => 9991,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            DefaultValue => 'a value',
        },
        ValidID => 1,
        UserID  => 1,
    );

    # verify dynamic field creation
    $Self->True(
        $FieldID,
        "DynamicFieldAdd() successful for Field $FieldName",
    );

    $NewJob{Data}->{ 'DynamicField_' . $FieldName . $RandomID } = $AddDynamicFields{$FieldName};
}

my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject         = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleInternalObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal');
my $GenericAgentObject    = $Kernel::OM->Get('Kernel::System::GenericAgent');

# create the new job
my $JobAdd = $GenericAgentObject->JobAdd(
    %NewJob,
    UserID => 1,
);
$Self->True(
    $JobAdd || '',
    'JobAdd()',
);

# get the new JobList
my %Jobs = ();
%Jobs = $GenericAgentObject->JobList();

# check if the new job exists
$Self->True(
    $Jobs{$JobName},
    'JobAdd() check if the added job exists',
);

# create a Ticket to test JobRun on an event trigger
my $TicketID = $TicketObject->TicketCreate(
    %{ $TicketValues{Create} },
    UserID => 1,
);

$Self->True(
    $TicketID,
    "TicketCreate() - uses for GenericAgenttest - $TicketID",
);

# get ticket data, and confirm that it have
# the right values without changes

my %Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);

# check current ticket data
for my $Item ( sort keys %{ $TicketValues{Create} } ) {

    $Self->Is(
        $Ticket{$Item},
        $TicketValues{Create}->{$Item},
        "TicketGet() - $Item",
    );
}

my $ArticleID = $ArticleInternalObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'this article is just for trigger a ArticleCreate event.',

    #    MessageID => '<asdasdasd.123@example.com>',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,                                   # if you don't want to send agent notifications
);

# Destroy the ticket object for triggering the transactional events.
# Recreate all objects which have references to the old TicketObject too!
$Kernel::OM->ObjectsDiscard(
    Objects => [
        'Kernel::System::Ticket',
        'Kernel::System::Ticket::Article',
        'Kernel::System::Ticket::GenericAgent',
    ],
);
$TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
$ArticleObject      = $Kernel::OM->Get('Kernel::System::Ticket::Article');
$GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

my %TicketMod = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);

# check updated ticket data
for my $Item ( sort keys %{ $TicketValues{Update} } ) {

    $Self->Is(
        $TicketMod{$Item},
        $TicketValues{Update}->{$Item},
        "TicketGet() - $Item",
    );
}

# check also for Dynamic Fields
for my $Item ( sort keys %AddDynamicFields ) {

    $Self->Is(
        $TicketMod{ 'DynamicField_' . $Item . $RandomID },
        $AddDynamicFields{$Item},
        "TicketGet() - DynamicFields - $Item",
    );
}

# add the new Job
my $RandomID2 = $Helper->GetRandomID();
my $JobName2  = 'UnitTest_' . $RandomID2;
my %NewJob2   = (
    Name => $JobName2,
    Data => {
        EventValues        => ['TicketStateUpdate'],
        StateIDs           => [ 6, 7, 8 ],
        NewPendingTime     => 10,
        NewPendingTimeType => 86400,
        Valid              => 1,
    },
);

# create the new job
my $JobAdd2 = $GenericAgentObject->JobAdd(
    %NewJob2,
    UserID => 1,
);
$Self->True(
    $JobAdd2 || '',
    'JobAdd()',
);

my $StateSetSuccess1 = $TicketObject->TicketStateSet(
    State    => 'open',
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $StateSetSuccess1,
    'Update #1',
);

my $StateSetSuccess2 = $TicketObject->TicketStateSet(
    State    => 'pending reminder',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $StateSetSuccess2,
    'Update #2',
);

$Kernel::OM->ObjectsDiscard(
    Objects => [
        'Kernel::System::Ticket',
        'Kernel::System::Ticket::Article',
        'Kernel::System::Ticket::GenericAgent',
    ],
);
$TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
$ArticleObject      = $Kernel::OM->Get('Kernel::System::Ticket::Article');
$GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

%Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 0,
);

# get current time
my $DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
);
my $SystemTime = $DateTimeObject->ToEpoch();

$Self->True(
    ( $Ticket{RealTillTimeNotUsed} > $SystemTime + 863500 )
        && ( $Ticket{RealTillTimeNotUsed} < $SystemTime + 864500 )
    ,
    "Check pending time",
);

# cleanup is done by RestoreDatabase.

1;
