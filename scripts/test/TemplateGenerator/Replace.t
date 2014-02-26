# --
# Replace.t - template generator
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::UnitTest::Helper;
use Kernel::System::Ticket;
use Kernel::System::TemplateGenerator;
use Kernel::System::CustomerUser;
use Kernel::System::Queue;

# create local objects
my $ConfigObject       = Kernel::Config->new();
my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$Self} );
my $BackendObject      = Kernel::System::DynamicField::Backend->new( %{$Self} );
my $HelperObject       = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);
my $UserObject = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $CustomerUserObject = Kernel::System::CustomerUser->new(
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

my $RandomID = $HelperObject->GetRandomID();

my $TicketDfId = $DynamicFieldObject->DynamicFieldAdd(
    Name       => 'ReplaceTest' . $RandomID,
    Label      => 'a description',
    FieldOrder => 123,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Config     => {
        Name        => 'ReplaceTest' . $RandomID,
        Description => 'Description for Dynamic Field.',
    },
    Reorder => 1,
    ValidID => 1,
    UserID  => 1,
);

my $TicketDf = $DynamicFieldObject->DynamicFieldGet(
    Name => 'ReplaceTest' . $RandomID,
);

$Self->True(
    $TicketDfId,
    'DynamicFieldAdd()',
);

my $TemplateGeneratorObject = Kernel::System::TemplateGenerator->new(
    %{$Self},
    ConfigObject       => $ConfigObject,
    TicketObject       => $TicketObject,
    UserObject         => $UserObject,
    CustomerUserObject => $CustomerUserObject,
    QueueObject        => $QueueObject,
);

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

my $TicketDfValueSet = $BackendObject->ValueSet(
    DynamicFieldConfig => $TicketDf,
    ObjectID           => $TicketID,
    Value              => 'otrs',
    UserID             => 1,
);

$Self->True(
    $TicketDfValueSet,
    'ValueSet()',
);

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    From           => 'Some Agent <email@example.com>',
    To             => 'Some Customer <customer-a@example.com>',
    Subject        => 'some short description',
    Body           => 'the message text',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify => 1,    # if you don't want to send agent notifications
);

$Self->True(
    $ArticleID,
    'ArticleCreate()',
);

my @Tests = (
    {
        Name => 'simple replace',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_From>',
        Result   => 'Test test@home.com',
    },
    {
        Name => 'simple replace, case insensitive',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_FROM>',
        Result   => 'Test test@home.com',
    },
    {
        Name => 'remove unknown tags',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_INVALID_TAG>',
        Result   => 'Test -',
    },
    {
        Name => 'otrs customer subject',    # <OTRS_CUSTOMER_SUBJECT>
        Data => {
            From    => 'test@home.com',
            Subject => 'otrs',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_SUBJECT>',
        Result   => 'Test otrs',
    },
    {
        Name => 'otrs customer subject 3 letters',    # <OTRS_CUSTOMER_SUBJECT[20]>
        Data => {
            From    => 'test@home.com',
            Subject => 'otrs',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_SUBJECT[3]>',
        Result   => 'Test otr [...]',
    },
    {
        Name => 'otrs customer subject 20 letters + garbarge',    # <OTRS_CUSTOMER_SUBJECT[20]>
        Data => {
            From    => 'test@home.com',
            Subject => 'RE: otrs',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_SUBJECT[20]>',
        Result   => 'Test otrs',
    },
    {
        Name => 'otrs responsible firstname',                     # <OTRS_RESPONSIBLE_UserFirstname>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_RESPONSIBLE_UserFirstname>',
        Result   => 'Test Admin',
    },
    {
        Name => 'otrs owner firstname',                           # <OTRS_OWNER_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_OWNER_UserFirstname>',
        Result   => 'Test Admin',
    },
    {
        Name => 'otrs current firstname',                         # <OTRS_CURRENT_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CURRENT_UserFirstname>',
        Result   => 'Test Admin',
    },
    {
        Name => 'otrs ticket ticketid',                           # <OTRS_TICKET_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_TicketID>',
        Result   => 'Test ' . $TicketID,
    },
    {
        Name => 'otrs dynamic field',                             # <OTRS_TICKET_DynamicField_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_ReplaceTest' . $RandomID . '>',
        Result   => 'Test otrs',
    },
    {
        Name => 'otrs dynamic field value',    # <OTRS_TICKET_DynamicField_*_Value>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_ReplaceTest' . $RandomID . '_Value>',
        Result   => 'Test otrs',
    },
    {
        Name => 'otrs config value',           # <OTRS_CONFIG_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CONFIG_DefaultTheme>',
        Result   => 'Test Standard',
    },

);

for my $Test (@Tests) {
    my $Result = $TemplateGeneratorObject->_Replace(
        Text     => $Test->{Template},
        Data     => $Test->{Data},
        RichText => $Test->{RichText},
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        $Test->{Name},
    );
}

$BackendObject->AllValuesDelete(
    DynamicFieldConfig => {
        ID         => $TicketDfId,
        ObjectType => 'Ticket',
        FieldType  => 'Text',
    },
    UserID => 1,
);
$DynamicFieldObject->DynamicFieldDelete(
    ID     => $TicketDfId,
    UserID => 1,
);

# the ticket is no longer needed
$TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

1;
