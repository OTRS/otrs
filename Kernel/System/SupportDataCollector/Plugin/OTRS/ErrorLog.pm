# --
# Kernel/System/SupportDataCollector/Plugin/OTRS/ErrorLog.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::ErrorLog;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::System::Log',
);
our $ObjectManagerAware = 1;

sub GetDisplayPath {
    return 'OTRS';
}

sub Run {
    my $Self = shift;

    my @ErrorLines;

    for my $Line ( split( /\n/, $Kernel::OM->Get('Kernel::System::Log')->GetLog() ) ) {
        my @Row = split( /;;/, $Line );
        if ( $Row[3] && $Row[1] =~ /error/i ) {
            push @ErrorLines, $Row[3];
        }
    }

    if (@ErrorLines) {
        $Self->AddResultInformation(
            Label   => 'Error Log',
            Value   => join( "\n", @ErrorLines ),
            Message => 'There are error reports in your system log.',
        );
    }
    else {
        $Self->AddResultInformation(
            Label => 'Error Log',
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
