# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::DiskPartitionOTRS;

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

    # Check if used OS is a linux system
    if ( $^O !~ /(linux|unix|netbsd|freebsd|darwin)/i ) {
        return $Self->GetResults();
    }

    # find OTRS partition
    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $OTRSPartition = `df -P $Home | tail -1 | cut -d' ' -f 1`;
    chomp $OTRSPartition;

    $Self->AddResultInformation(
        Label => Translatable('OTRS Disk Partition'),
        Value => $OTRSPartition,
    );

    return $Self->GetResults();
}

1;
