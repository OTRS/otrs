# --
# Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm - system data collector plugin
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::DefaultSOAPUser;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'OTRS';
}

sub Run {
    my $Self = shift;

    my $SOAPUser     = $Self->{ConfigObject}->Get('SOAP::User')     || '';
    my $SOAPPassword = $Self->{ConfigObject}->Get('SOAP::Password') || '';

    if ( $SOAPUser eq 'some_user' && ( $SOAPPassword eq 'some_pass' || $SOAPPassword eq '' ) ) {
        $Self->AddResultProblem(
            Label => 'Default SOAP Username And Password',
            Value => '',
            Message =>
                'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.',
        );
    }
    else {
        $Self->AddResultOk(
            Label => 'Default SOAP Username And Password',
            Value => '',
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
