# --
# Kernel/System/Ticket/Event/TicketNewMessageUpdate.pm - update ticket new message flag
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: TicketNewMessageUpdate.pm,v 1.4 2010-11-23 22:32:09 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::TicketNewMessageUpdate;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (
        qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject TimeObject)
        )
    {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Parameter (qw(Data Event Config)) {
        if ( !$Param{$Parameter} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Parameter!" );
            return;
        }
    }
    for my $DataParameter (qw(TicketID ArticleID)) {
        if ( !$Param{Data}->{$DataParameter} ) {
            $Self->{LogObject}
                ->Log( Priority => 'error', Message => "Need $DataParameter in Data!" );
            return;
        }
    }

    # update ticket new message flag
    if ( $Param{Event} eq 'ArticleCreate' ) {
        $Self->{TicketObject}->TicketFlagSet(
            TicketID => $Param{Data}->{TicketID},
            Key      => 'Seen',
            Value    => 0,
            AllUsers => 1,
        );

        # set the seen flag to 1 for the agent who created the article
        $Self->{TicketObject}->ArticleFlagSet(
            ArticleID => $Param{Data}->{ArticleID},
            Key       => 'Seen',
            Value     => 1,
            UserID    => $Param{UserID},
        );
        return 1;
    }
    elsif ( $Param{Event} eq 'ArticleFlagSet' ) {
        my @ArticleList = $Self->{TicketObject}->ArticleIndex(
            TicketID => $Param{Data}->{TicketID},
        );

        # check if ticket needs to be marked as seen
        my $ArticleAllSeen = 1;
        ARTICLE:
        for my $Article (@ArticleList) {
            my %ArticleFlag = $Self->{TicketObject}->ArticleFlagGet(
                ArticleID => $Article,
                UserID    => $Param{Data}->{UserID},
            );

            # last if article was not shown
            if ( !$ArticleFlag{Seen} ) {
                $ArticleAllSeen = 0;
                last ARTICLE;
            }
        }

        # mark ticket as seen if all articles have been seen
        if ($ArticleAllSeen) {
            $Self->{TicketObject}->TicketFlagSet(
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
