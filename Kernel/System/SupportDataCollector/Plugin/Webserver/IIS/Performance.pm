# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Webserver::IIS::Performance;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return Translatable('Webserver');
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
            Label      => Translatable('CGI Accelerator Usage'),
            Value      => 'PerlEx',
        );
    }
    else {
        $Self->AddResultWarning(
            Identifier => "CGIAcceleratorUsed",
            Label      => Translatable('CGI Accelerator Usage'),
            Value      => '',
            Message    => Translatable('You should use PerlEx to increase your performance.'),
        );
    }

    return $Self->GetResults()
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
