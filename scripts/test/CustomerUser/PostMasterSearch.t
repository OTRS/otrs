# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    RestoreDatabase => 1,
);

my $UserRand = $HelperObject->GetRandomID();

# add two users
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $UserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'Firstname Test',
    UserLastname   => 'Lastname Test',
    UserCustomerID => $UserRand . '-Customer-Id',
    UserLogin      => $UserRand,
    UserEmail      => "john.doe.$UserRand\@example.com",
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
);

$Self->True(
    $UserID,
    "CustomerUserAdd() - $UserID",
);

my @Tests = (
    {
        Name             => "Exact match",
        PostMasterSearch => "john.doe.$UserRand\@example.com",
        ResultCount      => 1,
    },
    {
        Name             => "Exact match with different casing",
        PostMasterSearch => "John.Doe.$UserRand\@example.com",
        ResultCount      => 1,
    },
    {
        Name             => "Partial string",
        PostMasterSearch => "doe.$UserRand\@example.com",
        ResultCount      => 0,
    },
    {
        Name             => "Partial string with different casing",
        PostMasterSearch => "Doe.$UserRand\@example.com",
        ResultCount      => 0,
    },
);

for my $Test (@Tests) {
    my %Result = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => $Test->{PostMasterSearch},
    );

    $Self->Is(
        scalar keys %Result,
        $Test->{ResultCount},
        $Test->{Name},
    );
}

1;
