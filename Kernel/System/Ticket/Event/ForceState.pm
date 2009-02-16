# --
# Kernel/System/Ticket/Event/ForceState.pm - set state
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: ForceState.pm,v 1.8 2009-02-16 11:46:10 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::ForceState;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject TimeObject EncodeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Event Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my %Ticket = $Self->{TicketObject}->TicketGet(%Param);

    # should I unlock a ticket after move?
    if ( $Ticket{Lock} =~ /^lock$/i ) {
        for ( keys %{ $Param{Config} } ) {
            if ( $_ eq $Ticket{State} && $_ ) {
                $Self->{TicketObject}->StateSet(
                    TicketID           => $Param{TicketID},
                    State              => $Param{Config}->{$_},
                    SendNoNotification => 1,
                    UserID             => 1,
                );
            }
        }
    }
    return 1;
}

1;
