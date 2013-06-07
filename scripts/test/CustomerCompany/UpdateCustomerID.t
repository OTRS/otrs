# --
# CustomerCompany/UpdateCustomerID.t - CustomerCompany tests for CustomerID
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::CustomerUser;
use Kernel::System::CustomerCompany;

# create local objects
my $ConfigObject = Kernel::Config->new();

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $CustomerUserObject = Kernel::System::CustomerUser->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $CustomerCompanyObject = Kernel::System::CustomerCompany->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my @CustomerIDs;

for my $Key ( 1 .. 1 ) {

    my $CompanyRand = 'Example-Customer-Company' . $Key . int( rand(1000000) );

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
    for my $CustomerUserKey ( 1 .. 9 ) {
        my $UserRand = 'Example-Customer-User' . $CustomerUserKey . int( rand(1000000) );
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

    my %CompanyData = $CustomerCompanyObject->CustomerCompanyGet( CustomerID => $CompanyRand );
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
        CustomerID => $CompanyData{CustomerID},
    );

    my %NewIDList = $CustomerUserObject->CustomerSearch(
        CustomerID => 'new' . $CompanyData{CustomerID},
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
            "After Customer Company update - $CustomerLogin has updated CustomerID",
        );
    }
}

1;
