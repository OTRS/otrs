# --
# Kernel/System/Console/Command/Help.pm - show help for a command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Help;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Displays help for a command.');
    $Self->AddArgument(
        Name        => 'command',
        Description => "Print usage information for this command.",
        ValueRegex  => qr/[a-zA-Z0-9:_]+/,
        Required    => 1,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Command = $Kernel::OM->Get( 'Kernel::System::Console::Command::' . $Self->GetArgument('command') );
    $Command->ANSI( $Self->ANSI() );
    print $Command->GetUsageHelp();

    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
