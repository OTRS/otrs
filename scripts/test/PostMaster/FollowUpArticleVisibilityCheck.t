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

my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
    MessageID            => 'message-id-email-external',
    SenderType           => 'customer',
    From                 => "Customer <$CustomerAddress>",
    To                   => "Agent <$AgentAddress>",
    Subject              => 'subject',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'NewTicket',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,
);

$Self->True(
    $ArticleID,
    "ArticleCreate()",
);

$ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    MessageID            => 'message-id-email-internal',
    SenderType           => 'agent',
    From                 => "Agent <$AgentAddress>",
    To                   => "Provider <$InternalAddress>",
    Subject              => 'subject',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'NewTicket',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,
);

$Self->True(
    $ArticleID,
    "ArticleCreate()",
);

# Accidental internal forward to the customer to test that customer replies are still external.
$ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    MessageID            => 'message-id-email-internal-customer',
    SenderType           => 'agent',
    From                 => "Agent <$AgentAddress>",
    To                   => "Customer <$CustomerAddress>",
    Subject              => 'subject',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'NewTicket',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,
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
            IsVisibleForCustomer => 1,
            SenderType           => 'customer',
        },
        JobConfig => {
            IsVisibleForCustomer => 0,
            Module               => 'Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck',
            SenderType           => 'customer',
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
            IsVisibleForCustomer => 0,
            SenderType           => 'customer',
        },
        JobConfig => {
            IsVisibleForCustomer => 0,
            Module               => 'Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck',
            SenderType           => 'customer',
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
            IsVisibleForCustomer => 0,
            SenderType           => 'customer',
        },
        JobConfig => {
            IsVisibleForCustomer => 0,
            Module               => 'Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck',
            SenderType           => 'customer',
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
            IsVisibleForCustomer => 1,
            SenderType           => 'customer',
        },
        JobConfig => {
            IsVisibleForCustomer => 0,
            Module               => 'Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck',
            SenderType           => 'customer',
        },
    },

    # response from internal address and "system" sender type
    # this must be unchanged, and previous articles as well (see bug#10182)
    {
        Name  => 'Provider notification',
        Email => "From: Provider <$InternalAddress>
To: Agent <$AgentAddress>
X-OTRS-FollowUp-SenderType: system
Subject: $Subject

Some Content in Body",
        Check => {
            IsVisibleForCustomer => 1,
            SenderType           => 'system',
        },
        JobConfig => {
            IsVisibleForCustomer => 0,
            Module               => 'Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck',
            SenderType           => 'customer',
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
            IsVisibleForCustomer => 0,
            SenderType           => 'customer',
        },
        JobConfig => {
            IsVisibleForCustomer => 0,
            Module               => 'Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck',
            SenderType           => 'customer',
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
            '000-FollowUpArticleVisibilityCheck' => {
                %{ $Test->{JobConfig} }
            },
        },
    );

    # Get current state of articles
    my @ArticleBoxOriginal = $ArticleObject->ArticleList(
        UserID   => 1,
        TicketID => $TicketID,
    );

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
        2,
        "$Test->{Name} - Follow up created",
    );
    $Self->True(
        $Return[1] || 0,
        "$Test->{Name} - Follow up TicketID",
    );

    # Get state of old articles after update
    my @ArticleBoxUpdate = $ArticleObject->ArticleList(
        TicketID => $TicketID,
    );
    my $NewMetaArticle = pop @ArticleBoxUpdate;

    # Make sure that old articles were not changed
    $Self->IsDeeply(
        \@ArticleBoxUpdate,
        \@ArticleBoxOriginal,
        "$Test->{Name} - old articles unchanged"
    );

    my %Article = $ArticleBackendObject->ArticleGet( %{$NewMetaArticle} );

    for my $Key ( sort keys %{ $Test->{Check} } ) {
        $Self->Is(
            $Article{$Key},
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
