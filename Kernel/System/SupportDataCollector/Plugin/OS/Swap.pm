# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::Swap;

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
                Label      => Translatable('Free Swap Space (%)'),
                Value      => 0,
                Message    => Translatable('No swap enabled.'),
            );
            $Self->AddResultProblem(
                Identifier => 'SwapUsed',
                Label      => Translatable('Used Swap Space (MB)'),
                Value      => 0,
                Message    => Translatable('No swap enabled.'),
            );
        }
        else {
            my $SwapFreeRelative = int( $SwapFree / $SwapTotal * 100 );
            if ( $SwapFreeRelative < 60 ) {
                $Self->AddResultProblem(
                    Identifier => 'SwapFree',
                    Label      => Translatable('Free Swap Space (%)'),
                    Value      => $SwapFreeRelative,
                    Message    => Translatable('There should be more than 60% free swap space.'),
                );
            }
            else {
                $Self->AddResultOk(
                    Identifier => 'SwapFree',
                    Label      => Translatable('Free Swap Space (%)'),
                    Value      => $SwapFreeRelative,
                );
            }

            my $SwapUsed = ( $SwapTotal - $SwapFree ) / 1024;

            if ( $SwapUsed > 200 ) {
                $Self->AddResultProblem(
                    Identifier => 'SwapUsed',
                    Label      => Translatable('Used Swap Space (MB)'),
                    Value      => $SwapUsed,
                    Message    => Translatable('There should be no more than 200 MB swap space used.'),
                );
            }
            else {
                $Self->AddResultOk(
                    Identifier => 'SwapUsed',
                    Label      => Translatable('Used Swap Space (MB)'),
                    Value      => $SwapUsed,
                );
            }
        }
    }

    return $Self->GetResults();
}

1;
