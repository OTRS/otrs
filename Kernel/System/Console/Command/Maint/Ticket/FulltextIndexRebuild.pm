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
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Completely rebuild the article search index.');
    $Self->AddOption(
        Name        => 'micro-sleep',
        Description => "Specify microseconds to sleep after every ticket to reduce system load (e.g. 1000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Rebuilding article search index...</yellow>\n");

    # disable ticket events
    $Kernel::OM->Get('Kernel::Config')->{'Ticket::EventModulePost'} = {};

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get all tickets
    my @TicketIDs = $TicketObject->TicketSearch(
        ArchiveFlags => [ 'y', 'n' ],
        OrderBy      => 'Down',
        SortBy       => 'Age',
        Result       => 'ARRAY',
        Limit        => 100_000_000,
        Permission   => 'ro',
        UserID       => 1,
    );

    my $Count      = 0;
    my $MicroSleep = $Self->GetOption('micro-sleep');

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    TICKETID:
    for my $TicketID (@TicketIDs) {

        $Count++;

        my @MetaArticles = $ArticleObject->ArticleList(
            TicketID => $TicketID,
            UserID   => 1,
        );

        for my $MetaArticle (@MetaArticles) {
            $ArticleObject->ArticleSearchIndexBuild(
                %{$MetaArticle},
                UserID => 1,
            );
        }

        if ( $Count % 2000 == 0 ) {
            my $Percent = int( $Count / ( $#TicketIDs / 100 ) );
            $Self->Print(
                "<yellow>$Count</yellow> of <yellow>$#TicketIDs</yellow> processed (<yellow>$Percent %</yellow> done).\n"
            );
        }

        Time::HiRes::usleep($MicroSleep) if $MicroSleep;
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
