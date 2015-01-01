# --
# Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm - system data collector plugin
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::DiskSpace;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Operating System';
}

sub Run {
    my $Self = shift;

    # This plugin is temporary disabled
    # A new logic is required to calculate the space
    return $Self->GetResults();

    # Check if used OS is a linux system
    if ( $^O !~ /(linux|unix|netbsd|freebsd|darwin)/i ) {
        return $Self->GetResults();
    }

    # find OTRS partition
    my $Home = $Self->{ConfigObject}->Get('Home');

    my $OTRSPartition = `df -P $Home | tail -1 | cut -d' ' -f 1`;
    chomp $OTRSPartition;

    my $Commandline = "df -lx tmpfs -x iso9660 -x udf -x squashfs";

    # current MacOS and FreeBSD does not support the -x flag for df
    if ( $^O =~ /(darwin|freebsd)/i ) {
        $Commandline = "df -l";
    }

    my $In;
    if ( open( $In, "-|", "$Commandline" ) ) {

        my ( @ProblemPartitions, $StatusProblem );

        # TODO change from percent to megabytes used.
        while (<$In>) {
            if ( $_ =~ /^$OTRSPartition\s.*/ && $_ =~ /^(.+?)\s.*\s(\d+)%.+?$/ ) {
                my ( $Partition, $UsedPercent ) = $_ =~ /^(.+?)\s.*?\s(\d+)%.+?$/;
                if ( $UsedPercent > 90 ) {
                    push @ProblemPartitions, "$Partition \[$UsedPercent%\]";
                    $StatusProblem = 1;
                }
                elsif ( $UsedPercent > 80 ) {
                    push @ProblemPartitions, "$Partition \[$UsedPercent%\]";
                }
            }
        }
        close($In);
        if (@ProblemPartitions) {
            if ($StatusProblem) {
                $Self->AddResultProblem(
                    Label   => 'Disk Usage',
                    Value   => join( ', ', @ProblemPartitions ),
                    Message => 'The partition where OTRS is located is almost full.',
                );
            }
            else {
                $Self->AddResultWarning(
                    Label   => 'Disk Usage',
                    Value   => join( ', ', @ProblemPartitions ),
                    Message => 'The partition where OTRS is located is almost full.',
                );
            }
        }
        else {
            $Self->AddResultOk(
                Label   => 'Disk Usage',
                Value   => '',
                Message => 'The partition where OTRS is located has no disk space problems.',
            );
        }
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
