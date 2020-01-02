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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'PostMaster::CheckFollowUpModule',
    Value => {
        '0400-Attachments' => {
            Module => 'Kernel::System::PostMaster::FollowUpCheck::Attachments',
        }
    }
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
$Helper->FixedTimeSet();

my $AgentAddress    = 'agent@example.com';
my $CustomerAddress = 'external@example.com';
my $InternalAddress = 'internal@example.com';

# create a new ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'external@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    "TicketCreate()",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

my $Subject = $TicketObject->TicketSubjectBuild(
    TicketNumber => $Ticket{TicketNumber},
    Subject      => 'test',
);

# filter test
my @Tests = (
    {
        Name  => 'Ticket number in body, no attachments (new ticket)',
        Email => <<EOF,
From: Customer <$CustomerAddress>
To: Agent <$AgentAddress>
Subject: Test

Some Content in Body
$Subject
EOF
        NewTicket => 1,
    },
    {
        Name  => 'Ticket number in body of HTML email, no attachments (new ticket)',
        Email => <<EOF,
From: Customer <$CustomerAddress>
To: Agent <$AgentAddress>
Content-Type: text/html; charset="iso-8859-1"; format=flowed
Subject: Test

Some Content in Body<br/>
$Subject
EOF
        NewTicket => 1,
    },
    {
        Name  => 'Plain email, ticket number in body, attachment without ticket number (new ticket)',
        Email => <<EOF,
Date: Thu, 21 Jun 2012 17:06:27 +0200
From: "Peter Pruchnerovic - MALL.cz" <peter.pruchnerovic\@mall.cz>
MIME-Version: 1.0
To: testqueue\@mall.cz
Subject: TRT
Content-Type: multipart/mixed;
 boundary="------------060303050306010608070702"

This is a multi-part message in MIME format.
--------------060303050306010608070702
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

$Subject

--------------060303050306010608070702
Content-Type: text/plain;
 name="test.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="test.txt"

Some text
--------------060303050306010608070702
EOF
        NewTicket => 1,
    },
    {
        Name  => 'Plain email, attachment with ticket number',
        Email => <<EOF,
Date: Thu, 21 Jun 2012 17:06:27 +0200
From: "Peter Pruchnerovic - MALL.cz" <peter.pruchnerovic\@mall.cz>
MIME-Version: 1.0
To: testqueue\@mall.cz
Subject: TRT
Content-Type: multipart/mixed;
 boundary="------------060303050306010608070702"

This is a multi-part message in MIME format.
--------------060303050306010608070702
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Test message body

--------------060303050306010608070702
Content-Type: text/plain;
 name="test.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="test.txt"

$Subject
--------------060303050306010608070702
EOF
        NewTicket => 2,
    },
    {
        Name  => 'HTML email, body with ticket number',
        Email => <<EOF,
Content-Type: multipart/alternative; boundary="Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10"
Subject: test multipart/mixed HTML
Date: Fri, 9 Sep 2016 09:03:57 +0200
To: test\@home.com
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
X-Mailer: Apple Mail (2.3124)


--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
    charset=utf-8

$Subject

--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10
Content-Type: multipart/mixed;
    boundary="Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655"


--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Transfer-Encoding: 7bit
Content-Type: text/html;
    charset=us-ascii

<html><head><meta http-equiv="Content-Type" content="text/html charset=us-ascii"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class="">$Subject<div class=""><br class=""></div><div class=""></div></body></html>
--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Disposition: attachment;
    filename=1.txt
Content-Type: text/plain;
    name="1.txt"
Content-Transfer-Encoding: 7bit

1

--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Transfer-Encoding: 8bit
Content-Type: text/html;
    charset=utf-8

<html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><div class=""></div><div class=""><br class=""></div><div class="">$Subject</div></body></html>
--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655--

--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10--

EOF
        NewTicket => 1,
    },

    {
        Name  => 'HTML email, attachment with ticket number',
        Email => <<EOF,
Content-Type: multipart/alternative; boundary="Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10"
Subject: test multipart/mixed HTML
Date: Fri, 9 Sep 2016 09:03:57 +0200
To: test\@home.com
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
X-Mailer: Apple Mail (2.3124)


--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
    charset=utf-8

first part

--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10
Content-Type: multipart/mixed;
    boundary="Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655"


--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Transfer-Encoding: 7bit
Content-Type: text/html;
    charset=us-ascii

<html><head><meta http-equiv="Content-Type" content="text/html charset=us-ascii"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class="">first part<div class=""><br class=""></div><div class=""></div></body></html>
--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Disposition: attachment;
    filename=1.txt
Content-Type: text/plain;
    name="1.txt"
Content-Transfer-Encoding: 7bit

$Subject

--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655
Content-Transfer-Encoding: 8bit
Content-Type: text/html;
    charset=utf-8

<html><head><meta http-equiv="Content-Type" content="text/html charset=utf-8"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""><div class=""></div><div class=""><br class=""></div><div class="">second part</div></body></html>
--Apple-Mail=_8BFFBEE6-E8BD-46DF-A006-75CAE6571655--

--Apple-Mail=_BA4B97EF-C2DC-42FB-BF6F-A71DBDC93F10--

EOF
        NewTicket => 2,
    },
);

# First run the tests for a ticket that has the customer as an "unknown" customer.
for my $Test (@Tests) {
    my @Return;
    {
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
            Email                  => \$Test->{Email},
            Debug                  => 2,
        );

        @Return = $PostMasterObject->Run();

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Successful',
        );
        $CommunicationLogObject->CommunicationStop(
            Status => 'Successful',
        );
    }
    $Self->Is(
        $Return[0] || 0,
        $Test->{NewTicket},
        "$Test->{Name} - article created",
    );

    if ( $Test->{NewTicket} == 1 ) {
        $Self->IsNot(
            $Return[1] || 0,
            $Ticket{TicketID},
            "$Test->{Name} - new ticket created",
        );
    }
    else {
        $Self->Is(
            $Return[1] || 0,
            $Ticket{TicketID},
            "$Test->{Name} - follow-up created",
        );

    }
}

# cleanup is done by RestoreDatabase.

1;
