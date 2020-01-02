# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::Migrate::ConfigXMLStructure;

use strict;
use warnings;

use File::Basename;
use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::SysConfig::Migration',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Migrate XML configuration files from OTRS 5 to OTRS 6.');
    $Self->AddOption(
        Name        => 'source-directory',
        Description => "Directory which contains configuration XML files that needs to be migrated.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # Perform any custom validations here. Command execution can be stopped with die().
    my $Directory = $Self->GetOption('source-directory');
    if ( $Directory && !-d $Directory ) {
        die "Directory $Directory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Migrating configuration XML files...</yellow>\n");

    # needed objects
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $Directory = $Self->GetOption('source-directory');
    my @Files     = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.xml',
    );

    if ( !@Files ) {
        $Self->PrintError("No XML files found in $Directory.");
        return $Self->ExitCodeError();
    }

    if ( !-d "$Directory/XML" ) {

        # Create XML directory
        mkdir "$Directory/XML";
    }

    FILE:
    for my $File (@Files) {

        my $TargetPath = "$Directory/XML/" . basename($File);

        $Self->Print("$File -> $TargetPath...");

        # Read XML file
        my $ContentRef = $MainObject->FileRead(
            Location => $File,
            Mode     => 'utf8',
        );

        # Get file name without extension
        my $FileName = $File;
        $FileName =~ s{^.*/(.*?)\..*$}{$1}gsmx;

        # Migrate
        my $Result = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateXMLStructure(
            Content => $$ContentRef,
            Name    => $FileName,
        );

        if ( !$Result ) {
            $Self->Print("<red>Failed.</red>\n");
            next FILE;
        }

        # Save result
        my $Success = $MainObject->FileWrite(
            Location => $TargetPath,
            Content  => \$Result,
            Mode     => 'utf8',
        );

        $Self->Print(" <green>Done.</green>\n");
    }

    $Self->Print("\n<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
