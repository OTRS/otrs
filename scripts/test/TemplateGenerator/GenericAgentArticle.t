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

# get needed objects
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $GenericAgentObject   = $Kernel::OM->Get('Kernel::System::GenericAgent');
my $CustomerUserObject   = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    RestoreDatabase  => 1,
    UseTmpArticleDir => 1,
);

my $RandomID = $HelperObject->GetRandomID();

my $TestCustomerUserLogin = $HelperObject->TestCustomerUserCreate();

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'GenericAgentArticle test ticket.',
    Queue        => 'Raw',
    Lock         => 'lock',
    PriorityID   => 1,
    StateID      => 1,
    CustomerUser => $TestCustomerUserLogin,
    CustomerID   => '123456',
    OwnerID      => 1,
    UserID       => 1,
);

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

my %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
    User => lc( $Ticket{CustomerUserID} ),
);

my %Notification = (
    Subject     => '',
    Body        => '<OTRS_TICKET_TicketNumber>',
    ContentType => 'text/plain',
);

my %GenericAgentArticle = $Kernel::OM->Get('Kernel::System::TemplateGenerator')->GenericAgentArticle(
    TicketID     => $TicketID,
    Recipient    => \%CustomerUserData,
    Notification => \%Notification,
    UserID       => 1,
);

$Self->Is(
    $GenericAgentArticle{Body},
    $Ticket{TicketNumber},
    "TicketNumber found. OTRS Tag used.",
);

1;
