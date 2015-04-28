# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::SchedulerRunning;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::PID',
);

sub GetDisplayPath {
    return 'OTRS';
}

sub Run {
    my $Self = shift;

    # try to get scheduler PID
    my %PID = $Kernel::OM->Get('Kernel::System::PID')->PIDGet(
        Name => 'otrs.Scheduler',
    );

    my $PIDUpdateTime = $Kernel::OM->Get('Kernel::Config')->Get('Scheduler::PIDUpdateTime') || 600;

    # check if scheduler process is registered in the DB and if the update was not too long ago
    if ( !%PID || ( time() - $PID{Changed} > 4 * $PIDUpdateTime ) ) {

        $Self->AddResultProblem(
            Label   => 'Scheduler',
            Value   => 0,
            Message => 'Scheduler is not running.',
        );
    }
    else {
        $Self->AddResultOk(
            Label => 'Scheduler',
            Value => 1,
        );
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
