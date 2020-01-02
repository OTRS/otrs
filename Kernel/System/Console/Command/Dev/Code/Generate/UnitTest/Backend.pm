# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Dev::Code::Generate::UnitTest::Backend;
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)

use strict;
use warnings;

use File::Path     ();
use File::Basename ();

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::Output::HTML::Layout',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate a test skeleton.');
    $Self->AddOption(
        Name => 'module-directory',
        Description =>
            "Specify the directory containing the module where the new test should be created (otherwise the OTRS home directory will be used).",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'target-path',
        Description => "Specify the path to the new test (e.g. MyModule/SubTest).",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );
    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $ModuleDirectory = $Self->GetOption('module-directory');
    if ( $ModuleDirectory && !-d $ModuleDirectory ) {
        die "Directory $ModuleDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $TargetHome      = $Home;
    my $ModuleDirectory = $Self->GetOption('module-directory');
    if ($ModuleDirectory) {
        $TargetHome = $ModuleDirectory;
    }

    # Keep comment lines in files also in the generated output.
    local $ENV{TEMPLATE_KEEP_COMMENTS} = 1;

    my $TargetPath = $Self->GetArgument('target-path');

    # create Test module file
    my $SkeletonFile = __FILE__;
    $SkeletonFile =~ s{Backend\.pm$}{Backend/Backend.t.skel}xms;

    my $SkeletonTemplate = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $SkeletonFile,
    );
    if ( !$SkeletonTemplate || !${$SkeletonTemplate} ) {
        $Self->PrintError("Could not read $SkeletonFile.");
        return $Self->ExitCodeError();
    }

    my $Skeleton = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        Template => ${$SkeletonTemplate},
    );

    my $TargetLocation  = "$TargetHome/scripts/test/$TargetPath.t";
    my $TargetDirectory = File::Basename::dirname($TargetLocation);

    if ( !-d $TargetDirectory ) {
        File::Path::make_path($TargetDirectory);
    }

    if ( -f $TargetLocation ) {
        $Self->PrintError("$TargetLocation already exists.");
        return $Self->ExitCodeError();
    }

    my $Success = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $TargetLocation,
        Content  => \$Skeleton,
    );

    if ( !$Success ) {
        $Self->PrintError("Could not generate $TargetLocation.\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Generated:</green> <yellow>$TargetLocation</yellow>\n");
    return $Self->ExitCodeOk();

}

1;
