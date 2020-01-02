# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::Ticket::OpenTickets;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

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
    ) || 0;

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

1;
