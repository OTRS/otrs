# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Permission::WatcherCheck;

use strict;
use warnings;

use vars qw(@ISA $VERSION);

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
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
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
