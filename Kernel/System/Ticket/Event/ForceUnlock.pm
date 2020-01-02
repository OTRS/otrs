# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Event::ForceUnlock;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in Data!"
            );
            return;
        }
    }

    # unlock ticket
    $Kernel::OM->Get('Kernel::System::Ticket')->TicketLockSet(
        TicketID           => $Param{Data}->{TicketID},
        Lock               => 'unlock',
        SendNoNotification => 1,
        UserID             => 1,
    );

    return 1;
}

1;
