# --
# Kernel/System/Console/Command/Maint/SupportBundle/Generate.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::SupportBundle::Generate;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::SupportBundleGenerator',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate a support bundle for this system.');
    $Self->AddOption(
        Name        => 'target-directory',
        Description => "Specify a custom output directory.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $TargetDirectory = $Self->GetOption('target-directory');
    if ( $TargetDirectory && !-d $TargetDirectory ) {
        die "Directory $TargetDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Generating support bundle...</yellow>\n");

    my $Response = $Kernel::OM->Get('Kernel::System::SupportBundleGenerator')->Generate();

    if ( !$Response->{Success} ) {
        $Self->PrintError("Could not generate support bundle.");
        return $Self->ExitCodeError();
    }

    my $FileData = $Response->{Data};

    my $OutputDir = $Self->GetOption('target-directory') || $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $FileLocation = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => $OutputDir . '/' . $FileData->{Filename},
        Content    => $FileData->{Filecontent},
        Mode       => 'binmode',
        Permission => '644',
    );

    if ( !$FileLocation ) {
        $Self->PrintError("Support bundle could not be saved.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Support Bundle saved to:</green> <yellow>$FileLocation</yellow>\n");

    return $Self->ExitCodeOk();
}

# sub PostRun {
#     my ( $Self, %Param ) = @_;
#
#     # This will be called after Run() (even in case of exceptions). Perform any cleanups here.
#
#     return;
# }

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
