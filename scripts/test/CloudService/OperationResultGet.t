# --
# OperationResultGet.t - Cloud Service OperationResultGet tests
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

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService');

my %RequestResult = (
    CloudServiceTest => [
        {
            Success      => 1,
            InstanceName => 'AnyName',
            Operation    => 'ConfigurationSet',
            Data         => {
                1 => 1,
            },
        },
        {
            Success   => 1,
            Operation => 'SomeOperation',
            Data      => {
                2 => 2,
            },
        },
    ],
    FeatureAddonManagement => [
        {
            Success   => 1,
            Operation => 'FAOListAssigned',
            Data      => {
                3 => 3,
            },
        },
        {
            Success      => 1,
            InstanceName => 'InstanceNameOne',
            Operation    => 'FAOGet',
            Data         => {
                4 => 4,
            },
        },
        {
            Success      => 1,
            InstanceName => 'InstanceNameTwo',
            Operation    => 'FAOGet',
            Data         => {
                5 => 5
            },
        },
    ],
    Test => [
        {
            Success   => 1,
            Operation => 'Test',
            Data      => {
                Test => 'Test'
            },
        },
    ],
);

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Mising RequestResult',
        Config => {
            CloudService  => 'Test',
            Operation     => 'Test',
            RequestResult => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Mising CloudService',
        Config => {
            CloudService  => undef,
            Operation     => 'Test',
            RequestResult => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Mising Operation',
        Config => {
            CloudService  => 'Test',
            Operation     => undef,
            RequestResult => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong RquestResult format',
        Config => {
            CloudService  => 'Test',
            Operation     => 'Test',
            RequestResult => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong RquestResult format 2',
        Config => {
            CloudService  => 'Test',
            Operation     => 'Test',
            RequestResult => [],
        },
        Success => 0,
    },
    {
        Name   => 'Empty RquestResult (wrong format)',
        Config => {
            CloudService  => 'Test',
            Operation     => 'Test',
            RequestResult => {},
        },
        Success => 0,
    },
    {
        Name   => 'Missing Cloud Service',
        Config => {
            CloudService  => 'Test',
            Operation     => 'Test',
            RequestResult => {
                Test2 => {
                    1 => 1,
                },
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Cloud Service format',
        Config => {
            CloudService  => 'Test',
            Operation     => 'Test',
            RequestResult => {
                Test => {
                    1 => 1,
                },
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Operation',
        Config => {
            CloudService  => 'Test',
            Operation     => 'Test1',
            RequestResult => \%RequestResult,
        },
        Success => 0,
    },
    {
        Name   => 'Operation ConfigurationSet Without InstanceName',
        Config => {
            CloudService  => 'CloudServiceTest',
            Operation     => 'ConfigurationSet',
            RequestResult => \%RequestResult,
        },
        Success => 0,
    },
    {
        Name   => 'Operation ConfigurationSet',
        Config => {
            CloudService  => 'CloudServiceTest',
            Operation     => 'ConfigurationSet',
            InstanceName  => 'AnyName',
            RequestResult => \%RequestResult,
        },
        ExpectedResults => $RequestResult{CloudServiceTest}->[0],
        Success         => 1,
    },
    {
        Name   => 'Operation SomeOperation With InstanceName',
        Config => {
            InstanceName  => 'AnyName',
            CloudService  => 'CloudServiceTest',
            Operation     => 'SomeOperation',
            RequestResult => \%RequestResult,
        },
        Success => 0,
    },
    {
        Name   => 'Operation SomeOperation',
        Config => {
            CloudService  => 'CloudServiceTest',
            Operation     => 'SomeOperation',
            RequestResult => \%RequestResult,
        },
        ExpectedResults => $RequestResult{CloudServiceTest}->[1],
        Success         => 1,
    },
    {
        Name   => 'Operation FAOGet InstanceName InstanceNameTwo',
        Config => {
            CloudService  => 'FeatureAddonManagement',
            Operation     => 'FAOGet',
            InstanceName  => 'InstanceNameTwo',
            RequestResult => \%RequestResult,
        },
        ExpectedResults => $RequestResult{FeatureAddonManagement}->[2],
        Success         => 1,
    },
    {
        Name   => 'Operation Test',
        Config => {
            CloudService  => 'Test',
            Operation     => 'Test',
            RequestResult => \%RequestResult,
        },
        ExpectedResults => $RequestResult{Test}->[0],
        Success         => 1,
    },
);

for my $Test (@Tests) {
    my $OperationResult = $CloudServiceObject->OperationResultGet( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $OperationResult->{Success},
            "$Test->{Name} OperationResultGet() - Executed with True"
        );
        $Self->IsDeeply(
            $OperationResult,
            $Test->{ExpectedResults},
            "$Test->{Name} OperationResultGet() -"
        );
    }
    else {
        $Self->False(
            $OperationResult->{Success},
            "$Test->{Name} OperationResultGet() - Executed with False"
        );
    }
}

1;
