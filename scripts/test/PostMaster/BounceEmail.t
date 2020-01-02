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

    my $Email = $Param{Email} || $BounceEmail->(%Param);

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );
    $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

    my $PostMasterObject = Kernel::System::PostMaster->new(
        CommunicationLogObject => $CommunicationLogObject,
        Email                  => $Email,
        Debug                  => 2,
    );

    my ( $ReturnCode, $TicketID ) = $PostMasterObject->Run();

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Message',
        Status        => 'Successful',
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
    my %Queue       = $QueueObject->QueueGet( Name => 'Raw' );
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

my $TestOriginalEmailAsAttachmentShouldNotBounce = sub {

    # Change the config of the 'Raw' queue to possible in case of a follow-up.
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my %Queue       = $QueueObject->QueueGet( Name => 'Raw' );
    my $Result      = $QueueObject->QueueUpdate(
        %Queue,
        FollowUpID => 1,
        UserID     => 1,
    );

    $Self->True(
        $Result,
        "Raw queue successfuly changed to follow-up 'possible'.",
    );

    my ( $ReturnCode, $TicketID, ) = $ProcessEmail->(
        Email => q{From: =?utf-8?B?eHB0bw?= <dummy@example.com>
Content-Type: text/plain;
    charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: original
X-Universally-Unique-Identifier: 80717B49-3608-470A-8C5B-38DBB63375F7
Message-Id: <E5CEC0EA-2569-48E3-A47E-B01E78F1A409@example.com>
Date: Thu, 8 Nov 2018 23:38:16 +0100
To: =?utf-8?B?eHB0bw?= <dummy2@example.com>

something},
    );

    $Self->Is(
        $ReturnCode,
        1,
        'Original email - New ticket created.',
    );

    ( $ReturnCode, $TicketID, ) = $ProcessEmail->(
        Email => q{Return-Path: <dummy@example.com>
Received: from [172.17.234.195] (p5B283A6B.dip0.t-ipconnect.de. [91.40.58.107])
        by smtp.example.com with ESMTPSA id p16-v6sm7861105wro.29.2018.11.08.14.39.35
        for <dummy2@example.com>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 14:39:35 -0800 (PST)
From: =?utf-8?B?eHB0bw?= <dummy@example.com>
Content-Type: multipart/mixed;
    boundary="Apple-Mail=_E2B0EF7A-9E43-470C-AC46-2FDA496697AF"
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: original as attachment
Message-Id: <A3CE5E53-2501-4A47-9E48-ACB6137B9E96@example.com>
Date: Thu, 8 Nov 2018 23:39:34 +0100
To: =?utf-8?B?eHB0bw?= <dummy2@example.com>
X-Mailer: Apple Mail (2.3445.9.1)


--Apple-Mail=_E2B0EF7A-9E43-470C-AC46-2FDA496697AF
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
    charset=us-ascii

it shouldn't be considered as bounce


--Apple-Mail=_E2B0EF7A-9E43-470C-AC46-2FDA496697AF
Content-Disposition: attachment;
    filename=original.eml
Content-Type: message/rfc822;
    x-mac-hide-extension=yes;
    x-unix-mode=0666;
    name="original.eml"
Content-Transfer-Encoding: 7bit

Delivered-To: dummy2@example.com
Received: by 2002:a17:906:4cca:0:0:0:0 with SMTP id q10-v6csp51694ejt;
        Thu, 8 Nov 2018 14:38:18 -0800 (PST)
X-Received: by 2002:a1c:b513:: with SMTP id e19-v6mr2606301wmf.114.1541716698766;
        Thu, 08 Nov 2018 14:38:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1541716698; cv=none;
        d=example.com; s=arc-20160816;
        b=GKpdbTMPvynmnz2/9zlJFSQgGyZWvtnqzUcwDfnG1mBKc/lbf6Iedn2u7CBnZ7+vJT
         0rtTY+sJZYPj2Ffu0UuwSqdoOWr961ycEgy3ha4gkh6B/PexKAJjiEzJsTgxeztJxWqu
         QPzDrsbwD1WjSERQdvXEytML7kuNzi1WDQhNSUZMQC1F4qkgm5OXF4Fyt3TsdCFQeIs0
         hk1YLCvlmTKczy5j5LqnDheY1EBJ5rnHImozE/6KB73vWded4wqe8VawI8+DuWavOim+
         xyDd20hKwdDO12xxIMHGMmgmyvsWoqaTLod2Mx1hl8bJpf8nGXztip3Nv9C9Ye223XmC
         E8UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=example.com; s=arc-20160816;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:dkim-signature;
        bh=RarS/pY26SoZ9t7u+csjkoR6wz1tPUsfs26574w9WmY=;
        b=hNikgXfZ4KJoOFMZHaGNbFnfhxce8wz4VRHOIW10ZDpSeBzpw//YMdpe+UBMu8LvXn
         0LwjBh09QTHJxPazpm9Ibi5nlI5KsWkEQKr9Nd7bAaH/POA16O+ChcyCSrZMFD6qc9qu
         dAAIkOyZfoCWCeo8/hK+8YiEa6u2yugqJ8ynbh7kWEbfkA3Ymp3wqdYhjuWVffT7CfKW
         ZPh7dJDfs9ADaAFmZ/FIpD8uU/Ts9M0duNlncslRj8bRcYD8glp3qiU6CPDT2u1EQALY
         u9zrBo7e+m1itlnmanY6M/tVDFvlrVChdrHaffCrbXIxnD07ok+eeqWRoumdqYdxw0IO
         /umg==
ARC-Authentication-Results: i=1; mx.example.com;
       dkim=pass header.i=@example.com header.s=20161025 header.b=RJNz7oaY;
       spf=pass (example.com: domain of dummy@example.com designates 209.85.220.41 as permitted sender) smtp.mailfrom=dummy@example.com;
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=example.com
Return-Path: <dummy@example.com>
Received: from mail-sor-f41.example.com (mail-sor-f41.example.com. [209.85.220.41])
        by mx.example.com with SMTPS id j3-v6sor4060253wrq.14.2018.11.08.14.38.18
        for <dummy2@example.com>
        (Google Transport Security);
        Thu, 08 Nov 2018 14:38:18 -0800 (PST)
Received-SPF: pass (example.com: domain of dummy@example.com designates 209.85.220.41 as permitted sender) client-ip=209.85.220.41;
Authentication-Results: mx.example.com;
       dkim=pass header.i=@example.com header.s=20161025 header.b=RJNz7oaY;
       spf=pass (example.com: domain of dummy@example.com designates 209.85.220.41 as permitted sender) smtp.mailfrom=dummy@example.com;
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=example.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=example.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=RarS/pY26SoZ9t7u+csjkoR6wz1tPUsfs26574w9WmY=;
        b=RJNz7oaYizzixehKFhR+GdHUVUQWzvfo/yLl6jRPwMtmUlvpfqwCotAUSsaxWKJPG2
         GsPkd1dQYIK/Ebx6Jwh3mOfLa183M51kBDGHDpr8Y9/S78sJGJXRu6jhsjCSjufHExOK
         IFRl7AB9ZKEtwjekOTPoPX9/bhJwtMRaUzlG29G3f6wqHbbBQRF9DpbiUEvnoMXFBmwm
         7Q4+lM1Q0z+7Y5KRe28IVVYfNorKtGi1zxn1H3GdHf+t29VserpWnFiA92bliXL+UVxp
         +2Pk0kljrX+6lrO3q6SFHdR5fbRZmG7S4c4VjoGW3i5ZJh0Q+dr2ATvdQcp9Pp5mvnOt
         FrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=RarS/pY26SoZ9t7u+csjkoR6wz1tPUsfs26574w9WmY=;
        b=f2k0rz6q8Pd6e/0Phor8WXWR1Ql7j7YvJSNoRRSb+OEjhRXzCesp+iVVcc00ZPqo0b
         aAADjNxOx2Jj/8c8CBDM1HDHl4LZ1IGfB+2O6i1L0mqF+apObbqZK+VgGfeVnDlwF+KJ
         f7pyW3+8C8FrXeJTTkwkNGo0X1METvzs3pVs3EXauRgSJVXqzuzH/0EXy7VBlfLGcjkL
         AnZu6UNeI+QzGlcohwvIRbWpCmkshyJTdZeTNtwgZ4WVhuBAMPmPRRFweI024Uh0tp3k
         I74cWt1qy5pgAqPv8sQqAO0gk6QXNmekDaZubY5IopoW0crRc9imDggIG3WOVLvhGY++
         hRmg==
X-Gm-Message-State: AGRZ1gLAnFaJcDjt4iRW4PzS0X0QnTQ5BLx/Lm2RrO+yM8tDnEDTtZsQ
    HeAwyUhDqOUQ00M5A8jLXaTYMrbop30=
X-Google-Smtp-Source: AJdET5co4A/o4N85mjHvSmpBbQe/DDaQewbpIO0i+QRaD4T9MUA4sPyR1kwTezrIJuz/b01z2Lq85A==
X-Received: by 2002:adf:f68e:: with SMTP id v14-v6mr5304235wrp.261.1541716698186;
        Thu, 08 Nov 2018 14:38:18 -0800 (PST)
Return-Path: <dummy@example.com>
Received: from [172.17.234.195] (p5B283A6B.dip0.t-ipconnect.de. [91.40.58.107])
        by smtp.example.com with ESMTPSA id v11-v6sm4030321wrt.40.2018.11.08.14.38.17
        for <dummy2@example.com>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 14:38:17 -0800 (PST)
From: =?utf-8?B?QW5kcsOpIEJyw6Fz?= <dummy@example.com>
Content-Type: text/plain;
    charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: original
Message-Id: <E5CEC0EA-2569-48E3-A47E-B01E78F1A409@example.com>
Date: Thu, 8 Nov 2018 23:38:16 +0100
To: =?utf-8?B?eHB0bw?= <dummy2@example.com>
X-Mailer: Apple Mail (2.3445.9.1)

something

--Apple-Mail=_E2B0EF7A-9E43-470C-AC46-2FDA496697AF--},
    );

    $Self->Is(
        $ReturnCode,
        1,
        'Original email as attachment - New ticket created.',
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
$TestOriginalEmailAsAttachmentShouldNotBounce->();

# cleanup is done by RestoreDatabase.

1;
