# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Webserver::Version;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return 'Webserver';
}

sub Run {
    my $Self = shift;

    my %Environment = %ENV;

    # Skip the plugin, if the support data collection isn't running in a web request.
    return $Self->GetResults() if !$ENV{GATEWAY_INTERFACE};

    my $Version = $ENV{SERVER_SOFTWARE};

    if ($Version) {
        $Self->AddResultInformation(
            Label => 'Webserver Version',
            Value => $ENV{SERVER_SOFTWARE},
        );
    }
    else {
        $Self->AddResultProblem(
            Label   => 'Webserver Version',
            Value   => '',
            Message => 'Could not determine webserver version.'
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
