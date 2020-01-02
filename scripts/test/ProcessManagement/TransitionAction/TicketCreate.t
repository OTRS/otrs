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

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject      = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $LinkObject         = $Kernel::OM->Get('Kernel::System::LinkObject');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# define variables
my $ModuleName = 'TicketCreate';
my $RandomID   = $Helper->GetRandomID();

# set user details
my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate();

# Create another test user.
my ( $TestUserLogin2, $TestUserID2 ) = $Helper->TestUserCreate();

# use Test email backend
my $Success = $Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

$Self->True(
    $Success,
    'Set Email Test backend with true'
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
    "TicketCreate() - $TicketID"
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => $UserID,
);
$Self->True(
    IsHashRefWithData( \%Ticket ),
    "TicketGet() - Get Ticket with ID $TicketID."
);

my @AddedTickets = ($TicketID);

my $ArticleInternalBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );
my $ArticlePhoneBackendObject    = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );

my $AgentArticleID = $ArticleInternalBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    UserID               => $UserID,
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer A <customer-a@example.com>',
    Subject              => 'Subject from Agent',
    Body                 => 'A short text from the agent',
    Charset              => 'ISO-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
);

$Self->True(
    IsStringWithData($AgentArticleID),
    "Article (SenderType = agent) created.",
);

my $CustomerArticleID = $ArticlePhoneBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'customer',
    IsVisibleForCustomer => 1,
    UserID               => $UserID,
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer A <customer-a@example.com>',
    Subject              => 'Subject from Customer',
    Body                 => 'A short text from the customer',
    Charset              => 'ISO-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
);

$Self->True(
    IsStringWithData($CustomerArticleID),
    "Article (SenderType = customer) created.",
);

my $UserLogin = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserID => 1,
);

# create dynamic fields
my $DynamicFieldID1 = $DynamicFieldObject->DynamicFieldAdd(
    InternalField => 0,
    Name          => 'Field1' . $RandomID,
    Label         => 'a description',
    FieldOrder    => 10000,
    FieldType     => 'Text',
    ObjectType    => 'Ticket',
    Config        => {
        Name        => 'AnyName',
        Description => 'Description for Dynamic Field.',
    },
    Reorder => 1,
    ValidID => 1,
    UserID  => 1,
);
my $DynamicFieldID2 = $DynamicFieldObject->DynamicFieldAdd(
    InternalField => 0,
    Name          => 'Field2' . $RandomID,
    Label         => 'a description',
    FieldOrder    => 10000,
    FieldType     => 'Text',
    ObjectType    => 'Article',
    Config        => {
        Name        => 'AnyName',
        Description => 'Description for Dynamic Field.',
    },
    Reorder => 1,
    ValidID => 1,
    UserID  => 1,
);
my $DynamicFieldID3 = $DynamicFieldObject->DynamicFieldAdd(
    InternalField => 0,
    Name          => 'Field3' . $RandomID,
    Label         => 'a description',
    FieldOrder    => 10000,
    FieldType     => 'Multiselect',
    ObjectType    => 'Ticket',
    Config        => {
        Name            => 'AnyName',
        Description     => 'Description for Dynamic Field.',
        DefaultValue    => '',
        MultiselectSort => 'TreeView',
        PossibleNone    => 0,
        PossibleValues  => {
            1 => 'A',
            2 => 'B',
            3 => 'C',
        },
        TranslatableValues => 0,
    },
    Reorder => 1,
    ValidID => 1,
    UserID  => 1,
);

# sanity checks
for my $DynamicFieldID ( $DynamicFieldID1, $DynamicFieldID2, $DynamicFieldID3 ) {
    $Self->True(
        $DynamicFieldID,
        "DynamicFieldADD() - $DynamicFieldID"
    );

    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        ID     => $DynamicFieldID,
        UserID => 1,
    );
    $Self->True(
        IsHashRefWithData($DynamicField),
        "DynamicFieldGet() - Get DynamicField with ID $DynamicFieldID."
    );
}

#
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# set a value for multiselect dynamic field
my $DFSetSuccess = $DynamicFieldBackendObject->ValueSet(
    DynamicFieldConfig => {
        ID         => $DynamicFieldID3,
        FieldType  => 'Multiselect',
        ObjectType => 'Ticket',
        Config     => {
            PossibleValues => {
                1 => 'A',
                2 => 'B',
                3 => 'C',
            },
        }
    },
    ObjectID => $TicketID,
    Value    => [ 1, 2 ],
    UserID   => 1,
);

$Self->True(
    $DFSetSuccess,
    "DynamicField ValueSet() for DynamicFieldID $DynamicFieldID3 - with true"
);

# get ticket again now with dynamic fields
%Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    UserID        => $UserID,
    DynamicFields => 1,
);

my @PendingStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
    StateType => ['pending reminder'],
    Result    => 'ID',
);

# Run() tests
my @Tests = (
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
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::1::' . $RandomID,
                QueueID       => 1,
                Lock          => 'unlock',
                Priority      => '3 normal',
                StateID       => 1,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
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

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Parent',
                TimeUnit                       => 123,
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
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::1::' . $RandomID,
                QueueID       => 1,
                Lock          => 'unlock',
                Priority      => '3 normal',
                StateID       => 1,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
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

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Parent',
                TimeUnit                       => 123,
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
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::1::' . $RandomID,
                QueueID       => 1,
                Lock          => 'unlock',
                Priority      => '3 normal',
                StateID       => 1,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
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

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Parent',
                TimeUnit                       => 123,
            },
        },
        Success           => 1,
        UpdatePendingTime => 0,
    },
    {
        Name   => 'Correct ASCII (Witn Owner, not OwnerID)',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::1::' . $RandomID,
                QueueID       => 1,
                Lock          => 'unlock',
                Priority      => '3 normal',
                StateID       => 1,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                Owner         => $UserLogin,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
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

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Parent',
                TimeUnit                       => 123,
            },
        },
        Success           => 1,
        UpdatePendingTime => 0,
    },
    {
        Name   => 'Correct ASCII With Pending State',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::2::' . $RandomID,
                QueueID       => 1,
                Lock          => 'unlock',
                Priority      => '3 normal',
                StateID       => $PendingStateIDs[0],
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
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

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Parent',
                TimeUnit                       => 123,
            },
        },
        Success           => 1,
        UpdatePendingTime => 1,
    },
    {
        Name   => 'Correct UTF8',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::3::' . $RandomID,
                QueueID       => 1,
                Lock          => 'unlock',
                Priority      => '3 normal',
                StateID       => 1,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject              => 'some short description',
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

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Parent',
                TimeUnit                       => 123,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Default Values',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::4::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
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

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Parent',
                TimeUnit                       => 123,
            },
        },
        Success           => 1,
        UpdatePendingTime => 0,
    },
    {
        Name   => 'Correct Ticket->OwnerID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::5::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => '<OTRS_TICKET_OwnerID>',
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
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

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Child',
                TimeUnit                       => 123,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->Owner',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::5::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                Owner         => '<OTRS_TICKET_Owner>',
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
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

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Child',
                TimeUnit                       => 123,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->OwnerID No Article',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::5::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => '<OTRS_TICKET_OwnerID>',
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Child',
            },
        },
        Success => 1,
        Article => 0,
    },
    {
        Name   => 'Correct Ticket->Owner No Article',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::5::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                Owner         => '<OTRS_TICKET_Owner>',
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Child',
            },
        },
        Success => 1,
        Article => 0,
    },

    {
        Name   => 'Correct Ticket->DynamicField_Field3 No Article',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::5::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => '1',
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                "DynamicField_Field3$RandomID" => "<OTRS_TICKET_DynamicField_Field3$RandomID>",
            },
        },
        Success => 1,
        Article => 0,
    },
    {
        Name   => 'Correct Ticket->DynamicField_Field3_Value No Article',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::5::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => '1',
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                "DynamicField_Field1$RandomID" => "<OTRS_TICKET_DynamicField_Field3$RandomID" . '_Value>',
            },
        },
        Success => 1,
        Article => 0,
    },

    {
        Name   => 'Correct Ticket->NotExistent',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::6::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject              => 'some short description',
                Body                 => '<OTRS_Tiket_NotExisting>',
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

                "DynamicField_Field1$RandomID" => 'Ticket',
                "DynamicField_Field2$RandomID" => 'Article',
                LinkAs                         => 'Normal',
                TimeUnit                       => 123,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Using Different UserID',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::7::' . $RandomID,
                QueueID       => 1,
                Lock          => 'unlock',
                Priority      => '3 normal',
                StateID       => $PendingStateIDs[0],
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
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
                ForceNotificationToUserID       => '1, 43, 56',
                ExcludeNotificationToUserID     => '43, 56',
                ExcludeMuteNotificationToUserID => '43, 56',
                UserID                          => $TestUserID2,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Ticket->OTRS smart tags',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::8::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                IsVisibleForCustomer => 0,
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject              => '<OTRS_AGENT_SUBJECT>',
                Body                 => '<OTRS_CUSTOMER_BODY>',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',

                NoAgentNotify => 0,

                LinkAs   => 'Child',
                TimeUnit => 123,
            },
        },
        Success        => 1,
        CheckFromValue => 1,
    },

    {
        Name   => 'Correct Ticket Phone Article',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::9::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                CommunicationChannel => 'Phone',
                IsVisibleForCustomer => 0,
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject              => 'some subject',
                Body                 => 'some body',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',

                NoAgentNotify => 0,

                LinkAs   => 'Child',
                TimeUnit => 123,
            },
        },
        Success        => 1,
        Article        => 1,
        CheckFromValue => 1,
    },
    {
        Name   => 'Correct Ticket Email Article',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::10::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                CommunicationChannel => 'Email',
                IsVisibleForCustomer => 0,
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject              => 'some subject',
                Body                 => 'some body',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',

                NoAgentNotify => 0,

                LinkAs   => 'Child',
                TimeUnit => 123,
            },
        },
        Success        => 1,
        Article        => 1,
        CheckFromValue => 1,
    },
    {
        Name   => 'Correct Ticket Internal Article',
        Config => {
            UserID => $UserID,
            Ticket => \%Ticket,
            Config => {
                Title         => 'ProcessManagement::TransitionAction::TicketCreate::11::' . $RandomID,
                CustomerID    => '123465',
                CustomerUser  => 'customer@example.com',
                OwnerID       => 1,
                TypeID        => 1,
                ResponsibleID => 1,
                PendingTime   => '2014-12-23 23:05:00',

                SenderType           => 'agent',
                CommunicationChannel => 'Internal',
                IsVisibleForCustomer => 0,
                ContentType          => 'text/plain; charset=ISO-8859-15',
                Subject              => 'some subject',
                Body                 => 'some body',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',

                NoAgentNotify => 0,

                LinkAs   => 'Child',
                TimeUnit => 123,
            },
        },
        Success        => 1,
        Article        => 1,
        CheckFromValue => 1,
    },

);

my %ExcludedArtributes = (
    CustomerID                      => 1,
    CustomerUser                    => 1,
    "DynamicField_Field1$RandomID"  => 1,
    Lock                            => 1,
    Owner                           => 1,
    OwnerID                         => 1,
    PendingTime                     => 1,
    Priority                        => 1,
    QueueID                         => 1,
    ResponsibleID                   => 1,
    StateID                         => 1,
    Title                           => 1,
    TypeID                          => 1,
    HistoryType                     => 1,
    HistoryComment                  => 1,
    ExcludeNotificationToUserID     => 1,
    ForceNotificationToUserID       => 1,
    NoAgentNotify                   => 1,
    ExcludeMuteNotificationToUserID => 1,
    AutoResponseType                => 1,
    LinkAs                          => 1,
    TimeUnit                        => 1,
);

my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

for my $Test (@Tests) {

    # make a deep copy to avoid changing the definition
    my $OrigTest = Storable::dclone($Test);

    my $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketCreate')->Run(
        %{ $Test->{Config} },
        ProcessEntityID          => 'P1',
        ActivityEntityID         => 'A1',
        TransitionEntityID       => 'T1',
        TransitionActionEntityID => 'TA1',
    );

    $Test->{Article} //= 1;

    if ( $Test->{Success} ) {

        $Self->True(
            $Success,
            "$ModuleName Run() - Test:'$Test->{Name}' | executed with True"
        );

        # search for new created ticket
        my @TicketIDs = $TicketObject->TicketSearch(
            Result => 'ARRAY',
            Limit  => 1,
            Title  => $Test->{Config}->{Config}->{Title},
            UserID => 1,
        );

        my %Article;

        # set NewTicketID (if possible)
        my $NewTicketID;
        if (@TicketIDs) {
            $NewTicketID = $TicketIDs[0];

            # add NewTicketID to AddedTickets
            push @AddedTickets, $NewTicketID;

            # Get last article.
            if ( $Test->{Article} ) {
                my @Articles = $ArticleObject->ArticleList(
                    TicketID => $NewTicketID,
                    OnlyLast => 1,
                );

                my $ArticleBackendObject = $ArticleObject->BackendForArticle(
                    TicketID  => $NewTicketID,
                    ArticleID => $Articles[0]->{ArticleID},
                );

                %Article = $ArticleBackendObject->ArticleGet(
                    TicketID      => $NewTicketID,
                    ArticleID     => $Articles[0]->{ArticleID},
                    DynamicFields => 1,
                );

                # Check 'From' value of article (see bug#13867).
                if ( $Test->{CheckFromValue} ) {
                    $Self->True(
                        $Article{From} =~ /$TestUserLogin/,
                        "Article 'From' value is correct",
                    );
                }
            }
        }

        ATTRIBUTE:
        for my $Attribute ( sort keys %{ $Test->{Config}->{Config} } ) {

            next ATTRIBUTE if $ExcludedArtributes{$Attribute};

            my $ArticleAttribute = $Attribute;

            if ( $Test->{Article} ) {
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
                    defined $Article{$ArticleAttribute},
                    "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for ArticleID:"
                        . " $Article{ArticleID} exists with True"
                );
            }

            my $ExpectedValue = $Test->{Config}->{Config}->{$Attribute};
            if (
                $OrigTest->{Config}->{Config}->{$Attribute}
                && $OrigTest->{Config}->{Config}->{$Attribute}
                =~ m{\A<OTRS_TICKET_([A-Za-z0-9_]+)>\z}msx
                )
            {
                $ExpectedValue = $Ticket{$1} // '';
                if ( !ref $ExpectedValue && $OrigTest->{Config}->{Config}->{$Attribute} !~ m{_Value} ) {
                    $Self->IsNot(
                        $Test->{Config}->{Config}->{$Attribute},
                        $OrigTest->{Config}->{Config}->{$Attribute},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute value: $OrigTest->{Config}->{Config}->{$Attribute} should been replaced"
                    );
                    $Self->Is(
                        $Test->{Config}->{Config}->{$Attribute},
                        $Ticket{$Attribute},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute value:"
                    );

                }
                elsif ( $OrigTest->{Config}->{Config}->{$Attribute} =~ m{OTRS_TICKET_DynamicField_(\S+?)_Value} ) {
                    $Self->IsNot(
                        $Test->{Config}->{Config}->{$Attribute},
                        $OrigTest->{Config}->{Config}->{$Attribute},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute value: $OrigTest->{Config}->{Config}->{$Attribute} should been replaced"
                    );
                    my $DynamicFieldName = $1;

                    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                        Name => $DynamicFieldName,
                    );

                    my $DisplayValue = $DynamicFieldBackendObject->ValueLookup(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Key                => $Ticket{"DynamicField_$DynamicFieldName"},
                    );

                    my $DisplayValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $DisplayValue,
                    );

                    $Self->Is(
                        $Test->{Config}->{Config}->{$Attribute},
                        $DisplayValueStrg->{Value},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute value:"
                    );
                }
                elsif ( $OrigTest->{Config}->{Config}->{$Attribute} =~ m{<OTRS_TICKET_DynamicField_(\S+)>} ) {
                    $Self->IsNot(
                        $Test->{Config}->{Config}->{$Attribute},
                        $OrigTest->{Config}->{Config}->{$Attribute},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute value: $OrigTest->{Config}->{Config}->{$Attribute} should been replaced"
                    );
                    my $DynamicFieldName = $1;

                    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                        Name => $DynamicFieldName,
                    );

                    my $ValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $Ticket{"DynamicField_$DynamicFieldName"},
                    );

                    $Self->Is(
                        $Test->{Config}->{Config}->{$Attribute},
                        $ValueStrg->{Value},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute value:"
                    );
                }
                else {
                    $Self->IsNotDeeply(
                        $Test->{Config}->{Config}->{$Attribute},
                        $OrigTest->{Config}->{Config}->{$Attribute},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute value: $OrigTest->{Config}->{Config}->{$Attribute} should been replaced"
                    );
                    $Self->IsDeeply(
                        $Test->{Config}->{Config}->{$Attribute},
                        $Ticket{$Attribute},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute value:"
                    );
                }
            }
            elsif ( $Attribute eq 'PendingTime' && !$OrigTest->{UpdatePendingTime} ) {
                $ExpectedValue = 0;
            }
            elsif ( $Attribute eq 'PendingTime' && $OrigTest->{UpdatePendingTime} ) {
                $ExpectedValue = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $ExpectedValue,
                    }
                )->ToEpoch();
            }

            # TODO: currently disabled, re-enable it when AgentNotification is fully switch to NotificationEvent
            # # if article is created by another user it is automatically sent also to Owner
            # if ( $OrigTest->{Config}->{Config}->{UserID} && $Attribute eq 'To' ) {
            #     $ExpectedValue .= ', Admin OTRS <root@localhost>'
            # }

            if ( $Test->{Article} ) {
                if ( !ref $ExpectedValue && $OrigTest->{Config}->{Config}->{$Attribute} !~ m{_Value} ) {
                    $Self->Is(
                        $Article{$ArticleAttribute},
                        $ExpectedValue,
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for ArticleID:"
                            . " $Article{ArticleID} match expected value"
                    );
                }
                elsif ( $OrigTest->{Config}->{Config}->{$Attribute} =~ m{OTRS_TICKET_DynamicField_(\S+?)_Value} ) {

                    my $DynamicFieldName = $1;

                    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                        Name => $DynamicFieldName,
                    );

                    my $DisplayValue = $DynamicFieldBackendObject->ValueLookup(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Key                => $Ticket{"DynamicField_$DynamicFieldName"},
                    );

                    my $DisplayValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $DisplayValue,
                    );

                    $Self->Is(
                        $Article{$ArticleAttribute},
                        $DisplayValueStrg->{Value},
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for ArticleID:"
                            . " $Article{ArticleID} match expected value"
                    );
                }
                else {
                    $Self->IsDeeply(
                        $Article{$ArticleAttribute},
                        $ExpectedValue,
                        "$ModuleName - Test:'$Test->{Name}' | Attribute: $Attribute for ArticleID:"
                            . " $Article{ArticleID} match expected value"
                    );
                }
            }
        }

        if ( $OrigTest->{Config}->{Config}->{UserID} ) {
            $Self->Is(
                $Test->{Config}->{Config}->{UserID},
                undef,
                "$ModuleName - Test:'$Test->{Name}' | Attribute: UserID for TicketID:"
                    . " $TicketID should be removed (as it was used)"
            );
        }
        if ( $Test->{Config}->{Config}->{LinkAs} ) {

            # create a LinkLookup for easy check
            my %LinkLookup;

            my %TypeList = $LinkObject->TypeList(
                UserID => 1,
            );
            my $LinkList = $LinkObject->LinkList(
                Object => 'Ticket',
                Key    => $TicketID,
                State  => 'Valid',
                UserID => 1,
            );
            for my $ObjectType ( sort keys %{$LinkList} ) {
                for my $RelationType ( sort keys %{ $LinkList->{$ObjectType} } ) {
                    for my $RelationTypeWay (
                        sort keys %{ $LinkList->{$ObjectType}->{$RelationType} }
                        )
                    {
                        my $LinkType           = $TypeList{$RelationType}->{ $RelationTypeWay . 'Name' };
                        my %ObjectsPerRelation = %{
                            $LinkList->{$ObjectType}->{$RelationType}->{$RelationTypeWay}
                                || {}
                        };
                        for my $ObjectID ( sort keys %{ObjectsPerRelation} ) {
                            $LinkLookup{$ObjectID} = $LinkType;
                        }
                    }
                }
            }

            $Self->IsNot(
                $LinkLookup{$NewTicketID},
                undef,
                "$ModuleName - Test:'$Test->{Name}' | Link with original ticket is not undef"
            );

            $Self->Is(
                $LinkLookup{$NewTicketID},
                $Test->{Config}->{Config}->{LinkAs},
                "$ModuleName - Test:'$Test->{Name}' | Link with original ticket should be $Test->{Config}->{Config}->{LinkAs}"
            );
        }
        if ( $Test->{Config}->{Config}->{TimeUnit} && $Test->{Article} ) {
            my $AccountedTime = $ArticleObject->ArticleAccountedTimeGet(
                ArticleID => $Article{ArticleID},
            );
            $Self->Is(
                $AccountedTime,
                $Test->{Config}->{Config}->{TimeUnit},
                "$ModuleName - Test:'$Test->{Name}' | TimeUnit"
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
