# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Event::LockAfterCreate;
## nofilter(TidyAll::Plugin::OTRS::Perl::ParamObject)

use strict;
use warnings;
our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Data Event Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }
    if ( !$Param{Data}->{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID in Data!"
        );

        return;
    }

    # Only for frontend actions by agents.
    return 1 if $Param{UserID} eq 1;

    # Get action.
    my $Action = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Action' );
    return 1 if !$Action;

    # Check action against config.
    return 1 if $Action !~ m{$Param{Config}->{Action}};

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );

    # Disregard closed tickets.
    return 1 if ( $Ticket{StateType} eq 'closed' );

    # Disregard already locked tickets.
    return 1 if ( lc $Ticket{Lock} ne 'unlock' );

    # Set lock.
    $TicketObject->TicketLockSet(
        TicketID => $Param{Data}->{TicketID},
        Lock     => 'lock',
        UserID   => $Param{UserID},
    );
    return 1;
}

1;
