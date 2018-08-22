# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# force rich text editor
my $Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 1,
);
$Self->True(
    $Success,
    'Force RichText with true',
);

# use DoNotSendEmail email backend
$Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);
$Self->True(
    $Success,
    'Set DoNotSendEmail backend with true',
);

# create a new user for current test
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['users'],
);

my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $UserLogin,
);

my $UserID = $UserData{UserID};

# create new customer user for current test
my $CustomerUserLogin = $Helper->TestCustomerUserCreate();

my %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
    User => $CustomerUserLogin,
);

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# create ticket
my @TicketIDs;
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'example.com',
    CustomerUser => $CustomerUserData{UserEmail},
    OwnerID      => $UserID,
    UserID       => $UserID,
);

# sanity check
$Self->True(
    $TicketID,
    "TicketCreate() successful for Ticket ID $TicketID",
);
push @TicketIDs, $TicketID;

# get ticket number
my $TicketNumber = $TicketObject->TicketNumberLookup(
    TicketID => $TicketID,
    UserID   => $UserID,
);

$Self->True(
    $TicketNumber,
    "TicketNumberLookup() successful for Ticket# $TicketNumber",
);

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'webrequest',
    SenderType     => 'customer',
    From           => $CustomerUserData{UserEmail},
    To             => $UserData{UserEmail},
    Subject        => 'some short description',
    Body           => 'the message text',
    Charset        => 'utf8',
    MimeType       => 'text/plain',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
);

# sanity check
$Self->True(
    $ArticleID,
    "ArticleCreate() successful for Article ID $ArticleID",
);

my $NotificationEventObject      = $Kernel::OM->Get('Kernel::System::NotificationEvent');
my $EventNotificationEventObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent');

# create add note notification
my @NotificationIDs;
my $NotificationID = $NotificationEventObject->NotificationAdd(
    Name => 'Customer notification',
    Data => {
        Events     => ['ArticleCreate'],
        Recipients => ['Customer'],
    },
    Subject => 'Test external note',

    # include non-breaking space (bug#10970)
    Body => 'Ticket:&nbsp;<OTRS_TICKET_TicketID>&nbsp;<OTRS_OWNER_UserFirstname>',

    Type    => 'text/html',
    Charset => 'utf-8',
    Comment => 'An optional comment',
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->IsNot(
    $NotificationID,
    undef,
    'NotificationAdd() should not be undef',
);
push @NotificationIDs, $NotificationID;

my $Result = $EventNotificationEventObject->Run(
    Event => 'ArticleCreate',
    Data  => {
        TicketID => $TicketID,
    },
    Config => {},
    UserID => 1,
);

$Self->True(
    $Result,
    'ArticleCreate event raised'
);

# get ticket article IDs
my @ArticleIDs = $TicketObject->ArticleIndex(
    TicketID => $TicketID,
);

$Self->Is(
    scalar @ArticleIDs,
    2,
    'ArticleIndex() should return two elements',
);

# get last article
my %Article = $TicketObject->ArticleGet(
    ArticleID => $ArticleIDs[-1],    # last
    UserID    => $UserID,
);

$Self->Is(
    $Article{ArticleType},
    'email-notification-ext',
    'ArticleGet() should return external notification',
);

$Self->Is(
    $Article{Subject},
    '[' . $ConfigObject->Get('Ticket::Hook') . $TicketNumber . '] Test external note',
    'ArticleGet() subject contains notification subject',
);

# Create new Notification.
my $NotificationID2 = $NotificationEventObject->NotificationAdd(
    Name => 'Customer notification no Article',
    Data => {
        Events     => ['TicketCreate'],
        Recipients => ['Customer'],
    },
    Subject => 'Test Customer notification no Article',
    Body    => 'Notificaiton Body',
    Type    => 'text/html',
    Charset => 'utf-8',
    Comment => 'An optional comment',
    ValidID => 1,
    UserID  => 1,
);
$Self->IsNot(
    $NotificationID2,
    undef,
    'NotificationAdd() should not be undef',
);
push @NotificationIDs, $NotificationID2;

# Test sending Customer notification with no article.
my $TicketID2 = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'example.com',
    CustomerUser => $CustomerUserData{UserCustomerID},
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID2,
    "TicketCreate() successful for Ticket ID $TicketID2",
);
push @TicketIDs, $TicketID2;

# Trigger TicketCreate event.
$Result = $EventNotificationEventObject->Run(
    Event => 'TicketCreate',
    Data  => {
        TicketID => $TicketID2,
    },
    Config => {},
    UserID => 1,
);

$Self->True(
    $Result,
    'TicketCreate event raised'
);

# Get Ticket Article IDs.
@ArticleIDs = $TicketObject->ArticleIndex(
    TicketID => $TicketID2,
);
$Self->Is(
    scalar @ArticleIDs,
    1,
    'ArticleIndex() should return one elements',
);

# Get Notification Article.
%Article = $TicketObject->ArticleGet(
    ArticleID => $ArticleIDs[0],
    UserID    => $UserID,
);
$Self->Is(
    $Article{ArticleType},
    'email-notification-ext',
    'ArticleGet() should return external notification',
);
$Self->Is(
    $Article{Subject},
    'Test Customer notification no Article',
    'ArticleGet() subject contains notification subject',
);

# Delete notification event.
for my $Notification (@NotificationIDs) {
    my $NotificationDelete = $NotificationEventObject->NotificationDelete(
        ID     => $Notification,
        UserID => 1,
    );
    $Self->True(
        $NotificationDelete,
        "NotificationDelete() successful for Notification ID $Notification",
    );
}

# Delete the ticket.
for my $Ticket (@TicketIDs) {
    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $Ticket,
        UserID   => $UserID,
    );
    $Self->True(
        $TicketDelete,
        "TicketDelete() successful for Ticket ID $Ticket",
    );
}

1;
