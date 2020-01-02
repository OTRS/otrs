# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::KernelVersion;

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

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
