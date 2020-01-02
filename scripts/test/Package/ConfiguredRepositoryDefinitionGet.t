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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Make sure repository root setting is set to default for duration of the test.
my %Setting = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
    Name    => 'Package::RepositoryRoot',
    Default => 1,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Package::RepositoryRoot',
    Value => $Setting{DefaultValue},
);

my @FrameworkVersionParts = split /\./, $Kernel::OM->Get('Kernel::Config')->Get('Version');
my $FrameworkVersion      = $FrameworkVersionParts[0];

my @Tests = (
    {
        Name           => 'No Repositories',
        ConfigSet      => {},
        Success        => 1,
        ExpectedResult => {
            'http://ftp.otrs.org/pub/otrs/packages/' => 'OTRS Freebie Features'
        },
    },
    {
        Name      => 'No ITSM Repositories',
        ConfigSet => {
            'http://otrs.com' => 'Test Repository',
        },
        Success        => 1,
        ExpectedResult => {
            'http://ftp.otrs.org/pub/otrs/packages/' => 'OTRS Freebie Features',
            'http://otrs.com'                        => 'Test Repository',
        },
    },
    {
        Name      => 'ITSM 33 Repository',
        ConfigSet => {
            'http://otrs.com'                               => 'Test Repository',
            'http://ftp.otrs.org/pub/otrs/itsm/packages33/' => 'OTRS::ITSM 3.3 Master',
        },
        Success        => 1,
        ExpectedResult => {
            'http://ftp.otrs.org/pub/otrs/packages/'                       => 'OTRS Freebie Features',
            'http://otrs.com'                                              => 'Test Repository',
            "http://ftp.otrs.org/pub/otrs/itsm/packages$FrameworkVersion/" => "OTRS::ITSM $FrameworkVersion Master",
        },
    },
    {
        Name      => 'ITSM 33 and 4 Repository',
        ConfigSet => {
            'http://otrs.com'                               => 'Test Repository',
            'http://ftp.otrs.org/pub/otrs/itsm/packages33/' => 'OTRS::ITSM 3.3 Master',
            'http://ftp.otrs.org/pub/otrs/itsm/packages4/'  => 'OTRS::ITSM 4 Master',
        },
        Success        => 1,
        ExpectedResult => {
            'http://ftp.otrs.org/pub/otrs/packages/'                       => 'OTRS Freebie Features',
            'http://otrs.com'                                              => 'Test Repository',
            "http://ftp.otrs.org/pub/otrs/itsm/packages$FrameworkVersion/" => "OTRS::ITSM $FrameworkVersion Master",
        },
    },
    {
        Name      => 'ITSM 33 4 and 5 Repository',
        ConfigSet => {
            'http://otrs.com'                               => 'Test Repository',
            'http://ftp.otrs.org/pub/otrs/itsm/packages33/' => 'OTRS::ITSM 3.3 Master',
            'http://ftp.otrs.org/pub/otrs/itsm/packages4/'  => 'OTRS::ITSM 4 Master',
            'http://ftp.otrs.org/pub/otrs/itsm/packages5/'  => 'OTRS::ITSM 5 Master',
        },
        Success        => 1,
        ExpectedResult => {
            'http://ftp.otrs.org/pub/otrs/packages/'                       => 'OTRS Freebie Features',
            'http://otrs.com'                                              => 'Test Repository',
            "http://ftp.otrs.org/pub/otrs/itsm/packages$FrameworkVersion/" => "OTRS::ITSM $FrameworkVersion Master",
        },
    },
    {
        Name      => 'ITSM 6 Repository',
        ConfigSet => {
            'http://ftp.otrs.org/pub/otrs/packages/'                       => 'OTRS Freebie Features',
            'http://otrs.com'                                              => 'Test Repository',
            "http://ftp.otrs.org/pub/otrs/itsm/packages$FrameworkVersion/" => "OTRS::ITSM $FrameworkVersion Master",
        },
        Success        => 1,
        ExpectedResult => {
            'http://ftp.otrs.org/pub/otrs/packages/'                       => 'OTRS Freebie Features',
            'http://otrs.com'                                              => 'Test Repository',
            "http://ftp.otrs.org/pub/otrs/itsm/packages$FrameworkVersion/" => "OTRS::ITSM $FrameworkVersion Master",
        },
    },
);

my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
my $ConfigKey     = 'Package::RepositoryList';

for my $Test (@Tests) {
    if ( $Test->{ConfigSet} ) {
        my $Success = $ConfigObject->Set(
            Key   => $ConfigKey,
            Value => $Test->{ConfigSet},
        );
        $Self->True(
            $Success,
            "$Test->{Name} configuration set in run time",
        );
    }

    my %RepositoryList = $PackageObject->_ConfiguredRepositoryDefinitionGet();

    $Self->IsDeeply(
        \%RepositoryList,
        $Test->{ExpectedResult},
        "$Test->{Name} _ConfiguredRepositoryDefinitionGet()",
    );
}

1;
