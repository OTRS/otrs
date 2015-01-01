# --
# GenericAgent.t - GenericAgent tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::Ticket;
use Kernel::System::Queue;
use Kernel::System::GenericAgent;
use Kernel::System::UnitTest::Helper;
use Kernel::System::DynamicField;
use Kernel::Config;

# create local config object
my $ConfigObject = Kernel::Config->new();
my $Hook         = $ConfigObject->Get('Ticket::Hook');

$ConfigObject->Set(
    Key   => 'Ticket::NumberGenerator',
    Value => 'Kernel::System::Ticket::Number::DateChecksum',
);

# create local objects
# add or update dynamic fields if needed
my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$Self} );

my @DynamicfieldIDs;
my @DynamicFieldUpdate;

my %NeededDynamicfields = (
    TicketFreeKey1  => 1,
    TicketFreeText1 => 1,
    TicketFreeKey2  => 1,
    TicketFreeText2 => 1,
);

# list available dynamic fields
my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
    Valid      => 0,
    ResultType => 'HASH',
);
$DynamicFields = ( ref $DynamicFields eq 'HASH' ? $DynamicFields : {} );
$DynamicFields = { reverse %{$DynamicFields} };

for my $FieldName ( sort keys %NeededDynamicfields ) {
    if ( !$DynamicFields->{$FieldName} ) {

        # create a dynamic field
        my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $FieldName,
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
    }
    else {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet( ID => $DynamicFields->{$FieldName} );

        if ( $DynamicField->{ValidID} > 1 ) {
            push @DynamicFieldUpdate, $DynamicField;
            $DynamicField->{ValidID} = 1;
            my $SuccessUpdate = $DynamicFieldObject->DynamicFieldUpdate(
                %{$DynamicField},
                Reorder => 0,
                UserID  => 1,
                ValidID => 1,
            );

            # verify dynamic field creation
            $Self->True(
                $SuccessUpdate,
                "DynamicFieldUpdate() successful update for Field $DynamicField->{Name}",
            );
        }
    }
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

my %Jobs = ();

# Get the the existing JobList
%Jobs = $GenericAgentObject->JobList();
my $JobCounter1 = keys %Jobs;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = $HelperObject->GetRandomID();

$RandomID =~ s/\-//g;

# Add a new Job
my $Name   = 'UnitTest_' . $RandomID;
my %NewJob = (
    Name => $Name,
    Data => {

        #ScheduleLastRun => '',
        #ScheduleMinutes => [1,2],
        #ScheduleDays => [],
        #ScheduleHours => [],
        TicketNumber      => '',
        From              => '',
        Body              => '',
        To                => '',
        Cc                => '',
        Subject           => '',
        CustomerID        => '',
        CustomerUserLogin => 'customerUnitTest@example.com',

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

        TicketCreateTimeStartMonth   => 8,
        TicketCreateTimeStopMonth    => 9,
        TicketCreateTimeStartDay     => 7,
        TicketCreateTimeStopYear     => 2006,
        TicketCreateTimeStartYear    => 2006,
        TicketCreateTimeStopDay      => 6,
        NewTitle                     => 'some new title',
        NewStateID                   => 2,
        NewPriorityID                => 3,
        NewNoteBody                  => '',
        NewCustomerUserLogin         => '',
        NewOwnerID                   => 1,
        NewModule                    => '',
        DynamicField_TicketFreeKey1  => 'Phone',
        DynamicField_TicketFreeText1 => 'Test 1',
        NewSendNoNotification        => 0,
        NewDelete                    => 0,
        NewCustomerID                => '',
        NewNoteSubject               => '',
        NewLockID                    => 2,
        NewNoteFrom                  => '',
        DynamicField_TicketFreeKey2  => 'Test',
        DynamicField_TicketFreeText2 => 'Value 2',
        NewCMD                       => '',
        NewParamKey1                 => '',
        NewParamValue1               => '',
        NewParamKey2                 => '',
        NewParamValue2               => '',
        NewParamKey3                 => '',
        NewParamValue3               => '',
        NewParamKey4                 => '',
        NewParamValue4               => '',
        NewParamKey5                 => '',
        NewParamValue5               => '',
        NewParamKey6                 => '',
        NewParamValue6               => '',
        Valid                        => 1,
    },
);

my $JobAdd = $GenericAgentObject->JobAdd(
    %NewJob,
    UserID => 1,
);
$Self->True(
    $JobAdd || '',
    'JobAdd()',
);

# Get the new JobList
%Jobs = $GenericAgentObject->JobList();
my $JobCounter2 = keys %Jobs;

# Check if the new job exists
$Self->True(
    $Jobs{$Name},
    'JobAdd() check if the added job exists',
);

# Check if a job is lost or too much added
$Self->Is(
    $JobCounter1 + 1,
    $JobCounter2,
    "JobAdd() check if a job is lost or too much added",
);

# check job attributes
my %GetParam = $GenericAgentObject->JobGet( Name => $Name );
$Self->Is(
    $GetParam{CustomerUserLogin} || '',
    'customerUnitTest@example.com',
    "JobGet() - CustomerUserLogin",
);
$Self->Is(
    $GetParam{Title} || '',
    '',
    "JobGet() - Title",
);
$Self->Is(
    $GetParam{NewTitle} || '',
    'some new title',
    "JobGet() - NewTitle",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeKey1} || '',
    'Phone',
    "JobGet() - DynamicField_TicketFreeKey1",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeText1} || '',
    'Test 1',
    "JobGet() - DynamicField_FreeText1",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeKey2} || '',
    'Test',
    "JobGet() - DynamicField_TicketFreeKey2",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeText2} || '',
    'Value 2',
    "JobGet() - DynamicField_TicketFreeText2",
);
$Self->True(
    !$GetParam{From},
    "JobGet() - From",
);
$Self->True(
    !$GetParam{Body} || '',
    "JobGet() - Body",
);
$Self->True(
    !$GetParam{ScheduleLastRun} || '',
    "JobGet() - ScheduleLastRun",
);
$Self->True(
    !$GetParam{ScheduleLastRunUnixTime} || '',
    "JobGet() - ScheduleLastRunUnixTime",
);

$Self->True(
    $GetParam{TicketCreateTimeNewerMinutes} || '',
    "JobGet() - TicketCreateTimeNewerMinutes",
);

# Try to add the same JobName double
my $Return = $GenericAgentObject->JobAdd(
    Name => $Name,
    Data => {
        ScheduleLastRun => '',
    },
    UserID => 1,
);

$Self->True(
    !$Return || '',
    'JobAdd() check return value - douple check',
);

# Create a Ticket to test JobRun and JobRunTicket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Testticket for Untittest of the Generic Agent',
    Queue        => 'Raw',
    Lock         => 'unlock',
    PriorityID   => 1,
    StateID      => 1,
    CustomerNo   => '123465',
    CustomerUser => 'customerUnitTest@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID    => $TicketID,
    ArticleType => 'note-internal',
    SenderType  => 'agent',
    From        => 'Agent Some Agent Some Agent <email@example.com>',
    To          => 'Customer A <customer-a@example.com>',
    Cc          => 'Customer B <customer-b@example.com>',
    ReplyTo     => 'Customer B <customer-b@example.com>',
    Subject     => 'some short description',
    Body        => 'the message text Perl modules provide a range of
',

    #    MessageID => '<asdasdasd.123@example.com>',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,                                   # if you don't want to send agent notifications
);

$Self->True(
    $TicketID,
    'TicketCreate() - uses for GenericAgenttest',
);

%GetParam = $GenericAgentObject->JobGet( Name => $Name );

my @ViewableIDs = $TicketObject->TicketSearch(
    Result  => 'ARRAY',
    SortBy  => 'Age',
    OrderBy => 'Down',
    UserID  => 1,
    %GetParam,
);

$Self->Is(
    $#ViewableIDs + 1,
    1,
    "TicketSearch() check if the ticket is available",
);

$Self->True(
    $GenericAgentObject->JobRun(
        Job    => $Name,
        UserID => 1,
    ),
    'JobRun() Run the UnitTest GenericAgent job',
);

my %Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);

# more change checks are useful!!
$Self->Is(
    $Ticket{Title},
    'some new title',
    "TicketGet() - Title",
);
$Self->Is(
    $Ticket{StateID},
    2,
    "TicketGet() - State",
);

$Self->Is(
    $Ticket{PriorityID},
    3,
    "TicketGet() - Priority",
);
$Self->Is(
    $Ticket{DynamicField_TicketFreeKey1} || '',
    'Phone',
    "TicketGet() -  DynamicField_TicketFreeKey1",
);

$Self->Is(
    $Ticket{DynamicField_TicketFreeText1} || '',
    'Test 1',
    "TicketGet() - DynamicField_TicketFreeText1",
);

$Self->Is(
    $Ticket{DynamicField_TicketFreeKey2} || '',
    'Test',
    "TicketGet() - DynamicField_TicketFreeKey2",
);

$Self->Is(
    $Ticket{DynamicField_TicketFreeText2} || '',
    'Value 2',
    "TicketGet() - DynamicField_TicketFreeText2",
);

$Self->True(
    $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    ),
    'TicketDelete()',
);

# check job attributes
%GetParam = $GenericAgentObject->JobGet( Name => $Name );
$Self->Is(
    $GetParam{CustomerUserLogin} || '',
    'customerUnitTest@example.com',
    "JobGet() - CustomerUserLogin",
);
$Self->Is(
    $GetParam{Title} || '',
    '',
    "JobGet() - Title",
);
$Self->Is(
    $GetParam{NewTitle} || '',
    'some new title',
    "JobGet() - NewTitle",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeKey1} || '',
    'Phone',
    "JobGet() - DynamicField_TicketFreeKey1",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeText1} || '',
    'Test 1',
    "JobGet() - DynamicField_TicketFreeText1",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeKey2} || '',
    'Test',
    "JobGet() - DynamicField_TicketFreeKey2",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeText2} || '',
    'Value 2',
    "JobGet() - DynamicField_TicketFreeText2",
);
$Self->True(
    !$GetParam{From},
    "JobGet() - From",
);
$Self->True(
    !$GetParam{Body} || '',
    "JobGet() - Body",
);
$Self->True(
    $GetParam{ScheduleLastRun} || '',
    "JobGet() - ScheduleLastRun",
);
$Self->True(
    $GetParam{ScheduleLastRunUnixTime} || '',
    "JobGet() - ScheduleLastRunUnixTime",
);

# delete job
my $JobDelete = $GenericAgentObject->JobDelete(
    Name   => $Name,
    UserID => 1,
);
$Self->True(
    $JobDelete || '',
    'JobDelete()',
);

# add
$GetParam{From}  = 'Some From';
$GetParam{Body}  = 'Some Body';
$GetParam{Title} = 'some new new title';
$JobAdd          = $GenericAgentObject->JobAdd(
    Name   => $Name,
    Data   => \%GetParam,
    UserID => 1,
);
$Self->True(
    $JobAdd || '',
    'JobAdd()',
);

# check job attributes
%GetParam = $GenericAgentObject->JobGet( Name => $Name );
$Self->Is(
    $GetParam{CustomerUserLogin} || '',
    'customerUnitTest@example.com',
    "JobGet() - CustomerUserLogin",
);
$Self->Is(
    $GetParam{Title} || '',
    'some new new title',
    "JobGet() - Title",
);
$Self->Is(
    $GetParam{NewTitle} || '',
    'some new title',
    "JobGet() - NewTitle",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeKey1} || '',
    'Phone',
    "JobGet() - DynamicField_TicketFreeKey1",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeText1} || '',
    'Test 1',
    "JobGet() - DynamicField_TicketFreeText1",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeKey2} || '',
    'Test',
    "JobGet() - DynamicField_TicketFreeKey2",
);
$Self->Is(
    $GetParam{DynamicField_TicketFreeText2} || '',
    'Value 2',
    "JobGet() - DynamicField_TicketFreeText2",
);
$Self->Is(
    $GetParam{From} || '',
    'Some From',
    "JobGet() - From",
);
$Self->Is(
    $GetParam{Body} || '',
    'Some Body',
    "JobGet() - Body",
);
$Self->True(
    $GetParam{ScheduleLastRun} || '',
    "JobGet() - ScheduleLastRun",
);
$Self->True(
    $GetParam{ScheduleLastRunUnixTime} || '',
    "JobGet() - ScheduleLastRunUnixTime",
);

# delete job
$JobDelete = $GenericAgentObject->JobDelete(
    Name   => $Name,
    UserID => 1,
);
$Self->True(
    $JobDelete || '',
    'JobDelete()',
);

# Get the new JobList
%Jobs = $GenericAgentObject->JobList();
my $JobCounter3 = keys %Jobs;

# Check if a job is lost or too much added
$Self->Is(
    $JobCounter1,
    $JobCounter3,
    "JobDelete() check if the correct number of jobs available",
);

# revert changes to dynamic fields
for my $DynamicField (@DynamicFieldUpdate) {
    my $SuccessUpdate = $DynamicFieldObject->DynamicFieldUpdate(
        Reorder => 0,
        UserID  => 1,
        %{$DynamicField},
    );
    $Self->True(
        $SuccessUpdate,
        "Reverted changes on ValidID for $DynamicField->{Name} field.",
    );
}

for my $DynamicFieldID (@DynamicfieldIDs) {

    # delete the dynamic field
    my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );
    $Self->True(
        $FieldDelete,
        "Deleted dynamic field with id $DynamicFieldID.",
    );
}

1;
