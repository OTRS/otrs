# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::FulltextIndex;

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

    $Self->Description('Flag articles to automatically rebuild the article search index or displays the index status.');
    $Self->AddOption(
        Name        => 'status',
        Description => "Displays the current status of the index.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'rebuild',
        Description => "Flag articles to automatically rebuild the article search index.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    if ( !$Self->GetOption('status') && !$Self->GetOption('rebuild') ) {
        $Self->Print( $Self->GetUsageHelp() );
        die "Either --status or --rebuild must be given!\n";
    }

    if ( $Self->GetOption('status') && $Self->GetOption('rebuild') ) {
        $Self->Print( $Self->GetUsageHelp() );
        die "Either --status or --rebuild must be given!\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( $Self->GetOption('status') ) {
        $Self->Status();
    }

    elsif ( $Self->GetOption('rebuild') ) {
        $Self->Rebuild();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub Status {
    my ( $Self, %Param ) = @_;

    my %Status     = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchIndexStatus();
    my $Percentage = $Status{ArticlesIndexed} / $Status{ArticlesTotal} * 100;

    my $Color = $Percentage == 100 ? 'green' : 'yellow';

    my $Output = sprintf(
        "Indexed Articles: <$Color>%.1f%%</$Color> (<$Color>%d/%d</$Color>)",
        $Percentage,
        $Status{ArticlesIndexed},
        $Status{ArticlesTotal}
    );

    $Self->Print("\nArticle index status:\n\n");
    $Self->Print("$Output\n\n");

    return 1;
}

sub Rebuild {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Retrieving articles that needs to be marked for indexing...</yellow>\n");

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my %ArticleTicketIDs = $ArticleObject->ArticleSearchIndexRebuildFlagList(
        Value => 0,
    );

    if (%ArticleTicketIDs) {

        my $ArticleCount = scalar keys %ArticleTicketIDs;

        $Self->Print("<yellow>Prepare $ArticleCount articles to be indexed...</yellow>\n");

        $ArticleObject->ArticleSearchIndexRebuildFlagSet(
            All   => 1,
            Value => 1,
        );
    }
    else {
        $Self->Print("<yellow>All articles are already marked for indexing!</yellow>\n");
    }

    return 1;
}

1;
