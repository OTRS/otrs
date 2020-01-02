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

my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# Set Framework Version to 4.0.4.
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

    # Test with single framework version <Framework>4.0.x</Framework>.
    {
        Framework => [
            {
                'Content' => '4.0.x',
            }
        ],
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.3',
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '4.0.3',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.4',
            }
        ],
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.4',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.5',
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '4.0.5',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.1.x',
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '4.1.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.1.3',
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '4.1.3',
        },
    },
    {
        Framework => [
            {
                'Content' => '5.0.4',
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.4',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.5',
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '3.0.5',
        },
    },

    # Test minimum framework version (e.g. <Framework Minimum="4.0.4">4.0.x</Framework>).
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.4'
            }
        ],
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.3'
            }
        ],
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.5'
            }
        ],
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '4.0.x',
            RequiredFrameworkMinimum => '4.0.5',
        },
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.4'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.3'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.5'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '3.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.3'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '3.0.x',
        },
    },

    # Test maximum framework version (e.g. <Framework Maximum="4.0.4">4.0.x</Framework>).
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Maximum' => '4.0.4'
            }
        ],
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Maximum' => '4.1.3'
            }
        ],
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Maximum' => '4.0.3'
            }
        ],
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '4.0.x',
            RequiredFrameworkMaximum => '4.0.3',
        },
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Maximum' => '4.0.4'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Maximum' => '4.1.3'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Maximum' => '4.0.5'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '3.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Maximum' => '4.0.3'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '3.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Maximum' => '4.0.4'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '3.0.x',
        },
    },

    # Test combination of minimum and maximum framework versions
    #   (e.g. <Framework Minimum="4.0.3" Maximum="4.0.4">4.0.x</Framework>).
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.4'
            }
        ],
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.4'
            }
        ],
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.5'
            }
        ],
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.6'
            }
        ],
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
                'Minimum' => '4.0.2',
                'Maximum' => '4.0.3'
            }
        ],
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
                'Maximum' => '4.0.3'
            }
        ],
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '4.0.x',
            RequiredFrameworkMinimum => '4.0.5',
        },
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.4'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.4'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.5'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.6'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '3.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.2',
                'Maximum' => '4.0.3'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '3.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.3'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '3.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '3.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.5'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '3.0.x',
        },
    },

    # Test with multiple frameworks.
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '3.x.x',
        },
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.5',
        },
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '5.0.x',
            RequiredFrameworkMinimum => '4.0.5',
        },
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '5.0.x',
            RequiredFrameworkMaximum => '4.0.3',
        },
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '5.0.x',
            RequiredFrameworkMinimum => '4.0.5',
        },
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
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '5.0.x',
            RequiredFrameworkMaximum => '4.0.3',
        },
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
        ExpectedResult => {
            Success                  => 0,
            RequiredFramework        => '5.0.x',
            RequiredFrameworkMaximum => '4.0.3',
        },
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
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
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
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
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
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.4'
            }
        ],
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
                'Content' => '4.0.5',
            },
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.4'
            }
        ],
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
                'Content' => '4.0.3',
            },
            {
                'Content' => '5.0.x',
                'Minimum' => '4.0.4',
                'Maximum' => '4.0.5'
            }
        ],
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
                'Minimum' => '4.0.5',
                'Maximum' => '4.0.6'
            }
        ],
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
                'Minimum' => '4.0.3',
                'Maximum' => '4.0.3'
            }
        ],
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
                'Minimum' => '4.0.2',
                'Maximum' => '4.0.3'
            }
        ],
        ExpectedResult => {
            Success           => 0,
            RequiredFramework => '5.0.x',
        },
    },
    {
        Framework => [
            {
                'Content' => '4.0.x',
                'Minimum' => '4.0.5',
            },
        ],
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
        ExpectedResult => {
            Success           => 1,
            RequiredFramework => '4.0.x',
        },
    },
);

for my $Test (@Tests) {

    my %VersionCheck = $PackageObject->AnalyzePackageFrameworkRequirements(
        Framework => $Test->{Framework},
    );

    my $FrameworkVersion = $Test->{Framework}[0]->{Content};
    my $FrameworkMinimum = $Test->{Framework}[0]->{Minimum} || '-';
    my $FrameworkMaximum = $Test->{Framework}[0]->{Maximum} || '-';

    my $Name = "AnalyzePackageFrameworkRequirements():";
    if ( $FrameworkMinimum ne '-' || $FrameworkMaximum ne '-' ) {
        $Name .= "Version => $FrameworkVersion, Minimum => $FrameworkMinimum, Maximum => $FrameworkMaximum";
    }

    $Self->IsDeeply(
        \%VersionCheck,
        $Test->{ExpectedResult},
        $Name,
    );
}

1;
