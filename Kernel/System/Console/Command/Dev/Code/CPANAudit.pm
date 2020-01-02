# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Dev::Code::CPANAudit;

use strict;
use warnings;

use CPAN::Audit;
use File::Basename;
use FindBin qw($Bin);

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = ();

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Scan CPAN dependencies in Kernel/cpan-lib and in the system for known vulnerabilities.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Audit = CPAN::Audit->new(
        no_color    => 1,
        no_corelist => 0,
        ascii       => 0,
        verbose     => 0,
        quiet       => 0,
        interactive => 0,
    );

    my @PathsToScan;

    # We need to pass an explicit list of paths to be scanned by CPAN::Audit, otherwise it will fallback to @INC which
    #   includes our complete tree, with article storage, cache, temp files, etc. It can result in a downgraded
    #   performance if this command is run often.
    #   Please see bug#14666 for more information.
    PATH:
    for my $Path (@INC) {
        next PATH if $Path && $Path eq '.';                          # Current folder
        next PATH if $Path && $Path eq dirname($Bin);                # OTRS home folder
        next PATH if $Path && $Path eq dirname($Bin) . '/Custom';    # Custom folder
        push @PathsToScan, $Path;
    }

    # Workaround for CPAN::Audit::Installed. It does not use the passed param(s), but @ARGV instead.
    local @ARGV = @PathsToScan;
    return $Audit->command('installed') == 0 ? $Self->ExitCodeOk() : $Self->ExitCodeError();
}

1;
