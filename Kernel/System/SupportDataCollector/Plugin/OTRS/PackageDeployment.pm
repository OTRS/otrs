# --
# Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm - system data collector plugin
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::PackageDeployment;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::System::Package;

sub GetDisplayPath {
    return 'OTRS';
}

sub Run {
    my $Self = shift;

    my @InvalidPackages;

    my $PackageObject = Kernel::System::Package->new( %{$Self} );

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
        $Self->AddResultProblem(
            Label   => 'Package Installation Status',
            Value   => join( ', ', @InvalidPackages ),
            Message => 'Some packages are not correctly installed.',
        );
    }
    else {
        $Self->AddResultOk(
            Label => 'Package Installation Status',
            Value => '',
        );
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
