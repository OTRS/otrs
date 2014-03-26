# --
# Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::Ticket::IndexModule;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'OTRS';
}

sub Run {
    my $Self = shift;

    my $Module = $Self->{ConfigObject}->Get('Ticket::IndexModule');

    my $TicketCount;
    $Self->{DBObject}->Prepare( SQL => 'SELECT count(*) FROM ticket' );

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TicketCount = $Row[0];
    }

    if ( $TicketCount > 60_000 && $Module =~ /RuntimeDB/ ) {
        $Self->AddResultWarning(
            Label => 'Ticket Index Module',
            Value => $Module,
            Message =>
                'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.',
        );
    }
    else {
        $Self->AddResultOk(
            Label => 'Ticket Index Module',
            Value => $Module,
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
