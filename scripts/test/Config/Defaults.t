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

use Kernel::Config::Files::ZZZAAuto;

=head1 SYNOPSIS

This test verifies that the settings defined in Defaults.pm match those in ZZZAAuto.pm (XML default config cache).

This test will only operate if no custom/unknown configuration files are present, because these might alter the default
settings and cause unexpected test failures.

=cut

my $ChecksumFileNotPresent = sub {
    $Self->False(
        1,
        'Default configuration unit test requires the checksum file (ARCHIVE) to be present and valid. Please first call the following command to create it: bin/otrs.CheckSum.pl -a create'
    );
    return 1;
};

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# Checksum file content as an array ref.
my $ChecksumFileArrayRef = $MainObject->FileRead(
    Location        => "$Home/ARCHIVE",
    Mode            => 'utf8',
    Type            => 'Local',
    Result          => 'ARRAY',
    DisableWarnings => 1,
);
return $ChecksumFileNotPresent->() if !$ChecksumFileArrayRef || !@{$ChecksumFileArrayRef};

# Get list of present config XML files.
my $Directory   = "$Home/Kernel/Config/Files/XML";
my @ConfigFiles = $MainObject->DirectoryRead(
    Directory => $Directory,
    Filter    => '*.xml',
);

for my $ConfigFile (@ConfigFiles) {

    $ConfigFile =~ s{^${Home}/(.*/[^/]+.xml)$}{$1}xmsg;

    if ( !grep { $_ =~ $ConfigFile } @{$ChecksumFileArrayRef} ) {
        $Self->False(
            0,
            "Custom configuration file found ($ConfigFile), skipping test..."
        );
        return 1;
    }
}

my $DefaultConfig = {};
bless $DefaultConfig, 'Kernel::Config::Defaults';
$DefaultConfig->Kernel::Config::Defaults::LoadDefaults();

my $ZZZAAutoConfig = {};
bless $ZZZAAutoConfig, 'Kernel::Config::Files::ZZZAAuto';
Kernel::Config::Files::ZZZAAuto->Load($ZZZAAutoConfig);

# These entries are hashes
my %CheckSubEntries = (
    'Frontend::Module'                   => 1,
    'Frontend::NotifyModule'             => 1,
    'Frontend::Navigation'               => 1,
    'Frontend::NavigationModule'         => 1,
    'CustomerFrontend::Module'           => 1,
    'Loader::Agent::CommonJS'            => 1,
    'Loader::Agent::CommonCSS'           => 1,
    'Loader::Customer::CommonJS'         => 1,
    'Loader::Customer::CommonCSS'        => 1,
    'PreferencesGroups'                  => 1,
    'Ticket::Article::Backend::MIMEBase' => 1,
);

# These entries are hashes of hashes
my %CheckSubEntriesElements = (
    'Frontend::Navigation###Admin' => 1,
);

my %IgnoreEntries = (
    'Frontend::CommonParam'         => 1,
    'CustomerFrontend::CommonParam' => 1,
    'PublicFrontend::CommonParam'   => 1,

    # This settings are modified in framework.xml and needs to be excluded from this test.
    'Loader::Module::Admin'                    => 1,
    'Loader::Module::AdminLog'                 => 1,
    'Loader::Module::AdminSystemConfiguration' => 1,

    # This settings is modified in daemon.xml and needs to be excluded from this test.
    'DaemonModules' => 1,
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

DEFAULTCONFIGENTRY:
for my $DefaultConfigEntry ( sort keys %{$DefaultConfig} ) {

    # There is a number of settings that are only in Defaults.pm, ignore these
    next DEFAULTCONFIGENTRY if !exists $ZZZAAutoConfig->{$DefaultConfigEntry};

    next DEFAULTCONFIGENTRY if $IgnoreEntries{$DefaultConfigEntry};

    if ( $CheckSubEntries{$DefaultConfigEntry} ) {

        DEFAULTCONFIGSUBENTRY:
        for my $DefaultConfigSubEntry ( sort keys %{ $DefaultConfig->{$DefaultConfigEntry} } ) {

            # There is a number of settings that are only in Defaults.pm, ignore these
            if ( !exists $ZZZAAutoConfig->{$DefaultConfigEntry}->{$DefaultConfigSubEntry} ) {
                next DEFAULTCONFIGSUBENTRY;
            }

            my $SettingName          = $DefaultConfigEntry . '###' . $DefaultConfigSubEntry;
            my $DefaultConfigSetting = $DefaultConfig->{$DefaultConfigEntry}->{$DefaultConfigSubEntry};

            # Check for a third level settings
            if ( $CheckSubEntriesElements{$SettingName} ) {

                DEFAULTCONFIGSUBENTRYELEMENT:
                for my $DefaultConfigSubEntryElement ( sort keys %{$DefaultConfigSetting} ) {

                    if (
                        !exists $ZZZAAutoConfig->{$DefaultConfigEntry}->{$DefaultConfigSubEntry}
                        ->{$DefaultConfigSubEntryElement}
                        )
                    {
                        next DEFAULTCONFIGSUBENTRYELEMENT;
                    }

                    my %Setting = $SysConfigObject->SettingGet(
                        Name => $DefaultConfigEntry . '###'
                            . $DefaultConfigSubEntry . '###'
                            . $DefaultConfigSubEntryElement,
                        Default => 1,
                    );

                    $Self->IsDeeply(
                        \$DefaultConfigSetting->{$DefaultConfigSubEntryElement},
                        \$Setting{EffectiveValue},
                        "$DefaultConfigEntry->$DefaultConfigSubEntry->$DefaultConfigSubEntryElement must be the same in Defaults.pm and setting default value",
                    );
                }
            }
            else {

                my %Setting = $SysConfigObject->SettingGet(
                    Name    => $SettingName,
                    Default => 1,
                );

                $Self->IsDeeply(
                    \$DefaultConfigSetting,
                    \$Setting{EffectiveValue},
                    "$DefaultConfigEntry->$DefaultConfigSubEntry must be the same in Defaults.pm and setting default value",
                );
            }
        }
    }
    else {

        my %Setting = $SysConfigObject->SettingGet(
            Name    => $DefaultConfigEntry,
            Default => 1,
        );

        $Self->IsDeeply(
            \$DefaultConfig->{$DefaultConfigEntry},
            \$Setting{EffectiveValue},
            "$DefaultConfigEntry must be the same in Defaults.pm and and setting default value",
        );
    }
}

1;
