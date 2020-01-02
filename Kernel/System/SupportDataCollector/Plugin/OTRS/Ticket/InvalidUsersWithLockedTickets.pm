# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::Ticket::InvalidUsersWithLockedTickets;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('OTRS');
}

sub Run {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $InvalidUsersTicketCount;
    $DBObject->Prepare(
        SQL => '
        SELECT COUNT(*) FROM ticket, users
        WHERE
            ticket.user_id = users.id
            AND ticket.ticket_lock_id = 2
            AND users.valid_id != 1
        ',
        Limit => 1,
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $InvalidUsersTicketCount = $Row[0];
    }

    if ($InvalidUsersTicketCount) {
        $Self->AddResultWarning(
            Label   => Translatable('Invalid Users with Locked Tickets'),
            Value   => $InvalidUsersTicketCount,
            Message => Translatable('There are invalid users with locked tickets.'),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Invalid Users with Locked Tickets'),
            Value => '0',
        );
    }

    return $Self->GetResults();
}

1;
