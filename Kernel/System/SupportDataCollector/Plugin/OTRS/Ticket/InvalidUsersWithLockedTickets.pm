# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::Ticket::InvalidUsersWithLockedTickets;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return 'OTRS';
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
            Label   => 'Invalid Users with Locked Tickets',
            Value   => $InvalidUsersTicketCount,
            Message => 'There are invalid users with locked tickets.',
        );
    }
    else {
        $Self->AddResultOk(
            Label => 'Invalid Users with Locked Tickets',
            Value => '0',
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
