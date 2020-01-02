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
my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Helper->FixedTimeSet();

my %NeededXHeaders = (
    'X-OTRS-PendingTime'          => 1,
    'X-OTRS-FollowUp-PendingTime' => 1,
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
        Name  => 'Regular pending time test',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '2021-01-01 00:00:00',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '2022-01-01 00:00:00',
            },
        ],
        CheckNewTicket => {
            RealTillTimeNotUsed => $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => '2021-01-01 00:00:00',
                }
            )->ToEpoch(),
        },
        CheckFollowUp => {
            RealTillTimeNotUsed => $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => '2022-01-01 00:00:00',
                }
            )->ToEpoch(),
        },
    },
    {
        Name  => 'Regular pending time test, wrong date',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '2022-01- 00:00:00',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '2022-01- 00:00:00',
            },
        ],
        CheckNewTicket => {
            RealTillTimeNotUsed => 0,
        },
        CheckFollowUp => {
            RealTillTimeNotUsed => 0,
        },
    },
    {
        Name  => 'Relative pending time test seconds',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '+60s',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '+30s',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60,
        },
        CheckFollowUp => {
            UntilTime => 30,
        },
    },
    {
        Name  => 'Relative pending time test implicit seconds',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '+60s',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '+30s',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60,
        },
        CheckFollowUp => {
            UntilTime => 30,
        },
    },
    {
        Name  => 'Relative pending time test implicit seconds no sign',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '60',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '30',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60,
        },
        CheckFollowUp => {
            UntilTime => 30,
        },
    },
    {
        Name  => 'Relative pending time test minutes',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '+60m',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '+30m',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60 * 60,
        },
        CheckFollowUp => {
            UntilTime => 30 * 60,
        },
    },
    {
        Name  => 'Relative pending time test hours',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '+60h',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '+30h',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60 * 60 * 60,
        },
        CheckFollowUp => {
            UntilTime => 30 * 60 * 60,
        },
    },
    {
        Name  => 'Relative pending time test days',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '+60d',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '+30d',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60 * 60 * 60 * 24,
        },
        CheckFollowUp => {
            UntilTime => 30 * 60 * 60 * 24,
        },
    },
    {
        Name  => 'Relative pending time test, invalid unit',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '+60y',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '+30y',
            },
        ],
        CheckNewTicket => {
            UntilTime => 0,
        },
        CheckFollowUp => {
            UntilTime => 0,
        },
    },
    {
        Name  => 'Relative pending time test, invalid unit',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '+30y',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '+30y',
            },
        ],
        CheckNewTicket => {
            UntilTime => 0,
        },
        CheckFollowUp => {
            UntilTime => 0,
        },
    },
    {
        Name  => 'Relative pending time test, invalid combination',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTRS-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-State-PendingTime',
                Value => '+30s +30m',
            },
            {
                Key   => 'X-OTRS-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTRS-FollowUp-State-PendingTime',
                Value => '+30s +30m',
            },
        ],
        CheckNewTicket => {
            UntilTime => 0,
        },
        CheckFollowUp => {
            UntilTime => 0,
        },
    },
);

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);
$CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

for my $Test (@Tests) {

    $ConfigObject->Set(
        Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
        Value => {
            %{$Test},
            Module => 'Kernel::System::PostMaster::Filter::Match',
        },
    );

    my $Email = 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: some subject

Some Content in Body
';

    my @Return;
    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            CommunicationLogObject => $CommunicationLogObject,
            Email                  => \$Email,
        );

        @Return = $PostMasterObject->Run();
    }
    $Self->Is(
        $Return[0] || 0,
        1,
        "$Test->{Name} - Create new ticket",
    );

    $Self->True(
        $Return[1] || 0,
        "$Test->{Name} - Create new ticket (TicketID)",
    );

    my $TicketID = $Return[1];

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{CheckNewTicket} } ) {
        $Self->Is(
            $Ticket{$Key},
            $Test->{CheckNewTicket}->{$Key},
            "$Test->{Name} - NewTicket - Check result value $Key",
        );
    }

    my $Subject = 'Subject: ' . $TicketObject->TicketSubjectBuild(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => 'test',
    );

    my $Email2 = "From: Sender <sender\@example.com>
To: Some Name <recipient\@example.com>
$Subject

Some Content in Body
";

    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            CommunicationLogObject => $CommunicationLogObject,
            Email                  => \$Email2,
        );

        @Return = $PostMasterObject->Run();
    }

    $Self->Is(
        $Return[0] || 0,
        2,
        "$Test->{Name} - Create follow up ticket",
    );
    $Self->True(
        $Return[1] || 0,
        "$Test->{Name} - Create follow up ticket (TicketID)",
    );
    $Self->Is(
        $Return[1],
        $TicketID,
        "$Test->{Name} - Create follow up ticket (TicketID of original ticket)",
    );

    %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{CheckFollowUp} } ) {
        $Self->Is(
            $Ticket{$Key},
            $Test->{CheckFollowUp}->{$Key},
            "$Test->{Name} - FollowUp - Check result value $Key",
        );
    }

    $ConfigObject->Set(
        Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
        Value => undef,
    );
}

$CommunicationLogObject->ObjectLogStop(
    ObjectLogType => 'Message',
    Status        => 'Successful',
);
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

# cleanup is done by RestoreDatabase.

1;
