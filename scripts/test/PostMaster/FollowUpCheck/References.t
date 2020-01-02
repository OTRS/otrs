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

# $ConfigObject->Set(
#     Key   => 'PostMaster::CheckFollowUpModule',
#     Value => {
#         '0400-Attachments' => {
#             Module => 'Kernel::System::PostMaster::FollowUpCheck::Attachments',
#             }
#         }
# );
#

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

# filter test
my @Tests = (
    {
        Name  => 'First article, new ticket',
        Email => <<'EOF',
From: Customer <test@example.com>
To: Agent <agent@example.com>
Message-ID: <message_followupcheck_references@example.com>
Subject: Test

Some Content in Body
$Subject
EOF
        NewTicket => 1,
    },
    {
        Name  => 'Followup article',
        Email => <<'EOF',
From: Customer <test@example.com>
To: Agent <agent@example.com>
References: <message_followupcheck_references@example.com>
Subject: Test2

Some Content in Body
$Subject
EOF
        NewTicket => 2,
    },

);

my $TicketID;

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
    $Self->True(
        $Return[1] || 0,
        "$Test->{Name} - article created",
    );
}

# cleanup is done by RestoreDatabase.

1;
