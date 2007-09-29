# --
# Kernel/System/Ticket/Event/ForceOwnerReset.pm - reset owner on move
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: ForceOwnerReset.pm,v 1.6 2007-09-29 10:52:46 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Event::ForceOwnerReset;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

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
    my $Self  = shift;
    my %Param = @_;

    # check needed stuff
    for (qw(TicketID Event Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    $Self->{TicketObject}->OwnerSet(
        TicketID           => $Param{TicketID},
        NewUserID          => 1,
        SendNoNotification => 1,                  # optional 1|0
        UserID             => 1,
    );
    $Self->{TicketObject}->LockSet(
        TicketID           => $Param{TicketID},
        Lock               => 'unlock',
        SendNoNotification => 1,                  # optional 1|0
        UserID             => 1,
    );
    return 1;
}

1;
