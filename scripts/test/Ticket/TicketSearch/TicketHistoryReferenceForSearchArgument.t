# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

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
    TicketChangeTimeNewerMinutes
    TicketChangeTimeOlderDate
    TicketChangeTimeOlderMinutes
    TicketLastChangeTimeNewerDate
    TicketLastChangeTimeNewerMinutes
    TicketLastChangeTimeOlderDate
    TicketLastChangeTimeOlderMinutes
    TicketCloseTimeNewerDate
    TicketCloseTimeNewerMinutes
    TicketCloseTimeOlderDate
    TicketCloseTimeOlderMinutes
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

# Test for tickets changed|closed older|newer than X minutes
{
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $TestName     = sub {
        return sprintf 'TicketSearch(%s) :: %s!', shift, shift;
    };

    my @Tests = (
        {
            Name             => 'Tickets closed less than 1 minute ago',
            SearchParam      => 'TicketCloseTimeNewerMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 0,
        },

        {
            Name             => 'Tickets closed older than 1 minute ago',
            SearchParam      => 'TicketCloseTimeOlderMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 1,
        },

        {
            Name             => 'Tickets changed less than 1 minute ago',
            SearchParam      => 'TicketChangeTimeNewerMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 0,
        },

        {
            Name             => 'Tickets changed older than 1 minute ago',
            SearchParam      => 'TicketChangeTimeOlderMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 1,
        },

        {
            Name             => 'Tickets where last change is less than 1 minute ago',
            SearchParam      => 'TicketLastChangeTimeNewerMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 0,
        },

        {
            Name             => 'Tickets where last change is older than 1 minute ago',
            SearchParam      => 'TicketLastChangeTimeOlderMinutes',
            SearchParamValue => 1,
            FixedTimeMinutes => 1,
        },
    );

    for my $Test (@Tests) {
        my $TicketBaseDTObject = $Kernel::OM->Create('Kernel::System::DateTime');
        if ( $Test->{FixedTimeMinutes} ) {
            $TicketBaseDTObject->Subtract(
                Minutes => $Test->{FixedTimeMinutes},
            );
            $Helper->FixedTimeSet($TicketBaseDTObject);
        }

        my $TicketID = $TicketObject->TicketCreate(
            Title    => 'Some Ticket_Title',
            Queue    => 'Junk',
            Lock     => 'unlock',
            Priority => '3 normal',
            State    => 'closed successful',
            OwnerID  => 1,
            UserID   => 1,
        );

        $Helper->FixedTimeUnset();

        $Self->True(
            $TicketID,
            $TestName->( $Test->{SearchParam}, 'Test ticket created successfully' ),
        );

        my @TicketIDs = $TicketObject->TicketSearch(
            Result               => 'ARRAY',
            StateType            => ['closed'],
            UserID               => 1,
            Limit                => 1,
            $Test->{SearchParam} => $Test->{SearchParamValue},
        );
        $Self->True(
            scalar(@TicketIDs) == 1,
            $TestName->( $Test->{SearchParam}, $Test->{Name}, ),
        );

        $Self->True(
            $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            ),
            $TestName->( $Test->{SearchParam}, 'Test ticket deleted', ),
        );
    }
}

1;
