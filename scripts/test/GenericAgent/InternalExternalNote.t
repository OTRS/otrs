# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject      = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    RestoreDatabase  => 1,
    UseTmpArticleDir => 1,
);

my $RandomID = $HelperObject->GetRandomID();

# Create a Ticket to test JobRun
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Testticket for Untittest of the Generic Agent',
    Queue        => 'Raw',
    Lock         => 'lock',
    PriorityID   => 1,
    StateID      => 1,
    CustomerNo   => '123465',
    CustomerUser => 'customerUnitTest@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

my $ArticleID = $ArticleObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    From           => 'Agent Some Agent Some Agent <email@example.com>',
    To             => 'Customer A <customer-a@example.com>',
    Cc             => 'Customer B <customer-b@example.com>',
    ReplyTo        => 'Customer B <customer-b@example.com>',
    Subject        => 'some short description',
    Body           => 'the message text Perl modules provide a range of',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,
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

# add a new Job for note-external
my $Name   = 'UnitTest_' . $RandomID;
my %NewJob = (
    Name => $Name,
    Data => {
        TicketNumber          => $Ticket{TicketNumber},
        EventValues           => 'TicketLockUpdate',
        NewArticleType        => 'note-external',
        NewNoteBody           => '<OTRS_TICKET_TicketNumber>',
        NewNoteFrom           => 'UnitTest@Example.com',
        NewNoteSubject        => '<OTRS_TICKET_TicketID>',
        NewSendNoNotification => 1,
        StateIDs              => [ 1, 4 ],
        LockIDs               => 2,
    },
);

my $JobAdd = $GenericAgentObject->JobAdd(
    %NewJob,
    UserID => 1,
);
$Self->True(
    $JobAdd || '',
    'JobAdd()',
);

$Self->True(
    $GenericAgentObject->JobRun(
        Job    => $Name,
        UserID => 1,
    ),
    'JobRun() Run the UnitTest GenericAgent job',
);

my @ArticleBox = $ArticleObject->ArticleContentIndex(
    TicketID      => $TicketID,
    DynamicFields => 0,
    UserID        => 1,
);

$Self->Is(
    $ArticleBox[1]->{Body},
    $Ticket{TicketNumber},
    "TicketNumber found. OTRS Tag used.",
);

my @CustomerArticleTypes = $ArticleObject->ArticleTypeList( Type => 'Customer' );
my @ArticleBoxCustomer = $ArticleObject->ArticleContentIndex(
    TicketID      => $TicketID,
    UserID        => $ArticleBox[1]->{CustomerUserID},
    DynamicFields => 0,
    ArticleType   => \@CustomerArticleTypes,
);

$Self->Is(
    $ArticleBoxCustomer[0]->{Body},
    $Ticket{TicketNumber},
    "Article found in customer view. TicketNumber found. OTRS Tag used.",
);

# add a new Job for note-internal
$Name   = 'UnitTestInternal_' . $RandomID;
%NewJob = (
    Name => $Name,
    Data => {
        TicketNumber          => $Ticket{TicketNumber},
        EventValues           => 'TicketLockUpdate',
        NewArticleType        => 'note-internal',
        NewNoteBody           => '<OTRS_TICKET_TicketNumber>',
        NewNoteFrom           => 'UnitTest@Example.com',
        NewNoteSubject        => '<OTRS_TICKET_TicketID>',
        NewSendNoNotification => 1,
        StateIDs              => [ 1, 4 ],
        LockIDs               => 2,
    },
);

$JobAdd = $GenericAgentObject->JobAdd(
    %NewJob,
    UserID => 1,
);
$Self->True(
    $JobAdd || '',
    'JobAdd()',
);

$Self->True(
    $GenericAgentObject->JobRun(
        Job    => $Name,
        UserID => 1,
    ),
    'JobRun() Run the UnitTest GenericAgent job',
);

@ArticleBox = $ArticleObject->ArticleContentIndex(
    TicketID      => $TicketID,
    DynamicFields => 0,
    UserID        => 1,
);

$Self->Is(
    $ArticleBox[1]->{Body},
    $Ticket{TicketNumber},
    "TicketNumber found. OTRS Tag used.",
);

@ArticleBoxCustomer = $ArticleObject->ArticleContentIndex(
    TicketID      => $TicketID,
    UserID        => $ArticleBox[1]->{CustomerUserID},
    ArticleType   => \@CustomerArticleTypes,
    DynamicFields => 0,
);

$Self->False(
    $ArticleBoxCustomer[1]->{Body},
    "No Article found in customer view.",
);

1;
