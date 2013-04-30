# --
# FollowUpPendingTime.t - PostMaster tests
# Copyright (C) 2003-2012 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::PostMaster;
use Kernel::System::PostMaster::Filter;
use Kernel::System::Ticket;
use Kernel::Config;

use Kernel::System::Time;

# create local config object
my $ConfigObject = Kernel::Config->new();

my $TimeObject = Kernel::System::Time->new( %{$Self} );

my %NeededXHeaders = (
    'X-OTRS-PendingTime' => 1,
    'X-OTRS-FollowUp-PendingTime' => 1,
);

my $XHeaders          = $ConfigObject->Get('PostmasterX-Header');
my @PostmasterXHeader = @{$XHeaders};
HEADER:
for my $Header ( sort keys %NeededXHeaders ) {
    next HEADER if ( grep $_ eq $Header, @PostmasterXHeader );
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
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'                      => 'pending reminder',
            'X-OTRS-State-PendingTime'          => '2021-01-01 00:00:00',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '2022-01-01 00:00:00',
        },
        CheckNewTicket => {
            RealTillTimeNotUsed => $TimeObject->TimeStamp2SystemTime(
                String => '2021-01-01 00:00:00'
            ),
        },
        CheckFollowUp => {
            RealTillTimeNotUsed => $TimeObject->TimeStamp2SystemTime(
                String => '2022-01-01 00:00:00'
            ),
        },
    },
    {
        Name  => 'Regular pending time test, wrong date',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'             => 'pending reminder',
            'X-OTRS-State-PendingTime' => '2022-01- 00:00:00',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '2022-01- 00:00:00',
        },
        CheckNewTicket => {
            RealTillTimeNotUsed => 0,
        },
        CheckFollowUp => {
            RealTillTimeNotUsed => 0,
        },
    },
    {
        Name  => 'Relative pending time test seconds',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'             => 'pending reminder',
            'X-OTRS-State-PendingTime' => '+60s',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '+30s',
        },
        CheckNewTicket => {
            UntilTime => 60,
        },
        CheckFollowUp => {
            UntilTime => 30,
        },
    },
    {
        Name  => 'Relative pending time test implicit seconds',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'             => 'pending reminder',
            'X-OTRS-State-PendingTime' => '+60',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '+30',
        },
        CheckNewTicket => {
            UntilTime => 60,
        },
        CheckFollowUp => {
            UntilTime => 30,
        },
    },
    {
        Name  => 'Relative pending time test implicit seconds no sign',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'             => 'pending reminder',
            'X-OTRS-State-PendingTime' => '60',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '30',
        },
        CheckNewTicket => {
            UntilTime => 60,
        },
        CheckFollowUp => {
            UntilTime => 30,
        },
    },
    {
        Name  => 'Relative pending time test minutes',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'             => 'pending reminder',
            'X-OTRS-State-PendingTime' => '+60m',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '+30m',
        },
        CheckNewTicket => {
            UntilTime => 60 * 60,
        },
        CheckFollowUp => {
            UntilTime => 30 * 60,
        },
    },
    {
        Name  => 'Relative pending time test hours',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'             => 'pending reminder',
            'X-OTRS-State-PendingTime' => '+60h',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '+30h',
        },
        CheckNewTicket => {
            UntilTime => 60 * 60 * 60,
        },
        CheckFollowUp => {
            UntilTime => 30 * 60 * 60,
        },
    },
    {
        Name  => 'Relative pending time test days',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'             => 'pending reminder',
            'X-OTRS-State-PendingTime' => '+60d',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '+30d',
        },
        CheckNewTicket => {
            UntilTime => 60 * 60 * 60 * 24,
        },
        CheckFollowUp => {
            UntilTime => 30 * 60 * 60 * 24,
        },
    },
    {
        Name  => 'Relative pending time test, invalid unit',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'             => 'pending reminder',
            'X-OTRS-State-PendingTime' => '+30y',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '+30y',
        },
        CheckNewTicket => {
            UntilTime => 0,
        },
        CheckFollowUp => {
            UntilTime => 0,
        },
    },
    {
        Name  => 'Relative pending time test, invalid unit',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'             => 'pending reminder',
            'X-OTRS-State-PendingTime' => '+30y',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '+30y',
        },
        CheckNewTicket => {
            UntilTime => 0,
        },
        CheckFollowUp => {
            UntilTime => 0,
        },
    },
    {
        Name  => 'Relative pending time test, invalid combination',
        Match => {
            From => 'sender@example.com',
        },
        Set => {
            'X-OTRS-State'             => 'pending reminder',
            'X-OTRS-State-PendingTime' => '+30s +30m',
            'X-OTRS-FollowUp-State'             => 'pending reminder',
            'X-OTRS-FollowUp-State-PendingTime' => '+30s +30m',
        },
        CheckNewTicket => {
            UntilTime => 0,
        },
        CheckFollowUp => {
            UntilTime => 0,
        },
    },
);

# set filter
my $PostMasterFilter = Kernel::System::PostMaster::Filter->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

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
            %{$Self},
            ConfigObject => $ConfigObject,
            Email        => \$Email,
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

    # new/clear ticket object
    my $TicketObject = Kernel::System::Ticket->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{CheckNewTicket} } ) {

        # fuzzy check
        if ( $Key eq 'UntilTime' ) {
            $Self->True(
                abs( $Ticket{$Key} - $Test->{CheckNewTicket}->{$Key} ) < 5,
                "$Test->{Name} - NewTicket - Check result value $Key does not differ more than 5s",
            );
        }

        # exact check
        else {
            $Self->Is(
                $Ticket{$Key},
                $Test->{CheckNewTicket}->{$Key},
                "$Test->{Name} - NewTicket - Check result value $Key",
            );
        }
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
            %{$Self},
            ConfigObject => $ConfigObject,
            Email        => \$Email2,
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

    # new/clear ticket object
    $TicketObject = Kernel::System::Ticket->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );
    %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{CheckFollowUp} } ) {

        # fuzzy check
        if ( $Key eq 'UntilTime' ) {
            $Self->True(
                abs( $Ticket{$Key} - $Test->{CheckFollowUp}->{$Key} ) < 5,
                "$Test->{Name} - FollowUp - Check result value $Key does not differ more than 5s",
            );
        }

        # exact check
        else {
            $Self->Is(
                $Ticket{$Key},
                $Test->{CheckFollowUp}->{$Key},
                "$Test->{Name} - FollowUp - Check result value $Key",
            );
        }
    }

    # delete ticket
    my $Delete = $TicketObject->TicketDelete(
        TicketID => $Return[1],
        UserID   => 1,
    );
    $Self->True(
        $Delete || 0,
        "$Test->{Name} - TicketDelete()",
    );

    $ConfigObject->Set(
        Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
        Value => undef,
    );
}

1;
