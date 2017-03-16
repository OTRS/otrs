# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::UpdateAppointmentCalendarFutureTasks;    ## no critic

use strict;
use warnings;

use base qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::Calendar::Appointment',
);

=head1 NAME

scripts::DBUpdateTo6::UpdateAppointmentCalendarFutureTasks - Update AppointmentCalendar future tasks.

=head1 PUBLIC INTERFACE

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Update the future tasks.
    my $Success = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentFutureTasksUpdate();

    return $Success;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
