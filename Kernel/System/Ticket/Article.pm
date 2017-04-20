# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Article');

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
            $Param{CommunicationChannelID} = $BaseArticles[0]->{CommunicationChannelID},
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
            return;
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
        Bind  => [ \$Param{ArticleID}, \$Param{UserID} ],
        Limit => 1500,
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
        Bind  => [ \$Param{TicketID}, \$Param{UserID} ],
        Limit => 1500,
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

# TODO: check / fix
# article search index methods
sub ArticleIndexBuild {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->ArticleIndexBuild(%Param);
}

sub ArticleIndexDelete {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->ArticleIndexDelete(%Param);
}

sub ArticleIndexDeleteTicket {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->ArticleIndexDeleteTicket(%Param);
}

sub _ArticleIndexQuerySQL {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->_ArticleIndexQuerySQL(%Param);
}

sub _ArticleIndexQuerySQLExt {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get( $Self->{ArticleSearchIndexModule} )->_ArticleIndexQuerySQLExt(%Param);
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

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
