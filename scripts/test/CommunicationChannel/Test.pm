# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::test::CommunicationChannel::Test;    ## no critic

use parent 'Kernel::System::CommunicationChannel::Base';

use strict;
use warnings;

our @ObjectDependencies = ();

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub ArticleDataTables {
    return (
        'i_do_not_exist',
    );
}

sub ArticleDataArticleIDField {
    return 'article_id';
}

sub PackageNameGet {
    return 'TestPackage';
}

1;
