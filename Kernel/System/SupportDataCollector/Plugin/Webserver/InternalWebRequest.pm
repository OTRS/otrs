# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Webserver::InternalWebRequest;

use strict;
use warnings;

use Kernel::System::ObjectManager;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = ();

sub GetDisplayPath {
    return Translatable('Webserver');
}

sub Run {
    my $Self = shift;

    # Skip the plugin, if the support data collection is running in a web request.
    return $Self->GetResults() if $ENV{GATEWAY_INTERFACE};

    $Self->AddResultWarning(
        Label   => Translatable('Support Data Collection'),
        Value   => 0,
        Message => Translatable('Support data could not be collected from the web server.'),
    );

    return $Self->GetResults();
}

1;
