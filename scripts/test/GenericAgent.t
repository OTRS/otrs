# --
# GenericAgent.t - GenericAgent tests
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: GenericAgent.t,v 1.2 2006-09-19 15:10:17 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Ticket;
use Kernel::System::Queue;
use Kernel::System::GenericAgent;

my $Hook = $Self->{ConfigObject}->Get('Ticket::Hook');

$Self->{ConfigObject}->Set(
    Key => 'Ticket::NumberGenerator',
    Value => 'Kernel::System::Ticket::Number::DateChecksum',
);
$Self->{TicketObject} = Kernel::System::Ticket->new(%{$Self});
$Self->{QueueObject} = Kernel::System::Queue->new(%{$Self});
$Self->{GenericAgentObject} = Kernel::System::GenericAgent->new(%{$Self});

my %Jobs = ();

# Get the the existing JobList
%Jobs = $Self->{GenericAgentObject}->JobList();
my $JobCounter1 = keys %Jobs;

# Add a new Job
my $Name = 'UnitTest' . int(rand(1000000));
my %NewJob = (
    Name => $Name,
    Data => {
        ScheduleLastRun => '',
        #ScheduleMinutes => [1,2],
        #ScheduleDays => [],
        #ScheduleHours => [],
        TicketNumber => '',
        From => '',
        Body => '',
        To => '',
        Cc => '',
        Subject => '',
        CustomerID => '',
        CustomerUserLogin => 'customerUnitTest@example.com',
        #QueueIDs => [],
        #PriorityIDs => [],
        #LockIDs => [],
        #TicketFreeText2 => [],
        #OwnerIDs => [],
        #StateIDs => [],
        TimeSearchType => '',
        TicketCreateTimeStartMonth => 8,
        TicketCreateTimeStopMonth => 9,
        TicketCreateTimeStartDay => 7,
        TicketCreateTimeStopYear => 2006,
        TicketCreateTimeStartYear => 2006,
        TicketCreateTimeStopDay => 6,
        TicketCreateTimePoint => 1,
        TicketCreateTimePointStart => 'Last',
        TicketCreateTimePointFormat => 'day',
        NewStateID => 2,
        NewPriorityID => 3,
        NewNoteBody => '',
        NewCustomerUserLogin => '',
        NewOwnerID => 1,
        NewModule => '',
        NewTicketFreeText1 => 'Phone',
        NewSendNoNotification => 0,
        NewDelete => 0,
        NewCustomerID => '',
        NewNoteSubject => '',
        NewLockID => 2,
        NewNoteFrom => '',
        NewTicketFreeText2 => 'test',
        NewCMD => '',
        NewParamKey1 => '',
        NewParamValue1 => '',
        NewParamKey2 => '',
        NewParamValue2 => '',
        NewParamKey3 => '',
        NewParamValue3 => '',
        NewParamKey4 => '',
        NewParamValue4 => '',
        NewParamKey5 => '',
        NewParamValue5 => '',
        NewParamKey6 => '',
        NewParamValue6 => '',
        Valid => 1,
    },
);

$Self->True(
    $Self->{GenericAgentObject}->JobAdd(
        %NewJob
    ),
    'JobAdd() check return value',
);

# Get the new JobList
%Jobs = $Self->{GenericAgentObject}->JobList();
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

# Try to add the same JobName double
# $Self->True(
#     $Self->{GenericAgentObject}->JobAdd(
#         Name => $Name,
#         Data => {
#             ScheduleLastRun => '',
#         },
#     ),
#     'JobAdd() check return value',
# );

# Create a Ticket to test JobRun and JobRunTicket
my $TicketID = $Self->{TicketObject}->TicketCreate(
    Title => 'Testticket for Untittest of the Generic Agent',
    Queue => 'Raw',
    Lock => 'unlock',
    PriorityID => 1,
    StateID => 1,
    CustomerNo => '123465',
    CustomerUser => 'customerUnitTest@example.com',
    OwnerID => 1,
    UserID => 1,
);

my $ArticleID = $Self->{TicketObject}->ArticleCreate(
    TicketID => $TicketID,
    ArticleType => 'note-internal',
    SenderType => 'agent',
    From => 'Agent Some Agent Some Agent <email@example.com>',
    To => 'Customer A <customer-a@example.com>',
    Cc => 'Customer B <customer-b@example.com>',
    ReplyTo => 'Customer B <customer-b@example.com>',
    Subject => 'some short description',
    Body => 'the message text Perl modules provide a range of
',
#    MessageID => '<asdasdasd.123@example.com>',
    ContentType => 'text/plain; charset=ISO-8859-15',
    HistoryType => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID => 1,
    NoAgentNotify => 1,            # if you don't want to send agent notifications
);

$Self->True(
    $TicketID,
    'TicketCreate() - uses for GenericAgenttest',
);

my %GetParam = ();
%GetParam = $Self->{GenericAgentObject}->JobGet(Name => $Name);

my @ViewableIDs = $Self->{TicketObject}->TicketSearch(
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
    $Self->{GenericAgentObject}->JobRun(
        Job => $Name,
        UserID => 1,
    ),
    'JobRun() Run the UnitTest GenericAgent job',
);

my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $TicketID);

# more change checks are useful!!
$Self->Is(
    $Ticket{StateID},
    2,
    "TicketGet() check if generic agent job changed the ticket settings (State)",
);

$Self->Is(
    $Ticket{PriorityID},
    3,
    "TicketGet() check if generic agent job changed the ticket settings (Priority)",
);


$Self->True(
    $Self->{TicketObject}->TicketDelete(
        TicketID => $TicketID,
        UserID => 1,
    ),
    'TicketDelete()',
);

# delete the test job
$Self->True(
    $Self->{GenericAgentObject}->JobDelete(Name => $Name),
    'JobDelete() check the return of the delete function',
);

# Get the new JobList
%Jobs = $Self->{GenericAgentObject}->JobList();
my $JobCounter3 = keys %Jobs;

# Check if a job is lost or too much added
$Self->Is(
    $JobCounter1,
    $JobCounter3,
    "JobDelete() check if the correct number of jobs available",
);

1;
