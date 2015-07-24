# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::Ticket::OpenTickets;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Ticket',
);

sub GetDisplayPath {
    return Translatable('OTRS');
}

sub Run {
    my $Self = shift;

    my $OpenTickets = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
        Result     => 'COUNT',
        StateType  => 'Open',
        UserID     => 1,
        Permission => 'ro',
    );

    if ( $OpenTickets > 8000 ) {
        $Self->AddResultWarning(
            Label   => Translatable('Open Tickets'),
            Value   => $OpenTickets,
            Message => Translatable('You should not have more than 8,000 open tickets in your system.'),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Open Tickets'),
            Value => $OpenTickets,
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
