# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::DaemonRunning;

use strict;
use warnings;

use Kernel::System::ObjectManager;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('OTRS');
}

sub Run {
    my $Self = shift;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get the NodeID from the SysConfig settings, this is used on High Availability systems.
    my $NodeID = $ConfigObject->Get('NodeID') || 1;

    # get PID directory
    my $PIDDir  = $ConfigObject->Get('Home') . '/var/run/';
    my $PIDFile = $PIDDir . "Daemon-NodeID-$NodeID.pid";

    my $RunningPID;

    if ( -e $PIDFile ) {

        # read existing PID file
        open my $FH, '<', $PIDFile;    ## no critic
        flock $FH, 1;
        my $RegisteredPID = do { local $/; <$FH> };
        close $FH;

        if ($RegisteredPID) {

            # check if process is running
            $RunningPID = kill 0, $RegisteredPID;
        }
    }

    if ($RunningPID) {
        $Self->AddResultOk(
            Label => Translatable('Daemon'),
            Value => 1,
        );
    }
    else {
        $Self->AddResultProblem(
            Label   => Translatable('Daemon'),
            Value   => 0,
            Message => Translatable('Daemon is not running.'),
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
