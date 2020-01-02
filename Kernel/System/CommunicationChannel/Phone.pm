# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CommunicationChannel::Phone;

use strict;
use warnings;

use parent 'Kernel::System::CommunicationChannel::Base';

our @ObjectDependencies = (
    'Kernel::System::Ticket::Article::Backend::Phone',
);

=head1 NAME

Kernel::System::CommunicationChannel::Phone - phone communication channel class

=head1 DESCRIPTION

This is a class for phone communication channel.

=cut

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel::Phone');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ArticleDataTables()

Returns list of communication channel article tables for backend data storage.

    my @ArticleDataTables = $ChannelObject->ArticleDataTables();

    @ArticleTables = (
        'article_data_mime',
        'article_data_mime_plain',
        'article_data_mime_attachment',
    );

=cut

sub ArticleDataTables {
    return (
        'article_data_mime',
        'article_data_mime_plain',
        'article_data_mime_attachment',
        'article_data_mime_send_error',
    );
}

=head2 ArticleDataArticleIDField()

Returns the name of the field used to link the channel article tables for backend data storage to
the main article table.

    my $ArticleIDField = $ChannelObject->ArticleDataArticleIDField();
    $ArticleIDField = 'article_id';

=cut

sub ArticleDataArticleIDField {
    return 'article_id';
}

=head2 ArticleBackend()

Returns communication channel article backend object.

    my $ArticleBackend = $ChannelObject->ArticleBackend();

This method will always return a valid object, so that you can chain-call on the return value like:

    $ChannelObject->ArticleBackend()->ArticleGet(...);

=cut

sub ArticleBackend {
    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Phone');
}

=head2 PackageNameGet()

Returns name of the package that provides communication channel.

    my $PackageName = $ChannelObject->PackageNameGet();
    $PackageName = 'Framework';

=cut

sub PackageNameGet {
    return 'Framework';
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
