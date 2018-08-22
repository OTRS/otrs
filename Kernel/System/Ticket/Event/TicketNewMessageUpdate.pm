# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Event::TicketNewMessageUpdate;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Parameter (qw(Data Event Config)) {
        if ( !$Param{$Parameter} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Parameter!"
            );
            return;
        }
    }
    for my $DataParameter (qw(TicketID ArticleID)) {
        if ( !$Param{Data}->{$DataParameter} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $DataParameter in Data!",
            );
            return;
        }
    }

    # update ticket new message flag
    if ( $Param{Event} eq 'ArticleCreate' ) {

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        $TicketObject->TicketFlagDelete(
            TicketID => $Param{Data}->{TicketID},
            Key      => 'Seen',
            AllUsers => 1,
        );

        # Set the seen flag to 1 for the agent who created the article.
        #   This must also be done for articles with SenderType other than agent because
        #   it could be still coming from an agent (see bug#11565).
        $TicketObject->ArticleFlagSet(
            ArticleID => $Param{Data}->{ArticleID},
            Key       => 'Seen',
            Value     => 1,
            UserID    => $Param{UserID},
        );

        return 1;
    }
    elsif ( $Param{Event} eq 'ArticleFlagSet' ) {

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my @ArticleList;
        my @SenderTypes = (qw(customer agent system));

        # ignore system sender
        if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::NewArticleIgnoreSystemSender') ) {
            @SenderTypes = (qw(customer agent));
        }

        for my $SenderType (@SenderTypes) {
            push @ArticleList, $TicketObject->ArticleIndex(
                TicketID   => $Param{Data}->{TicketID},
                SenderType => $SenderType,
            );
        }

        # check if ticket needs to be marked as seen
        my $ArticleAllSeen = 1;
        ARTICLE:
        for my $ArticleID (@ArticleList) {
            my %ArticleFlag = $TicketObject->ArticleFlagGet(
                ArticleID => $ArticleID,
                UserID    => $Param{Data}->{UserID},
            );

            # last ARTICLE if article was not shown
            if ( !$ArticleFlag{Seen} ) {
                $ArticleAllSeen = 0;
                last ARTICLE;
            }
        }

        # mark ticket as seen if all articles have been seen
        if ($ArticleAllSeen) {
            $TicketObject->TicketFlagSet(
                TicketID => $Param{Data}->{TicketID},
                Key      => 'Seen',
                Value    => 1,
                UserID   => $Param{Data}->{UserID},
            );
        }
    }

    return;
}

1;
