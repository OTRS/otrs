# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# some random customer users
my @CustomerUsers;
for ( 1 .. 5 ) {
    push @CustomerUsers, 'Customer' . $Helper->GetRandomID() . '@localhost';
}

my @TicketIDs;
for my $CustomerUserID (@CustomerUsers) {

    # create a new ticket
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'My ticket created by an Agent',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerUser => $CustomerUserID,
        CustomerID   => $CustomerUserID,
        OwnerID      => 1,
        UserID       => 1,
    );

    $Self->True(
        $TicketID,
        "Ticket created for test - '$CustomerUserID' - $TicketID",
    );
}

# test search by unknown CustomerUserID, with an existing ticket
for my $CustomerUserID (@CustomerUsers) {
    my $UnknownTicketCustomerList = $TicketObject->SearchUnknownTicketCustomers(
        SearchTerm => $CustomerUserID,
    );

    $Self->IsDeeply(
        $UnknownTicketCustomerList,
        {
            $CustomerUserID => $CustomerUserID,
        },
        "Test unknown customer search with ticket for: '$CustomerUserID'",
    );

}

# test search by unknown CustomerUserID, without an existing ticket
for ( 1 .. 5 ) {
    my $CustomerUserID            = 'Customer' . $Helper->GetRandomID() . '@localhost';
    my $UnknownTicketCustomerList = $TicketObject->SearchUnknownTicketCustomers(
        SearchTerm => $CustomerUserID,
    );

    $Self->Is(
        $UnknownTicketCustomerList,
        undef,
        "Test unknown customer search w/o ticket for: '$CustomerUserID'",
    );

}

# cleanup is done by RestoreDatabase.

1;
