# --
# Kernel/System/Console/Command/Maint/Database/MySQL/InnoDBMigration.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Database::MySQL::InnoDBMigration;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::PID',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Converts all MySQL database tables to InnoDB.');
    $Self->AddOption(
        Name        => 'force',
        Description => "Actually do the migration now.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'force-pid',
        Description => "Start even if another process is still registered in the database.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    if ( $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'} ne 'mysql' ) {
        die "This script can only be run on mysql databases.\n";
    }

    my $PIDCreated = $Kernel::OM->Get('Kernel::System::PID')->PIDCreate(
        Name  => $Self->Name(),
        Force => $Self->GetOption('force-pid'),
        TTL   => 60 * 60 * 24 * 3,
    );
    if ( !$PIDCreated ) {
        my $Error = "Unable to register the process in the database. Is another instance still running?\n";
        $Error .= "You can use --force-pid to override this check.\n";
        die $Error;
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Force = $Self->GetOption('force');
    if ($Force) {
        $Self->Print("<yellow>Converting all database tables to InnoDB...</yellow>\n");
    }
    else {
        $Self->Print("<yellow>Checking for tables that need to be converted to InnoDB...</yellow>\n");
    }

    # Get all tables that have MyISAM
    $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL => "SHOW TABLE STATUS WHERE ENGINE = 'MyISAM'",
    );

    my @Tables;
    while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        push @Tables, $Row[0];
    }

    # Turn off foreign key checks.
    if (@Tables) {
        my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "SET foreign_key_checks = 0",
        );
        if ( !$Result ) {
            $Self->PrintError('Could not disable foreign key checks.');
            return $Self->ExitCodeError();
        }
    }

    $Self->Print( "<yellow>" . scalar @Tables . "</yellow> tables need to be converted.\n" );
    if ( !$Force ) {
        if (@Tables) {
            $Self->Print("You can re-run this script with <green>--force</green> to start the migration.\n");
            $Self->Print("<red>This operation can take a long time.</red>\n");
        }
        return $Self->ExitCodeOk();
    }

    # Now convert the tables.
    for my $Table (@Tables) {
        $Self->Print("  Changing table <yellow>$Table</yellow> to engine InnoDB...\n");
        my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "ALTER TABLE $Table ENGINE = InnoDB",
        );
        if ( !$Result ) {
            $Self->PrintError("Could not convert table $Table to engine InnoDB.");
            return $Self->ExitCodeError();
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub PostRun {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::PID')->PIDDelete( Name => $Self->Name() );
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
