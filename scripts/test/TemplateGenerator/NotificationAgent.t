# --
# NotificationAgent.t - TemplateGenerator NotificationAgent sub tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
# --
# $Id: NotificationAgent.t,v 1.5 2012/04/24 15:10:25 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use Kernel::System::UnitTest::Helper;
use vars (qw($Self));

use Time::HiRes qw( usleep );

use Kernel::Config;
use Kernel::System::Ticket;
use Kernel::System::Queue;
use Kernel::System::User;
use Kernel::System::PostMaster;
use Kernel::System::Type;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::State;
use Kernel::System::UnitTest::Helper;
use Kernel::System::TemplateGenerator;

# create local objects
my $ConfigObject = Kernel::Config->new();

my $EncodeObject = Kernel::System::Encode->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $LogObject = Kernel::System::Log->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);

my $MainObject = Kernel::System::Main->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $DBObject = Kernel::System::DB->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);

my $UserObject   = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TypeObject    = Kernel::System::Type->new( %{$Self} );
my $ServiceObject = Kernel::System::Service->new( %{$Self} );
my $SLAObject     = Kernel::System::SLA->new( %{$Self} );
my $HelperObject  = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,
);
my $StateObject = Kernel::System::State->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $CustomerUserObject = Kernel::System::CustomerUser->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);


my $Helper = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,
    RestoreSystemConfiguration => 1,        # optional, save ZZZAuto.pm and restore it in the destructor
);

# For testing we need:
# - 2 x Agent Users
# - 1 x Customer User
# - 1 x Test Ticket
# - 1 x Test Article sender type Customer

my $Agent1Login = $Helper->TestUserCreate(
    Groups => ['admin', 'users'],
);

my $Agent2Login = $Helper->TestUserCreate(
    Groups => ['admin', 'users'],
);

my $CustomerLogin = $Helper->TestCustomerUserCreate();

my %Customer = $CustomerUserObject->CustomerUserDataGet(
    User => $CustomerLogin,
);

my %Agent1 = $UserObject->GetUserData(
    User => $Agent1Login,
);

my %Agent2 = $UserObject->GetUserData(
    User => $Agent1Login,
);

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'pending reminder',
    CustomerNo   => $CustomerLogin,
    CustomerUser => $CustomerLogin,
    OwnerID      => $Agent1{UserID},
    UserID       => $Agent1{UserID},
);

my $CustomerToAgentArticleID = $TicketObject->ArticleCreate(
    TicketID    => $TicketID,
    ArticleType => 'webrequest',
    SenderType  => 'customer',
    From => $Customer{UserEmail},
    To => $Agent1{UserEmail},
    Subject =>
        'Request for Unittest',
    Body => (
        "This is the Unittests\noriginal Message Body.\n"
    ),
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'WebRequestCustomer',
    HistoryComment => 'Customer request',
    UserID         => 1,
    NoAgentNotify  => 1,
);

my $AgentToCustomerArticleID = $TicketObject->ArticleCreate(
    TicketID    => $TicketID,
    ArticleType => 'email-external',
    SenderType  => 'agent',
    From => $Agent1{UserEmail},
    To => $Customer{UserEmail},
    Subject =>
        'Email to external',
    Body => (
        "This is the Email agent to external\n Message Body.\n"
    ),
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'SendAnswer',
    HistoryComment => 'Email sent to "' . $Customer{UserEmail} . '".',
    UserID         => 1,
    NoAgentNotify  => 1,
);
my $AgentNoteArticleID = $TicketObject->ArticleCreate(
    TicketID    => $TicketID,
    ArticleType => 'note-internal',
    SenderType  => 'agent',
    From => $Agent1{UserEmail},
    Subject =>
        'Note by Agent1',
    Body => (
        "This is an\nAgent Note.\n"
    ),
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'AddNote',
    HistoryComment => 'Added note (Owner)',
    UserID         => 1,
    NoAgentNotify  => 1,
);


my $TemplateGeneratorObject = Kernel::System::TemplateGenerator->new(
    TicketObject        => $TicketObject,
    CustomerUserObject  => $CustomerUserObject,
    QueueObject         => $QueueObject,
    DBObject            => $DBObject,
    UserObject          => $UserObject,
    %{$Self},
);

my %Notification;
%Notification = $TemplateGeneratorObject->NotificationAgent(
    Type                  => 'OwnerUpdate',
    TicketID              => $TicketID,
    CustomerMessageParams => {
        Body => "This is OwnerUpdate Test including\n<OTRS_CUSTOMER_EMAIL[15]>\nciting of the original CustomerMessage\n",
    },
    RecipientID           => $Agent2{UserID},
    UserID                => $Agent1{UserID},
);

$Self->True(
    $Notification{Body} =~ m{This \s+ is \s+ the \s+ Unittests \s+ original \s* Message \s+ Body\.<\/div\>}xms,
    'Citing <OTRS_Customer_Email[15]>',
);

%Notification = ();
%Notification = $TemplateGeneratorObject->NotificationAgent(
    Type                  => 'OwnerUpdate',
    TicketID              => $TicketID,
    CustomerMessageParams => {
        Body => "This is OwnerUpdate Test including\n<OTRS_CUSTOMER_EMAIL[1]>\nciting of the original CustomerMessage\n",
    },
    RecipientID           => $Agent2{UserID},
    UserID                => $Agent1{UserID},
);

$Self->True(
    $Notification{Body} =~ m{This \s+ is \s+ the \s+ Unittests\<\/div\>}xms,
    'Citing <OTRS_Customer_Email[1]>',
);

my $TicketState = $TicketObject->StateSet(
    State    => 'closed successful',
    TicketID => $TicketID,
    UserID   => 1,
);

my $Delete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Delete,
    'TicketDelete()',
);

