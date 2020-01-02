# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::DiskSpace;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('Operating System');
}

sub Run {
    my $Self = shift;

    # This plugin is temporary disabled
    # A new logic is required to calculate the space
    # TODO: fix
    return $Self->GetResults();

    # # Check if used OS is a linux system
    # if ( $^O !~ /(linux|unix|netbsd|freebsd|darwin)/i ) {
    #     return $Self->GetResults();
    # }
    #
    # # find OTRS partition
    # my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    #
    # my $OTRSPartition = `df -P $Home | tail -1 | cut -d' ' -f 1`;
    # chomp $OTRSPartition;
    #
    # my $Commandline = "df -lx tmpfs -x iso9660 -x udf -x squashfs";
    #
    # # current MacOS and FreeBSD does not support the -x flag for df
    # if ( $^O =~ /(darwin|freebsd)/i ) {
    #     $Commandline = "df -l";
    # }
    #
    # my $In;
    # if ( open( $In, "-|", "$Commandline" ) ) {
    #
    #     my ( @ProblemPartitions, $StatusProblem );
    #
    #     # TODO change from percent to megabytes used.
    #     while (<$In>) {
    #         if ( $_ =~ /^$OTRSPartition\s.*/ && $_ =~ /^(.+?)\s.*\s(\d+)%.+?$/ ) {
    #             my ( $Partition, $UsedPercent ) = $_ =~ /^(.+?)\s.*?\s(\d+)%.+?$/;
    #             if ( $UsedPercent > 90 ) {
    #                 push @ProblemPartitions, "$Partition \[$UsedPercent%\]";
    #                 $StatusProblem = 1;
    #             }
    #             elsif ( $UsedPercent > 80 ) {
    #                 push @ProblemPartitions, "$Partition \[$UsedPercent%\]";
    #             }
    #         }
    #     }
    #     close($In);
    #     if (@ProblemPartitions) {
    #         if ($StatusProblem) {
    #             $Self->AddResultProblem(
    #                 Label   => Translatable('Disk Usage'),
    #                 Value   => join( ', ', @ProblemPartitions ),
    #                 Message => Translatable('The partition where OTRS is located is almost full.'),
    #             );
    #         }
    #         else {
    #             $Self->AddResultWarning(
    #                 Label   => Translatable('Disk Usage'),
    #                 Value   => join( ', ', @ProblemPartitions ),
    #                 Message => Translatable('The partition where OTRS is located is almost full.'),
    #             );
    #         }
    #     }
    #     else {
    #         $Self->AddResultOk(
    #             Label   => Translatable('Disk Usage'),
    #             Value   => '',
    #             Message => Translatable('The partition where OTRS is located has no disk space problems.'),
    #         );
    #     }
    # }
    #
    # return $Self->GetResults();
}

1;
