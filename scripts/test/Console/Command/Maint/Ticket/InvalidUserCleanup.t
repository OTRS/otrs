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

my $UserName = $Helper->TestUserCreate();
my %User     = $UserObject->GetUserData( User => $UserName );
my $UserID   = $User{UserID};

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'A test for ticket unlocking',
    Queue        => 'Raw',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'pending reminder',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $UserID,
    UserID       => $UserID,
);

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => $UserID,
    NoAgentNotify        => 1,
);

$Self->True(
    $ArticleID,
    'ArticleCreate()'
);

my $Set = $ArticleObject->ArticleFlagSet(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    Key       => 'seen',
    Value     => 1,
    UserID    => $UserID,
);
$Self->True(
    $Set,
    'ArticleFlagSet() article $ArticleID',
);

$Kernel::OM->Get('Kernel::System::User')->UserUpdate(
    %User,
    ValidID      => 2,
    ChangeUserID => 1,
);

my $Subscribe = $TicketObject->TicketWatchSubscribe(
    TicketID    => $TicketID,
    WatchUserID => $UserID,
    UserID      => $UserID,
);

$Self->True(
    $Subscribe,
    "TicketWatchSubscribe() User:$UserID to Ticket:$TicketID",
);

# Set current time.
$Helper->FixedTimeSet();

my $ExitCode = $CommandObject->Execute();

# Just check exit code.
$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::InvalidUserCleanup exit code",
);

my %Ticket = $TicketObject->TicketGet(
    UserID   => 1,
    TicketID => $TicketID,

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

# Cleanup cache is done by RestoreDatabase.

1;
