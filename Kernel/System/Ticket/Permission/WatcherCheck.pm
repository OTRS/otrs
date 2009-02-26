# --
# Kernel/System/Ticket/Permission/WatcherCheck.pm - the sub module of
# the global ticket handle
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: WatcherCheck.pm,v 1.3 2009-02-26 10:27:58 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Permission::WatcherCheck;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject QueueObject UserObject GroupObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID UserID Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # return if no watcher feature is active
    return if !$Self->{ConfigObject}->Get('Ticket::Watcher');

    # return no acces if it's wrong permission type
    return if $Param{Type} ne 'ro';

    # get ticket data, return access if current user is watcher
    my %Ticket = $Self->{TicketObject}->TicketWatchGet(
        TicketID => $Param{TicketID},
    );
    return 1 if $Ticket{ $Param{UserID} };

    # return no access
    return;
}

1;
