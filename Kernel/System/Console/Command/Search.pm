# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Search;

use strict;
use warnings;

use parent qw(
    Kernel::System::Console::BaseCommand
    Kernel::System::Console::Command::List
);

our @ObjectDependencies = (
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Search for commands.');
    $Self->AddArgument(
        Name        => 'searchterm',
        Description => "Find commands with similar names or descriptions.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    return $Self->HandleSearch( SearchCommand => $Self->GetArgument('searchterm') );
}

# Also used from "Help" command.

sub HandleSearch {
    my ( $Self, %Param ) = @_;

    my $SearchCommand = $Param{SearchCommand};

    $Self->Print("Searching for commands similar to '<yellow>$SearchCommand</yellow>'...\n");

    my $PreviousCommandNameSpace = '';
    my $UsageText;

    COMMAND:
    for my $Command ( $Self->ListAllCommands() ) {
        my $CommandObject = $Kernel::OM->Get($Command);

        if (
            $Command !~ m{\Q$SearchCommand\E}smxi
            &&
            $CommandObject->Description() !~ m{\Q$SearchCommand\E}smxi
            )
        {
            next COMMAND;
        }
        my $CommandName = $CommandObject->Name();

        # Group by toplevel namespace
        my ($CommandNamespace) = $CommandName =~ m/^([^:]+)::/smx;
        $CommandNamespace //= '';
        if ( $CommandNamespace ne $PreviousCommandNameSpace ) {
            $UsageText .= "<yellow>$CommandNamespace</yellow>\n";
            $PreviousCommandNameSpace = $CommandNamespace;
        }
        $UsageText .= sprintf( " <green>%-40s</green> - %s\n", $CommandName, $CommandObject->Description() );
    }

    if ( !$UsageText ) {
        $Self->Print("<yellow>No commands found.</yellow>\n");
        return $Self->ExitCodeOk();
    }

    $Self->Print($UsageText);
    return $Self->ExitCodeOk();
}

1;
