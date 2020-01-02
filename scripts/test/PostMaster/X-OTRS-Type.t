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
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Kernel::OM->Get('Kernel::System::Type')->TypeAdd(
    Name    => "X-OTRS-Type-Test",
    ValidID => 1,
    UserID  => 1,
);

# filter test
my @Tests = (
    {
        Name  => 'Valid ticket type (Unclassified)',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
X-OTRS-Type: Unclassified
Subject: Test

Some Content in Body',
        NewTicket => 1,
        Check     => {
            Type => 'Unclassified',
        }
    },
    {
        Name  => 'Valid ticket type (Unclassified)',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
X-OTRS-Type: X-OTRS-Type-Test
Subject: Test

Some Content in Body',
        NewTicket => 1,
        Check     => {
            Type => 'X-OTRS-Type-Test',
        }
    },
    {
        Name  => 'Invalid ticket type, ticket still needs to be created',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
X-OTRS-Type: Nonexisting
Subject: Test

Some Content in Body',
        NewTicket => 1,
        Check     => {
            Type => 'Unclassified',
        }
    },
);

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
        "#Filter Run() - NewTicket",
    );
    $Self->True(
        $Return[1] || 0,
        "#Filter  Run() - NewTicket/TicketID",
    );
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{Check} } ) {
        $Self->Is(
            $Ticket{$Key},
            $Test->{Check}->{$Key},
            "#Filter Run() - $Key",
        );
    }
}

# cleanup is done by RestoreDatabase.

1;
