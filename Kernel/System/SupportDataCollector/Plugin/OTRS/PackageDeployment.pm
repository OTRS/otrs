# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::PackageDeployment;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Package',
);

sub GetDisplayPath {
    return Translatable('OTRS');
}

sub Run {
    my $Self = shift;

    # get package object
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    my @InvalidPackages;
    for my $Package ( $PackageObject->RepositoryList() ) {
        my $DeployCheck = $PackageObject->DeployCheck(
            Name    => $Package->{Name}->{Content},
            Version => $Package->{Version}->{Content},
        );
        if ( !$DeployCheck ) {
            push @InvalidPackages, "$Package->{Name}->{Content} $Package->{Version}->{Content}";
        }
    }

    if (@InvalidPackages) {
        if ( $Kernel::OM->Get('Kernel::Config')->Get('Package::AllowLocalModifications') ) {
            $Self->AddResultInformation(
                Label   => Translatable('Package Installation Status'),
                Value   => join( ', ', @InvalidPackages ),
                Message => Translatable('Some packages have locally modified files.'),
            );
        }
        else {
            $Self->AddResultProblem(
                Label   => Translatable('Package Installation Status'),
                Value   => join( ', ', @InvalidPackages ),
                Message => Translatable('Some packages are not correctly installed.'),
            );
        }
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Package Installation Status'),
            Value => '',
        );
    }

    return $Self->GetResults();
}

1;
