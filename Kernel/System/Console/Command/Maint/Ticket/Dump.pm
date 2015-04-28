# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::Dump;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Ticket',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Prints a ticket and its articles to the console.');
    $Self->AddOption(
        Name        => 'article-limit',
        Description => "Maximum number of articles to print.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d+/smx,
    );
    $Self->AddArgument(
        Name        => 'ticket-id',
        Description => "ID of the ticket to be printed.",
        Required    => 1,
        ValueRegex  => qr/\d+/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Self->GetArgument('ticket-id'),
        DynamicFields => 0,
    );

    if ( !%Ticket ) {
        $Self->PrintError("Could not find ticket.");
        return $Self->ExitCodeError();
    }

    $Self->Print( "<green>" . ( '=' x 69 ) . "</green>\n" );

    KEY:
    for my $Key (qw(TicketNumber TicketID Title Created Queue State Priority Lock CustomerID CustomerUserID))
    {

        next KEY if !$Key;
        next KEY if !$Ticket{$Key};

        $Self->Print("<yellow>$Key:</yellow> $Ticket{$Key}\n");
    }

    $Self->Print( "<green>" . ( '-' x 69 ) . "</green>\n" );

    # get article index
    my @Index = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleIndex(
        TicketID => $Self->GetArgument('ticket-id'),
    );

    my $Counter      = 1;
    my $ArticleLimit = $Self->GetOption('article-limit');
    ARTICLEID:
    for my $ArticleID (@Index) {

        last ARTICLEID if defined $ArticleLimit && $ArticleLimit < $Counter;
        next ARTICLEID if !$ArticleID;

        # get article data
        my %Article = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleGet(
            ArticleID     => $ArticleID,
            DynamicFields => 0,
        );

        next ARTICLEID if !%Article;

        KEY:
        for my $Key (qw(ArticleID From To Cc Subject ReplyTo InReplyTo Created SenderType)) {

            next KEY if !$Key;
            next KEY if !$Article{$Key};

            $Self->Print("<yellow>$Key:</yellow> $Article{$Key}\n");
        }

        $Article{Body} ||= '';

        $Self->Print("<yellow>Body:</yellow>\n");
        $Self->Print("$Article{Body}\n");
        $Self->Print( "<green>" . ( '-' x 69 ) . "</green>\n" );
    }
    continue {
        $Counter++;
    }

    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
