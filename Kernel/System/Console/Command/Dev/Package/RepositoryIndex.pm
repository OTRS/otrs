# --
# Kernel/System/Console/Command/Dev/Package/RepositoryIndex.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Dev::Package::RepositoryIndex;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate an index file (otrs.xml) for an OTRS package repository.');
    $Self->AddArgument(
        Name        => 'source-directory',
        Description => "Specify the directory containing the OTRS packages.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SourceDirectory = $Self->GetArgument('source-directory');
    if ( $SourceDirectory && !-d $SourceDirectory ) {
        die "Directory $SourceDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Result = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
    $Result .= "<otrs_package_list version=\"1.0\">\n";
    my $SourceDirectory = $Self->GetArgument('source-directory');
    my @List            = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $SourceDirectory,
        Filter    => '*.opm',
        Recursive => 1,
    );
    for my $File (@List) {
        my $Content    = '';
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $File,
            Mode     => 'utf8',      # optional - binmode|utf8
            Result   => 'SCALAR',    # optional - SCALAR|ARRAY
        );
        if ( !$ContentRef ) {
            $Self->PrintError("Can't open $File: $!\n");
            return $Self->ExitCodeError();
        }
        my %Structure = $Kernel::OM->Get('Kernel::System::Package')->PackageParse( String => ${$ContentRef} );
        my $XML = $Kernel::OM->Get('Kernel::System::Package')->PackageBuild( %Structure, Type => 'Index' );
        if ( !$XML ) {
            $Self->PrintError("Cannot generate index entry for $File.\n");
            return $Self->ExitCodeError();
        }
        $Result .= "<Package>\n";
        $Result .= $XML;
        my $RelativeFile = $File;
        $RelativeFile =~ s{^\Q$SourceDirectory\E}{}smx;
        $RelativeFile =~ s{^/}{}smx;
        $Result .= "  <File>$RelativeFile</File>\n";
        $Result .= "</Package>\n";
    }
    $Result .= "</otrs_package_list>\n";
    $Self->Print($Result);

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
