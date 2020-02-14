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

my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );
my $GenericAgentObject   = $Kernel::OM->Get('Kernel::System::GenericAgent');

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    RestoreDatabase  => 1,
    UseTmpArticleDir => 1,
);

my $RandomID = $HelperObject->GetRandomID();

# Create a ticket to test JobRun.
my $TicketID = $TicketObject->TicketCreate(
    Title      => 'Testticket for Untittest of the Generic Agent',
    Queue      => 'Raw',
    Lock       => 'lock',
    PriorityID => 1,
    StateID    => 1,
    OwnerID    => 1,
    UserID     => 1,
);

# Create test article.
my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text Perl modules provide a range of',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,
);

$Self->True(
    $TicketID,
    'Ticket was created',
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
);

$Self->True(
    $Ticket{TicketNumber},
    'Found ticket number',
);

# Add a new job with note visible externally.
my $Name   = 'UnitTest_' . $RandomID;
my %NewJob = (
    Name => $Name,
    Data => {
        TicketNumber                => $Ticket{TicketNumber},
        EventValues                 => 'TicketLockUpdate',
        NewNoteIsVisibleForCustomer => 1,
        NewNoteBody                 => '<OTRS_TICKET_TicketNumber>',
        NewNoteFrom                 => 'UnitTest@Example.com',
        NewNoteSubject              => '<OTRS_TICKET_TicketID>',
        NewSendNoNotification       => 1,
        StateIDs                    => [ 1, 4 ],
        LockIDs                     => 2,
    },
);

my $JobAdd = $GenericAgentObject->JobAdd(
    %NewJob,
    UserID => 1,
);
$Self->True(
    $JobAdd || '',
    'JobAdd()'
);

$Self->True(
    $GenericAgentObject->JobRun(
        Job    => $Name,
        UserID => 1,
    ),
    'JobRun() Run the UnitTest GenericAgent job'
);

# Get all articles.
my @Articles = $ArticleObject->ArticleList(
    TicketID => $TicketID,
);
my @ArticleBox;
for my $Article (@Articles) {
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $TicketID,
        ArticleID     => $Article->{ArticleID},
        DynamicFields => 0,
    );
    push @ArticleBox, \%Article;
}

$Self->Is(
    $ArticleBox[1]->{Body},
    $Ticket{TicketNumber},
    'TicketNumber found. OTRS Tag used.'
);

# Get articles visible to customer.
@Articles = $ArticleObject->ArticleList(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
);
my @ArticleBoxCustomer;
for my $Article (@Articles) {
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $TicketID,
        ArticleID     => $Article->{ArticleID},
        DynamicFields => 0,
    );
    push @ArticleBoxCustomer, \%Article;
}

$Self->Is(
    $ArticleBoxCustomer[0]->{Body},
    $Ticket{TicketNumber},
    'Article found in customer view. TicketNumber found. OTRS Tag used.'
);

# Add a new job with note visible internally.
$Name   = 'UnitTestInternal_' . $RandomID;
%NewJob = (
    Name => $Name,
    Data => {
        TicketNumber                => $Ticket{TicketNumber},
        EventValues                 => 'TicketLockUpdate',
        NewNoteIsVisibleForCustomer => 0,
        NewNoteBody                 => '<OTRS_TICKET_TicketNumber>',
        NewNoteFrom                 => 'UnitTest@Example.com',
        NewNoteSubject              => '<OTRS_TICKET_TicketID>',
        NewSendNoNotification       => 1,
        StateIDs                    => [ 1, 4 ],
        LockIDs                     => 2,
    },
);

$JobAdd = $GenericAgentObject->JobAdd(
    %NewJob,
    UserID => 1,
);
$Self->True(
    $JobAdd || '',
    'JobAdd()'
);

$Self->True(
    $GenericAgentObject->JobRun(
        Job    => $Name,
        UserID => 1,
    ),
    'JobRun() Run the UnitTest GenericAgent job'
);

# Get all articles.
@Articles = $ArticleObject->ArticleList(
    TicketID => $TicketID,
);
@ArticleBox = ();
for my $Article (@Articles) {
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $TicketID,
        ArticleID     => $Article->{ArticleID},
        DynamicFields => 0,
    );
    push @ArticleBox, \%Article;
}

$Self->Is(
    $ArticleBox[1]->{Body},
    $Ticket{TicketNumber},
    'TicketNumber found. OTRS Tag used.'
);

# Get all articles visible to customer.
@Articles = $ArticleObject->ArticleList(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
);
@ArticleBoxCustomer = ();
for my $Article (@Articles) {
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $TicketID,
        ArticleID     => $Article->{ArticleID},
        DynamicFields => 0,
    );
    push @ArticleBoxCustomer, \%Article;
}

$Self->False(
    $ArticleBoxCustomer[1]->{Body},
    'No Article found in customer view.'
);

1;
