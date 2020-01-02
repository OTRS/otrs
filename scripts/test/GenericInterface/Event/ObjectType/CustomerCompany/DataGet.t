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
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
    Language => 'en',
);

my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
my $TestCustomerCompany   = $CustomerCompanyObject->CustomerCompanyAdd(
    CustomerID             => $TestCustomerUserLogin,
    CustomerCompanyName    => 'New Customer Inc.' . $RandomID,
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
    $TestCustomerCompany,
    'CustomerCompanyAdd()',
);

my %ExpectedDataRaw = $CustomerCompanyObject->CustomerCompanyGet(
    CustomerID => $TestCustomerUserLogin,
    UserID     => 1,
);

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Success',
        Config => {
            Data => {
                CustomerID => $TestCustomerUserLogin,
            },
        },
        Success => 1,
    },
);

my $BackedObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::ObjectType::CustomerCompany');

TEST:
for my $Test (@Tests) {

    my %ObjectData = $BackedObject->DataGet( %{ $Test->{Config} } );

    my %ExpectedData;
    if ( $Test->{Success} ) {
        %ExpectedData = %ExpectedDataRaw;
    }

    $Self->IsDeeply(
        \%ObjectData,
        \%ExpectedData,
        "$Test->{Name} DataGet()"
    );
}

# Cleanup is done by RestoreDatabase.
1;
