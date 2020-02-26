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

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Hook = $ConfigObject->Get('Ticket::Hook');

$ConfigObject->Set(
    Key   => 'Ticket::NumberGenerator',
    Value => 'Kernel::System::Ticket::Number::DateChecksum',
);

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

my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

my %Jobs;

# get the the existing JobList
%Jobs = $GenericAgentObject->JobList();
my $JobCounter1 = keys %Jobs;

# Create a Ticket to test JobRun and JobRunTicket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Test ticket for Untittest of the Generic Agent',
    Queue        => 'Raw',
    Lock         => 'unlock',
    PriorityID   => 1,
    StateID      => 1,
    CustomerNo   => '123465',
    CustomerUser => 'customerUnitTest@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

my $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal')->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text Perl modules provide a range of
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

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
);

$Self->True(
    $Ticket{TicketNumber},
    'Found ticket number',
);

# add a new Job
my $Name   = $Helper->GetRandomID();
my %NewJob = (
    Name => $Name,
    Data => {
        TicketNumber                 => $Ticket{TicketNumber},
        MIMEBase_From                => '',
        MIMEBase_Body                => '',
        MIMEBase_To                  => '',
        MIMEBase_Cc                  => '',
        MIMEBase_Subject             => '',
        CustomerID                   => '',
        CustomerUserLogin            => 'customerUnitTest@example.com',
        TimeSearchType               => 'TimePoint',
        TicketCreateTimePoint        => 1,
        TicketCreateTimePointStart   => 'Last',
        TicketCreateTimePointFormat  => 'year',
        TicketCreateTimeStartMonth   => 8,
        TicketCreateTimeStopMonth    => 9,
        TicketCreateTimeStartDay     => 7,
        TicketCreateTimeStopYear     => 2006,
        TicketCreateTimeStartYear    => 2006,
        TicketCreateTimeStopDay      => 6,
        NewTitle                     => 'some new title',
        NewStateID                   => 2,
        NewPriorityID                => 3,
        NewCustomerUserLogin         => '',
        NewOwnerID                   => 1,
        NewModule                    => '',
        DynamicField_TicketFreeKey1  => 'Phone',
        DynamicField_TicketFreeText1 => 'Test 1',
        NewSendNoNotification        => 0,
        NewDelete                    => 0,
        NewCustomerID                => 'TestCustomerID',
        NewNoteFrom                  => 'From',
        NewNoteBody                  => 'Body',
        NewNoteSubject               => 'Subject',
        NewNoteIsVisibleForCustomer  => '1',
        NewLockID                    => 2,
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
    !$GetParam{MIMEBase_From},
    "JobGet() - MIMEBase_From",
);
$Self->True(
    !$GetParam{MIMEBase_Body} || '',
    "JobGet() - MIMEBase_Body",
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
    'JobAdd() check return value - double check',
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

%Ticket = $TicketObject->TicketGet(
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

$Self->Is(
    $Ticket{CustomerUserID} || '',
    'customerUnitTest@example.com',
    "TicketGet() - CustomerUserLogin",
);

my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my @MetaArticles  = $ArticleObject->ArticleList(
    TicketID => $TicketID,
    OnlyLast => 1,
    UserID   => 1,
);

my %NoteArticle = $ArticleObject->BackendForArticle( %{ $MetaArticles[0] } )->ArticleGet( %{ $MetaArticles[0] } );

$Self->Is(
    $NoteArticle{From},
    'From',
    'Notification article From found',
);

$Self->True(
    scalar $NoteArticle{Subject} =~ m{Subject},
    'Notification article Subject found',
);

$Self->Is(
    $NoteArticle{Body},
    'Body',
    'Notification article Body found',
);

$Self->Is(
    $NoteArticle{IsVisibleForCustomer},
    1,
    'Notification article IsVisibleForCustomer found',
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
    !$GetParam{MIMEBase_From},
    "JobGet() - MIMEBase_From",
);
$Self->True(
    !$GetParam{MIMEBase_Body} || '',
    "JobGet() - MIMEBase_Body",
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
$GetParam{MIMEBase_From} = 'Some From';
$GetParam{MIMEBase_Body} = 'Some Body';
$GetParam{Title}         = 'some new new title';
$JobAdd                  = $GenericAgentObject->JobAdd(
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
    $GetParam{MIMEBase_From} || '',
    'Some From',
    "JobGet() - MIMEBase_From",
);
$Self->Is(
    $GetParam{MIMEBase_Body} || '',
    'Some Body',
    "JobGet() - MIMEBase_Body",
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

# Check LastClose functionality (see bug#14774).
my $TestJobName   = 'Job' . $Helper->GetRandomID();
my $OldPriorityID = 3;
my $NewPriorityID = 1;

$Helper->FixedTimeSet();

# Go 7 days to the past.
$Helper->FixedTimeAddSeconds( -60 * 60 * 24 * 7 );

# Add generic agent job - select a ticket with LastClose in last 3 days and set its priority to very low.
# At first job run, ticket has not to be found because last close is 4 days ago ('last 3 days' doesn't match this value).
# At second job run, ticket has to be found because last close is 2 days ago ('last 3 days' matches this value).
my $TestJobAdd = $GenericAgentObject->JobAdd(
    Name => $TestJobName,
    Data => {
        LastCloseTimeSearchType        => 'TimePoint',
        TicketLastCloseTimePoint       => 3,
        TicketLastCloseTimePointFormat => 'day',
        TicketLastCloseTimePointStart  => 'Last',
        NewPriorityID                  => $NewPriorityID,
        Valid                          => 1,
    },
    UserID => 1,
);
$Self->True(
    $TestJobAdd,
    "TestJob '$TestJobName' is created",
);

# Create test ticket.
my $TestTicketID = $TicketObject->TicketCreate(
    Title        => 'Test for LastClose',
    Queue        => 'Raw',
    Lock         => 'unlock',
    PriorityID   => $OldPriorityID,
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customerUnitTest@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TestTicketID,
    "TicketID $TestTicketID is created",
);

my @Tests = (
    {
        State      => 'closed successful',
        DaysInPast => '6',
    },
    {
        State      => 'open',
        DaysInPast => '5',
    },
    {
        State      => 'closed successful',
        DaysInPast => '4',
    }
);

for my $Test (@Tests) {

    # Add one day.
    $Helper->FixedTimeAddSeconds( 60 * 60 * 24 );

    my $Success = $TicketObject->TicketStateSet(
        State    => $Test->{State},
        TicketID => $TestTicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "$Test->{DaysInPast} days ago - State '$Test->{State}' is set to TicketID '$TestTicketID' successfully",
    );
}

# Unset fixed time because the job has to run in present.
$Helper->FixedTimeUnset();

# Run the job - test ticket has not to be found.
$Self->True(
    $GenericAgentObject->JobRun(
        Job    => $TestJobName,
        UserID => 1,
    ),
    "Run GenericAgent job '$TestJobName'",
);

my %TestTicket = $TicketObject->TicketGet(
    TicketID => $TestTicketID,
);
$Self->Is(
    $TestTicket{PriorityID},
    $OldPriorityID,
    "First job run - PriorityID is still '$OldPriorityID'",
);

$Helper->FixedTimeSet();

# Continue with ticket state changes (go 4 days to the past).
$Helper->FixedTimeAddSeconds( -60 * 60 * 24 * 4 );

# Open the ticket 3 days ago and close 2 days ago.
@Tests = (
    {
        State      => 'open',
        DaysInPast => '3',
    },
    {
        State      => 'closed successful',
        DaysInPast => '2',
    }
);

for my $Test (@Tests) {

    # Add one day.
    $Helper->FixedTimeAddSeconds( 60 * 60 * 24 );

    my $Success = $TicketObject->TicketStateSet(
        State    => $Test->{State},
        TicketID => $TestTicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "$Test->{DaysInPast} days ago - State '$Test->{State}' is set to TicketID '$TestTicketID' successfully",
    );
}

# Unset fixed time because the job has to run in present.
$Helper->FixedTimeUnset();

# Run the job again - test ticket has to be found.
$Self->True(
    $GenericAgentObject->JobRun(
        Job    => $TestJobName,
        UserID => 1,
    ),
    "Run GenericAgent job '$TestJobName'",
);

%TestTicket = $TicketObject->TicketGet(
    TicketID => $TestTicketID,
);
$Self->Is(
    $TestTicket{PriorityID},
    $NewPriorityID,
    "Second job run - PriorityID is changed to '$NewPriorityID'",
);

# cleanup is done by RestoreDatabase

1;
