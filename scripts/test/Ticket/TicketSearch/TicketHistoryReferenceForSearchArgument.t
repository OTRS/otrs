# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Test for arguments that should have mapping.
my @ArgsWithReference = qw(
    CreatedStates
    CreatedStateIDs
    CreatedQueues
    CreatedQueueIDs
    CreatedPriorities
    CreatedPriorityIDs
    CreatedTypes
    CreatedTypeIDs
    CreatedUserIDs
    TicketChangeTimeNewerDate
    TicketChangeTimeOlderDate
    TicketLastChangeTimeNewerDate
    TicketLastChangeTimeOlderDate
    TicketCloseTimeNewerDate
    TicketCloseTimeOlderDate
);

for my $Arg (@ArgsWithReference) {
    my $THRef = $TicketObject->_TicketHistoryReferenceForSearchArgument(
        Argument => $Arg,
    );
    $Self->True(
        $THRef,
        "TicketSearch :: ticket-history reference for '${ Arg }' exists!",
    );
}

# Test for argument that should not have mapping.
{
    my $THRef = $TicketObject->_TicketHistoryReferenceForSearchArgument(
        Argument => 'ArgWithNoMapping',
    );
    $Self->False(
        $THRef,
        "TicketSearch :: ticket-history reference for 'ArgWithNoMapping' doesn't exists!",
    );
}

1;
