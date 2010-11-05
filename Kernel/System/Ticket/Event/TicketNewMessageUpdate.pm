# --
# Kernel/System/Ticket/Event/TicketNewMessageUpdate.pm - update ticket new message flag
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: TicketNewMessageUpdate.pm,v 1.2 2010-11-05 18:58:32 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::TicketNewMessageUpdate;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for (qw(TicketID ArticleID)) {
        if ( !$Param{Data}->{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_ in Data!" );
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
        return 1;
    }
    elsif ( $Param{Event} eq 'ArticleFlagSet' ) {
        my @ArticleList = $Self->{TicketObject}->ArticleIndex(
            TicketID => $Param{Data}->{TicketID},
        );

        # check if ticket need to be marked as seen
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

        # mark ticket as seen if all article are shown
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
