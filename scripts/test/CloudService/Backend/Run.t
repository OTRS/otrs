# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::WebUserAgent;

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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Create a fake cloud service response.
my $CloudServiceResponse = {
    Success      => 1,
    ErrorMessage => '',
    Results      => {
        Test => [
            {
                Operation => 'Test',
                Data      => {},
                Success   => 1,
            },
        ],
    },
};
my $CloudServiceResponseJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
    Data => $CloudServiceResponse,
);

# Override Request() from WebUserAgent to always return expected data without any real web call.
#   This should prevent instability in case cloud services are unavailable.
local *Kernel::System::WebUserAgent::Request = sub {
    return (
        Content => \$CloudServiceResponseJSON,
        Status  => '200 OK',
    );
};

my $CloudServiceObject = $Kernel::OM->Get('Kernel::System::CloudService::Backend::Run');

for my $Test (@Tests) {

    # Set test SysConfig settings.
    for my $Setting ( @{ $Test->{Settings} } ) {
        my $Success = $ConfigObject->Set( %{$Setting} );
        $Self->True(
            $Success,
            "$Test->{Name} - Set $Setting->{Key}"
        );
    }

    my $RequestResult = $CloudServiceObject->Request( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->Is(
            $RequestResult,
            undef,
            "$Test->{Name} - Expected unsuccessful request"
        );
    }
    else {
        $Self->IsDeeply(
            $RequestResult,
            $Test->{ExpectedResults},
            "$Test->{Name} - Expected request"
        );
    }
}

1;
