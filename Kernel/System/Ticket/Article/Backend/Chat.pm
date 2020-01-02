# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Article::Backend::Chat;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

use parent 'Kernel::System::Ticket::Article::Backend::Base';

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::Ticket::Article::Backend::Chat - backend class for chat based articles

=head1 DESCRIPTION

This class provides functions to manipulate chat based articles in the database.

Inherits from L<Kernel::System::Ticket::Article::Backend::MIMEBase>, please have a look there for its base API,
and below for the additional functions this backend provides.

=head1 PUBLIC INTERFACE

=cut

sub ChannelNameGet {
    return 'Chat';
}

=head2 ArticleCreate()

Create a chat article.

    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => 123,                              # (required)
        SenderTypeID         => 1,                                # (required)
                                                                  # or
        SenderType           => 'agent',                          # (required) agent|system|customer
        ChatMessageList      => [                                 # (required) Output from ChatMessageList()
            {
                ID              => 1,
                MessageText     => 'My chat message',
                CreateTime      => '2014-04-04 10:10:10',
                SystemGenerated => 0,
                ChatterID       => '123',
                ChatterType     => 'User',
                ChatterName     => 'John Doe',
            },
            ...
        ],
        IsVisibleForCustomer => 1,                                # (required) Is article visible for customer?
        UserID               => 123,                              # (required)
        HistoryType          => 'OwnerUpdate',                          # EmailCustomer|Move|AddNote|PriorityUpdate|WebRequestCustomer|...
        HistoryComment       => 'Some free text!',
    );

Events:
    ArticleCreate

=cut

sub ArticleCreate {
    my ( $Self, %Param ) = @_;

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # Lookup if no ID is passed.
    if ( $Param{SenderType} && !$Param{SenderTypeID} ) {
        $Param{SenderTypeID} = $ArticleObject->ArticleSenderTypeLookup( SenderType => $Param{SenderType} );
    }

    # check needed stuff
    for my $Needed (qw(TicketID UserID SenderTypeID ChatMessageList HistoryType HistoryComment)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !IsArrayRefWithData( $Param{ChatMessageList} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'ChatMessageList must be an array reference!',
        );
        return;
    }

    if ( !defined $Param{IsVisibleForCustomer} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need IsVisibleForCustomer!',
        );
        return;
    }

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # for the event handler, before any actions have taken place
    my %OldTicketData = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
    );

    # Check if this is the first article (for notifications).
    my @Articles     = $ArticleObject->ArticleList( TicketID => $Param{TicketID} );
    my $FirstArticle = scalar @Articles ? 0 : 1;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Create meta article.
    my $ArticleID = $Self->_MetaArticleCreate(
        TicketID               => $Param{TicketID},
        SenderTypeID           => $Param{SenderTypeID},
        IsVisibleForCustomer   => $Param{IsVisibleForCustomer},
        CommunicationChannelID => $Self->ChannelIDGet(),
        UserID                 => $Param{UserID},
    );
    if ( !$ArticleID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't create meta article (TicketID=$Param{TicketID})!",
        );
        return;
    }

    my $DBType = $DBObject->GetDatabaseFunction('Type');

    CHAT_MESSAGE:
    for my $ChatMessage ( @{ $Param{ChatMessageList} } ) {
        next CHAT_MESSAGE if !IsHashRefWithData($ChatMessage);

        my $Success = $DBObject->Do(
            SQL => '
                INSERT INTO article_data_otrs_chat
                    (article_id, chat_participant_id, chat_participant_name, chat_participant_type,
                        message_text, system_generated, create_time)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ',
            Bind => [
                \$ArticleID, \$ChatMessage->{ChatterID}, \$ChatMessage->{ChatterName}, \$ChatMessage->{ChatterType},
                \$ChatMessage->{MessageText}, \$ChatMessage->{SystemGenerated}, \$ChatMessage->{CreateTime},
            ],
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "System was unable to store data in article_data_otrs_chat table (ArticleID = $ArticleID)!",
            );
            return;
        }
    }

    $ArticleObject->_ArticleCacheClear(
        TicketID => $Param{TicketID},
    );

    # add history row
    $TicketObject->HistoryAdd(
        ArticleID    => $ArticleID,
        TicketID     => $Param{TicketID},
        CreateUserID => $Param{UserID},
        HistoryType  => $Param{HistoryType},
        Name         => $Param{HistoryComment},
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

    # unlock ticket if the owner is away (and the feature is enabled)
    if (
        $Param{UnlockOnAway}
        && $OldTicketData{Lock} eq 'lock'
        && $ConfigObject->Get('Ticket::UnlockOnAway')
        )
    {
        my %OwnerInfo = $UserObject->GetUserData(
            UserID => $OldTicketData{OwnerID},
        );

        if ( $OwnerInfo{OutOfOfficeMessage} ) {
            $TicketObject->TicketLockSet(
                TicketID => $Param{TicketID},
                Lock     => 'unlock',
                UserID   => $Param{UserID},
            );
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message =>
                    "Ticket [$OldTicketData{TicketNumber}] unlocked, current owner is out of office!",
            );
        }
    }

    $ArticleObject->ArticleSearchIndexBuild(
        TicketID  => $Param{TicketID},
        ArticleID => $ArticleID,
        UserID    => 1,
    );

    # event
    $Self->EventHandler(
        Event => 'ArticleCreate',
        Data  => {
            ArticleID     => $ArticleID,
            TicketID      => $Param{TicketID},
            OldTicketData => \%OldTicketData,
        },
        UserID => $Param{UserID},
    );

    # reset unlock if needed
    if ( !$Param{SenderType} ) {
        $Param{SenderType} = $ArticleObject->ArticleSenderTypeLookup( SenderTypeID => $Param{SenderTypeID} );
    }

    my $ObjectDateTime = $Kernel::OM->Create('Kernel::System::DateTime');

    # reset unlock time if customer sent an update
    if ( $Param{SenderType} eq 'customer' ) {

        # Check if previous sender was an agent.
        my $AgentSenderTypeID  = $ArticleObject->ArticleSenderTypeLookup( SenderType => 'agent' );
        my $SystemSenderTypeID = $ArticleObject->ArticleSenderTypeLookup( SenderType => 'system' );
        my @Articles           = $ArticleObject->ArticleList(
            TicketID => $Param{TicketID},
        );

        my $LastSenderTypeID;
        ARTICLE:
        for my $Article ( reverse @Articles ) {
            next ARTICLE if $Article->{ArticleID} eq $ArticleID;
            next ARTICLE if $Article->{SenderTypeID} eq $SystemSenderTypeID;
            $LastSenderTypeID = $Article->{SenderTypeID};
            last ARTICLE;
        }

        if ( $LastSenderTypeID && $LastSenderTypeID == $AgentSenderTypeID ) {
            $TicketObject->TicketUnlockTimeoutUpdate(
                UnlockTimeout => $ObjectDateTime->ToEpoch(),
                TicketID      => $Param{TicketID},
                UserID        => $Param{UserID},
            );
        }
    }

    # check if latest article is sent to customer
    elsif ( $Param{SenderType} eq 'agent' ) {
        $TicketObject->TicketUnlockTimeoutUpdate(
            UnlockTimeout => $ObjectDateTime->ToEpoch(),
            TicketID      => $Param{TicketID},
            UserID        => $Param{UserID},
        );
    }

    # return ArticleID
    return $ArticleID;
}

=head2 ArticleGet()

Returns single article data.

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => 123,   # (required)
        ArticleID     => 123,   # (required)
        DynamicFields => 1,     # (optional) To include the dynamic field values for this article on the return structure.
    );

Returns:

    %Article = (
        TicketID             => 123,
        ArticleID            => 123,
        ChatMessageList      => [
            {
                MessageText     => 'My chat message',
                CreateTime      => '2014-04-04 10:10:10',
                SystemGenerated => 0,
                ChatterID       => '123',
                ChatterType     => 'User',
                ChatterName     => 'John Doe',
            },
            ...
        ],
        SenderTypeID         => 1,
        SenderType           => 'agent',
        IsVisibleForCustomer => 1,
        CreateBy             => 1,
        CreateTime           => '2017-03-28 08:33:47',

        # If DynamicFields => 1 was passed, you'll get an entry like this for each dynamic field:
        DynamicField_X => 'value_x',
    );

=cut

sub ArticleGet {
    my ( $Self, %Param ) = @_;

    for my $Item (qw(TicketID ArticleID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!"
            );
            return;
        }
    }

    # Get meta article.
    my %Article = $Self->_MetaArticleGet(
        ArticleID => $Param{ArticleID},
        TicketID  => $Param{TicketID},
    );
    return if !%Article;

    if ( !$Article{SenderType} ) {
        my %ArticleSenderTypeList = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSenderTypeList();
        $Article{SenderType} = $ArticleSenderTypeList{ $Article{SenderTypeID} };
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
        SELECT id, chat_participant_id, chat_participant_name, chat_participant_type, message_text, system_generated,
            create_time
        FROM article_data_otrs_chat
        WHERE article_id = ?
        ORDER BY id ASC
    ';
    my @Bind = ( \$Param{ArticleID} );

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my @ChatMessageList;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        my %Data = (
            ID              => $Row[0],
            ChatterID       => $Row[1],
            ChatterName     => $Row[2],
            ChatterType     => $Row[3],
            MessageText     => $Row[4],
            SystemGenerated => $Row[5],
            CreateTime      => $Row[6],
        );

        push @ChatMessageList, \%Data;
    }

    $Article{ChatMessageList} = \@ChatMessageList;

    # Check if we also need to return dynamic field data.
    if ( $Param{DynamicFields} ) {
        my %DataWithDynamicFields = $Self->_MetaArticleDynamicFieldsGet(
            Data => \%Article,
        );
        %Article = %DataWithDynamicFields;
    }

    # Return if content is empty.
    if ( !%Article ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such article (TicketID=$Param{TicketID}, ArticleID=$Param{ArticleID})!",
        );
        return;
    }

    return %Article;
}

=head2 ArticleUpdate()

Update article data.

Note: Keys C<ChatMessageList>, C<SenderType>, C<SenderTypeID> and C<IsVisibleForCustomer> are implemented.

    my $Success = $ArticleBackendObject->ArticleUpdate(
        TicketID  => 123,                   # (required)
        ArticleID => 123,                   # (required)
        Key       => 'ChatMessageList',     # (optional)
        Value     => [                      # (optional)
            {
                MessageText     => 'My chat message (edited)',
                CreateTime      => '2014-04-04 10:10:10',
                SystemGenerated => 0,
                ChatterID       => '123',
                ChatterType     => 'User',
                ChatterName     => 'John Doe',
            },
            ...
        ],
        UserID => 123,                      # (required)
    );

    my $Success = $ArticleBackendObject->ArticleUpdate(
        TicketID  => 123,
        ArticleID => 123,
        Key       => 'SenderType',
        Value     => 'agent',
        UserID    => 123,
    );

Events:
    ArticleUpdate

=cut

sub ArticleUpdate {
    my ( $Self, %Param ) = @_;

    for my $Item (qw(TicketID ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # Lookup for sender type ID.
    if ( $Param{Key} eq 'SenderType' ) {
        $Param{Key}   = 'SenderTypeID';
        $Param{Value} = $ArticleObject->ArticleSenderTypeLookup(
            SenderType => $Param{Value},
        );
    }

    if ( $Param{Key} eq 'ChatMessageList' ) {
        if ( !IsArrayRefWithData( $Param{Value} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Value must be an array reference!',
            );
            return;
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # First, remove existing messages from storage.
        my $Success = $DBObject->Do(
            SQL => '
                DELETE FROM article_data_otrs_chat
                WHERE article_id = ?
            ',
            Bind => [ \$Param{ArticleID} ],
        );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "System was unable to remove data from article_data_otrs_chat table (ArticleID = $Param{ArticleID})!",
            );
            return;
        }

        my $DBType = $DBObject->GetDatabaseFunction('Type');

        # Add updated messages.
        CHAT_MESSAGE:
        for my $ChatMessage ( @{ $Param{Value} } ) {
            next CHAT_MESSAGE if !IsHashRefWithData($ChatMessage);

            my $Success = $DBObject->Do(
                SQL => '
                    INSERT INTO article_data_otrs_chat
                        (article_id, chat_participant_id, chat_participant_name, chat_participant_type,
                            message_text, system_generated, create_time)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                ',
                Bind => [
                    \$Param{ArticleID}, \$ChatMessage->{ChatterID}, \$ChatMessage->{ChatterName},
                    \$ChatMessage->{ChatterType},
                    \$ChatMessage->{MessageText}, \$ChatMessage->{SystemGenerated}, \$ChatMessage->{CreateTime},
                ],
            );

            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        "System was unable to store data in article_data_otrs_chat table (ArticleID = $Param{ArticleID})!",
                );
                return;
            }
        }
    }

    return if !$Self->_MetaArticleUpdate(
        %Param,
    );

    $ArticleObject->_ArticleCacheClear(
        TicketID => $Param{TicketID},
    );

    $ArticleObject->ArticleSearchIndexBuild(
        TicketID  => $Param{TicketID},
        ArticleID => $Param{ArticleID},
        UserID    => 1,
    );

    $Self->EventHandler(
        Event => 'ArticleUpdate',
        Data  => {
            TicketID  => $Param{TicketID},
            ArticleID => $Param{ArticleID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=head2 ArticleDelete()

Delete article data.

    my $Success = $ArticleBackendObject->ArticleDelete(
        TicketID  => 123,
        ArticleID => 123,
        UserID    => 123,
    );

=cut

sub ArticleDelete {    ## no critic;
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ArticleID TicketID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Delete all records related to the article.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            DELETE FROM article_data_otrs_chat
            WHERE article_id = ?
        ',
        Bind => [ \$Param{ArticleID} ],
    );

    # Delete meta article and associated data, and clear cache.
    return $Self->_MetaArticleDelete(
        %Param,
    );
}

=head2 BackendSearchableFieldsGet()

Get the definition of the searchable fields as a hash.

    my %SearchableFields = $ArticleBackendObject->BackendSearchableFieldsGet();

Returns:

    my %SearchableFields = (
        'Chat_ChatterName' => {
            Label      => 'Chat Participant',
            Key        => 'Chat_ChatterName',
            Type       => 'Text',
            Filterable => 0,
        },
        'Chat_MessageText' => {
            Label      => 'Message Text',
            Key        => 'Chat_MessageText',
            Type       => 'Text',
            Filterable => 1,
        },
    );

=cut

sub BackendSearchableFieldsGet {
    my ( $Self, %Param ) = @_;

    my %SearchableFields;

    return %SearchableFields if !$Kernel::OM->Get('Kernel::Config')->Get('ChatEngine::Active');

    %SearchableFields = (
        'Chat_ChatterName' => {
            Label      => Translatable('Chat Participant'),
            Key        => 'Chat_ChatterName',
            Type       => 'Text',
            Filterable => 0,
        },
        'Chat_MessageText' => {
            Label      => Translatable('Chat Message Text'),
            Key        => 'Chat_MessageText',
            Type       => 'Text',
            Filterable => 1,
        },
    );

    return %SearchableFields;
}

=head2 ArticleSearchableContentGet()

Get article attachment index as hash.

    my %Index = $ArticleBackendObject->ArticleSearchableContentGet(
        TicketID       => 123,   # (required)
        ArticleID      => 123,   # (required)
        DynamicFields  => 1,     # (optional) To include the dynamic field values for this article on the return structure.
        RealNames      => 1,     # (optional) To include the From/To/Cc fields with real names.
        UserID         => 123,   # (required)
    );

Returns:

my %ArticleSearchData = {
    'ChatterName'    => {
        String     => 'John Doe Jane Doe Joe Doe',
        Key        => 'ChatterName',
        Type       => 'Text',
        Filterable => 0,
    },
    'ChatterType'    => {
        String     => 'User User1 User2 User3',
        Key        => 'ChatterType',
        Type       => 'Text',
        Filterable => 0,
    },
    'MessageText'    => {
        String     => 'Chat message Second chat message Third chat message',
        Key        => 'Body',
        Type       => 'Text',
        Filterable => 1,
    }
};

=cut

sub ArticleSearchableContentGet {
    my ( $Self, %Param ) = @_;

    for my $Item (qw(TicketID ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!"
            );
            return;
        }
    }

    my %DataKeyMap = (
        'Chat_ChatterName' => 'ChatterName',
        'Chat_MessageText' => 'MessageText',
    );

    my %ArticleData = $Self->ArticleGet(
        TicketID      => $Param{TicketID},
        ArticleID     => $Param{ArticleID},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );

    my %BackendSearchableFields = $Self->BackendSearchableFieldsGet();

    my %ArticleSearchData;

    FIELDKEY:
    for my $FieldKey ( sort keys %BackendSearchableFields ) {

        my $IndexString = '';

        for my $ChatMessageList ( @{ $ArticleData{ChatMessageList} } ) {
            $IndexString .= ' ' . $ChatMessageList->{ $DataKeyMap{ $BackendSearchableFields{$FieldKey}->{Key} } };
        }

        next FIELDKEY if !IsStringWithData($IndexString);

        $ArticleSearchData{$FieldKey} = {
            String     => $IndexString,
            Key        => $BackendSearchableFields{$FieldKey}->{Key},
            Type       => $BackendSearchableFields{$FieldKey}->{Type} // 'Text',
            Filterable => $BackendSearchableFields{$FieldKey}->{Filterable} // 0,
        };
    }

    return %ArticleSearchData;
}

=head2 ArticleHasHTMLContent()

Returns 1 if article has HTML content.

    my $ArticleHasHTMLContent = $ArticleBackendObject->ArticleHasHTMLContent(
        TicketID  => 1,
        ArticleID => 2,
        UserID    => 1,
    );

Result:

    $ArticleHasHTMLContent = 1;

=cut

sub ArticleHasHTMLContent {
    my ( $Self, %Param ) = @_;

    return 1;
}

sub ArticleAttachmentIndex {
    my ( $Self, %Param ) = @_;

    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
