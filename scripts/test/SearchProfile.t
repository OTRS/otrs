# --
# SearchProfile.t - SearchProfile tests
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
my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
my $HelperObject        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $DBObject            = $Kernel::OM->Get('Kernel::System::DB');
my $SearchProfileObject = $Kernel::OM->Get('Kernel::System::SearchProfile');

# set UserID
my $UserID = 1;

my $RandomID = $HelperObject->GetRandomID();

my $TestNumber = 1;

my $Base = 'TicketSearch' . $RandomID;

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
            UserLogin => $UserID,
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
            UserLogin => $UserID,
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Base      => $Base,
            Key       => 'Body',
            Value     => 'Any value',                 # SCALAR|ARRAYREF
            UserLogin => $UserID,
        },
    },
    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 0,
        Add        => {
            Base      => $Base,
            Name      => 'last-search' . $RandomID,
            Value     => 'Any value',                 # SCALAR|ARRAYREF
            UserLogin => $UserID,
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
            UserLogin => $UserID,
        },
    },

    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 1,
        Add        => {
            Base => $Base,
            Name => 'last-search' . $RandomID . '-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Key  => 'Unicode-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',
            Value     => 'Any value-äüßÄÖÜ€исáéíúúÁÉÍÚñÑ',    # SCALAR|ARRAYREF
            UserLogin => $UserID,
        },
    },

    {
        Name       => 'Test ' . $TestNumber++,
        SuccessAdd => 1,
        Add        => {
            Base      => $Base,
            Name      => 'last-search-array' . $RandomID,
            Key       => 'Array',
            Value     => [ 'ValueOne', 'ValueTwo', 'ValueThree', 'ValueFour' ],    # SCALAR|ARRAYREF
            UserLogin => $UserID,
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

# list check from DB
my %SearchProfileList
    = $SearchProfileObject->SearchProfileList( Base => $Base, UserLogin => $UserID );
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
        UserLogin => $UserID,
    );

    $Self->True(
        $SuccesDelete,
        "SearchProfileDelete() - $SearchProfileName",
    );

    # get SearchProfile
    my $SuccessGet = $SearchProfileObject->SearchProfileGet(
        Base      => $Base,
        Name      => $SearchProfileName,
        UserLogin => $UserID,
    );

    # verify SearchProfile
    $Self->False(
        $SuccessGet,
        "SearchProfileGet() - Deleted entry",
    );

    # check deleting from SearchProfileList
    my %SearchProfileList
        = $SearchProfileObject->SearchProfileList( Base => $Base, UserLogin => $UserID );

    $Self->False(
        $SearchProfileList{$SearchProfileName},
        "SearchProfileList() - Deleted entry $SearchProfileName",
    );
}

1;
