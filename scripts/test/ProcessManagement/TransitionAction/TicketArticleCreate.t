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

use Kernel::System::VariableCheck qw(:all);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# use Test email backend
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

# define variables
my $ModuleName = 'TicketArticleCreate';

# set user details
my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate();

# get ticket object
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Email',
);

#
# Create a test ticket
#
my $TicketID = $TicketObject->TicketCreate(
    Title         => 'test',
    QueueID       => 1,
    Lock          => 'unlock',
    Priority      => '3 normal',
    StateID       => 1,
    TypeID        => 1,
    OwnerID       => 1,
    ResponsibleID => 1,
    UserID        => $UserID,
);

# sanity checks
$Self->True(
    $TicketID,
    "TicketCreate() - $TicketID",
);

my $ArticleID1 = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <otrs@example.com>',
    To                   => 'Suplier<suplier@example.com>',
    Subject              => 'Email for suplier',
    Body           => "the message text\nthe message text\nthe message text\nthe message text\nthe message text\n",
    Charset        => 'utf8',
    MimeType       => 'text/plain',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
);
$Self->True(
    $ArticleID1,
    "First article created."
);

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

my $RandomID = $Helper->GetRandomID();

# create a dynamic field
my $TextFieldName = "texttest$RandomID";
my $TextFieldID   = $DynamicFieldObject->DynamicFieldAdd(
    Name       => $TextFieldName,
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'a value',
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $TextFieldID,
    "DynamicFieldAdd() successful for Field ID $TextFieldID",
);

# create a dynamic field
my $MultiSelectFieldName = "multiselecttest$RandomID";
my $MultiSelectFieldID   = $DynamicFieldObject->DynamicFieldAdd(
    Name       => $MultiSelectFieldName,
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Multiselect',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue   => 'a value',
        PossibleValues => {
            a => 'a1',
            b => 'b1',
            c => 'c1',
        },
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $MultiSelectFieldID,
    "DynamicFieldAdd() successful for Field ID $MultiSelectFieldID",
);

# create a dynamic field
my $DropDownFieldName = "dropdowntest$RandomID";
my $DropDownFieldID   = $DynamicFieldObject->DynamicFieldAdd(
    Name       => $DropDownFieldName,
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Dropdown',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue   => 'a value',
        PossibleValues => {
            a => 'a1',
            b => 'b1',
            c => 'c1',
        },
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $DropDownFieldID,
    "DynamicFieldAdd() successful for Field ID $DropDownFieldID",
);

# set dynamic field values
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    Name => $TextFieldName,
);

my $Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    ObjectID           => $TicketID,
    Value              => 'a value',
    UserID             => $UserID,
);

# sanity check
$Self->True(
    $Success,
    "DynamicField ValueSet() successful for Field ID $TextFieldID",
);

$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    Name => $MultiSelectFieldName,
);

$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    ObjectID           => $TicketID,
    Value              => [ 'a', 'b', 'c' ],
    UserID             => $UserID,
);

# sanity check
$Self->True(
    $Success,
    "DynamicField ValueSet() successful for Field ID $MultiSelectFieldID",
);

$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    Name => $DropDownFieldName,
);

$Success = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    ObjectID           => $TicketID,
    Value              => 'a',
    UserID             => $UserID,
);

# sanity check
$Self->True(
    $Success,
    "DynamicField ValueSet() successful for Field ID $DropDownFieldID",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    UserID        => $UserID,
    DynamicFields => 1,
);
$Self->True(
    IsHashRefWithData( \%Ticket ),
    "TicketGet() - Get Ticket with ID $TicketID.",
);

# Run() tests
my @Tests = (
    {
        Name   => 'Correct Ticket->Smart tags',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                ContentType          => 'text/plain; charset=UTF-8',
                CommunicationChannel => 'Internal',
                IsVisibleForCustomer => 1,
                SenderType           => 'agent',
                From                 => 'Admin OTRS',
                HistoryComment       => 'Info',
                HistoryType          => 'AddNote',
                Body                 => '<OTRS_AGENT_BODY[2]>',
                Subject              => '<OTRS_AGENT_SUBJECT[10]>'
            },
        },
        Success => 1,
    },
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name   => 'No UserID',
        Config => {
            UserID => undef,
            Ticket => \%Ticket,
            Config => {
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject              => 'some short description',
                Body                 => 'the message text',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',
                From                 => 'Some Agent <email@example.com>',
                To                   => 'Some Customer A <customer-a@example.com>',
                Cc                   => 'Some Customer B <customer-b@example.com>',
                ReplyTo              => 'Some Customer B <customer-b@example.com>',
                MessageID            => '<asdasdasd.123@example.com>',
                InReplyTo            => '<asdasdasd.12@example.com>',
                References =>
                    '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
                NoAgentNotify                   => 0,
                AutoResponseType                => 'auto reply',
                ForceNotificationToUserID       => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 0,
    },
    {
        Name   => 'No Ticket',
        Config => {
            UserID => $UserID,
            Ticket => undef,
            Config => {
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject              => 'some short description',
                Body                 => 'the message text',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',
                From                 => 'Some Agent <email@example.com>',
                To                   => 'Some Customer A <customer-a@example.com>',
                Cc                   => 'Some Customer B <customer-b@example.com>',
                ReplyTo              => 'Some Customer B <customer-b@example.com>',
                MessageID            => '<asdasdasd.123@example.com>',
                InReplyTo            => '<asdasdasd.12@example.com>',
                References =>
                    '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
                NoAgentNotify                   => 0,
                AutoResponseType                => 'auto reply',
                ForceNotificationToUserID       => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 0,
    },
    {
        Name   => 'No Config',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {},
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Config',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                NoAgentNotify => 0,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Ticket Format',
        Config => {
            UserID => $UserID,
            Ticket => 1,
            Config => {
                NoAgentNotify => 0,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Config Format',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Correct ASCII',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject              => 'some short description',
                Body                 => 'the message text',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',
                From                 => 'Some Agent <email@example.com>',
                To                   => 'Some Customer A <customer-a@example.com>',
                Cc                   => 'Some Customer B <customer-b@example.com>',
                ReplyTo              => 'Some Customer B <customer-b@example.com>',
                MessageID            => '<asdasdasd.123@example.com>',
                InReplyTo            => '<asdasdasd.12@example.com>',
                References =>
                    '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
                NoAgentNotify                   => 0,
                ForceNotificationToUserID       => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct UTF8',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                Body =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Cc             => 'Some Customer B <customer-b@example.com>',
                ReplyTo        => 'Some Customer B <customer-b@example.com>',
                MessageID      => '<asdasdasd.123@example.com>',
                InReplyTo      => '<asdasdasd.12@example.com>',
                References =>
                    '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
                NoAgentNotify                   => 0,
                ForceNotificationToUserID       => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->Title',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject =>
                    '<OTRS_TICKET_Title>',
                Body =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Cc             => 'Some Customer B <customer-b@example.com>',
                ReplyTo        => 'Some Customer B <customer-b@example.com>',
                MessageID      => '<asdasdasd.123@example.com>',
                InReplyTo      => '<asdasdasd.12@example.com>',
                References =>
                    '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
                NoAgentNotify                   => 0,
                ForceNotificationToUserID       => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->NotExistent',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject =>
                    '<OTRS_TICKET_NotExisting> - tag not found',
                Body =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Cc             => 'Some Customer B <customer-b@example.com>',
                ReplyTo        => 'Some Customer B <customer-b@example.com>',
                MessageID      => '<asdasdasd.123@example.com>',
                InReplyTo      => '<asdasdasd.12@example.com>',
                References =>
                    '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
                NoAgentNotify                   => 0,
                ForceNotificationToUserID       => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Without From',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject =>
                    '<OTRS_TICKET_NotExisting> - tag not found',
                Body =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => undef,
                To             => 'Some Customer A <customer-a@example.com>',
                Cc             => 'Some Customer B <customer-b@example.com>',
                ReplyTo        => 'Some Customer B <customer-b@example.com>',
                MessageID      => '<asdasdasd.123@example.com>',
                InReplyTo      => '<asdasdasd.12@example.com>',
                References =>
                    '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
                NoAgentNotify                   => 0,
                ForceNotificationToUserID       => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->DynamicFieldText',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject =>
                    '<OTRS_TICKET_DynamicField_' . $TextFieldName . '_Value>',
                Body =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Cc             => 'Some Customer B <customer-b@example.com>',
                ReplyTo        => 'Some Customer B <customer-b@example.com>',
                MessageID      => '<asdasdasd.123@example.com>',
                InReplyTo      => '<asdasdasd.12@example.com>',
                References =>
                    '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
                NoAgentNotify                   => 0,
                ForceNotificationToUserID       => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->DynamicFieldDropDown Keys',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject =>
                    '<OTRS_TICKET_DynamicField_' . $DropDownFieldName . '>',
                Body =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Cc             => 'Some Customer B <customer-b@example.com>',
                ReplyTo        => 'Some Customer B <customer-b@example.com>',
                MessageID      => '<asdasdasd.123@example.com>',
                InReplyTo      => '<asdasdasd.12@example.com>',
                References =>
                    '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
                NoAgentNotify                   => 0,
                ForceNotificationToUserID       => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->DynamicFieldMultiselect Values',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject =>
                    '<OTRS_TICKET_DynamicField_' . $MultiSelectFieldName . '_Value>',
                Body =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Cc             => 'Some Customer B <customer-b@example.com>',
                ReplyTo        => 'Some Customer B <customer-b@example.com>',
                MessageID      => '<asdasdasd.123@example.com>',
                InReplyTo      => '<asdasdasd.12@example.com>',
                References =>
                    '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
                NoAgentNotify                   => 0,
                ForceNotificationToUserID       => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 1,
    },

    {
        Name   => 'Correct using Internal backend',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
                CommunicationChannel => 'Internal',
                Subject              => 'Test Internal',
                Body           => 'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Charset        => 'ISO-8859-15',
                MimeType       => 'text/plain',
                UnlockOnAway   => 1,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct using Phone backend',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
                CommunicationChannel => 'Phone',
                Subject              => 'Test Phone',
                Body           => 'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Charset        => 'ISO-8859-15',
                MimeType       => 'text/plain',
                UnlockOnAway   => 1,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct using Email backend',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
                CommunicationChannel => 'Email',
                Subject              => 'Test Email',
                Body           => 'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Charset        => 'ISO-8859-15',
                MimeType       => 'text/plain',
                UnlockOnAway   => 1,

                Cc         => 'Some Customer B <customer-b@example.com>',
                Bcc        => 'Some Customer C <customer-c@example.com>',
                ReplyTo    => 'Some Customer B <customer-b@example.com>',
                InReplyTo  => '<asdasdasd.12@example.com>',
                References => '<asdasdasd.1@example.com> <asdasdasd.12@example.com>',
            },
        },
        Success => 1,
    },

    {
        Name   => 'Correct using Test123 backend',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
                CommunicationChannel => 'Test123',
                Subject              => 'Test Test123',
                Body           => 'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Charset        => 'ISO-8859-15',
                MimeType       => 'text/plain',
                UnlockOnAway   => 1,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Correct using Phone backend without "From" parameter',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
                CommunicationChannel => 'Phone',
                Subject              => 'Test Phone',
                Body                 => 'Test body',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',
                To                   => 'Some Customer A <customer-a@example.com>',
                Charset              => 'ISO-8859-15',
                MimeType             => 'text/plain',
                UnlockOnAway         => 1,
            },
        },
        Success        => 1,
        CheckFromValue => 1,
    },
);

my %ExcludedArtributes = (
    HistoryType                     => 1,
    HistoryComment                  => 1,
    ExcludeNotificationToUserID     => 1,
    ForceNotificationToUserID       => 1,
    NoAgentNotify                   => 1,
    ExcludeMuteNotificationToUserID => 1,
    AutoResponseType                => 1,
    UnlockOnAway                    => 1,
    Bcc                             => 1,
);

my $ArticleObject              = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

for my $Test (@Tests) {

    # make a deep copy to avoid changing the definition
    my $OrigTest = Storable::dclone($Test);

    my $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketArticleCreate')->Run(
        %{ $Test->{Config} },
        ProcessEntityID          => 'P1',
        ActivityEntityID         => 'A1',
        TransitionEntityID       => 'T1',
        TransitionActionEntityID => 'TA1',
    );

    if ( $Test->{Success} ) {

        $Self->True(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | executed with True"
        );

        # get last article
        my @MetaArticles = $ArticleObject->ArticleList(
            TicketID => $TicketID,
            OnlyLast => 1,
        );
        my %Article = $ArticleObject->BackendForArticle( %{ $MetaArticles[-1] } )->ArticleGet( %{ $MetaArticles[-1] } );

        # Check 'From' value of article (see bug#13867).
        if ( $Test->{CheckFromValue} ) {
            $Self->True(
                $Article{From} =~ /$TestUserLogin/,
                "Article 'From' value is correct",
            );
        }

        ATTRIBUTE:
        for my $Attribute ( sort keys %{ $Test->{Config}->{Config} } ) {

            next ATTRIBUTE if $ExcludedArtributes{$Attribute};

            if (
                $OrigTest->{Config}->{Config}->{$Attribute} eq '<OTRS_TICKET_NotExisting>'
                && $Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('Type') eq 'oracle'
                )
            {
                $Article{$Attribute} //= '';
            }

            if ( $OrigTest->{Config}->{Config}->{$Attribute} eq '<OTRS_AGENT_BODY[2]>' )
            {
                my @Count = ( $Article{$Attribute} =~ /the message text/g );
                $Self->Is(
                    scalar @Count,
                    2,
                    'Smart tag <OTRS_AGENT_BODY[2]> is replaced right'
                );
            }

            if ( $OrigTest->{Config}->{Config}->{$Attribute} eq '<OTRS_AGENT_SUBJECT[10]>' )
            {
                $Self->Is(
                    $Article{$Attribute},
                    'Email for  [...]',
                    'Smart tag <OTRS_AGENT_SUBJECT[10]> is replaced right'
                );
            }

            if ( $Attribute eq 'CommunicationChannel' ) {

                my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
                    ChannelID => $Article{CommunicationChannelID},
                );

                $Self->Is(
                    $CommunicationChannel{ChannelName},
                    $Test->{Config}->{Config}->{$Attribute},
                    "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for ArticleID:"
                        . " $Article{ArticleID} match expected value",
                );
                next ATTRIBUTE;
            }

            $Self->True(
                defined $Article{$Attribute},
                "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for ArticleID:"
                    . " $Article{ArticleID} exists with True",
            );

            my $ExpectedValue = $Test->{Config}->{Config}->{$Attribute};

            if ( $Attribute eq 'From' && !defined $Test->{Config}->{Config}->{$Attribute} ) {
                my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                    UserID => $UserID,
                );
                $ExpectedValue = "$User{UserFullName} <$User{UserEmail}>";
            }

            if (
                $OrigTest->{Config}->{Config}->{$Attribute}
                =~ m{\A<OTRS_TICKET_([A-Za-z0-9_]+)>\z}msx
                )
            {
                $ExpectedValue = $Ticket{$1} // '';

                if (
                    $OrigTest->{Config}->{Config}->{$Attribute}
                    =~ m{\A<OTRS_TICKET_DynamicField_([A-Za-z0-9_]+)_Value>\z}msx
                    )
                {
                    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                        Name => $1,
                    );

                    my $DisplayValue = $DynamicFieldBackendObject->ValueLookup(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Key                => $Ticket{"DynamicField_$1"},
                    );

                    my $ValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $DisplayValue,
                    );

                    $ExpectedValue = $ValueStrg->{Value};
                }

                $Self->IsNot(
                    $Test->{Config}->{Config}->{$Attribute},
                    $OrigTest->{Config}->{Config}->{$Attribute},
                    "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute value: $OrigTest->{Config}->{Config}->{$Attribute} should been replaced",
                );
            }

            $Self->Is(
                $Article{$Attribute},
                $ExpectedValue,
                "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for ArticleID:"
                    . " $Article{ArticleID} match expected value",
            );
        }

        if ( $OrigTest->{Config}->{Config}->{UserID} ) {
            $Self->Is(
                $Test->{Config}->{Config}->{UserID},
                undef,
                "$ModuleName - Test:'$Test->{Name}' | Attribute: UserID for TicketID:"
                    . " $TicketID should be removed (as it was used)",
            );
        }
    }
    else {
        $Self->False(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | executed with False"
        );
    }
}

# cleanup is done by RestoreDatabase

1;
