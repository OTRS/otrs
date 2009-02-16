# --
# Kernel/System/Ticket/Event/TicketFreeFieldDefault.pm - a event module for default ticket free text settings
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: TicketFreeFieldDefault.pm,v 1.9 2009-02-16 11:46:10 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::TicketFreeFieldDefault;
use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

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
    for (qw(TicketID Event Config UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $ConfigSettings = $Self->{ConfigObject}->Get('Ticket::TicketFreeFieldDefault');
    for ( keys %{$ConfigSettings} ) {
        my $Element = $ConfigSettings->{$_};
        if ( $Param{Event} eq $Element->{Event} ) {
            my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

            # do some stuff
            $Self->{TicketObject}->TicketFreeTextSet(
                Counter  => $Element->{Counter},
                Key      => $Element->{Key},
                Value    => $Element->{Value},
                TicketID => $Param{TicketID},
                UserID   => $Param{UserID},
            );
        }
    }
    return 1;
}

1;
