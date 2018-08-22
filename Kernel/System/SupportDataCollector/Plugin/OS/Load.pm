# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::Load;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return 'Operating System';
}

sub Run {
    my $Self = shift;

    # Check if used OS is a linux system
    if ( $^O !~ /(linux|unix|netbsd|freebsd|darwin)/i ) {
        return $Self->GetResults();
    }

    my @Loads;

    # If used OS is a linux system
    if ( $^O =~ /(linux|unix|netbsd|freebsd|darwin)/i ) {

        # linux systems
        if ( -e "/proc/loadavg" ) {
            my $LoadFile;
            open( $LoadFile, '<', "/proc/loadavg" );    ## no critic
            while (<$LoadFile>) {
                @Loads = split( " ", $_ );
            }
            close($LoadFile);
        }

        # mac os
        elsif ( $^O =~ /darwin/i ) {
            if ( open( my $In, "-|", "sysctl vm.loadavg" ) ) {    ## no critic
                while (<$In>) {
                    if ( my ($Loads) = $_ =~ /vm\.loadavg: \s* \{ \s*  (.*) \s* \}/smx ) {
                        @Loads = split ' ', $Loads;
                    }
                }
                close $In;
            }
        }

        if (@Loads) {
            $Self->AddResultInformation(
                Label => 'System Load',
                Value => $Loads[2],
                Message =>
                    'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).',
            );
        }
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
