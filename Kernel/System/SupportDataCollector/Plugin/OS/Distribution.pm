# --
# Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::Distribution;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::System::Environment',
);
our $ObjectManagerAware = 1;

sub GetDisplayPath {
    return 'Operating System';
}

sub Run {
    my $Self = shift;

    my %OSInfo = $Kernel::OM->Get('Kernel::System::Environment')->OSInfoGet();

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

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
