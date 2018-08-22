# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::ErrorLog;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'OTRS';
}

sub Run {
    my $Self = shift;

    my @ErrorLines;

    for my $Line ( split( /\n/, $Self->{LogObject}->GetLog() ) ) {
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

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
