# --
# Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::DiskSpacePartitions;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return 'Operating System/Disk Partitions Usage';
}

sub Run {
    my $Self = shift;

    # Check if used OS is a linux system
    if ( $^O !~ /(linux|unix|netbsd|freebsd|darwin)/i ) {
        return $Self->GetResults();
    }

    my $Commandline = "df -lx tmpfs -x iso9660 -x udf -x squashfs";

    # current MacOS and FreeBSD does not support the -x flag for df
    if ( $^O =~ /(darwin|freebsd)/i ) {
        $Commandline = "df -l";
    }

    my %UsedIdentifiers;

    my $In;
    if ( open( $In, "-|", "$Commandline" ) ) {

        my @Partitions;

        while (<$In>) {
            if ( $_ =~ /^(.+?)\s.*\s(\d+)%.+?$/ ) {
                my ( $Partition, $UsedPercent ) = $_ =~ /^(.+?)\s.*?\s(\d+)%.+?$/;

                my $Identifier = $Partition;
                if ( defined $UsedIdentifiers{$Partition} ) {
                    $Identifier .= '_' . $UsedIdentifiers{$Partition};
                    $UsedIdentifiers{$Partition}++;
                }
                else {
                    $UsedIdentifiers{$Partition} = 1;
                }

                push @Partitions, {
                    Identifier => $Identifier,
                    Label      => $Partition,
                    Value      => $UsedPercent . '%',
                };
            }
        }
        close($In);
        for my $Patition (@Partitions) {
            $Self->AddResultInformation( %{$Patition} );
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
