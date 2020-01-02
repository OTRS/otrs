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
my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
my $DBObject            = $Kernel::OM->Get('Kernel::System::DB');
my $SearchProfileObject = $Kernel::OM->Get('Kernel::System::SearchProfile');
my $CustomerUserObject  = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $UserObject          = $Kernel::OM->Get('Kernel::System::User');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# create test user
my ( $Login, $UserID ) = $Helper->TestUserCreate();

my $RandomID = $Helper->GetRandomID();

my $TestNumber = 1;

my $Base = 'TicketSearch';

# workaround for oracle
# oracle databases can't determine the difference between NULL and ''
my $IsNotOracle = 1;
if ( $DBObject->GetDatabaseFunction('Type') eq 'oracle' ) {
    $IsNotOracle = 0;
}

my @Tests = (

    # the current function check for defined values
    # it should be changed to check also for not empty
    # at least for Base and Name
    #    {
    #        Name       => 'Test ' . $TestNumber++,
    #        SuccessAdd => $IsNotOracle,
    #        Add        => {
    #            Base      => '',
    #            Name      => 'last-search'.$RandomID,
    #            Key       => 'Body',
    #            Value     => 'Any value',    # SCALAR|ARRAYREF
    #            UserLogin => $UserID,
    #        },
    #    },
    #    {
    #        Name       => 'Test ' . $TestNumber++,
    #        SuccessAdd => $IsNotOracle,
    #        Add        => {
    #            Base      => $Base,
    #            Name      => '',
    #            Key       => 'Body',
    #            Value     => 'Any value',    # SCALAR|ARRAYREF
    #            UserLogin => $UserID,
    #        },
    #    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => $IsNotOracle,
        Add        => {
            Base      => $Base,
            Name      => 'last-search' . $RandomID,
            Key       => '',
            Value     => 'Any value',                 # SCALAR|ARRAYREF
            UserLogin => $Login,
        },
    },

    # the current function returns 1 if not Value is defined
    # it should be changed
    #    {
    #        Name       => 'Test ' . $TestNumber++,
    #        SuccessAdd => 1,
    #        Add        => {
    #            Base      => $Base,
    #            Name      => 'last-search' . $RandomID,
    #            Key       => 'Body',
    #            Value     => '',                          # SCALAR|ARRAYREF
    #            UserLogin => $UserID,
    #        },
    #    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 1,
        Add        => {
            Base      => $Base,
            Name      => 'last-search' . $RandomID,
            Key       => 'AnyKey',
            Value     => 'Any value',                 # SCALAR|ARRAYREF
            UserLogin => '',
        },
    },

    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Name      => 'last-search' . $RandomID,
            Key       => 'Body',
            Value     => 'Any value',                 # SCALAR|ARRAYREF
            UserLogin => $Login,
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Base      => $Base,
            Key       => 'Body',
            Value     => 'Any value',                 # SCALAR|ARRAYREF
            UserLogin => $Login,
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Base      => $Base,
            Name      => 'last-search' . $RandomID,
            Value     => 'Any value',                 # SCALAR|ARRAYREF
            UserLogin => $Login,
        },
    },

    # the current function returns 1 if not Value is defined
    # it should be changed
    #    {
    #        Name       => 'Test ' . $TestNumber++,
    #        SuccessAdd => 0,
    #        Add        => {
    #            Base      => $Base,
    #            Name      => 'last-search'.$RandomID,
    #            Key       => 'Body',
    #            UserLogin => $UserID,
    #        },
    #    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Base  => $Base,
            Name  => 'last-search' . $RandomID,
            Key   => 'Body',
            Value => 'Any value',                 # SCALAR|ARRAYREF
        },
    },

    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 1,
        Add        => {
            Base      => $Base,
            Name      => 'last-search' . $RandomID,
            Key       => 'AValidKey',
            Value     => 'Any value',                 # SCALAR|ARRAYREF
            UserLogin => $Login,
        },
    },

    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 1,
        Add        => {
            Base      => $Base,
            Name      => 'last-search' . $RandomID . '-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Key       => 'Unicode-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Value     => 'Any value-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',                      # SCALAR|ARRAYREF
            UserLogin => $Login,
        },
    },

    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 1,
        Add        => {
            Base      => $Base,
            Name      => 'last-search-array' . $RandomID,
            Key       => 'Array',
            Value     => [ 'ValueOne', 'ValueTwo', 'ValueThree', 'ValueFour' ],                      # SCALAR|ARRAYREF
            UserLogin => $Login,
        },
    },

);

my @SearchProfileNames;
TEST:
for my $Test (@Tests) {

    # Add SearchProfile
    my $SuccessAdd = $SearchProfileObject->SearchProfileAdd(
        %{ $Test->{Add} },
    );

    if ( !$Test->{SuccessAdd} ) {
        $Self->False(
            $SuccessAdd,
            "$Test->{Name} - SearchProfileAdd()",
        );
        next TEST;
    }
    else {
        $Self->True(
            $SuccessAdd,
            "$Test->{Name} - SearchProfileAdd()",
        );
    }

    # remember profile name to verify it later
    push @SearchProfileNames, $Test->{Add}->{Name};

    # get SearchProfile
    my %SearchProfile = $SearchProfileObject->SearchProfileGet(
        Base      => $Test->{Add}->{Base},
        Name      => $Test->{Add}->{Name},
        UserLogin => $Test->{Add}->{UserLogin},
    );

    # verify SearchProfile
    $Self->Is(
        1,
        IsHashRefWithData( \%SearchProfile ),
        "$Test->{Name} - SearchProfileGet() - Correct structure",
    );

    if ( IsArrayRefWithData( $Test->{Add}->{Value} ) ) {

        my @FromTest   = sort @{ $Test->{Add}->{Value} };
        my @FromResult = sort @{ $SearchProfile{ $Test->{Add}->{Key} } };

        # check if retrieved result match with the expected one
        $Self->IsDeeply(
            \@FromTest,
            \@FromResult,
            "$Test->{Name} - ArrayRef - SearchProfileGet() - Value",
        );
    }
    else {
        $Self->Is(
            $SearchProfile{ $Test->{Add}->{Key} },
            $Test->{Add}->{Value},
            "$Test->{Name} - String - SearchProfileGet() - Value",
        );
    }

}

# rename test user - make sure profiles are updated to match

# get current user data
my %User = $UserObject->GetUserData(
    UserID => $UserID,
);

# change UserLogin
$Login = 'new' . $Login;
$UserObject->UserUpdate(
    UserID        => $UserID,
    UserFirstname => $User{UserFirstname},
    UserLastname  => $User{UserLastname},
    UserLogin     => $Login,
    UserEmail     => $User{UserEmail},
    ValidID       => 1,
    ChangeUserID  => 1,
);

# list check from DB
my %SearchProfileList = $SearchProfileObject->SearchProfileList(
    Base      => $Base,
    UserLogin => $Login,
);
for my $SearchProfileName (@SearchProfileNames) {

    $Self->Is(
        $SearchProfileName,
        $SearchProfileList{$SearchProfileName},
        "SearchProfileList() from DB found SearchProfile $SearchProfileName",
    );

    # delete entry
    my $SuccesDelete = $SearchProfileObject->SearchProfileDelete(
        Base      => $Base,
        Name      => $SearchProfileName,
        UserLogin => $Login,
    );

    $Self->True(
        $SuccesDelete,
        "SearchProfileDelete() - $SearchProfileName",
    );

    # get SearchProfile
    my $SuccessGet = $SearchProfileObject->SearchProfileGet(
        Base      => $Base,
        Name      => $SearchProfileName,
        UserLogin => $Login,
    );

    # verify SearchProfile
    $Self->False(
        $SuccessGet,
        "SearchProfileGet() - Deleted entry",
    );

    # check deleting from SearchProfileList
    my %SearchProfileList = $SearchProfileObject->SearchProfileList(
        Base      => $Base,
        UserLogin => $Login,
    );

    $Self->False(
        $SearchProfileList{$SearchProfileName},
        "SearchProfileList() - Deleted entry $SearchProfileName",
    );
}

my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();
my $CustomerBase          = 'CustomerTicketSearch';
my %CustomerSearches      = (
    First => {
        Search => {
            PriorityIDs => [ 2, 4 ],
            StateIDs    => [ 1, 3, 5 ],
            Body => 'asdf',
        }
    },
    Second => {
        Search => {
            CustomerID => 'asdf',
            StateIDs   => [1],
        }
    }

);

for my $SearchProfile ( sort keys %CustomerSearches ) {
    for my $Key ( sort keys %{ $CustomerSearches{$SearchProfile}->{Search} } ) {
        my $AddResult = $SearchProfileObject->SearchProfileAdd(
            Base      => $CustomerBase,
            Name      => $SearchProfile,
            Key       => $Key,
            Value     => $CustomerSearches{$SearchProfile}->{Search}->{$Key},
            UserLogin => $TestCustomerUserLogin,
        );
        $Self->True(
            $AddResult,
            "Adding key '$Key' to searchprofile '$SearchProfile' for '$TestCustomerUserLogin'",
        );
    }
}

%SearchProfileList = $SearchProfileObject->SearchProfileList(
    Base      => $CustomerBase,
    UserLogin => $TestCustomerUserLogin,
);
$Self->Is(
    scalar keys %SearchProfileList,
    scalar keys %CustomerSearches,
    'CustomerUser: SearchProfileList returns appropriate number of profiles',
);

# rename customer user
my %Customer = $CustomerUserObject->CustomerUserDataGet(
    User => $TestCustomerUserLogin,
);
my $NewCustomerUserLogin = $Helper->GetRandomID();
my $Update               = $CustomerUserObject->CustomerUserUpdate(
    %Customer,
    ID        => $Customer{UserLogin},
    UserLogin => $NewCustomerUserLogin,
    UserID    => 1,
);
$Self->True(
    $Update,
    "CustomerUserUpdate - $Customer{UserLogin} - $NewCustomerUserLogin",
);

%SearchProfileList = $SearchProfileObject->SearchProfileList(
    Base      => $CustomerBase,
    UserLogin => $TestCustomerUserLogin,
);
$Self->Is(
    scalar keys %SearchProfileList,
    0,
    'CustomerUser: SearchProfileList returns no profiles for old user',
);

%SearchProfileList = $SearchProfileObject->SearchProfileList(
    Base      => $CustomerBase,
    UserLogin => $NewCustomerUserLogin,
);
$Self->Is(
    scalar keys %SearchProfileList,
    scalar keys %CustomerSearches,
    'CustomerUser: SearchProfileList returns appropriate number of profiles for new username',
);

# change back customer user login so invalidation at test destruction is ok
$Update = $CustomerUserObject->CustomerUserUpdate(
    %Customer,
    ID        => $NewCustomerUserLogin,
    UserLogin => $TestCustomerUserLogin,
    UserID    => 1,
);

for my $SearchProfile ( sort keys %CustomerSearches ) {
    my $DeleteSuccess = $SearchProfileObject->SearchProfileDelete(
        Base      => $CustomerBase,
        Name      => $SearchProfile,
        UserLogin => $TestCustomerUserLogin,
    );
    $Self->True(
        $DeleteSuccess,
        "Deleting searchprofile '$SearchProfile' for '$TestCustomerUserLogin'",
    );
}

%SearchProfileList = $SearchProfileObject->SearchProfileList(
    Base      => $CustomerBase,
    UserLogin => $TestCustomerUserLogin,
);
$Self->Is(
    scalar keys %SearchProfileList,
    0,
    'CustomerUser: SearchProfileList returns no profiles for user',
);

# cleanup is done by RestoreDatabase

1;
