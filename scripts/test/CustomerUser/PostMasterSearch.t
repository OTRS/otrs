# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CustomerUser = 'customer' . $Helper->GetRandomID();

# add two users
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'Firstname Test',
    UserLastname   => 'Lastname Test',
    UserCustomerID => $CustomerUser . '-Customer-Id',
    UserLogin      => $CustomerUser,
    UserEmail      => "john.doe.$CustomerUser\@example.com",
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
);

$Self->True(
    $CustomerUserID,
    "CustomerUserAdd() - $CustomerUserID",
);

my @Tests = (
    {
        Name             => "Exact match",
        PostMasterSearch => "john.doe.$CustomerUser\@example.com",
        ResultCount      => 1,
    },
    {
        Name             => "Exact match with different casing",
        PostMasterSearch => "John.Doe.$CustomerUser\@example.com",
        ResultCount      => 1,
    },
    {
        Name             => "Partial string",
        PostMasterSearch => "doe.$CustomerUser\@example.com",
        ResultCount      => 0,
    },
    {
        Name             => "Partial string with different casing",
        PostMasterSearch => "Doe.$CustomerUser\@example.com",
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

# cleanup is done by RestoreDatabase

1;
