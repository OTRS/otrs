# --
# Kernel/System/Ticket/Event/Test.pm - test event module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: Test.pm,v 1.11 2010-05-19 07:08:18 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::Test;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject)) {
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
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_ in Data!" );
            return;
        }
    }

    if ( $Param{Event} eq 'TicketCreate' ) {
        my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{Data}->{TicketID} );
        if ( $Ticket{State} eq 'Test' ) {

            # do some stuff
            $Self->{TicketObject}->HistoryAdd(
                TicketID     => $Param{Data}->{TicketID},
                CreateUserID => $Param{UserID},
                HistoryType  => 'Misc',
                Name         => 'Some Info about Changes!',
            );
        }
    }
    elsif ( $Param{Event} eq 'TicketQueueUpdate' ) {
        my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{Data}->{TicketID} );
        if ( $Ticket{Queue} eq 'Test' ) {

            # do some stuff
            $Self->{TicketObject}->HistoryAdd(
                TicketID     => $Param{Data}->{TicketID},
                CreateUserID => $Param{UserID},
                HistoryType  => 'Misc',
                Name         => 'Some Info about Changes!',
            );
        }
    }
    return 1;
}

1;
