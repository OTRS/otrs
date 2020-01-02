# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::SystemID;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return Translatable('OTRS');
}

sub Run {
    my $Self = shift;

    # Get the configured SystemID
    my $SystemID = $Kernel::OM->Get('Kernel::Config')->Get('SystemID');

    # Does the SystemID contain non-digits?
    if ( $SystemID !~ /^\d+$/ ) {
        $Self->AddResultProblem(
            Label   => Translatable('SystemID'),
            Value   => $SystemID,
            Message => Translatable('Your SystemID setting is invalid, it should only contain digits.'),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('SystemID'),
            Value => $SystemID,
        );
    }

    return $Self->GetResults();
}

1;
