# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::PerlVersion;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Operating System';
}

sub Run {
    my $Self = shift;

    my $Version = sprintf "%vd", $^V;
    my $OS = $^O;

    # ActivePerl detection
    if ( $^O =~ /win32/i ) {
        $Self->{MainObject}->Require('Win32');

        # Win32::BuildNumber() is only available on ActivePerl, NOT on Strawberry.
        no strict 'refs';    ## no critic
        if ( defined &Win32::BuildNumber ) {
            $Version .= ' (ActiveState build ' . Win32::BuildNumber() . ')';
        }
        else {
            $Version .= ' (StrawberryPerl)';
        }
    }

    $Self->AddResultInformation(
        Label => 'Perl Version',
        Value => "$Version ($OS)",
    );

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
