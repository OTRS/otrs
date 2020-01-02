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

# get customer user object
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

my $RandomID        = $Helper->GetRandomID();
my $CustomerUserID  = "user$RandomID";
my $CustomerUserID2 = "user$RandomID-2";
my $CustomerID      = "customer$RandomID";
my $CustomerID2     = "customer$RandomID-2";
my $UserID          = 1;

my @Tests = (
    {
        Name    => 'No parameters',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'No CustomerUserID',
        Config => {
            CustomerID => $CustomerID,
            Active     => 1,
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'No CustomerID',
        Config => {
            CustomerUserID => $CustomerUserID,
            Active         => 1,
            UserID         => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'No UserID',
        Config => {
            CustomerUserID => $CustomerUserID,
            CustomerID     => $CustomerID,
            Active         => 1,
        },
        Success => 0,
    },
    {
        Name   => 'All parameters',
        Config => {
            CustomerUserID => $CustomerUserID,
            CustomerID     => $CustomerID,
            Active         => 1,
            UserID         => $UserID,
        },
        ExpectedCustomers => [
            $CustomerID,
        ],
        ExpectedUsers => [
            $CustomerUserID,
        ],
        Success => 1,
    },
    {
        Name   => 'Multiple customer users',
        Config => [
            {
                CustomerUserID => $CustomerUserID,
                CustomerID     => $CustomerID,
                Active         => 1,
                UserID         => $UserID,
            },
            {
                CustomerUserID => $CustomerUserID2,
                CustomerID     => $CustomerID,
                Active         => 1,
                UserID         => $UserID,
            },
        ],
        ExpectedCustomers => [
            $CustomerID,
        ],
        ExpectedUsers => [
            $CustomerUserID,
            $CustomerUserID2,
        ],
        Success => 1,
    },
    {
        Name   => 'Reset customer association',
        Config => [
            {
                CustomerUserID => $CustomerUserID,
                CustomerID     => $CustomerID,
                Active         => 0,
                UserID         => $UserID,
            },
            {
                CustomerUserID => $CustomerUserID2,
                CustomerID     => $CustomerID,
                Active         => 0,
                UserID         => $UserID,
            },
        ],
        ExpectedCustomers => [],
        ExpectedUsers     => [],
        Success           => 1,
    },
    {
        Name   => 'Multiple customers',
        Config => [
            {
                CustomerUserID => $CustomerUserID,
                CustomerID     => $CustomerID,
                Active         => 1,
                UserID         => $UserID,
            },
            {
                CustomerUserID => $CustomerUserID,
                CustomerID     => $CustomerID2,
                Active         => 1,
                UserID         => $UserID,
            },
        ],
        ExpectedCustomers => [
            $CustomerID,
            $CustomerID2,
        ],
        ExpectedUsers => [
            $CustomerUserID,
        ],
        Success => 1,
    },
);

for my $Test (@Tests) {

    my @Configs;

    # single configuration
    if ( ref $Test->{Config} eq 'HASH' ) {
        push @Configs, $Test->{Config};
    }

    # multiple configurations
    elsif ( ref $Test->{Config} eq 'ARRAY' ) {
        @Configs = @{ $Test->{Config} };
    }

    # add relations
    for my $Config (@Configs) {
        my $Success = $CustomerUserObject->CustomerUserCustomerMemberAdd(
            %{$Config},
        );

        if ( $Test->{Success} ) {
            $Self->True(
                $Success,
                "CustomerUserCustomerMemberAdd() - $Test->{Name}",
            );
        }
        else {
            $Self->False(
                $Success,
                "CustomerUserCustomerMemberAdd() - $Test->{Name}",
            );
        }
    }

    # check output
    if ( $Test->{Success} ) {
        for my $Config (@Configs) {
            my @CustomerIDs = $CustomerUserObject->CustomerUserCustomerMemberList(
                CustomerUserID => $Config->{CustomerUserID},
            );

            $Self->IsDeeply(
                \@CustomerIDs,
                $Test->{ExpectedCustomers},
                "CustomerUserCustomerMemberList( CustomerUserID ) - $Test->{Name}",
            );

            my @CustomerUserIDs = $CustomerUserObject->CustomerUserCustomerMemberList(
                CustomerID => $Config->{CustomerID},
            );

            $Self->IsDeeply(
                \@CustomerUserIDs,
                $Test->{ExpectedUsers},
                "CustomerUserCustomerMemberList( CustomerID ) - $Test->{Name}",
            );

            @CustomerIDs = $CustomerUserObject->CustomerIDs(
                User => $Config->{CustomerUserID},
            );

            $Self->IsDeeply(
                \@CustomerIDs,
                $Test->{ExpectedCustomers},
                "CustomerIDs( CustomerUserID ) - $Test->{Name}",
            );
        }
    }
}

# cleanup is done by RestoreDatabase

1;
