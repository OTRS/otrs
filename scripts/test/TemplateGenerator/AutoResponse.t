# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => '0',
);

# force rich text editor
my $Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 1,
);
$Self->True(
    $Success,
    'Force RichText with true',
);

# use DoNotSendEmail email backend
$Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);
$Self->True(
    $Success,
    'Set DoNotSendEmail backend with true',
);

# set Default Language
$Success = $ConfigObject->Set(
    Key   => 'DefaultLanguage',
    Value => 'en',
);
$Self->True(
    $Success,
    'Set default language to English',
);

my $RandomID = $Helper->GetRandomID();

# create customer users
my $TestUserLoginEN = $Helper->TestCustomerUserCreate(
    Language => 'en',
);
my $TestUserLoginDE = $Helper->TestCustomerUserCreate(
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
    'QueueAdd() - QueueID should not be undef',
);

# get auto response object
my $AutoResponseObject = $Kernel::OM->Get('Kernel::System::AutoResponse');

# create new auto response
my $AutoResonseName      = 'Some::AutoResponse' . $RandomID;
my %AutoResponseTemplate = (
    Name        => $AutoResonseName,
    ValidID     => 1,
    Subject     => 'Some Subject..',
    Response    => 'S:&nbsp;&lt;OTRS_TICKET_State&gt;',    # include non-breaking space (bug#12097)
    ContentType => 'text/html',
    AddressID   => 1,
    TypeID      => 4,                                      # auto reply/new ticket
    UserID      => 1,
);
my $AutoResponseID = $AutoResponseObject->AutoResponseAdd(%AutoResponseTemplate);
$Self->IsNot(
    $AutoResponseID,
    undef,
    'AutoResponseAdd() - AutoResonseID should not be undef',
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

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Email',
);

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
    'TicketCreate() - TicketID should not be undef',
);

my $HTMLTemplate
    = '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">%s</body></html>';
my @Tests = (
    {
        Name           => 'English Language Customer',
        CustomerUser   => $TestUserLoginEN,
        ExpectedResult => sprintf( $HTMLTemplate, 'S:&nbsp;new' ),
    },
    {
        Name           => 'German Language Customer',
        CustomerUser   => $TestUserLoginDE,
        ExpectedResult => sprintf( $HTMLTemplate, 'S:&nbsp;neu' ),
    },
    {
        Name           => 'Not existing Customer',
        CustomerUser   => 'customer@example.com',
        ExpectedResult => sprintf( $HTMLTemplate, 'S:&nbsp;new' ),
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

    # create auto response article (bug#12097)
    my $ArticleID = $ArticleBackendObject->SendAutoResponse(
        TicketID         => $TicketID,
        AutoResponseType => 'auto reply/new ticket',
        OrigHeader       => {
            From => $Test->{CustomerUser},
        },
        IsVisibleForCustomer => 1,
        UserID               => 1,
    );
    $Self->IsNot(
        $ArticleID,
        undef,
        "$Test->{Name} SendAutoResponse() - ArticleID should not be undef"
    );
}

# Cleanup is done by RestoreDatabase.

1;
