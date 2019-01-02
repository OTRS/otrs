# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'email-external',
    MessageID      => 'message-id-email-external',
    SenderType     => 'customer',
    From           => "Customer <$CustomerAddress>",
    To             => "Agent <$AgentAddress>",
    Subject        => 'subject',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'NewTicket',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,
);

$Self->True(
    $ArticleID,
    "ArticleCreate()",
);

$ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'email-internal',
    MessageID      => 'message-id-email-internal',
    SenderType     => 'agent',
    From           => "Agent <$AgentAddress>",
    To             => "Provider <$InternalAddress>",
    Subject        => 'subject',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'NewTicket',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,
);

$Self->True(
    $ArticleID,
    "ArticleCreate()",
);

# Accidential internal forward to the customer to test that customer replies are still external.
$ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'email-internal',
    MessageID      => 'message-id-email-internal-customer',
    SenderType     => 'agent',
    From           => "Agent <$AgentAddress>",
    To             => "Customer <$CustomerAddress>",
    Subject        => 'subject',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'NewTicket',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,
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

    # response from internal address, must be made internal
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

    # response from forwarded customer address, must be made internal
    {
        Name  => 'Provider response',
        Email => "From: Forwarded Address <forwarded\@googlemail.com>
Reply-To: Provider <$InternalAddress>
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

    # response from an unknown address, but in response to the internal article (References)
    {
        Name  => 'Response to internal mail from unknown sender',
        Email => "From: Somebody <unknown\@address.com>
To: Agent <$AgentAddress>
References: <message-id-email-internal>
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
);

my $RunTest = sub {
    my $Test = shift;

    $ConfigObject->Set(
        Key   => 'PostMaster::PreCreateFilterModule',
        Value => {},
    );

    $ConfigObject->Set(
        Key   => 'PostMaster::PreCreateFilterModule',
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
            Email => \$Test->{Email},
            Debug => 2,
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

    # Get state of old articles after update
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

    return;
};

# First run the tests for a ticket that has the customer as an "unknown" customer.
for my $Test (@Tests) {
    $RunTest->($Test);
}

# Now add the customer to the customer database and run the tests again.
my $TestCustomerLogin  = $Helper->TestCustomerUserCreate();
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
my %CustomerData       = $CustomerUserObject->CustomerUserDataGet(
    User => $TestCustomerLogin,
);
$CustomerUserObject->CustomerUserUpdate(
    %CustomerData,
    Source    => 'CustomerUser',       # CustomerUser source config
    ID        => $TestCustomerLogin,
    UserEmail => $CustomerAddress,
    UserID    => 1,
);
%CustomerData = $CustomerUserObject->CustomerUserDataGet(
    User => $TestCustomerLogin,
);
$TicketObject->TicketCustomerSet(
    No       => $CustomerData{CustomerID},
    User     => $TestCustomerLogin,
    TicketID => $TicketID,
    UserID   => 1,
);

for my $Test (@Tests) {
    $RunTest->($Test);
}

# cleanup is done by RestoreDatabase.

1;
