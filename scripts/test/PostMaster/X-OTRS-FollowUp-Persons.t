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
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# ensure that the appropriate X-Headers are available in the config
my %NeededXHeaders = (
    'X-OTRS-FollowUp-OwnerID'       => 1,
    'X-OTRS-FollowUp-Owner'         => 1,
    'X-OTRS-FollowUp-ResponsibleID' => 1,
    'X-OTRS-FollowUp-Responsible'   => 1,
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

# set ticket hook
$ConfigObject->Set(
    Key   => 'Ticket::Hook',
    Value => 'Ticket#',
);
$ConfigObject->Set(
    Key   => 'Ticket::HookDivider',
    Value => '',
);

# ticket number is in subject on the left
$ConfigObject->Set(
    Key   => 'Ticket::SubjectFormat',
    Value => 'Left',
);

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent',
    Queue        => 'Junk',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'removed',
    CustomerUser => 'external@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$TicketID //= '';

$Self->True(
    $TicketID,
    "Ticket created - TicketID=$TicketID."
);

my %TestTicket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

my $UserRand;
TRY:
for my $Try ( 1 .. 20 ) {

    $UserRand = 'unittest-' . $Helper->GetRandomID();

    my $UserID = $UserObject->UserLookup(
        UserLogin => $UserRand,
    );

    last TRY if !$UserID;

    next TRY if $Try ne 20;

    $Self->True(
        0,
        'Find non existing user login.',
    );
}

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# add user
my $UserID = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand,
    UserEmail     => $UserRand . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$Self->True(
    $UserID,
    'UserAdd()',
);

# filter test
my @Tests = (
    {
        Name  => '#1 - Owner Test',
        Email => "From: Sender <sender\@example.com>
To: Some Name <recipient\@example.com>
Subject: [TNR] A simple question
X-OTRS-FollowUp-Owner: $UserRand

This is a multiline
email for server: example.tld

The IP address: 192.168.0.1
        ",
        Return => 2,    # it's a followup
        Check  => {
            Owner => $UserRand,
        },
    },
    {
        Name  => '#2 - OwnerID Test',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: [TNR] Another question
X-OTRS-FollowUp-OwnerID: 1

This is a multiline
email for server: example.tld

The IP address: 192.168.0.1
        ',
        Return => 2,    # it's a followup
        Check  => {
            OwnerID => 1,
        },
    },
    {
        Name  => '#3 - Responsible Test',
        Email => "From: Sender <sender\@example.com>
To: Some Name <recipient\@example.com>
Subject: [TNR] A simple question
X-OTRS-FollowUp-Responsible: $UserRand

This is a multiline
email for server: example.tld

The IP address: 192.168.0.1
        ",
        Return => 2,    # it's a followup
        Check  => {
            Responsible => $UserRand,
        },
    },
    {
        Name  => '#4 - ResponsibleID Test',
        Email => 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: [TNR] Another question
X-OTRS-FollowUp-ResponsibleID: 1

This is a multiline
email for server: example.tld

The IP address: 192.168.0.1
        ',
        Return => 2,    # it's a followup
        Check  => {
            ResponsibleID => 1,
        },
    },
);

my %TicketNumbers;
my %TicketIDs;

my $Index = 1;
for my $Test (@Tests) {
    my $Name  = $Test->{Name};
    my $Email = $Test->{Email};

    $Email =~ s{\[TNR\]}{[Ticket#$TestTicket{TicketNumber}]};

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

# new/clear ticket object
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# delete ticket
my $Delete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $Delete || 0,
    "#Filter TicketDelete()",
);

# cleanup is done by RestoreDatabase

1;
