# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CommunicationChannel::Base;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::CommunicationChannel::Base - base class for communication channels

=head1 DESCRIPTION

This is a base class for communication channels and should not be instantiated directly.

    package Kernel::CommunicationChannel::MyChannel;
    use parent 'Kernel::CommunicationChannel::Base';

    # methods go here

=cut

=head1 PUBLIC INTERFACE

=head2 new()

Do not instantiate this class, instead use the real communication channel sub classes.
Also, don't use the constructor directly, use the ObjectManager instead:

    my $ChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel::MyChannel');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Die if someone tries to instantiate the base class.
    if ( $Type eq __PACKAGE__ ) {
        ...;    # yada-yada (unimplemented) operator
    }

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ArticleDataTables()

Returns list of communication channel article tables for backend data storage. All backends must
implement this method.

    my @ArticleDataTables = $ChannelObject->ArticleDataTables();

    @ArticleTables = (
        'article_data_mime',
        'article_data_mime_plain',
        'article_data_mime_attachment',
    );

=cut

sub ArticleDataTables {
    ...;    # yada-yada (unimplemented) operator
}

=head2 ArticleDataArticleIDField()

Returns the name of the field used to link the channel article tables for backend data storage to
the main article table.

    my $ArticleIDField = $ChannelObject->ArticleDataArticleIDField();
    $ArticleIDField = 'article_id';

=cut

sub ArticleDataArticleIDField {
    ...;    # yada-yada (unimplemented) operator
}

=head2 ArticleBackend()

Returns communication channel article backend object. Override this method in your class.

    my $ArticleBackend = $ChannelObject->ArticleBackend();

This method will always return a valid object, so that you can chain-call on the return value like:

    $ChannelObject->ArticleBackend()->ArticleGet(...);

=cut

sub ArticleBackend {
    ...;    # yada-yada (unimplemented) operator
}

=head2 ArticleDataIsDroppable()

Returns 1 if communication channel article data can be dropped/deleted. Override this method in your
class.

    my $IsDroppable = $ChannelObject->ArticleDataIsDroppable();
    $IsDroppable = 1;

=cut

sub ArticleDataIsDroppable {
    ...;    # yada-yada (unimplemented) operator
}

=head2 PackageNameGet()

Returns name of the package that provides communication channel. Override this method in your class.

    my $PackageName = $ChannelObject->PackageNameGet();
    $PackageName = 'MyObject';

=cut

sub PackageNameGet {
    ...;    # yada-yada (unimplemented) operator
}

=head2 ChannelIconGet()

Returns icon for the communication channel. Override this method in your class.

    my $ChannelIcon = $ChannelObject->ChannelIconGet();
    $ChannelIcon = 'fa-envelope';

=cut

sub ChannelIconGet {
    ...;    # yada-yada (unimplemented) operator
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
