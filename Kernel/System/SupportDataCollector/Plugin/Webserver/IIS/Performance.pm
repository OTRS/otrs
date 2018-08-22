# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Webserver::IIS::Performance;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Webserver';
}

sub Run {
    my $Self = shift;

    my %Environment = %ENV;

    # No IIS webserver, skip this check
    if ( !$ENV{SERVER_SOFTWARE} || $ENV{SERVER_SOFTWARE} !~ m{Microsoft-IIS}i ) {
        return $Self->GetResults();
    }

    my @Result;

    # Check for CGI accelerator
    if ( $ENV{'GATEWAY_INTERFACE'} && $ENV{'GATEWAY_INTERFACE'} =~ /^CGI-PerlEx/i ) {
        $Self->AddResultOk(
            Identifier => "CGIAcceleratorUsed",
            Label      => 'CGI Accelerator Usage',
            Value      => 'PerlEx',
        );
    }
    else {
        $Self->AddResultWarning(
            Identifier => "CGIAcceleratorUsed",
            Label      => 'CGI Accelerator Usage',
            Value      => '',
            Message    => 'You should use PerlEx to increase your performance.',
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
