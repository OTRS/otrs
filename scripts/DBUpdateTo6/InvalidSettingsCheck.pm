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

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @InvalidSettings = $SysConfigObject->ConfigurationInvalidList(
        Undeployed => 1,    # Check undeployed settings as well.
        NoCache    => 1,
    );

    return 1 if !scalar @InvalidSettings;

    my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Config::FixInvalid');
    my @CommandArgs = ( '--no-ansi', '--skip-missing' );

    if ( !$Verbose ) {
        push @CommandArgs, '--quiet';
    }

    # This check will occur only if we are in interactive mode.
    if ( $Param{CommandlineOptions}->{NonInteractive} || !is_interactive() ) {

        # Try to fix invalid settings automatically. Run in no-ANSI mode for consistent output.
        push @CommandArgs, '--non-interactive';
    }

    # Just execute the command.
    $CommandObject->Execute(@CommandArgs);

    return 1;
}

1;
