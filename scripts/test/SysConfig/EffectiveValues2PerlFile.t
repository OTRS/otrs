# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
## nofilter(TidyAll::Plugin::OTRS::Perl::TestSubs)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::ObjectManager;

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

1;
