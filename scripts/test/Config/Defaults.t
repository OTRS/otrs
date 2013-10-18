# --
# Defaults.t - config tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::Config::Files::ZZZAAuto;

=head1 SYNOPSIS

This test verifies that the settings defined in Defaults.pm
match those in ZZZAAuto.pm (XML default config cache).

This test will only operate if no custom/unkown configuration
files are installed, because these might alter the default settings
and cause wrong test failures.

=cut

# Get list of installed config XML files
my $Directory   = $Self->{ConfigObject}->Get('Home') . "/Kernel/Config/Files/";
my @ConfigFiles = $Self->{MainObject}->DirectoryRead(
    Directory => $Directory,
    Filter    => "*.xml",
);

my %AllowedConfigFiles = (
    'Framework.xml'         => 1,
    'Fred.xml'              => 1,
    'GenericInterface.xml'  => 1,
    'ProcessManagement.xml' => 1,
    'Scheduler.xml'         => 1,
    'Ticket.xml'            => 1,
    'Support.xml'           => 1,
    'OTRSCodePolicy.xml'    => 1,
);

for my $ConfigFile (@ConfigFiles) {
    $ConfigFile =~ s{^.*/([^/]+.xml)$}{$1}xmsg;
    if ( !$AllowedConfigFiles{$ConfigFile} ) {
        print "You have custom configuration files installed ($ConfigFile). Skipping this test.\n";
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
    'Frontend::Module'            => 1,
    'CustomerFrontend::Module'    => 1,
    'Loader::Agent::CommonJS'     => 1,
    'Loader::Agent::CommonCSS'    => 1,
    'Loader::Customer::CommonJS'  => 1,
    'Loader::Customer::CommonCSS' => 1,
    'PreferencesGroups'           => 1,
);

my %IgnoreEntries = (
    'Frontend::CommonObject'         => 1,
    'Frontend::CommonParam'          => 1,
    'CustomerFrontend::CommonObject' => 1,
    'CustomerFrontend::CommonParam'  => 1,
    'PublicFrontend::CommonParam'    => 1,
);

DEFAULTCONFIGENTRY:
for my $DefaultConfigEntry ( sort keys %{$DefaultConfig} ) {

    # There is a number of settings that are only in Defaults.pm, ignore these
    next DEFAULTCONFIGENTRY if !exists $ZZZAAutoConfig->{$DefaultConfigEntry};

    next DEFAULTCONFIGENTRY if $IgnoreEntries{$DefaultConfigEntry};

    if ( $CheckSubEntries{$DefaultConfigEntry} ) {

        DEFAULTCONFIGSUBENTRY:
        for my $DefaultConfigSubEntry ( sort keys %{ $DefaultConfig->{$DefaultConfigEntry} } ) {

            # There is a number of settings that are only in Defaults.pm, ignore these
            next DEFAULTCONFIGSUBENTRY
                if !exists $ZZZAAutoConfig->{$DefaultConfigEntry}->{$DefaultConfigSubEntry};

            $Self->IsDeeply(
                \$DefaultConfig->{$DefaultConfigEntry}->{$DefaultConfigSubEntry},
                \$ZZZAAutoConfig->{$DefaultConfigEntry}->{$DefaultConfigSubEntry},
                "$DefaultConfigEntry->$DefaultConfigSubEntry must be the same in Defaults.pm and ZZZAAuto.pm",
            );
        }
    }
    else {
        $Self->IsDeeply(
            \$DefaultConfig->{$DefaultConfigEntry},
            \$ZZZAAutoConfig->{$DefaultConfigEntry},
            "$DefaultConfigEntry must be the same in Defaults.pm and ZZZAAuto.pm",
        );
    }

}

1;
