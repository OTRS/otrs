# --
# CloudService.t - Authentication tests
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

use Kernel::System::CloudService;
use Kernel::System::VariableCheck qw(:all);

my $Index = 0;

my @Tests = (
    {
        Name    => 'Test ' . $Index . '.- No RequestData',
        Success => '0',
    },
    {
        Name    => 'Test ' . $Index . '.- RequestData is not an array, HASH',
        RequestData => {},
        Success => '0',
    },
    {
        Name    => 'Test ' . $Index . '.- RequestData is not an array, STRING',
        RequestData => 'Array',
        Success => '0',
    },
    {
        Name    => 'Test ' . $Index . '.- RequestData without Webservice',
        RequestData => {
            '' => [
                {
                    InstanceName => 'AnyName', # optional
                    Operation    => "ConfigurationSet",
                    Data         => {
                        # ... request operation data ...
                    },
                },
            ],
        },
        Success => '0',
    },
    {
        Name    => 'Test ' . $Index . '.- RequestData without Operation',
        RequestData => {
            CloudServiceTest => [
                {
                    InstanceName => 'AnyName', # optional
                    Data         => {
                        # ... request operation data ...
                    },
                },
            ],
        },
        Success => '0',
    },
    {
        Name    => 'Test ' . $Index . '.- Wrong Data structure - STRING',
        RequestData => {
            CloudServiceTest => [
                {
                    InstanceName => 'MyInstance', # optional
                    Operation    => "ConfigurationSet",
                    Data         => 'NoCorrectDataStructure',
                },
            ],
        },
        Success => '0',
    },
    {
        Name    => 'Test ' . $Index . '.- Wrong Data structure - ARRAY',
        RequestData => {
            CloudServiceTest => [
                {
                    InstanceName => 'MyInstance', # optional
                    Operation    => "ConfigurationSet",
                    Data         => ['a', 'b', 'c', 'd'],
                },
            ],
        },
        Success => '0',
    },
    {
        Name    => 'Test ' . $Index . '.- Correct Request data structure - Not a real CloudService',
        RequestData => {
            CloudServiceTest => [
                {
                    InstanceName => 'AnyName', # optional
                    Operation    => "ConfigurationSet",
                    Data         => {
                        # ... request operation data ...
                    },
                },
            ],
        },
        Success => '0',
    },

);


my $CloudServiceObject = Kernel::System::CloudService->new(
    %{$Self},
);

for my $Test (@Tests) {

    my $RequestResult = $CloudServiceObject->Request(
        %{$Test},
    );

    if ( $Test->{Success} ) {
        $Self->Is(
            ref $RequestResult->{Data},
            'HASH',
            "$Test->{Name} - Operation result Data structure",
        );
    }
    else {
        $Self->Is(
            $RequestResult,
            undef,
            "$Test->{Name} - Operation executed with Fail",
        );
    }
}

1;
