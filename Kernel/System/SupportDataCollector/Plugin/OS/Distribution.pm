# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OS::Distribution;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Environment',
);

sub GetDisplayPath {
    return Translatable('Operating System');
}

sub Run {
    my $Self = shift;

    my %OSInfo = $Kernel::OM->Get('Kernel::System::Environment')->OSInfoGet();

    # if OSname starts with Unknown, test was not successful
    if ( $OSInfo{OSName} =~ /\A Unknown /xms ) {
        $Self->AddResultProblem(
            Label   => Translatable('Distribution'),
            Value   => $OSInfo{OSName},
            Message => Translatable('Could not determine distribution.')
        );
    }
    else {
        $Self->AddResultInformation(
            Label => Translatable('Distribution'),
            Value => $OSInfo{OSName},
        );
    }

    return $Self->GetResults();
}

1;
