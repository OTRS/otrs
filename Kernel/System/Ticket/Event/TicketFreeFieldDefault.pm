# --
# Kernel/System/Ticket/Event/TicketFreeFieldDefault.pm - a event module for default ticket free text settings
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: TicketFreeFieldDefault.pm,v 1.5 2007-09-29 10:52:46 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Event::TicketFreeFieldDefault;
use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

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
    my $Self  = shift;
    my %Param = @_;

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
}

1;
