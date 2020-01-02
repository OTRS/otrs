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

my $TicketObject                = $Kernel::OM->Get('Kernel::System::Ticket');
my $NotificationEventObject     = $Kernel::OM->Get('Kernel::System::NotificationEvent');
my $TicketNoficationEventObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Disable email addresses checking.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Disable notification event handler.
$Helper->ConfigSettingChange(
    Key   => 'Ticket::EventModulePost###7000-NotificationEvent',
    Valid => 0,
);

my $RandomID = $Helper->GetRandomID();

# Create article send notification.
my $NotificationID = $NotificationEventObject->NotificationAdd(
    Name    => "Notification-$RandomID",
    Comment => "Comment $RandomID",
    Data    => {
        Transports     => ['Email'],
        Events         => ['ArticleSend'],
        RecipientEmail => [ $RandomID . '@test.com' ],
    },
    Message => {
        en => {
            Subject     => "Notification subject - $RandomID",
            Body        => "Notification body - $RandomID",
            ContentType => 'text/plain',
        },
    },
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $NotificationID,
    "NotificationID $NotificationID is created",
);

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title      => "Ticket-$RandomID",
    QueueID    => 1,
    Lock       => 'unlock',
    PriorityID => 3,
    State      => 'open',
    OwnerID    => 1,
    UserID     => 1,
);
$Self->True(
    $TicketID,
    "TicketID $TicketID is created"
);

# Create test email article.
my $ArticleID
    = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel( ChannelName => 'Email' )->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'system',
    IsVisibleForCustomer => 1,
    Subject              => 'some short description',
    Body                 => 'the message text',
    Charset              => 'ISO-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'SendCustomerNotification',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    );
$Self->True(
    $ArticleID,
    "ArticleID $ArticleID is created",
);

# Run ArticleSend notification event.
my $Result = $TicketNoficationEventObject->Run(
    UserID => 1,
    Config => {
        Event       => '',
        Module      => 'Kernel::System::Ticket::Event::NotificationEvent',
        Transaction => 1,
    },
    Event => 'ArticleSend',
    Data  => {
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    }
);

# Verify the notification is sent successfully.
$Self->Is(
    $Result,
    1,
    "1 - ArticleSend notification event - sent notification",
);

# Run ArticleSend notification event again.
$Result = $TicketNoficationEventObject->Run(
    UserID => 1,
    Config => {
        Event       => '',
        Module      => 'Kernel::System::Ticket::Event::NotificationEvent',
        Transaction => 1,
    },
    Event => 'ArticleSend',
    Data  => {
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    }
);

# Verify the loop protection stopped loop successfully.
$Self->Is(
    $Result,
    undef,
    "2 - ArticleSend notification event - return 'undef' after loop protection check",
);

# Delete notification event.
my $Success = $NotificationEventObject->NotificationDelete(
    ID     => $NotificationID,
    UserID => 1,
);
$Self->True(
    $Success,
    "NotificationID $NotificationID is deleted",
);

# Delete test ticket.
$Success = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketID $TicketID is deleted"
);

# Cleanup is done by RestoreDatabase.

1;
