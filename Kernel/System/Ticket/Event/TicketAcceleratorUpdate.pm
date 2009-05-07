# --
# Kernel/System/Ticket/Event/TicketAcceleratorUpdate.pm - update ticket index
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: TicketAcceleratorUpdate.pm,v 1.1 2009-05-07 21:03:26 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::TicketAcceleratorUpdate;

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
    for (qw(TicketID Event Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # update ticket view index
    $Self->{TicketObject}->TicketAcceleratorUpdate( TicketID => $Param{TicketID} );

    return 1;
}

1;
