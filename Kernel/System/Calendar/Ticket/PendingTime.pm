# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Calendar::Ticket::PendingTime;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DateTime',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::Calendar::Ticket::PendingTime - PendingTime appointment type

=head1 DESCRIPTION

PendingTime ticket appointment type.

=head1 PUBLIC INTERFACE

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TicketPendingTimeObject = $Kernel::OM->Get('Kernel::System::Calendar::Ticket::PendingTime');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 GetTime()

returns time value for pending time appointment type.

    my $PendingTime = $TicketPendingTimeObject->GetTime(
        Type     => 'PendingTime',
        TicketID => 1,
    );

=cut

sub GetTime {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type TicketID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $Param{TicketID},
    );
    return if !$Ticket{UntilTime};

    # Calculate pending time.
    my $PendingTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $PendingTimeObject->Add(
        Seconds => $Ticket{UntilTime},
    );

    return $PendingTimeObject->ToString();
}

=head2 SetTime()

set ticket pending time to supplied time value.

    my $Success = $TicketPendingTimeObject->SetTime(
        Type     => 'PendingTime',
        Value    => '2016-01-01 00:00:00'
        TicketID => 1,
    );

returns 1 if successful.

=cut

sub SetTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type Value TicketID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $PendingTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{Value},
        },
    );
    my $PendingTimeSetings = $PendingTimeObject->Get();

    # set pending time
    my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPendingTimeSet(
        %{$PendingTimeSetings},
        TicketID => $Param{TicketID},
        UserID   => 1,
    );

    return $Success;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
