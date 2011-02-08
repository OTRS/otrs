# --
# Test.t - Mapping tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Test.t,v 1.2 2011-02-08 16:41:23 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::GenericInterface::Mapping;

# create a debbuger object
use Kernel::GenericInterface::Debugger;

$Self->{DebuggerObject} = Kernel::GenericInterface::Debugger->new(
    %$Self,
    DebuggerConfig => {
        DebugLevel => 'debug',
    },
    WebserviceID => 1,
    TestMode     => 1,
);

# create a mapping instance
my $MappingObject = Kernel::GenericInterface::Mapping->new(
    %{$Self},
    MappingConfig => {
        Type   => 'Test',
        Config => {},
    },
);
$Self->Is(
    ref $MappingObject,
    'Kernel::GenericInterface::Mapping',
    'MappingObject was correctly instantiated',
);

my @MappingTests = (
    {
        Name   => 'Test ToUpper',
        Config => { TestOption => 'ToUpper' },
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            one   => 'ONE',
            two   => 'TWO',
            three => 'THREE',
            four  => 'FOUR',
            five  => 'FIVE',
        },
        ResultSuccess => 1,
    },
    {
        Name   => 'Test ToLower',
        Config => { TestOption => 'ToLower' },
        Data   => {
            one   => 'ONE',
            two   => 'TWO',
            three => 'THREE',
            four  => 'FOUR',
            five  => 'FIVE',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultSuccess => 1,
    },
    {
        Name   => 'Test Empty',
        Config => { TestOption => 'Empty' },
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            one   => '',
            two   => '',
            three => '',
            four  => '',
            five  => '',
        },
        ResultSuccess => 1,
    },
    {
        Name   => 'Test without TestOption',
        Config => { TestOption => '' },
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultSuccess => 1,
    },
    {
        Name          => 'Test with wrong Data',
        Config        => { TestOption => 'no data' },
        Data          => 'something for data',
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name          => 'Test with wrong TestOption',
        Config        => { TestOption => 7 },
        Data          => 'something for data',
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test with a wrong TestOption',
        Config => { TestOption => 'ThisShouldBeAWrongTestOption' },
        Data   => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultSuccess => 1,
    },

);

for my $Test (@MappingTests) {
    $MappingObject->{MappingConfig}->{Config} = $Test->{Config};
    my $MappingResult = $MappingObject->Map(
        %{$Self},
        Data => $Test->{Data},
    );

    # check if function return correct status
    $Self->Is(
        $MappingResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' (Success).',
    );

    # check if function return correct data
    $Self->IsDeeply(
        $MappingResult->{Data},
        $Test->{ResultData},
        $Test->{Name} . ' (Data Structure).',
    );

    if ( !$Test->{ResultSuccess} ) {
        $Self->True(
            $MappingResult->{ErrorMessage},
            $Test->{Name} . ' (Error Message: ' .
                $MappingResult->{ErrorMessage} . ')',
        );
    }
    else {
        $Self->False(
            $MappingObject->{ErrorMessage},
            $Test->{Name} . ' (Not Error Message).',
        );
    }
}

1;
