# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::InvalidSettingsCheck;    ## no critic

use strict;
use warnings;

use IO::Interactive qw(is_interactive);

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Console::Command::Admin::Config::FixInvalid',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo6::InvalidSettingsCheck - Checks for invalid configuration settings.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @InvalidSettings = $SysConfigObject->ConfigurationInvalidList(
        Undeployed => 1,    # Check undeployed settings as well.
        NoCache    => 1,
    );

    return 1 if !scalar @InvalidSettings;

    my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Config::FixInvalid');

    # This check will occur only if we are in interactive mode.
    if ( $Param{CommandlineOptions}->{NonInteractive} || !is_interactive() ) {

        # Try to fix invalid settings automatically. Run in no-ANSI mode for consistent output.
        $CommandObject->Execute( '--non-interactive', '--no-ansi' );
    }
    else {
        # Try to fix invalid settings manually.
        $CommandObject->Execute('--no-ansi');
    }

    # Check if there are still some invalid settings.
    @InvalidSettings = $SysConfigObject->ConfigurationInvalidList(
        Undeployed => 1,    # Check undeployed settings as well.
        NoCache    => 1,
    );

    return 1 if !scalar @InvalidSettings;

    print "\n        Migration was OK, however there are some settings with invalid values:";

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    for my $SettingName (@InvalidSettings) {
        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        my $EffectiveValue = $MainObject->Dump(
            $Setting{EffectiveValue},
        );

        $EffectiveValue =~ s/\$VAR1 = //;

        print "\n            - $SettingName - $EffectiveValue";
    }

    print
        "\n        Please use console command (bin/otrs.Console.pl Admin::Config::Update --help) or GUI to fix them.\n";

    return 1;
}

1;
