# --
# Kernel/System/Ticket/Event/ArchiveRestore.pm - restore ticket from archive
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::ArchiveRestore;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
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
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')
                ->Log( Priority => 'error', Message => "Need $_ in Data!" );
            return;
        }
    }

    # return if no archive feature is enabled
    return 1 if !$Kernel::OM->Get('Kernel::Config')->Get('Ticket::ArchiveSystem');

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        UserID        => 1,
        DynamicFields => 0,
    );
    return if !%Ticket;

    # do not restore until ticket is closed, removed or merged
    # (restore just open tickets)
    return 1 if $Ticket{StateType} eq 'closed';
    return 1 if $Ticket{StateType} eq 'removed';
    return 1 if $Ticket{StateType} eq 'merged';

    # restore ticket from archive
    return if !$TicketObject->TicketArchiveFlagSet(
        TicketID    => $Param{Data}->{TicketID},
        UserID      => 1,
        ArchiveFlag => 'n',
    );

    return 1;
}

1;
