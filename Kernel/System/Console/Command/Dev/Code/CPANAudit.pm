# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Dev::Code::CPANAudit;

use strict;
use warnings;

use CPAN::Audit;

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

    # We don't have to pass in Kernel/cpan-lib, as it is already in @INC and therefore scanned by
    #   CPAN::Audit::Installed.

    # Workaround for CPAN::Audit::Installed. It does not use the passed param(s), but @ARGV instead.
    local @ARGV = ();
    return $Audit->command('installed') == 0 ? $Self->ExitCodeOk() : $Self->ExitCodeError();
}

1;
