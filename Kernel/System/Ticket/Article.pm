# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Article;

use strict;
use warnings;

use parent qw(Kernel::System::EventHandler);

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::CommunicationChannel',
    'Kernel::System::DB',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket::Article::Backend::Invalid',
    'Kernel::System::Ticket',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::Ticket::Article - functions to manage ticket articles

=head1 DESCRIPTION

Since OTRS 6, article data is split in a neutral part for all articles (in the C<article> database table),
and back end specific data in custom tables (such as C<article_data_mime> for the C<MIME> based back ends).

This class only manages back end neutral article data, like listing articles with L</ArticleList()> or manipulating
article metadata like L</ArticleFlagSet()>.

For all operations involving back end specific article data (like C<ArticleCreate> and C<ArticleGet>),
please call L</BackendForArticle()> or L</BackendForChannel()> to get to the correct article back end.
See L</ArticleList()> for an example of looping over all article data of a ticket.

See L<Kernel::System::Ticket::Article::Backend::Base> for the definition of the basic interface of all
article back ends.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{CacheType} = 'Article';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    # init of event handler
    $Self->EventHandlerInit(
        Config => 'Ticket::EventModulePost',
    );

    # TODO: check if this can be removed after the new search is implemented.
    $Self->{ArticleSearchIndexModule} = $Param{ArticleSearchIndexModule}
        || $Kernel::OM->Get('Kernel::Config')->Get('Ticket::SearchIndexModule')
        || 'Kernel::System::Ticket::ArticleSearchIndex::RuntimeDB';

    return $Self;
}

=head2 BackendForArticle()

Returns the correct back end for a given article, or the
L<Invalid|Kernel::System::Ticket::Article::Backend::Invalid> back end, so that you can always expect
a back end object instance that can be used for chain-calling.

    my $ArticleBackendObject = $ArticleObject->BackendForArticle( TicketID => 42, ArticleID => 123 );

Alternatively, you can pass in a hash with base article data as returned by L</ArticleList()>, this will avoid the
lookup for the C<CommunicationChannelID> of the article:

    my $ArticleBackendObject = $ArticleObject->BackendForArticle( %BaseArticle );

See L<Kernel::System::Ticket::Article::Backend::Base> for the definition of the basic interface of all
article back ends.

=cut

sub BackendForArticle {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Invalid');
        }
    }

    if ( !$Param{CommunicationChannelID} ) {
        my @BaseArticles = $Self->ArticleList(
            TicketID  => $Param{TicketID},
            ArticleID => $Param{ArticleID},
        );
        if (@BaseArticles) {
            $Param{CommunicationChannelID} = $BaseArticles[0]->{CommunicationChannelID};
        }
    }

    if ( $Param{CommunicationChannelID} ) {
        my $ChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelObjectGet(
            ChannelID => $Param{CommunicationChannelID},
        );
        return $ChannelObject->ArticleBackend() if $ChannelObject && $ChannelObject->can('ArticleBackend');
    }

    # Fall back to the invalid back end to enable chain calling.
    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Invalid');
}

=head2 BackendForChannel()

Returns the correct back end for a given communication channel, or the C<Invalid> back end, so that you can always expect
a back end object instance that can be used for chain-calling.

    my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

See L<Kernel::System::Ticket::Article::Backend::Base> for the definition of the basic interface of all
article back ends.

=cut

sub BackendForChannel {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ChannelName)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Invalid');
        }
    }

    my $ChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelObjectGet(
        ChannelName => $Param{ChannelName},
    );
    return $ChannelObject->ArticleBackend() if $ChannelObject && $ChannelObject->can('ArticleBackend');

    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Invalid');
}

=head2 ArticleList()

Returns an filtered array of base article data for a ticket.

    my @Articles = $ArticleObject->ArticleList(

        TicketID               => 123,

        # Optional filters, these can be combined:

        ArticleID              => 234,                # optional, limit to one article (if present on a ticket)
        CommunicationChannel   => 'Email',            # optional, to limit to a certain CommunicationChannel
        CommunicationChannelID => 2,                  # optional, to limit to a certain CommunicationChannelID
        SenderType             => 'customer',         # optional, to limit to a certain article SenderType
        SenderTypeID           => 2,                  # optional, to limit to a certain article SenderTypeID
        IsVisibleForCustomer   => 0,                  # optional, to limit to a certain visibility

        # After filtering, you can also limit to first or last found article only:

        OnlyFirst              => 0,                  # optional, only return first match
        OnlyLast               => 0,                  # optional, only return last match
    );

Returns a list with base article data (no back end related data included):

    (
        {
            ArticleID              => 1,
            TicketID               => 2,
            ArticleNumber          => 1,                        # sequential number of article in the ticket
            CommunicationChannelID => 1,
            SenderTypeID           => 1,
            IsVisibleForCustomer   => 0,
            CreateBy               => 1,
            CreateTime             => '2017-03-01 00:00:00',
            ChangeBy               => 1,
            ChangeTime             => '2017-03-01 00:00:00',
        },
        { ... }
    )

Please note that you need to use L<ArticleGet()|Kernel::System::Ticket::Article::Backend::Base/ArticleGet()> via the
article backend objects to access the full backend-specific article data hash for each article.

    for my $MetaArticle (@Articles) {
        my %Article = $ArticleObject->BackendForArticle( %{$MetaArticle} )->ArticleGet( %{$MetaArticle} );
    }

=cut

sub ArticleList {
    my ( $Self, %Param ) = @_;

    if ( !$Param{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketID!',
        );
        return;
    }

    if ( $Param{OnlyFirst} && $Param{OnlyLast} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'OnlyFirst and OnlyLast cannot be used together!',
        );
        return;
    }

    my @MetaArticleList = $Self->_MetaArticleList(%Param);
    return if !@MetaArticleList;

    if ( $Param{ArticleID} ) {
        @MetaArticleList = grep { $_->{ArticleID} == $Param{ArticleID} } @MetaArticleList;
    }

    if ( $Param{CommunicationChannel} || $Param{CommunicationChannelID} ) {
        my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
            ChannelID   => scalar $Param{CommunicationChannelID},
            ChannelName => scalar $Param{CommunicationChannel},
        );
        if ( !%CommunicationChannel ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "CommunicationChannel $Param{CommunicationChannel} was not found!",
            );
            return;
        }
        @MetaArticleList = grep { $_->{CommunicationChannelID} == $CommunicationChannel{ChannelID} } @MetaArticleList;

    }

    if ( $Param{SenderType} || $Param{SenderTypeID} ) {
        my $SenderTypeID = $Param{SenderTypeID} || $Self->ArticleSenderTypeLookup( SenderType => $Param{SenderType} );
        if ( !$SenderTypeID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Article SenderType $Param{SenderType} was not found!",
            );
            return;
        }
        @MetaArticleList = grep { $_->{SenderTypeID} == $SenderTypeID } @MetaArticleList;
    }

    if ( defined $Param{IsVisibleForCustomer} ) {
        @MetaArticleList = grep { $_->{IsVisibleForCustomer} == $Param{IsVisibleForCustomer} } @MetaArticleList;
    }

    if ( $Param{OnlyFirst} && @MetaArticleList ) {
        @MetaArticleList = ( $MetaArticleList[0] );
    }
    elsif ( $Param{OnlyLast} && @MetaArticleList ) {
        @MetaArticleList = ( $MetaArticleList[-1] );
    }

    return @MetaArticleList;
}

=head2 TicketIDLookup()

Get a ticket ID for supplied article ID.

    my $TicketID = $ArticleObject->TicketIDLookup(
        ArticleID => 123,   # required
    );

Returns ID of a ticket that article belongs to:

    $TicketID = 123;

NOTE: Usage of this lookup function is strongly discouraged, since its result is not cached.
Where possible, use C<ArticleList()> instead.

=cut

sub TicketIDLookup {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!',
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => '
            SELECT ticket_id
            FROM article
            WHERE id = ?
        ',
        Bind  => [ \$Param{ArticleID} ],
        Limit => 1,
    );

    my $TicketID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $TicketID = $Row[0];
    }

    return $TicketID;
}

=head2 ArticleFlagSet()

Set article flags.

    my $Success = $ArticleObject->ArticleFlagSet(
        TicketID  => 123,
        ArticleID => 123,
        Key       => 'Seen',
        Value     => 1,
        UserID    => 123,
    );

Events:
    ArticleFlagSet

=cut

sub ArticleFlagSet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID Key Value UserID)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my %Flag = $Self->ArticleFlagGet(%Param);

    # check if set is needed
    return 1 if defined $Flag{ $Param{Key} } && $Flag{ $Param{Key} } eq $Param{Value};

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # set flag
    return if !$DBObject->Do(
        SQL => '
            DELETE FROM article_flag
            WHERE article_id = ?
                AND article_key = ?
                AND create_by = ?',
        Bind => [ \$Param{ArticleID}, \$Param{Key}, \$Param{UserID} ],
    );
    return if !$DBObject->Do(
        SQL => 'INSERT INTO article_flag
            (article_id, article_key, article_value, create_time, create_by)
            VALUES (?, ?, ?, current_timestamp, ?)',
        Bind => [ \$Param{ArticleID}, \$Param{Key}, \$Param{Value}, \$Param{UserID} ],
    );

    # event
    $Self->EventHandler(
        Event => 'ArticleFlagSet',
        Data  => {
            TicketID  => $Param{TicketID},
            ArticleID => $Param{ArticleID},
            Key       => $Param{Key},
            Value     => $Param{Value},
            UserID    => $Param{UserID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=head2 ArticleFlagDelete()

Delete an article flag.

    my $Success = $ArticleObject->ArticleFlagDelete(
        TicketID  => 123,
        ArticleID => 123,
        Key       => 'seen',
        UserID    => 123,
    );

    my $Success = $ArticleObject->ArticleFlagDelete(
        TicketID  => 123,
        ArticleID => 123,
        Key       => 'seen',
        AllUsers  => 1,         # delete for all users
    );

Events:
    ArticleFlagDelete

=cut

sub ArticleFlagDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID ArticleID Key)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    if ( !$Param{AllUsers} && !$Param{UserID} ) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need AllUsers or UserID!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{AllUsers} ) {
        return if !$DBObject->Do(
            SQL => '
                DELETE FROM article_flag
                WHERE article_id = ?
                    AND article_key = ?',
            Bind => [ \$Param{ArticleID}, \$Param{Key} ],
        );
    }
    else {
        return if !$DBObject->Do(
            SQL => '
                DELETE FROM article_flag
                WHERE article_id = ?
                    AND create_by = ?
                    AND article_key = ?',
            Bind => [ \$Param{ArticleID}, \$Param{UserID}, \$Param{Key} ],
        );

        # event
        $Self->EventHandler(
            Event => 'ArticleFlagDelete',
            Data  => {
                TicketID  => $Param{TicketID},
                ArticleID => $Param{ArticleID},
                Key       => $Param{Key},
                UserID    => $Param{UserID},
            },
            UserID => $Param{UserID},
        );
    }

    return 1;
}

=head2 ArticleFlagGet()

Get article flags.

    my %Flags = $ArticleObject->ArticleFlagGet(
        ArticleID => 123,
        UserID    => 123,
    );

=cut

sub ArticleFlagGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql query
    return if !$DBObject->Prepare(
        SQL => '
            SELECT article_key, article_value
            FROM article_flag
            WHERE article_id = ?
                AND create_by = ?',
        Bind => [ \$Param{ArticleID}, \$Param{UserID} ],
    );

    my %Flag;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Flag{ $Row[0] } = $Row[1];
    }

    return %Flag;
}

=head2 ArticleFlagsOfTicketGet()

Get all article flags of a ticket.

    my %Flags = $ArticleObject->ArticleFlagsOfTicketGet(
        TicketID  => 123,
        UserID    => 123,
    );

    returns (
        123 => {                    # ArticleID
            'Seen'  => 1,
            'Other' => 'something',
        },
    )

=cut

sub ArticleFlagsOfTicketGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql query
    return if !$DBObject->Prepare(
        SQL => '
            SELECT article.id, article_flag.article_key, article_flag.article_value
            FROM article_flag, article
            WHERE article.id = article_flag.article_id
                AND article.ticket_id = ?
                AND article_flag.create_by = ?',
        Bind => [ \$Param{TicketID}, \$Param{UserID} ],
    );

    my %Flag;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Flag{ $Row[0] }->{ $Row[1] } = $Row[2];
    }

    return %Flag;
}

=head2 ArticleAccountedTimeGet()

Returns the accounted time of a article.

    my $AccountedTime = $ArticleObject->ArticleAccountedTimeGet(
        ArticleID => $ArticleID,
    );

=cut

sub ArticleAccountedTimeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!'
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db query
    return if !$DBObject->Prepare(
        SQL  => 'SELECT time_unit FROM time_accounting WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    my $AccountedTime = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Row[0] =~ s/,/./g;
        $AccountedTime = $AccountedTime + $Row[0];
    }

    return $AccountedTime;
}

=head2 ArticleAccountedTimeDelete()

Delete accounted time of an article.

    my $Success = $ArticleObject->ArticleAccountedTimeDelete(
        ArticleID => $ArticleID,
    );

=cut

sub ArticleAccountedTimeDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!'
        );
        return;
    }

    # db query
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM time_accounting WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    return 1;
}

=head2 ArticleSenderTypeList()

List all article sender types.

    my %ArticleSenderTypeList = $ArticleObject->ArticleSenderTypeList();

Returns:

    (
        1 => 'agent',
        2 => 'customer',
        3 => 'system',
    )

=cut

sub ArticleSenderTypeList {
    my ( $Self, %Param ) = @_;

    my $CacheKey = 'ArticleSenderTypeList';

    # Is there a cached value yet?
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if ref $Cache eq 'HASH';

    my $DBObject    = $Kernel::OM->Get('Kernel::System::DB');
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    return if !$DBObject->Prepare(
        SQL => "SELECT id, name FROM article_sender_type WHERE "
            . "valid_id IN (${\(join ', ', $ValidObject->ValidIDsGet())})",
    );

    my %Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result{ $Row[0] } = $Row[1];
    }

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Result,
    );
    return %Result;
}

=head2 ArticleSenderTypeLookup()

Lookup an article sender type id or name.

    my $SenderTypeID = $ArticleObject->ArticleSenderTypeLookup(
        SenderType => 'customer', # customer|system|agent
    );

    my $SenderType = $ArticleObject->ArticleSenderTypeLookup(
        SenderTypeID => 1,
    );

=cut

sub ArticleSenderTypeLookup {
    my ( $Self, %Param ) = @_;

    if ( !$Param{SenderType} && !$Param{SenderTypeID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SenderType or SenderTypeID!',
        );
        return;
    }

    my %SenderTypes = $Self->ArticleSenderTypeList( Result => 'HASH' );

    if ( $Param{SenderTypeID} ) {
        return $SenderTypes{ $Param{SenderTypeID} };
    }
    return { reverse %SenderTypes }->{ $Param{SenderType} };
}

=head2 ArticleSearchIndexRebuildFlagSet()

Set the article flags to indicate if the article search index needs to be rebuilt.

    my $Success = $ArticleObject->ArticleSearchIndexRebuildFlagSet(
        ArticleIDs => [ 123, 234, 345 ]   # (Either 'ArticleIDs' or 'All' must be provided) The ArticleIDs to be updated.
        All        => 1                   # (Either 'ArticleIDs' or 'All' must be provided) Set all articles to $Value. Default: 0,
        Value      => 1, # 0/1 default 0
    );

=cut

sub ArticleSearchIndexRebuildFlagSet {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{All} && !IsArrayRefWithData( $Param{ArticleIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Either ArticleIDs or All parameter must be provided!"
        );
        return;
    }

    $Param{All}        //= 0;
    $Param{ArticleIDs} //= [];
    $Param{Value} = $Param{Value} ? 1 : 0;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{All} ) {

        return if !$DBObject->Do(
            SQL  => "UPDATE article SET search_index_needs_rebuild = ?",
            Bind => [ \$Param{Value}, ],
        );

        return 1;
    }

    my $InCondition = $DBObject->QueryInCondition(
        Key       => 'id',
        Values    => $Param{ArticleIDs},
        QuoteType => 'Integer',
    );

    return if !$DBObject->Do(
        SQL => "
            UPDATE article
            SET search_index_needs_rebuild = ?
            WHERE $InCondition",
        Bind => [ \$Param{Value}, ],
    );

    return 1;
}

=head2 ArticleSearchIndexRebuildFlagList()

Get a list of ArticleIDs and TicketIDs for a given flag (either needs rebuild or not)

    my %ArticleTicketIDs = $ArticleObject->ArticleSearchIndexRebuildFlagList(
        Value => 1,     # (optional) 0/1 default 0
        Limit => 10000, # (optional) default: 20000
    );

Returns:

    %ArticleIDs = (
        1 => 2, # ArticleID => TicketID
        3 => 4,
        5 => 6,
        ...
    );

=cut

sub ArticleSearchIndexRebuildFlagList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Value)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    $Param{Value} = $Param{Value} ? 1 : 0;
    $Param{Limit} //= 20000;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql query
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, ticket_id
            FROM article
            WHERE search_index_needs_rebuild = ?',
        Bind  => [ \$Param{Value}, ],
        Limit => $Param{Limit},
    );

    my %ArticleIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ArticleIDs{ $Row[0] } = $Row[1];
    }

    return %ArticleIDs;
}

=head2 ArticleSearchIndexStatus()

gets an article indexing status hash.

    my %Status = $ArticleObject->ArticleSearchIndexStatus();

Returns:

    %Status = (
        ArticlesTotal      => 443,
        ArticlesIndexed    => 420,
        ArticlesNotIndexed =>  23,
    );

=cut

sub ArticleSearchIndexStatus {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT count(*) FROM article WHERE search_index_needs_rebuild = 0',
    );

    my %Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result{ArticlesIndexed} = $Row[0];
    }

    return if !$DBObject->Prepare(
        SQL => 'SELECT count(*) FROM article WHERE search_index_needs_rebuild = 1',
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result{ArticlesNotIndexed} = $Row[0];
    }

    $Result{ArticlesTotal} = $Result{ArticlesIndexed} + $Result{ArticlesNotIndexed};

    return %Result;
}

=head2 ArticleSearchIndexBuild()

Rebuilds the current article search index table content. Existing article entries will be replaced.

    my $Success = $ArticleObject->ArticleSearchIndexBuild(
        TicketID  => 123,
        ArticleID => 123,
        UserID    => 1,
    );

Returns:

    True if indexing process was successfully finished, False if not.

=cut

sub ArticleSearchIndexBuild {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->ArticleSearchIndexBuild(%Param);
}

=head2 ArticleSearchIndexDelete()

Deletes entries from the article search index table base on supplied C<ArticleID> or C<TicketID>.

    my $Success = $ArticleObject->ArticleSearchIndexDelete(
        ArticleID => 123,   # required, deletes search index for single article
                            # or
        TicketID  => 123,   # required, deletes search index for all ticket articles

        UserID    => 1,     # required
    );

Returns:

    True if delete process was successfully finished, False if not.

=cut

sub ArticleSearchIndexDelete {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->ArticleSearchIndexDelete(%Param);
}

=head2 ArticleSearchIndexSQLJoinNeeded()

Checks the given search parameters for used article backend fields.

    my $Needed = $ArticleObject->ArticleSearchIndexSQLJoinNeeded(
        SearchParams => {
            ...
            ConditionInline         => 1,
            ContentSearchPrefix     => '*',
            ContentSearchSuffix     => '*',
            MIMEBase_From           => '%spam@example.com%',
            MIMEBase_To             => '%service@example.com%',
            MIMEBase_Cc             => '%client@example.com%',
            MIMEBase_Subject        => '%VIRUS 32%',
            MIMEBase_Body           => '%VIRUS 32%',
            MIMEBase_AttachmentName => '%anyfile.txt%',
            Chat_ChatterName        => '%Some Chatter Name%',
            Chat_MessageText        => '%Some Message Text%'
            ...
        },
    );

Returns:

    True if article search index usage is needed, False if not.

=cut

sub ArticleSearchIndexSQLJoinNeeded {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->ArticleSearchIndexSQLJoinNeeded(%Param);
}

=head2 ArticleSearchIndexSQLJoin()

Generates SQL string extensions, including the needed table joins for the article index search.

    my $SQLExtenion = $ArticleObject->ArticleSearchIndexSQLJoin(
        SearchParams => {
            ...
            ConditionInline         => 1,
            ContentSearchPrefix     => '*',
            ContentSearchSuffix     => '*',
            MIMEBase_From           => '%spam@example.com%',
            MIMEBase_To             => '%service@example.com%',
            MIMEBase_Cc             => '%client@example.com%',
            MIMEBase_Subject        => '%VIRUS 32%',
            MIMEBase_Body           => '%VIRUS 32%',
            MIMEBase_AttachmentName => '%anyfile.txt%',
            Chat_ChatterName        => '%Some Chatter Name%',
            Chat_MessageText        => '%Some Message Text%'
            ...
        },
    );

Returns:

    $SQLExtension = 'LEFT JOIN article_search_index ArticleFulltext ON art.id = ArticleFulltext.article_id ';

=cut

sub ArticleSearchIndexSQLJoin {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->ArticleSearchIndexSQLJoin(%Param);
}

=head2 ArticleSearchIndexWhereCondition()

Generates SQL query conditions for the used article fields, that may be used in the WHERE clauses of main
SQL queries to the database.

    my $SQLExtenion = $ArticleObject->ArticleSearchIndexWhereCondition(
        SearchParams => {
            ...
            ConditionInline         => 1,
            ContentSearchPrefix     => '*',
            ContentSearchSuffix     => '*',
            MIMEBase_From           => '%spam@example.com%',
            MIMEBase_To             => '%service@example.com%',
            MIMEBase_Cc             => '%client@example.com%',
            MIMEBase_Subject        => '%VIRUS 32%',
            MIMEBase_Body           => '%VIRUS 32%',
            MIMEBase_AttachmentName => '%anyfile.txt%',
            Chat_ChatterName        => '%Some Chatter Name%',
            Chat_MessageText        => '%Some Message Text%'
            ...
        },
    );

Returns:

    $SQLConditions = " AND (MIMEBase_From.article_value LIKE '%spam@example.com%') ";

=cut

sub ArticleSearchIndexWhereCondition {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->ArticleSearchIndexWhereCondition(%Param);
}

=head2 SearchStringStopWordsFind()

Find stop words within given search string.

    my $StopWords = $ArticleObject->SearchStringStopWordsFind(
        SearchStrings => {
            'Fulltext'      => '(this AND is) OR test',
            'MIMEBase_From' => 'myself',
        },
    );

    Returns Hashref with found stop words.

=cut

sub SearchStringStopWordsFind {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->SearchStringStopWordsFind(%Param);
}

=head2 SearchStringStopWordsUsageWarningActive()

Checks if warnings for stop words in search strings are active or not.

    my $WarningActive = $ArticleObject->SearchStringStopWordsUsageWarningActive();

=cut

sub SearchStringStopWordsUsageWarningActive {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->SearchStringStopWordsUsageWarningActive(%Param);
}

=head2 ArticleSearchableFieldsList()

Get list of searchable fields across all article backends.

    my %SearchableFields = $ArticleObject->ArticleSearchableFieldsList();

Returns:

    %SearchableFields = (
        'MIMEBase_Body' => {
            Filterable => 1,
            Key        => 'MIMEBase_Body',
            Label      => 'Body',
            Type       => 'Text',
        },
        'MIMEBase_Subject' => {
            Filterable => 1,
            Key        => 'MIMEBase_Subject',
            Label      => 'Subject',
            Type       => 'Text',
        },
        ...
    );

=cut

sub ArticleSearchableFieldsList {
    my ( $Self, %Param ) = @_;

    my @CommunicationChannels = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelList(
        ValidID => 1,
    );

    my %SearchableFields;

    for my $Channel (@CommunicationChannels) {

        my $CurrentArticleBackendObject = $Self->BackendForChannel(
            ChannelName => $Channel->{ChannelName},
        );

        my %BackendSearchableFields = $CurrentArticleBackendObject->BackendSearchableFieldsGet();

        %SearchableFields = ( %SearchableFields, %BackendSearchableFields );
    }

    return %SearchableFields;
}

=head1 PRIVATE FUNCTIONS

=head2 _MetaArticleList()

Returns an array-hash with the meta articles of the current ticket.

    my @MetaArticles = $ArticleObject->_MetaArticleList(
        TicketID => 123,
    );

Returns:

    (
        {
            ArticleID              => 1,
            TicketID               => 2,
            ArticleNumber          => 1,                        # sequential number of article in the ticket
            CommunicationChannelID => 1,
            SenderTypeID           => 1,
            IsVisibleForCustomer   => 0,
            CreateBy               => 1,
            CreateTime             => '2017-03-01 00:00:00',
            ChangeBy               => 1,
            ChangeTime             => '2017-03-01 00:00:00',
        },
        { ... },
    )


=cut

sub _MetaArticleList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketID!'
        );
        return;
    }

    my $CacheKey = '_MetaArticleList::' . $Param{TicketID};

    my $Cached = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    if ( ref $Cached eq 'ARRAY' ) {
        return @{$Cached};
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, ticket_id, communication_channel_id, article_sender_type_id, is_visible_for_customer,
                        create_by, create_time, change_by, change_time
            FROM article
            WHERE ticket_id = ?
            ORDER BY id ASC',
        Bind => [ \$Param{TicketID} ],
    );

    my @Index;
    my $Count;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %Result;
        $Result{ArticleID}              = $Row[0];
        $Result{TicketID}               = $Row[1];
        $Result{CommunicationChannelID} = $Row[2];
        $Result{SenderTypeID}           = $Row[3];
        $Result{IsVisibleForCustomer}   = $Row[4];
        $Result{CreateBy}               = $Row[5];
        $Result{CreateTime}             = $Row[6];
        $Result{ChangeBy}               = $Row[7];
        $Result{ChangeTime}             = $Row[8];
        $Result{ArticleNumber}          = ++$Count;
        push @Index, \%Result;
    }

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \@Index,
    );

    return @Index;
}

=head2 _ArticleCacheClear()

Removes all article caches related to specified ticket.

    my $Success = $ArticleObject->_ArticleCacheClear(
        TicketID => 123,
    );

=cut

sub _ArticleCacheClear {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # MetaArticleIndex()
    $CacheObject->Delete(
        Type => $Self->{CacheType},
        Key  => '_MetaArticleList::' . $Param{TicketID},
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
