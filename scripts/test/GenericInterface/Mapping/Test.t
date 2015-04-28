# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Mapping;

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

# create a mapping instance
my $MappingObject = Kernel::GenericInterface::Mapping->new(
    DebuggerObject => $DebuggerObject,
    MappingConfig  => {
        Type => 'Test',
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
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name   => 'Test with unknown TestOption',
        Config => { TestOption => 'blah' },
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
        Name          => 'Test with no Data',
        Config        => { TestOption => 'no data' },
        Data          => undef,
        ResultData    => {},
        ResultSuccess => 1,
    },
    {
        Name          => 'Test with empty Data',
        Config        => { TestOption => 'empty data' },
        Data          => {},
        ResultData    => {},
        ResultSuccess => 1,
    },
    {
        Name          => 'Test with wrong Data',
        Config        => { TestOption => 'no data' },
        Data          => [],
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

    $Self->Is(
        $MappingResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' success status',
    );

    if ( !$Test->{ResultSuccess} ) {
        $Self->True(
            $MappingResult->{ErrorMessage},
            $Test->{Name} . ' error message found',
        );
    }
}

1;
