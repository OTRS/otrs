# --
# Kernel/System/Ticket/Event/TicketNewMessageUpdate.pm - update ticket new message flag
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: TicketNewMessageUpdate.pm,v 1.1 2010-10-12 13:59:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::TicketNewMessageUpdate;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
            UserID   => $Param{UserID},
        );
        return 1;
    }
    elsif ( $Param{Event} eq 'ArticleFlagSet' ) {
        my @ArticleList = $Self->{TicketObject}->ArticleIndex(
            TicketID => $Param{Data}->{TicketID},
        );
        for my $ArticleID (@ArticleList) {
            my $ArticleNotSeen;
            my %ArticleFlag = $Self->{TicketObject}->ArticleFlagGet(
                ArticleID => $Param{Data}->{ArticleID},
                UserID    => $Param{UserID},
            );
            return 1 if !$ArticleFlag{Seen};

            $Self->{TicketObject}->TicketFlagSet(
                TicketID => $Param{Data}->{TicketID},
                Key      => 'Seen',
                Value    => 1,
                UserID   => $Param{UserID},
            );
            return 1;
        }
    }
    return;
}

1;
