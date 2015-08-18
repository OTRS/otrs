# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::DiskSpacePartitions;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return 'Operating System/Disk Partitions Usage';
}

sub Run {
    my $Self = shift;

    # Check if used OS is a Linux system
    if ( $^O !~ /(linux|unix|netbsd|freebsd|darwin)/i ) {
        return $Self->GetResults();
    }

    my $Commandline = "df -lx tmpfs -x iso9660 -x udf -x squashfs";

    # current MacOS and FreeBSD does not support the -x flag for df
    if ( $^O =~ /(darwin|freebsd)/i ) {
        $Commandline = "df -l";
    }

    # run the command an store the result on an array
    my @Lines;
    if ( open( my $In, "-|", "$Commandline" ) ) {
        @Lines = <$In>;
        close($In);
    }

    # clean results, in some systems when partition is too long it splits the line in two, it is
    #   needed to have all partition information in just one line for example
    #   From:
    #   /dev/mapper/system-tmp
    #                   2064208    85644   1873708   5% /tmp
    #   To:
    #   /dev/mapper/system-tmp                   2064208    85644   1873708   5% /tmp
    my @CleanLines;
    my $PreviousLine;

    LINE:
    for my $Line (@Lines) {

        chomp $Line;

        # if line does not have percent number (then it should only contain the partition)
        if ( $Line !~ m{\d+%} ) {

            # remember the line
            $PreviousLine = $Line;
            next LINE;
        }

        # if line starts with just spaces and have a percent number
        elsif ( $Line =~ m{\A \s+ (:? \d+ | \s+)+ \d+ % .+? \z}msx ) {

            # concatenate previous line and store it
            push @CleanLines, $PreviousLine . $Line;
            $PreviousLine = '';
            next LINE;
        }

        # otherwise store the line as it is
        push @CleanLines, $Line;
        $PreviousLine = '';
    }

    my %SeenPartitions;
    LINE:
    for my $Line (@CleanLines) {

        # remove leading white spaces in line
        $Line =~ s{\A\s+}{};

        if ( $Line =~ m{\A .+? \s .* \s \d+ % .+? \z}msx ) {
            my ( $Partition, $UsedPercent, $MountPoint ) = $Line =~ m{\A (.+?) \s .*? \s (\d+)%.+? (/.*) \z}msx;

            $MountPoint //= '';

            $Partition = "$Partition ($MountPoint)";

            next LINE if $SeenPartitions{$Partition}++;

            $Self->AddResultInformation(
                Identifier => $Partition,
                Label      => $Partition,
                Value      => $UsedPercent . '%',
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
