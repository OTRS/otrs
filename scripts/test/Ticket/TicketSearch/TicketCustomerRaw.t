# --
# TicketCustomerRaw.t - ticket module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# add two users
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

my @CustomerLogins;
my $Rand = int( rand(1000000) );
for my $Key ( 1 .. 2 ) {
    my $UserRand = 'TestCustomerUserLogin + ' . $Key . $Rand;

    my $UserID = $CustomerUserObject->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => 'Firstname Test' . $Key,
        UserLastname   => 'Lastname Test' . $Key,
        UserCustomerID => "CustomerID-$UserRand",
        UserLogin      => $UserRand,
        UserEmail      => $UserRand . '-Email@example.com',
        UserPassword   => 'some_pass',
        ValidID        => 1,
        UserID         => 1,
    );
    push @CustomerLogins, $UserID;

    $Self->True(
        $UserID,
        "CustomerUserAdd() - $UserID",
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

# clean up customer users

for my $CustomerUserLogin (@CustomerLogins) {

    print $CustomerUserLogin;
    print "\n";
    my $Success = $DBObject->Do(
        SQL  => 'DELETE FROM customer_user WHERE login = ?',
        Bind => [ \$CustomerUserLogin ],
    );
    $Self->True(
        $Success,
        "Removed customer user $CustomerUserLogin",
    );
}

# clean up customer tickets

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
