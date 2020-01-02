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
my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
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

my $RandomID = $Helper->GetRandomID();

# add two users
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my @Tests = (
    {
        Name              => 'Regular User',
        CustomerID        => "johndoe$RandomID",
        CustomerIDUpdate  => "johndoe2$RandomID",
        CustomerUserEmail => "johndoe.$RandomID\@email.com",
    },
    {
        Name              => 'Update to special characters',
        CustomerID        => "max$RandomID",
        CustomerIDUpdate  => "max + & # () * $RandomID",
        CustomerUserEmail => "johndoe2.$RandomID\@email.com",
    },
    {
        Name              => 'Update from special characters',
        CustomerID        => "moritz + & # () * $RandomID",
        CustomerIDUpdate  => "moritz$RandomID",
        CustomerUserEmail => "johndoe3.$RandomID\@email.com",
    },
);

for my $Test (@Tests) {

    my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => 'Firstname Test',
        UserLastname   => 'Lastname Test',
        UserCustomerID => $Test->{CustomerID},
        UserLogin      => $Test->{CustomerUserEmail},
        UserEmail      => $Test->{CustomerUserEmail},
        UserPassword   => 'some_pass',
        ValidID        => 1,
        UserID         => 1,
    );

    $Self->True(
        $CustomerUserID,
        "$Test->{Name} - customer user created",
    );

    my $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID          => $Test->{CustomerID},
        CustomerCompanyName => $Test->{CustomerID},
        ValidID             => 1,
        UserID              => 1,
    );

    $Self->True(
        $CustomerCompanyID,
        "$Test->{Name} - customer company created",
    );

    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket_Title',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => $Test->{CustomerID},
        CustomerUser => "john.doe.$RandomID\@email.com",
        OwnerID      => 1,
        UserID       => 1,
    );

    $Self->True(
        $TicketID,
        "$Test->{Name} - ticket created",
    );

    my $Update = $CustomerCompanyObject->CustomerCompanyUpdate(
        CustomerCompanyID   => $Test->{CustomerID},
        CustomerID          => $Test->{CustomerIDUpdate},
        CustomerCompanyName => $Test->{CustomerIDUpdate},
        ValidID             => 1,
        UserID              => 1,
    );

    $Self->True(
        $Update,
        "$Test->{Name} - customer updated",
    );

    $Self->Is(
        $TicketObject->TicketSearch(
            Result        => 'COUNT',
            CustomerIDRaw => $Test->{CustomerIDUpdate},
            UserID        => 1,
            OrderBy       => ['Up'],
            SortBy        => ['TicketNumber'],
        ),
        1,
        "$Test->{Name} - ticket was updated with new CustomerID $Test->{CustomerIDUpdate}"
    );

}

# cleanup is done by RestoreDatabase

1;
