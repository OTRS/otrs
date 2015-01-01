# --
# Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm - system data collector plugin
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::Swap;

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

    my $MemInfoFile;
    my ( $MemTotal, $MemFree, $SwapTotal, $SwapFree );

    # If used OS is a linux system
    if ( -e "/proc/meminfo" && open( $MemInfoFile, '<', "/proc/meminfo" ) ) {    ## no critic
        while (<$MemInfoFile>) {
            my $TmpLine = $_;
            if ( $TmpLine =~ /MemTotal/ ) {
                $TmpLine =~ s/^.*?(\d+).*$/$1/;
                $MemTotal = int($TmpLine);
            }
            elsif ( $TmpLine =~ /MemFree/ ) {
                $TmpLine =~ s/^.*?(\d+).*$/$1/;
                $MemFree = int($TmpLine);
            }
            elsif ( $TmpLine =~ /SwapTotal/ ) {
                $TmpLine =~ s/^.*?(\d+).*$/$1/;
                $SwapTotal = int($TmpLine);
            }
            elsif ( $TmpLine =~ /SwapFree/ ) {
                $TmpLine =~ s/^.*?(\d+).*$/$1/;
                $SwapFree = int($TmpLine);
            }
        }
        close($MemInfoFile);
    }

    if ($MemTotal) {

        if ( !$SwapTotal ) {
            $Self->AddResultProblem(
                Identifier => 'SwapFree',
                Label      => 'Free Swap Space (%)',
                Value      => 0,
                Message    => 'No swap enabled.',
            );
            $Self->AddResultProblem(
                Identifier => 'SwapUsed',
                Label      => 'Used Swap Space (MB)',
                Value      => 0,
                Message    => 'No swap enabled.',
            );
        }
        else {
            my $SwapFreeRelative = int( $SwapFree / $SwapTotal * 100 );
            if ( $SwapFreeRelative < 60 ) {
                $Self->AddResultProblem(
                    Identifier => 'SwapFree',
                    Label      => 'Free Swap Space (%)',
                    Value      => $SwapFreeRelative,
                    Message    => 'There should be more than 60% free swap space.',
                );
            }
            else {
                $Self->AddResultOk(
                    Identifier => 'SwapFree',
                    Label      => 'Free Swap Space (%)',
                    Value      => $SwapFreeRelative,
                );
            }

            my $SwapUsed = ( $SwapTotal - $SwapFree ) / 1024;

            if ( $SwapUsed > 200 ) {
                $Self->AddResultProblem(
                    Identifier => 'SwapUsed',
                    Label      => 'Used Swap Space (MB)',
                    Value      => $SwapUsed,
                    Message    => 'There should be no more than 200 MB swap space used.',
                );
            }
            else {
                $Self->AddResultOk(
                    Identifier => 'SwapUsed',
                    Label      => 'Used Swap Space (MB)',
                    Value      => $SwapUsed,
                );
            }
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
