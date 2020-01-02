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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $RandomID = $Helper->GetRandomID();

my @CustomerIDs;
for my $Key ( 1 .. 3, 'ä', 'カス', '*' ) {

    my $CompanyRand = $Key . $RandomID;

    push @CustomerIDs, $CompanyRand;

    my $CustomerID = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID             => $CompanyRand,
        CustomerCompanyName    => $CompanyRand . ' Inc',
        CustomerCompanyStreet  => 'Some Street',
        CustomerCompanyZIP     => '12345',
        CustomerCompanyCity    => 'Some city',
        CustomerCompanyCountry => 'USA',
        CustomerCompanyURL     => 'http://example.com',
        CustomerCompanyComment => 'some comment',
        ValidID                => 1,
        UserID                 => 1,
    );

    $Self->True(
        $CustomerID,
        "CustomerCompanyAdd() - $CustomerID",
    );

    my %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $CustomerID,
    );

    $Self->Is(
        $CustomerCompany{CustomerCompanyName},
        "$CompanyRand Inc",
        "CustomerCompanyGet() - 'Company Name'",
    );

    $Self->Is(
        $CustomerCompany{CustomerID},
        "$CompanyRand",
        "CustomerCompanyGet() - CustomerID",
    );

    my @CustomerLogins;
    my $CustomerUserRandomID = $Helper->GetRandomID();
    for my $CustomerUserKey ( 1 .. 3, 'ä', 'カス', '*' ) {

        my $UserRand = $CustomerUserKey . $CustomerUserRandomID;

        push @CustomerLogins, $UserRand;

        my $UserID = $CustomerUserObject->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => 'Firstname Test' . $CustomerUserKey,
            UserLastname   => 'Lastname Test' . $CustomerUserKey,
            UserCustomerID => $CompanyRand,
            UserLogin      => $UserRand,
            UserEmail      => $UserRand . '-Email@example.com',
            UserPassword   => 'some_pass',
            ValidID        => 1,
            UserID         => 1,
        );

        $Self->True(
            $UserID,
            "Created Customer $UserRand for customerID $CompanyRand",
        );
    }

    my %CompanyData = $CustomerCompanyObject->CustomerCompanyGet(
        CustomerID => $CompanyRand,
    );

    $Self->Is(
        $CompanyData{CustomerID},
        $CompanyRand,
        "CustomerCompanyGet - data OK for CustomerID $CustomerID",
    );

    my $Success = $CustomerCompanyObject->CustomerCompanyUpdate(
        %CompanyData,
        CustomerCompanyID => $CompanyData{CustomerID},
        CustomerID        => 'new' . $CompanyData{CustomerID},
        UserID            => 1,
    );

    $Self->True(
        $Success,
        "CustomerCompanyUpdate - OK for $CompanyData{CustomerID}",
    );

    my %OldIDList = $CustomerUserObject->CustomerSearch(
        CustomerIDRaw => $CompanyData{CustomerID},
    );

    my %NewIDList = $CustomerUserObject->CustomerSearch(
        CustomerIDRaw => 'new' . $CompanyData{CustomerID},
    );

    $Self->Is(
        scalar keys %OldIDList,
        0,
        "All CustomerUser entries were changed away from old CustomerID",
    );
    $Self->Is(
        scalar keys %NewIDList,
        scalar @CustomerLogins,
        "All CustomerUser entries were changed to the new CustomerID",
    );

    for my $CustomerLogin (@CustomerLogins) {

        $Self->False(
            $OldIDList{$CustomerLogin},
            "Customer User $CustomerLogin not in list for $CompanyData{CustomerID}",
        );

        $Self->True(
            $NewIDList{$CustomerLogin},
            "Customer User $CustomerLogin found in list for new$CompanyData{CustomerID}",
        );

        my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
            User => $CustomerLogin,
        );

        $Self->Is(
            $CustomerData{UserCustomerID},
            'new' . $CompanyData{CustomerID},
            "After Customer update - $CustomerLogin has updated CustomerID",
        );
    }
}

# cleanup is done by RestoreDatabase

1;
