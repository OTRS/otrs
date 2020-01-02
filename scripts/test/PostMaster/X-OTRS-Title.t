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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

# ensure that the appropriate X-Headers are available in the config
my %NeededXHeaders = (
    'X-OTRS-Title'          => 1,
    'X-OTRS-FollowUp-Title' => 1,
);

my $XHeaders          = $ConfigObject->Get('PostmasterX-Header');
my @PostmasterXHeader = @{$XHeaders};

HEADER:
for my $Header ( sort keys %NeededXHeaders ) {
    next HEADER if ( grep { $_ eq $Header } @PostmasterXHeader );
    push @PostmasterXHeader, $Header;
}

$ConfigObject->Set(
    Key   => 'PostmasterX-Header',
    Value => \@PostmasterXHeader
);

# filter test
my @Tests = (
    {
        Name  => '#1 - Body Test',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: A simple question
X-OTRS-Title: UnitTest-1

This is a multiline
email for server: example.tld

The IP address: 192.168.0.1
        ',
        Return => 1,    # it's a new ticket
        Check  => {
            Title => 'UnitTest-1',
        },
    },
    {
        Name  => '#2 - Subject Test',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: [#1] Another question
X-OTRS-FollowUp-Title: UnitTest-1 - Response 1

This is a multiline
email for server: example.tld

The IP address: 192.168.0.1
        ',
        Return => 2,    # it's a followup
        Check  => {
            Title => 'UnitTest-1 - Response 1',
        },
    },
);

my %TicketNumbers;
my %TicketIDs;

my $Index = 1;
for my $Test (@Tests) {
    my $Name  = $Test->{Name};
    my $Email = $Test->{Email};

    $Email =~ s{\[#([0-9]+)\]}{[Ticket#$TicketNumbers{$1}]};

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
            Email                  => \$Email,
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
        $Test->{Return},
        "$Name - NewTicket/FollowUp",
    );
    $Self->True(
        $Return[1] || 0,
        "$Name - TicketID",
    );

    # new/clear ticket object
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{Check} } ) {
        $Self->Is(
            $Ticket{$Key},
            $Test->{Check}->{$Key},
            "Run('$Test->{Name}') - $Key",
        );
    }

    $TicketNumbers{$Index} = $Ticket{TicketNumber};
    $TicketIDs{ $Return[1] }++;

    $Index++;
}

for my $TicketID ( sort keys %TicketIDs ) {

    # new/clear ticket object
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # delete ticket
    my $Delete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );

    $Self->True(
        $Delete || 0,
        "#Filter TicketDelete()",
    );
}

# cleanup is done by RestoreDatabase

1;
