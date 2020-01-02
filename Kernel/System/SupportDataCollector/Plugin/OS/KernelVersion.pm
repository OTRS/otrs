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

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return Translatable('Operating System');
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
            Label => Translatable('Kernel Version'),
            Value => $KernelVersion,
        );
    }
    else {
        $Self->AddResultProblem(
            Label => Translatable('Kernel Version'),
            Value => $KernelVersion,
            Value => Translatable('Could not determine kernel version.'),
        );
    }

    return $Self->GetResults();
}

1;
