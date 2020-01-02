# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
## nofilter(TidyAll::Plugin::OTRS::Perl::TestSubs)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::ObjectManager;

# Get needed objects
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
$HelperObject->FixedTimeSet();

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

# Delete cache.
$CacheObject->Delete(
    Type => 'SysConfigPersistent',
    Key  => "EffectiveValues2PerlFile",
);

my @Tests = (
    {
        Name    => 'No params',
        Param   => {},
        Success => 0,
    },
    {
        Name  => 'Missing Settings',
        Param => {
            TargetPath => 'Kernel/Config/Files/ZZZAAAuto.pm'
        },
        Success => 0,
    },
    {
        Name  => 'Missing TargetPath',
        Param => {
            Settings => [
                {
                    Name           => 'SettingName',
                    IsValid        => 1,
                    EffectiveValue => '1',
                },
            ],
        },
        Success => 0,
    },
    {
        Name  => 'Wrong settings format',
        Param => {
            Settings => {
                Name           => 'SettingName',
                IsValid        => 1,
                EffectiveValue => '1',
            },
            TargetPath => 'Kernel/Config/Files/ZZZAAAuto.pm',
        },
        Success => 0,
    },
    {
        Name  => 'Single Setting Simple Value',
        Param => {
            Settings => [
                {
                    Name           => 'SettingName',
                    IsValid        => 1,
                    EffectiveValue => '1',
                },
            ],
            TargetPath => 'Kernel/Config/Files/ZZZAAAuto.pm',
        },
        ExpectedValue => {
            Package => 'Kernel::Config::Files::ZZZAAAuto;',
            Value   => << 'EOF'
$Self->{'SettingName'} =  '1';
EOF
        },
        Success => 1,
    },
    {
        Name  => 'Multiple Settings Simple Value',
        Param => {
            Settings => [
                {
                    Name           => 'SettingName',
                    IsValid        => 1,
                    EffectiveValue => '1',
                },
                {
                    Name           => 'AnotherSettingName',
                    IsValid        => 1,
                    EffectiveValue => '2',
                },

            ],
            TargetPath => 'Kernel/Config/Files/ZZZAAAuto.pm',
        },
        ExpectedValue => {
            Package => 'Kernel::Config::Files::ZZZAAAuto;',
            Value   => << 'EOF'
$Self->{'SettingName'} =  '1';
$Self->{'AnotherSettingName'} =  '2';
EOF
        },
        Success => 1,
    },
    {
        Name  => 'Single Setting Complex Value',
        Param => {
            Settings => [
                {
                    Name           => 'SettingName',
                    IsValid        => 1,
                    EffectiveValue => [
                        {
                            Value => 1,
                        },
                    ],
                },
            ],
            TargetPath => 'Kernel/Config/Files/User/1.pm',
        },
        ExpectedValue => {
            Package => 'Kernel::Config::Files::User::1;',
            Value   => << 'EOF'
$Self->{'SettingName'} =  [
  {
    'Value' => 1
  }
];
EOF
        },
        Success => 1,
    },
    {
        Name  => 'Multiple Setting Complex Value',
        Param => {
            Settings => [
                {
                    Name           => 'SettingName',
                    IsValid        => 1,
                    EffectiveValue => [
                        {
                            Value => 1,
                        },
                    ],
                },
                {
                    Name           => 'AnotherSettingName',
                    IsValid        => 1,
                    EffectiveValue => {
                        Value  => 1,
                        Value2 => [ '2', '3' ],
                    },
                },
            ],
            TargetPath => 'Kernel/Config/Files/User/1.pm',
        },
        ExpectedValue => {
            Package => 'Kernel::Config::Files::User::1;',
            Value   => << 'EOF'
$Self->{'SettingName'} =  [
  {
    'Value' => 1
  }
];
$Self->{'AnotherSettingName'} =  {
  'Value' => 1,
  'Value2' => [
    '2',
    '3'
  ]
};
EOF
        },
        Success => 1,
    },
    {
        Name  => 'Multiple Setting Complex Value Name Hash',
        Param => {
            Settings => [
                {
                    Name           => 'SettingName###Key1',
                    IsValid        => 1,
                    EffectiveValue => [
                        {
                            Value => 1,
                        },
                    ],
                },
                {
                    Name           => 'SettingName###Key2',
                    IsValid        => 1,
                    EffectiveValue => {
                        Value  => 1,
                        Value2 => [ '2', '3' ],
                    },
                },
            ],
            TargetPath => 'Kernel/Config/Files/User/1.pm',
        },
        ExpectedValue => {
            Package => 'Kernel::Config::Files::User::1;',
            Value   => << 'EOF'
$Self->{'SettingName'}->{'Key1'} =  [
  {
    'Value' => 1
  }
];
$Self->{'SettingName'}->{'Key2'} =  {
  'Value' => 1,
  'Value2' => [
    '2',
    '3'
  ]
};
EOF
        },
        Success => 1,
    },

    {
        Name  => 'Multiple Setting Complex Value Disabled',
        Param => {
            Settings => [
                {
                    Name           => 'SettingName###Key1',
                    IsValid        => 0,
                    EffectiveValue => [
                        {
                            Value => 1,
                        },
                    ],
                },
                {
                    Name           => 'DefaultUsedLanguages',
                    IsValid        => 0,
                    EffectiveValue => {
                        Value  => 1,
                        Value2 => 2,
                    },
                },
            ],
            TargetPath => 'Kernel/Config/Files/User/1.pm',
        },
        ExpectedValue => {
            Package => 'Kernel::Config::Files::User::1;',
            Value   => << 'EOF'
delete $Self->{'DefaultUsedLanguages'};
EOF
        },
        Success => 1,
    },
);

my $AssembleExpectedValue = sub {
    my %Param = @_;

    my $File = << "EOF";
# OTRS config file (automatically generated)
# VERSION:2.0
package $Param{Package}
use strict;
use warnings;
no warnings 'redefine'; ## no critic
use utf8;
sub Load {
    my (\$File, \$Self) = \@_;
EOF

    $File .= $Param{Value};

    $File .= << 'EOF';
    return;
}
1;
EOF
};

# Get SysConfig object;
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

TEST:
for my $Test (@Tests) {
    my $FileString = $SysConfigObject->_EffectiveValues2PerlFile( %{ $Test->{Param} } );

    if ( !$Test->{Success} ) {
        $Self->Is(
            $FileString,
            undef,
            "$Test->{Name} _EffectiveValues2PerlFile() - (not success)",
        );
        next TEST;
    }

    my $ExpectedValue = $AssembleExpectedValue->( %{ $Test->{ExpectedValue} } );
    $Self->IsDeeply(
        $FileString,
        $ExpectedValue,
        "$Test->{Name} _EffectiveValues2PerlFile() -",
    );
}

$HelperObject->FixedTimeAddSeconds( 60 * 60 * 24 * 35 );    # Add 35 days, it should be enough to make results obsolete.
my $FileString = $SysConfigObject->_EffectiveValues2PerlFile(
    Settings => [
        {
            Name           => 'SettingName###Key1',
            IsValid        => 1,
            EffectiveValue => 'NewValue',
        },
    ],
    TargetPath => 'Kernel/Config/Files/User/1.pm',
);
$Self->True(
    $FileString,
    'Call _EffectiveValues2PerlFile() after 35 days',
);

# Get cache value directly.
my $Cached = $Kernel::OM->Get('Kernel::System::Cache')->Get(
    Type => 'SysConfigPersistent',
    Key  => "EffectiveValues2PerlFile",
);

delete $Cached->{NewValue};

$Self->IsDeeply(
    $Cached,
    {
    },
    'Make sure that all other parts of cache are deleted (they are expired).'
);
1;
