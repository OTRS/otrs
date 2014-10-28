# --
# Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::KernelVersion;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Operating System';
}

sub Run {
    my $Self = shift;

    # Check if used OS is a linux system
    if ( $^O !~ /(linux|unix|netbsd|freebsd|darwin)/i ) {
        return $Self->GetResults();
    }

    my $KernelVersion = "";
    my $KernelInfo;
    if ( open( $KernelInfo, "-|", "uname -a" ) ) {
        while (<$KernelInfo>) {
            $KernelVersion .= $_;
        }
        close($KernelInfo);
        if ($KernelVersion) {
            $KernelVersion =~ s/^\s+|\s+$//g;
        }
    }

    if ($KernelVersion) {
        $Self->AddResultInformation(
            Label => 'Kernel Version',
            Value => $KernelVersion,
        );
    }
    else {
        $Self->AddResultProblem(
            Label => 'Kernel Version',
            Value => $KernelVersion,
            Value => 'Could not determine kernel version.',
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
