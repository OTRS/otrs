# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get package object
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# Set Framework Version to 4.0.4
$ConfigObject->Set(
    Key   => 'Version',
    Value => '4.0.4',
);

my @Tests = (

    # Example of the Framework Array
    #
    # $VAR2 = 'Framework';
    # $VAR3 = [
    #           {
    #             'TagType' => 'Start',
    #             'TagLevel' => '2',
    #             'Minimum' => '5.0.10',
    #             'Content' => '5.0.x',
    #             'TagLastLevel' => 'otrs_package',
    #             'TagCount' => '24',
    #             'Tag' => 'Framework'
    #           }
    #         ];

    # test with single framework version <Framework>4.0.x</Framework>
    {
        Framework => [
            {
                'Content' => '4.0.x',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '4.0.3',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '4.0.4',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '4.0.5',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '4.1.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '4.1.3',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '5.0.4',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.5',
            }
        ],
        Result => 0,
    },

    # test minimum framework version (e.g. <Framework Minimum="4.0.4">4.0.x</Framework>)
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.4'
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.3'
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.5'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.4'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.3'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.5'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.3'
            }
        ],
        Result => 0,
    },

    # test maximum framework version (e.g. <Framework Maximum="4.0.4">4.0.x</Framework>)
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Maximum' => '4.0.4'
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Maximum' => '4.1.3'
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Maximum' => '4.0.3'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Maximum' => '4.0.4'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Maximum' => '4.1.3'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Maximum' => '4.0.5'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Maximum' => '4.0.3'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Maximum' => '4.0.4'
            }
        ],
        Result => 0,
    },

# test combination of minimum and maximum framework versions  (e.g. <Framework Minimum="4.0.3" Maximum="4.0.4">4.0.x</Framework>)
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.4'
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.4'
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.5'
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.6'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.2',
                'Maximum' => '4.0.3'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.3'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.4'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.4'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.5'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.6'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.2',
                'Maximum' => '4.0.3'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.3'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.5'
            }
        ],
        Result => 0,
    },

    # test with multiple frameworks
    {
        Framework => [
            {
                'Content' => '5.0.x',
            },
            {
                'Content' => '4.x.x',
            },
            {
                'Content' => '3.x.x',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '4.0.3',
            },
            {
                'Content' => '4.0.4',
            },
            {
                'Content' => '4.0.5',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.5',
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.3',
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.4',
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Maximum' => '4.0.4',
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Maximum' => '4.0.3',
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Maximum' => '4.0.5',
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.4'
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.4'
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.5'
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 1,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.6'
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.3'
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.2',
                'Maximum' => '4.0.3'
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.4'
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.4'
            },
            {
                'Content' => '4.0.5',
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.5'
            },
            {
                'Content' => '4.0.3',
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.6'
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.3'
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.2',
                'Maximum' => '4.0.3'
            },
            {
                'Content' => '5.0.x',
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.4'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.5',
            },
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.4'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.3',
            },
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.5'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.6'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.3'
            }
        ],
        Result => 0,
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.2',
                'Maximum' => '4.0.3'
            }
        ],
        Result => 0,
    },

    # tests for RestultType 'HASH'
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.2',
                'Maximum' => '4.0.3',
            },
        ],
        ResultType     => 'HASH',
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '4.0.x',
            RequiredFrameworkMaximum => '4.0.3',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.5',
            },
        ],
        ResultType     => 'HASH',
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '4.0.x',
            RequiredFrameworkMinimum => '4.0.5',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.3',
            },
        ],
        ResultType     => 'HASH',
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '4.0.x',
            RequiredFrameworkMinimum => '4.0.5',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '4.0.5',
            },
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.4'
            }
        ],
        ResultType     => 'HASH',
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
            },
            {
                'Content' => '5.0.x',
            },
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.4'
            }
        ],
        ResultType     => 'HASH',
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.x',
        },
    },
);

for my $Test (@Tests) {

    my $VersionCheck;
    my %VersionCheckHash;
    if ( $Test->{ResultType} && $Test->{ResultType} eq 'HASH' ) {
        %VersionCheckHash = $PackageObject->_CheckFramework(
            Framework  => $Test->{Framework},
            ResultType => $Test->{ResultType} || '',
        );
    }
    else {
        $VersionCheck = $PackageObject->_CheckFramework(
            Framework => $Test->{Framework},
        );
    }

    my $FrameworkVersion = $Test->{Framework}[0]->{Content};
    my $FrameworkMinimum = $Test->{Framework}[0]->{Minimum} || '';
    my $FrameworkMaximum = $Test->{Framework}[0]->{Maximum} || '';

    my $Name = "_CheckFramework() - $FrameworkVersion - Minimum: $FrameworkMinimum - Maximum: $FrameworkMaximum";

    if ( $Test->{ResultType} && $Test->{ResultType} eq 'HASH' ) {
        $Self->IsDeeply(
            \%VersionCheckHash,
            $Test->{ExpectedResult},
            $Name,
        );
    }
    else {
        if ( $Test->{Result} ) {
            $Self->True(
                $VersionCheck,
                $Name,
            );
        }
        else {
            $Self->False(
                $VersionCheck,
                $Name,
            );
        }
    }
}

1;
