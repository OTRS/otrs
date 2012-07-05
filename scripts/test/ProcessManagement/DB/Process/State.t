# --
# State.t - ProcessManagement state tests
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: State.t,v 1.1 2012-07-05 14:55:36 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::ProcessManagement::DB::Process::State;
use Kernel::System::UnitTest::Helper;
use Kernel::System::VariableCheck qw(:all);

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 0,
);

my $ConfigObject = Kernel::Config->new();

my $StateObject = Kernel::System::ProcessManagement::DB::Process::State->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $LocalStateList = $StateObject->{StateList};

my $UserID = 1;

#
# StateList tests
#
my $StateList = $StateObject->StateList();

$Self->IsNot(
    ref $StateList,
    'HASH',
    'StateList Test 1: Emty params | should not be HASH',
);
$Self->Is(
    $StateList,
    undef,
    'StateList Test 1: Emty params | should be undef',
);

$StateList = $StateObject->StateList( UserID => $UserID );

$Self->Is(
    ref $StateList,
    'HASH',
    'StateList Test 1: Emtpy params | should be HASH',
);
$Self->IsDeeply(
    $StateList,
    $LocalStateList,
    'StateList Test 2: Correct | should be undef',
);

#
# StateLookup tests
#
my @Tests = (
    {
        Name    => 'StateLookup Test1: No params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'StateLookup Test2: No ID and Name',
        Config => {
            ID     => undef,
            Name   => undef,
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'StateLookup Test3: No UserID',
        Config => {
            ID     => 1,
            Name   => undef,
            UserID => undef,
        },
        Success => 0,
    },
    {
        Name   => 'StateLookup Test4: Wrong ID',
        Config => {
            ID     => 9999,
            Name   => undef,
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'StateLookup Test5: Wrong Name',
        Config => {
            ID     => undef,
            Name   => 'NonExistent',
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'StateLookup Test6: ID 1',
        Config => {
            ID     => 1,
            Name   => undef,
            UserID => $UserID,
        },
        Result  => 'Active',
        Success => 1,
    },
    {
        Name   => 'StateLookup Test7: ID 2',
        Config => {
            ID     => 2,
            Name   => undef,
            UserID => $UserID,
        },
        Result  => 'Inactive',
        Success => 1,
    },
    {
        Name   => 'StateLookup Test8: ID 3',
        Config => {
            ID     => 3,
            Name   => undef,
            UserID => $UserID,
        },
        Result  => 'FadeAway',
        Success => 1,
    },

    {
        Name   => 'StateLookup Test9: Name Active',
        Config => {
            ID     => undef,
            Name   => 'Active',
            UserID => $UserID,
        },
        Result  => 1,
        Success => 1,
    },
    {
        Name   => 'StateLookup Test10: Name Inactive',
        Config => {
            ID     => undef,
            Name   => 'Inactive',
            UserID => $UserID,
        },
        Result  => 2,
        Success => 1,
    },
    {
        Name   => 'StateLookup Test11: Name FadeAway',
        Config => {
            ID     => undef,
            Name   => 'FadeAway',
            UserID => $UserID,
        },
        Result  => 3,
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Result = $StateObject->StateLookup( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $Result,
            undef,
            "$Test->{Name} | Result should not undef",
        );
        $Self->Is(
            $Result,
            $Test->{Result},
            "$Test->{Name} | Resul should be $Test->{Result}",
        );
    }
    else {
        $Self->Is(
            $Result,
            undef,
            "$Test->{Name} | Result should be undef",
        );
    }
}

1;
