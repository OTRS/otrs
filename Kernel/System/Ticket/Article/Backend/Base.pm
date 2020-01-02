# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Article::Backend::Base;

use strict;
use warnings;

use parent qw(Kernel::System::EventHandler);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::CommunicationChannel',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket::Article',
);

=head1 NAME

Kernel::System::Ticket::Article::Backend::Base - base class for article backends

=head1 DESCRIPTION

This is a base class for article backends and should not be instantiated directly.

    package Kernel::System::Ticket::Article::Backend::MyBackend;
    use strict;
    use warnings;

    use parent qw(Kernel::System::Ticket::Article::Backend::Base);

    # methods go here

=cut

=head1 PUBLIC INTERFACE

=head2 new()

Do not instantiate this class, instead use the real article backend classes.
Also, don't use the constructor directly, use the ObjectManager instead:

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MyBackend');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Die if someone tries to instantiate the base class.
    if ( $Type eq __PACKAGE__ ) {
        die 'Virtual method in base class must not be called.';
    }

    my $Self = {};
    bless( $Self, $Type );

    # init of event handler
    $Self->EventHandlerInit(
        Config => 'Ticket::EventModulePost',
    );

    return $Self;
}

=head2 ChannelNameGet()

Returns name of the communication channel used by the article backend. Used internally. Override this method in your
backend class.

    my $ChannelName = $ArticleBackendObject->ChannelNameGet();
    $ChannelName = 'MyBackend';

=cut

sub ChannelNameGet {
    die 'Virtual method in base class must not be called.';
}

=head2 ArticleHasHTMLContent()

Returns 1 if article has HTML content.

    my $ArticleHasHTMLContent = $ArticleBackendObject->ArticleHasHTMLContent(
        TicketID  => 1,
        ArticleID => 2,
        UserID    => 1,
    );

Result:

    $ArticleHasHTMLContent = 1;     # or 0

=cut

sub ArticleHasHTMLContent {
    die 'Virtual method in base class must not be called.';
}

=head2 ChannelIDGet()

Returns registered communication channel ID. Same for all article backends, don't override this
particular method. In case of invalid article backend, this method will return false value.

    my $ChannelID = $ArticleBackendObject->ChannelIDGet();
    $ChannelID = 1;

=cut

sub ChannelIDGet {
    my ( $Self, %Param ) = @_;

    return $Self->{CommunicationChannelID} if defined $Self->{CommunicationChannelID};

    return if $Self->ChannelNameGet() eq 'Invalid';

    # Get registered communication channel ID.
    my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
        ChannelName => $Self->ChannelNameGet(),
    );
    $Self->{CommunicationChannelID} = $CommunicationChannel{ChannelID};

    if ( !$Self->{CommunicationChannelID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't get channel ID for '"
                . $Self->ChannelNameGet()
                . "'. Communication channel not registered correctly!",
        );
        return;
    }

    return $Self->{CommunicationChannelID};
}

=head2 ArticleCreate()

Create an article. Override this method in your class.

    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => 123,
        SenderType           => 'agent',    # agent|system|customer
        IsVisibleForCustomer => 1,
        UserID               => 123,

        # Backend specific parameters:
        # From    => 'Some Agent <email@example.com>',
        # To      => 'Some Customer A <customer-a@example.com>',
        # Subject => 'some short description',
        # ...
    );

Events:
    ArticleCreate

=cut

sub ArticleCreate {
    die 'Virtual method in base class must not be called.';
}

=head2 ArticleUpdate()

Update an article. Override this method in your class.

    my $Success = $ArticleBackendObject->ArticleUpdate(
        TicketID  => 123,
        ArticleID => 123,
        Key       => 'Body',
        Value     => 'New Body',
        UserID    => 123,
    );

Events:
    ArticleUpdate

=cut

sub ArticleUpdate {
    die 'Virtual method in base class must not be called.';
}

=head2 ArticleGet()

Returns article data. Override this method in your class.

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => 123,
        ArticleID     => 123,
        DynamicFields => 1,

        # Backend specific parameters:
        # RealNames => 1,
    );

=cut

sub ArticleGet {
    die 'Virtual method in base class must not be called.';
}

=head2 ArticleDelete()

Delete an article. Override this method in your class.

    my $Success = $ArticleBackendObject->ArticleDelete(
        TicketID  => 123,
        ArticleID => 123,
        UserID    => 123,
    );

=cut

sub ArticleDelete {
    die 'Virtual method in base class must not be called.';
}

=head2 BackendSearchableFieldsGet()

Get article attachment index as hash.

    my %Index = $ArticleBackendObject->BackendSearchableFieldsGet();

Returns:

    my %BackendSearchableFieldsGet = {
        From    => 'from',
        To      => 'to',
        Cc      => 'cc',
        Subject => 'subject',
        Body    => 'body',
    };

=cut

sub BackendSearchableFieldsGet {
    die 'Virtual method in base class must not be called.';
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

    my %ArticleSearchData = [
        {
        'From'    => 'Test User1 <testuser1@example.com>',
        'To'      => 'Test User2 <testuser2@example.com>',
        'Cc'      => 'Test User3 <testuser3@example.com>',
        'Subject' => 'This is a test subject!',
        'Body'    => 'This is a body text!',
        ...
        },
    ];

=cut

sub ArticleSearchableContentGet {
    die 'Virtual method in base class must not be called.';
}

=head1 PRIVATE FUNCTIONS

Use following functions from backends only.

=head2 _MetaArticleCreate()

Create a new article.

    my $ArticleID = $Self->_MetaArticleCreate(
        TicketID             => 123,
        SenderType           => 'agent',    # agent|system|customer
        IsVisibleForCustomer => 0,
        CommunicationChannel => 'Email',
        UserID               => 1,
    );

Alternatively, you can pass in IDs too:

    my $ArticleID = $Self->_MetaArticleCreate(
        TicketID               => 123,
        SenderTypeID           => 1,
        IsVisibleForCustomer   => 0,
        CommunicationChannelID => 2,
        UserID                 => 1,
    );

=cut

sub _MetaArticleCreate {
    my ( $Self, %Param ) = @_;

    if ( $Param{SenderType} && !$Param{SenderTypeID} ) {
        $Param{SenderTypeID} = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSenderTypeLookup(
            SenderType => $Param{SenderType},
        );
    }

    my %Channel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
        ChannelID   => scalar $Param{CommunicationChannelID},
        ChannelName => scalar $Param{CommunicationChannel},
    );

    if ( !%Channel ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CommunicationChannelID!"
        );
        return;
    }

    for my $Needed (qw(TicketID SenderTypeID CommunicationChannelID UserID )) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    for my $Needed (qw(IsVisibleForCustomer)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => 32,
    );
    my $InsertFingerprint = $$ . '-' . $RandomString;

    return if !$DBObject->Do(
        SQL => 'INSERT INTO article
            (ticket_id, article_sender_type_id, is_visible_for_customer, communication_channel_id, insert_fingerprint, create_time, create_by, change_time, change_by)
            VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{TicketID}, \$Param{SenderTypeID}, \( $Param{IsVisibleForCustomer} ? 1 : 0 ), \$Channel{ChannelID},
            \$InsertFingerprint, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get article id
    return if !$DBObject->Prepare(
        SQL => 'SELECT id FROM article
            WHERE ticket_id = ?
                AND insert_fingerprint = ?
            ORDER BY id DESC',
        Bind  => [ \$Param{TicketID}, \$InsertFingerprint ],
        Limit => 1,
    );

    my $ArticleID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ArticleID = $Row[0];
    }

    # return if there is not article created
    if ( !$ArticleID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't get ArticleID from insert (TicketID=$Param{TicketID})!",
        );
        return;
    }

    $Kernel::OM->Get('Kernel::System::Ticket::Article')->_ArticleCacheClear(
        TicketID => $Param{TicketID},
    );

    return $ArticleID;
}

=head2 _MetaArticleUpdate()

Update an article.

Note: Keys C<SenderType>, C<SenderTypeID> and C<IsVisibleForCustomer> are implemented.

    my $Success = $Self->_MetaArticleUpdate(
        TicketID  => 123,                    # (required)
        ArticleID => 123,                    # (required)
        Key       => 'IsVisibleForCustomer', # (optional) If not provided, only ChangeBy and ChangeTime will be updated.
        Value     => 1,                      # (optional)
        UserID    => 123,                    # (required)
    );

    my $Success = $Self->_MetaArticleUpdate(
        TicketID  => 123,
        ArticleID => 123,
        Key       => 'SenderType',
        Value     => 'agent',
        UserID    => 123,
    );

Events:
    MetaArticleUpdate

=cut

sub _MetaArticleUpdate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ArticleID UserID TicketID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    if ( $Param{Key} && $Param{Key} eq 'SenderType' ) {
        $Param{Key}   = 'SenderTypeID';
        $Param{Value} = $Self->ArticleSenderTypeLookup(
            SenderType => $Param{Value},
        );
    }

    # map
    my %Map = (
        SenderTypeID         => 'article_sender_type_id',
        IsVisibleForCustomer => 'is_visible_for_customer',
    );

    my @Bind;
    my $SQL = '
        UPDATE article
        SET
    ';

    if ( $Param{Key} && $Map{ $Param{Key} } ) {

        if ( !defined $Param{Value} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Need Value!',
            );
            return;
        }

        $SQL .= "$Map{$Param{Key}} = ?, ";
        push @Bind, \$Param{Value};
    }

    $SQL .= '
            change_time = current_timestamp, change_by = ?
        WHERE id = ?
    ';

    push @Bind, ( \$Param{UserID}, \$Param{ArticleID} );

    # db update
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    $Kernel::OM->Get('Kernel::System::Ticket::Article')->_ArticleCacheClear(
        TicketID => $Param{TicketID},
    );

    return 1;
}

=head2 _MetaArticleGet()

Get article meta data.

    my %Article = $Self->_MetaArticleGet(
        ArticleID => 42,
        TicketID  => 23,
    );

Returns:

    %Article = (
        ArticleID              => 1,
        TicketID               => 2,
        CommunicationChannelID => 1,
        SenderTypeID           => 1,
        IsVisibleForCustomer   => 0,
        CreateTime             => ...,
        CreateBy               => ...,
        ChangeTime             => ...,
        ChangeBy               => ...,
    );


=cut

sub _MetaArticleGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ArticleID TicketID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Use ArticleList() internally to benefit from its ticket-level cache.
    my @MetaArticleIndex = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleList(
        TicketID  => $Param{TicketID},
        ArticleID => $Param{ArticleID},
    );

    return %{ $MetaArticleIndex[0] // {} };
}

=head2 _MetaArticleDelete()

Delete an article. This must be called B<after> all backend data has been deleted.

    my $Success = $Self->_MetaArticleDelete(
        ArticleID => 123,
        UserID    => 123,
        TicketID  => 123,
    );

=cut

sub _MetaArticleDelete {
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

    return if !$Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ObjectValuesDelete(
        ObjectType => 'Article',
        ObjectID   => $Param{ArticleID},
        UserID     => $Param{UserID},
    );

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # Delete related accounted time entries.
    return if !$ArticleObject->ArticleAccountedTimeDelete(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # Delete article from article search index.
    return if !$ArticleObject->ArticleSearchIndexDelete(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Remove all associated data for the article.
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM article_flag WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM ticket_history WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM mail_queue WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    # Finally, delete the meta article entry.
    return if !$DBObject->Do(
        SQL  => 'DELETE FROM article WHERE id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    $Kernel::OM->Get('Kernel::System::Ticket::Article')->_ArticleCacheClear(
        TicketID => $Param{TicketID},
    );

    return 1;
}

=head2 _MetaArticleDynamicFieldsGet()

Returns article content with dynamic fields.

    my %Data = $Self->_MetaArticleDynamicFieldsGet(
        Data => {            # (required) article data
            TicketID  => 1,
            ArticleID => 1,
            From      => 'agent@mail.org',
            To        => 'customer@mail.org',
            ...
        },
    );

Returns:
    %Data = (
        TicketID  => 1,
        ArticleID => 1,
        From      => 'agent@mail.org',
        To        => 'customer@mail.org',
        ...,
        DynamicField_A  => 'Value A',
        ...
    );

=cut

sub _MetaArticleDynamicFieldsGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Data} || ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );
        return;
    }

    my %Data = %{ $Param{Data} };

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $DynamicFieldArticleList = $DynamicFieldObject->DynamicFieldListGet(
        ObjectType => 'Article',
    );

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicFieldArticleList} ) {

        # Validate each dynamic field.
        next DYNAMICFIELD if !$DynamicFieldConfig;
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
        next DYNAMICFIELD if !IsHashRefWithData( $DynamicFieldConfig->{Config} );

        # Get the current value for each dynamic field.
        my $Value = $DynamicFieldBackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Data{ArticleID},
        );

        # Set the dynamic field name and value into the article hash.
        $Data{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $Value;
    }

    return %Data;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
