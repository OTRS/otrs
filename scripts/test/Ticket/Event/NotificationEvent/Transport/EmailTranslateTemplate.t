# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use Kernel::Language;

use vars (qw($Self));

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Enable email addresses checking.
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# Enable rich text editor.
$ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 1,
);

# Use Test email backend.
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

# Set not self notify.
$ConfigObject->Set(
    Key   => 'AgentSelfNotifyOnAction',
    Value => 0,
);

my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

my $Success = $TestEmailObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);

$Self->IsDeeply(
    $TestEmailObject->EmailsGet(),
    [],
    'Test backend empty after initial cleanup',
);

my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# Create first test user with default language setting ('en').
my $UserLogin = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->TestUserCreate(
    Groups => ['users'],
);
my %UserData = $UserObject->GetUserData(
    User => $UserLogin,
);
my $UserID = $UserData{UserID};

# Create second test user with 'de' lanugage setting.
my $UserLoginDE = $Helper->TestUserCreate(
    Groups   => ['users'],
    Language => 'de'
);
my %UserDataDE = $UserObject->GetUserData(
    User => $UserLoginDE,
);
my $UserDEID = $UserDataDE{UserID};

# Create customer test user with 'es' language setting.
my $CustomerUser = $Helper->TestCustomerUserCreate(
    Language => 'es',
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Create ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'example.com',
    CustomerUser => $CustomerUser,
    OwnerID      => $UserID,
    UserID       => $UserID,
);
$Self->True(
    $TicketID,
    "TicketCreate() successful for Ticket ID $TicketID",
);

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'webrequest',
    SenderType     => 'customer',
    From           => 'customerOne@example.com, customerTwo@example.com',
    To             => 'Some Agent A <agent-a@example.com>',
    Subject        => 'some short description',
    Body           => 'the message text',
    Charset        => 'utf8',
    MimeType       => 'text/plain',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
);
$Self->True(
    $ArticleID,
    "ArticleCreate() successful for Article ID $ArticleID",
);

my $RandomID = $Helper->GetRandomNumber();

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# Create a dynamic field.
my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT1$RandomID",
    Label      => 'Description',
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);

my $NotificationEventObject      = $Kernel::OM->Get('Kernel::System::NotificationEvent');
my $EventNotificationEventObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent');

# Test translation of email template. See bug#13722
#   (https://bugs.otrs.org/show_bug.cgi?id=13722).
$Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 1,
);
$Self->True(
    $Success,
    "Enable RichText with true",
);

my $NotificationID = $NotificationEventObject->NotificationAdd(
    Name => "JobNameTranslation-$RandomID",
    Data => {
        Events          => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
        Recipients      => ['Customer'],
        RecipientAgents => [ $UserID, $UserDEID ],
        Transports      => ['Email'],
    },
    Message => {
        en => {
            Subject     => 'JobName',
            Body        => 'JobName <OTRS_TICKET_TicketID> <OTRS_CONFIG_SendmailModule> <OTRS_OWNER_UserFirstname>',
            ContentType => 'text/html',
        },
    },
    Comment => 'An optional comment',
    ValidID => 1,
    UserID  => 1,
);

$EventNotificationEventObject->Run(
    Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
    Data  => {
        TicketID => $TicketID,
    },
    Config => {},
    UserID => 1,
);

my $Emails = $TestEmailObject->EmailsGet();

# Verify notification translation.
my @Tests = (
    {
        Recipient => 'Customer',
        Language  => 'es',
    },
    {
        Recipient => 'Agent',
        Language  => 'en',
    },
    {
        Recipient => 'Agent',
        Language  => 'de',
    },
);

my $Count = 0;
for my $Test (@Tests) {

    my $LanguageObject = Kernel::Language->new(
        UserLanguage => $Test->{Language},
    );

    my $PoweredBy = $LanguageObject->Translate('Powered by');
    $Self->True(
        index( ${ $Emails->[$Count]->{Body} }, $PoweredBy ) > -1,
        "$Test->{Recipient} - $Test->{Language} - $PoweredBy - 'Powered by' is translated in notificiation",
    );

    $Count++;
}

$TestEmailObject->CleanUp();

# Delete the dynamic field.
my $DFDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID      => $FieldID,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $DFDelete,
    "DynamicFieldDelete() successful for Field ID $FieldID",
);

# Delete the ticket.
my $TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => $UserID,
);
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket ID $TicketID",
);

# Cleanup is done by RestoreDatabase.

1;
