# --
# TicketCustomerID.t - ticket module testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Kernel::System::CustomerCompany;
use Kernel::System::Ticket;
use Kernel::System::UnitTest::Helper;

# create local objects
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);
my $UserObject = Kernel::System::User->new(
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
);
my $CustomerCompanyObject = Kernel::System::CustomerCompany->new(
    %{$Self},
);

my @CustomerCompanyIDs;

for ( 1 .. 3 ) {
    my $RandomString = $HelperObject->GetRandomID();
    push @CustomerCompanyIDs, $RandomString;
    my $ID = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID             => $RandomString,
        CustomerCompanyName    => "$RandomString-Name",
        CustomerCompanyStreet  => '5201 Blue Lagoon Drive',
        CustomerCompanyZIP     => '33126',
        CustomerCompanyCity    => 'Miami',
        CustomerCompanyCountry => 'USA',
        CustomerCompanyURL     => 'http://www.example.org',
        CustomerCompanyComment => 'some comment',
        ValidID                => 1,
        UserID                 => 1,
    );
    $Self->True(
        $ID,
        "Created company $RandomString with id $ID",
    );

}

my @TicketIDs;
my %CustomerIDTickets;
for my $CustomerID (@CustomerCompanyIDs) {
    for ( 1 .. 3 ) {

        # create a new ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'My ticket created by Agent A',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerUser => 'customer@example.com',
            CustomerID   => $CustomerID,
            OwnerID      => 1,
            UserID       => 1,
        );

        $Self->True(
            $TicketID,
            "Ticket created for test - $CustomerID - $TicketID",
        );
        push @TicketIDs, $TicketID;
        push @{ $CustomerIDTickets{$CustomerID} }, $TicketID;

    }
}

for my $CustomerID (@CustomerCompanyIDs) {
    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result     => 'ARRAY',
        CustomerID => $CustomerID,
        UserID     => 1,
        OrderBy    => ['Up'],
        SortBy     => ['TicketNumber'],
    );
    $Self->IsDeeply(
        \@ReturnedTicketIDs,
        $CustomerIDTickets{$CustomerID},
        'test',
    );

    my $Update = $CustomerCompanyObject->CustomerCompanyUpdate(
        CustomerCompanyID      => $CustomerID,
        CustomerID             => $CustomerID . ' - updated',
        CustomerCompanyName    => $CustomerID . '- updated Inc',
        CustomerCompanyStreet  => 'Some Street',
        CustomerCompanyZIP     => '12345',
        CustomerCompanyCity    => 'Some city',
        CustomerCompanyCountry => 'USA',
        CustomerCompanyURL     => 'http://updated.example.com',
        CustomerCompanyComment => 'some comment updated',
        ValidID                => 1,
        UserID                 => 1,
    );

    $Self->True(
        $Update,
        "Updated $CustomerID",
    );

    @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result     => 'ARRAY',
        CustomerID => "$CustomerID - updated",
        UserID     => 1,
        OrderBy    => ['Up'],
        SortBy     => ['TicketNumber'],
    );
    $Self->IsDeeply(
        \@ReturnedTicketIDs,
        $CustomerIDTickets{$CustomerID},
        'test',
    );

}

for my $TicketID (@TicketIDs) {
    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "Removed ticket $TicketID",
    );
}

1;
