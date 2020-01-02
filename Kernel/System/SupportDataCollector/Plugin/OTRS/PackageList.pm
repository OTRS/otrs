# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::PackageList;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CSV',
    'Kernel::System::Package',
);

sub GetDisplayPath {
    return Translatable('OTRS') . '/' . Translatable('Package List');
}

sub Run {
    my $Self = shift;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # get needed objects
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    my $CSVObject     = $Kernel::OM->Get('Kernel::System::CSV');

    my @PackageList = $PackageObject->RepositoryList( Result => 'Short' );

    for my $Package (@PackageList) {

        my @PackageData = (
            [
                $Package->{Name},
                $Package->{Version},
                $Package->{MD5sum},
                $Package->{Vendor},
            ],
        );

        # use '-' (minus) as separator otherwise the line will not wrap and will not be totally
        #   visible
        my $Message = $CSVObject->Array2CSV(
            Data      => \@PackageData,
            Separator => '-',
            Quote     => "'",
        );

        # remove the new line character, otherwise it does not play good with output translations
        chomp $Message;

        $Self->AddResultInformation(
            Identifier => $Package->{Name},
            Label      => $Package->{Name},
            Value      => $Package->{Version},
            Message    => $Message,
        );
    }

    # if no packages where found we should not add any result, otherwise the table will be
    #   have that row instead of output just the label and a message of not packages found

    return $Self->GetResults();
}

1;
