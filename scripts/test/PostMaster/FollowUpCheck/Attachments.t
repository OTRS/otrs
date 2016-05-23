# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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
        RestoreDatabase => 1,
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
);

# First run the tests for a ticket that has the customer as an "unknown" customer.
for my $Test (@Tests) {
    my @Return;
    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            Email => \$Test->{Email},
            Debug => 2,
        );

        @Return = $PostMasterObject->Run();
    }
    $Self->Is(
        $Return[0] || 0,
        $Test->{NewTicket},
        "$Test->{Name} - article created",
    );
    $Self->True(
        $Return[1] || 0,
        "$Test->{Name} - article created",
    );
}

# cleanup is done by RestoreDatabase.

1;
