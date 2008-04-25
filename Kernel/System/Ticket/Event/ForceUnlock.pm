# --
# Kernel/System/Ticket/Event/ForceUnlock.pm - unlock ticket
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ForceUnlock.pm,v 1.8 2008-04-25 09:04:24 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Ticket::Event::ForceUnlock;

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
    $Self->{TicketObject}->LockSet(
        TicketID           => $Param{TicketID},
        Lock               => 'unlock',
        SendNoNotification => 1,
        UserID             => 1,
    );
    return 1;
}

1;
