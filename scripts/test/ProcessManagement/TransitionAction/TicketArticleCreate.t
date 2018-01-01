# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

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

# define variables
my $UserID     = 1;
my $ModuleName = 'TicketArticleCreate';

# set user details
my $TestUserLogin = $Helper->TestUserCreate();
my $TestUserID    = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin,
);

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

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
                ArticleType    => 'note-internal',
                SenderType     => 'agent',
                ContentType    => 'text/plain; charset=ISO-8859-15',
                Subject        => 'some short description',
                Body           => 'the message text',
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
                NoAgentNotify             => 0,
                AutoResponseType          => 'auto reply',
                ForceNotificationToUserID => [ 1, 43, 56, ],
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
                ArticleType    => 'note-internal',
                SenderType     => 'agent',
                ContentType    => 'text/plain; charset=ISO-8859-15',
                Subject        => 'some short description',
                Body           => 'the message text',
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
                NoAgentNotify             => 0,
                AutoResponseType          => 'auto reply',
                ForceNotificationToUserID => [ 1, 43, 56, ],
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
                ArticleType    => 'note-internal',
                SenderType     => 'agent',
                ContentType    => 'text/plain; charset=ISO-8859-15',
                Subject        => 'some short description',
                Body           => 'the message text',
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
                NoAgentNotify             => 0,
                ForceNotificationToUserID => [ 1, 43, 56, ],
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
                ArticleType => 'note-internal',
                SenderType  => 'agent',
                ContentType => 'text/plain; charset=ISO-8859-15',
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
                NoAgentNotify             => 0,
                ForceNotificationToUserID => [ 1, 43, 56, ],
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
                ArticleType => 'note-internal',
                SenderType  => 'agent',
                ContentType => 'text/plain; charset=ISO-8859-15',
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
                NoAgentNotify             => 0,
                ForceNotificationToUserID => [ 1, 43, 56, ],
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
                ArticleType => 'note-internal',
                SenderType  => 'agent',
                ContentType => 'text/plain; charset=ISO-8859-15',
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
                NoAgentNotify             => 0,
                ForceNotificationToUserID => [ 1, 43, 56, ],
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
                ArticleType => 'note-internal',
                SenderType  => 'agent',
                ContentType => 'text/plain; charset=ISO-8859-15',
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
                NoAgentNotify             => 0,
                ForceNotificationToUserID => [ 1, 43, 56, ],
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
                ArticleType => 'note-internal',
                SenderType  => 'agent',
                ContentType => 'text/plain; charset=ISO-8859-15',
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
                NoAgentNotify             => 0,
                ForceNotificationToUserID => [ 1, 43, 56, ],
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
                ArticleType => 'note-internal',
                SenderType  => 'agent',
                ContentType => 'text/plain; charset=ISO-8859-15',
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
                NoAgentNotify             => 0,
                ForceNotificationToUserID => [ 1, 43, 56, ],
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
                ArticleType => 'note-internal',
                SenderType  => 'agent',
                ContentType => 'text/plain; charset=ISO-8859-15',
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
                NoAgentNotify             => 0,
                ForceNotificationToUserID => [ 1, 43, 56, ],
                ExcludeNotificationToUserID     => [ 43, 56, ],
                ExcludeMuteNotificationToUserID => [ 43, 56, ],
            },
        },
        Success => 1,
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
);

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
        my @ArticleIDs = $TicketObject->ArticleIndex(
            TicketID => $TicketID,
        );
        my %Article = $TicketObject->ArticleGet(
            ArticleID => $ArticleIDs[-1],
            UserID    => 1,
        );

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
