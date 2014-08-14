# --
# Kernel/System/SupportDataCollector/Plugin/OS/PerlVersion.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::PerlVersion;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::System::Main',
);

sub GetDisplayPath {
    return 'Operating System';
}

sub Run {
    my $Self = shift;

    my $Version = sprintf "%vd", $^V;
    my $OS = $^O;

    # ActivePerl detection
    if ( $^O =~ /win32/i ) {
        $Kernel::OM->Get('Kernel::System::Main')->Require('Win32');

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

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
