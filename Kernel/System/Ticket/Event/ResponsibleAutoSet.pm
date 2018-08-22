# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Event::ResponsibleAutoSet;
use strict;
use warnings;

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
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_ in Data!"
            );
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
