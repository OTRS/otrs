# --
# GenericAgent.t - event based ticket actions tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::Ticket;
use Kernel::System::Queue;
use Kernel::System::GenericAgent;
use Kernel::System::UnitTest::Helper;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::Config;

# create local config object
my $ConfigObject = Kernel::Config->new();

# generate random string
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);
my $RandomID = $HelperObject->GetRandomID();

# create local objects
my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$Self} );

my $BackendObject = Kernel::System::DynamicField::Backend->new( %{$Self} );

# define structure for create and update values
my %TicketValues = (
    Create => {
        Title      => 'Test ticket for UntitTest of the event ticket actions.',
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

        #ScheduleLastRun => '',
        #ScheduleMinutes => [1,2],
        #ScheduleDays => [],
        #ScheduleHours => [],
        TicketNumber => '',
        From         => '',
        Body         => '',
        To           => '',
        Cc           => '',
        Subject      => '',
        CustomerID   => '',

        #        CustomerUserLogin => 'customerUnitTest@example.com',

        #QueueIDs => [],
        #PriorityIDs => [],
        #LockIDs => [],
        #TicketFreeText2 => [],
        #OwnerIDs => [],
        #StateIDs => [],
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

        #        NewCustomerID                => '',
        NewNoteSubject => '',
        NewQueueID     => 3,
        NewNoteFrom    => '',
        NewCMD         => '',
        NewParamKey1   => '',
        NewParamValue1 => '',
        NewParamKey2   => '',
        NewParamValue2 => '',
        NewParamKey3   => '',
        NewParamValue3 => '',
        NewParamKey4   => '',
        NewParamValue4 => '',
        NewParamKey5   => '',
        NewParamValue5 => '',
        NewParamKey6   => '',
        NewParamValue6 => '',
        Valid          => 1,
    },
);

for my $Item ( sort keys %{ $TicketValues{Update} } ) {
    $NewJob{Data}->{ 'New' . $Item } = $TicketValues{Update}->{$Item};
}

# add dynamic fields
my @DynamicfieldIDs;
my %AddDynamicfields = (
    NewDynamicField          => 'A new value',
    InterestingDynamicField  => 'The most beautyful song in the world.',
    NothingToSayDynamicField => 'Null',
    TooLongDynamicField      => $RandomID,
);

for my $FieldName ( sort keys %AddDynamicfields ) {

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

    push @DynamicfieldIDs, $FieldID;

    $NewJob{Data}->{ 'DynamicField_' . $FieldName . $RandomID } = $AddDynamicfields{$FieldName};
}

my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    TicketObject => $TicketObject,
);
my $GenericAgentObject = Kernel::System::GenericAgent->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    TicketObject => $TicketObject,
    QueueObject  => $QueueObject,
);

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

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID    => $TicketID,
    ArticleType => 'note-internal',
    SenderType  => 'agent',
    From        => 'Agent Some Agent Some Agent <email@example.com>',
    To          => 'Customer A <customer-a@example.com>',
    Subject     => 'some short description',
    Body        => 'this article is just for trigger a ArticleCreate event.',

    #    MessageID => '<asdasdasd.123@example.com>',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify => 1,    # if you don't want to send agent notifications
);

# Destroy the ticket object for triggering the transactional events.
# Recreate all objects which have references to the old TicketObject too!
$TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
$QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    TicketObject => $TicketObject,
);
$GenericAgentObject = Kernel::System::GenericAgent->new(
    %{$Self},
    ConfigObject => $ConfigObject,
    TicketObject => $TicketObject,
    QueueObject  => $QueueObject,
);

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
for my $Item ( sort keys %AddDynamicfields ) {

    $Self->Is(
        $TicketMod{ 'DynamicField_' . $Item . $RandomID },
        $AddDynamicfields{$Item},
        "TicketGet() - DynamicFields - $Item",
    );
}

for my $DynamicFieldID (@DynamicfieldIDs) {

    my $ValuesDelete = $BackendObject->AllValuesDelete(
        DynamicFieldConfig => {
            ID         => $DynamicFieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Text',
        },
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $ValuesDelete,
        "AllValuesDelete() successful for Field ID $DynamicFieldID",
    );

    # delete the dynamic field
    my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    # sanity check
    $Self->True(
        $FieldDelete,
        "DynamicFieldDelete() successful for Field ID $DynamicFieldID",
    );
}

# delete the ticket
my $TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

# sanity check
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket ID $TicketID",
);

# delete job
my $JobDelete = $GenericAgentObject->JobDelete(
    Name   => $JobName,
    UserID => 1,
);
$Self->True(
    $JobDelete || '',
    'JobDelete()',
);

1;
