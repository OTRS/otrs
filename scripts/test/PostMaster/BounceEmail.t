# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::PostMaster;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

# Disable emails validation.
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Don't really send the emails, just simulate.
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

my $MailQueueSend = sub {

    # Send
    my $Items = $MailQueueObject->List();
    for my $Item ( @{$Items} ) {
        $MailQueueObject->Send( %{$Item}, );
    }

    return;
};

my $LastBounceEmailGenerated = undef;
my $BounceEmail              = sub {
    my %Param = @_;

    my $MessageID = $Param{MessageID};
    if ( !$MessageID ) {
        $MessageID = '<000001372d0dbf88-76d26d51-9d96-468a-9071-318ba2c35003-000000@email.amazonses.com>';
    }

    return $LastBounceEmailGenerated if $LastBounceEmailGenerated && !$Param{MessageID};

    $LastBounceEmailGenerated = sprintf q{Delivered-To: me@aaronsw.com
Received: by 10.213.9.17 with SMTP id j17csp4766ebj;
        Tue, 8 May 2012 20:34:50 -0700 (PDT)
Received: by 10.182.207.10 with SMTP id ls10mr30733797obc.9.1336534489928;
        Tue, 08 May 2012 20:34:49 -0700 (PDT)
Return-Path: <>
Received: from mx3.name.com (mx3.name.com. [173.192.7.98])
        by mx.google.com with ESMTP id s3si768112obn.1.2012.05.08.20.34.49;
        Tue, 08 May 2012 20:34:49 -0700 (PDT)
Received-SPF: pass (google.com: best guess record for domain of mx3.name.com designates 173.192.7.98 as permitted sender) client-ip=173.192.7.98;
Authentication-Results: mx.google.com; spf=pass (google.com: best guess record for domain of mx3.name.com designates 173.192.7.98 as permitted sender) smtp.mail=
Received-SPF: None (no SPF record) identity=helo; client-ip=199.255.192.13; helo=a192-13.smtp-out.amazonses.com; envelope-from=<>; receiver=info@watchdog.net
Received: from a192-13.smtp-out.amazonses.com (a192-13.smtp-out.amazonses.com [199.255.192.13])
    by mx3.name.com (Postfix) with ESMTP id 5972F6000074C
    for <info@watchdog.net>; Tue,  8 May 2012 22:34:49 -0500 (CDT)
X-Original-To: 000001372d0dbf88-76d26d51-9d96-468a-9071-318ba2c35003-000000@amazonses.com
Delivered-To: 000001372d0dbf88-76d26d51-9d96-468a-9071-318ba2c35003-000000@amazonses.com
Message-Id: <000001372fa9d596-ec772006-9987-11e1-8d9b-433290f94ba3-000000@email.amazonses.com>
Date: Wed, 9 May 2012 03:34:48 +0000
To: info@watchdog.net
From: MAILER-DAEMON@amazonses.com
Subject: Delivery Status Notification (Failure)
MIME-Version: 1.0
Content-Type: multipart/report; report-type=delivery-status; boundary="ACnzx.4lvBb052b.srYYd.CyGnkMZ"
X-AWS-Outgoing: 199.255.192.13

--ACnzx.4lvBb052b.srYYd.CyGnkMZ
content-type: text/plain;
    charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The following message to <wrongster@foo.com> was undeliverable.
The reason for the problem:
5.4.7 - Delivery expired (message too old) 'no valid ip addresses'

--ACnzx.4lvBb052b.srYYd.CyGnkMZ
content-type: message/delivery-status

Reporting-MTA: dns; na-mm-outgoing-7101-bacon.iad7.amazon.com

Final-Recipient: rfc822;wrongster@foo.com
Action: failed
Status: 5.0.0 (permanent failure)
Diagnostic-Code: smtp; 5.4.7 - Delivery expired (message too old) 'no valid ip addresses' (delivery attempts: 0)

--ACnzx.4lvBb052b.srYYd.CyGnkMZ
content-type: message/rfc822

Received: from unknown (HELO aws-bacon-dlvr-svc-na-i-986ddefa.us-east-1.amazon.com) ([10.13.133.79])
  by na-mm-outgoing-7101-bacon.iad7.amazon.com with ESMTP; 08 May 2012 16:15:55 +0000
Return-Path: 000001372d0dbf88-76d26d51-9d96-468a-9071-318ba2c35003-000000@amazonses.com
Date: Tue, 8 May 2012 15:25:04 +0000
From: info@watchdog.net
To: wrongster@foo.com
Message-ID: %s
Subject: Thanks for signing 'delete this petition'!
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AWS-Outgoing: 199.127.232.7

Thanks for signing "delete this petition"! Please encourage your friends to sign by forwarding this link to them:

http://act.watchdog.net/petitions/6

it is incorrect

--ACnzx.4lvBb052b.srYYd.CyGnkMZ--}, $MessageID;

    return $LastBounceEmailGenerated;
};

my $ProcessEmail = sub {
    my %Param = @_;

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
            Start     => 1,
            }
    );
    my $MessageID = $CommunicationLogObject->ObjectLogStart( ObjectType => 'Message' );

    my $PostMasterObject = Kernel::System::PostMaster->new(
        CommunicationLogObject    => $CommunicationLogObject,
        CommunicationLogMessageID => $MessageID,
        Email                     => $BounceEmail->(%Param),
        Debug                     => 2,
    );

    my ( $ReturnCode, $TicketID ) = $PostMasterObject->Run();

    $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Message',
        ObjectID   => $MessageID,
        Status     => 'Successful',
    );
    $CommunicationLogObject->CommunicationStop(
        Status => 'Successful',
    );

    return ( $ReturnCode, $TicketID, );
};

my $CheckArticleTransmissionError = sub {
    my %Param = @_;

    my $TicketID = $Param{TicketID};

    # Get the last article for the ticket.
    my @Articles = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleList(
        TicketID => $TicketID,
    );

    # Sort articles list in descending order.
    @Articles = sort { $b->{ArticleID} <=> $a->{ArticleID} } @Articles;

    my $ArticleBackendObject =
        $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
        ChannelName => 'Email'
        );

    my $SendError = $ArticleBackendObject->ArticleGetTransmissionError(
        ArticleID => $Articles[1]->{ArticleID},
    );

    # Check if there is a transmission Error record.
    $Self->True(
        ($SendError),
        'New article transmission send error exists.',
    );

    return;
};

my $TestCreateNewTicket = sub {
    my ( $ReturnCode, $TicketID, ) = $ProcessEmail->();

    $Self->Is(
        $ReturnCode,
        1,
        'New ticket created.',
    );

    return;
};

my $TestCreateArticleExistentTicket = sub {

    my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');

    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket_Title',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );

    my $ArticleID = $ArticleBackendObject->ArticleSend(
        Body                 => 'Simple string',
        MimeType             => 'text/plain',
        From                 => 'unittest@example.org',
        To                   => 'unittest@example.com',
        TicketID             => $TicketID,
        SenderType           => 'customer',
        IsVisibleForCustomer => 1,
        HistoryType          => 'AddNote',
        HistoryComment       => 'note',
        Subject              => 'Unittest data',
        Charset              => 'utf-8',
        UserID               => 1,
    );

    $MailQueueSend->();

    my %Article = $ArticleBackendObject->ArticleGet(
        ArticleID => $ArticleID,
        TicketID  => $TicketID,
    );

    my ( $ReturnCode, ) = $ProcessEmail->( MessageID => $Article{MessageID} );

    $Self->Is(
        $ReturnCode,
        2,
        'New article created to an existent ticket.',
    );

    return $TicketID;
};

my $TestForceNewTicket = sub {
    my %Param = @_;

    my $TicketID = $Param{TicketID};

    # Close the current ticket.
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $Result       = $TicketObject->TicketStateSet(
        State    => 'closed successful',
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Result,
        "Ticket ${TicketID} successfully closed.",
    );

    # Change the config of the 'Raw' queue to create a new ticket in case of follow-up.
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my %Queue = $QueueObject->QueueGet( Name => 'Raw' );
    $Result = $QueueObject->QueueUpdate(
        %Queue,
        FollowUpID => 3,
        UserID     => 1,
    );

    $Self->True(
        $Result,
        "Raw queue successfuly changed to follow-up 'new-ticket'.",
    );

    # Process the e-mail
    my ( $ReturnCode, $NewTicketID, ) = $ProcessEmail->();
    $Self->Is(
        $ReturnCode,
        3,
        'New ticket created with follow-up "new-ticket".',
    );

    return;
};

my $TestDontReOpenClosedTicket = sub {
    my %Param = @_;

    # Change the config of the 'Raw' queue to reject in case of a follow-up.
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my %Queue       = $QueueObject->QueueGet( Name => 'Raw' );
    my $Result      = $QueueObject->QueueUpdate(
        %Queue,
        FollowUpID => 2,
        UserID     => 1,
    );

    $Self->True(
        $Result,
        "Raw queue successfuly changed to follow-up 'reject'.",
    );

    # Process the e-mail
    my ( $ReturnCode, $TicketID, ) = $ProcessEmail->();
    $Self->Is(
        $ReturnCode,
        4,
        'New article kept the ticket closed.',
    );

    return;
};

# RUN THE TESTS

# Ensure mail-queue is empty
$MailQueueObject->Delete();

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Force bounce e-mail to use always the normal follow-up flow.
$Helper->ConfigSettingChange(
    Key   => 'PostmasterBounceEmailAsFollowUp',
    Value => 1,
);

$TestCreateNewTicket->();
my $TicketID = $TestCreateArticleExistentTicket->();

# Don't force bounce e-mail to use always the normal follow-up flow.
$ConfigObject->Set(
    Key   => 'PostmasterBounceEmailAsFollowUp',
    Value => 0,
);

$TestForceNewTicket->(
    TicketID => $TicketID,
);
$TestDontReOpenClosedTicket->();

# cleanup is done by RestoreDatabase.

1;
