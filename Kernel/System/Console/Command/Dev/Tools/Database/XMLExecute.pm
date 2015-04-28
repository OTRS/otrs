# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::Database::XMLExecute;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::XML',

);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Convert an OTRS database XML file to SQL and execute it in the current database.');
    $Self->AddArgument(
        Name        => 'source-path',
        Description => "Specify the location of the database XML file to be executed.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SourcePath = $Self->GetArgument('source-path');
    if ( !-r $SourcePath ) {
        die "Source file $SourcePath does not exist / is not readable.\n";
    }
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $Self->GetArgument('source-path'),
    );
    if ( !$XML ) {
        $Self->PrintError("Could not read XML source.");
        return $Self->ExitCodeError();
    }
    my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XML );
    my @SQL = $Kernel::OM->Get('Kernel::System::DB')->SQLProcessor(
        Database => \@XMLArray,
    );
    if ( !@SQL ) {
        $Self->PrintError("Could not generate SQL.");
        return $Self->ExitCodeError();
    }

    my @SQLPost = $Kernel::OM->Get('Kernel::System::DB')->SQLProcessorPost();

    for my $SQL ( @SQL, @SQLPost ) {
        $Self->Print("$SQL\n");
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do( SQL => $SQL );
        if ( !$Success ) {
            $Self->PrintError("Database action failed. Exiting.");
            return $Self->ExitCodeError();
        }
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
