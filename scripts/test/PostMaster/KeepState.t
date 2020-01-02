# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::PostMaster;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# create the ticket that should get the followup
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);
my %MainTicket = $TicketObject->TicketGet(
    TicketID => $TicketID,
);

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get current XHeaders
my @XHeaders        = @{ $ConfigObject->Get('PostmasterX-Header') };
my $KeepStateHeader = $ConfigObject->Get('KeepStateHeader') || 'X-OTRS-FollowUp-State-Keep';

# make sure Keep state header is not in this list
@XHeaders = grep { $_ ne $KeepStateHeader } @XHeaders;

# make sure keep state header is in the extended list
my @ExtendedXHeaders = ( @XHeaders, $KeepStateHeader );

# set open to default followup state
$ConfigObject->Set(
    Key   => 'PostmasterDefaultState',
    Value => 'open'
);

my @Tests = (
    {
        Name            => 'XHeaders:Disabled State:New StateKeepXHeader:No',
        XHeaders        => \@XHeaders,
        InitialState    => 'new',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test24.box',
        ExpectedResults => 'new',
    },
    {
        Name            => 'XHeaders:Disabled State:Open StateKeepXHeader:No',
        XHeaders        => \@XHeaders,
        InitialState    => 'open',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test24.box',
        ExpectedResults => 'open',
    },
    {
        Name            => 'XHeaders:Disabled State:Closed StateKeepXHeader:No',
        XHeaders        => \@XHeaders,
        InitialState    => 'closed successful',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test24.box',
        ExpectedResults => 'open',
    },
    {
        Name            => 'XHeaders:Disabled State:New StateKeepXHeader:Yes',
        XHeaders        => \@XHeaders,
        InitialState    => 'new',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test25.box',
        ExpectedResults => 'new',
    },
    {
        Name            => 'XHeaders:Disabled State:Open StateKeepXHeader:Yes',
        XHeaders        => \@XHeaders,
        InitialState    => 'open',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test25.box',
        ExpectedResults => 'open',
    },
    {
        Name            => 'XHeaders:Disabled State:Closed StateKeepXHeader:Yes',
        XHeaders        => \@XHeaders,
        InitialState    => 'closed successful',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test25.box',
        ExpectedResults => 'open',
    },
    {
        Name            => 'XHeaders:Enabled State:New StateKeepXHeader:No',
        XHeaders        => \@ExtendedXHeaders,
        InitialState    => 'new',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test24.box',
        ExpectedResults => 'new',
    },
    {
        Name            => 'XHeaders:Enabled State:Open StateKeepXHeader:No',
        XHeaders        => \@ExtendedXHeaders,
        InitialState    => 'open',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test24.box',
        ExpectedResults => 'open',
    },
    {
        Name            => 'XHeaders:Enabled State:Closed StateKeepXHeader:No',
        XHeaders        => \@ExtendedXHeaders,
        InitialState    => 'closed successful',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test24.box',
        ExpectedResults => 'open',
    },
    {
        Name            => 'XHeaders:Enabled State:New StateKeepXHeader:Yes',
        XHeaders        => \@ExtendedXHeaders,
        InitialState    => 'new',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test25.box',
        ExpectedResults => 'new',
    },
    {
        Name            => 'XHeaders:Enabled State:Open StateKeepXHeader:Yes',
        XHeaders        => \@ExtendedXHeaders,
        InitialState    => 'open',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test25.box',
        ExpectedResults => 'open',
    },
    {
        Name            => 'XHeaders:Enabled State:Closed StateKeepXHeader:Yes',
        XHeaders        => \@ExtendedXHeaders,
        InitialState    => 'closed successful',
        Email           => '/scripts/test/sample/PostMaster/PostMaster-Test25.box',
        ExpectedResults => 'closed successful',
    },

);

# get main object
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

for my $Test (@Tests) {
    if ( $Test->{XHeaders} ) {
        $ConfigObject->Set(
            Key   => 'PostmasterX-Header',
            Value => $Test->{XHeaders},
        );
    }
    if ( $Test->{InitialState} ) {
        my $Success = $TicketObject->TicketStateSet(
            TicketID => $TicketID,
            State    => $Test->{InitialState},
            UserID   => 1,
        );
    }

    # read followup email
    my $Location   = $ConfigObject->Get('Home') . $Test->{Email};
    my $ContentRef = $MainObject->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Result   => 'ARRAY',
    );

    # set ticket number in mail subject to get a followup
    my @Content = ();
    for my $Line ( @{$ContentRef} ) {
        if ( $Line =~ /^Subject:/ ) {
            $Line = 'Subject: '
                . $ConfigObject->Get('Ticket::Hook')
                . $MainTicket{TicketNumber};
        }
        push @Content, $Line;
    }

    my @Return;

    # execute PostMaster with the read email
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
            Email                  => \@Content,
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

    # check we actually got followup
    $Self->Is(
        $Return[0] || 0,
        2,
        "$Test->{Name} Run() - FollowUp",
    );

    #check we actually got same TicketID
    $Self->Is(
        $Return[1] || 0,
        $MainTicket{TicketID},
        "$Test->{Name} Run() - FollowUp/TicketID",
    );

    # new/clear ticket object
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket (after followup)
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 0,
    );

    $Self->Is(
        $Ticket{State},
        $Test->{ExpectedResults},
        "$Test->{Name} Run() - State after FollowUp",
    );
}

# cleanup is done by RestoreDatabase
1;
