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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

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

# Force rich text editor.
my $Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 1,
);
$Self->True(
    $Success,
    'Force RichText with true',
);

# Use DoNotSendEmail email backend.
$Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);
$Self->True(
    $Success,
    'Set DoNotSendEmail backend with true',
);

# Set Default Language.
$Success = $ConfigObject->Set(
    Key   => 'DefaultLanguage',
    Value => 'en',
);
$Self->True(
    $Success,
    'Set default language to English',
);

my $RandomID = $Helper->GetRandomID();

# Create customer users.
my $TestUserLoginEN = $Helper->TestCustomerUserCreate(
    Language => 'en',
);
my $TestUserLoginDE = $Helper->TestCustomerUserCreate(
    Language => 'de',
);

my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

# Create new queue.
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

my $AutoResponseObject = $Kernel::OM->Get('Kernel::System::AutoResponse');

# Create new auto response.
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

# Assign auto response to queue.
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

# Create a new ticket.
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

my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

for my $Test (@Tests) {

    # Set ticket customer.
    my $Success = $TicketObject->TicketCustomerSet(
        User     => $Test->{CustomerUser},
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "$Test->{Name} TicketCustomerSet() - for customer $Test->{CustomerUser} with true",
    );

    # Get assigned auto response.
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

    # Create auto response article (bug#12097).
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

# Check replacing time attribute tags (see bug#13865 - https://bugs.otrs.org/show_bug.cgi?id=13865).
# Create datetime dynamic field.
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DynamicFieldName   = "DateTimeDF$RandomID";
my $DynamicFieldID     = $DynamicFieldObject->DynamicFieldAdd(
    Name       => $DynamicFieldName,
    Label      => $DynamicFieldName,
    FieldOrder => 9991,
    FieldType  => 'DateTime',
    ObjectType => 'Ticket',
    Config     => {},
    ValidID    => 1,
    UserID     => 1,
);
$Self->True(
    $DynamicFieldID,
    "DynamicFieldID $DynamicFieldID is created",
);

my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    ID => $DynamicFieldID,
);

# Create test queue.
my $TestQueueID = $QueueObject->QueueAdd(
    Name            => "TestQueue$RandomID",
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);
$Self->True(
    $TestQueueID,
    "TestQueueID $TestQueueID is created",
);

my $TestAutoResponse = '<!DOCTYPE html><html>' .
    '<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head>'
    . '<body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">'
    . 'OTRS_TICKET_Created: &lt;OTRS_TICKET_Created&gt;<br />'
    . 'OTRS_TICKET_Changed: &lt;OTRS_TICKET_Changed&gt;<br />'
    . 'OTRS_TICKET_DynamicField_'
    . $DynamicFieldName
    . ': &lt;OTRS_TICKET_DynamicField_'
    . $DynamicFieldName
    . '&gt;<br />'
    . 'OTRS_TICKET_DynamicField_'
    . $DynamicFieldName
    . '_Value: &lt;OTRS_TICKET_DynamicField_'
    . $DynamicFieldName
    . '_Value&gt;<br />'
    . '</body>'
    . '</html>';

# Create test auto response with tags.
my $TestAutoResponseID = $AutoResponseObject->AutoResponseAdd(
    Name        => "TestAutoResponse$RandomID",
    ValidID     => 1,
    Subject     => "$RandomID - <OTRS_TICKET_Created>",
    Response    => $TestAutoResponse,
    ContentType => 'text/html',
    AddressID   => 1,
    TypeID      => 1,
    UserID      => 1,
);
$Self->True(
    $TestAutoResponseID,
    "TestAutoResponseID $TestAutoResponseID is created",
);

# Assign auto response to queue.
$Success = $AutoResponseObject->AutoResponseQueue(
    QueueID         => $TestQueueID,
    AutoResponseIDs => [$TestAutoResponseID],
    UserID          => 1,
);
$Self->True(
    $Success,
    "Auto response ID $TestAutoResponseID is assigned to QueueID $TestQueueID",
);

# Set fixed time.
$Helper->FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2018-12-06 12:00:00',
        },
    )->ToEpoch()
);

# Create test customer user.
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();

# Create test ticket.
my $TestTicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    QueueID      => $TestQueueID,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $TestCustomerUserLogin,
    CustomerUser => $TestCustomerUserLogin,
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TestTicketID,
    "TestTicketID $TestTicketID is created",
);

# Get ticket number.
my $TicketNumber = $TicketObject->TicketNumberLookup(
    TicketID => $TestTicketID,
);

# Set datetime dynamic field value for test ticket.
$Success = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    Value              => '2018-12-03 15:00:00',
    UserID             => 1,
    ObjectID           => $TestTicketID,
);
$Self->True(
    $Success,
    "Dynamic field value is set successfully",
);

@Tests = (
    {
        Timezone        => 'Europe/Berlin',
        Language        => 'de',
        ExpectedSubject => "[Ticket#$TicketNumber] $RandomID - 06.12.2018 13:00 (Europe/Berlin)",
        ExpectedText =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">OTRS_TICKET_Created: 06.12.2018 13:00 (Europe/Berlin)<br />OTRS_TICKET_Changed: 06.12.2018 13:00 (Europe/Berlin)<br />OTRS_TICKET_DynamicField_'
            . $DynamicFieldName
            . ': 2018-12-03 16:00:00 (Europe/Berlin)<br />OTRS_TICKET_DynamicField_'
            . $DynamicFieldName
            . '_Value: 03.12.2018 16:00 (Europe/Berlin)<br /></body></html>',
    },
    {
        Timezone        => 'America/Bogota',
        Language        => 'es',
        ExpectedSubject => "[Ticket#$TicketNumber] $RandomID - 06/12/2018 - 07:00 (America/Bogota)",
        ExpectedText =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">OTRS_TICKET_Created: 06/12/2018 - 07:00 (America/Bogota)<br />OTRS_TICKET_Changed: 06/12/2018 - 07:00 (America/Bogota)<br />OTRS_TICKET_DynamicField_'
            . $DynamicFieldName
            . ': 2018-12-03 10:00:00 (America/Bogota)<br />OTRS_TICKET_DynamicField_'
            . $DynamicFieldName
            . '_Value: 03/12/2018 - 10:00 (America/Bogota)<br /></body></html>',
    },
    {
        Timezone        => 'Asia/Bangkok',
        Language        => 'en',
        ExpectedSubject => "[Ticket#$TicketNumber] $RandomID - 12/06/2018 19:00 (Asia/Bangkok)",
        ExpectedText =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">OTRS_TICKET_Created: 12/06/2018 19:00 (Asia/Bangkok)<br />OTRS_TICKET_Changed: 12/06/2018 19:00 (Asia/Bangkok)<br />OTRS_TICKET_DynamicField_'
            . $DynamicFieldName
            . ': 2018-12-03 22:00:00 (Asia/Bangkok)<br />OTRS_TICKET_DynamicField_'
            . $DynamicFieldName
            . '_Value: 12/03/2018 22:00 (Asia/Bangkok)<br /></body></html>',
    }
);

my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

for my $Test (@Tests) {

    # Set customer user's timezone and language.
    $CustomerUserObject->SetPreferences(
        Key    => 'UserTimeZone',
        Value  => $Test->{Timezone},
        UserID => $TestCustomerUserLogin,
    );
    $CustomerUserObject->SetPreferences(
        Key    => 'UserLanguage',
        Value  => $Test->{Language},
        UserID => $TestCustomerUserLogin,
    );

    # Call AutoResponse function.
    my %TestAutoResponse = $TemplateGeneratorObject->AutoResponse(
        TicketID         => $TestTicketID,
        OrigHeader       => {},
        AutoResponseType => 'auto reply',
        UserID           => 1,
    );

    # Check replaced subject.
    $Self->Is(
        $TestAutoResponse{Subject},
        $Test->{ExpectedSubject},
        "AutoResponse subject - Language: $Test->{Language}, Timezone: $Test->{Timezone} - tags are replaced correctly"
    );

    # Check replaced text.
    $Self->Is(
        $TestAutoResponse{Text},
        $Test->{ExpectedText},
        "AutoResponse text - Language: $Test->{Language}, Timezone: $Test->{Timezone} - tags are replaced correctly"
    );
}

# Cleanup is done by RestoreDatabase.

1;
