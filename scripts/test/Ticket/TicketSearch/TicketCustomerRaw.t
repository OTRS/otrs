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

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my @CustomerLogins;

# add two customer users
for ( 1 .. 2 ) {
    my $UserRand = "CustomerUserLogin + " . $Helper->GetRandomID();

    my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => 'Firstname Test',
        UserLastname   => 'Lastname Test',
        UserCustomerID => "CustomerID-$UserRand",
        UserLogin      => $UserRand,
        UserEmail      => $UserRand . '-Email@example.com',
        UserPassword   => 'some_pass',
        ValidID        => 1,
        UserID         => 1,
    );
    push @CustomerLogins, $CustomerUserID;

    $Self->True(
        $CustomerUserID,
        "CustomerUserAdd() - $CustomerUserID",
    );
}

my @TicketIDs;
my %CustomerIDTickets;
for my $CustomerUserLogin (@CustomerLogins) {
    for ( 1 .. 3 ) {

        # create a new ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'My ticket created by Agent A',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerUser => $CustomerUserLogin,
            CustomerID   => "CustomerID-$CustomerUserLogin",
            OwnerID      => 1,
            UserID       => 1,
        );

        $Self->True(
            $TicketID,
            "Ticket created for test - $CustomerUserLogin - $TicketID",
        );
        push @TicketIDs, $TicketID;
        push @{ $CustomerIDTickets{$CustomerUserLogin} }, $TicketID;

    }
}

# test search by CustomerUserLoginRaw, when CustomerUserLogin have special chars or whitespaces

for my $CustomerUserLogin (@CustomerLogins) {

    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result               => 'ARRAY',
        CustomerUserLoginRaw => $CustomerUserLogin,
        UserID               => 1,
        OrderBy              => ['Up'],
        SortBy               => ['TicketNumber'],
    );

    $Self->IsDeeply(
        \@ReturnedTicketIDs,
        $CustomerIDTickets{$CustomerUserLogin},
        "Test TicketSearch for CustomerLoginRaw: \'$CustomerUserLogin\'",
    );

}

# test search by CustomerUserLogin, when CustomerUserLogin have special chars or whitespaces
# result is empty

for my $CustomerUserLogin (@CustomerLogins) {

    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result            => 'ARRAY',
        CustomerUserLogin => $CustomerUserLogin,
        UserID            => 1,
        OrderBy           => ['Up'],
        SortBy            => ['TicketNumber'],
    );

    $Self->IsNotDeeply(
        \@ReturnedTicketIDs,
        $CustomerIDTickets{$CustomerUserLogin},
        "Test TicketSearch for CustomerLoginRaw: \'$CustomerUserLogin\'",
    );

}

# test search by CustomerIDRaw, when CustomerID have special chars or whitespaces

for my $CustomerUserLogin (@CustomerLogins) {

    my %User              = $CustomerUserObject->CustomerUserDataGet( User => $CustomerUserLogin );
    my $CustomerIDRaw     = $User{UserCustomerID};
    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result        => 'ARRAY',
        CustomerIDRaw => $CustomerIDRaw,
        UserID        => 1,
        OrderBy       => ['Up'],
        SortBy        => ['TicketNumber'],
    );

    $Self->IsDeeply(
        \@ReturnedTicketIDs,
        $CustomerIDTickets{$CustomerUserLogin},
        "Test TicketSearch for CustomerIDRaw \'$CustomerIDRaw\'",
    );
}

# test search by CustomerID, when CustomerID have special chars or whitespaces
# result is empty

for my $CustomerUserLogin (@CustomerLogins) {

    my %User              = $CustomerUserObject->CustomerUserDataGet( User => $CustomerUserLogin );
    my $CustomerIDRaw     = $User{UserCustomerID};
    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result     => 'ARRAY',
        CustomerID => $CustomerIDRaw,
        UserID     => 1,
        OrderBy    => ['Up'],
        SortBy     => ['TicketNumber'],
    );

    $Self->IsNotDeeply(
        \@ReturnedTicketIDs,
        $CustomerIDTickets{$CustomerUserLogin},
        "Test TicketSearch for CustomerIDRaw \'$CustomerIDRaw\'",
    );
}

# cleanup is done by RestoreDatabase.

1;
