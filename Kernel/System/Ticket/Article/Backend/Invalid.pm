# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Article::Backend::Invalid;

use strict;
use warnings;

use parent qw(
    Kernel::System::EventHandler
    Kernel::System::Ticket::Article::Backend::Base
);

our @ObjectDependencies = (
    'Kernel::System::CommunicationChannel',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Ticket::Article',
);

=head1 NAME

Kernel::System::Ticket::Article::Backend::Invalid - backend for articles that have an unknown communication channel

=head1 DESCRIPTION

This is a fallback backend which exists for two purposes: first, to make sure that you can always chain-call on
C<BackendForArticle>, even if the article has a communication channel that is missing in the system. And second,
to make it possible to delete such articles.

=cut

=head1 PUBLIC INTERFACE

=cut

sub ChannelNameGet {
    return 'Invalid';
}

=head2 ArticleCreate()

Dummy function. The invalid backend will not create any articles.

=cut

sub ArticleCreate {
    return;
}

=head2 ArticleUpdate()

Dummy function. The invalid backend will not update any articles.

=cut

sub ArticleUpdate {
    return;
}

=head2 ArticleGet()

Returns article meta data as also returned by L<Kernel::System::Ticket::Article::ArticleList()>.

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => 123,
        ArticleID     => 123,
        DynamicFields => 1,
    );

=cut

sub ArticleGet {
    my ( $Self, %Param ) = @_;

    for my $Item (qw(TicketID ArticleID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }

    my %MetaArticle = $Self->_MetaArticleGet(%Param);

    my %ArticleSenderTypeList = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSenderTypeList();

    # Include sender type lookup.
    $MetaArticle{SenderType} = $ArticleSenderTypeList{ $MetaArticle{SenderTypeID} };

    return %MetaArticle;
}

=head2 ArticleDelete()

Delete an article. Override this method in your class.

    my $Success = $ArticleBackendObject->ArticleDelete(
        TicketID  => 123,
        ArticleID => 123,
        UserID    => 123,
    );

This method uses data stored in the communication channel entry to determine if there are any database tables that
have foreign keys to the C<article> table. Depending data will first be deleted, then the main article entry.

=cut

sub ArticleDelete {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID UserID)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Get CommunicationChannel data of article.
    if ( !$Param{CommunicationChannelID} ) {
        my %MetaArticle = $Self->_MetaArticleGet(%Param);
        $Param{CommunicationChannelID} = $MetaArticle{CommunicationChannelID};
    }

    if ( !$Param{CommunicationChannelID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not determine CommunicationChannelID for Article $Param{ArticleID}!"
        );
        return;
    }

    # Get table dependency information from CommunicationChannel.
    my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
        ChannelID => $Param{CommunicationChannelID},
    );
    if ( !%CommunicationChannel ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not load CommunicationChannel data for Article $Param{ArticleID}!"
        );
        return;
    }

    my %ChannelData;
    if ( ref $CommunicationChannel{ChannelData} eq 'HASH' ) {
        %ChannelData = %{ $CommunicationChannel{ChannelData} };
    }
    my @ArticleDataTables         = @{ $ChannelData{ArticleDataTables} // [] };
    my $ArticleDataArticleIDField = $ChannelData{ArticleDataArticleIDField};

    # Delete depending Article data.
    if ( @ArticleDataTables && $ArticleDataArticleIDField ) {
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        for my $ArticleDataTable (@ArticleDataTables) {
            $DBObject->Do(
                SQL  => "DELETE FROM $ArticleDataTable WHERE $ArticleDataArticleIDField = ?",
                Bind => [ \$Param{ArticleID} ],
            );
        }
    }

    # Delete main article data.
    return $Self->_MetaArticleDelete(%Param);
}

=head2 ArticleSearchableContentGet()

Dummy function. The invalid backend will not return any searchable data.

=cut

sub ArticleSearchableContentGet {
    return;
}

=head2 BackendSearchableFieldsGet()

Dummy function. The invalid backend will not return any searchable fields.

=cut

sub BackendSearchableFieldsGet {
    return;
}

=head2 ArticleHasHTMLContent()

Dummy function. The invalid backend will always return 1.

=cut

sub ArticleHasHTMLContent {
    return 1;
}

=head2 ArticleAttachmentIndex()

Dummy function. The invalid backend will not return any attachments.

=cut

sub ArticleAttachmentIndex {
    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
