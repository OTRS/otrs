# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::FQDN;

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

    my $FQDN = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    # Do we have set our FQDN?
    if ( $FQDN eq 'yourhost.example.com' ) {
        $Self->AddResultProblem(
            Label   => Translatable('FQDN (domain name)'),
            Value   => $FQDN,
            Message => Translatable('Please configure your FQDN setting.'),
        );
    }

    # FQDN syntax check.
    elsif ( $FQDN !~ /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,12}$/ ) {
        $Self->AddResultProblem(
            Label   => Translatable('Domain Name'),
            Value   => $FQDN,
            Message => Translatable('Your FQDN setting is invalid.'),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Domain Name'),
            Value => $FQDN,
        );
    }

    return $Self->GetResults();
}

1;
