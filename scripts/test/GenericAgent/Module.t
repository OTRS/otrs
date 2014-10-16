# --
# Module.t - GenericAgent tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

# This test should verify that a module gets the configured parameters
#   passed directly in the param hash

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $HelperObject       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

my %Jobs;

my $RandomID = $HelperObject->GetRandomID();

# Create a Ticket to test JobRun and JobRunTicket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Testticket for Untittest of the Generic Agent',
    Queue        => 'Raw',
    Lock         => 'unlock',
    PriorityID   => 1,
    StateID      => 1,
    CustomerNo   => '123465',
    CustomerUser => 'customerUnitTest@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID    => $TicketID,
    ArticleType => 'note-internal',
    SenderType  => 'agent',
    From        => 'Agent Some Agent Some Agent <email@example.com>',
    To          => 'Customer A <customer-a@example.com>',
    Cc          => 'Customer B <customer-b@example.com>',
    ReplyTo     => 'Customer B <customer-b@example.com>',
    Subject     => 'some short description',
    Body        => 'the message text Perl modules provide a range of
',

    #    MessageID => '<asdasdasd.123@example.com>',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify => 1,    # if you don't want to send agent notifications
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

# add a new Job
my $Name   = 'UnitTest_' . $RandomID;
my %NewJob = (
    Name => $Name,
    Data => {
        TicketNumber   => $Ticket{TicketNumber},
        NewModule      => 'scripts::test::GenericAgent::MailForward',
        NewParamKey1   => 'TargetAddress',
        NewParamValue1 => 'somebody@unittest.com',
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

my @ArticleBox = $TicketObject->ArticleContentIndex(
    TicketID      => $TicketID,
    DynamicFields => 0,
    UserID        => 1,
);

$Self->Is(
    scalar @ArticleBox,
    2,
    "2 articles found, forward article was created",
);

$Self->Is(
    $ArticleBox[1]->{To},
    'somebody@unittest.com',
    "TargetAddress was used",
);

# the ticket is no longer needed
my $TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $TicketDelete || '',
    'TicketDelete()',
);

my $JobDelete = $GenericAgentObject->JobDelete(
    Name   => $Name,
    UserID => 1,
);
$Self->True(
    $JobDelete || '',
    'JobDelete()',
);

1;
