# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::FulltextIndexRebuild;

use strict;
use warnings;

use Time::HiRes();

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Ticket::Article',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Flag articles to automatically rebuild the article search index.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Retrieving articles that needs to be marked for indexing...</yellow>\n");

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my %ArticleTicketIDs = $ArticleObject->ArticleSearchIndexRebuildFlagList(
        Value => 0,
    );

    my @ArticleIDs = keys %ArticleTicketIDs;

    if (@ArticleIDs) {

        my $ArticleCount = scalar @ArticleIDs;

        $Self->Print("<yellow>Prepare $ArticleCount articles to be indexed...</yellow>\n");

        $ArticleObject->ArticleSearchIndexRebuildFlagSet(
            ArticleIDs => \@ArticleIDs,
            Value      => 1,
        );
    }
    else {
        $Self->Print("<yellow>All articles are already marked for indexing!</yellow>\n");
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
