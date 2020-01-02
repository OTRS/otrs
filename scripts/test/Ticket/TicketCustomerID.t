# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @CustomerCompanyIDs;
for my $Item ( 1 .. 3 ) {
    my $CustomerCompany = 'CustomerCompany' . $Helper->GetRandomID();
    push @CustomerCompanyIDs, $CustomerCompany;
    my $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID             => $CustomerCompany,
        CustomerCompanyName    => "$CustomerCompany-Name",
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
        $CustomerCompanyID,
        "Created company $CustomerCompany with id $CustomerCompanyID",
    );
}

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

# cleanup is done by RestoreDatabase.

1;
