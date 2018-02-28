# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
my $UserObject        = $Kernel::OM->Get('Kernel::System::User');
my $QueueObject       = $Kernel::OM->Get('Kernel::System::Queue');
my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
my $TicketObject      = $Kernel::OM->Get('Kernel::System::Ticket');

my $RandomID = $Helper->GetRandomID();

# Create test user.
my $UserLogin = $Helper->TestUserCreate();
my $UserID = $UserObject->UserLookup( UserLogin => $UserLogin );
$Self->True(
    $UserID,
    "UserID $UserID is created",
);

# Create test group.
my $GroupID = $GroupObject->GroupAdd(
    Name    => "Group$RandomID",
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $GroupID,
    "GroupID $GroupID is created",
);

# Add test user to test group.
my $Success = $GroupObject->PermissionGroupUserAdd(
    GID        => $GroupID,
    UID        => $UserID,
    Permission => {
        rw => 1,
    },
    UserID => 1,
);
$Self->True(
    $Success,
    "UserID $UserID added to groupID $GroupID",
);

# Create test queue with escalation rules.
my $QueueID = $QueueObject->QueueAdd(
    Name                => "Queue$RandomID",
    ValidID             => 1,
    GroupID             => $GroupID,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => 'Some Comment',
);
$Self->True(
    $QueueID,
    "QueueID $QueueID is created",
);

# Create test calendar.
my %Calendar = $CalendarObject->CalendarCreate(
    CalendarName => "Calendar$RandomID",
    Color        => '#3A87AD',
    GroupID      => $GroupID,
    UserID       => $UserID,
);
$Self->True(
    $Calendar{CalendarID},
    "CalendarID $Calendar{CalendarID} is created",
);

# Generate random string for RuleID.
my $RuleID = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
    Length     => 32,
    Dictionary => [ 0 .. 9, 'a' .. 'f' ],
);

# Update test calendar with rule.
$Success = $CalendarObject->CalendarUpdate(
    %Calendar,
    TicketAppointments => [
        {
            RuleID       => $RuleID,
            StartDate    => 'SolutionTime',
            EndDate      => 'Plus_30',
            QueueID      => [$QueueID],
            SearchParams => {},
        },
    ],
    UserID => $UserID,
);
$Self->True(
    $Success,
    "CalendarID $Calendar{CalendarID} is updated with ticket appointment rule",
);

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title    => "Ticket$RandomID",
    QueueID  => $QueueID,
    Lock     => 'unlock',
    Priority => '3 normal',
    State    => 'open',
    OwnerID  => 1,
    UserID   => 1,
);
$Self->True(
    $TicketID,
    "TicketID $TicketID is created",
);

# Create article.
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );
my $ArticleID            = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'user@example.com',
    To                   => 'customer@example.com',
    Subject              => 'Some Subject',
    Body                 => 'Some Body',
    MimeType             => 'plain/text',
    Charset              => 'utf-8',
    Queue                => 'raw',
    HistoryType          => 'AddNote',
    HistoryComment       => '%%',
    UserID               => 1,
);
$Self->True(
    $ArticleID,
    "ArticleID $ArticleID is created for TicketID $TicketID",
);

# Renew object because of transaction.
$Kernel::OM->ObjectsDiscard(
    Objects => [ 'Kernel::System::Ticket', ],
);
$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Process ticket appointments of the calendar.
my %Result = $CalendarObject->TicketAppointmentProcessCalendar(
    CalendarID => $Calendar{CalendarID},
);

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Check if there is an appointment created by ticket creation (ticket-appointment relation).
# Get AppointmentID from ticket-appointment relation.
my $AppointmentID;
$DBObject->Prepare(
    SQL  => "SELECT appointment_id FROM calendar_appointment_ticket WHERE ticket_id = ?",
    Bind => [ \$TicketID ]
);
while ( my @Row = $DBObject->FetchrowArray() ) {
    $AppointmentID = $Row[0];
}

$Self->True(
    $AppointmentID,
    "Relation TicketID $TicketID - AppointmentID $AppointmentID exists",
);

# Verify that appointment with AppoinmentID exists.
my %AppointmentData = $AppointmentObject->AppointmentGet(
    AppointmentID => $AppointmentID,
);
$Self->True(
    IsHashRefWithData( \%AppointmentData ),
    "AppointmentID $AppointmentID exists",
);

# Start daemon if needed.
my $Home                 = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $Daemon               = "$Home/bin/otrs.Daemon.pl";
my $PreviousDaemonStatus = `perl $Daemon status`;

if ( $PreviousDaemonStatus =~ m{Daemon not running}i ) {
    my $Result = system("perl $Daemon start");
    $Self->Is(
        $Result,
        0,
        "Daemon is started successfully.",
    );

    # Wait for slow systems.
    my $SleepTime = 120;
    print "Waiting at most $SleepTime s until daemon starts\n";
    ACTIVESLEEP:
    for my $Seconds ( 1 .. $SleepTime ) {
        my $DaemonStatus = `perl $Daemon status`;
        if ( $DaemonStatus =~ m{Daemon running}i ) {
            last ACTIVESLEEP;
        }
        print "Sleeping for $Seconds seconds...\n";
        sleep 1;
    }
}

my $TaskWorkerObject  = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker');
my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

# Remove scheduled tasks from DB, as they may interfere with tests run later.
my @AllTasks = $SchedulerDBObject->TaskList();
for my $Task (@AllTasks) {
    my $Success = $SchedulerDBObject->TaskDelete(
        TaskID => $Task->{TaskID},
    );
    $Self->True(
        $Success,
        "TaskDelete - Removed scheduled task $Task->{TaskID}",
    );
}

# Delete ticket.
$Success = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketID $TicketID is deleted",
);

# Discard ticket object.
$Kernel::OM->ObjectsDiscard(
    Objects => ['Kernel::System::Ticket'],
);

# Wait for slow systems.
my $SleepTime = 5;
print "Waiting at most $SleepTime s until task are registered\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my @List = $SchedulerDBObject->TaskList(
        Type => 'AsynchronousExecutor',
    );
    last ACTIVESLEEP if scalar @List;
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
}

my $TotalWaitToExecute = 120;

# Wait for daemon to actually execute task.
WAITEXECUTE:
for my $Wait ( 1 .. $TotalWaitToExecute ) {
    print "Waiting for Daemon to execute task, $Wait seconds\n";

    my $Success = $TaskWorkerObject->Run();
    $TaskWorkerObject->_WorkerPIDsCheck();
    $Self->True(
        $Success,
        'TaskWorker Run() - To execute current tasks, with true',
    );

    my @List = $SchedulerDBObject->TaskList(
        Type => 'AsynchronousExecutor',
    );

    if ( scalar @List eq 0 ) {
        $Self->True(
            1,
            "All tasks are dropped from task list",
        );
        last WAITEXECUTE;
    }

    sleep 1;

    next WAITEXECUTE if $Wait < $TotalWaitToExecute;

    $Self->True(
        0,
        "All tasks are not dropped from task list after $TotalWaitToExecute seconds!",
    );
}

# Check if ticket-appointment relation is deleted.
my $AppointmentIDAfter;
$DBObject->Prepare(
    SQL  => "SELECT appointment_id FROM calendar_appointment_ticket WHERE ticket_id = ?",
    Bind => [ \$TicketID ]
);
while ( my @Row = $DBObject->FetchrowArray() ) {
    $AppointmentIDAfter = $Row[0];
}
$Self->False(
    $AppointmentIDAfter,
    "Relation TicketID $TicketID - AppointmentID $AppointmentID is deleted",
);

# Check if the appointment created by ticket creation is deleted.
my %Appointment = $AppointmentObject->AppointmentGet(
    AppointmentID => $AppointmentID,
);
$Self->True(
    !IsHashRefWithData( \%Appointment ),
    "AppointmentID $AppointmentID is deleted",
);

# Stop daemon if needed.
if ( $PreviousDaemonStatus =~ m{Daemon not running}i ) {
    my $Result = system("perl $Daemon stop");
    $Self->Is(
        $Result,
        0,
        "Daemon is stopped successfully.",
    );

    # Wait for slow systems.
    my $SleepTime = 120;
    print "Waiting at most $SleepTime s until daemon stops\n";
    ACTIVESLEEP:
    for my $Seconds ( 1 .. $SleepTime ) {
        my $DaemonStatus = `perl $Daemon status`;
        if ( $DaemonStatus =~ m{Daemon not running}i ) {
            last ACTIVESLEEP;
        }
        print "Sleeping for $Seconds seconds...\n";
        sleep 1;
    }
}

my $CurrentDaemonStatus = `perl $Daemon status`;

$Self->Is(
    $CurrentDaemonStatus,
    $PreviousDaemonStatus,
    "Daemon has original state again.",
);

# Cleanup

# Delete test created calendar.
$Success = $DBObject->Do(
    SQL  => "DELETE FROM calendar WHERE id = ?",
    Bind => [ \$Calendar{CalendarID} ],
);
$Self->True(
    $Success,
    "CalendarID $Calendar{CalendarID} is deleted",
);

# Delete test created queue.
$Success = $DBObject->Do(
    SQL  => "DELETE FROM queue WHERE id = ?",
    Bind => [ \$QueueID ],
);
$Self->True(
    $Success,
    "QueueID $QueueID is deleted",
);

# Delete group-user relation.
$Success = $DBObject->Do(
    SQL  => "DELETE FROM group_user WHERE group_id = ?",
    Bind => [ \$GroupID ],
);
$Self->True(
    $Success,
    "Group-user relation for GroupID $GroupID is deleted",
);

# Delete test created group.
$Success = $DBObject->Do(
    SQL  => "DELETE FROM groups WHERE id = ?",
    Bind => [ \$GroupID ],
);
$Self->True(
    $Success,
    "GroupID $GroupID is deleted",
);

# Clean up async tasks.
@AllTasks = $SchedulerDBObject->TaskList();
for my $Task (@AllTasks) {
    my $Success = $SchedulerDBObject->TaskDelete(
        TaskID => $Task->{TaskID},
    );
    $Self->True(
        $Success,
        "TaskDelete - Removed scheduled task $Task->{TaskID}",
    );
}

1;
