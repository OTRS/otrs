# --
# Kernel/System/Ticket/Event/ResponsibleAutoSet.pm - a event module for auto set of responible
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::ResponsibleAutoSet;
use strict;
use warnings;

use vars qw($VERSION);

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
    for (qw(Data Event Config UserID)) {
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

    # set responsible if first change
    return 1 if !$Self->{ConfigObject}->Get('Ticket::Responsible');
    return 1 if !$Self->{ConfigObject}->Get('Ticket::ResponsibleAutoSet');

    # get current ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );

    # check responible update
    if ( $Ticket{ResponsibleID} == 1 && $Param{UserID} != 1 ) {
        $Self->{TicketObject}->TicketResponsibleSet(
            TicketID           => $Param{Data}->{TicketID},
            NewUserID          => $Ticket{OwnerID},
            SendNoNotification => 1,
            UserID             => $Param{UserID},
        );
    }
    return 1;
}

1;
