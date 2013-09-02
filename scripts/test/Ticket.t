# --
# Ticket.t - ticket module testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use Kernel::System::UnitTest::Helper;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::Ticket;
use Kernel::System::Queue;
use Kernel::System::User;
use Kernel::System::PostMaster;
use Kernel::System::Type;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::State;

# create local objects
my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TypeObject    = Kernel::System::Type->new( %{$Self} );
my $ServiceObject = Kernel::System::Service->new( %{$Self} );
my $SLAObject     = Kernel::System::SLA->new( %{$Self} );
my $HelperObject  = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,
);
my $StateObject = Kernel::System::State->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# set fixed time
$HelperObject->FixedTimeSet();

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

my %Ticket = $TicketObject->TicketGet( TicketID => $TicketID );
$Self->Is(
    $Ticket{Title},
    'Some Ticket_Title',
    'TicketGet() (Title)',
);
$Self->Is(
    $Ticket{Queue},
    'Raw',
    'TicketGet() (Queue)',
);
$Self->Is(
    $Ticket{Priority},
    '3 normal',
    'TicketGet() (Priority)',
);
$Self->Is(
    $Ticket{State},
    'closed successful',
    'TicketGet() (State)',
);
$Self->Is(
    $Ticket{Owner},
    'root@localhost',
    'TicketGet() (Owner)',
);
$Self->Is(
    $Ticket{CreateBy},
    1,
    'TicketGet() (CreateBy)',
);
$Self->Is(
    $Ticket{ChangeBy},
    1,
    'TicketGet() (ChangeBy)',
);
$Self->Is(
    $Ticket{Title},
    'Some Ticket_Title',
    'TicketGet() (Title)',
);
$Self->Is(
    $Ticket{Responsible},
    'root@localhost',
    'TicketGet() (Responsible)',
);
$Self->Is(
    $Ticket{Lock},
    'unlock',
    'TicketGet() (Lock)',
);
$Self->Is(
    $Ticket{ServiceID},
    '',
    'TicketGet() (ServiceID)',
);
$Self->Is(
    $Ticket{SLAID},
    '',
    'TicketGet() (SLAID)',
);
$Self->Is(
    $Ticket{TypeID},
    '1',
    'TicketGet() (TypeID)',
);

my $TestUserLogin = $HelperObject->TestUserCreate(
    Groups => [ 'users', ],
);

my $TestUserID = $UserObject->UserLookup(
    UserLogin => $TestUserLogin,
);

my $TicketIDCreatedBy = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => $TestUserID,
);

my %CheckCreatedBy = $TicketObject->TicketGet(
    TicketID => $TicketIDCreatedBy,
    UserID   => $TestUserID,
);

$Self->Is(
    $CheckCreatedBy{ChangeBy},
    $TestUserID,
    'TicketGet() (ChangeBy - not system ID 1 user)',
);

$Self->Is(
    $CheckCreatedBy{CreateBy},
    $TestUserID,
    'TicketGet() (CreateBy - not system ID 1 user)',
);

$TicketObject->TicketOwnerSet(
    TicketID  => $TicketIDCreatedBy,
    NewUserID => $TestUserID,
    UserID    => 1,
);

%CheckCreatedBy = $TicketObject->TicketGet(
    TicketID => $TicketIDCreatedBy,
    UserID   => $TestUserID,
);

$Self->Is(
    $CheckCreatedBy{CreateBy},
    $TestUserID,
    'TicketGet() (CreateBy - still the same after OwnerSet)',
);

$Self->Is(
    $CheckCreatedBy{OwnerID},
    $TestUserID,
    'TicketOwnerSet()',
);

$Self->Is(
    $CheckCreatedBy{ChangeBy},
    1,
    'TicketOwnerSet() (ChangeBy - System ID 1 now)',
);

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID    => $TicketID,
    ArticleType => 'note-internal',
    SenderType  => 'agent',
    From =>
        'Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent <email@example.com>',
    To =>
        'Some Customer A Some Customer A Some Customer A Some Customer A Some Customer A Some Customer A  Some Customer ASome Customer A Some Customer A <customer-a@example.com>',
    Cc =>
        'Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B <customer-b@example.com>',
    ReplyTo =>
        'Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B Some Customer B <customer-b@example.com>',
    Subject =>
        'some short description some short description some short description some short description some short description some short description some short description some short description ',
    Body => (
        'the message text
Perl modules provide a range of features to help you avoid reinventing the wheel, and can be downloaded from CPAN ( http://www.cpan.org/ ). A number of popular modules are included with the Perl distribution itself.

Categories of modules range from text manipulation to network protocols to database integration to graphics. A categorized list of modules is also available from CPAN.

To learn how to install modules you download from CPAN, read perlmodinstall

To learn how to use a particular module, use perldoc Module::Name . Typically you will want to use Module::Name , which will then give you access to exported functions or an OO interface to the module.

perlfaq contains questions and answers related to many common tasks, and often provides suggestions for good CPAN modules to use.

perlmod describes Perl modules in general. perlmodlib lists the modules which came with your Perl installation.

If you feel the urge to write Perl modules, perlnewmod will give you good advice.
' x 200
    ),    # create a really big string by concatenating 200 times

    #    MessageID => '<asdasdasd.123@example.com>',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify => 1,    # if you don't want to send agent notifications
);

$Self->True(
    $ArticleID,
    'ArticleCreate()',
);

my %Article = $TicketObject->ArticleGet( ArticleID => $ArticleID );
$Self->Is(
    $Article{Title},
    'Some Ticket_Title',
    'ArticleGet()',
);
$Self->True(
    $Article{From} eq
        'Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent <email@example.com>',
    'ArticleGet()',
);

# ticket watch tests
my $Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketID,
    WatchUserID => 1,
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);
my $Unsubscribe = $TicketObject->TicketWatchUnsubscribe(
    TicketID    => $TicketID,
    WatchUserID => 1,
    UserID      => 1,
);
$Self->True(
    $Unsubscribe || 0,
    'TicketWatchUnsubscribe()',
);

# add new subscription (will be deleted by TicketDelete(), also check foreign keys)
$Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketID,
    WatchUserID => 1,
    UserID      => 1,
);
$Self->True(
    $Subscribe || 0,
    'TicketWatchSubscribe()',
);

my $TicketSearchTicketNumber = substr $Ticket{TicketNumber}, 0, 10;
my %TicketIDs = $TicketObject->TicketSearch(
    Result       => 'HASH',
    Limit        => 100,
    TicketNumber => [ $TicketSearchTicketNumber . '%', '%not exisiting%' ],
    UserID       => 1,
    Permission   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber as HASHREF)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result       => 'HASH',
    Limit        => 100,
    TicketNumber => $Ticket{TicketNumber},
    UserID       => 1,
    Permission   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result       => 'HASH',
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, '1234' ],
    UserID       => 1,
    Permission   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber[ARRAY])',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result     => 'HASH',
    Limit      => 100,
    Title      => $Ticket{Title},
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:Title)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result     => 'HASH',
    Limit      => 100,
    Title      => [ $Ticket{Title}, 'SomeTitleABC' ],
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:Title[ARRAY])',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result     => 'HASH',
    Limit      => 100,
    CustomerID => $Ticket{CustomerID},
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CustomerID)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result     => 'HASH',
    Limit      => 100,
    CustomerID => [ $Ticket{CustomerID}, 'LULU' ],
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CustomerID[ARRAY])',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result     => 'HASH',
    Limit      => 100,
    CustomerID => ['LULU'],
    UserID     => 1,
    Permission => 'rw',
);
$Self->False(
    scalar $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CustomerID[ARRAY])',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result            => 'HASH',
    Limit             => 100,
    CustomerUserLogin => $Ticket{CustomerUser},
    UserID            => 1,
    Permission        => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CustomerUser)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result            => 'HASH',
    Limit             => 100,
    CustomerUserLogin => [ $Ticket{CustomerUserID}, '1234' ],
    UserID            => 1,
    Permission        => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CustomerUser[ARRAY])',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result            => 'HASH',
    Limit             => 100,
    TicketNumber      => $Ticket{TicketNumber},
    Title             => $Ticket{Title},
    CustomerID        => $Ticket{CustomerID},
    CustomerUserLogin => $Ticket{CustomerUserID},
    UserID            => 1,
    Permission        => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,Title,CustomerID,CustomerUserID)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result            => 'HASH',
    Limit             => 100,
    TicketNumber      => [ $Ticket{TicketNumber}, 'ABC' ],
    Title             => [ $Ticket{Title}, '123' ],
    CustomerID        => [ $Ticket{CustomerID}, '1213421' ],
    CustomerUserLogin => [ $Ticket{CustomerUserID}, 'iadasd' ],
    UserID            => 1,
    Permission        => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,Title,CustomerID,CustomerUser[ARRAY])',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result       => 'HASH',
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, 'ABC' ],
    StateType    => 'Closed',
    UserID       => 1,
    Permission   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,StateType:Closed)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result       => 'HASH',
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, 'ABC' ],
    StateType    => 'Open',
    UserID       => 1,
    Permission   => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,StateType:Open)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result              => 'HASH',
    Limit               => 100,
    Body                => 'write perl modules',
    ConditionInline     => 1,
    ContentSearchPrefix => '*',
    ContentSearchSuffix => '*',
    StateType           => 'Closed',
    UserID              => 1,
    Permission          => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:Body,StateType:Closed)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result              => 'HASH',
    Limit               => 100,
    Body                => 'write perl modules',
    ConditionInline     => 1,
    ContentSearchPrefix => '*',
    ContentSearchSuffix => '*',
    StateType           => 'Open',
    UserID              => 1,
    Permission          => 'rw',
);
$Self->True(
    !$TicketIDs{$TicketID},
    'TicketSearch() (HASH:Body,StateType:Open)',
);

my $TicketMove = $TicketObject->MoveTicket(
    Queue              => 'Junk',
    TicketID           => $TicketID,
    SendNoNotification => 1,
    UserID             => 1,
);
$Self->True(
    $TicketMove,
    'MoveTicket()',
);

my $TicketState = $TicketObject->StateSet(
    State    => 'open',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $TicketState,
    'StateSet()',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result       => 'HASH',
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, 'ABC' ],
    StateType    => 'Open',
    UserID       => 1,
    Permission   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,StateType:Open)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result       => 'HASH',
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, 'ABC' ],
    StateType    => 'Closed',
    UserID       => 1,
    Permission   => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber,StateType:Closed)',
);

for my $Condition (
    '(Some&&Agent)',
    'Some&&Agent',
    '(Some+Agent)',
    ' (Some+Agent)',
    ' (Some+Agent)  ',
    'Some&&Agent',
    'Some+Agent',
    ' Some+Agent',
    'Some+Agent ',
    ' Some+Agent ',
    '(!SomeWordShouldNotFound||(Some+Agent))',
    '((Some+Agent)||(SomeAgentNotFound||AgentNotFound))',
    '"Some Agent Some"',
    '("Some Agent Some")',
    '!"Some Some Agent"',
    '(!"Some Some Agent")',
    )
{
    %TicketIDs = $TicketObject->TicketSearch(

        # result (required)
        Result => 'HASH',

        # result limit
        Limit               => 1000,
        From                => $Condition,
        ConditionInline     => 1,
        ContentSearchPrefix => '*',
        ContentSearchSuffix => '*',
        UserID              => 1,
        Permission          => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        "TicketSearch() (HASH:From,ConditionInline,From='$Condition')",
    );
}

for my $Condition (
    '(SomeNotFoundWord&&AgentNotFoundWord)',
    'SomeNotFoundWord||AgentNotFoundWord',
    ' SomeNotFoundWord||AgentNotFoundWord',
    'SomeNotFoundWord&&AgentNotFoundWord',
    'SomeNotFoundWord&&AgentNotFoundWord  ',
    '(SomeNotFoundWord AgentNotFoundWord)',
    'SomeNotFoundWord&&AgentNotFoundWord',
    '(SomeWordShouldNotFound||(!Some+!Agent))',
    '((SomeNotFound&&Agent)||(SomeAgentNotFound||AgentNotFound))',
    '!"Some Agent Some"',
    '(!"Some Agent Some")',
    '"Some Some Agent"',
    '("Some Some Agent")',
    )
{
    %TicketIDs = $TicketObject->TicketSearch(

        # result (required)
        Result => 'HASH',

        # result limit
        Limit               => 1000,
        From                => $Condition,
        ConditionInline     => 1,
        ContentSearchPrefix => '*',
        ContentSearchSuffix => '*',
        UserID              => 1,
        Permission          => 'rw',
    );
    $Self->True(
        ( !$TicketIDs{$TicketID} ),
        "TicketSearch() (HASH:From,ConditionInline,From='$Condition')",
    );
}

my $TicketPriority = $TicketObject->PrioritySet(
    Priority => '2 low',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $TicketPriority,
    'PrioritySet()',
);

# get ticket data
my %TicketData = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

# save current change_time
my $ChangeTime = $TicketData{Changed};

# wait 5 seconds
$HelperObject->FixedTimeAddSeconds(5);

my $TicketTitle = $TicketObject->TicketTitleUpdate(
    Title    => 'Some Title 1234567',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $TicketTitle,
    'TicketTitleUpdate()',
);

# get updated ticket data
%TicketData = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

# compare current change_time with old one
$Self->IsNot(
    $ChangeTime,
    $TicketData{Changed},
    'Change_time updated in TicketTitleUpdate()',
);

# get updated ticket data
%TicketData = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

# save current change_time
$ChangeTime = $TicketData{Changed};

# wait 5 seconds
$HelperObject->FixedTimeAddSeconds(5);

# set unlock timeout
my $UnlockTimeout = $TicketObject->TicketUnlockTimeoutUpdate(
    UnlockTimeout => $Self->{TimeObject}->SystemTime() + 10000,
    TicketID      => $TicketID,
    UserID        => 1,
);

$Self->True(
    $UnlockTimeout,
    'TicketUnlockTimeoutUpdate()',
);

# get updated ticket data
%TicketData = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

# compare current change_time with old one
$Self->IsNot(
    $ChangeTime,
    $TicketData{Changed},
    'Change_time updated in TicketUnlockTimeoutUpdate()',
);

# save current change_time
$ChangeTime = $TicketData{Changed};

# save current queue
my $CurrentQueueID = $TicketData{QueueID};

# wait 5 seconds
$HelperObject->FixedTimeAddSeconds(5);

my $NewQueue = $CurrentQueueID != 1 ? 1 : 2;

# set queue
my $TicketQueueSet = $TicketObject->TicketQueueSet(
    QueueID  => $NewQueue,
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketQueueSet,
    'TicketQueueSet()',
);

# get updated ticket data
%TicketData = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

# compare current change_time with old one
$Self->IsNot(
    $ChangeTime,
    $TicketData{Changed},
    'Change_time updated in TicketQueueSet()',
);

# restore queue
$TicketQueueSet = $TicketObject->TicketQueueSet(
    QueueID  => $CurrentQueueID,
    TicketID => $TicketID,
    UserID   => 1,
);

# save current change_time
$ChangeTime = $TicketData{Changed};

# save current type
my $CurrentTicketType = $TicketData{TypeID};

# wait 5 seconds
$HelperObject->FixedTimeAddSeconds(5);

# create a test type
my $TypeID = $TypeObject->TypeAdd(
    Name    => 'Unit Test New Type' . int rand 10000,
    ValidID => 1,
    UserID  => 1,
);

# set type
my $TicketTypeSet = $TicketObject->TicketTypeSet(
    TypeID   => $TypeID,
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketTypeSet,
    'TicketTypeSet()',
);

# get updated ticket data
%TicketData = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

# compare current change_time with old one
$Self->IsNot(
    $ChangeTime,
    $TicketData{Changed},
    'Change_time updated in TicketTypeSet()',
);

# restore type
$TicketTypeSet = $TicketObject->TicketTypeSet(
    TypeID   => $CurrentTicketType,
    TicketID => $TicketID,
    UserID   => 1,
);

# set as invalid the test type
$TypeObject->TypeUpdate(
    ID      => $TypeID,
    Name    => 'Unit Test New Type' . int rand 10000,
    ValidID => 2,
    UserID  => 1,
);

# create a test service
my $ServiceID = $ServiceObject->ServiceAdd(
    Name    => 'Unit Test New Service' . int rand 10000,
    ValidID => 1,
    Comment => 'Unit Test Comment',
    UserID  => 1,
);

# wait 1 seconds
$HelperObject->FixedTimeAddSeconds(1);

# set type
my $TicketServiceSet = $TicketObject->TicketServiceSet(
    ServiceID => $ServiceID,
    TicketID  => $TicketID,
    UserID    => 1,
);

$Self->True(
    $TicketServiceSet,
    'TicketServiceSet()',
);

# get updated ticket data
%TicketData = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

# compare current change_time with old one
$Self->IsNot(
    $ChangeTime,
    $TicketData{Changed},
    'Change_time updated in TicketServiceSet()',
);

# set as invalid the test service
$ServiceObject->ServiceUpdate(
    ServiceID => $ServiceID,
    Name      => 'Unit Test New Service' . int rand 10000,
    ValidID   => 2,
    UserID    => 1,
);

# save current change_time
$ChangeTime = $TicketData{Changed};

# wait 5 seconds
$HelperObject->FixedTimeAddSeconds(5);

my $TicketEscalationIndexBuild = $TicketObject->TicketEscalationIndexBuild(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketEscalationIndexBuild,
    'TicketEscalationIndexBuild()',
);

# get updated ticket data
%TicketData = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

# compare current change_time with old one
$Self->IsNot(
    $ChangeTime,
    $TicketData{Changed},
    'Change_time updated in TicketEscalationIndexBuild()',
);

# save current change_time
$ChangeTime = $TicketData{Changed};

# create a test SLA
my $SLAID = $SLAObject->SLAAdd(
    Name    => 'Unit Test New SLA' . int rand 10000,
    ValidID => 1,
    Comment => 'Unit Test Comment',
    UserID  => 1,
);

# wait 5 seconds
$HelperObject->FixedTimeAddSeconds(5);

# set SLA
my $TicketSLASet = $TicketObject->TicketSLASet(
    SLAID    => $SLAID,
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketSLASet,
    'TicketSLASet()',
);

# get updated ticket data
%TicketData = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

# compare current change_time with old one
$Self->IsNot(
    $ChangeTime,
    $TicketData{Changed},
    'Change_time updated in TicketSLASet()',
);

# set as invalid the test SLA
$SLAObject->SLAUpdate(
    SLAID   => $SLAID,
    Name    => 'Unit Test New SLA' . int rand 10000,
    ValidID => 1,
    Comment => 'Unit Test Comment',
    UserID  => 1,
);

my $TicketLock = $TicketObject->LockSet(
    Lock               => 'lock',
    TicketID           => $TicketID,
    SendNoNotification => 1,
    UserID             => 1,
);
$Self->True(
    $TicketLock,
    'LockSet()',
);

# Test CreatedUserIDs
%TicketIDs = $TicketObject->TicketSearch(
    Result         => 'HASH',
    Limit          => 100,
    CreatedUserIDs => [ 1, 455, 32 ],
    UserID         => 1,
    Permission     => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedUserIDs[Array])',
);

# Test CreatedPriorities
%TicketIDs = $TicketObject->TicketSearch(
    Result            => 'HASH',
    Limit             => 100,
    CreatedPriorities => [ '2 low', '3 normal' ],
    UserID            => 1,
    Permission        => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedPriorities[Array])',
);

# Test CreatedPriorityIDs
%TicketIDs = $TicketObject->TicketSearch(
    Result             => 'HASH',
    Limit              => 100,
    CreatedPriorityIDs => [ 2, 3 ],
    UserID             => 1,
    Permission         => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedPriorityIDs[Array])',
);

# Test CreatedStates
%TicketIDs = $TicketObject->TicketSearch(
    Result        => 'HASH',
    Limit         => 100,
    CreatedStates => ['closed successful'],
    UserID        => 1,
    Permission    => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedStates[Array])',
);

# Test CreatedStateIDs
%TicketIDs = $TicketObject->TicketSearch(
    Result          => 'HASH',
    Limit           => 100,
    CreatedStateIDs => [2],
    UserID          => 1,
    Permission      => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedStateIDs[Array])',
);

# Test CreatedQueues
%TicketIDs = $TicketObject->TicketSearch(
    Result        => 'HASH',
    Limit         => 100,
    CreatedQueues => ['Raw'],
    UserID        => 1,
    Permission    => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedQueues[Array])',
);

# Test CreatedQueueIDs
%TicketIDs = $TicketObject->TicketSearch(
    Result          => 'HASH',
    Limit           => 100,
    CreatedQueueIDs => [ 2, 3 ],
    UserID          => 1,
    Permission      => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:CreatedQueueIDs[Array])',
);

# Test TicketCreateTimeNewerMinutes
%TicketIDs = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    TicketCreateTimeNewerMinutes => 60,
    UserID                       => 1,
    Permission                   => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeNewerMinutes => 60)',
);

# Test ArticleCreateTimeNewerMinutes
%TicketIDs = $TicketObject->TicketSearch(
    Result                        => 'HASH',
    Limit                         => 100,
    ArticleCreateTimeNewerMinutes => 60,
    UserID                        => 1,
    Permission                    => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:ArticleCreateTimeNewerMinutes => 60)',
);

# Test TicketCreateOlderMinutes
%TicketIDs = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    TicketCreateTimeOlderMinutes => 60,
    UserID                       => 1,
    Permission                   => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeOlderMinutes => 60)',
);

# Test ArticleCreateOlderMinutes
%TicketIDs = $TicketObject->TicketSearch(
    Result                        => 'HASH',
    Limit                         => 100,
    ArticleCreateTimeOlderMinutes => 60,
    UserID                        => 1,
    Permission                    => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:ArticleCreateTimeOlderMinutes => 60)',
);

# Test TicketCreateTimeNewerDate
my $SystemTime = $Self->{TimeObject}->SystemTime();
%TicketIDs = $TicketObject->TicketSearch(
    Result                    => 'HASH',
    Limit                     => 100,
    TicketCreateTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime - ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeNewerDate => 60)',
);

# Test ArticleCreateTimeNewerDate
$SystemTime = $Self->{TimeObject}->SystemTime();
%TicketIDs  = $TicketObject->TicketSearch(
    Result                     => 'HASH',
    Limit                      => 100,
    ArticleCreateTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime - ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:ArticleCreateTimeNewerDate => 60)',
);

# Test TicketCreateOlderDate
%TicketIDs = $TicketObject->TicketSearch(
    Result                    => 'HASH',
    Limit                     => 100,
    TicketCreateTimeOlderDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime - ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeOlderDate => 60)',
);

# Test ArticleCreateOlderDate
%TicketIDs = $TicketObject->TicketSearch(
    Result                     => 'HASH',
    Limit                      => 100,
    ArticleCreateTimeOlderDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime - ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:ArticleCreateTimeOlderDate => 60)',
);

# Test TicketCloseTimeNewerDate
%TicketIDs = $TicketObject->TicketSearch(
    Result                   => 'HASH',
    Limit                    => 100,
    TicketCloseTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime - ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCloseTimeNewerDate => 60)',
);

# Test TicketCloseOlderDate
%TicketIDs = $TicketObject->TicketSearch(
    Result                   => 'HASH',
    Limit                    => 100,
    TicketCloseTimeOlderDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime - ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCloseTimeOlderDate => 60)',
);

my %Ticket2 = $TicketObject->TicketGet( TicketID => $TicketID );
$Self->Is(
    $Ticket2{Title},
    'Some Title 1234567',
    'TicketGet() (Title)',
);
$Self->Is(
    $Ticket2{Queue},
    'Junk',
    'TicketGet() (Queue)',
);
$Self->Is(
    $Ticket2{Priority},
    '2 low',
    'TicketGet() (Priority)',
);
$Self->Is(
    $Ticket2{State},
    'open',
    'TicketGet() (State)',
);
$Self->Is(
    $Ticket2{Lock},
    'lock',
    'TicketGet() (Lock)',
);

%Article = $TicketObject->ArticleGet( ArticleID => $ArticleID );
$Self->Is(
    $Article{Title},
    'Some Title 1234567',
    'ArticleGet() (Title)',
);
$Self->Is(
    $Article{Queue},
    'Junk',
    'ArticleGet() (Queue)',
);
$Self->Is(
    $Article{Priority},
    '2 low',
    'ArticleGet() (Priority)',
);
$Self->Is(
    $Article{State},
    'open',
    'ArticleGet() (State)',
);
$Self->Is(
    $Article{Owner},
    'root@localhost',
    'ArticleGet() (Owner)',
);
$Self->Is(
    $Article{Responsible},
    'root@localhost',
    'ArticleGet() (Responsible)',
);
$Self->Is(
    $Article{Lock},
    'lock',
    'ArticleGet() (Lock)',
);

#for ( 1 .. 16 ) {
#    $Self->Is(
#        $Article{ 'TicketFreeKey' . $_ },
#        'Hans_' . $_,
#        "ArticleGet() (TicketFreeKey$_)",
#    );
#    $Self->Is(
#        $Article{ 'TicketFreeText' . $_ },
#        'Max_' . $_,
#        "ArticleGet() (TicketFreeText$_)",
#    );
#}

my @MoveQueueList = $TicketObject->MoveQueueList(
    TicketID => $TicketID,
    Type     => 'Name',
);

$Self->Is(
    $MoveQueueList[0],
    'Raw',
    'MoveQueueList() (Raw)',
);
$Self->Is(
    $MoveQueueList[$#MoveQueueList],
    'Junk',
    'MoveQueueList() (Junk)',
);

my $TicketAccountTime = $TicketObject->TicketAccountTime(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    TimeUnit  => '4.5',
    UserID    => 1,
);

$Self->True(
    $TicketAccountTime,
    'TicketAccountTime() 1',
);

my $TicketAccountTime2 = $TicketObject->TicketAccountTime(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    TimeUnit  => '4123.53',
    UserID    => 1,
);

$Self->True(
    $TicketAccountTime2,
    'TicketAccountTime() 2',
);

my $TicketAccountTime3 = $TicketObject->TicketAccountTime(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    TimeUnit  => '4,53',
    UserID    => 1,
);

$Self->True(
    $TicketAccountTime3,
    'TicketAccountTime() 3',
);

my $AccountedTime = $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID );

$Self->Is(
    $AccountedTime,
    4132.56,
    'TicketAccountedTimeGet()',
);

my $AccountedTime2 = $TicketObject->ArticleAccountedTimeGet(
    ArticleID => $ArticleID,
);

$Self->Is(
    $AccountedTime2,
    4132.56,
    'ArticleAccountedTimeGet()',
);

my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
    SystemTime => $Self->{TimeObject}->SystemTime(),
);

my ( $StopSec, $StopMin, $StopHour, $StopDay, $StopMonth, $StopYear )
    = $Self->{TimeObject}->SystemTime2Date(
    SystemTime => $Self->{TimeObject}->SystemTime() - 60 * 60 * 24,
    );

my %TicketStatus = $TicketObject->HistoryTicketStatusGet(
    StopYear   => $Year,
    StopMonth  => $Month,
    StopDay    => $Day,
    StartYear  => $StopYear,
    StartMonth => $StopMonth,
    StartDay   => $StopDay,
);

if ( $TicketStatus{$TicketID} ) {
    my %TicketHistory = %{ $TicketStatus{$TicketID} };
    $Self->Is(
        $TicketHistory{TicketNumber},
        $Ticket{TicketNumber},
        "HistoryTicketStatusGet() (TicketNumber)",
    );
    $Self->Is(
        $TicketHistory{TicketID},
        $TicketID,
        "HistoryTicketStatusGet() (TicketID)",
    );
    $Self->Is(
        $TicketHistory{CreateUserID},
        1,
        "HistoryTicketStatusGet() (CreateUserID)",
    );
    $Self->Is(
        $TicketHistory{Queue},
        'Junk',
        "HistoryTicketStatusGet() (Queue)",
    );
    $Self->Is(
        $TicketHistory{CreateQueue},
        'Raw',
        "HistoryTicketStatusGet() (CreateQueue)",
    );
    $Self->Is(
        $TicketHistory{State},
        'open',
        "HistoryTicketStatusGet() (State)",
    );
    $Self->Is(
        $TicketHistory{CreateState},
        'closed successful',
        "HistoryTicketStatusGet() (CreateState)",
    );
    $Self->Is(
        $TicketHistory{Priority},
        '2 low',
        "HistoryTicketStatusGet() (Priority)",
    );
    $Self->Is(
        $TicketHistory{CreatePriority},
        '3 normal',
        "HistoryTicketStatusGet() (CreatePriority)",
    );

    #    for ( 1 .. 16 ) {
    #        $Self->Is(
    #            $TicketHistory{ 'TicketFreeKey' . $_ },
    #            'Hans_' . $_,
    #            "HistoryTicketStatusGet() (TicketFreeKey$_)",
    #        );
    #        $Self->Is(
    #            $TicketHistory{ 'TicketFreeText' . $_ },
    #            'Max_' . $_,
    #            "HistoryTicketStatusGet() (TicketFreeText$_)",
    #        );
    #    }
}
else {
    $Self->True(
        0,
        'HistoryTicketStatusGet()',
    );
}

my $Delete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Delete,
    'TicketDelete()',
);

my $DeleteCheck = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->False(
    $DeleteCheck,
    'TicketDelete() worked',
);

my $CustomerNo = '42' . int rand 1_000_000;

# ticket search sort/order test
my $TicketIDSortOrder1 = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket sort/order by tests',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

my %TicketCreated = $TicketObject->TicketGet(
    TicketID => $TicketIDSortOrder1,
    UserID   => 1,
);

# wait 5 seconds
$HelperObject->FixedTimeAddSeconds(2);

my $TicketIDSortOrder2 = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket sort/order by tests2',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# wait 5 seconds
$HelperObject->FixedTimeAddSeconds(2);

my $Success = $TicketObject->TicketStateSet(
    State    => 'open',
    TicketID => $TicketIDSortOrder1,
    UserID   => 1,
);

my %TicketUpdated = $TicketObject->TicketGet(
    TicketID => $TicketIDSortOrder1,
    UserID   => 1,
);

$Self->IsNot(
    $TicketCreated{Changed},
    $TicketUpdated{Changed},
    'TicketUpdated for sort - change time was updated'
        . " $TicketCreated{Changed} ne $TicketUpdated{Changed}",
);

# find newest ticket by priority, age
my @TicketIDsSortOrder = $TicketObject->TicketSearch(
    Result       => 'ARRAY',
    Title        => '%sort/order by test%',
    Queues       => ['Raw'],
    CustomerID   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OrderBy      => [ 'Down', 'Up' ],
    SortBy       => [ 'Priority', 'Age' ],
    UserID       => 1,
    Limit        => 1,
);

$Self->Is(
    $TicketIDsSortOrder[0],
    $TicketIDSortOrder1,
    'TicketTicketSearch() - ticket sort/order by (Priority (Down), Age (Up))',
);

# find oldest ticket by priority, age
@TicketIDsSortOrder = $TicketObject->TicketSearch(
    Result       => 'ARRAY',
    Title        => '%sort/order by test%',
    Queues       => ['Raw'],
    CustomerID   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OrderBy      => [ 'Down', 'Down' ],
    SortBy       => [ 'Priority', 'Age' ],
    UserID       => 1,
    Limit        => 1,
);
$Self->Is(
    $TicketIDsSortOrder[0],
    $TicketIDSortOrder2,
    'TicketTicketSearch() - ticket sort/order by (Priority (Down), Age (Down))',
);

# find last modified ticket by changed time
@TicketIDsSortOrder = $TicketObject->TicketSearch(
    Result       => 'ARRAY',
    Title        => '%sort/order by test%',
    Queues       => ['Raw'],
    CustomerID   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OrderBy      => [ 'Down', ],
    SortBy       => ['Changed'],
    UserID       => 1,
    Limit        => 1,
);
$Self->Is(
    $TicketIDsSortOrder[0],
    $TicketIDSortOrder1,
    'TicketTicketSearch() - ticket sort/order by (Changed (Down))'
        . "$TicketIDsSortOrder[0] instead of $TicketIDSortOrder1",
);

# find oldest modified by changed time
@TicketIDsSortOrder = $TicketObject->TicketSearch(
    Result       => 'ARRAY',
    Title        => '%sort/order by test%',
    Queues       => ['Raw'],
    CustomerID   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OrderBy      => [ 'Up', ],
    SortBy       => [ 'Changed', ],
    UserID       => 1,
    Limit        => 1,
);
$Self->Is(
    $TicketIDsSortOrder[0],
    $TicketIDSortOrder2,
    'TicketTicketSearch() - ticket sort/order by (Changed (Up)))'
        . "$TicketIDsSortOrder[0]  instead of $TicketIDSortOrder2",
);

my $TicketIDSortOrder3 = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket sort/order by tests2',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '4 high',
    State        => 'new',
    CustomerNo   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# wait 2 seconds
$HelperObject->FixedTimeAddSeconds(2);

my $TicketIDSortOrder4 = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket sort/order by tests2',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '4 high',
    State        => 'new',
    CustomerNo   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# find oldest ticket by priority, age
@TicketIDsSortOrder = $TicketObject->TicketSearch(
    Result       => 'ARRAY',
    Title        => '%sort/order by test%',
    Queues       => ['Raw'],
    CustomerID   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OrderBy      => [ 'Down', 'Down' ],
    SortBy       => [ 'Priority', 'Age' ],
    UserID       => 1,
    Limit        => 1,
);
$Self->Is(
    $TicketIDsSortOrder[0],
    $TicketIDSortOrder4,
    'TicketTicketSearch() - ticket sort/order by (Priority (Down), Age (Down))',
);

# find oldest ticket by priority, age
@TicketIDsSortOrder = $TicketObject->TicketSearch(
    Result       => 'ARRAY',
    Title        => '%sort/order by test%',
    Queues       => ['Raw'],
    CustomerID   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OrderBy      => [ 'Up', 'Down' ],
    SortBy       => [ 'Priority', 'Age' ],
    UserID       => 1,
    Limit        => 1,
);
$Self->Is(
    $TicketIDsSortOrder[0],
    $TicketIDSortOrder2,
    'TicketTicketSearch() - ticket sort/order by (Priority (Up), Age (Down))',
);

# find newest ticket
@TicketIDsSortOrder = $TicketObject->TicketSearch(
    Result       => 'ARRAY',
    Title        => '%sort/order by test%',
    Queues       => ['Raw'],
    CustomerID   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OrderBy      => 'Down',
    SortBy       => 'Age',
    UserID       => 1,
    Limit        => 1,
);
$Self->Is(
    $TicketIDsSortOrder[0],
    $TicketIDSortOrder4,
    'TicketTicketSearch() - ticket sort/order by (Age (Down))',
);

# find oldest ticket
@TicketIDsSortOrder = $TicketObject->TicketSearch(
    Result       => 'ARRAY',
    Title        => '%sort/order by test%',
    Queues       => ['Raw'],
    CustomerID   => $CustomerNo,
    CustomerUser => 'customer@example.com',
    OrderBy      => 'Up',
    SortBy       => 'Age',
    UserID       => 1,
    Limit        => 1,
);
$Self->Is(
    $TicketIDsSortOrder[0],
    $TicketIDSortOrder1,
    'TicketTicketSearch() - ticket sort/order by (Age (Up))',
);

for my $TicketIDDelete (
    $TicketIDSortOrder1, $TicketIDSortOrder2, $TicketIDSortOrder3,
    $TicketIDSortOrder4
    )
{
    $Self->True(
        $TicketObject->TicketDelete(
            TicketID => $TicketIDDelete,
            UserID   => 1,
        ),
        "TicketDelete()",
    );
}

# ---
# avoid StateType and StateTypeID problems in TicketSearch()
# ---

my %StateTypeList = $StateObject->StateTypeList(
    UserID => 1,
);

# you need a hash with the state as key and the related StateType and StateTypeID as
# reference
my %StateAsKeyAndStateTypeAsValue;
for my $StateTypeID ( sort keys %StateTypeList ) {
    my @List = $StateObject->StateGetStatesByType(
        StateType => [ $StateTypeList{$StateTypeID} ],
        Result    => 'Name',                             # HASH|ID|Name
    );
    for my $Index (@List) {
        $StateAsKeyAndStateTypeAsValue{$Index}->{Name} = $StateTypeList{$StateTypeID};
        $StateAsKeyAndStateTypeAsValue{$Index}->{ID}   = $StateTypeID;
    }
}

# to be sure that you have a result ticket create one
$TicketID = $TicketObject->TicketCreate(
    Title        => 'StateTypeTest',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

my %StateList = $StateObject->StateList( UserID => 1 );

# now check every possible state
for my $State ( values %StateList ) {
    $TicketObject->StateSet(
        State              => $State,
        TicketID           => $TicketID,
        SendNoNotification => 1,
        UserID             => 1,
    );

    my @TicketIDs = $TicketObject->TicketSearch(
        Result       => 'ARRAY',
        Title        => '%StateTypeTest%',
        Queues       => ['Raw'],
        StateTypeIDs => [ $StateAsKeyAndStateTypeAsValue{$State}->{ID} ],
        UserID       => 1,
    );

    my @TicketIDsType = $TicketObject->TicketSearch(
        Result    => 'ARRAY',
        Title     => '%StateTypeTest%',
        Queues    => ['Raw'],
        StateType => [ $StateAsKeyAndStateTypeAsValue{$State}->{Name} ],
        UserID    => 1,
    );

    if ( $TicketIDs[0] ) {
        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketIDs[0],
            UserID   => 1,
        );
    }

    # if there is no result the StateTypeID hasn't worked
    # Test if there is a result, if I use StateTypeID $StateAsKeyAndStateTypeAsValue{$State}->{ID}
    $Self->True(
        $TicketIDs[0],
        "TicketSearch() - StateTypeID - found ticket",
    );

# if it is not equal then there is in the using of StateType or StateTypeID an error
# check if you get the same result if you use the StateType attribute or the StateTypeIDs attribute.
# State($State) StateType($StateAsKeyAndStateTypeAsValue{$State}->{Name}) and StateTypeIDs($StateAsKeyAndStateTypeAsValue{$State}->{ID})
    $Self->Is(
        scalar @TicketIDs,
        scalar @TicketIDsType,
        "TicketSearch() - StateType",
    );
}

my %TicketPending = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->Is(
    $TicketPending{UntilTime},
    '0',
    "TicketPendingTimeSet() - Pending Time - not set",
);

my $PendingTimeSet = $TicketObject->TicketPendingTimeSet(
    TicketID => $TicketID,
    UserID   => 1,
    Year     => '2003',
    Month    => '08',
    Day      => '14',
    Hour     => '22',
    Minute   => '05',
);

$Self->True(
    $PendingTimeSet,
    "TicketPendingTimeSet() - Pending Time - set",
);

%TicketPending = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

my $PendingUntilTime = $Self->{TimeObject}->Date2SystemTime(
    Year   => '2003',
    Month  => '08',
    Day    => '14',
    Hour   => '22',
    Minute => '05',
    Second => '00',
);

$PendingUntilTime = $Self->{TimeObject}->SystemTime() - $PendingUntilTime;

$Self->Is(
    $TicketPending{UntilTime},
    '-' . $PendingUntilTime,
    "TicketPendingTimeSet() - Pending Time - read back",
);

$PendingTimeSet = $TicketObject->TicketPendingTimeSet(
    TicketID => $TicketID,
    UserID   => 1,
    Year     => '0',
    Month    => '0',
    Day      => '0',
    Hour     => '0',
    Minute   => '0',
);

$Self->True(
    $PendingTimeSet,
    "TicketPendingTimeSet() - Pending Time - reset",
);

%TicketPending = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->Is(
    $TicketPending{UntilTime},
    '0',
    "TicketPendingTimeSet() - Pending Time - not set",
);

$PendingTimeSet = $TicketObject->TicketPendingTimeSet(
    TicketID => $TicketID,
    UserID   => 1,
    String   => '2003-09-14 22:05:00',
);

$Self->True(
    $PendingTimeSet,
    "TicketPendingTimeSet() - Pending Time - set string",
);

%TicketPending = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

$PendingUntilTime = $Self->{TimeObject}->TimeStamp2SystemTime(
    String => '2003-09-14 22:05:00',
);

$PendingUntilTime = $Self->{TimeObject}->SystemTime() - $PendingUntilTime;

$Self->Is(
    $TicketPending{UntilTime},
    '-' . $PendingUntilTime,
    "TicketPendingTimeSet() - Pending Time - read back",
);

$PendingTimeSet = $TicketObject->TicketPendingTimeSet(
    TicketID => $TicketID,
    UserID   => 1,
    String   => '0000-00-00 00:00:00',
);

$Self->True(
    $PendingTimeSet,
    "TicketPendingTimeSet() - Pending Time - reset string",
);

%TicketPending = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->Is(
    $TicketPending{UntilTime},
    '0',
    "TicketPendingTimeSet() - Pending Time - not set",
);

$PendingTimeSet = $TicketObject->TicketPendingTimeSet(
    TicketID => $TicketID,
    UserID   => 1,
    String   => '2003-09-14 22:05:00',
);

$Self->True(
    $PendingTimeSet,
    "TicketPendingTimeSet() - Pending Time - set string",
);

my $TicketStateUpdate = $TicketObject->TicketStateSet(
    TicketID => $TicketID,
    UserID   => 1,
    State    => 'pending reminder',
);

%TicketPending = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketPending{UntilTime},
    "TicketPendingTimeSet() - Set to pending - time should still be there",
);

$TicketStateUpdate = $TicketObject->TicketStateSet(
    TicketID => $TicketID,
    UserID   => 1,
    State    => 'new',
);

%TicketPending = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->Is(
    $TicketPending{UntilTime},
    '0',
    "TicketPendingTimeSet() - Set to new - Pending Time not set",
);

# check that searches with NewerDate in the future are not executed
$HelperObject->FixedTimeAddSeconds( -60 * 60 );

# Test TicketCreateTimeNewerDate (future date)
$SystemTime = $Self->{TimeObject}->SystemTime();
%TicketIDs  = $TicketObject->TicketSearch(
    Result                    => 'HASH',
    Limit                     => 100,
    TicketCreateTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime + ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeNewerDate => -60)',
);

# Test ArticleCreateTimeNewerDate (future date)
$SystemTime = $Self->{TimeObject}->SystemTime();
%TicketIDs  = $TicketObject->TicketSearch(
    Result                     => 'HASH',
    Limit                      => 100,
    ArticleCreateTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime + ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:ArticleCreateTimeNewerDate => -60)',
);

# Test TicketCloseTimeNewerDate (future date)
%TicketIDs = $TicketObject->TicketSearch(
    Result                   => 'HASH',
    Limit                    => 100,
    TicketCloseTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $SystemTime + ( 60 * 60 ),
    ),
    UserID     => 1,
    Permission => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCloseTimeNewerDate => -60)',
);

# the ticket is no longer needed
$TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

# tests for searching StateTypes that might not have states
# this should return an empty list rather then a big SQL error
# the problem is, we can't really test if there is an SQL error or not
# ticketsearch returns an empty list anyway

my @NewStates = $StateObject->StateGetStatesByType(
    StateType => ['new'],
    Result    => 'ID',
);

# make sure we dont have valid states for state type new
for my $NewStateID (@NewStates) {
    my %State = $StateObject->StateGet( ID => $NewStateID, );
    $StateObject->StateUpdate(
        %State,
        ValidID => 2,
        UserID  => 1,
    );
}

my @TicketIDs = $TicketObject->TicketSearch(
    Result       => 'LIST',
    Limit        => 100,
    TicketNumber => [ $Ticket{TicketNumber}, 'ABC' ],
    StateType    => 'New',
    UserID       => 1,
    Permission   => 'rw',
);
$Self->False(
    $TicketIDs[0],
    'TicketSearch() (LIST:TicketNumber,StateType:new (no valid states of state type new)',
);

# activate states again
for my $NewStateID (@NewStates) {
    my %State = $StateObject->StateGet( ID => $NewStateID, );
    $StateObject->StateUpdate(
        %State,
        ValidID => 1,
        UserID  => 1,
    );
}

# check response of ticket search for invalid timestamps
for my $SearchParam (qw(ArticleCreateTime TicketCreateTime TicketPendingTime)) {
    for my $ParamOption (qw(OlderDate NewerDate)) {
        $TicketObject->TicketSearch(
            $SearchParam . $ParamOption => '2000-02-31 00:00:00',
            UserID                      => 1,
        );
        my $ErrorMessage = $Self->{LogObject}->GetLogEntry(
            Type => 'error',
            What => 'Message',
        );
        $Self->Is(
            $ErrorMessage,
            "Search not executed due to invalid time '2000-02-31 00:00:00'!",
            "TicketSearch() (Handling invalid timestamp in '$SearchParam$ParamOption')",
        );
    }
}

1;
