# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::Distribution;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Operating System';
}

sub Run {
    my $Self = shift;

    my %OSInfo = $Self->{EnvironmentObject}->OSInfoGet();

    # if OSname starts with Unknown, test was not successful
    if ( $OSInfo{OSName} =~ /\A Unknown /xms ) {
        $Self->AddResultProblem(
            Label   => 'Distribution',
            Value   => $OSInfo{OSName},
            Message => 'Could not determine distribution.'
        );
    }
    else {
        $Self->AddResultInformation(
            Label => 'Distribution',
            Value => $OSInfo{OSName},
        );
    }

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
