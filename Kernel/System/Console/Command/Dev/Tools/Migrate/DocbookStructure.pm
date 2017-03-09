# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::Migrate::DocbookStructure;

use strict;
use warnings;

use File::Basename;
use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::SysConfig::Migration',
    'Kernel::Config',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Migrate the admin manual to the new config structure.');
    $Self->AddOption(
        Name        => 'source-directory',
        Description => "Directory which contains configuration XML files that needs to be migrated.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'language',
        Description => "Which language to migrate.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'filename',
        Description => "FileName to migrate (without .xml).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # Perform any custom validations here. Command execution can be stopped with die().
    my $Home      = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $Directory = $Self->GetOption('source-directory');
    my $Language  = $Self->GetOption('language');
    if (
        $Directory !~ m{$Home} &&
        $Directory !~ m{^/}
        )
    {
        $Directory = $Home . '/' . $Directory . '/' . $Language;
    }
    else {
        $Directory .= $Language;
    }
    if ( $Directory && !-d $Directory ) {
        die "Directory $Directory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # needed objects
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $Home       = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $Directory  = $Self->GetOption('source-directory');
    my $Language   = $Self->GetOption('language');

    if (
        $Directory !~ m{$Home} &&
        $Directory !~ m{^/}
        )
    {
        $Directory = $Home . '/' . $Directory . '/' . $Language;
    }
    else {
        $Directory .= $Language;
    }
    my $XMLDirectory = $Directory . '-XML';

    #$Self->Print("\npre XML-DIR $Directory\n");

    my @Files = $MainObject->DirectoryRead(
        Directory => $Directory,
        Recursive => 1,
        Filter    => '*.xml',
    );

    if ( !@Files ) {
        $Self->PrintError("No XML files found in $Directory.");
        return $Self->ExitCodeError();
    }

    if ( !-d "$XMLDirectory" ) {

        # Create XML directory
        `mkdir $XMLDirectory`;

        if ( !-d "$XMLDirectory" ) {
            $Self->Print("\n<red>XML-Path-create Failed. -> $XMLDirectory</red>\n");
            return $Self->ExitCodeError();
        }
    }

    my $DirLength = length($Directory);

    $Self->Print("\n<yellow>Migrating configuration XML files...</yellow>\n");
    my $FileCount = 0;

    FILE:
    for my $File (@Files) {

        # Read XML file
        my $ContentRef = $MainObject->FileRead(
            Location => $File,
            Mode     => 'utf8',
        );

        if ( $Self->GetOption('filename') ) {
            my $FileName = $Self->GetOption('filename') . '.xml';
            next FILE if $File !~ m{$FileName};
        }

        # check for ConfigReference
        if (
            $$ContentRef !~ m{ConfigReference_}
            )
        {
            next FILE;
        }

        # prepare and check migration-folders
        my $NewFolder = $XMLDirectory . substr( $File, $DirLength );

        my @CheckFolders = split( '/', $NewFolder );
        my $FolderString = '';

        FOLDERCHECK:
        for my $FolderCheck (@CheckFolders) {
            last FOLDERCHECK if $FolderCheck =~ m{\.xml};
            $FolderString .= $FolderCheck . '/';

            #$Self->Print("\n - $FolderString\n");
            if ( !-d "$FolderString" ) {

                mkdir "$FolderString";
            }
            if ( !-d "$FolderString" ) {

                $Self->Print("<red>New XML-Path-create Failed. -> $FolderString</red>\n");
                return $Self->ExitCodeError();
            }
        }

        my $TargetPath = $FolderString . basename($File);
        $Self->Print("$File -> $TargetPath...");

        # Get file name without extension
        my $FileName = $File;
        $FileName =~ s{^.*/(.*?)\..*$}{$1}gsmx;

        # Migrate
        my $Result = $Self->_MigrateDocBook(
            Content => $$ContentRef,
            Name    => $File,
        );

        if ( !$Result ) {
            $Self->Print("<red>Failed.</red>\n");
            next FILE;
        }
        $FileCount++;

        if ( $Result ne $$ContentRef ) {

            # Save result
            my $Success = $MainObject->FileWrite(
                Location => $TargetPath,
                Content  => \$Result,
                Mode     => 'utf8',
            );

            if ($Success) {
                $Self->Print(" <green>Saved.</green>\n");
            }
        }
    }

    $Self->Print("\n<green>$FileCount Files done.\nMigration finished</green>\n");
    return $Self->ExitCodeOk();
}

sub _MigrateDocBook {
    my ( $Self, %Param ) = @_;

    my $Content  = $Param{Content};
    my $FileName = $Param{Name};

    my $WorkContent = $Content;

    my $LogMessage = "\n" . $FileName . "\n";

    # Remove SubGroups from Config
    my @Subgroups = $Self->_GetSubGroups();

    # remove SubGroup if "ConfigReference_SubGroup" or SubGroup in description
    for my $SubGroup (@Subgroups) {
        $WorkContent =~ s{=\"ConfigReference_$SubGroup\:}{="ConfigReference_}gsmx;

        # Description
        $WorkContent =~ s{\">$SubGroup\:(\w)}{">$1}gsmx;
        $WorkContent =~ s{\">$SubGroup\s&gt;\s}{">}gsmx;

        # Description with line break
        $WorkContent =~ s{\">\n$SubGroup\:(\w)}{">\n$1}gsmx;
        $WorkContent =~ s{\">\n$SubGroup\s-&gt;\s}{">\n}gsmx;
        $WorkContent =~ s{\">\n$SubGroup\s->\s}{">\n}gsmx;
    }

    # Replace Navigation Structure
    my %Navigation = $Self->_GetNavigation();

    MIGRATE:
    while ( $WorkContent =~ m{=\"ConfigReference\_(.*)">}g ) {
        my $TmpString = $1;

        next MIGRATE if ( $TmpString =~ m{MMMM} );

        for my $Navi ( sort keys %Navigation ) {

            # set Section if "ConfigReference_Navigation" only
            $WorkContent =~ s{=\"ConfigReference_$Navi\"}{="ConfigReference_Section_$Navigation{$Navi}"}gsmx;

            # Set Setting if "ConfigReference_Navigation:Some::More::Stuff"
            $WorkContent
                =~ s{=\"ConfigReference_$Navi\:(\w[\:\:|\w]*?)\"}{="ConfigReference_Setting_$Navigation{$Navi}:$1"}gsmx;
        }
    }
    $WorkContent =~ s{MMMM}{::}gsmx;

    return $WorkContent;
}

sub _GetNavigation {
    my ( $Self, %Param ) = @_;

    my %Navigation = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->NavigationLookupGet();

    # Make easy usable in replacement
    for my $Navi ( sort keys %Navigation ) {
        my $Tmp = $Navigation{$Navi};
        $Tmp =~ s{\:\:}{MMMM}gsmx;
        $Navigation{$Navi} = $Tmp;
    }

    return %Navigation;
}

sub _GetSubGroups {
    my ( $Self, %Param ) = @_;

    my @SubGroup = (
        'CloudService',
        'Daemon',
        'DynamicFields',
        'Framework',
        'Fred',
        'GenericInterface',
        'ProcessManagement',
        'Ticket',
    );

    return @SubGroup;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
