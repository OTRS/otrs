# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
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

my @Tests = (
    {
        Name     => 'Missing RequestData',
        Settings => [
            {
                Key   => 'CloudServices::Disabled',
                Value => 0,
            },
        ],
        Config  => {},
        Success => 0,
    },
    {
        Name     => 'Invalid RequestData',
        Settings => [
            {
                Key   => 'CloudServices::Disabled',
                Value => 0,
            },
        ],
        Config => {
            RequestData => 'Test',
        },
        Success => 0,
    },
    {
        Name     => 'Missing Cloud Service',
        Settings => [
            {
                Key   => 'CloudServices::Disabled',
                Value => 0,
            },
        ],
        Config => {
            RequestData => {
                '' => {},
            },
        },
        Success => 0,
    },
    {
        Name     => 'Invalid Cloud Service',
        Settings => [
            {
                Key   => 'CloudServices::Disabled',
                Value => 0,
            },
        ],
        Config => {
            RequestData => {
                Test => 'Test',
            },
        },
        Success => 0,
    },
    {
        Name     => 'Missing Operation',
        Settings => [
            {
                Key   => 'CloudServices::Disabled',
                Value => 0,
            },
        ],
        Config => {
            RequestData => {
                Test => [
                    {
                        '' => 'Test',
                    },
                ],
            },
        },
        Success => 0,
    },
    {
        Name     => 'Wrong Data',
        Settings => [
            {
                Key   => 'CloudServices::Disabled',
                Value => 0,
            },
        ],
        Config => {
            RequestData => {
                Test => [
                    {
                        Operation => 'Test',
                        Data      => 'Test',
                    },
                ],
            },
        },
        Success => 0,
    },
    {
        Name     => 'Correct Request',
        Settings => [
            {
                Key   => 'CloudServices::Disabled',
                Value => 0,
            },
        ],
        Config => {
            RequestData => {
                Test => [
                    {
                        Operation => 'Test',
                        Data      => {},
                    },
                ],
            },
        },
        Success         => 1,
        ExpectedResults => {
            Test => [
                {
                    Operation => 'Test',
                    Data      => {},
                    Success   => 1,
                },
            ],
        },
    },
    {
        Name     => 'Correct Request (Disabled Cloud Services)',
        Settings => [
            {
                Key   => 'CloudServices::Disabled',
                Value => 1,
            },
        ],
        Config => {
            RequestData => {
                Test => [
                    {
                        Operation => 'Test',
                        Data      => {},
                    },
                ],
            },
        },
        Success => 0,
    },
);

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Some old test VMs have problems with the used SSL certificate, disable for this test.
$ConfigObject->Set(
    Key   => 'WebUserAgent::DisableSSLVerification',
    Value => 1,
);

my %Intervall = (
    1 => 3,
    2 => 15,
    3 => 60,
    4 => 60 * 3,
    5 => 60 * 6,
);

TEST:
for my $Test (@Tests) {

    # set test SysConfig settings
    for my $Setting ( @{ $Test->{Settings} } ) {

        my $Success = $ConfigObject->Set( %{$Setting} );
        $Self->True(
            $Success,
            "$Test->{Name} Config Set() - for $Setting->{Key} with true",
        );
    }

    # refresh cloud service object
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::CloudService::Backend::Run', ],
    );

    # get cloud service backend object
    my $CloudServiceBackend = $Kernel::OM->Get('Kernel::System::CloudService::Backend::Run');

    my $RequestResult;
    TRY:
    for my $Try ( 1 .. 5 ) {

        # perform the request
        $RequestResult = $CloudServiceBackend->Request( %{ $Test->{Config} } );

        if ( !$Test->{Success} ) {
            $Self->Is(
                $RequestResult,
                undef,
                "$Test->{Name} - Expected unsuccessfull request",
            );

            next TEST;
        }

        last TRY if $RequestResult;

        sleep $Intervall{$Try};
    }

    $Self->IsDeeply(
        $RequestResult,
        $Test->{ExpectedResults},
        "$Test->{Name} - Expected request",
    );
}

1;
