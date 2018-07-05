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

use Kernel::System::VariableCheck qw(IsHashRefWithData);

my $QueueObject          = $Kernel::OM->Get('Kernel::System::Queue');
my $ServiceObject        = $Kernel::OM->Get('Kernel::System::Service');
my $SLAObject            = $Kernel::OM->Get('Kernel::System::SLA');
my $StateObject          = $Kernel::OM->Get('Kernel::System::State');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );
my $DateTimeObject       = $Kernel::OM->Create('Kernel::System::DateTime');
my $TypeObject           = $Kernel::OM->Get('Kernel::System::Type');
my $UserObject           = $Kernel::OM->Get('Kernel::System::User');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# set fixed time
$Helper->FixedTimeSet();

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    Extended => 1,
);
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

my $DefaultTicketType = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Type::Default');
$Self->Is(
    $Ticket{TypeID},
    $TypeObject->TypeLookup( Type => $DefaultTicketType ),
    'TicketGet() (TypeID)',
);
$Self->Is(
    $Ticket{Closed},
    $Ticket{Created},
    'Ticket created as closed as Close Time = Creation Time',
);

my $TestUserLogin = $Helper->TestUserCreate(
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
    CustomerUser => 'unittest@otrs.com',
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

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
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

    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,                                   # if you don't want to send agent notifications
);

$Self->True(
    $ArticleID,
    'ArticleCreate()'
);

$Self->Is(
    scalar $ArticleObject->ArticleList( TicketID => $TicketID ),
    1,
    'ArticleCount',
);

my %Article = $ArticleBackendObject->ArticleGet(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
);
$Self->True(
    $Article{From} eq
        'Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent Some Agent <email@example.com>',
    'ArticleGet()',
);

for my $Key (qw( Body Subject From To ReplyTo )) {
    my $Success = $ArticleBackendObject->ArticleUpdate(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        Key       => $Key,
        Value     => "New $Key",
        UserID    => 1,
    );
    $Self->True(
        $Success,
        'ArticleUpdate()'
    );

    my %Article2 = $ArticleBackendObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );
    $Self->Is(
        $Article2{$Key},
        "New $Key",
        'ArticleUpdate()'
    );

    # set old value
    $Success = $ArticleBackendObject->ArticleUpdate(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
        Key       => $Key,
        Value     => $Article{$Key},
        UserID    => 1,
    );
}

$ArticleObject->ArticleSearchIndexBuild(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    UserID    => 1,
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

# Test TicketNumber search condition '0', expecting no results, see bug#11461.
%TicketIDs = $TicketObject->TicketSearch(
    Result       => 'HASH',
    Limit        => 100,
    TicketNumber => 0,
    UserID       => 1,
    Permission   => 'rw',
);
$Self->True(
    !$TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketNumber eq 0)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result     => 'HASH',
    Limit      => 100,
    TicketID   => $TicketID,
    UserID     => 1,
    Permission => 'rw',
);

$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketID)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result     => 'HASH',
    Limit      => 100,
    TicketID   => [ $TicketID, 42 ],
    UserID     => 1,
    Permission => 'rw',
);

$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketID as ARRAYREF)',
);

my $Count = $TicketObject->TicketSearch(
    Result       => 'COUNT',
    TicketNumber => $Ticket{TicketNumber},
    UserID       => 1,
    Permission   => 'rw',
);
$Self->Is(
    $Count,
    1,
    'TicketSearch() (COUNT:TicketNumber)',
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
    MIMEBase_Body       => 'write perl modules',
    ConditionInline     => 1,
    ContentSearchPrefix => '*',
    ContentSearchSuffix => '*',
    StateType           => 'Closed',
    UserID              => 1,
    Permission          => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:MIMEBase_Body,StateType:Closed)',
);

%TicketIDs = $TicketObject->TicketSearch(
    Result              => 'HASH',
    Limit               => 100,
    MIMEBase_Body       => 'write perl modules',
    ConditionInline     => 1,
    ContentSearchPrefix => '*',
    ContentSearchSuffix => '*',
    StateType           => 'Open',
    UserID              => 1,
    Permission          => 'rw',
);
$Self->True(
    !$TicketIDs{$TicketID},
    'TicketSearch() (HASH:MIMEBase_,StateType:Open)',
);

$TicketObject->MoveTicket(
    Queue              => 'Junk',
    TicketID           => $TicketID,
    SendNoNotification => 1,
    UserID             => 1,
);

$TicketObject->MoveTicket(
    Queue              => 'Raw',
    TicketID           => $TicketID,
    SendNoNotification => 1,
    UserID             => 1,
);

my %HD = $TicketObject->HistoryTicketGet(
    StopYear  => 4000,
    StopMonth => 1,
    StopDay   => 1,
    TicketID  => $TicketID,
    Force     => 1,
);
my $QueueLookupID = $QueueObject->QueueLookup( Queue => $HD{Queue} );
$Self->Is(
    $QueueLookupID,
    $HD{QueueID},
    'HistoryTicketGet() Check history queue',
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
        MIMEBase_From       => $Condition,
        ConditionInline     => 1,
        ContentSearchPrefix => '*',
        ContentSearchSuffix => '*',
        UserID              => 1,
        Permission          => 'rw',
    );
    $Self->True(
        $TicketIDs{$TicketID},
        "TicketSearch() (HASH:MIMEBase_From,ConditionInline,MIMEBase_From='$Condition')",
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
        MIMEBase_From       => $Condition,
        ConditionInline     => 1,
        ContentSearchPrefix => '*',
        ContentSearchSuffix => '*',
        UserID              => 1,
        Permission          => 'rw',
    );

    $Self->True(
        ( !$TicketIDs{$TicketID} ),
        "TicketSearch() (HASH:MIMEBase_From,ConditionInline,MIMEBase_From='$Condition')",
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
$Helper->FixedTimeAddSeconds(5);

my $TicketTitle = $TicketObject->TicketTitleUpdate(
    Title => 'Very long title 01234567890123456789012345678901234567890123456789'
        . '0123456789012345678901234567890123456789012345678901234567890123456789'
        . '0123456789012345678901234567890123456789012345678901234567890123456789'
        . '0123456789012345678901234567890123456789',
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

# check if we have a Ticket Title Update history record
my @HistoryLines = $TicketObject->HistoryGet(
    TicketID => $TicketID,
    UserID   => 1,
);
my $HistoryItem = pop @HistoryLines;
$Self->Is(
    $HistoryItem->{HistoryType},
    'TitleUpdate',
    "TicketTitleUpdate - found HistoryItem",
);

$Self->Is(
    $HistoryItem->{Name},
    '%%Some Ticket_Title%%Very long title 0123456789012345678901234567890123...',
    "TicketTitleUpdate - Found new title",
);

# get updated ticket data
%TicketData = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

# save current change_time
$ChangeTime = $TicketData{Changed};

# wait 5 seconds
$Helper->FixedTimeAddSeconds(5);

# set unlock timeout
my $UnlockTimeout = $TicketObject->TicketUnlockTimeoutUpdate(
    UnlockTimeout => $DateTimeObject->ToEpoch() + 10000,
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
$Helper->FixedTimeAddSeconds(5);

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
$Helper->FixedTimeAddSeconds(5);

# create a test type
my $TypeID = $TypeObject->TypeAdd(
    Name    => 'Type' . $Helper->GetRandomID(),
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
    Name    => 'Type' . $Helper->GetRandomID(),
    ValidID => 2,
    UserID  => 1,
);

# create a test service
my $ServiceID = $ServiceObject->ServiceAdd(
    Name    => 'Service' . $Helper->GetRandomID(),
    ValidID => 1,
    Comment => 'Unit Test Comment',
    UserID  => 1,
);

# wait 1 seconds
$Helper->FixedTimeAddSeconds(1);

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
    Name      => 'Service' . $Helper->GetRandomID(),
    ValidID   => 2,
    UserID    => 1,
);

# save current change_time
$ChangeTime = $TicketData{Changed};

# wait 5 seconds
$Helper->FixedTimeAddSeconds(5);

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
    Name    => 'SLA' . $Helper->GetRandomID(),
    ValidID => 1,
    Comment => 'Unit Test Comment',
    UserID  => 1,
);

# wait 5 seconds
$Helper->FixedTimeAddSeconds(5);

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
    Name    => 'SLA' . $Helper->GetRandomID(),
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

# Test TicketLastChangeTimeNewerMinutes
%TicketIDs = $TicketObject->TicketSearch(
    Result                           => 'HASH',
    Limit                            => 100,
    TicketLastChangeTimeNewerMinutes => 60,
    UserID                           => 1,
    Permission                       => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketLastChangeTimeNewerMinutes => 60)',
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

# Test TicketLastChangeOlderMinutes
%TicketIDs = $TicketObject->TicketSearch(
    Result                           => 'HASH',
    Limit                            => 100,
    TicketLastChangeTimeOlderMinutes => 60,
    UserID                           => 1,
    Permission                       => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketLastChangeTimeOlderMinutes => 60)',
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
my $TicketCreateTimeNewerDate = $Kernel::OM->Create('Kernel::System::DateTime');
$TicketCreateTimeNewerDate->Subtract( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                    => 'HASH',
    Limit                     => 100,
    TicketCreateTimeNewerDate => $TicketCreateTimeNewerDate->ToString(),
    UserID                    => 1,
    Permission                => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeNewerDate => 60)',
);

# Test TicketLastChangeTimeNewerDate
my $TicketLastChangeTimeNewerDate = $Kernel::OM->Create('Kernel::System::DateTime');
$TicketLastChangeTimeNewerDate->Subtract( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                        => 'HASH',
    Limit                         => 100,
    TicketLastChangeTimeNewerDate => $TicketLastChangeTimeNewerDate->ToString(),
    UserID                        => 1,
    Permission                    => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketLastChangeTimeNewerDate => 60)',
);

# Test ArticleCreateTimeNewerDate
my $ArticleCreateTimeNewerDate = $Kernel::OM->Create('Kernel::System::DateTime');
$ArticleCreateTimeNewerDate->Subtract( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                     => 'HASH',
    Limit                      => 100,
    ArticleCreateTimeNewerDate => $ArticleCreateTimeNewerDate->ToString(),
    UserID                     => 1,
    Permission                 => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:ArticleCreateTimeNewerDate => 60)',
);

# Test TicketLastChangeOlderDate
my $TicketLastChangeOlderDate = $Kernel::OM->Create('Kernel::System::DateTime');
$TicketLastChangeOlderDate->Subtract( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                        => 'HASH',
    Limit                         => 100,
    TicketLastChangeTimeOlderDate => $TicketLastChangeOlderDate->ToString(),
    UserID                        => 1,
    Permission                    => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketLastChangeTimeOlderDate => 60)',
);

# Test TicketCreateOlderDate
my $TicketCreateOlderDate = $Kernel::OM->Create('Kernel::System::DateTime');
$TicketCreateOlderDate->Subtract( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                    => 'HASH',
    Limit                     => 100,
    TicketCreateTimeOlderDate => $TicketCreateOlderDate->ToString(),
    UserID                    => 1,
    Permission                => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeOlderDate => 60)',
);

# Test ArticleCreateOlderDate
my $ArticleCreateOlderDate = $Kernel::OM->Create('Kernel::System::DateTime');
$ArticleCreateOlderDate->Subtract( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                     => 'HASH',
    Limit                      => 100,
    ArticleCreateTimeOlderDate => $ArticleCreateOlderDate->ToString(),
    UserID                     => 1,
    Permission                 => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:ArticleCreateTimeOlderDate => 60)',
);

# Test TicketCloseTimeNewerDate
my $TicketCloseTimeNewerDate = $Kernel::OM->Create('Kernel::System::DateTime');
$TicketCloseTimeNewerDate->Subtract( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                   => 'HASH',
    Limit                    => 100,
    TicketCloseTimeNewerDate => $TicketCloseTimeNewerDate->ToString(),
    UserID                   => 1,
    Permission               => 'rw',
);
$Self->True(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCloseTimeNewerDate => 60)',
);

# Test TicketCloseOlderDate
my $TicketCloseOlderDate = $Kernel::OM->Create('Kernel::System::DateTime');
$TicketCloseOlderDate->Subtract( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                   => 'HASH',
    Limit                    => 100,
    TicketCloseTimeOlderDate => $TicketCloseOlderDate->ToString(),
    UserID                   => 1,
    Permission               => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCloseTimeOlderDate => 60)',
);

my %Ticket2 = $TicketObject->TicketGet( TicketID => $TicketID );
$Self->Is(
    $Ticket2{Title},
    'Very long title 01234567890123456789012345678901234567890123456789'
        . '0123456789012345678901234567890123456789012345678901234567890123456789'
        . '0123456789012345678901234567890123456789012345678901234567890123456789'
        . '0123456789012345678901234567890123456789',
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
    $MoveQueueList[-1],
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

my $AccountedTime2 = $ArticleObject->ArticleAccountedTimeGet(
    ArticleID => $ArticleID,
);

$Self->Is(
    $AccountedTime2,
    4132.56,
    'ArticleAccountedTimeGet()'
);

my $HistoryTicketStatusGetStartObj    = $Kernel::OM->Create('Kernel::System::DateTime');
my $HistoryTicketStatusGetStartValues = $HistoryTicketStatusGetStartObj->Get();

my $HistoryTicketStatusGetStopObj = $Kernel::OM->Create('Kernel::System::DateTime');
$HistoryTicketStatusGetStopObj->Subtract( Days => 1 );
my $HistoryTicketStatusGetStopValues = $HistoryTicketStatusGetStopObj->Get();

my %TicketStatus = $TicketObject->HistoryTicketStatusGet(
    StopYear   => $HistoryTicketStatusGetStartValues->{Year},
    StopMonth  => $HistoryTicketStatusGetStartValues->{Month},
    StopDay    => $HistoryTicketStatusGetStartValues->{Day},
    StartYear  => $HistoryTicketStatusGetStopValues->{Year},
    StartMonth => $HistoryTicketStatusGetStopValues->{Month},
    StartDay   => $HistoryTicketStatusGetStopValues->{Day},
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

my $CustomerNo = 'CustomerNo' . $Helper->GetRandomID();

# ticket search sort/order test
my $TicketIDSortOrder1 = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket sort/order by tests',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => $CustomerNo,
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);

my %TicketCreated = $TicketObject->TicketGet(
    TicketID => $TicketIDSortOrder1,
    UserID   => 1,
);

# wait 2 seconds
$Helper->FixedTimeAddSeconds(2);

my $TicketIDSortOrder2 = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket sort/order by tests2',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => $CustomerNo,
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);

# wait 2 seconds
$Helper->FixedTimeAddSeconds(2);

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
    CustomerUser => 'unittest@otrs.com',
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
    CustomerUser => 'unittest@otrs.com',
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
    CustomerUser => 'unittest@otrs.com',
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
    CustomerUser => 'unittest@otrs.com',
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
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);

# wait 2 seconds
$Helper->FixedTimeAddSeconds(2);

my $TicketIDSortOrder4 = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket sort/order by tests2',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '4 high',
    State        => 'new',
    CustomerNo   => $CustomerNo,
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);

# wait 2 seconds
$Helper->FixedTimeAddSeconds(2);

my $TicketIDSortOrder5 = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket sort/order by tests5 (with other queue)',
    Queue        => 'Misc',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => $CustomerNo,
    CustomerUser => 'unittest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);

# find oldest ticket by priority, age
@TicketIDsSortOrder = $TicketObject->TicketSearch(
    Result       => 'ARRAY',
    Title        => '%sort/order by test%',
    Queues       => ['Raw'],
    CustomerID   => $CustomerNo,
    CustomerUser => 'unittest@otrs.com',
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
    CustomerUser => 'unittest@otrs.com',
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
    CustomerUser => 'unittest@otrs.com',
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
    CustomerUser => 'unittest@otrs.com',
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

# sort by ticket queue
@TicketIDsSortOrder = $TicketObject->TicketSearch(
    Result       => 'ARRAY',
    Title        => '%sort/order by test%',
    Queues       => [ 'Misc', 'Raw' ],
    CustomerID   => $CustomerNo,
    CustomerUser => 'unittest@otrs.com',
    OrderBy      => 'Up',
    SortBy       => 'Queue',
    UserID       => 1,
    Limit        => 1,
);
$Self->Is(
    $TicketIDsSortOrder[0],
    $TicketIDSortOrder5,
    'TicketTicketSearch() - ticket sort/order by (Queue (Up))',
);

$Count = $TicketObject->TicketSearch(
    Result       => 'COUNT',
    Title        => '%sort/order by test%',
    Queues       => ['Raw'],
    CustomerID   => $CustomerNo,
    CustomerUser => 'unittest@otrs.com',
    UserID       => 1,
    Limit        => 1,
);
$Self->Is(
    $Count,
    4,
    'TicketTicketSearch() - ticket count for created tickets',
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

# avoid StateType and StateTypeID problems in TicketSearch()

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
    CustomerUser => 'unittest@otrs.com',
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

my $Diff               = 60;
my $CurrentSystemTime  = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
my $PendingTimeSetDiff = $TicketObject->TicketPendingTimeSet(
    Diff     => $Diff,
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $PendingTimeSetDiff,
    "TicketPendingTimeSet() - Pending Time - set diff",
);

%TicketPending = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->Is(
    $TicketPending{RealTillTimeNotUsed},
    $CurrentSystemTime + $Diff * 60,
    "TicketPendingTimeSet() - diff time check",
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

my $PendingUntilTime = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        Year   => '2003',
        Month  => '08',
        Day    => '14',
        Hour   => '22',
        Minute => '05',
        Second => '00',
        }
)->ToEpoch();

$PendingUntilTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch() - $PendingUntilTime;

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

$PendingUntilTime = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2003-09-14 22:05:00',
        }
)->ToEpoch();

$PendingUntilTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch() - $PendingUntilTime;

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
$Helper->FixedTimeAddSeconds( -60 * 60 );

# Test TicketCreateTimeNewerDate (future date)
$TicketCreateTimeNewerDate = $Kernel::OM->Create('Kernel::System::DateTime');
$TicketCreateTimeNewerDate->Add( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                    => 'HASH',
    Limit                     => 100,
    TicketCreateTimeNewerDate => $TicketCreateTimeNewerDate->ToString(),
    UserID                    => 1,
    Permission                => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:TicketCreateTimeNewerDate => -60)',
);

# Test ArticleCreateTimeNewerDate (future date)
$ArticleCreateTimeNewerDate = $Kernel::OM->Create('Kernel::System::DateTime');
$ArticleCreateTimeNewerDate->Add( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                     => 'HASH',
    Limit                      => 100,
    ArticleCreateTimeNewerDate => $ArticleCreateTimeNewerDate->ToString(),
    UserID                     => 1,
    Permission                 => 'rw',
);
$Self->False(
    $TicketIDs{$TicketID},
    'TicketSearch() (HASH:ArticleCreateTimeNewerDate => -60)',
);

# Test TicketCloseTimeNewerDate (future date)
$TicketCloseTimeNewerDate = $Kernel::OM->Create('Kernel::System::DateTime');
$TicketCloseTimeNewerDate->Add( Hours => 1 );

%TicketIDs = $TicketObject->TicketSearch(
    Result                   => 'HASH',
    Limit                    => 100,
    TicketCloseTimeNewerDate => $TicketCloseTimeNewerDate->ToString(),
    UserID                   => 1,
    Permission               => 'rw',
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
# ticket search returns an empty list anyway

my @NewStates = $StateObject->StateGetStatesByType(
    StateType => ['new'],
    Result    => 'ID',
);

# make sure we don't have valid states for state type new
for my $NewStateID (@NewStates) {
    my %State = $StateObject->StateGet(
        ID => $NewStateID,
    );
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
    my %State = $StateObject->StateGet(
        ID => $NewStateID,
    );
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
        my $ErrorMessage = $Kernel::OM->Get('Kernel::System::Log')->GetLogEntry(
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

# Create enviroment for testing Escalation ORDER BY modification from the bug#13458.
# Create Queues with different Escalation times.
my @QueueConfig = (
    {
        # First created Queue does not have Update time set, value is 0 for created ticket.
        Name              => 'Queue' . $Helper->GetRandomID(),
        FirstResponseTime => 50,
        SolutionTime      => 60,
    },
    {
        # Second created Queue does not have First response time set, value is 0 for created ticket.
        Name         => 'Queue' . $Helper->GetRandomID(),
        UpdateTime   => 70,
        SolutionTime => 80,
    },
    {
        # Third created Queue does not have Solution time set, value is 0 for created ticket.
        Name              => 'Queue' . $Helper->GetRandomID(),
        FirstResponseTime => 60,
        UpdateTime        => 30,
    },
);

my @QueueIDs;
for my $QueueCreate (@QueueConfig) {
    my $QueueID = $QueueObject->QueueAdd(
        ValidID         => 1,
        GroupID         => 1,
        FollowUpID      => 1,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        Comment         => 'Some comment',
        UserID          => 1,
        %{$QueueCreate},
    );
    push @QueueIDs, $QueueID;
}

# Create Tickets.
my @TestTicketIDs;
for my $QueueID (@QueueIDs) {
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket Title',
        QueueID      => $QueueID,
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerID   => '123465',
        CustomerUser => 'bugtest@otrs.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    push @TestTicketIDs, $TicketID;

    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        IsVisibleForCustomer => 0,
        SenderType           => 'agent',
        From                 => 'Agent Some Agent Some Agent <email@example.com>',
        To                   => 'Customer A <customer-a@example.com>',
        Cc                   => 'Customer B <customer-b@example.com>',
        ReplyTo              => 'Customer B <customer-b@example.com>',
        Subject              => 'some short description',
        Body                 => 'the message text Perl modules provide a range of',
        ContentType          => 'text/plain; charset=ISO-8859-15',
        HistoryType          => 'AddNote',
        HistoryComment       => 'Some free text!',
        UserID               => 1,
        NoAgentNotify        => 1,
    );

    my $TicketEscalationIndexBuild = $TicketObject->TicketEscalationIndexBuild(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # Wait 1 second to have escalations.
    $Helper->FixedTimeAddSeconds(1);

    # Renew objects because of transaction.
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::Ticket',
            'Kernel::System::Ticket::Article',
            'Kernel::System::Ticket::Article::Backend::Internal',
        ],
    );
    $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
}

# Create TicketSearch by Escalations scenarios.
my @Tests = (
    {
        Config => {
            OrderBy => 'Up',
            SortBy  => 'EscalationResponseTime',
        },
        ExpectedResult => [ $TestTicketIDs[1], $TestTicketIDs[0], $TestTicketIDs[2] ],
    },
    {
        Config => {
            OrderBy => 'Down',
            SortBy  => 'EscalationResponseTime',
        },
        ExpectedResult => [ $TestTicketIDs[2], $TestTicketIDs[0], $TestTicketIDs[1] ],
    },
    {
        Config => {
            OrderBy => 'Up',
            SortBy  => 'EscalationUpdateTime',
        },
        ExpectedResult => [ $TestTicketIDs[0], $TestTicketIDs[2], $TestTicketIDs[1] ],
    },
    {
        Config => {
            OrderBy => 'Down',
            SortBy  => 'EscalationUpdateTime',
        },
        ExpectedResult => [ $TestTicketIDs[1], $TestTicketIDs[2], $TestTicketIDs[0] ],
    },
    {
        Config => {
            OrderBy => 'Up',
            SortBy  => 'EscalationSolutionTime',
        },
        ExpectedResult => [ $TestTicketIDs[2], $TestTicketIDs[0], $TestTicketIDs[1] ],
    },
    {
        Config => {
            OrderBy => 'Down',
            SortBy  => 'EscalationSolutionTime',
        },
        ExpectedResult => [ $TestTicketIDs[1], $TestTicketIDs[0], $TestTicketIDs[2] ],
    },
);
for my $Test (@Tests) {
    my @Tickets = $TicketObject->TicketSearch(
        Result            => 'ARRAY',
        CustomerUserLogin => 'bugtest@otrs.com',
        UserID            => 1,
        %{ $Test->{Config} },
    );
    $Self->IsDeeply(
        $Test->{ExpectedResult},
        \@Tickets,
        "TicketSearch() - SortBy $Test->{Config}{SortBy} - OrderBy $Test->{Config}{OrderBy}"
    );
}

# cleanup is done by RestoreDatabase but we need to delete the tickets to cleanup the filesystem too
my @DeleteTicketList = $TicketObject->TicketSearch(
    Result            => 'ARRAY',
    CustomerUserLogin => [ 'unittest@otrs.com', 'bugtest@otrs.com' ],
    UserID            => 1,
);
for my $TicketID (@DeleteTicketList) {
    $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
}

# Test ticket search by fulltext (see bug#13284).
#   Create a test ticket and add an article for this ticket.
#   Note that article subject and ticket title differ.
my $TestTicketTitle  = 'title' . $Helper->GetRandomID();
my $FulltextTicketID = $TicketObject->TicketCreate(
    Title        => $TestTicketTitle,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerID   => '123465',
    CustomerUser => 'bugtest@otrs.com',
    OwnerID      => 1,
    UserID       => 1,
);

my $TestArticleSubject = 'subject' . $Helper->GetRandomID();
my $FulltextArticleID  = $ArticleBackendObject->ArticleCreate(
    TicketID             => $FulltextTicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => $TestArticleSubject,
    Body                 => 'Some text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'AddNote',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,
);

$ArticleObject->ArticleSearchIndexBuild(
    TicketID  => $FulltextTicketID,
    ArticleID => $FulltextArticleID,
    UserID    => 1,
);

# Search for ticket title as fulltext parameter.
@TicketIDs = $TicketObject->TicketSearch(
    Result     => 'ARRAY',
    Fulltext   => $TestTicketTitle,
    UserID     => 1,
    Permission => 'rw',
);

# Verify result has one item and it's indeed the test ticket.
$Self->IsDeeply(
    \@TicketIDs,
    [$FulltextTicketID],
    "TicketSearch() - search ticket title '$TestTicketTitle' as fulltext - found only TicketID $FulltextTicketID"
);

# Search for article subject as fulltext parameter.
@TicketIDs = $TicketObject->TicketSearch(
    Result     => 'ARRAY',
    Fulltext   => $TestArticleSubject,
    UserID     => 1,
    Permission => 'rw',
);

# Verify result has one item and it's indeed the test ticket.
$Self->IsDeeply(
    \@TicketIDs,
    [$FulltextTicketID],
    "TicketSearch() - search article subject '$TestArticleSubject' as fulltext - found only TicketID $FulltextTicketID"
);

$Success = $TicketObject->TicketDelete(
    TicketID => $FulltextTicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketID $FulltextTicketID - deleted",
);

# Test TicketCountByAttribute() function.
# Enable Ticket Type.
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Ticket::Type',
    Value => 1,
);

# Create test environment.
my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');
my $RandomID       = $Helper->GetRandomID();
my @Priorities;
my @Services;
my @SLAs;
my @States;
my @Types;
my @Queues;

for my $Index ( 1 .. 3 ) {

    # Create test queues.
    my $QueueName = $Index . 'Queue' . $RandomID;
    my $QueueID   = $QueueObject->QueueAdd(
        Name            => $QueueName,
        ValidID         => 1,
        GroupID         => 1,
        FollowUpID      => 1,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        Comment         => 'Unit Test Comment',
        UserID          => 1,
    ) || die "QueueAdd() error.";

    push @Queues, {
        ID   => $QueueID,
        Name => $QueueName,
    };

    # Create test priorities.
    my $PriorityName = $Index . 'Prio' . $RandomID;
    my $PriorityID   = $PriorityObject->PriorityAdd(
        Name    => $PriorityName,
        ValidID => 1,
        UserID  => 1,
    ) || die "PriorityAdd() error.";

    push @Priorities, {
        ID   => $PriorityID,
        Name => $PriorityName,
    };

    # Create test services.
    my $ServiceName = $Index . 'Service' . $RandomID;
    my $ServiceID   = $ServiceObject->ServiceAdd(
        Name    => $ServiceName,
        ValidID => 1,
        Comment => 'Unit Test Comment',
        UserID  => 1,
    ) || die "ServiceAdd() error.";

    push @Services, {
        ID   => $ServiceID,
        Name => $ServiceName,
    };

    # Create test SLAs.
    my $SLAName = $Index . 'SLA' . $RandomID;
    my $SLAID   = $SLAObject->SLAAdd(
        Name    => $SLAName,
        ValidID => 1,
        Comment => 'Unit Test Comment',
        UserID  => 1,
    ) || die "SLAAdd() error.";

    push @SLAs, {
        ID   => $SLAID,
        Name => $SLAName,
    };

    # Create test states.
    my $StateName = $Index . 'State' . $RandomID;
    my $StateID   = $StateObject->StateAdd(
        Name    => $StateName,
        Comment => 'Unit Test Comment',
        ValidID => 1,
        TypeID  => 1,
        UserID  => 1,
    ) || die "StateAdd() error.";

    push @States, {
        ID   => $StateID,
        Name => $StateName,
    };

    # Create test types.
    my $TypeName = $Index . 'Type' . $RandomID;
    my $TypeID   = $TypeObject->TypeAdd(
        Name    => $TypeName,
        ValidID => 1,
        UserID  => 1,
    ) || die "TypeAdd() error.";

    push @Types, {
        ID   => $TypeID,
        Name => $TypeName,
    };
}

# Create test cases for different function outcome.
@Tests = (
    {
        QueueID    => $Queues[0]->{ID},
        PriorityID => $Priorities[0]->{ID},
        StateID    => $States[0]->{ID},
        ServiceID  => $Services[0]->{ID},
        SLAID      => $SLAs[2]->{ID},
        TypeID     => $Types[0]->{ID},
    },
    {
        QueueID    => $Queues[1]->{ID},
        PriorityID => $Priorities[2]->{ID},
        StateID    => $States[1]->{ID},
        ServiceID  => $Services[1]->{ID},
        SLAID      => $SLAs[2]->{ID},
        TypeID     => $Types[1]->{ID},
    },
    {
        QueueID    => $Queues[2]->{ID},
        PriorityID => $Priorities[2]->{ID},
        StateID    => $States[0]->{ID},
        ServiceID  => $Services[1]->{ID},
        SLAID      => $SLAs[2]->{ID},
        TypeID     => $Types[0]->{ID},
    },
    {
        QueueID    => $Queues[2]->{ID},
        PriorityID => $Priorities[0]->{ID},
        StateID    => $States[0]->{ID},
        ServiceID  => $Services[1]->{ID},
        SLAID      => $SLAs[2]->{ID},
        TypeID     => $Types[2]->{ID},
    },
    {
        QueueID    => $Queues[2]->{ID},
        PriorityID => $Priorities[2]->{ID},
        StateID    => $States[0]->{ID},
        ServiceID  => $Services[2]->{ID},
        SLAID      => $SLAs[2]->{ID},
        TypeID     => $Types[1]->{ID},
    },
    {
        QueueID    => $Queues[1]->{ID},
        PriorityID => $Priorities[0]->{ID},
        StateID    => $States[1]->{ID},
        ServiceID  => $Services[0]->{ID},
        SLAID      => $SLAs[2]->{ID},
        TypeID     => $Types[2]->{ID},
    },
    {
        QueueID    => $Queues[1]->{ID},
        PriorityID => $Priorities[0]->{ID},
        StateID    => $States[1]->{ID},
        ServiceID  => $Services[0]->{ID},
        SLAID      => $SLAs[2]->{ID},
        TypeID     => $Types[0]->{ID},
    },
    {
        QueueID    => $Queues[1]->{ID},
        PriorityID => $Priorities[2]->{ID},
        StateID    => $States[2]->{ID},
        ServiceID  => $Services[0]->{ID},
        SLAID      => $SLAs[2]->{ID},
        TypeID     => $Types[1]->{ID},
    },
    {
        QueueID    => $Queues[2]->{ID},
        PriorityID => $Priorities[2]->{ID},
        StateID    => $States[1]->{ID},
        ServiceID  => $Services[0]->{ID},
        SLAID      => $SLAs[2]->{ID},
        TypeID     => $Types[0]->{ID},
    },
    {
        QueueID    => $Queues[0]->{ID},
        PriorityID => $Priorities[2]->{ID},
        StateID    => $States[0]->{ID},
        ServiceID  => $Services[0]->{ID},
        SLAID      => $SLAs[2]->{ID},
        TypeID     => $Types[2]->{ID},
    },
);

my %ExpectedResult;
undef @TicketIDs;
for my $Test (@Tests) {
    my $TicketID = $TicketObject->TicketCreate(
        %{$Test},
        Title        => 'Unit Test ticket',
        CustomerNo   => 'Unit Test customer',
        CustomerUser => 'unittest@otrs.com',
        Lock         => 'unlock',
        OwnerID      => 1,
        UserID       => 1,
    );
    push @TicketIDs, $TicketID;

}

# Create test expected outcome.
@Tests = (
    {
        Attribute     => 'Service',
        ExpectedCount => {
            $Services[0]->{Name} => 6,
            $Services[1]->{Name} => 3,
            $Services[2]->{Name} => 1,
        },
    },
    {
        Attribute     => 'ServiceID',
        ExpectedCount => {
            $Services[0]->{ID} => 6,
            $Services[1]->{ID} => 3,
            $Services[2]->{ID} => 1,
        },
    },
    {
        Attribute     => 'SLA',
        ExpectedCount => {
            $SLAs[2]->{Name} => 10,
        },
    },
    {
        Attribute     => 'SLAID',
        ExpectedCount => {
            $SLAs[2]->{ID} => 10,
        },
    },
    {
        Attribute     => 'Queue',
        ExpectedCount => {
            $Queues[0]->{Name} => 2,
            $Queues[1]->{Name} => 4,
            $Queues[2]->{Name} => 4,
        },
    },
    {
        Attribute     => 'QueueID',
        ExpectedCount => {
            $Queues[0]->{ID} => 2,
            $Queues[1]->{ID} => 4,
            $Queues[2]->{ID} => 4,
        },
    },
    {
        Attribute     => 'Priority',
        ExpectedCount => {
            $Priorities[0]->{Name} => 4,
            $Priorities[2]->{Name} => 6,
        },
    },
    {
        Attribute     => 'PriorityID',
        ExpectedCount => {
            $Priorities[0]->{ID} => 4,
            $Priorities[2]->{ID} => 6,
        },
    },
    {
        Attribute     => 'State',
        ExpectedCount => {
            $States[0]->{Name} => 5,
            $States[1]->{Name} => 4,
            $States[2]->{Name} => 1,
        },
    },
    {
        Attribute     => 'StateID',
        ExpectedCount => {
            $States[0]->{ID} => 5,
            $States[1]->{ID} => 4,
            $States[2]->{ID} => 1,
        },
    },
    {
        Attribute     => 'Type',
        ExpectedCount => {
            $Types[0]->{Name} => 4,
            $Types[1]->{Name} => 3,
            $Types[2]->{Name} => 3,
        },
    },
    {
        Attribute     => 'TypeID',
        ExpectedCount => {
            $Types[0]->{ID} => 4,
            $Types[1]->{ID} => 3,
            $Types[2]->{ID} => 3,
        },
    },
);

# Check required params.
my $TicketCount = $TicketObject->TicketCountByAttribute(
    TicketIDs => \@TicketIDs,
);
$Self->False(
    $TicketCount,
    "TicketCountByAttribute() need Attribute param."
);
$TicketCount = $TicketObject->TicketCountByAttribute(
    Attribute => 'Service',
    TicketIDs => [],
);
$Self->True(
    !IsHashRefWithData($TicketCount),
    "TicketCountByAttribute() need TicketIDs array."
);

# Run valid tests.
for my $Test (@Tests) {
    my $TicketCount = $TicketObject->TicketCountByAttribute(
        Attribute => $Test->{Attribute},
        TicketIDs => \@TicketIDs,
    );
    $Self->IsDeeply(
        $TicketCount,
        $Test->{ExpectedCount},
        "TicketCountByAttribute() for Attribute $Test->{Attribute} correct,"
    );
}

1;
