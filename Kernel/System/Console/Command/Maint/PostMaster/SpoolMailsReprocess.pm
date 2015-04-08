# --
# Kernel/System/Console/Command/Maint/PostMaster/SpoolMailsReprocess.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::PostMaster::SpoolMailsReprocess;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Reprocess mails from spool directory that could not be imported in the first place.');

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SpoolDir = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/var/spool';
    if ( !-d $SpoolDir ) {
        die "Spool directory $SpoolDir does not exist!\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $SpoolDir = "$Home/var/spool";

    $Self->Print("<yellow>Processing mails in $SpoolDir...</yellow>\n");

    my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $SpoolDir,
        Filter    => '*',
    );

    my $Success = 1;

    for my $File (@Files) {
        $Self->Print("  Processing <yellow>$File</yellow>... ");

        # Here we use a system call because Maint::PostMaster::Read has special exception handling
        #   and will die if certain problems occur.
        my $Result = system("$^X $Home/bin/otrs.Console.pl Maint::PostMaster::Read <  $File ");

        # Exit code 0 == success
        if ( !$Result ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Successfully reprocessed email $File.",
            );
            unlink $File;
            $Self->Print("<green>Ok.</green>\n");
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not re-process email $File.",
            );
            $Self->Print("<red>Failed.</red>\n");
            $Success = 0;
        }
    }

    if ( !$Success ) {
        $Self->PrintError("There were problems importing the spool mails.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
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
