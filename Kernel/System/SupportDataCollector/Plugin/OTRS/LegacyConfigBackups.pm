# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)
package Kernel::System::SupportDataCollector::Plugin::OTRS::LegacyConfigBackups;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::Package',
    'Kernel::Output::HTML::Layout',
);

sub GetDisplayPath {
    return Translatable('OTRS');
}

sub Run {
    my $Self = shift;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $BackupsFolder = "$Home/Kernel/Config/Backups";

    my @BackupFiles;

    if ( -d $BackupsFolder ) {
        @BackupFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $BackupsFolder,
            Filter    => '*',
        );
    }

    if ( !@BackupFiles ) {
        $Self->AddResultOk(
            Label   => Translatable('Legacy Configuration Backups'),
            Value   => 0,
            Message => Translatable('No legacy configuration backup files found.'),
        );
        return $Self->GetResults();
    }

    # get package object
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    my @InvalidPackages;
    my @WrongFrameworkVersion;
    for my $Package ( $PackageObject->RepositoryList() ) {

        my $DeployCheck = $PackageObject->DeployCheck(
            Name    => $Package->{Name}->{Content},
            Version => $Package->{Version}->{Content},
        );
        if ( !$DeployCheck ) {
            push @InvalidPackages, "$Package->{Name}->{Content} $Package->{Version}->{Content}";
        }

        # get package
        my $PackageContent = $PackageObject->RepositoryGet(
            Name    => $Package->{Name}->{Content},
            Version => $Package->{Version}->{Content},
            Result  => 'SCALAR',
        );

        my %PackageStructure = $PackageObject->PackageParse(
            String => $PackageContent,
        );

        my %CheckFramework = $PackageObject->AnalyzePackageFrameworkRequirements(
            Framework => $PackageStructure{Framework},
            NoLog     => 1,
        );

        if ( !$CheckFramework{Success} ) {
            push @WrongFrameworkVersion, "$Package->{Name}->{Content} $Package->{Version}->{Content}";
        }
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    if ( @InvalidPackages || @WrongFrameworkVersion ) {
        $Self->AddResultOk(
            Label   => Translatable('Legacy Configuration Backups'),
            Value   => scalar @BackupFiles,
            Message => $LayoutObject->{LanguageObject}->Translate(
                'Legacy configuration backup files found in %s, but they might still be required by some packages.',
                $BackupsFolder
            ),
        );
        return $Self->GetResults();
    }

    $Self->AddResultWarning(
        Label   => Translatable('Legacy Configuration Backups'),
        Value   => scalar @BackupFiles,
        Message => $LayoutObject->{LanguageObject}->Translate(
            'Legacy configuration backup files are no longer needed for the installed packages, please remove them from %s.',
            $BackupsFolder
        ),
    );
    return $Self->GetResults();
}

1;
