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

use Kernel::Config;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $HelperObject->GetRandomID();

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $RemoveDirtyFlags = sub {
    my $Success = $SysConfigDBObject->DefaultSettingDirtyCleanUp();
    $Success = $SysConfigDBObject->ModifiedSettingDirtyCleanUp();
};

$RemoveDirtyFlags->();

my @Tests = (
    {
        Name              => 'Missing UserID',
        ConfigurationPerl => {
            Default => {
                ProductName => {
                    EffectiveValue => 'Test Modified',
                },
                AgentLoginLogo => {
                    EffectiveValue => {
                        URL         => 'Test Default URL',
                        StyleHeight => '70px',
                    },
                },
            },
            Modified => {
                ProductName => {
                    EffectiveValue => 'Test Modified 2',
                },
                AgentLoginLogo => {
                    EffectiveValue => {
                        URL         => 'Test Modified URL 2',
                        StyleHeight => '70px',
                    },
                },
            },
        },
        Config  => {},
        Success => 0,
    },

    {
        Name              => 'Empty Config',
        ConfigurationPerl => {},
        Config            => {
            UserID => 1,
        },
        Success => 0,
    },

    {
        Name              => 'Configuration Invalid',
        ConfigurationPerl => [
            {
                Default => {
                    ProductName => {
                        EffectiveValue => 'Test Modified',
                    },
                    AgentLoginLogo => {
                        EffectiveValue => {
                            URL         => 'Test Default URL',
                            StyleHeight => '70px',
                        },
                    },
                },
                Modified => {
                    ProductName => {
                        EffectiveValue => 'Test Modified 2',
                    },
                    AgentLoginLogo => {
                        EffectiveValue => {
                            URL         => 'Test Modified URL 2',
                            StyleHeight => '70px',
                        },
                    },
                },
            },
        ],
        Config  => {},
        Success => 0,
    },

    {
        Name              => 'Only Defaults',
        ConfigurationPerl => {
            Default => {
                ProductName => {
                    EffectiveValue => 'Test Modified',
                },
                AgentLoginLogo => {
                    EffectiveValue => {
                        URL         => 'Test Default URL',
                        StyleHeight => '70px',
                    },
                },
            },
        },
        Config => {
            UserID => 1,
        },
        ExpectedResults => {
            Modified => {},
        },
        Success => 1,
    },
    {
        Name              => 'Only Modified',
        ConfigurationPerl => {
            Modified => {
                ProductName => {
                    EffectiveValue => 'Test Modified',
                },
                AgentLoginLogo => {
                    EffectiveValue => {
                        URL         => 'Test Modified URL',
                        StyleHeight => '70px',
                    },
                },
            },
        },
        Config => {
            UserID => 1,
        },
        ExpectedResults => {
            Modified => {
                ProductName    => 'Test Modified',
                AgentLoginLogo => {
                    URL         => 'Test Modified URL',
                    StyleHeight => '70px',
                },
            },
        },
        Success => 1,
    },
    {
        Name              => 'Modified NotExising',
        ConfigurationPerl => {
            Modified => {
                ProductName123 => {
                    EffectiveValue => 'Test Modified',
                },
                AgentLoginLogo123 => {
                    EffectiveValue => {
                        URL         => 'Test Modified URL',
                        StyleHeight => '70px',
                    },
                },
            },
        },
        Config => {
            UserID => 1,
        },
        ExpectedResults => {
            Modified => {},
        },
        Success => 1,
    },
    {
        Name              => 'Modified Wrong',
        ConfigurationPerl => {
            Modified => {
                ProductName123 => {
                    EffectiveValue => ['Test Modified'],
                },
                AgentLoginLogo123 => {
                    EffectiveValue => 'Test Modified URL',
                }
            },
        },
        Config => {
            UserID => 1,
        },
        ExpectedResults => {
            Modified => {},
        },
        Success => 1,
    },
    {
        Name              => 'Setting enabled',
        ConfigurationPerl => {
            Modified => {
                'Stats::MaxXaxisAttributes' => {
                    EffectiveValue => 1000,
                    IsValid        => 1,
                },
            },
        },
        Config => {
            UserID => 1,
        },
        ExpectedResults => {
            Modified => {
                'Stats::MaxXaxisAttributes' => '1000',
            },
        },
        Success => 1,
    },
    {
        Name              => 'Setting disabled',
        ConfigurationPerl => {
            Modified => {
                'OutOfOfficeMessageTemplate' => {
                    EffectiveValue => 'template',
                    IsValid        => 0,
                },
            },
        },
        Config => {
            UserID => 1,
        },
        ExpectedResults => {
            Modified => {
                'OutOfOfficeMessageTemplate' => 'template',
            },
        },
        Success => 1,
    },
    {
        Name              => 'Full Load',
        ConfigurationPerl => {
            Default => {
                ProductName => {
                    EffectiveValue => 'Test Modified',
                },
                AgentLoginLogo => {
                    EffectiveValue => {
                        URL         => 'Test Default URL',
                        StyleHeight => '70px',
                    },
                },
            },
            Modified => {
                ProductName => {
                    EffectiveValue => 'Test Modified 2',
                },
                AgentLoginLogo => {
                    EffectiveValue => {
                        URL         => 'Test Modified URL 2',
                        StyleHeight => '70px',
                    },
                },
            },
        },
        Config => {
            UserID => 1,
        },
        ExpectedResults => {
            Modified => {
                ProductName    => 'Test Modified 2',
                AgentLoginLogo => {
                    URL         => 'Test Modified URL 2',
                    StyleHeight => '70px',
                },
            },
        },
        Success => 1,
    },
);

my $YAMLObject      = $Kernel::OM->Get('Kernel::System::YAML');
my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

TEST:
for my $Test (@Tests) {
    $RemoveDirtyFlags->();

    my $ConfigurationYAML = $YAMLObject->Dump(
        Data => $Test->{ConfigurationPerl},
    );

    my $Success = $SysConfigObject->ConfigurationLoad(
        %{ $Test->{Config} },
        ConfigurationYAML => $ConfigurationYAML,
    );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "$Test->{Name} ConfigurationLoad() - with false()",
        );
        next TEST;
    }

    $Self->True(
        $Success,
        "$Test->{Name} ConfigurationLoad() - with True()",
    );

    my @DefaultDirty = $SysConfigDBObject->DefaultSettingListGet(
        IsDirty => 1,
    );

    $Self->IsDeeply(
        \@DefaultDirty,
        [],
        "$Test->{Name} - Default Dirty",
    );

    my @ModifiedDirty = $SysConfigDBObject->ModifiedSettingListGet(
        IsDirty  => 1,
        IsGlobal => 1,
    );

    my %ModifiedDirtyResult = map { $_->{Name} => $_->{EffectiveValue} } @ModifiedDirty;

    $Self->IsDeeply(
        \%ModifiedDirtyResult,
        $Test->{ExpectedResults}->{Modified},
        "$Test->{Name} ExpectedResults - modified",
    );

    for my $SettingName ( sort keys %{ $Test->{ConfigurationPerl}->{Modified} } ) {
        if ( defined $Test->{ConfigurationPerl}->{Modified}->{$SettingName}->{IsValid} ) {
            my %Setting = $SysConfigObject->SettingGet(
                Name   => $SettingName,
                UserID => 1,
            );

            $Self->Is(
                $Setting{IsValid},
                $Test->{ConfigurationPerl}->{Modified}->{$SettingName}->{IsValid},
                "Make sure that $SettingName has correct IsValid value.",
            );
        }
    }
}

1;
