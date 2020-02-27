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
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Set fixed time to create user in pst.
# Then when it is set to invalid, it have been invalid for more than a month.
$Helper->FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2019-06-15 00:00:00',
        },
    )->ToEpoch()
);

my $CommandObject        = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::InvalidUserCleanup');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $UserObject           = $Kernel::OM->Get('Kernel::System::User');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckMXRecord',
    Value => 0,
);

# Enable ticket watcher feature.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Watcher',
    Value => 1,
);

my ( $UserName1, $UserID1 ) = $Helper->TestUserCreate();

my $TicketID1 = $TicketObject->TicketCreate(
    Title        => 'A test for ticket unlocking',
    Queue        => 'Raw',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'pending reminder',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $UserID1,
    UserID       => $UserID1,
);

my $ArticleID1 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID1,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => $UserID1,
    NoAgentNotify        => 1,
);

$Self->True(
    $ArticleID1,
    "ArticleCreate() - $ArticleID1",
);

my $Set = $ArticleObject->ArticleFlagSet(
    TicketID  => $TicketID1,
    ArticleID => $ArticleID1,
    Key       => 'seen',
    Value     => 1,
    UserID    => $UserID1,
);
$Self->True(
    $Set,
    "ArticleFlagSet() article $ArticleID1",
);

# Set user as an invalid.
my %User = $UserObject->GetUserData( User => $UserName1 );
$Kernel::OM->Get('Kernel::System::User')->UserUpdate(
    %User,
    ValidID      => 2,
    ChangeUserID => 1,
);

my $Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketID1,
    WatchUserID => $UserID1,
    UserID      => $UserID1,
);

$Self->True(
    $Subscribe,
    "TicketWatchSubscribe() User:$UserID1 to Ticket:$TicketID1",
);

# Set current time in order to check InvalidUserCleanup console command.
# Created test user will be invalid for more than a month.
$Helper->FixedTimeSet();

my ( $UserName2, $UserID2 ) = $Helper->TestUserCreate();
my $TicketID2 = $TicketObject->TicketCreate(
    Title        => 'A test for ticket unlocking',
    Queue        => 'Raw',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'pending reminder',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $UserID2,
    UserID       => $UserID2,
);

my $ArticleID2 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID1,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => $UserID2,
    NoAgentNotify        => 1,
);

$Self->True(
    $ArticleID2,
    "ArticleCreate() - $ArticleID2"
);

$Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketID2,
    WatchUserID => $UserID2,
    UserID      => $UserID2,
);

$Self->True(
    $Subscribe,
    "TicketWatchSubscribe() User:$UserID2 to Ticket:$TicketID2",
);

my $ExitCode = $CommandObject->Execute();

# Just check exit code.
$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::InvalidUserCleanup exit code",
);

my %Ticket = $TicketObject->TicketGet(
    UserID   => 1,
    TicketID => $TicketID1,

);

$Self->Is(
    $Ticket{Lock},
    'unlock',
    'Ticket from invalid owner was unlocked',
);

$Self->Is(
    $Ticket{State},
    'open',
    'Ticket from invalid owner was set to "open"',
);

my @HistoryLines = $TicketObject->HistoryGet(
    TicketID => $TicketID1,
    UserID   => 1,
);
$Self->True(
    scalar( grep { $_->{HistoryType} eq 'Unsubscribe' } @HistoryLines ) // 0,
    "'Unsubscribe' history entry of invalid user - found for UserID $UserID1, TicketID $TicketID1",
);

# Check if there is Unsubscribe history entry for ticket
#   that is not subscribed with invalid ticket.
# See more information in bug#14987.
@HistoryLines = $TicketObject->HistoryGet(
    TicketID => $TicketID2,
    UserID   => 1,
);
$Self->False(
    scalar( grep { $_->{HistoryType} eq 'Unsubscribe' } @HistoryLines ) // 1,
    "'Unsubscribe' history entry of invalid user - not found for UserID $UserID2, TicketID $TicketID2",
);

# Cleanup cache is done by RestoreDatabase.

1;
