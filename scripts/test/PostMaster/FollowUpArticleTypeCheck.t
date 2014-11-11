# --
# FollowUpArticleTypeCheck.t - FollowUpArticleTypeCheck tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::PostMaster;
use Kernel::System::Ticket;

use Kernel::System::UnitTest::Helper;

# create local objects
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

$HelperObject->FixedTimeSet();

# create local config object
my $ConfigObject = Kernel::Config->new();

# new/clear ticket object
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

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
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    "TicketCreate()",
);

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'email-external',
    SenderType     => 'customer',
    From           => "Customer <$CustomerAddress>",
    To             => "Agent <$AgentAddress>",
    Subject        => 'subject',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'NewTicket',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,                                   # if you don't want to send agent notifications
);

$Self->True(
    $ArticleID,
    "ArticleCreate()",
);

$ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'email-internal',
    SenderType     => 'agent',
    From           => "Agent <$AgentAddress>",
    To             => "Provider <$InternalAddress>",
    Subject        => 'subject',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'NewTicket',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,                                   # if you don't want to send agent notifications
);

$Self->True(
    $ArticleID,
    "ArticleCreate()",
);
my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

my $Subject = 'Subject: ' . $TicketObject->TicketSubjectBuild(
    TicketNumber => $Ticket{TicketNumber},
    Subject      => 'test',
);

# filter test
my @Tests = (

    # regular response
    {
        Name  => 'Customer response',
        Email => "From: Customer <$CustomerAddress>
To: Agent <$AgentAddress>
Subject: $Subject

Some Content in Body",
        Check => {
            ArticleType => 'email-external',
            SenderType  => 'customer',
        },
        JobConfig => {
            ArticleType => 'email-internal',
            Module      => 'Kernel::System::PostMaster::Filter::FollowUpArticleTypeCheck',
            SenderType  => 'customer',
        },
    },

    # response to internal address, must be made internal
    {
        Name  => 'Provider response',
        Email => "From: Provider <$InternalAddress>
To: Agent <$AgentAddress>
Subject: $Subject

Some Content in Body",
        Check => {
            ArticleType => 'email-internal',
            SenderType  => 'customer',
        },
        JobConfig => {
            ArticleType => 'email-internal',
            Module      => 'Kernel::System::PostMaster::Filter::FollowUpArticleTypeCheck',
            SenderType  => 'customer',
        },
    },

    # another regular response
    {
        Name  => 'Customer response 2',
        Email => "From: Customer <$CustomerAddress>
To: Agent <$AgentAddress>
Subject: $Subject

Some Content in Body",
        Check => {
            ArticleType => 'email-external',
            SenderType  => 'customer',
        },
        JobConfig => {
            ArticleType => 'email-internal',
            Module      => 'Kernel::System::PostMaster::Filter::FollowUpArticleTypeCheck',
            SenderType  => 'customer',
        },
    },

    # response from internal address and "system" sender type
    # this must be unchanged, and previous articles as well (see bug#10182)
    {
        Name  => 'Provider notification',
        Email => "From: Provider <$InternalAddress>
To: Agent <$AgentAddress>
X-OTRS-FollowUp-ArticleType: note-report
X-OTRS-FollowUp-SenderType: system
Subject: $Subject

Some Content in Body",
        Check => {
            ArticleType => 'note-report',
            SenderType  => 'system',
        },
        JobConfig => {
            ArticleType => 'email-internal',
            Module      => 'Kernel::System::PostMaster::Filter::FollowUpArticleTypeCheck',
            SenderType  => 'customer',
        },
    },
);

for my $Test (@Tests) {

    $ConfigObject->Set(
        Key   => 'PostMaster::PostFilterModule',
        Value => {},
    );

    $ConfigObject->Set(
        Key   => 'PostMaster::PostFilterModule',
        Value => {
            '000-FollowUpArticleTypeCheck' => {
                %{ $Test->{JobConfig} }
            },
        },
    );

    # Get current state of articles
    my @ArticleBoxOriginal = $TicketObject->ArticleGet(
        TicketID => $TicketID,
    );

    my @Return;
    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            %{$Self},
            ConfigObject => $ConfigObject,
            Email        => \$Test->{Email},
            Debug        => 2,
        );

        @Return = $PostMasterObject->Run();
    }
    $Self->Is(
        $Return[0] || 0,
        2,
        "$Test->{Name} - Follow up created",
    );
    $Self->True(
        $Return[1] || 0,
        "$Test->{Name} - Follow up TicketID",
    );

    # Get state of old articles after udpate
    my @ArticleBoxUpdate = $TicketObject->ArticleGet(
        TicketID => $TicketID,
        Limit    => scalar @ArticleBoxOriginal,
    );

    # Make sure that old articles were not changed
    $Self->IsDeeply(
        \@ArticleBoxUpdate,
        \@ArticleBoxOriginal,
        "$Test->{Name} - old articles unchanged"
    );

    my @Article = $TicketObject->ArticleGet(
        TicketID => $Return[1],
        Order    => 'DESC',
        Limit    => 1,
    );

    for my $Key ( sort keys %{ $Test->{Check} } ) {
        $Self->Is(
            $Article[0]->{$Key},
            $Test->{Check}->{$Key},
            "$Test->{Name} - Check value $Key",
        );
    }
}

# delete tickets
my $Delete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Delete || 0,
    "TicketDelete()",
);

1;
