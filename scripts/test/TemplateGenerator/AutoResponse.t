# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;
use vars (qw($Self));

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# disable rich text editor
my $Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 0,
);
$Self->True(
    $Success,
    "Disable RichText with true",
);

# use NoSendMail email backend
$Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::NoSendMail',
);
$Self->True(
    $Success,
    "Set NoSendMail backend with true",
);

# set Default Language
$Success = $ConfigObject->Set(
    Key   => 'DefaultLanguage',
    Value => 'en',
);
$Self->True(
    $Success,
    "Set default language to English",
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID     = $HelperObject->GetRandomID();

# create customer users
my $TestUserLoginEN = $HelperObject->TestCustomerUserCreate(
    Language => 'en',
);
my $TestUserLoginDE = $HelperObject->TestCustomerUserCreate(
    Language => 'de',
);

# get queue object
my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

# create new queue
my $QueueName     = 'Some::Queue' . $RandomID;
my %QueueTemplate = (
    Name            => $QueueName,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);
my $QueueID = $QueueObject->QueueAdd(%QueueTemplate);
$Self->IsNot(
    $QueueID,
    undef,
    "QueueAdd() - QueueID should not be undef",
);

# get auto response object
my $AutoResponseObject = $Kernel::OM->Get('Kernel::System::AutoResponse');

# create new auto response
my $AutoResonseName      = 'Some::AutoResponse' . $RandomID;
my %AutoResponseTemplate = (
    Name        => $AutoResonseName,
    ValidID     => 1,
    Subject     => 'Some Subject..',
    Response    => '<OTRS_TICKET_State>',
    Charset     => 'utf8',
    ContentType => 'text/plain',
    AddressID   => 1,
    TypeID      => 4,                       # auto reply/new ticket
    UserID      => 1,
);
my $AutoResponseID = $AutoResponseObject->AutoResponseAdd(%AutoResponseTemplate);
$Self->IsNot(
    $AutoResponseID,
    undef,
    "AutoResponseAdd() - AutoResonseID should not be undef",
);

# get a list of the queues that do not have auto response
my %AutoResponseWithoutQueue = $AutoResponseObject->AutoResponseWithoutQueue();

$Self->True(
    exists $AutoResponseWithoutQueue{$QueueID} && $AutoResponseWithoutQueue{$QueueID} eq $QueueName,
    'AutoResponseWithoutQueue() contains queue ' . $QueueName . ' with ID ' . $QueueID,
);

# assign auto response to queue
$Success = $AutoResponseObject->AutoResponseQueue(
    QueueID         => $QueueID,
    AutoResponseIDs => [$AutoResponseID],
    UserID          => 1,
);
$Self->True(
    $Success,
    "AutoResponseQueue() - assigned auto response - $AutoResonseName to queue - $QueueName",
);

# check again after assigning auto response to queue
%AutoResponseWithoutQueue = $AutoResponseObject->AutoResponseWithoutQueue();
$Self->False(
    exists $AutoResponseWithoutQueue{$QueueID} && $AutoResponseWithoutQueue{$QueueID} eq $QueueName,
    'AutoResponseWithoutQueue() does not contain queue ' . $QueueName . ' with ID ' . $QueueID,
);

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# create a new ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    QueueID      => $QueueID,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->IsNot(
    $TicketID,
    undef,
    "TicketCreate() - TicketID should not be undef",
);

my @Tests = (
    {
        Name           => 'English Language Customer',
        CustomerUser   => $TestUserLoginEN,
        ExpectedResult => 'new',
    },
    {
        Name           => 'German Language Customer',
        CustomerUser   => $TestUserLoginDE,
        ExpectedResult => 'neu',
    },
    {
        Name           => 'Not existing Customer',
        CustomerUser   => 'customer@example.com',
        ExpectedResult => 'new',
    },
);

# get template generator object
my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

for my $Test (@Tests) {

    # set ticket customer
    my $Success = $TicketObject->TicketCustomerSet(
        User     => $Test->{CustomerUser},
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "$Test->{Name} TicketCustomerSet() - for customer $Test->{CustomerUser} with true",
    );

    # get assigned auto response
    my %AutoResponse = $TemplateGeneratorObject->AutoResponse(
        TicketID         => $TicketID,
        OrigHeader       => {},
        AutoResponseType => 'auto reply/new ticket',
        UserID           => 1,
    );
    $Self->Is(
        $AutoResponse{Text},
        $Test->{ExpectedResult},
        "$Test->{Name} AutoResponse() - Text"
    );
}

# Cleanup is done by RestoreDatabase.

1;
